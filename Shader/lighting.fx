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

    return D * F * G;
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float m, float3 f0, float NormalizationFactor)
{
    float m2 = m * m;
    float3 H = normalize(V + L);

    float NdotH = saturate(dot(N, H));
    float NdotL = saturate(dot(N, L));
    float NdotV = abs(dot(N, V)) + 1e-5h;

    float spec = (NdotH * m2 - NdotH) * NdotH + 1;
    spec = m2 / (spec * spec) * NormalizationFactor;

    float Gv = NdotL * sqrt((-NdotV * m2 + NdotV) * NdotV + m2);
    float Gl = NdotV * sqrt((-NdotL * m2 + NdotL) * NdotL + m2);
    spec *= 0.5h / (Gv + Gl);

    float f90 = saturate(dot(f0, 0.33333h) / 0.02h);
    float3 fresnel = fresnelSchlick(f0, f90, saturate(dot(L, H)));

    return fresnel * spec;
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float gloss, float3 f0)
{
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF(N, L, V, roughness, f0, 1.0f) * saturate(dot(N, L));
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

float GetPhysicalLightAttenuation(float3 lightPosition, float3 P, float radius, float attenuationBulbSize)
{
    float invRadius = 1 / radius;    
    float d = distance(lightPosition, P);
    float fadeoutFactor = saturate((radius - d) * (invRadius / 0.2));
    float denom = 1 + max(d - attenuationBulbSize, 0) / attenuationBulbSize;
    float attenuation = fadeoutFactor * fadeoutFactor / (denom * denom);    
    return attenuation;
}

float GetPhysicalLightAttenuation(float3 L, float radius, float attenuationBulbSize)
{
    float invRadius = 1 / radius;    
    float d = length(L);
    float fadeoutFactor = saturate((radius - d) * (invRadius / 0.2));
    float denom = 1 + max(d - attenuationBulbSize, 0) / attenuationBulbSize;
    float attenuation = fadeoutFactor * fadeoutFactor / (denom * denom);    
    return attenuation;
}

float GetSpotAttenuation(float3 P, float3 lightPosition, float3 lightDirection, float angle, float radius)
{
    float3 v = normalize(P - lightPosition);
    float spotAngle = max(0, dot(v, lightDirection));   
    float spotFalloff = cos(angle) / (spotAngle + 1e-6);
    float spotAttenuation = 1.0h - pow(saturate(spotFalloff), radius);
    return spotAttenuation;
}

float GetSpotAttenuation(float3 L, float3 lightDirection, float angle, float radius)
{
    float3 v = normalize(-L);
    float spotAngle = max(0, dot(v, lightDirection));   
    float spotFalloff = cos(angle) / (spotAngle + 1e-6);
    float spotAttenuation = 1.0h - pow(saturate(spotFalloff), radius);
    return spotAttenuation;
}

float3 SphereLightDirection(float3 N, float3 V, float3 L, float lightRadius)
{
    float3 R = reflect(V, N);
    float3 centerToRay = dot(L, R) * R - L;
    float3 closestPoint = L + centerToRay * saturate(lightRadius / (length(centerToRay) + 1e-6));
    return normalize(closestPoint);
}

float SphereNormalization(float len, float radius, float gloss)
{
    float dist = saturate(radius / len);
    float normFactor = gloss / saturate(gloss + 0.5 * dist);
    return normFactor * normFactor;
}

float3 SphereAreaLightBRDF(float3 N, float3 V, float3 L, float radius, float gloss, float3 f0)
{
    float len = max(length(L),  1e-6);
    float3 L2 = SphereLightDirection(N, V, L, radius);
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF(N, V, L2, roughness, f0, SphereNormalization(len, radius, roughness)) * saturate(dot(N, L/len));
}

float3 RectangleLight(float3 R, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh)
{
    float RdotN = dot(Ln, R) + 1e-6;
    float intersectLen = dot(Ln, L) / RdotN;
    float3 I = R * intersectLen - L;

    float2 lightPos2D = float2(dot(I, Lt), dot(I, Lb));
    float2 lightClamp2D = clamp(lightPos2D, -Lwh, Lwh);

    return L + Lt * lightClamp2D.x + Lb * lightClamp2D.y;
}

float3 RectangleLightWithUV(float3 R, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, out float2 coord)
{
    float RdotN = dot(Ln, R) + 1e-6;
    float intersectLen = dot(Ln, L) / RdotN;
    float3 I = R * intersectLen - L;

    float2 lightPos2D = float2(dot(I, Lt), dot(I, Lb));
    float2 lightClamp2D = clamp(lightPos2D, -Lwh, Lwh);
    coord = saturate(lightClamp2D / Lwh * 0.5 + 0.5);
    return L + Lt * lightClamp2D.x + Lb * lightClamp2D.y;
}

float3 RectangleDirection(float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, out float2 coord)
{
    float3 I = dot(Ln, L) * Ln - L;
    float2 lightPos2D = float2(dot(I, Lt), dot(I, Lb));
    float2 lightClamp2D = clamp(lightPos2D, -Lwh, Lwh);
    coord = saturate(lightClamp2D / Lwh * 0.5 + 0.5);
    return L + Lt * lightClamp2D.x + (Lb * lightClamp2D.y);
}

float3 RectangleLightBRDF(float3 N, float3 V, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, float gloss, float3 f0)
{
    float3 R = reflect(V, N);
    float3 Lw = RectangleLight(R, L, Lt, Lb, Ln, Lwh);
    float len = max(length(Lw), 1e-6);
    float3 L2 = Lw / len;
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF(N, L2, V, roughness, f0, SphereNormalization(len, length(Lwh), roughness)) * saturate(dot(N, normalize(L)));
}

float3 RectangleLightBRDFWithUV(float3 N, float3 V, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, float gloss, float3 f0, out float2 coord)
{
    float3 R = reflect(V, N);
    float3 Lw = RectangleLightWithUV(R, L, Lt, Lb, Ln, Lwh, coord);
    float len = max(length(Lw), 1e-6);
    float3 L2 = Lw / len;
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF(N, L2, V, roughness, f0, SphereNormalization(len, Lwh.y, roughness)) * saturate(dot(N, normalize(L)));
}

#endif