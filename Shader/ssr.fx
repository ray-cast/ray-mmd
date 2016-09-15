shared texture SSRDownsampleX1Map: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX1MapTemp: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX2Map: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX2MapTemp: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX3Map: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX3MapTemp: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX4Map: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRDownsampleX4MapTemp: RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
shared texture SSRCompositionMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8";
>;
sampler SSRDownsampleX1Samp = sampler_state {
    texture = <SSRDownsampleX1Map>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX2Samp = sampler_state {
    texture = <SSRDownsampleX2Map>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX3Samp = sampler_state {
    texture = <SSRDownsampleX3Map>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX4Samp = sampler_state {
    texture = <SSRDownsampleX4Map>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX1SampTemp = sampler_state {
    texture = <SSRDownsampleX1MapTemp>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX2SampTemp = sampler_state {
    texture = <SSRDownsampleX2MapTemp>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX3SampTemp = sampler_state {
    texture = <SSRDownsampleX3MapTemp>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRDownsampleX4SampTemp = sampler_state {
    texture = <SSRDownsampleX4MapTemp>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};
sampler SSRCompositionSamp = sampler_state {
    texture = <SSRCompositionMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

float cb_zThickness = 1.0;
float cb_maxDistance = 1000.0;
float cb_nearPlaneZ = 0.1;
float cb_stride = 0.0;
float cb_strideZCutoff = 0.002;
float cb_maxSteps = 64;

bool intersectsDepthBuffer(float z, float minZ, float maxZ)
{
     float depthScale = min(1.0f, z * cb_strideZCutoff);
     z += cb_zThickness + lerp(0.0f, 2.0f, depthScale);
     return (maxZ >= z) && (minZ - cb_zThickness <= z);
}
 
void swap(inout float a, inout float b)
{
     float t = a;
     a = b;
     b = t;
}

bool TraceScreenSpaceRay2(float3 viewPosition, float3 viewDirection, float jitter, inout float2 hitPixel)
{
    float maxReflectLength = 1.5 * viewPosition.z * 0.5;
    float rayLength = ((viewPosition.z + viewDirection.z * maxReflectLength) < cb_nearPlaneZ) ? (cb_nearPlaneZ - viewPosition.z) / viewDirection.z : maxReflectLength;
    
    float3 startPosition = viewPosition;
    float3 endPosition = viewPosition + viewDirection * rayLength;

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

    float rayZMin = viewPosition.z;
    float rayZMax = viewPosition.z;
    float rayZMaxEstimate = viewPosition.z;
    float rayZDepth = rayZMax;
    
    const int numSamples = SSR_SAMPLER_COUNT;
    const float stepSize = 1.0 / numSamples;
    
    float bestLen = stepSize;
    
    [unroll(numSamples)]
    for (;; bestLen += stepSize)
    {
        float4 projPos = startScreenPos + deltaScreenPos * bestLen;
        projPos.xy /= projPos.w;
        
        rayZMin = rayZMaxEstimate;
        rayZMaxEstimate = rayZMax = projPos.z;
        rayZDepth = tex2D(Gbuffer4Map, projPos.xy).r;
        
        if (rayZMin > rayZMax)
        {
            swap(rayZMin, rayZMax);
        }

        if (intersectsDepthBuffer(rayZDepth, rayZMin, rayZMax))
        {
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
    
    return intersectsDepthBuffer(rayZDepth, rayZMin, rayZMax) * (bestLen > 0 ? 1 : 0);
}

void ScreenSpaceReflectVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float3 oViewdir : TEXCOORD1,
    out float4 oPosition  : POSITION,
    uniform int n)
{
    oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy * n;
    oViewdir = mul(Position, matProjectInverse).xyz;
    oPosition = Position;
}

float4 ScreenSpaceReflectPS(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR 
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);
        
    clip(-material.normal.z);
    
    float3 V = normalize(viewdir);
    
    float linearDepth = tex2D(Gbuffer4Map, coord).r;
    
    float3 viewPosition = viewdir * linearDepth;
    float3 viewReflect = normalize(reflect(V, material.normal));
    
    float2 hitPixel = 0;
    if (TraceScreenSpaceRay2(viewPosition, viewReflect, 0.0, hitPixel))
    {
        float4 color = 0;
        color.rgb = tex2D(OpaqueSamp, hitPixel.xy).rgb;
        color.a = dot(viewReflect, V);
        return color;
    }

    return 0;
}

float4 SSRGaussionBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset, uniform int n) : COLOR
{
    float weight = 0.0;
    float4 color = 0.0f;
    
    for (int i = 0; i < n; ++i)
    {
        float w = 0.39894 * exp(-0.5 * i * i / (n * n)) / n;
        color += tex2D(source, coord + offset * i) * w;
        color += tex2D(source, coord - offset * i) * w;
        weight += 2.0 * w;
    }

    return color / weight;
}

float4 SSRCompositionPS(in float2 coord : TEXCOORD0, in float3 viewdir : TEXCOORD1) : COLOR
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);
    
    float gloss = material.smoothness;
    gloss *= gloss;

    float weight = frac(min(gloss, 0.9999) * 3);

    float4 refl0 = tex2D(SSRDownsampleX1Samp, coord);
    float4 refl1 = tex2D(SSRDownsampleX2Samp, coord);
    float4 refl2 = tex2D(SSRDownsampleX3Samp, coord);
    float4 refl3 = tex2D(SSRDownsampleX4Samp, coord);

    float4 color = 0;
    
    if (gloss > 2.0 / 3.0)
        color = lerp(refl1, refl0, weight * weight);
    else if (gloss > 1.0 / 3.0)
        color = lerp(refl2, refl1, weight);
    else
        color = lerp(refl3, refl2, weight);
        
    float3 V = normalize(-viewdir);
        
    color.rgb *= EnvironmentSpecularUnreal4(material.normal, V, material.smoothness, material.specular);
    return color;
}