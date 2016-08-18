float DeriveSpecularOcclusion(float nv, float ao, float smoothness)
{
    return saturate(pow(nv + ao, smoothness) - 1 + ao);
}

float EdgeFilter(float2 center, float2 a0, float2 a1, float2 a2, float2 a3)
{
    const float THRESH = 30./255.;
    float4 lum = float4(a0.x, a1.x , a2.x, a3.x);
    float4 w = 1.0 - step(THRESH, abs(lum - center.x));
    float W = w.x + w.y + w.z + w.w;
    w.x = (W == 0.0) ? 1.0 : w.x;
    W   = (W == 0.0) ? 1.0 : W;
    return (w.x * a0.y + w.y * a1.y + w.z * a2.y + w.w * a3.y) / W;
}

float4 DeferredLightingPS(
    in float2 coord: TEXCOORD0,
    in float3 viewdir: TEXCOORD1,
    in float4 screenPosition : SV_Position) : COLOR
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float3 background = tex2D(ScnSamp, coord).rgb;
    float3 lighting = background;
    if (material.lightModel != LIGHTINGMODEL_EMISSIVE)
    {
        lighting *= (lerp(1, 5, mDirectLightP) - mDirectLightM);
    }

#if SSAO_SAMPLER_COUNT > 0
        float4 ssgi = tex2D(SSAOMapSamp, coord);
        ssgi = pow(ssgi, mSSAOP + 1 - mSSAOM);
        lighting *= ssgi.a;
#   if SSAO_EANBLE_GI
        lighting += material.albedo * ssgi.rgb * (lerp(1, 5, mIndirectLightP) - mIndirectLightM);
#   endif
#endif

#if IBL_QUALITY > 0
    float4 envLighting = tex2D(EnvLightingSampler, coord);
#if (IBL_QUALITY >= 3) && (SSAO_SAMPLER_COUNT > 0)
    float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
    float3 worldView = mul(normalize(viewdir), (float3x3)matViewInverse);

    float4 env2 = tex2D(EnvLightingSampler, coord + float2(ViewportOffset2.x, 0.0));
    float4 env3 = tex2D(EnvLightingSampler, coord - float2(ViewportOffset2.x, 0.0));
    float4 env4 = tex2D(EnvLightingSampler, coord + float2(0.0, ViewportOffset2.y));
    float4 env5 = tex2D(EnvLightingSampler, coord - float2(0.0, ViewportOffset2.y));
    env2.rg = EdgeFilter(envLighting.rg, env2.rg, env3.rg, env4.rg, env5.rg);
    env2.ba = EdgeFilter(envLighting.ba, env2.ba, env3.ba, env4.ba, env5.ba);

    float3 diffuse;
    float3 specular;
    bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));
    diffuse = (pattern) ? float3(envLighting.rg, env2.g) : float3(envLighting.r, env2.g, envLighting.g);
    specular = (pattern) ? float3(envLighting.ba, env2.a) : float3(envLighting.b, env2.a, envLighting.a);

    diffuse = ycbcr2rgb(diffuse);
    specular = ycbcr2rgb(specular);

#   if SSAO_SAMPLER_COUNT > 0
            float diffOcclusion = ssgi.a * ssgi.a;
            float specOcclusion= DeriveSpecularOcclusion(abs(dot(worldNormal, worldView) + 1e-5), diffOcclusion, material.smoothness);
            lighting += (diffuse * diffOcclusion + specular * specOcclusion);
#   else
            lighting += (diffuse + specular);
#   endif

#else
#   if SSAO_SAMPLER_COUNT > 0
        envLighting *= (ssgi.a * ssgi.a);
#   endif
    lighting += envLighting.rgb;
#endif

#endif
    return float4(lighting, 0.0);
}