#include "../../ray.conf"
#include "../../shader/common.fxsub"
#include "../../shader/math.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"

float showAlbedo : CONTROLOBJECT<string name="(self)"; string item = "Albedo";>;
float showNormal : CONTROLOBJECT<string name="(self)"; string item = "Normal";>;
float showSpecular : CONTROLOBJECT<string name="(self)"; string item = "Specular";>;
float showSmoothness : CONTROLOBJECT<string name="(self)"; string item = "Smoothness";>;
float showVisibility : CONTROLOBJECT<string name="(self)"; string item = "Visibility";>;
float showCustomID : CONTROLOBJECT<string name="(self)"; string item = "CustomID";>;
float showCustomDataA : CONTROLOBJECT<string name="(self)"; string item = "CustomDataA";>;
float showCustomDataB : CONTROLOBJECT<string name="(self)"; string item = "CustomDataB";>;
float showDepth : CONTROLOBJECT<string name="(self)"; string item = "Depth";>;

float showAlpha : CONTROLOBJECT<string name="(self)"; string item = "Alpha";>;
float showAlbedoAlpha : CONTROLOBJECT<string name="(self)"; string item = "AlbedoAlpha";>;
float showNormalAlpha : CONTROLOBJECT<string name="(self)"; string item = "NormalAlpha";>;
float showSpecularAlpha : CONTROLOBJECT<string name="(self)"; string item = "SpecularAlpha";>;
float showSmoothnessAlpha : CONTROLOBJECT<string name="(self)"; string item = "SmoothnessAlpha";>;
float showVisibilityAlpha : CONTROLOBJECT<string name="(self)"; string item = "VisibilityAlpha";>;
float showCustomIDAlpha : CONTROLOBJECT<string name="(self)"; string item = "CustomIDAlpha";>;
float showCustomDataAlphaA : CONTROLOBJECT<string name="(self)"; string item = "CustomDataAlphaA";>;
float showCustomDataAlphaB : CONTROLOBJECT<string name="(self)"; string item = "CustomDataAlphaB";>;
float showDepthAlpha : CONTROLOBJECT<string name="(self)"; string item = "DepthAlpha";>;

float showSSAO : CONTROLOBJECT<string name="(self)"; string item = "SSAO";>;
float showSSDO : CONTROLOBJECT<string name="(self)"; string item = "SSDO";>;
float showSSR : CONTROLOBJECT<string name="(self)"; string item = "SSR";>;
float showPSSM : CONTROLOBJECT<string name="(self)"; string item = "PSSM";>;
float showOutline : CONTROLOBJECT<string name="(self)"; string item = "Outline";>;

texture2D ScnMap : RENDERCOLORTARGET<
	float2 ViewPortRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "X8R8G8B8";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};

#if SSDO_QUALITY > 0
shared texture SSDOMap : RENDERCOLORTARGET;
sampler SSDOMapSamp = sampler_state {
	texture = <SSDOMap>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
#endif

#if SSR_QUALITY > 0
shared texture SSRayTracingMap: RENDERCOLORTARGET;
sampler SSRayTracingSamp = sampler_state {
	texture = <SSRayTracingMap>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
#endif

#if SUN_SHADOW_QUALITY && SUN_LIGHT_ENABLE
shared texture PSSM1 : OFFSCREENRENDERTARGET;
sampler PSSM1Samp = sampler_state {
	texture = <PSSM1>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
shared texture PSSM2 : OFFSCREENRENDERTARGET;
sampler PSSM2Samp = sampler_state {
	texture = <PSSM2>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
shared texture PSSM3 : OFFSCREENRENDERTARGET;
sampler PSSM3Samp = sampler_state {
	texture = <PSSM3>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
shared texture PSSM4 : OFFSCREENRENDERTARGET;
sampler PSSM4Samp = sampler_state {
	texture = <PSSM4>;
	MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
#endif
#if OUTLINE_QUALITY
shared texture OutlineMap : OFFSCREENRENDERTARGET;
sampler OutlineMapSamp = sampler_state {
	texture = <OutlineMap>;
	MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
#endif

void DebugControllerVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord : TEXCOORD0,
	out float4 oPosition : POSITION)
{
	oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy;
	oPosition = Position;
}

float4 DebugControllerPS(in float2 coord : TEXCOORD0) : COLOR
{
	float4 MRT1 = tex2Dlod(Gbuffer1Map, float4(coord, 0, 0));
	float4 MRT2 = tex2Dlod(Gbuffer2Map, float4(coord, 0, 0));
	float4 MRT3 = tex2Dlod(Gbuffer3Map, float4(coord, 0, 0));
	float4 MRT4 = tex2Dlod(Gbuffer4Map, float4(coord, 0, 0));

	MaterialParam material;
	DecodeGbuffer(MRT1, MRT2, MRT3, MRT4, material);

	float4 MRT5 = tex2Dlod(Gbuffer5Map, float4(coord, 0, 0));
	float4 MRT6 = tex2Dlod(Gbuffer6Map, float4(coord, 0, 0));
	float4 MRT7 = tex2Dlod(Gbuffer7Map, float4(coord, 0, 0));
	float4 MRT8 = tex2Dlod(Gbuffer8Map, float4(coord, 0, 0));

	MaterialParam materialAlpha;
	DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);

	float showTotal = showAlbedo + showNormal + showSpecular + showSmoothness + showVisibility + showCustomID + showCustomDataB + showCustomDataA;
	showTotal += showAlpha + showAlbedoAlpha + showSpecularAlpha + showNormalAlpha + showSmoothnessAlpha + showVisibilityAlpha + showCustomIDAlpha + showCustomDataAlphaB + showCustomDataAlphaA;
	showTotal += showDepth + showDepthAlpha + showSSAO + showSSDO + showSSR + showPSSM + showOutline;

	float3 result = srgb2linear_fast(tex2Dlod(ScnSamp, float4(coord, 0, 0)).rgb) * !any(showTotal);
	result += material.albedo * showAlbedo;
	result += (mul(material.normal, (float3x3)matViewInverse).xyz * 0.5 + 0.5) * showNormal;
	result += material.specular * showSpecular;
	result += material.smoothness * showSmoothness;
	result += material.customDataA * showCustomDataA;
	result += material.customDataB * showCustomDataB;
	result += material.visibility * showVisibility;

	result += materialAlpha.albedo * showAlbedoAlpha;
	result += (mul(materialAlpha.normal, (float3x3)matViewInverse).xyz * 0.5 + 0.5) * showNormalAlpha;
	result += materialAlpha.specular * showSpecularAlpha;
	result += materialAlpha.smoothness * showSmoothnessAlpha;
	result += materialAlpha.customDataA * showCustomDataAlphaA;
	result += materialAlpha.customDataB * showCustomDataAlphaB;
	result += materialAlpha.visibility * showVisibilityAlpha;

	#if OUTLINE_QUALITY
		float4 edge = tex2Dlod(OutlineMapSamp, float4(coord, 0, 0));
		result += lerp(float3(1, 1, 1), edge.rgb, any(edge.a))  * showOutline;
	#endif

	result = linear2srgb(result);

	result += materialAlpha.alpha * showAlpha;
	result += pow(saturate(material.linearDepth / 200), 0.5) * showDepth;
	result += pow(saturate(materialAlpha.linearDepth / 200), 0.5) * showDepthAlpha;

	#if SSDO_QUALITY > 0
		float4 ssao = tex2Dlod(SSDOMapSamp, float4(coord, 0, 0));
		result += ssao.w * showSSAO;
		result += ssao.xyz * showSSDO;
	#endif

	#if SSR_QUALITY > 0
		result += tex2Dlod(SSRayTracingSamp, float4(coord, 0, 0)).rgb * showSSR;
	#endif

	#if SUN_SHADOW_QUALITY && SUN_LIGHT_ENABLE
		float depth1 = tex2Dlod(PSSM1Samp, float4(coord * 2.0, 0, 0)).r;		
		float depth2 = tex2Dlod(PSSM2Samp, float4(coord * 2.0 - float2(1.0, 0.0), 0, 0)).r;		
		float depth3 = tex2Dlod(PSSM3Samp, float4(coord * 2.0 - float2(0.0, 1.0), 0, 0)).r;		
		float depth4 = tex2Dlod(PSSM4Samp, float4(coord * 2.0 - float2(1.0, 1.0), 0, 0)).r;		
		result += pow(saturate((depth1 + depth2 + depth3 + depth4) / 1500), 2) * showPSSM;
	#endif

	if (material.lightModel == SHADINGMODELID_SKIN)
		result += float3(1,0,0) * showCustomID;
	if (material.lightModel == SHADINGMODELID_SUBSURFACE)
		result += float3(0,1,0) * showCustomID;
	if (material.lightModel == SHADINGMODELID_CLOTH)
		result += float3(0,0,1) * showCustomID;
	if (material.lightModel == SHADINGMODELID_EMISSIVE)
		result += float3(1,1,1) * showCustomID;
	if (material.lightModel == SHADINGMODELID_CLEAR_COAT)
		result += float3(1,0,1) * showCustomID;
	if (material.lightModel == SHADINGMODELID_GLASS)
		result += float3(0.2,0.3,0.5) * showCustomID;
	if (material.lightModel == SHADINGMODELID_ANISOTROPY)
		result += float3(1.0,0.5,1.0) * showCustomID;
	if (material.lightModel == SHADINGMODELID_CEL)
		result += float3(0.0,0.5,1.0) * showCustomID;
	if (material.lightModel == SHADINGMODELID_TONEBASED)
		result += float3(0.5,0.5,1.0) * showCustomID;

	if (materialAlpha.lightModel == SHADINGMODELID_SKIN)
		result += float3(1,0,0) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_SUBSURFACE)
		result += float3(0,1,0) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_CLOTH)
		result += float3(0,0,1) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_EMISSIVE)
		result += float3(1,1,1) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_CLEAR_COAT)
		result += float3(1,0,1) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_GLASS)
		result += float3(0.2,0.3,0.5) * showCustomIDAlpha;
	if (materialAlpha.lightModel == SHADINGMODELID_ANISOTROPY)
		result += float3(1.0,0.5,1.0) * showCustomIDAlpha;
	if (material.lightModel == SHADINGMODELID_CEL)
		result += float3(0.0,0.5,1.0) * showCustomIDAlpha;
	if (material.lightModel == SHADINGMODELID_TONEBASED)
		result += float3(0.5,0.5,1.0) * showCustomIDAlpha;

	return float4(result, 1);
}

float Script : STANDARDSGLOBAL<
	string ScriptOutput = "color";
	string ScriptClass = "scene";
	string ScriptOrder = "postprocess";
> = 0.8;

technique DebugController <
	string Script = 
	"RenderColorTarget=ScnMap;"
	"RenderDepthStencilTarget=;"
	"ScriptExternal=Color;"

	"RenderColorTarget=;"
	"RenderDepthStencilTarget=;"
	"Pass=DebugController;"
;> {
	pass DebugController<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = False; ZWriteEnable = False;
		VertexShader = compile vs_3_0 DebugControllerVS();
		PixelShader = compile ps_3_0 DebugControllerPS();
	}
}