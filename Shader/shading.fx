bool ExistSkybox : CONTROLOBJECT<string name = "skybox.pmx";>;
bool ExistSkyboxHDR : CONTROLOBJECT<string name = "skybox_hdr.pmx";>;

float3 ShadingMaterial(float3 N, float3 V, float3 L, float2 coord, MaterialParam material)
{
    float3 lighting = 0;

    float vis = saturate(dot(N, L));
    if (vis > 0)
    {
        lighting = material.albedo * DiffuseBRDF(N, L, V, material.smoothness, material.transmittance);
        lighting += SpecularBRDF(N, L, V, material.smoothness, material.specular) * vis;
        lighting *= LightSpecular * (1 + mDirectLightP * 10 - mDirectLightM);
        lighting *= step(0, material.albedo + material.specular - 1e-5);
        
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
    float4 MRT3 = tex2D(Gbuffer4Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, MRT3, material);
    
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    float4 MRT8 = tex2D(Gbuffer8Map, coord);
    
    MaterialParam materialAlpha;
    DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);
        
    float3 V = mul(normalize(viewdir), (float3x3)matViewInverse);
    float3 P = mul(float4(-viewdir * material.linearDepth, 1), matViewInverse).xyz;
    float3 N = mul(material.normal, (float3x3)matViewInverse);
    float3 L = normalize(-LightDirection);

    float3 lighting = 0;
    lighting += tex2D(LightMapSamp, coord).rgb;
    lighting += ShadingMaterial(N, V, L, coord, material);
    
#if OUTDOORFLOOR_QUALITY > 0
    float floorVisiable = step(0.9, dot(N, float3(0, 1, 0)));
    float roughness = SmoothnessToRoughness(material.smoothness);
    float mipLevel = EnvironmentMip(roughness, 6);
    
    float4 floor = tex2Dlod(OutdoorShadingMapSamp, float4(coord, 0, mipLevel));
    floor.rgb *= floorVisiable;
    floor.rgb *= EnvironmentSpecularUnreal4(N, V, roughness, material.specular);
    floor.rgb *= P.y > 1 ? 0 : 1;
    lighting += floor * (1 + mFloorLightP * 10 - mFloorLightM);
#endif
    
#if SSAO_SAMPLER_COUNT > 0
    float ssao = tex2D(SSAOMapSamp, coord).r;
    if (materialAlpha.alpha < 0.01)
    {
        lighting *= ssao;
    }
#endif

    lighting += srgb2linear(tex2D(ScnSamp, coord).rgb);
    
    float3 N2 = mul(materialAlpha.normal, (float3x3)matViewInverse);
    float3 lighting2 = ShadingMaterial(N2, V, L, coord, materialAlpha);
#if SSAO_SAMPLER_COUNT > 0
    lighting2 *= ssao;
#endif

#if IBL_QUALITY > 0   
    float3 diffuse, diffuse2;
    float3 specular, specular2;
    
#if IBL_QUALITY == 1
    DecodeYcbcrBilinearFilter(EnvLightMapSamp, coord, screenPosition, ViewportOffset2, diffuse, diffuse2);
    DecodeYcbcrBilinearFilter(EnvLightSpecMapSamp, coord, screenPosition, ViewportOffset2, specular, specular2);
#else
    DecodeYcbcrWithEdgeFilter(EnvLightMapSamp, coord, screenPosition, ViewportOffset2, diffuse, diffuse2);
    DecodeYcbcrWithEdgeFilter(EnvLightSpecMapSamp, coord, screenPosition, ViewportOffset2, specular, specular2);
#endif

#if SHADOW_QUALITY > 0
    float shadow = lerp(1, tex2D(ShadowmapSamp, coord).r, mEnvShadowP);
    diffuse *= shadow;
    diffuse2 *= shadow;
    specular *= shadow;
    specular2 *= shadow;
#endif

#if OUTDOORFLOOR_QUALITY > 0
    specular *= floorVisiable < 1 ? 1 : 0;
#endif

#if SSAO_SAMPLER_COUNT > 0
    diffuse *= ssao;
    diffuse2 *= ssao;
    specular *= ComputeSpecularOcclusion(dot(N, V), ssao, material.smoothness);
    specular2 *= ComputeSpecularOcclusion(dot(N2, V), ssao, materialAlpha.smoothness);
#endif    

    if (ExistSkybox || ExistSkyboxHDR)
    {
        lighting += diffuse + specular;
        lighting2 += diffuse2 + specular2; 
    }
    
#endif

    lighting = lerp(lighting, lighting2, materialAlpha.alpha);

    float linearDepth = material.linearDepth;
    float linearDepth2 = materialAlpha.linearDepth;
    linearDepth = linearDepth2 > 1.0 ? min(linearDepth, linearDepth2) : linearDepth;

#if FOG_ENABLE
    float3 FogP = mul(float4(-viewdir * linearDepth, 1), matViewInverse).xyz;
    
    lighting = ApplyGroundFog(lighting, linearDepth, FogP);
    lighting = ApplySkyFog(lighting, linearDepth, V);
#endif
    
    return float4(lighting, linearDepth);
}