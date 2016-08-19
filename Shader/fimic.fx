float4 GlareDetectionPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : SV_Target0
{  
    float4 color = tex2D(source, coord);
    return max(color - (1.0 - mBloomThreshold) / (mBloomThreshold + EPSILON), 0.0);
}

float4 BloomBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : SV_Target
{
    const float weights[15] = { 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153 };
    const float weightSum = 262106.0;

    float4 color = 0.0f;
    float2 coords = coord - offset * 7.0;

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
        color = color * exposure;
        float3 curr = ACESFilm2Tonemap(color);
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
    float L = length(CoordToPos(coord));
    return color * smoothstep(outer, inner, L);
}

float3 AppleDispersion(sampler2D source, float2 coord, float inner, float outer)
{
    float L = length(CoordToPos(coord));
    L = 1 - smoothstep(outer, inner, L);
    float3 color = tex2D(source, coord).rgb;
    color.g = tex2D(source, coord + ViewportOffset2 * L * 4).g;
    color.b = tex2D(source, coord + ViewportOffset2 * L * 8).b;
    return color;
}

float4 FimicToneMappingPS(in float2 coord: TEXCOORD0, uniform sampler2D source) : COLOR
{
    float3 color = AppleDispersion(source, coord, 1.5 - mVignette, 2.5 - mVignette);

#if HDR_ENABLE

#if HDR_BLOOM_ENABLE > 0
    float bloomIntensity = lerp(1, 10, mBloomIntensity);
    
    float3 bloom1 = tex2D(BloomSampX2, coord).rgb * bloomIntensity;
    float3 bloom2 = tex2D(BloomSampX3, coord).rgb * bloomIntensity;
    float3 bloom3 = tex2D(BloomSampX4, coord).rgb * bloomIntensity;
    float3 bloom4 = tex2D(BloomSampX5, coord).rgb * bloomIntensity;
    
    float3 bloom = 0.0f;
    bloom += bloom1 *  8.0 / 120.0;
    bloom += bloom2 * 16.0 / 120.0;
    bloom += bloom3 * 32.0 / 120.0;
    bloom += bloom4 * 64.0 / 120.0;
    
    color += bloom;
#endif

    color = ColorBalance(color, float4(1 - float3(mColBalanceR, mColBalanceG, mColBalanceB), mColBalance));
    color = FilmicTonemap(color, (1 + mExposure * 10));
#endif

    color = saturate(color);
    color = linear2srgb(color);
    
    color = AppleVignette(color, coord, 1.5 - mVignette, 2.5 - mVignette);
    color = ApplyDithering(color, coord);

    return float4(color, luminance(color));
}