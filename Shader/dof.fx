const float2 dofEqWorld;
const float2 dofEqWeapon;
const float2 dofRowDelta;
float4 dofLerpScale;
float4 dofLerpBias;
float3 dofEqFar;

void DofDownVS(
    in float4 pos : POSITION, 
    in float2 coord : TEXCOORD0,
    out float2 oColor0 : TEXCOORD0,
    out float2 oColor1 : TEXCOORD1,
    out float2 oDepth0 : TEXCOORD2,
    out float2 oDepth1 : TEXCOORD3,
    out float2 oDepth2 : TEXCOORD4,
    out float2 oDepth3 : TEXCOORD5,
    out float4 oPosition : POSITION,
    uniform float2 offset)
{
    oPosition = pos;
    oColor0 = coord + float2(-1.0, -1.0) * offset;
    oColor1 = coord + float2(+1.0, -1.0) * offset;
    oDepth0 = coord + float2(-1.5, -1.5) * offset;
    oDepth1 = coord + float2(-0.5, -1.5) * offset;
    oDepth2 = coord + float2(+0.5, -1.5) * offset;
    oDepth3 = coord + float2(+1.5, -1.5) * offset;
}

float4 DofDownPS(
    in float2 color0 : TEXCOORD0,
    in float2 color1 : TEXCOORD1,
    in float2 depth0 : TEXCOORD2,
    in float2 depth1 : TEXCOORD3,
    in float2 depth2 : TEXCOORD4,
    in float2 depth3 : TEXCOORD5,
    uniform sampler source) : COLOR
{
    float3 color;
    float maxCoc;
    float4 depth;
    float4 viewCoc;
    float4 sceneCoc;
    float4 curCoc;
    float4 coc;
    float2 rowOfs[4];

    rowOfs[0] = 0;
    rowOfs[1] = dofRowDelta.xy;
    rowOfs[2] = dofRowDelta.xy * 2;
    rowOfs[3] = dofRowDelta.xy * 3;

    color = 0;
    color += tex2D(source, color0.xy + rowOfs[0]).rgb;
    color += tex2D(source, color1.xy + rowOfs[0]).rgb;
    color += tex2D(source, color0.xy + rowOfs[2]).rgb;
    color += tex2D(source, color1.xy + rowOfs[2]).rgb;
    color /= 4;

    depth[0] = tex2D(Gbuffer4Map, depth0.xy + rowOfs[0]).r;
    depth[1] = tex2D(Gbuffer4Map, depth1.xy + rowOfs[0]).r;
    depth[2] = tex2D(Gbuffer4Map, depth2.xy + rowOfs[0]).r;
    depth[3] = tex2D(Gbuffer4Map, depth3.xy + rowOfs[0]).r;
    
    viewCoc = saturate( dofEqWeapon.x * -depth + dofEqWeapon.y );
    sceneCoc = saturate( dofEqWorld.x * depth + dofEqWorld.y );
    curCoc = min( viewCoc, sceneCoc );
    coc = curCoc;
    
    depth[0] = tex2D(Gbuffer4Map, depth0.xy + rowOfs[1]).r;
    depth[1] = tex2D(Gbuffer4Map, depth1.xy + rowOfs[1]).r;
    depth[2] = tex2D(Gbuffer4Map, depth2.xy + rowOfs[1]).r;
    depth[3] = tex2D(Gbuffer4Map, depth3.xy + rowOfs[1]).r;
    
    viewCoc = saturate(dofEqWeapon.x * -depth + dofEqWeapon.y);
    sceneCoc = saturate(dofEqWorld.x * depth + dofEqWorld.y);
    curCoc = min( viewCoc, sceneCoc );
    coc = max( coc, curCoc );
    
    depth[0] = tex2D(Gbuffer4Map, depth0.xy + rowOfs[2]).r;
    depth[1] = tex2D(Gbuffer4Map, depth1.xy + rowOfs[2]).r;
    depth[2] = tex2D(Gbuffer4Map, depth2.xy + rowOfs[2]).r;
    depth[3] = tex2D(Gbuffer4Map, depth3.xy + rowOfs[2]).r;
    
    viewCoc = saturate( dofEqWeapon.x * -depth + dofEqWeapon.y );
    sceneCoc = saturate( dofEqWorld.x * depth + dofEqWorld.y );
    curCoc = min( viewCoc, sceneCoc );
    coc = max( coc, curCoc );
    
    depth[0] = tex2D(Gbuffer4Map, depth0.xy + rowOfs[3]).r;
    depth[1] = tex2D(Gbuffer4Map, depth1.xy + rowOfs[3]).r;
    depth[2] = tex2D(Gbuffer4Map, depth2.xy + rowOfs[3]).r;
    depth[3] = tex2D(Gbuffer4Map, depth3.xy + rowOfs[3]).r;
    
    viewCoc = saturate(dofEqWeapon.x * -depth + dofEqWeapon.y);
    sceneCoc = saturate(dofEqWorld.x * depth + dofEqWorld.y);    
    curCoc = min(viewCoc, sceneCoc);
    coc = max(coc, curCoc);
       
    return float4(color, coc.r);
}

float4 DofNearCoc(const float2 coord : TEXCOORD0, uniform sampler shrunkSampler, uniform sampler blurredSampler) : COLOR
{  
    float4 blurred = tex2D(blurredSampler, coord); 
    float4 shrunk = tex2D(shrunkSampler, coord);
    
    float3 color = shrunk.rgb;
    float coc = 2 * max(blurred.a, shrunk.a) - shrunk.a;
    
    return float4(color, coc);
}

void SmallBlurVS(
    in float4 position : POSITION, 
    in float4 texcoord : TEXCOORD0,
    out float4 oTexcoord : TEXCOORD0,
    out float4 oPosition : POSITION,
    uniform float2 offset)
{
    oPosition = position;
    oTexcoord = texcoord.xxyy + offset.xxyy * float4(-0.5, 0.5, -0.5, 0.5);
}

float4 SmallBlurPS(in float4 coord : TEXCOORD0, uniform sampler source)
{
    float4 color = 0;
    color += tex2D(source, coord.xz);
    color += tex2D(source, coord.yz);
    color += tex2D(source, coord.xw);
    color += tex2D(source, coord.yw);
    return color / 4;
}

float4 InterpolateDof(float3 small, float3 med, float3 large, float t)
{
  float4 weights;
  float3 color;
  float  alpha;

  weights = saturate( t * dofLerpScale + dofLerpBias );
  weights.yz = min( weights.yz, 1 - weights.xy );

  color = weights.y * small + weights.z * med + weights.w * large;
  alpha = dot( weights.yzw, float3( 16.0 / 17, 1.0, 1.0 ) );
  
  return float4(color, alpha);
}

float4 ApplyDepthOfField(
    in float2 coord : TEXCOORD0,
    uniform sampler source, 
    uniform sampler smallBlurSampler, 
    uniform sampler largeBlurSampler, 
    uniform float2 offset)
{   
    const float weight = 4.0 / 17;
    
    float3 small = 0;
    small += weight * tex2D(source, coord + offset * float2(+0.5, -1.5)).rgb;
    small += weight * tex2D(source, coord + offset * float2(-1.5, -0.5)).rgb;
    small += weight * tex2D(source, coord + offset * float2(-0.5, +1.5)).rgb;
    small += weight * tex2D(source, coord + offset * float2(+1.5, +0.5)).rgb;
    
    float4 med = tex2D(smallBlurSampler, coord);
    float3 large = tex2D(largeBlurSampler, coord).rgb;
    float depth = tex2D(Gbuffer4Map, coord).r;    
    float nearCoc = med.a;    

    float coc;
    
    if (depth > 1.0e6)
    {
        coc = nearCoc;
    }
    else
    {
        float farCoc = saturate( dofEqFar.x * depth + dofEqFar.y );
        coc = max(nearCoc, farCoc * dofEqFar.z);
    }
    
    return InterpolateDof(small, med.rgb, large, coc);
}