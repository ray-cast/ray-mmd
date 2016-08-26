#include "../ray.conf"
#include "../shader/math.fx"
#include "../shader/common.fx"
#include "../shader/gbuffer.fx"
#include "../shader/gbuffer_sampler.fx"
#include "../shader/lighting.fx"

float mR : CONTROLOBJECT < string name="PointLight.pmx"; string item = "R+"; >;
float mG : CONTROLOBJECT < string name="PointLight.pmx"; string item = "G+"; >;
float mB : CONTROLOBJECT < string name="PointLight.pmx"; string item = "B+"; >;
float mRadiusP : CONTROLOBJECT < string name="PointLight.pmx"; string item = "Radius+"; >;
float mIntensityP : CONTROLOBJECT < string name="PointLight.pmx"; string item = "Intensity+"; >;
float mBlubP : CONTROLOBJECT < string name="PointLight.pmx"; string item = "Blub+"; >;

#define POINTLIGHT_MAX_RADIUS 500
#define POINTLIGHT_MAX_INTENSITY 1000

void PointLightingVS(
    in float4 Position : POSITION,
    in float3 Normal   : NORMAL,
    in float2 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float3 oNormal    : TEXCOORD1,
    out float3 oViewdir   : TEXCOORD2,
    out float4 oTexcoord2 : TEXCOORD3,
    out float4 oLightDir  : TEXCOORD4,
    out float4 oPosition  : SV_Position)
{
    oTexcoord = Texcoord.xyxy;
    oViewdir = CameraPosition - Position.xyz;
    oNormal = normalize(Normal);
    
    float3 center = Position.xyz - Normal;
    Position.xyz = center + Normal * (1 + mRadiusP * POINTLIGHT_MAX_RADIUS);
    
    oLightDir = float4(center.xyz, 1);

    oPosition = mul(float4(Position.xyz, 1), matViewProject);
    oTexcoord2 = float4(oPosition.xyz, oPosition.w);
}

float3 GetPosition(float2 uv)
{
    float depth = tex2D(Gbuffer4Map, uv).r;
    return ReconstructPos(uv, matProjectInverse, depth);
}

float4 PointLightingPS(
    float4 texcoord : TEXCOORD0,
    float3 normal   : TEXCOORD1,
    float3 viewdir  : TEXCOORD2,
    float4 texcoord2 : TEXCOORD3,
    float4 lightPos  : TEXCOORD4,
    float4 screenPosition : SV_Position,
    uint isFrontFace : SV_IsFrontFace) : SV_Target
{
    float2 texCoord = texcoord2.xy / texcoord2.w;
    texCoord = PosToCoord(texCoord);
    texCoord += ViewportOffset;

    float4 MRT0 = tex2D(Gbuffer1Map, texCoord);
    float4 MRT1 = tex2D(Gbuffer2Map, texCoord);
    float4 MRT2 = tex2D(Gbuffer3Map, texCoord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float3 P = GetPosition(texCoord);
    float3 V = normalize(mul(viewdir, matView));
    float3 L = normalize(mul(lightPos, matView).xyz - P);

    float3 v = lightPos - mul(float4(P, 1), matViewInverse).xyz;
    float d2 = 1 / dot(v, v);

    float4 lighting = 0.0f;
    lighting.rgb += DiffuseBRDF(material.normal, L, V, material.smoothness) * material.albedo;
    lighting.rgb += SpecularBRDF(material.normal, L, V, material.smoothness, material.specular);
    lighting.rgb *= float3(mR, mG, mB);
    lighting *= (1 + mIntensityP * POINTLIGHT_MAX_INTENSITY);
    lighting *= GetPhysicalLightAttenuation(lightPos, mul(float4(P, 1), matViewInverse), (1 + mRadiusP * POINTLIGHT_MAX_RADIUS), 1 - mBlubP);

    return lighting;
}

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass;\
    > { \
        pass DrawObject { \
            ZEnable = false; \
            ZWriteEnable = false;\
            AlphaBlendEnable = TRUE; \
            AlphaTestEnable = FALSE;\
            SrcBlend = ONE;\
            DestBlend = ONE;\
            CullMode = CW;\
            VertexShader = compile vs_3_0 PointLightingVS(); \
            PixelShader  = compile ps_3_0 PointLightingPS(); \
        } \
    }


OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTech < string MMDPass = "shadow";  > {}
technique ZplotTec < string MMDPass = "zplot"; > {}