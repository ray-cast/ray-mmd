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
    return RoughnessToSmoothness(sqrt(2.0 / (spec + 2)));
}

float RoughnessToShininess(float roughness)
{
    return 2.0f / (roughness * roughness) - 2.0f;
}

float SmoothnessToShininess(float smoothness)
{
    float roughness = SmoothnessToRoughness(smoothness);
    return RoughnessToSmoothness(roughness);
}

float fresnelSchlick(float f0, float f9, float LdotH)
{
    return lerp(f0, f9, exp2((-5.55473 * LdotH - 6.98316) * LdotH));
}

float3 fresnelSchlick(float3 f0, float3 f9, float LdotH)
{
    return lerp(f0, f9, exp2((-5.55473 * LdotH - 6.98316) * LdotH));
}

float ComputeSpecularOcclusion(float nv, float ao, float smoothness)
{
    return saturate(pow(nv + ao, smoothness) - 1 + ao);
}

float3 ComputeSpecularMicroOcclusion(float3 f0)
{
    return saturate(dot(f0, 0.33333h) * 50);
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

    return saturate(A + B * (s / t));
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

    return FL * FV * energyFactor;
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

float DiffuseBRDF(float3 N, float3 L, float3 V, float gloss)
{
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return BurleyBRDF(N, L, V, roughness);
}

float3 DiffuseBRDF(float3 N, float3 L, float3 V, float gloss, float3 transmittanceColor)
{
    float nl = dot(N, L);
    float w = lerp(0, 0.5, luminance(transmittanceColor));
    float wn = 1.0 / ((1 + w) * (1 + w));
    float transmittanceBack = saturate((-nl + w) * wn);
    float diffuse = DiffuseBRDF(N, L, V, gloss);
    return lerp(diffuse * nl, saturate((nl + w) * wn) + transmittanceColor * transmittanceBack, step(1e-5, w));
}

float3 SpecularBRDF_BlinnPhong(float3 N, float3 L, float3 V, float smoothness, float3 specular)
{
    float3 H = normalize(L + V);

    float nh = saturate(dot(N, H));
    float nl = saturate(dot(N, L));
    float lh = saturate(dot(L, H));

    float alpha = exp2(10 * smoothness + 1); // 2 - 2048
    float D =  ((alpha + 2) / 8) * exp2(alpha * InvLog2 * nh - alpha * InvLog2);

    float k = min(1.0f, smoothness + 0.545f);
    float G = 1.0 / (k * lh * lh + 1 - k);

    float3 f0 = max(0.04, specular);
    float3 f90 = ComputeSpecularMicroOcclusion(f0);
    float3 F = fresnelSchlick(f0, f90, lh);

    return D * F * G;
}

float3 SpecularBRDF_GGX(float3 N, float3 L, float3 V, float roughness, float anisotropic, float3 specular, float NormalizationFactor)
{
    float3 H = normalize(V + L);
    
    float nh = dot(N, H);
    float nl = saturate(dot(N, L));
    float lh = saturate(dot(L, H));
    float nv = abs(dot(N, V)) + 1e-5h;

    float3 T = cross(N, float3(0, 0, 1));
    float3 B = cross(T, N);

    float m2 = roughness * roughness;
    float aspect = sqrt(1 - anisotropic * 0.9);
    float ax = max(0.001, m2 / aspect);
    float ay = max(0.001, m2 * aspect);
    float hx = dot(H, T);
    float hy = dot(H, B);
    float spec = 1 / (ax * ay * pow2(pow2(hx / ax) + pow2(hy / ay) + nh * nh) * NormalizationFactor);
    
    float Gv = nl * sqrt((-nv * m2 + nv) * nv + m2);
    float Gl = nv * sqrt((-nl * m2 + nl) * nl + m2);
    spec *= 0.5 / (Gv + Gl);

    float3 f0 = max(0.04, specular);
    float3 f90 = ComputeSpecularMicroOcclusion(f0);
    float3 fresnel = fresnelSchlick(f0, f90, lh);

    return fresnel * spec;
}

float3 SpecularBRDF_GGX(float3 N, float3 L, float3 V, float roughness, float3 specular, float NormalizationFactor)
{
    float3 H = normalize(V + L);

    float nh = saturate(dot(N, H));
    float nl = saturate(dot(N, L));
    float lh = saturate(dot(L, H));
    float nv = abs(dot(N, V)) + 1e-5h;

    float m2 = roughness * roughness;
    float spec = (nh * m2 - nh) * nh + 1;
    spec = m2 / (spec * spec) * NormalizationFactor;

    float Gv = nl * sqrt((-nv * m2 + nv) * nv + m2);
    float Gl = nv * sqrt((-nl * m2 + nl) * nl + m2);
    spec *= 0.5h / (Gv + Gl);

    float3 f0 = max(0.04, specular);
    float3 f90 = ComputeSpecularMicroOcclusion(f0);
    float3 fresnel = fresnelSchlick(f0, f90, lh);

    return fresnel * spec;
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float gloss, float3 f0)
{
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF_GGX(N, L, V, roughness, f0, 1.0f);
}

float3 SpecularBRDF(float3 N, float3 L, float3 V, float gloss, float anisotropic, float3 f0)
{
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF_GGX(N, L, V, roughness, anisotropic, f0, 1.0f);
}

float3 KajiyaKayAnisotropic(float3 T, float3 H, float3 f0, float anisotropic)
{   
    float th = dot(T, H);
    float specular = sqrt(max(1.0 - th * th, 0.01));
    return f0 * pow(specular, anisotropic);
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

float HorizonOcclusion(float3 N, float3 R)
{
    float factor = clamp(1.0 + 1.3 * dot(R, N), 0.1, 1.0);
    return factor * factor;
}

float3 GetDiffuseDominantDir(float3 N, float3 V, float roughness) 
{
    float a = 1.02341f * roughness - 1.51174f;
    float b = -0.511705f * roughness + 0.755868f;
    float factor = saturate((dot(N, V) * a + b) * roughness);
    return lerp(N, V, factor);
}

float3 GetSpecularDominantDir(float3 N, float3 R, float roughness)
{
    float smoothness = 1.0 - roughness;
    float factor = smoothness * (sqrt(smoothness) + roughness);
    return lerp(N, R, factor);    
}

float EnvironmentMip(float roughness, int miplevel)
{
    return sqrt(roughness) * miplevel;
}

float3 EnvironmentReflect(float3 normal, float3 view)
{
    return reflect(-view, normal);
}

float3 EnvironmentSpecularBlackOpsII(float3 N, float3 V, float smoothness, float3 specular)
{
    float4 t = float4(1 / 0.96, 0.475, (0.0275 - 0.25 * 0.04) / 0.96, 0.25) * smoothness;
    t += float4(0, 0, (0.015 - 0.75 * 0.04) / 0.96, 0.75);
    float a0 = t.x * min(t.y, exp2(-9.28 * dot(N, V))) + t.z;
    float a1 = t.w;
    return saturate(lerp(a0, a1, specular));
}

float3 EnvironmentSpecularUnreal4(float3 N, float3 V, float roughness, float3 specular)
{
    float4 c0 = float4(-1, -0.0275, -0.572, 0.022);
    float4 c1 = float4(1, 0.0425, 1.04, -0.04);
    float4 r = roughness * c0 + c1;
    float a004 = min(r.x * r.x, exp2(-9.28 * dot(N, V))) * r.x + r.y;
    float2 AB = float2(-1.04, 1.04) * a004 + r.zw;
    return specular * AB.x + AB.y;
}

float GetPhysicalSmoothDistanceAtt(float squaredDistance, float invSqrAttRadius)
{
    float factor = squaredDistance * invSqrAttRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}

float GetPhysicalLightAttenuation(float3 L, float radius)
{
    float invRadius = 1 / (radius * radius);
    float sqrDist = dot(L, L);
    float attenuation = 1.0 / (max(sqrDist, 1e-6));
    return attenuation *= GetPhysicalSmoothDistanceAtt(sqrDist, invRadius);
}

float GetPointLightAttenuation(float3 L, float radius)
{
    float attenuation = GetPhysicalLightAttenuation(L, radius);
    return attenuation;
}

float GetSpotLightAttenuation(float3 L, float3 lightDirection, float angle, float scale, float radius)
{
    float3 L2 = normalize(L);
    
    float spotAngle = dot(L2, -lightDirection);
    
    float lightAngleScale = 1.0f / max(0.001f, angle);
    float lightAngleOffset = angle * scale;
    
    float attenuation = saturate(spotAngle * lightAngleScale - lightAngleOffset); 
    attenuation *= attenuation;
    
    return attenuation;
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
    return SpecularBRDF_GGX(N, V, L2, roughness, f0, SphereNormalization(len, radius, roughness));
}

float3 RectangleDirection(float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, out float2 coord)
{
    float3 I = dot(Ln, L) * Ln - L;
    float2 lightPos2D = float2(dot(I, Lt), dot(I, Lb));
    float2 lightClamp2D = clamp(lightPos2D, -Lwh, Lwh);
    coord = saturate(lightClamp2D / Lwh * 0.5 + 0.5);
    return L + Lt * lightClamp2D.x + (Lb * lightClamp2D.y);
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

float RectangleAttenuation(float3 L, float3 lightDirection, float angle, float radius)
{
    float3 v = normalize(-L);
    float rectangleAngle = max(0, dot(v, lightDirection));   
    return rectangleAngle;
}

float3 RectangleLightBRDF(float3 N, float3 V, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, float gloss, float3 f0)
{
    float3 R = reflect(V, N);
    float3 Lw = RectangleLight(R, L, Lt, Lb, Ln, Lwh);
    float len = max(length(Lw), 1e-6);
    float3 L2 = Lw / len;
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF_GGX(N, L2, V, roughness, f0, SphereNormalization(len, Lwh.y, roughness));
}

float3 RectangleLightBRDFWithUV(float3 N, float3 V, float3 L, float3 Lt, float3 Lb, float3 Ln, float2 Lwh, float gloss, float3 f0, out float2 coord)
{
    float3 R = reflect(V, N);
    float3 Lw = RectangleLightWithUV(R, L, Lt, Lb, Ln, Lwh, coord);
    float len = max(length(Lw), 1e-6);
    float3 L2 = Lw / len;
    float roughness = max(SmoothnessToRoughness(gloss), 0.001);
    return SpecularBRDF_GGX(N, L2, V, roughness, f0, SphereNormalization(len, Lwh.y, roughness));
}

float3 TubeLightDirection(float3 N, float3 V, float3 L0, float3 L1, float3 P, float radius)
{   
    float3 Ld = L1 - L0;
    float t = dot(-L0, Ld) / dot(Ld, Ld);
    float3 d = (L0 + Ld * saturate(t));
    return d - normalize(d) * radius;
}

float3 TubeLightSpecDirection(float3 N, float3 V, float3 L0, float3 L1, float3 P, float radius)
{      
    float3 Ld = L1 - L0;
    float3 R = reflect(V, N);
    
    float RoL0 = dot(R, L0);
    float RoLd = dot(R, Ld);
    float L0oLd = dot(L0, Ld);
    float T = (RoL0 * RoLd - L0oLd) / (dot(Ld, Ld) - RoLd * RoLd);
    
    float3 closestPoint = L0 + Ld * saturate(T);
    float3 centerToRay = dot(closestPoint, R) * R - closestPoint;
    
    return closestPoint + centerToRay * saturate(radius / length(centerToRay));
}

float3 TubeLightBRDF(float3 P, float3 N, float3 V, float3 L0, float3 L1, float LightWidth, float LightRadius, float smoothness, float3 f0)
{
    float3 Lw = TubeLightSpecDirection(N, V, L0, L1, P, LightRadius);
    
    float len = length(Lw);
    float3 L2 = Lw / len;
    
    float roughness = max(SmoothnessToRoughness(smoothness), 0.001);
    float normalizeFactor = SphereNormalization(len, length(float2(LightWidth, LightRadius)), roughness);    
    return SpecularBRDF_GGX(N, L2, V, roughness, f0, normalizeFactor);
}

float TubeLightAttenuation(float3 N, float3 L0, float3 L1, float3 P)
{
    float length1 = length(L0);
    float length2 = length(L1);
    
    float nl0 = dot(L0, N) / (2.0 * length1);
    float nl1 = dot(L1, N) / (2.0 * length2);
    
    return (2.0 * clamp(nl0 + nl1, 0.0, 1.0)) / (length1 * length2 + dot(L0, L1) + 2.0);
}