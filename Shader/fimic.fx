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
    
    float4 color = tex2D(source, coord);
    
    float4 bloom = max(color - (1.0 - mBloomThreshold) / (mBloomThreshold + EPSILON), 0.0);
    
    if (material.lightModel == LIGHTINGMODEL_EMISSIVE)
    {
        bloom += float4(material.emissive, 0);
    }

    return bloom;
}

float4 BloomBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : SV_Target
{
    const float weights[15] = { 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153 };
    const float weightSum = 262106.0;

    float4 color = 0.0f;
    float2 coords = coord - offset * 6.2;

    [unroll]
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

float3 Uncharted2Tonemap(float3 x)
{
    const float A = lerp(0.22, 1, mShoStrength); // Shoulder Strength
    const float B = lerp(0.30, 1, mLinStrength); // Linear Strength
    const float C = 0.10; // Linear Angle
    const float D = 0.20; // Toe Strength
    const float E = 0.01 *  (mToeNum * 10); // Toe Numerator
    const float F = 0.30; // Toe Denominator E/F = Toe Angle
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

float3 ACESFilm2Tonemap(float3 x)
{
    const float A = 2.51f;
    const float B = 0.03f;
    const float C = 2.43f;
    const float D = 0.59f;
    const float E = 0.14f;
    return (x * (A * x + B)) / (x * (C * x + D) + E);   
}

float3 FilmicTonemap(float3 color, float exposure)
{
    #if TONEMAP_OPERATOR == TONEMAP_LINEAR
        return exposure * color;
    #elif TONEMAP_OPERATOR == TONEMAP_FILMIC
        const float W = lerp(11.2, 1, mLinWhite); // Linear White Point Value
        color = color * exposure;
        color = 2 * Uncharted2Tonemap(color);
        float3 whiteScale = 1.0f / Uncharted2Tonemap(W);
        color *= whiteScale;
        return lerp(curr, color, mToneMapping);
    #elif TONEMAP_OPERATOR == TONEMAP_UNCHARTED2
        const float W = lerp(11.2, 1, mLinWhite); // Linear White Point Value
        color = color * exposure;
        float3 curr = Uncharted2Tonemap(2 * color);
        float3 whiteScale = 1.0f / Uncharted2Tonemap(W);
        curr *= whiteScale;
        return lerp(curr, color, mToneMapping);
    #elif TONEMAP_OPERATOR == TONEMAP_ACESFILM
        const float W = lerp(11.2, 1, mLinWhite); // Linear White Point Value
        color = color * exposure;
        float3 uncharted = Uncharted2Tonemap(2 * color);
        float3 whiteScale = 1.0f / Uncharted2Tonemap(W);
        uncharted *= whiteScale;
        float3 curr = ACESFilm2Tonemap(color);
        return lerp(curr, uncharted, mToneMapping);
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
    float L = length(CoordToPos(coord));
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

float3 AppleFilmGrain(float3 color, float2 coord) 
{
    float noiseIntensity = mFilmGrain * 2;
    coord.x *= (ViewportSize.y / ViewportSize.x);
    coord.x += time * 6;
    
    float noise = tex2D(NoiseMapSamp, coord).r;
    float exposureFactor = (2 + mExposure * 10) / 2.0;
    exposureFactor = sqrt(exposureFactor);
    float t = lerp(3.5 * noiseIntensity, 1.13 * noiseIntensity, exposureFactor);
    
    // Overlay blending
    return Overlay(color, lerp(0.5, noise, t));
}

float4 FimicToneMappingPS(in float2 coord: TEXCOORD0, uniform sampler2D source) : COLOR
{
    float3 color = AppleDispersion(source, coord, mDispersionRadius, 1 + mDispersionRadius);
    
#if HDR_ENABLE

    color = ColorBalance(color, float4(1 - float3(mColBalanceR, mColBalanceG, mColBalanceB), mColBalance));
    color = FilmicTonemap(color, (1 + mExposure * 10));
    
#if HDR_BLOOM_ENABLE > 0
    float bloomIntensity = lerp(1, 10, mBloomIntensity);
    
    float3 bloom1 = tex2D(BloomSampX2, coord).rgb * bloomIntensity;
    float3 bloom2 = tex2D(BloomSampX3, coord).rgb * bloomIntensity;
    float3 bloom3 = tex2D(BloomSampX4, coord).rgb * bloomIntensity;
    float3 bloom4 = tex2D(BloomSampX5, coord).rgb * bloomIntensity;
    
    float3 bloom = 0.0f;
    bloom += bloom1;
    bloom += bloom2;
    bloom += bloom3;
    bloom += bloom4;
    
    color += bloom;
#endif
#endif
  
    color = AppleVignette(color, coord, 1.5 - mVignette, 2.5 - mVignette);
    color = ApplyDithering(color, coord);
    color = AppleFilmGrain(color, coord);
    
    float lum = luminance(color);
    
    color = saturate(color);
    color = linear2srgb(color);
       
    return float4(color, lum);
}