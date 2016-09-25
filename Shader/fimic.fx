texture2D NoiseMap<string ResourceName = "shader/noise.png";>; 
sampler NoiseMapSamp = sampler_state
{
    texture = NoiseMap;
    MINFILTER = NONE; MAGFILTER = NONE; ADDRESSU = WRAP; ADDRESSV = WRAP;
};

float4 GlareDetectionPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : SV_Target0
{ 
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float2 offsets[] = {
        float2( 0.0,  0.0),
        float2(-1.0,  0.0),
        float2( 1.0,  0.0),
        float2( 0.0, -1.0),
        float2( 0.0,  1.0),
    };

    float4 color = 1e100;
    for (int i = 0; i < 5; i++)
        color = min(tex2D(source, coord + offsets[i] * offset), color);
    
    float4 bloom = max(color - (1.0 - mBloomThreshold) / (mBloomThreshold + EPSILON), 0.0);   

    if (material.lightModel == LIGHTINGMODEL_EMISSIVE)
    {
        bloom += float4(material.emissive, 0);
    }

#if ALHPA_ENABLE > 0
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    
    float alphaDiffuse = 0;
    MaterialParam materialAlpha;
    DecodeGbufferWithAlpha(MRT5, MRT6, MRT7, materialAlpha, alphaDiffuse);
    
    if (materialAlpha.lightModel == LIGHTINGMODEL_EMISSIVE)
    {
        bloom += float4(materialAlpha.emissive, 0);
    }
#endif
    
    return bloom;
}

void BloomBlurVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD,
    out float4 oTexcoord : TEXCOORD0,
    out float4 oPosition : SV_Position,
    uniform int n)
{
    oPosition = Position;
    oTexcoord = Texcoord;
    oTexcoord.xy += ViewportOffset * n;
}

float4 BloomBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset, uniform int n) : SV_Target
{
    const float weights[15] = { 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153 };
    const float weightSum = 262106.0;
    
    float4 color = 0;
    float2 coords = coord - offset * 7.0;
    
    for (int i = 0; i < 15; ++i)
    {
        color += tex2D(source, coords) * (weights[i] / weightSum);
        coords += offset;
    }

    return color;
}

float3 ColorBalance(float3 color, float4 balance)
{
    float3 lum = luminance(color);
    color = lerp(lum, color, 1 - balance.a);
    color *= balance.rgb;
    return color;
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

float3 ACESFilmRec2020( float3 x )
{
    float a = 15.8f;
    float b = 2.12f;
    float c = 1.2f;
    float d = 5.92f;
    float e = 1.9f;
    return ( x * ( a * x + b ) ) / ( x * ( c * x + d ) + e );
}

float3 FilmicTonemap(float3 color, float exposure)
{
    #if TONEMAP_OPERATOR == TONEMAP_LINEAR
        return exposure * color;
    #elif TONEMAP_OPERATOR == TONEMAP_ACES_FILM_REC_709
        color = color * exposure;
        float3 curr = ACESFilmRec709(color);
        return lerp(curr, color, mToneMapping);
    #elif TONEMAP_OPERATOR == TONEMAP_ACES_FILM_REC_2020
        color = color * exposure;
        float3 curr = ACESFilmRec2020(color);
        return lerp(curr, color, mToneMapping);
    #else
        return color;
    #endif
}

float3 noise3(float2 seed)
{
    return frac(sin(dot(seed.xy, float2(34.483, 89.637))) * float3(29156.4765, 38273.5639, 47843.7546));
}

float3 ApplyDithering(float3 color, float2 uv)
{
    float3 noise = noise3(uv) + noise3(uv + 0.5789) - 0.5;
    color += noise / 255.0;
    return color;
}

float3 AppleVignette(float3 color, float2 coord, float inner, float outer)
{
    float L = length(coord * 2 - 1);
    return color * smoothstep(outer, inner, L);
}

float3 AppleDispersion(sampler2D source, float2 coord, float inner, float outer)
{
    float L = length(CoordToPos(coord));
    L = 1 - smoothstep(outer, inner, L);
    float3 color = tex2D(source, coord).rgb;
    color.g = tex2D(source, coord - ViewportOffset2 * L * (mDispersion * 8)).g;
    color.b = tex2D(source, coord + ViewportOffset2 * L * (mDispersion * 8)).b;
    return color;
}

float3 Overlay(float3 a, float3 b)
{
    return pow(abs(b), 2.2) < 0.5? 2 * a * b : 1.0 - 2 * (1.0 - a) * (1.0 - b);
}

float3 AppleFilmGrain(float3 color, float2 coord, float exposure)
{
    float noiseIntensity = mFilmGrain;
    coord.x *= (ViewportSize.y / ViewportSize.x);
    coord.x += time * 6;
    
    float noise = tex2D(NoiseMapSamp, coord).r;
    float exposureFactor = exposure / 2.0;
    exposureFactor = sqrt(exposureFactor);
    float t = lerp(3.5 * noiseIntensity, 1.13 * noiseIntensity, exposureFactor);
    
    return Overlay(color, lerp(0.5, noise, t));
}

float3 AppleFilmLine(float3 color, float2 coord, int2 screenPosition)
{
    bool pattern = fmod(screenPosition.y, 2.0) > 0 ? 1 : 0;
    return lerp(color, 0, mFilmLine * pattern);
}

float BloomFactor(const in float factor) 
{
    float mirrorFactor = 1.2 - factor;
    return lerp(factor, mirrorFactor, mBloomRadius);
}

float ComputeEV100(float aperture, float shutterTime, float ISO)
{
    return log2(aperture / shutterTime * 100 / ISO);
}

float ComputeExposureFromEV100(float EV100)
{
    float maxLuminance = 1.2f * pow (2.0f, EV100);
    return 1.0f / maxLuminance;
}

float4 FimicToneMappingPS(in float2 coord: TEXCOORD0, in float4 screenPosition : SV_Position, uniform sampler2D source) : COLOR
{
    float3 color = AppleDispersion(source, coord, mDispersionRadius, 1 + mDispersionRadius);
    
    float exposure = 1 + mExposure * 10;
#if ISO100_ENABLE
    #if !defined(MIKUMIKUMOVING)
        if (ExistISO)
        {
    #endif
            float aperture = 1.0 + mAperture * 30;
            float shutterTime = (1.2 + mShutterTimeP * 10 - mShutterTimeM);
            float EV100 = ComputeEV100(aperture, shutterTime, 100 * (1 + mISO * 10));
            exposure = ComputeExposureFromEV100(EV100);
    #if !defined(MIKUMIKUMOVING)
        }
    #endif
#endif

#if HDR_ENABLE
#if HDR_BLOOM_QUALITY > 0
    float bloomFactors[] = {1.0, 0.8, 0.6, 0.4, 0.2};
    
    float3 bloom0 = tex2D(BloomSampX1, coord).rgb;
    float3 bloom1 = BloomFactor(bloomFactors[1]) * tex2D(BloomSampX2, coord).rgb;
    float3 bloom2 = BloomFactor(bloomFactors[2]) * tex2D(BloomSampX3, coord).rgb;
    float3 bloom3 = BloomFactor(bloomFactors[3]) * tex2D(BloomSampX4, coord).rgb;
    float3 bloom4 = BloomFactor(bloomFactors[4]) * tex2D(BloomSampX5, coord).rgb;
    
    float3 bloom = 0.0f;
    bloom += bloom0;
    bloom += bloom1;
    bloom += bloom2;
    bloom += bloom3;
    bloom += bloom4;
    
    float bloomIntensity = lerp(1, 20, mBloomIntensity);
    color += bloom * bloomIntensity;
#endif

    float3 balance = float3(1 + float3(mColBalanceRP, mColBalanceGP, mColBalanceBP) - float3(mColBalanceRM, mColBalanceGM, mColBalanceBM));
    color = ColorBalance(color, float4(balance, mColBalance));
    color = FilmicTonemap(color, exposure);
#endif
  
    color = AppleVignette(color, coord, 1.5 - mVignette, 2.5 - mVignette);
    color = AppleFilmGrain(color, coord, exposure);
    color = AppleFilmLine(color, coord, screenPosition.xy);
    
    color = saturate(color);
    color = linear2srgb(color);
    color = ApplyDithering(color, coord);

    return float4(color, luminance(color));
}