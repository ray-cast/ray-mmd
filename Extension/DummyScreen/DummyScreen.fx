#include "../../shader/common.fxsub"

shared texture2D DummyScreenTex : RenderColorTarget
<
    float2 ViewPortRatio = {1.0, 1.0};
    bool AntiAlias = false;
    int Miplevels = 1;
    string Format= "A8B8G8R8";
>;

texture DiffuseMap : MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
    texture = <DiffuseMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

void DummyScreenVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float4 oPosition  : POSITION)
{
    oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy;
    oPosition = Position;
}

float4 DummyScreenPS(in float2 coord : TEXCOORD0) : COLOR 
{
    return tex2D(DiffuseMapSamp, coord);
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
	    ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DummyScreenVS();
        PixelShader  = compile ps_3_0 DummyScreenPS();
    }
}
