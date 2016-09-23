#include "../ray.conf"
#include "../shader/math.fx"
#include "../shader/common.fx"
#include "../shader/shadowcommon.fx"

float3 LightDirection : DIRECTION < string Object = "Light"; >;
static float4x4 matLightView = CreateLightViewMatrix(normalize(LightDirection));
static float4x4 matLightProjectionToCameraView = mul(matViewInverse, matLightView);
static float4x4 matLightWorldViewProject = mul(matLightView, matLightProject);
static float4x4 lightParam = CreateLightProjParameters(matLightProjectionToCameraView);

texture DiffuseMap: MATERIALTEXTURE;
sampler DiffuseSamp = sampler_state
{
    texture = <DiffuseMap>;
    MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = POINT;
    ADDRESSU  = WRAP; ADDRESSV  = WRAP;
};

void CascadeShadowMapVS(
    in float4 Position : POSITION,
    in float2 Texcoord : TEXCOORD0,
    out float4 oTexcoord0 : TEXCOORD0,
    out float4 oTexcoord1 : TEXCOORD1,
    out float4 oPosition : POSITION,
    uniform int3 offset)
{
    oPosition = mul(Position, matLightWorldViewProject);
    oPosition.xy = oPosition.xy * lightParam[offset.z].xy + lightParam[offset.z].zw;
    oPosition.xy = oPosition.xy * 0.5 + (offset.xy * 0.5f);
    oPosition.z = max(oPosition.z, LightZMin / LightZMax);
    
    oTexcoord1 = oPosition;
    oTexcoord0 = float4(Texcoord, offset.xy);
}

float4 CascadeShadowMapPS(float4 coord0 : TEXCOORD0, float4 coord1 : TEXCOORD1, uniform bool useTexture) : COLOR
{
    float2 clipUV = (coord1.xy - SHADOW_MAP_OFFSET) * coord0.zw;
    clip(clipUV.x);
    clip(clipUV.y);
    clip(!opadd - 0.001f);

    float alpha = MaterialDiffuse.a;
    alpha *= (abs(MaterialDiffuse.a - 0.98) >= 0.01);
    if ( useTexture ) alpha *= tex2D(DiffuseSamp, coord0.xy).a;
    clip(alpha - CasterAlphaThreshold);

    return coord1.z;
}

#define PSSM_TEC(name, mmdpass, tex) \
    technique name < string MMDPass = mmdpass; bool UseTexture = tex; \
    > { \
        pass CascadeShadowMap0 { \
            AlphaBlendEnable = false; AlphaTestEnable = true; \
            VertexShader = compile vs_3_0 CascadeShadowMapVS(int3(-1, 1, 0)); \
            PixelShader  = compile ps_3_0 CascadeShadowMapPS(tex); \
        } \
        pass CascadeShadowMap1 { \
            AlphaBlendEnable = false; AlphaTestEnable = true; \
            VertexShader = compile vs_3_0 CascadeShadowMapVS(int3( 1, 1, 1)); \
            PixelShader  = compile ps_3_0 CascadeShadowMapPS(tex); \
        } \
        pass CascadeShadowMap2 { \
            AlphaBlendEnable = false; AlphaTestEnable = true; \
            VertexShader = compile vs_3_0 CascadeShadowMapVS(int3(-1,-1, 2)); \
            PixelShader  = compile ps_3_0 CascadeShadowMapPS(tex); \
        } \
        pass CascadeShadowMap3 { \
            AlphaBlendEnable = false; AlphaTestEnable = true; \
            VertexShader = compile vs_3_0 CascadeShadowMapVS(int3( 1,-1, 3)); \
            PixelShader  = compile ps_3_0 CascadeShadowMapPS(tex); \
        } \
    }

PSSM_TEC(DepthTecBS2, "object_ss", false)
PSSM_TEC(DepthTecBS3, "object_ss", true)

technique DepthTec0 < string MMDPass = "object"; >{}
technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}