#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"

#define POST_STEREOSCOPIC_MODE 5
#include "stereoscopic.fxsub"

float AcsTr : CONTROLOBJECT<string name = "(self)"; string item = "Tr";>;

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "A2R10G10B10";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = POINT; MagFilter = POINT; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
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

void ScreenSpaceQuadVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float2 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord.xy + ViewportOffset.xy;
	oPosition = Position;
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
	"RenderColorTarget=;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"

	"RenderColorTarget=ScnMap;"
	"Clear=Color;"
	"Clear=Depth;"
	"RenderDepthStencilTarget=;"
	"ScriptExternal=Color;"

	"RenderColorTarget=;"
	"Pass=Stereoscopic;"
;>{
	pass Stereoscopic<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 StereoscopicPS(ScnSamp, DepthMapSamp);
	}
}