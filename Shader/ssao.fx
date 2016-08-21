#if SSAO_SAMPLER_COUNT > 0

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

float hash(float n) { return frac(sin(n) * 1e4); }
float hash(float2 p) { return frac(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

float noise1(float2 x) 
{
    float2 i = floor(x);
    float2 f = frac(x);

    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));

    // Simple 2D lerp using smoothstep envelope between the values.
    // return float3(lerp(lerp(a, b, smoothstep(0.0, 1.0, f.x)),
    //          lerp(c, d, smoothstep(0.0, 1.0, f.x)),
    //          smoothstep(0.0, 1.0, f.y)));

    // Same code, with the clamps in smoothstep and common subexpressions
    // optimized away.
    float2 u = f * f * (3.0 - 2.0 * f);
    return lerp(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float2 RotateDirection(float2 Dir, float2 CosSin)
{
    return float2(Dir.x*CosSin.x - Dir.y*CosSin.y,
                  Dir.x*CosSin.y + Dir.y*CosSin.x);
}

float2 tapLocation(int index, float noise)
{
    float alpha = 2.0 * PI * 7 / SSAO_SAMPLER_COUNT;
    float angle = index * alpha + noise;
    float radius = (mSSAORadiusM - mSSAORadiusP + 1) * 16;
    float2 radiusStep = ((ViewportSize.x / radius) / ViewportSize) / SSAO_SAMPLER_COUNT;
    return float2(cos(angle), sin(angle)) * (index * radiusStep + ViewportOffset2);
}

float4 SSAO(in float2 coord : TEXCOORD0) : COLOR
{
    float3 viewPosition = GetPosition(coord);
    float3 viewNormal = GetNormal(coord);

    float sampleNoise = GetJitterOffset(int2(coord * ViewportSize)) * (PI * 2.0);  
    
    float sampleWeight = 0.0f;
    float sampleAmbient = 0.0f;

    for (int j = 0; j < SSAO_SAMPLER_COUNT; j++)
    {
        float2 sampleOffset = coord + tapLocation(j, sampleNoise); 
        float3 samplePosition = GetPosition(sampleOffset);
        float3 sampleDirection = samplePosition - viewPosition;

        float sampleLength2 = dot(sampleDirection, sampleDirection);
        float sampleAngle = dot(normalize(sampleDirection), viewNormal);

        if (sampleLength2 < SSAO_SPACE_RADIUS2)
        {
            float bias = 0.0012;
            float occlustion  = saturate(sampleAngle - samplePosition.z * bias);
            
            sampleAmbient += occlustion;
            sampleWeight += 1.0;
        }
    }

    return 1 - sampleAmbient / sampleWeight;
}

float SSAOBlurWeight(float2 coord, float r, float center_d)
{
    const float blurSharpness = SSAO_BLUR_SHARPNESS;
    const float blurSigma = SSAO_BLUR_RADIUS * 0.5f;
    const float blurFalloff = 1.0f / (2.0f * blurSigma * blurSigma);

    float d = linearizeDepth(coord);
    float ddiff = (d - center_d) * blurSharpness;
    return exp2(-r * r * blurFalloff - ddiff * ddiff);
}

float4 SSAOBlur(in float2 coord : TEXCOORD0, uniform sampler smp, uniform float2 offset) : SV_Target
{
    float center_d = linearizeDepth(coord);

    float4 total_c = tex2D(smp, coord);
    float total_w = 1.0f;

    [unroll]
    for (int r = 1; r < SSAO_BLUR_RADIUS; r++)
    {
        float2 offset1 = coord + offset * r;
        float2 offset2 = coord - offset * r;

        float bilateralWeight1 = SSAOBlurWeight(offset1, r, center_d);
        float bilateralWeight2 = SSAOBlurWeight(offset2, r, center_d);

        total_c += tex2D(smp, offset1) * bilateralWeight1;
        total_c += tex2D(smp, offset2) * bilateralWeight2;

        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
    }

    return total_c / total_w;
}

float4 SSGI(in float2 coord : TEXCOORD0) : COLOR
{
    float3 viewPosition = GetPosition(coord);
    float3 viewNormal = GetNormal(coord);

    float sampleNoise = GetJitterOffset(int2(coord * ViewportSize)) * (PI * 2.0);  
    
    float sampleWeight = 0.0f;
    float4 sampleIndirect = 0.0f;

    for (int j = 0; j < SSAO_SAMPLER_COUNT; j++)
    {
        float2 sampleOffset = coord + tapLocation(j, sampleNoise); 
        float3 samplePosition = GetPosition(sampleOffset);
        float3 sampleDirection = samplePosition - viewPosition;

        float sampleLength2 = dot(sampleDirection, sampleDirection);
        float sampleAngle = dot(normalize(sampleDirection), viewNormal);

        if (sampleLength2 < SSAO_SPACE_RADIUS2)
        {
            float bias = 0.0012;
            float occlustion  = saturate(sampleAngle - samplePosition.z * bias);

            float4 MRT0 = tex2D(Gbuffer1Map, sampleOffset);
            float4 MRT1 = tex2D(Gbuffer2Map, sampleOffset);
            float4 MRT2 = tex2D(Gbuffer3Map, sampleOffset);

            MaterialParam material;
            DecodeGbuffer(MRT0, MRT1, MRT2, material);
                
            if (dot(material.normal, viewNormal) < 1e-3f)
            {
                float bloomIntensity = lerp(1, 10, mBloomIntensity);
                
                sampleIndirect.rgb += material.emissive.rgb * tex2D(Gbuffer1Map, coord).rgb * bloomIntensity;
                sampleIndirect.rgb += tex2D(ScnSamp, sampleOffset).rgb * occlustion / SSAO_SAMPLER_COUNT;
                sampleIndirect *= attenuationTerm(samplePosition, viewPosition, float3(1, 0.5, 0.0));
                
                sampleWeight += 1.0;
            }
        }
    }

    return sampleIndirect;
}

float SSGIBlurWeight(float2 coord, float r, float center_d)
{
    const float blurSharpness = SSGI_BLUR_SHARPNESS;
    const float blurSigma = SSGI_BLUR_RADIUS * 0.5f;
    const float blurFalloff = 1.0f / (2.0f * blurSigma * blurSigma);

    float d = linearizeDepth(coord);
    float ddiff = (d - center_d) * blurSharpness;
    return exp2(-r * r * blurFalloff - ddiff * ddiff);
}

float4 SSGIBlur(in float2 coord : TEXCOORD0, uniform sampler smp, uniform float2 offset) : COLOR
{
    float center_d = linearizeDepth(coord);

    float4 total_c = tex2D(smp, coord);
    float total_w = 1.0f;

    [unroll]
    for (int r = 1; r < SSGI_BLUR_RADIUS; r++)
    {
        float2 offset1 = coord + offset * r;
        float2 offset2 = coord - offset * r;

        float bilateralWeight1 = SSGIBlurWeight(offset1, r, center_d);
        float bilateralWeight2 = SSGIBlurWeight(offset2, r, center_d);

        total_c += tex2D(smp, offset1) * bilateralWeight1;
        total_c += tex2D(smp, offset2) * bilateralWeight2;

        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
    }

    return float4(total_c.rgb / total_w, 1);
}

#endif