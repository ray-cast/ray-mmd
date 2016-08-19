float4 GlareDetectionPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : SV_Target0
{
    const float threshold = max(1e-5, 1.0f - mBloomThresholdP);
    const float intensity = 1.0f;

    float4 color = tex2D(source, coord) * (lerp(1, 5, mExposureP) - mExposureM);
    return float4(max(color.rgb - threshold / (1.0 - threshold), 0.0), color.a);
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

float3 FilmicTonemap(float3 color, float exposure)
{
    #if TONEMAP_OPERATOR == TONEMAP_LINEAR
        return exposure * color;
    #elif TONEMAP_OPERATOR == TONEMAP_EXPONENTIAL
        color = 1.0 - exp2(-exposure * color);
        return color;
    #elif TONEMAP_OPERATOR == TONEMAP_EXPONENTIAL_HSV
        color = rgb2hsv(color);
        color.b = 1.0 - exp2(-exposure * color.b);
        color = hsv2rgb(color);
        return color;
    #elif TONEMAP_OPERATOR == TONEMAP_REINHARD
        float burnout = 11.2;
        color = xyz2yxy(rgb2xyz(color));
        float L = color.r;
        L *= exposure;
        float LL = 1 + L / (burnout * burnout);
        float L_d = L * LL / (1 + L);
        color.r = L_d;
        color = xyz2rgb(yxy2xyz(color));
        return color;
    #elif TONEMAP_OPERATOR == TONEMAP_FILMIC
        const float W = lerp(11.2, 1, mLinWhite); // Linear White Point Value
        color = 2 * Uncharted2Tonemap(exposure * color);
        float3 whiteScale = 1.0f / Uncharted2Tonemap(W);
        color *= whiteScale;
        return color;
    #elif TONEMAP_OPERATOR == TONEMAP_UNCHARTED2
        const float W = lerp(11.2, 1, mLinWhite); // Linear White Point Value
        color = Uncharted2Tonemap(2 * exposure * color);
        float3 whiteScale = 1.0f / Uncharted2Tonemap(W);
        color *= whiteScale;
        return color;
    #else
        return color;
    #endif
}

float3 noise3( float2 seed )
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
    float3 color = tex2D(source, coord);
    color.g = tex2D(source, coord + ViewportOffset2 * L * 4).g;
    color.b = tex2D(source, coord + ViewportOffset2 * L * 8).b;
    return color;
}

float4 FimicToneMappingPS(in float2 coord: TEXCOORD0, uniform sampler2D source) : COLOR
{
    float3 color = AppleDispersion(source, coord, 1.5 - mVignetteP + mVignetteM, 2.5 - mVignetteP + mVignetteM);

#if HDR_ENABLE

#if HDR_BLOOM_ENABLE > 0
    float bloomIntensity = lerp(1, 10, mBloomIntensityP);
    
    float3 bloom1 = tex2D(BloomSampX2, coord).rgb * bloomIntensity;
    float3 bloom2 = tex2D(BloomSampX3, coord).rgb * bloomIntensity;
    float3 bloom3 = tex2D(BloomSampX4, coord).rgb * bloomIntensity;
    float3 bloom4 = tex2D(BloomSampX5, coord).rgb * bloomIntensity;
    
    color += bloom1 *  8.0 / 120.0;
    color += bloom2 * 16.0 / 120.0;
    color += bloom3 * 32.0 / 120.0;
    color += bloom4 * 64.0 / 120.0;
#endif

    color = ColorBalance(color, float4(1, 1, 1, mColBalance));
    color = FilmicTonemap(color, (1 + mExposureP * 10 - mExposureM));
    color = AppleVignette(color, coord, 1.5 - mVignetteP + mVignetteM, 2.5 - mVignetteP + mVignetteM);
#endif

    color = saturate(color);
    color = linear2srgb(color);
    color = ApplyDithering(color, coord);

    return float4(color, luminance(color));
}