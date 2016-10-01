float4x4 matView               : VIEW;
float4x4 matViewInverse        : VIEWINVERSE;
float4x4 matProject            : PROJECTION;
float4x4 matProjectInverse     : PROJECTIONINVERSE;
float4x4 matViewProject        : VIEWPROJECTION;
float4x4 matViewProjectInverse : VIEWPROJECTIONINVERSE;

float3 CameraPosition  : POSITION  < string Object = "Camera"; >;
float3  LightSpecular   : SPECULAR  < string Object = "Light"; >;
float3  LightDirection  : DIRECTION < string Object = "Light"; >;

float STARDISTANCE = 300;
float STARBRIGHTNESS = 0.4;
float STARDENCITY = 0.02;

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

void ComputePhaseFunctions(float3 inscatteringMie, float3 inscatteringRayleigh, float3 viewdir, float3 L, float g, inout float3 inscattering)
{
    float gg = g * g;
    float g2 = 2 * g;
    
    float cosTheta = dot(viewdir, L);
    float cosTheta2 = cosTheta * cosTheta;
    
    float leftTop = 3 * (1 - gg);
    float leftBottom = 2 * (2 + gg);
    float rightTop = 1.0 + cosTheta2;
    float rightBottom = pow(1.0 + gg - g2 * cosTheta, 1.5);
    
    float3 betaMie = inscatteringMie * (leftTop / leftBottom) * (rightTop / rightBottom)  / (4.0 * pi);
    float3 betaRayleigh = inscatteringRayleigh * (cosTheta2 * 0.75 + 0.75) / (4 * pi);
    
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

float hash(float3 p3)
{
    p3  = frac(p3 * float3(.1031,.11369,.13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z);
}

float stars(float3 ray)
{
    float3 p = ray * STARDISTANCE;
    float brigtness = smoothstep(1.0 - STARDENCITY, 1.0, hash(floor(p)));
    return smoothstep(STARBRIGHTNESS, 0, length(frac(p) - 0.5)) * brigtness;
}

void ComputeStars(float3 viewdir, inout float3 inscattering)
{
    inscattering = inscattering + stars(viewdir);
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

float3 linear2srgb(float3 srgb)
{
    const float ALPHA = 0.055f;
    return srgb < 0.0031308f ? 12.92f * srgb : (1 + ALPHA) * pow(srgb, 1.0f / 2.4f) - ALPHA;
}

void SkyboxVS(
    in float4 Position : POSITION,
    out float4 oNormal   : TEXCOORD0,
    out float4 oTexcoord : TEXCOORD1,
    out float4 oPosition : SV_Position)
{
    oNormal = normalize(Position);
    oTexcoord = float4(oNormal.xyz * 40000, 1);
    oPosition = mul(oTexcoord, matViewProject);
}

void ComputeUnshadowedInscattering(float3 world, inout float3 inscattering, inout float3 extinction)
{
    float3 viewdir = normalize(world);
    
    float3 up = float3(0, 1, 0);
    float3 sunDirection = -LightDirection;
    
    float zenithAngle = saturate(dot(viewdir, up));
    float zenithAngleRadians = degrees(acos(zenithAngle));
    float zenithAngleCos = dot(sunDirection, up);
    float zenithAngleDenom = 1.0 / (zenithAngle + 0.15 * pow(93.885 - zenithAngleRadians, -1.253));
    
    float3 inscatteringMie = totalMie(lambda, K, turbidity) * mieCoefficient;
    float3 inscatteringRayleigh = totalRayleigh(lambda) * reileighCoefficient;
    ComputePhaseFunctions(inscatteringMie, inscatteringRayleigh, viewdir, sunDirection, mieG, inscattering);
    
    float3 opticalMie = inscatteringMie * mieZenithLength * zenithAngleDenom;
    float3 opticalRayleigh = inscatteringRayleigh * rayleighZenithLength * zenithAngleDenom;
    ComputeScatteringIntensity(opticalMie, opticalRayleigh, extinction);
    
    inscattering *= ComputeSunIntensity(zenithAngleCos);
    
    float3 Lin = inscattering * (1.0 - extinction);//pow(, 1.0);
    Lin *= lerp(1.0, pow(inscattering * extinction, 0.5), pow(1.0 - zenithAngleCos, 5.0));
    Lin *= 0.015;
    
    float3 texColor = Lin;
    float3 color = ACESFilmRec709(texColor);
    
    inscattering = linear2srgb(color);
}

float4 SkyboxPS(in float4 normal : TEXCOORD0, in float3 position : TEXCOORD1, in float4 screenPosition : SV_Position) : COLOR
{
    float3 insctrColor = 0, extinction = 1;
    ComputeUnshadowedInscattering(position, insctrColor, extinction);
    return float4(insctrColor, 1);
}

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass; \
    string Script = \
        "RenderColorTarget0=;" \
        "RenderDepthStencilTarget=;" \
        "Pass=DrawObject;" \
    ; \
    > { \
        pass DrawObject { \
            AlphaTestEnable = FALSE; AlphaBlendEnable = FALSE; \
            VertexShader = compile vs_3_0 SkyboxVS(); \
            PixelShader  = compile ps_3_0 SkyboxPS(); \
        } \
    }

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTec1, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}