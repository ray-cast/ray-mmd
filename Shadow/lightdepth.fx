#include "shadowcommon.fxsub"

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

struct DrawObject_OUTPUT {
    float4 Pos      : POSITION;     // 射影変換座標
    float2 Tex      : TEXCOORD0;    // テクスチャ
    float2 Tex2     : TEXCOORD1;
    float4 PPos     : TEXCOORD2;
};

DrawObject_OUTPUT DrawObject_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0, uniform int cascadeIndex)
{
    DrawObject_OUTPUT Out;
    Out.Pos = mul(Pos, matLightWorldViewProject);

    if (cascadeIndex == 0)
    {
        Out.Tex2 = float2(-1, 1);
    }
    else if (cascadeIndex == 1)
    {
        Out.Tex2 = float2( 1, 1);
    }
    else if (cascadeIndex == 2)
    {
        Out.Tex2 = float2(-1,-1);
    }
    else
    {
        Out.Tex2 = float2( 1,-1);
    }

    Out.Pos.xy = Out.Pos.xy * lightParam[cascadeIndex].xy + lightParam[cascadeIndex].zw;
    Out.Pos.xy = Out.Pos.xy * 0.5 + (Out.Tex2 * 0.5f);

    // depth clamping
    Out.Pos.z = max(Out.Pos.z, LightZMin / LightZMax);

    Out.PPos = Out.Pos;
    Out.Tex = Tex;

    return Out;
}

float4 DrawObject_PS(DrawObject_OUTPUT IN, uniform int cascadeIndex, uniform bool useTexture) : COLOR
{
    float2 clipUV = (IN.PPos.xy - SHADOW_MAP_OFFSET) * IN.Tex2;
    clip(clipUV.x);
    clip(clipUV.y);

    clip(!opadd - 0.001f);

    float alpha = MaterialDiffuse.a;
    alpha *= (abs(MaterialDiffuse.a - 0.98) >= 0.01); // ??
    if ( useTexture ) alpha *= tex2D( ObjTexSampler, IN.Tex.xy ).a;
    clip(alpha - CasterAlphaThreshold);

    float z = IN.PPos.z;
    return z;
}

#define OBJECT_TEC(name, mmdpass, tex) \
    technique name < string MMDPass = mmdpass; bool UseTexture = tex; \
    > { \
        pass DrawObject0 { \
            AlphaBlendEnable = FALSE;   AlphaTestEnable = TRUE; \
            VertexShader = compile vs_3_0 DrawObject_VS(0); \
            PixelShader  = compile ps_3_0 DrawObject_PS(0, tex); \
        } \
        pass DrawObject1 { \
            AlphaBlendEnable = FALSE;   AlphaTestEnable = TRUE; \
            VertexShader = compile vs_3_0 DrawObject_VS(1); \
            PixelShader  = compile ps_3_0 DrawObject_PS(1, tex); \
        } \
        pass DrawObject2 { \
            AlphaBlendEnable = FALSE;   AlphaTestEnable = TRUE; \
            VertexShader = compile vs_3_0 DrawObject_VS(2); \
            PixelShader  = compile ps_3_0 DrawObject_PS(2, tex); \
        } \
        pass DrawObject3 { \
            AlphaBlendEnable = FALSE;   AlphaTestEnable = TRUE; \
            VertexShader = compile vs_3_0 DrawObject_VS(3); \
            PixelShader  = compile ps_3_0 DrawObject_PS(3, tex); \
        } \
    }

OBJECT_TEC(DepthTecBS2, "object_ss", false)
OBJECT_TEC(DepthTecBS3, "object_ss", true)

technique DepthTec0 < string MMDPass = "object"; >{}
technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}