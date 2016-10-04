#if SSAO_QUALITY == 1
#   define SSAO_SAMPLER_COUNT 8
#elif SSAO_QUALITY == 2
#   define SSAO_SAMPLER_COUNT 12
#elif SSAO_QUALITY >= 3
#   define SSAO_SAMPLER_COUNT 16
#else
#   define SSAO_SAMPLER_COUNT 16
#endif

#define SSAO_SPACE_RADIUS 10
#define SSAO_SPACE_RADIUS2 SSAO_SPACE_RADIUS * SSAO_SPACE_RADIUS
#define SSAO_BLUR_RADIUS 8
#define SSGI_SAMPLER_COUNT 0
#define SSGI_BLUR_RADIUS 8

shared texture SSAOMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "L8";
#endif
>;
texture SSAOMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "L8";
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

float linearizeDepth(float2 uv)
{
    return tex2D(DepthMapSamp, uv).g;
}

float3 GetPosition(float2 uv)
{
    float depth = linearizeDepth(uv);
    return ReconstructPos(uv, matProjectInverse, depth);
}

float3 GetNormal(float2 uv)
{
    float4 MRT2 = tex2D(Gbuffer2Map, uv);
    float4 MRT6 = tex2D(Gbuffer6Map, uv);
    
    float linearDepth = tex2D(Gbuffer4Map, uv).r;
    float linearDepth2 = tex2D(Gbuffer8Map, uv).r;
    float4 MRT = linearDepth2 > 1.0 ? (linearDepth < linearDepth2 ? MRT2 : MRT6) : MRT2;
    return DecodeGBufferNormal(MRT);
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
    
    if (viewPosition.z < 0.0)
    {
        return 1.0;
    }

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
    
    return pow(ao,  1 + ao + ao * ao * (mSSAOP * 10 - mSSAOM));
}

float4 SSAOBlur(in float2 coord : TEXCOORD0, uniform sampler source, uniform float2 offset) : SV_Target
{
    float center_d = abs(linearizeDepth(coord));

    float total_c = tex2D(source, coord).r;
    float total_w = 1.0f;
    
    float2 offset1 = coord + offset;
    float2 offset2 = coord - offset;
    
    [unroll]
    for (int r = 1; r < SSAO_BLUR_RADIUS; r++)
    {
        float depth1 = abs(linearizeDepth(offset1));
        float depth2 = abs(linearizeDepth(offset2));
        
        float bilateralWeight1 = BilateralWeight(r, depth1, center_d, SSAO_BLUR_RADIUS, 1);
        float bilateralWeight2 = BilateralWeight(r, depth2, center_d, SSAO_BLUR_RADIUS, 1);

        total_c += tex2D(source, offset1).r * bilateralWeight1;
        total_c += tex2D(source, offset2).r * bilateralWeight2;
        
        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
        
        offset1 += offset;
        offset2 -= offset;
    }

    return total_c / total_w;
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

float4 SSGIBlur(in float2 coord : TEXCOORD0, uniform sampler source, uniform float2 offset) : COLOR
{
    float center_d = linearizeDepth(coord);

    float4 total_c = tex2D(source, coord);
    float total_w = 1.0f;

    float2 offset1 = coord + offset;
    float2 offset2 = coord - offset;

    [unroll]
    for (int r = 1; r < SSGI_BLUR_RADIUS; r++)
    {       
        float depth1 = abs(linearizeDepth(offset1));
        float depth2 = abs(linearizeDepth(offset2));

        float bilateralWeight1 = BilateralWeight(r, depth1, center_d, SSGI_BLUR_RADIUS, 1);
        float bilateralWeight2 = BilateralWeight(r, depth2, center_d, SSGI_BLUR_RADIUS, 1);

        total_c += tex2D(source, offset1) * bilateralWeight1;
        total_c += tex2D(source, offset2) * bilateralWeight2;

        total_w += bilateralWeight1;
        total_w += bilateralWeight2;
        
        offset1 += offset;
        offset2 -= offset;
    }

    return total_c / total_w;
}