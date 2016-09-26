#if SSR_QUALITY == 1
#   define SSR_SAMPLER_COUNT 32
#elif SSR_QUALITY == 2
#   define SSR_SAMPLER_COUNT 64
#elif SSR_QUALITY >= 3
#   define SSR_SAMPLER_COUNT 128
#else
#   define SSR_SAMPLER_COUNT 32
#endif

shared texture SSRayTracingMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A16B16G16R16F";
>;
texture SSRLightMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A2R10G10B10";
    int Miplevels = 0;
    bool AntiAlias = false;
>;
texture SSRLightMapTemp: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A2R10G10B10";
>;
sampler SSRayTracingSamp = sampler_state {
    texture = <SSRayTracingMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRLightSamp = sampler_state {
    texture = <SSRLightMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRLightSampTemp = sampler_state {
    texture = <SSRLightMapTemp>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

static float thickness = (1.0 + mSSRThickness);
static float strideZCutoff = 1 / ((1 + mSSRStrideZCutoff * 1000));
static float fadeEnd = 1.0 - mSSRFadeEnd;
static float fadeStart = 0.3 + mSSRFadeStart;
static float fadeDiffRcp = 1.0f / max(0.01, fadeEnd - fadeStart);

bool intersectsDepthBuffer(float z, float minZ, float maxZ)
{
     float depthScale = min(1.0f, z * strideZCutoff);
     z += thickness + lerp(0.0f, 2.0f, depthScale);
     return (maxZ >= z) && (minZ - thickness <= z);
}
 
void swap(inout float a, inout float b)
{
     float t = a;
     a = b;
     b = t;
}

float specularPowerToConeAngle(float specularPower)
{
    const float xi = 0.244f;
    float exponent = 1.0f / (specularPower + 1.0f);
    return acos(pow(xi, exponent));
}
 
float isoscelesTriangleOpposite(float adjacentLength, float coneTheta)
{
    return 2.0f * tan(coneTheta) * adjacentLength;
}
 
float isoscelesTriangleInRadius(float a, float h)
{
    float a2 = a * a;
    float fh2 = 4.0f * h * h;
    return (a * (sqrt(a2 + fh2) - a)) / (4.0f * h);
}
 
float isoscelesTriangleNextAdjacent(float adjacentLength, float incircleRadius)
{
    return adjacentLength - (incircleRadius * 2.0f);
}

bool TraceScreenSpaceRay(float3 viewPosition, float3 viewReflect, float maxDistance, float stride, float jitter, out float2 hitPixel)
{   
    float3 startPosition = viewPosition;
    float3 endPosition = viewPosition + viewReflect * maxDistance;

    float4 startScreenPos = mul(float4(startPosition, 1), matProject);
    float4 endScreenPos = mul(float4(endPosition, 1), matProject);
    
    float3 startDirection = startPosition / startScreenPos.w;
    float3 endDirection = endPosition / endScreenPos.w;
    
    float4 startTexcoord = float4(PosToCoord(startScreenPos.xy / startScreenPos.w), startScreenPos.zw);
    float4 endTexcoord = float4(PosToCoord(endScreenPos.xy / endScreenPos.w), endScreenPos.zw);

    startScreenPos.xy = startScreenPos.xy * float2(0.5, -0.5) + 0.5 * startScreenPos.w;
    endScreenPos.xy = endScreenPos.xy * float2(0.5, -0.5) + 0.5 * endScreenPos.w;
    
    float4 deltaScreenPos = endScreenPos - startScreenPos;
    float4 deltaTexcoord = endTexcoord - startTexcoord;

    deltaScreenPos *= stride;
    deltaTexcoord *= stride;

    startScreenPos += deltaScreenPos * jitter;
    startTexcoord += deltaTexcoord * jitter;
    
    const int numSamples = SSR_SAMPLER_COUNT;
    const float stepSize = 1.0 / numSamples;
    const float intervalSize = maxDistance / (numSamples * 1.6) * thickness;
    
    float len = stepSize;
    float bestLen = 0;
    
    for (int i = 0; i < numSamples; i++, len += stepSize)
    {
        float4 projPos = startScreenPos + deltaScreenPos * len;
        projPos.xy /= projPos.w;
        
        float depth = tex2D(ShadingMapSamp, projPos.xy).a;
        
        if (abs(depth - projPos.z) < intervalSize)
        {
            bestLen = len;
            break;
        }
    }
    
    float4 projPos = startScreenPos + deltaScreenPos * bestLen;
    projPos.xy /= projPos.w;
    
    hitPixel = projPos.xy;
    
    if (hitPixel.x < 0.0 || hitPixel.x > 1.0 || hitPixel.y < 0.0 || hitPixel.y > 1.0)
    {
        bestLen = 0;
    }
    
    return bestLen > 0 ? 1 : 0;
}

float4 SSRayTracingPS(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR 
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    clip(-material.normal.z);
    
    float linearDepth = tex2D(ShadingMapSamp, coord).a;

    float3 V = normalize(-viewdir);    
    float3 viewPosition = V * linearDepth / V.z;
    float3 viewReflect = normalize(reflect(V, material.normal));
    
    float maxDistance = viewPosition.z * (1.5 + mSSRRangeP - mSSRRangeM);
    
    float strideScale = 1.0f - min(1.0f, viewPosition.z * strideZCutoff);
    float stride = 1.0f + strideScale * mSSRStride;
    float jitter = GetJitterOffset((int2)coord * ViewportSize) * 0.02 * mSSRJitter;
    
    float atten = dot(viewReflect, V);
    if (atten <= 0)
    {
        clip(-1);
    }
    
    float2 hitPixel = 0;
    if (!TraceScreenSpaceRay(viewPosition, viewReflect, maxDistance, stride, jitter, hitPixel))
    {
        clip(-1);
    }

    float4 color = 0;
    color.rg = hitPixel.xy;
    color.b = tex2D(Gbuffer4Map, hitPixel).r;
    color.a = dot(viewReflect, V);
    return color;
}

float4 SSRGaussionBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : COLOR
{
    static const float2 offsets[7] = {{-3, -3}, {-2, -2}, {-1, -1}, {0, 0}, {1, 1}, {2, 2}, {3, 3}};
    static const float weights[7] = {0.001f, 0.028f, 0.233f, 0.474f, 0.233f, 0.028f, 0.001f};
 
    float4 color = 0.0;
    
    [unroll]
    for(uint i = 0u; i < 7u; ++i)
    {
        color += tex2D(source, coord + offset * offsets[i]) * weights[i];
    }
    
    return color;
}

float4 SSRConeTracingPS(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR
{
    float4 rayTracing = tex2D(SSRayTracingSamp, coord);
#if defined(MIKUMIKUMOVING)
    clip(rayTracing.w - 1e-5);
#endif

    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);
    
    float linearDepth = tex2D(Gbuffer4Map, coord).r;
    
    float3 V = normalize(viewdir);
    float3 viewPosition = V * linearDepth / V.z;
    
    float roughness = SmoothnessToRoughness(material.smoothness);
    float specularPower = RoughnessToShininess(roughness);
    float coneTheta = specularPowerToConeAngle(specularPower) * 0.5f;
    
    float2 deltaTexcoord = rayTracing.xy - coord;
    
    float  adjacentLength = length(deltaTexcoord);
    float2 adjacentUnit = deltaTexcoord / adjacentLength;
    
    float4 totalColor = 0.0;
    
    float remainingAlpha = 1.0f;
    float maxMipLevel = 6;
    
    float gloss = material.smoothness;
    float glossMult = gloss;
    
    for (int i = 0; i < 14; ++i)
    {
        float oppositeLength = isoscelesTriangleOpposite(adjacentLength, coneTheta);
        float incircleSize = isoscelesTriangleInRadius(oppositeLength, adjacentLength);

        float2 samplePos = coord + adjacentUnit * (adjacentLength - incircleSize);
        float mipChannel = clamp(log2(incircleSize * ViewportSize.x), 0.0f, maxMipLevel);

        float4 newColor = float4(tex2Dlod(SSRLightSamp, float4(samplePos, 0, mipChannel)).rgb, 1) * glossMult;

        remainingAlpha -= newColor.a;
        if (remainingAlpha < 0.0f)
        {
            newColor.rgb *= (1.0f - abs(remainingAlpha));
        }
        
        totalColor += newColor;

        if (totalColor.a >= 1.0f)
        {
            break;
        }

        adjacentLength = isoscelesTriangleNextAdjacent(adjacentLength, incircleSize);
        glossMult *= gloss;
    }
    
    float maxDistance = 500 + 500 * mSSRFadeDistance;
    
    float3 fresnel = EnvironmentSpecularUnreal4(material.normal, V, material.smoothness, material.specular);

    float2 boundary = abs(rayTracing.xy - float2(0.5f, 0.5f)) * 2.0f;
    float fadeOnBorder = 1.0f - saturate((boundary.x - fadeStart) * fadeDiffRcp);
    fadeOnBorder *= 1.0f - saturate((boundary.y - fadeStart) * fadeDiffRcp);
    fadeOnBorder = smoothstep(0.0f, 1.0f, fadeOnBorder);
    
    float3 rayHitPositionVS = mul(float4(CoordToPos(rayTracing.xy), rayTracing.z, 1.0), matProjectInverse).xyz;
    float fadeOnDistance = 1.0f - saturate(distance(rayHitPositionVS, viewPosition) / maxDistance);
    float fadeOnPerpendicular = saturate(lerp(0.0f, 1.0f, saturate(rayTracing.w * 4.0f)));
    float fadeOnRoughness = saturate(lerp(0.0f, 1.0f, gloss * 4.0f));
    float totalFade = fadeOnBorder * fadeOnDistance * fadeOnPerpendicular * fadeOnRoughness * (1.0f - saturate(remainingAlpha));

    return float4(totalColor.rgb * fresnel, totalFade);
}