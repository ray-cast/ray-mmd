float2 ViewportSize : VIEWPORTPIXELSIZE;

static float2 ViewportOffset  = 0.5 / ViewportSize;
static float2 ViewportOffset2 = 1.0 / ViewportSize;
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

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
	string Format = "R16F";
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
	MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};

void ScreenSpaceQuadVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float2 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord + ViewportOffset.xy;
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
	"RenderColorTarget=ScnMap;"
	"RenderDepthStencilTarget=;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"
	"Clear=Color;"
	"Clear=Depth;"
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