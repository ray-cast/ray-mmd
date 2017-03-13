#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"

float AcsTr : CONTROLOBJECT<string name = "(self)"; string item = "Tr";>;

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "A2R10G10B10";
>;
texture ScnMap2 : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "A2R10G10B10";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = POINT;   MagFilter = POINT;   MipFilter = NONE;
	AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ScnSamp2 = sampler_state {
	texture = <ScnMap2>;
	MinFilter = POINT;   MagFilter = POINT;   MipFilter = NONE;
	AddressU  = CLAMP;  AddressV = CLAMP;
};
texture DepthMap : OFFSCREENRENDERTARGET<
	string Description = "Depth Map";
	float2 ViewPortRatio = {1.0, 1.0};
	string Format = "R32F";
	float4 ClearColor = { 1, 0, 0, 0 };
	float ClearDepth = 1.0;
	string DefaultEffect =
		"self = hide;"
		"*fog.pmx=hide;"
		"*controller.pmx=hide;"
		"*editor*.pmx=hide;"
		"*.pmx=Depth.fx;"
		"*.pmd=Depth.fx;"
		"*.x=hide;";
>;
sampler DepthMapSamp = sampler_state {
	texture = <DepthMap>;
	MinFilter = POINT; MagFilter = POINT; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};

float linearizeDepth(float2 uv)
{
	return tex2Dlod(DepthMapSamp, float4(uv, 0, 0)).r;
}

void BilateralBlurVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float2 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord.xy + ViewportOffset.xy;
	oPosition = Position;
}

float4 BilateralBlurXPS(
	in float2 coord   : TEXCOORD0,
	in float3 viewdir : TEXCOORD1,
	uniform sampler source) : COLOR
{
	float center_d = linearizeDepth(coord);

	float total_w = 1.0f;
	float3 total_c = pow(tex2Dlod(source, float4(coord, 0, 0)).rgb, 2.2);

	float2 offset = float2(ViewportOffset2.x, 0.0);
	float2 offset1 = coord + offset;
	float2 offset2 = coord - offset;

	[unroll]
	for (int r = 1; r <= 6; r++)
	{
		float depth1 = linearizeDepth(offset1);
		float depth2 = linearizeDepth(offset2);

		float bilateralWeight1 = BilateralWeight(r, depth1, center_d, 6, 4);
		float bilateralWeight2 = BilateralWeight(r, depth2, center_d, 6, 4);

		total_c += pow(tex2Dlod(source, float4(offset1, 0, 0)).rgb, 2.2) * bilateralWeight1;
		total_c += pow(tex2Dlod(source, float4(offset2, 0, 0)).rgb, 2.2) * bilateralWeight2;

		total_w += bilateralWeight1;
		total_w += bilateralWeight2;

		offset1 += offset;
		offset2 -= offset;
	}

	total_c /= total_w;

	return float4(total_c, 0);
}

float4 BilateralBlurYPS(
	in float2 coord   : TEXCOORD0,
	in float3 viewdir : TEXCOORD1,
	uniform sampler source,
	uniform sampler original) : COLOR
{
	float center_d = linearizeDepth(coord);

	float total_w = 1.0f;
	float3 total_c = tex2Dlod(source, float4(coord, 0, 0)).rgb;

	float2 offset = float2(0.0, ViewportOffset2.y);
	float2 offset1 = coord + offset;
	float2 offset2 = coord - offset;

	[unroll]
	for (int r = 1; r <= 6; r++)
	{
		float depth1 = linearizeDepth(offset1);
		float depth2 = linearizeDepth(offset2);

		float bilateralWeight1 = BilateralWeight(r, depth1, center_d, 6, 4);
		float bilateralWeight2 = BilateralWeight(r, depth2, center_d, 6, 4);

		total_c += tex2Dlod(source, float4(offset1, 0, 0)).rgb * bilateralWeight1;
		total_c += tex2Dlod(source, float4(offset2, 0, 0)).rgb * bilateralWeight2;

		total_w += bilateralWeight1;
		total_w += bilateralWeight2;

		offset1 += offset;
		offset2 -= offset;
	}

	float coeff = (1 - exp(-center_d / (500 * AcsTr + 1e-4)));
	total_c /= total_w;
	total_c = lerp(pow(tex2Dlod(original, float4(coord, 0, 0)).rgb, 2.2), total_c, coeff);
	total_c = pow(total_c, 1.0 / 2.2);

	return float4(total_c, 1);
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique MainTech <
	string Script = 
	"RenderColorTarget0=;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"

	"RenderColorTarget0=ScnMap;"
	"Clear=Color;"
	"Clear=Depth;"
	"RenderDepthStencilTarget=;"
	"ScriptExternal=Color;"

	"RenderColorTarget=ScnMap2; Pass=BilateralBlurX;"
	"RenderColorTarget=;		Pass=BilateralBlurY;"
;>{
	pass BilateralBlurX<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 BilateralBlurVS();
		PixelShader  = compile ps_3_0 BilateralBlurXPS(ScnSamp);
	}
	pass BilateralBlurY<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 BilateralBlurVS();
		PixelShader  = compile ps_3_0 BilateralBlurYPS(ScnSamp2, ScnSamp);
	}
}