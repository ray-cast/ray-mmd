float2 ViewportSize : VIEWPORTPIXELSIZE;

static float2 ViewportOffset  = 0.5 / ViewportSize;
static float2 ViewportOffset2 = 1.0 / ViewportSize;
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

shared texture2D DummyScreenTex : RenderColorTarget<
	float2 ViewportRatio = {1.0, 1.0};
	int Miplevels = 0;
	string Format= "A2B10G10R10";
>;

texture ScreenMap : MATERIALTEXTURE;
sampler ScreenMapSamp = sampler_state
{
	texture = <ScreenMap>;
	MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = NONE;
	ADDRESSU = CLAMP; ADDRESSV = CLAMP;
};

void DummyScreenVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord : TEXCOORD0,
	out float4 oPosition : POSITION)
{
	oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy;
	oPosition = Position;
}

float4 DummyScreenPS(in float2 coord : TEXCOORD0) : COLOR 
{
	return tex2Dlod(ScreenMapSamp, float4(coord, 0, 0));
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "standard";
> = 0.8;

technique MainTec0 <
	string Script = 
	"RenderColorTarget=DummyScreenTex;"
	"Pass=CopyDummyScreenTex;"
;> {
	pass CopyDummyScreenTex < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 DummyScreenVS();
		PixelShader  = compile ps_3_0 DummyScreenPS();
	}
}