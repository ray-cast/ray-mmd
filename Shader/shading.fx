float DeriveSpecularOcclusion(float nv, float ao, float smoothness)
{
    return saturate(pow(nv + ao, smoothness) - 1 + ao);
}

float3 ShadingMaterial(float3 V, float3 L, MaterialParam material)
{
    float3 lighting = 0;
    
    float3 N = mul(material.normal, (float3x3)matViewInverse);
    
    float vis = saturate(dot(N, L));
    if (vis > 0)
    {
        if (material.lightModel == LIGHTINGMODEL_NORMAL || material.lightModel == LIGHTINGMODEL_EMISSIVE)
            lighting = DiffuseBRDF(N, L, V, material.smoothness);
        else if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
            lighting = TranslucencyBRDF(N, L, material.transmittance);

        lighting *= material.albedo;
        lighting += SpecularBRDF(N, L, V, material.smoothness, material.specular);
        lighting *= LightSpecular * vis * (1 + mDirectLightP * 10 - mDirectLightM);
    }
    
    return lighting;
}

float3 ShadingMaterial(float3 V, float3 L, float2 coord, MaterialParam material)
{
    float3 lighting = ShadingMaterial(V, L, material);
#if SHADOW_QUALITY > 0
    lighting *= tex2D(ShadowmapSamp, coord).r;
#endif
    return lighting;
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
    
    float3 V = mul(normalize(viewdir), (float3x3)matViewInverse);
    float3 L = normalize(-LightDirection);

    float3 lighting = 0;
    lighting += srgb2linear(tex2D(ScnSamp, coord).rgb);
    lighting += tex2D(LightingSampler, coord).rgb;
    lighting += ShadingMaterial(V, L, coord, material);
    
#if SSAO_SAMPLER_COUNT > 0
    float ssao = tex2D(SSAOMapSamp, coord).r;
    ssao = pow(ssao, mSSAOP - mSSAOM);
    lighting *= ssao;
#endif

#if (IBL_QUALITY > 1) && (ALHPA_ENABLE > 0)
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    
    float alphaDiffuse = 0;
    MaterialParam materialAlpha;
    DecodeGbufferWithAlpha(MRT5, MRT6, MRT7, materialAlpha, alphaDiffuse);
    
    float3 lighting2 = ShadingMaterial(V, L, materialAlpha);
    
    float3 diffuse;
    float3 diffuse2;
    DecodeYcbcr(EnvLightingSampler, coord, screenPosition, ViewportOffset2, diffuse, diffuse2);
    
    #if SHADOW_QUALITY > 0
        float shadow = lerp(1, tex2D(ShadowmapSamp, coord).r, mEnvShadowP);
        diffuse *= shadow;
        diffuse2 *= shadow;
    #endif

    #if SSAO_SAMPLER_COUNT > 0
        float diffOcclusion = ssao * ssao;
        diffuse *= diffOcclusion;
        diffuse2 *= diffOcclusion;
    #endif
    
    lighting = lerp(lighting + diffuse, lighting2 + diffuse2, alphaDiffuse);
    
#elif (IBL_QUALITY > 1) && (SSAO_SAMPLER_COUNT > 0)
    float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);

    float3 diffuse, specular;
    DecodeYcbcr(EnvLightingSampler, coord, screenPosition, ViewportOffset2, diffuse, specular);
    
    #if SHADOW_QUALITY > 0
        float shadow = lerp(1, tex2D(ShadowmapSamp, coord).r, mEnvShadowP);
        diffuse *= shadow;
        specular *= shadow;
    #endif

    #if SSAO_SAMPLER_COUNT > 0
        float diffOcclusion = ssao * ssao;
        float specOcclusion= DeriveSpecularOcclusion(abs(dot(worldNormal, V) + 1e-5), diffOcclusion, material.smoothness);
        diffuse *= diffOcclusion;
        specular *= specOcclusion;
    #endif
    
    lighting += (diffuse + specular);    
#elif IBL_QUALITY > 0
    float4 envLighting = tex2D(EnvLightingSampler, coord);
    
    #if SSAO_SAMPLER_COUNT > 0
        envLighting *= (ssao * ssao);
    #endif
    
    #if SHADOW_QUALITY > 0
        envLighting *= lerp(1, tex2D(ShadowmapSamp, coord).r, mEnvShadowP);
    #endif

    lighting += envLighting.rgb;
#endif

    return float4(lighting, 0.0);
}