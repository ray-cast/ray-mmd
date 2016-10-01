#include "../ray.conf"
#include "../shader/math.fx"
#include "../shader/common.fx"

void DrawObjectVS(
    in float4 Position : POSITION,
    in float3 Normal : NORMAL, 
    out float4 oTexcoord : TEXCOORD0,
    out float4 oNormal : TEXCOORD1,
    out float4 oPosition : POSITION)
{
    oPosition = mul(Position, matViewProject);
    oTexcoord = float4(mul(Normal, (float3x3)matView), 100000);
}

float4 DrawObjectPS(in float4 coord : TEXCOORD0) : COLOR
{
    return coord;
}

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass; \
    string Script = \
        "RenderColorTarget0=;" \
        "Pass=DrawObject;" \
    ;>{ \
        pass DrawObject { \
            AlphaTestEnable = false; AlphaBlendEnable = false; \
            VertexShader = compile vs_3_0 DrawObjectVS(); \
            PixelShader  = compile ps_3_0 DrawObjectPS(); \
        } \
    }
    
OBJECT_TEC(MainTec2, "object")
OBJECT_TEC(MainTec3, "object")    
OBJECT_TEC(MainTecBS2, "object_ss")
OBJECT_TEC(MainTecBS3, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}