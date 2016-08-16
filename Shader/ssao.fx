#if SSAO_SAMPLER_COUNT > 0

static float DepthLength2 = SSAO_SPACE_RADIUS * SSAO_SPACE_RADIUS;
static float DepthLength6 = pow(SSAO_SPACE_RADIUS, 6);

static float2 SSAORadiusB = (64.0 / 1024.0) / SSAO_SAMPLER_COUNT * ViewportAspect;

float linearizeDepth(float2 texcoord)
{
    return tex2D(Gbuffer4Map, texcoord).r;
}

float3 GetPosition(float2 uv)
{
    float depth = tex2D(Gbuffer4Map, uv).r;
    return ReconstructPos(uv, matProjectInverse, depth);
}

float3 GetNormal(float2 uv)
{
    float4 MRT1 = tex2D(Gbuffer2Map, uv);
    return DecodeGBufferNormal(MRT1);
}

float4 AmbientOcclustionPS(in float2 coord : TEXCOORD0) : SV_TARGET0
{
    float3 viewPosition = GetPosition(coord);
    float3 viewNormal = GetNormal(coord);

    int2 rndTexOffset = int2(coord * ViewportSize);
    float radMul = 1.0 / SSAO_SAMPLER_COUNT * (3.14 * 2.0 * 7.0);
    float radAdd = GetJitterOffset(rndTexOffset) * (PI * 2.0);

    float2 radiusMul = SSAORadiusB;
    float2 radiusAdd = 1.0 / ViewportSize.y;

    float sampleWeight = 0.0f;
    float4 sampleAmbient = 0.0f;

    for (int j = 0; j < SSAO_SAMPLER_COUNT; j++)
    {
        float2 sc;
        sincos(j * radMul + radAdd, sc.x, sc.y);

        float2 sampleOffset = coord + sc * (j * radiusMul + radiusAdd);
        float3 samplePosition = GetPosition(sampleOffset);
        float3 sampleDirection = samplePosition - viewPosition;

        float sampleLength2 = dot(sampleDirection, sampleDirection);
        float sampleAngle = dot(normalize(sampleDirection), viewNormal);

        float f = max(DepthLength2 - sampleLength2, 0.0f);
        float falloff = f * f * f / DepthLength6;

		float bias = 0.002;
        float occlustion  = max(0.0, falloff * (sampleAngle - samplePosition.z * bias));

        sampleWeight += falloff;
#if SSAO_EANBLE_GI > 0
        sampleAmbient += float4(tex2D(ScnSamp, sampleOffset).rgb, 1) * occlustion;
#else
        sampleAmbient += occlustion;
#endif
    }

#if SSAO_EANBLE_GI > 0
    return float4(sampleAmbient.xyz, sampleWeight - sampleAmbient.a) / sampleWeight;
#else
    return 1 - sampleAmbient.a / sampleWeight;
#endif
}

float BilateralFilterWeight(float2 coord, float r, float center_d)
{
    const float blurSharpness = SSAO_BLUR_SHARPNESS;
    const float blurSigma = SSAO_BLUR_RADIUS * 0.5f;
    const float blurFalloff = 1.0f / (2.0f * blurSigma * blurSigma);

    float d = linearizeDepth(coord);
    float ddiff = (d - center_d) * blurSharpness;
    return exp2(-r * r * blurFalloff - ddiff * ddiff);
}

float4 BilateralFilterPS(in float2 coord : TEXCOORD0, uniform sampler smp, uniform float2 offset) : SV_Target
{
    float center_d = linearizeDepth(coord);

    float4 total_c = tex2D(smp, coord);
    float total_w = 1.0f;

    [unroll]
    for (int r = 1; r < SSAO_BLUR_RADIUS; r++)
    {
        float2 offset1 = coord + offset * r;
        float2 offset2 = coord - offset * r;

        float bilateralWeight1 = BilateralFilterWeight(offset1, r, center_d);
        float bilateralWeight2 = BilateralFilterWeight(offset2, r, center_d);

        total_c += tex2D(smp, offset1) * bilateralWeight1;
        total_c += tex2D(smp, offset2) * bilateralWeight2;

        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
    }

    return total_c / total_w;
}

#endif