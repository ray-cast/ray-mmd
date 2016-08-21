#ifndef  _H_LIGHTING_H_
#define  _H_LIGHTING_H_

float SmoothnessToRoughness(float smoothness)
{
    return (1.0f - smoothness) * (1.0f - smoothness);
}

float RoughnessToSmoothness(float roughness)
{
    return 1.0f - sqrt(roughness);
}

float ShininessToSmoothness(float spec)
{
    // http://simonstechblog.blogspot.de/2011/12/microfacet-brdf.html
    return RoughnessToSmoothness(sqrt(2.0 / (spec + 2)));
}

float SmoothnessToShininess(float smoothness)
{
    float roughness = SmoothnessToRoughness(smoothness);
    return 2.0f / (roughness * roughness) - 2.0f;
}

float fresnelSchlick(float f0, float f9, float LdotH)
{
    return lerp(f0, f9, exp2((-5.55473 * LdotH - 6.98316) * LdotH));
}

float3 fresnelSchlick(float3 f0, float f9, float LdotH)
{
    return lerp(f0, f9, exp2((-5.55473 * LdotH - 6.98316) * LdotH));
}

float OrenNayarBRDF(float3 N, float3 L, float3 V, float roughness)
{
    float sigma2 = roughness * roughness;

    float nl = dot(N, L);
    float nv = dot(N, V);
    float lv = dot(L, V);

    float s = lv - nl * nv;
    float t = s <= 0 ? 1 : max(max(nl, nv), 1e-6);
    float A = 1.0 / (1.0 + (0.5 - 2.0 / (3.0 * PI)) * sigma2);
    float B = A * sigma2;

    return max(0, nl) * max(A + B * (s / t), 0);
}

float BurleyBRDF(float3 N, float3 L, float3 V, float roughness)
{
    float3 H = normalize(V + L);

    float energyBias = 0.5 * roughness;
    float energyFactor = lerp(1, 1 / 1.51, roughness);

    float nl = saturate(dot(N, L));
    float vh = saturate(dot(V, H));
    float nv = abs(dot(N, V)) + 1e-5h;

    float fd90 = energyBias + 2.0 * vh * vh * roughness;

    float FL = fresnelSchlick(1, fd90, nl);
    float FV = fresnelSchlick(1, fd90, nv);

    return FL * FV * energyFactor * nl;
}

float DiffuseBRDF(float3 N, float3 L, float3 V, float gloss)
{
    float roughness = SmoothnessToRoughness(gloss);
    return BurleyBRDF(N, L, V, roughness);
}

float3 TranslucencyBRDF(float3 N, float3 L, float3 transmittanceColor)
{
    float w = lerp(0, 0.5, luminance(transmittanceColor));
    float wn = 1.0 / ((1 + w) * (1 + w));
    float nl = dot(N, L);
    float transmittance = saturate((-nl + w) * wn);
    float diffuse = saturate((nl + w) * wn);
    return diffuse + transmittanceColor * transmittance;
}

float3 TranslucencyBRDF(float3 N, float3 L, float3 V, float smoothness, float3 transmittanceColor)
{
    float w = lerp(0, 0.5, luminance(transmittanceColor));
    float wn = 1.0 / ((1 + w) * (1 + w));
    float nl = dot(N, L);
    float transmittance = saturate((-nl + w) * wn);
    float brdf = DiffuseBRDF(N, L, V, smoothness);
    float diffuse = saturate((brdf + w) * wn);
    return diffuse + transmittanceColor * transmittance;
}

float3 SpecularBRDF_BlinnPhong(float3 N, float3 L, float3 V, float gloss, float3 f0)
{
    float3 H = normalize(L + V);

    float nh = saturate(dot(N, H));
    float nl = saturate(dot(N, L));
    float lh = saturate(dot(L, H));

    float alpha = exp2(10 * gloss + 1); // 2 - 2048
    float D =  ((alpha + 2) / 8) * exp2(alpha * InvLog2 * nh - alpha * InvLog2);

    float k = min(1.0f, gloss + 0.545f);
    float G = 1.0 / (k * lh * lh + 1 - k);

    float3 F = fresnelSchlick(f0, 1.0, lh);

    return D * F * G * nl;
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float m, float3 f0, float NormalizationFactor)
{
    float m2 = m * m;
    float3 H = normalize( V + L );

    float NdotH = saturate( dot( N, H ) );
    float NdotL = saturate( dot( N, L ) );
    float NdotV = abs( dot( N, V ) ) + 1e-5h;

    float spec = (NdotH * m2 - NdotH) * NdotH + 1;
    spec = m2 / (spec * spec) * NormalizationFactor;

    float Gv = NdotL * sqrt( (-NdotV * m2 + NdotV) * NdotV + m2 );
    float Gl = NdotV * sqrt( (-NdotL * m2 + NdotL) * NdotL + m2 );
    spec *= 0.5h / (Gv + Gl);

    f0 = max(0.04, f0);
    float f90 = saturate( dot( f0, 0.33333h ) / 0.02h );
    float3 fresnel = lerp( f0, f90, pow( 1 - saturate( dot( L, H ) ), 5 ) );

    return fresnel * spec * NdotL;
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float gloss, float3 f0)
{
    float roughness = SmoothnessToRoughness(gloss);
    return SpecularBRDF(N, L, V, roughness, f0, 1.0f);
}

void CubemapBoxParallaxCorrection(inout float3 R, in float3 P, in float3 envBoxCenter, in float3 envBoxMin, in float3 envBoxMax)
{
    float3 R2 = normalize(R.xyz);

    float3 rbmax = ((envBoxCenter + envBoxMax) - P) / R2;
    float3 rbmin = ((envBoxCenter + envBoxMin) - P) / R2;
    float3 rbminmax = (R2 > 0.0f) ? rbmax : rbmin;
    float3 posonbox = P + R * min(min(rbminmax.x, rbminmax.y), rbminmax.z);

    R = normalize(posonbox - envBoxCenter);
}

float EnvironmentMip(float gloss, int miplevel)
{
    return lerp(miplevel, 0, gloss);
}

float3 EnvironmentReflect(float3 normal, float3 view)
{
    return reflect(-view, normal);
}

float3 EnvironmentSpecularBlackOpsII(float3 N, float3 V, float gloss, float3 specular)
{
    float4 t = float4(1 / 0.96, 0.475, (0.0275 - 0.25 * 0.04) / 0.96, 0.25) * gloss;
    t += float4(0, 0, (0.015 - 0.75 * 0.04) / 0.96, 0.75);
    float a0 = t.x * min(t.y, exp2(-9.28 * dot(N, V))) + t.z;
    float a1 = t.w;
    return saturate(lerp(a0, a1, specular));
}

float3 EnvironmentSpecularUnreal4(float3 N, float3 V, float gloss, float3 specular)
{
    float4 c0 = float4(-1, -0.0275, -0.572, 0.022);
    float4 c1 = float4(1, 0.0425, 1.04, -0.04);
    float4 r = (1 - gloss) * c0 + c1;
    float a004 = min(r.x * r.x, exp2(-9.28 * dot(N, V))) * r.x + r.y;
    float2 AB = float2(-1.04, 1.04) * a004 + r.zw;
    return specular * AB.x + AB.y;
}

float attenuationTerm(float3 lightPosition, float3 P, float3 atten)
{
    float3 v = lightPosition - P;
    float d2 = dot(v, v);
    float d = sqrt(d2);
    return 1.0 / (dot(atten, float3(1, d, d2)));
}

float spotLighting(float3 lightPosition, float3 lightDirection, float2 cosOuterInner, float3 atten, float3 pos)
{
    float3 v = pos - lightPosition;
    float d2 = dot(v, v);
    float d = sqrt(d2);
    float spotFactor = dot(normalize(v), lightDirection);
    return smoothstep(cosOuterInner.x, cosOuterInner.y, spotFactor) * (spotFactor / dot(atten, float3(1, d, d2)));
}

float3 ShadingLight(float3 albedo, float4 lighting)
{
    return lighting.rgb * (albedo + lighting.a / (luminance(lighting.rgb) + 1e-6f));
}

#endif