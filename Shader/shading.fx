float3 ShadingMaterial(float3 N, float3 V, float3 L, float2 coord, MaterialParam material)
{
    float3 lighting = 0;
    
    float3 R = reflect(-V, N);
    float3 D = L;
    float r = sin(0.000066);
    float d = cos(0.000066);
    float dr = dot(D, R);
    float3 S = normalize(R - dr * D);
    float3 L2 = dr < d ? normalize(d * D + S * r) : R;
    float illuminance = saturate(dot(N, D));

    float vis = saturate(dot(N, L));
    if (vis > 0)
    {
        if (material.lightModel == LIGHTINGMODEL_NORMAL || material.lightModel == LIGHTINGMODEL_EMISSIVE)
            lighting = DiffuseBRDF(N, L, V, material.smoothness);
        else if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
            lighting = TranslucencyBRDF(N, L, material.transmittance);

        lighting *= material.albedo;
        lighting += SpecularBRDF(N, L, V, material.smoothness, material.specular);
        lighting *= LightSpecular * vis * (1 + mDirectLightP * 10 - mDirectLightM) * any(material.albedo + material.specular);
        
#if SHADOW_QUALITY > 0
    lighting *= tex2D(ShadowmapSamp, coord).r;
#endif
    }
    
    return lighting;
}

#if FOG_ENABLE
float3 ApplySkyFog(float3 color, float distance, float3 V)
{
    float fogAmount = 1.0 - exp2(-distance * (mFogSky / 1000));
    float sunAmount = saturate(dot(V, LightDirection));
    float3 sunColor = lerp(float3(mFogR, mFogG, mFogB), float3(mFogSkyR, mFogSkyG, mFogSkyB), mFogSkyTwoColor);
    float3 fogColor = lerp(float3(mFogR, mFogG, mFogB), sunColor, sunAmount);
    return lerp(color, fogColor, fogAmount);
}

float3 ApplyGroundFog(float3 color, float distance, float3 P)
{
    float fog = 1.0 - exp(-distance * P.y * (mFogHeight / 5000));
    float fogAmount = saturate(mFogDensity * exp(-CameraPosition.y * (mFogHeight / 5000)) * fog / P.y);
    float3 fogColor = float3(mFogR, mFogG, mFogB);
    fogAmount = pow(fogAmount, max(1 - mFogRadius, 0.01));
    return lerp(color, fogColor, fogAmount);
}
#endif

float4 DeferredShadingPS(in float2 coord: TEXCOORD0, in float3 viewdir: TEXCOORD1, in float4 screenPosition : SV_Position) : COLOR
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);
    
    float3 V = normalize(mul(viewdir, (float3x3)matViewInverse));
    float3 N = mul(material.normal, (float3x3)matViewInverse);
    float3 L = normalize(-LightDirection);

    float3 lighting = 0;
    lighting += srgb2linear(tex2D(ScnSamp, coord).rgb);
    lighting += tex2D(LightMapSamp, coord).rgb;
    lighting += ShadingMaterial(N, V, L, coord, material);
    
#if SSAO_SAMPLER_COUNT > 0
    float ssao = tex2D(SSAOMapSamp, coord).r;
    ssao = pow(ssao, 1 + mSSAOP * 10 - mSSAOM);
    lighting *= ssao;
#endif
    
#if IBL_QUALITY > 0
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    
    float alphaDiffuse = 0;
    MaterialParam materialAlpha;
    DecodeGbufferWithAlpha(MRT5, MRT6, MRT7, materialAlpha, alphaDiffuse);
    
    float3 N2 = mul(materialAlpha.normal, (float3x3)matViewInverse);
    float3 lighting2 = ShadingMaterial(N2, V, L, coord, materialAlpha);
    
    float3 diffuse;
    float3 diffuse2;
#if IBL_QUALITY == 1
    DecodeYcbcrBilinearFilter(EnvLightMapSamp, coord, screenPosition, ViewportOffset2, diffuse, diffuse2);
#else
    DecodeYcbcrWithEdgeFilter(EnvLightMapSamp, coord, screenPosition, ViewportOffset2, diffuse, diffuse2);
#endif

#if SSAO_SAMPLER_COUNT > 0
    float diffOcclusion = ssao * ssao;
    #if IBL_QUALITY == 1
        diffuse *= diffOcclusion;
        diffuse2 *= diffOcclusion;
    #else
        float specOcclusion = ComputeSpecularOcclusion(dot(N, V), diffOcclusion, material.smoothness);
        diffuse *= (diffOcclusion + specOcclusion) * 0.5;
        diffuse2 *= (diffOcclusion + specOcclusion) * 0.5;
    #endif
#endif

#if SHADOW_QUALITY > 0
    float shadow = lerp(1, tex2D(ShadowmapSamp, coord).r, mEnvShadowP);
    diffuse *= shadow;
    diffuse2 *= shadow;
#endif
    
    lighting = lerp(lighting + diffuse, lighting2 + diffuse2, alphaDiffuse);
#endif

#if FOG_ENABLE
    float distance = tex2D(Gbuffer4Map, coord).r;
    
    float3 P = mul(float4(-viewdir * distance, 1), matViewInverse).xyz;
    
    lighting = ApplyGroundFog(lighting, distance, P);
    lighting = ApplySkyFog(lighting, distance, V);
#endif

#if SSR_QUALITY > 0
    float linearDepth = tex2D(Gbuffer4Map, coord).r;
    float linearDepth2 = tex2D(Gbuffer8Map, coord).r;
    linearDepth = linearDepth2 > 1.0 ? min(linearDepth, linearDepth2) : linearDepth;

    return float4(lighting, linearDepth);
#else
    return float4(lighting, 0.0f);
#endif
}