shared texture2D SSAOMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "R16F";
#endif
>;
texture2D SSAOMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "R16F";
#endif
>;
sampler SSAOMapSamp = sampler_state {
    texture = <SSAOMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler SSAOMapSampTemp = sampler_state {
    texture = <SSAOMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

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

float2 tapLocation(int index, float noise)
{
    float alpha = 2.0 * PI * 7 / SSAO_SAMPLER_COUNT;
    float angle = (index + noise) * alpha;
    float radius = (mSSAORadiusM - mSSAORadiusP + 1) * 16;
    float2 radiusStep = ((ViewportSize.x / radius) / ViewportSize) / SSAO_SAMPLER_COUNT;
    return float2(cos(angle), sin(angle)) * (index * radiusStep + ViewportOffset2);
}

float4 SSAO(in float2 coord : TEXCOORD0) : COLOR
{
    float3 viewPosition = GetPosition(coord);
    float3 viewNormal = GetNormal(coord);

    float sampleNoise = GetJitterOffset(int2(coord * ViewportSize));
    
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

    return saturate(1 - sampleAmbient / sampleWeight);
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