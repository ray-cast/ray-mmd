#include "../../ray.conf"
#include "../../shader/math.fx"
#include "../../shader/common.fx"
#include "../../shader/gbuffer.fx"
#include "../../shader/gbuffer_sampler.fx"
#include "../../shader/lighting.fx"

float3  LightDirection  : DIRECTION < string Object = "Light"; >;
float3  LightSpecular   : SPECULAR  < string Object = "Light"; >;

bool ExistRay : CONTROLOBJECT<string name = "ray.x";>;

texture DiffuseMap: MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
    texture = <DiffuseMap>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = POINT;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

float4 GetTextureColor(float4 albedo, float2 uv)
{
    if (use_texture)
    {
        float4 TexColor = tex2D(DiffuseMapSamp, uv);
        TexColor.rgb = lerp(1, TexColor * TextureMulValue + TextureAddValue, TextureMulValue.a + TextureAddValue.a).rgb;
        TexColor.rgb = TexColor.rgb;
        albedo *= TexColor;
    }

    return srgb2linear(albedo);
}

const float mieCoefficient = 0.005;
const float reileighCoefficient = 2;
const float mieG = 0.98;
const float turbidity = 1;
const float3 lambda = float3(680E-9, 550E-9, 450E-9);
const float3 K = float3(0.686, 0.678, 0.666);
const float v = 4.0;
const float rayleighZenithLength = 8.4E3;
const float mieZenithLength = 1.25E3;
const float pi = 3.141592654f;
const float EE = 1000.0;
const float steepness = 1.5;
const float cutoffAngle = 3.141592654f / 1.95;

float3 totalRayleigh(float3 lambda)
{
    float n = 1.0003;
    float n2 = n * n;
    float pi3 = pi * pi * pi;
    return (8.0 * pi3 * pow(n2 - 1.0, 2.0) * 6.105) / (3.0 * 2.545E25 * pow(lambda, 4.0) * 6.245);
}

float3 totalMie(float3 lambda, float3 K, float T)
{
    float c = (0.2 * T) * 10E-18;
    return 0.434 * c * pi * pow((2.0 * pi) / lambda, v - 2.0) * K;
}

void ComputePhaseFunctions(float3 inscatteringMie, float3 inscatteringRayleigh, float3 V, float3 L, float g, inout float3 inscattering)
{
    float gg = g * g;
    float g2 = 2 * g;
    
    float cosTheta = dot(V, L);
    float cosTheta2 = cosTheta * cosTheta;
    
    float leftTop = 3 * (1 - gg);
    float leftBottom = 2 * (2 + gg);
    float rightTop = 1.0 + cosTheta2;
    float rightBottom = pow(1.0 + gg - g2 * cosTheta, 1.5);
    
    float3 betaMie = inscatteringMie * (leftTop / leftBottom) * (rightTop / rightBottom) / (4.0 * pi);
    float3 betaRayleigh = inscatteringRayleigh * (cosTheta2 * 0.75 + 0.75) / (4.0 * pi);
    
    inscattering = (betaMie + betaRayleigh) / (inscatteringMie + inscatteringRayleigh);
}

void ComputeScatteringIntensity(float3 opticalDepthMie, float3 opticalDepthRayleigh, out float3 extinction)
{
    extinction = exp(-(opticalDepthRayleigh + opticalDepthMie));
}

float ComputeSunIntensity(float zenithAngleCos)
{
    return EE * max(0.0f, 1.0f - exp(-((cutoffAngle - acos(zenithAngleCos)) / steepness)));
}

float3 ACESFilmRec709(float3 x)
{
    const float A = 2.51f;
    const float B = 0.03f;
    const float C = 2.43f;
    const float D = 0.59f;
    const float E = 0.14f;
    return (x * (A * x + B)) / (x * (C * x + D) + E);   
}

void DrawObjectVS(
    in float4 Position : POSITION,
    in float3 Normal   : NORMAL,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float3 oNormal    : TEXCOORD1,
    out float4 oViewdir   : TEXCOORD2,
    out float4 oPosition  : SV_Position)
{
    oNormal = Normal;
    oTexcoord = Texcoord;
    oViewdir = Position;
    oPosition = mul(Position, matViewProject);
}

float4 DrawObjectPS(float4 texcoord : TEXCOORD0, float3 normal : TEXCOORD1, float3 position : TEXCOORD2) : SV_Target
{
    float4 albedo = GetTextureColor(MaterialDiffuse, texcoord.xy);

    float3 L = mul(normalize(-LightDirection), matView);
    float3 V = mul(normalize(CameraPosition - position), matView);
    float3 N = mul(normalize(normal), matView);

    float MaterialSmoothness = ShininessToSmoothness(MaterialPower);

    float3 inscatteringMie = totalMie(lambda, K, turbidity) * mieCoefficient;
    float3 inscatteringRayleigh = totalRayleigh(lambda) * reileighCoefficient;
    
    float3 inscattering = 0;
    ComputePhaseFunctions(inscatteringMie, inscatteringRayleigh, -V, L, mieG, inscattering);
    
    float3 extinction = 0;
    float distance = length(position - CameraPosition);
    ComputeScatteringIntensity(inscatteringMie * distance, inscatteringRayleigh * distance, extinction);
    
    float3 up = float3(0, 1, 0);
    float zenithAngleCos = dot(L, up);
    inscattering *= ComputeSunIntensity(zenithAngleCos);

    float3 Lin = inscattering * (1.0f - extinction);
    Lin *= lerp(1.0, pow(inscattering * extinction, 0.5), pow(1.0 - zenithAngleCos, 5.0));
    Lin *= 0.015;
    
    float4 lighting = 0;
    lighting.rgb += albedo * DiffuseBRDF(N, L, V, 0.1);
    lighting.rgb += albedo * SpecularBRDF(N, L, V, 0.1, 0.04);
    lighting.rgb *= saturate(dot(N, L)) * LightSpecular;
    
    float3 color = ACESFilmRec709(lighting + Lin);
    color = saturate(linear2srgb(color));
    return float4(color, albedo.a);
}

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass;\
    > { \
        pass DrawObject { \
            AlphaTestEnable = true; AlphaBlendEnable = true; \
            VertexShader = compile vs_3_0 DrawObjectVS(); \
            PixelShader  = compile ps_3_0 DrawObjectPS(); \
        } \
    }

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTech < string MMDPass = "shadow";  > {}
technique ZplotTec < string MMDPass = "zplot"; > {}