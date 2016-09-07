#include "../../ray.conf"
#include "../../shader/math.fx"
#include "../../shader/common.fx"
#include "../../shader/gbuffer.fx"
#include "../../shader/gbuffer_sampler.fx"
#include "../../shader/lighting.fx"

shared texture2D DummyScreenTex : RenderColorTarget
<
    float2 ViewPortRatio = {1.0, 1.0};
    bool AntiAlias = false;
    int Miplevels = 1;
    string Format= "A8B8G8R8";
>;

sampler SamplerDummyScreenTex = sampler_state {
    texture = <DummyScreenTex>;
    ADDRESSU = WRAP;
    ADDRESSV = WRAP;
    FILTER = POINT;
};

texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state
{
    texture = <ObjectTexture>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

struct VS_OUTPUT
{
    float4 Pos        : POSITION;
    float2 Tex        : TEXCOORD1;
    float3 Normal     : TEXCOORD2;
    float3 Eye        : TEXCOORD3;
    float4 Color      : COLOR0;
    float3 Specular   : COLOR1;
};

VS_OUTPUT VS_DummyScreenTexCopy( float4 Pos : POSITION, float2 Tex : TEXCOORD0 ) {
    VS_OUTPUT Out = (VS_OUTPUT)0; 
    
    Out.Pos = Pos;
    Out.Tex = Tex + ViewportOffset;
    
    return Out;
}

float4 PS_DummyScreenTexCopy( VS_OUTPUT In) : COLOR {

    return tex2D(ObjTexSampler, In.Tex);
}

technique MainTec0 <
    string MMDPass = "object";
    string Script = 
    "RenderColorTarget=DummyScreenTex;"
    "Pass=CopyDummyScreenTex;"
    ;
> {
    pass CopyDummyScreenTex < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
	    ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 VS_DummyScreenTexCopy();
        PixelShader  = compile ps_3_0 PS_DummyScreenTexCopy();
    }
}
