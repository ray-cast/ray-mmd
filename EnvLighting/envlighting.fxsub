#include "../ray.conf"
#include "../shader/math.fx"
#include "../shader/common.fx"
#include "../shader/gbuffer.fx"
#include "../shader/gbuffer_sampler.fx"
#include "../shader/lighting.fx"

texture IBLDiffuseTexture: MATERIALTOONTEXTURE;
sampler IBLDiffuseSampler = sampler_state {
    texture = <IBLDiffuseTexture>;
    MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
    ADDRESSU  = CLAMP;  ADDRESSV  = CLAMP;
};

texture IBLSpecularTexture : MATERIALSPHEREMAP;
sampler IBLSpecularSampler = sampler_state {
    texture = <IBLSpecularTexture>;
    MINFILTER = LINEAR; 
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
};

void EnvLightingVS(
    in float4 Position : POSITION,
    in float3 Normal   : NORMAL,
    in float2 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float3 oNormal    : TEXCOORD1,
    out float3 oViewdir   : TEXCOORD2,
    out float4 oTexcoord2 : TEXCOORD3,
    out float4 oPosition  : SV_Position)
{
    oTexcoord = Texcoord.xyxy;
    oViewdir = CameraPosition - mul(Position, matWorld).xyz;
    oNormal = normalize(mul(Normal, (float3x3)matWorld));
    oPosition = mul(Position, matWorldViewProject);
    oTexcoord2 = oPosition;
}

float4 EnvLightingPS(
    float4 texcoord : TEXCOORD0,
    float3 normal   : TEXCOORD1,
    float3 viewdir  : TEXCOORD2,
    float4 texcoord2 : TEXCOORD3,
    float4 screenPosition : SV_Position) : SV_Target
{
    float2 texCoord = texcoord2.xy / texcoord2.w;
    texCoord = PosToCoord(texCoord);
    texCoord += ViewportOffset;

    float4 MRT0 = tex2D(Gbuffer1Map, texCoord);
    float4 MRT1 = tex2D(Gbuffer2Map, texCoord);
    float4 MRT2 = tex2D(Gbuffer3Map, texCoord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float3 V = normalize(viewdir);

#if (IBL_QUALITY >= 3) && (SSAO_SAMPLER_COUNT > 0)
    float4 lighting = float4(0.0, 0.5, 0.0, 0.5);
#else
    float4 lighting = 0.0f;
#endif

    if (material.lightModel != LIGHTINGMODEL_EMISSIVE)
    {
        float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
        float3 worldView = V;

        float mipLayer = EnvironmentMip(material.smoothness, IBL_MIPMAP_LEVEL);

        float3 R = EnvironmentReflect(worldNormal, worldView);

#if IBL_QUALITY >= 2
        float3 prefilteredDiffuse = tex2D(IBLDiffuseSampler, computeSphereCoord(worldNormal)).rgb;
        float3 prefilteredSpeculr = tex2Dlod(IBLSpecularSampler, float4(computeSphereCoord(R), 0, mipLayer)).rgb;
        float3 prefilteredTransmittance = tex2D(IBLDiffuseSampler, -computeSphereCoord(worldNormal)).rgb;
#else
        float3 prefilteredDiffuse = tex2Dlod(IBLSpecularSampler, float4(computeSphereCoord(worldNormal), 0, IBL_MIPMAP_LEVEL)).rgb;
        float3 prefilteredSpeculr = tex2Dlod(IBLSpecularSampler, float4(computeSphereCoord(R), 0, mipLayer)).rgb;
        float3 prefilteredTransmittance = tex2Dlod(IBLSpecularSampler, float4(computeSphereCoord(-worldNormal), 0, IBL_MIPMAP_LEVEL)).rgb;
#endif

        float3 diffuse = prefilteredDiffuse * material.albedo;

#if IBL_ENABLE_SS
        diffuse += prefilteredTransmittance * material.transmittance;
#endif

        float3 specular = prefilteredSpeculr * EnvironmentSpecularBlackOpsII(worldNormal, worldView, material.smoothness, material.specular);

#if (IBL_QUALITY >= 3) && (SSAO_SAMPLER_COUNT > 0)
        diffuse = rgb2ycbcr(diffuse);
        specular = rgb2ycbcr(specular);

        bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));
        lighting.r = diffuse.r;
        lighting.g = (pattern) ? diffuse.g: diffuse.b;
        lighting.b = specular.r;
        lighting.a = (pattern) ? specular.g: specular.b;
#else
        lighting.rgb = diffuse + specular;
#endif
    }

    return lighting;
}

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass;\
    > { \
        pass DrawObject { \
            AlphaBlendEnable = FALSE; AlphaTestEnable = FALSE;\
            VertexShader = compile vs_3_0 EnvLightingVS(); \
            PixelShader  = compile ps_3_0 EnvLightingPS(); \
        } \
    }


OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTech < string MMDPass = "shadow";  > {}
technique ZplotTec < string MMDPass = "zplot"; > {}