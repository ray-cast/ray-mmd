#define SSGI_SAMPLER_COUNT 0
#define SSGI_BLUR_RADIUS 8
#define SSGI_BLUR_SHARPNESS 1

#if SSAO_MODE >= 2
shared texture2D SSAODepthMap : OFFSCREENRENDERTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "*.pmd = ./shadow/SSAO.fx;"
        "*.pmx = ./shadow/SSAO.fx;"
        "*=hide;";
>;
sampler SSAODepthMapSamp = sampler_state {
    texture = <SSAODepthMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

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
#if SSAO_MODE >= 2
    return tex2D(SSAODepthMapSamp, texcoord).a;
#else
    return tex2D(ShadingMapSamp, texcoord).a;
#endif
}

float3 GetPosition(float2 uv)
{
    float depth = linearizeDepth(uv);
    return ReconstructPos(uv, matProjectInverse, depth);
}

float3 GetNormal(float2 uv)
{
#if SSAO_MODE >= 2
    float4 MRT1 = tex2D(SSAODepthMapSamp, uv);
    return MRT1.xyz;
#else
    float4 MRT2 = tex2D(Gbuffer2Map, uv);
    float4 MRT6 = tex2D(Gbuffer6Map, uv);
    
    float linearDepth = tex2D(Gbuffer4Map, uv).r;
    float linearDepth2 = tex2D(Gbuffer8Map, uv).r;
    float4 MRT = linearDepth2 > 1.0 ? (linearDepth < linearDepth2 ? MRT2 : MRT6) : MRT2;
    return DecodeGBufferNormal(MRT);
#endif
}

float2 tapLocation(int index, float noise)
{
    float alpha = 2.0 * PI * 7 / SSAO_SAMPLER_COUNT;
    float angle = (index + noise) * alpha;
    float radius = (mSSAORadiusM - mSSAORadiusP + 1) * 16;
    float2 radiusStep = ((ViewportSize.x / radius) / ViewportSize) / SSAO_SAMPLER_COUNT;
    return float2(cos(angle), sin(angle)) * (index * radiusStep + ViewportOffset2);
}

float4 SSAO(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR
{
    float3 viewNormal = GetNormal(coord);
    float3 viewPosition = -viewdir * linearizeDepth(coord);

    float sampleWeight = 0.0f;
    float sampleAmbient = 0.0f;
    float sampleNoise = GetJitterOffset(int2(coord * ViewportSize));

    [unroll]
    for (int j = 0; j < SSAO_SAMPLER_COUNT; j++)
    {
        float2 sampleOffset = coord + tapLocation(j, sampleNoise); 
        float3 samplePosition = GetPosition(sampleOffset);
        float3 sampleDirection = samplePosition - viewPosition;

        float sampleLength2 = dot(sampleDirection, sampleDirection);
        float sampleAngle = dot(normalize(sampleDirection), viewNormal);

        if (sampleLength2 < SSAO_SPACE_RADIUS2)
        {
            float bias = 0.002;
            float occlustion  = saturate(sampleAngle - samplePosition.z * bias);
            
            sampleAmbient += occlustion;
            sampleWeight += 1.0;
        }
    }

    float ao = saturate(1 - sampleAmbient / sampleWeight);
    
    return pow(ao,  2 * ao + ao * ao * (mSSAOP * 10 - mSSAOM));
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

float4 SSAOBlur(in float2 coord : TEXCOORD0, uniform sampler source, uniform float2 offset) : SV_Target
{
    float center_d = linearizeDepth(coord);

    float total_c = tex2D(source, coord).r;
    float total_w = 1.0f;
    
    float2 offset1 = coord + offset;
    float2 offset2 = coord - offset;
    
    [unroll]
    for (int r = 1; r < SSAO_BLUR_RADIUS; r++)
    {
        float bilateralWeight1 = SSAOBlurWeight(offset1, r, center_d);
        float bilateralWeight2 = SSAOBlurWeight(offset2, r, center_d);

        total_c += tex2D(source, offset1).r * bilateralWeight1;
        total_c += tex2D(source, offset2).r * bilateralWeight2;
        
        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
        
        offset1 += offset;
        offset2 -= offset;
    }

    return total_c / total_w;
}

float4 SSAOApplyPS(in float2 coord : TEXCOORD0) : COLOR
{
    return tex2D(SSAOMapSamp, coord).r;
}

float4 SSGI(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR
{
    float3 viewNormal = GetNormal(coord);
    float3 viewPosition = -viewdir * linearizeDepth(coord);

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
            float4 MRT4 = tex2D(Gbuffer4Map, sampleOffset);

            MaterialParam material;
            DecodeGbuffer(MRT0, MRT1, MRT2,MRT4, material);
                
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

float4 SSGIBlur(in float2 coord : TEXCOORD0, uniform sampler source, uniform float2 offset) : COLOR
{
    float center_d = linearizeDepth(coord);

    float3 total_c = tex2D(source, coord).rgb;
    float total_w = 1.0f;

    [unroll]
    for (int r = 1; r < SSGI_BLUR_RADIUS; r++)
    {
        float2 offset1 = coord + offset * r;
        float2 offset2 = coord - offset * r;

        float bilateralWeight1 = SSGIBlurWeight(offset1, r, center_d);
        float bilateralWeight2 = SSGIBlurWeight(offset2, r, center_d);

        total_c += tex2D(source, offset1).rgb * bilateralWeight1;
        total_c += tex2D(source, offset2).rgb * bilateralWeight2;

        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
    }

    return float4(total_c / total_w, 1);
}