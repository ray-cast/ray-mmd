#if SSR_SAMPLER_COUNT > 0
const float maxDistance = 4000;
const float zThickness = 2.0;
const float nearZ = 1.0;

float4 LocalReflectionPS(in float2 coord : TEXCOORD) : SV_Target
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float3 viewPosition = ReconstructPos(coord, material.distance);

    float4 worldPosition = mul(float4(viewPosition, 1), matViewInverse);
    worldPosition /= worldPosition.w;

    float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
    float3 worldViewdir = normalize(worldPosition.xyz - CameraPosition);
    float3 worldReflect = normalize(reflect(worldViewdir, worldNormal));

    float3 viewReflect = mul(worldReflect, (float3x3)matView);
    float rayLength = (viewReflect.z >= 0.0) ? maxDistance : min((nearZ - viewPosition.z) / viewReflect.z, maxDistance);

    float4 startPosition = worldPosition;
    float4 endPosition = startPosition + float4(worldReflect, 0) * rayLength;

    float4 startScreenPos0 = mul(startPosition, matViewProject);
    float4 endScreenPos1 = mul(endPosition, matViewProject);

    float2 startTexcoord = startScreenPos0.xy / startScreenPos0.w * float2(0.5, -0.5) + 0.5;
    float2 endTexcoord = endScreenPos1.xy / endScreenPos1.w * float2(0.5, -0.5) + 0.5;

    return 0.0f;
}

#endif