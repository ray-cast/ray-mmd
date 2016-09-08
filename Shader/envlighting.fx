texture IBLSpecularTexture : MATERIALTEXTURE;
sampler IBLSpecularSampler = sampler_state {
    texture = <IBLSpecularTexture>;
    MINFILTER = LINEAR; MAGFILTER = LINEAR;
    ADDRESSU  = WRAP;   ADDRESSV  = WRAP;
};

texture IBLDiffuseTexture : MATERIALSPHEREMAP;
sampler IBLDiffuseSampler = sampler_state {
    texture = <IBLDiffuseTexture>;
    MINFILTER = LINEAR; MAGFILTER = LINEAR;
    ADDRESSU  = WRAP;   ADDRESSV  = WRAP;
};

void EnvLightingVS(
    in float4 Position : POSITION,
    in float3 Normal   : NORMAL,
    in float2 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float3 oNormal    : TEXCOORD1,
    out float3 oViewdir   : TEXCOORD2,
    out float4 oPosition  : SV_Position)
{
    oTexcoord = Texcoord.xyxy;
    oViewdir = -mul(Position, matProjectInverse).xyz;
    oPosition = Position;
}

float4 EnvLightingPS(
    float4 texcoord : TEXCOORD0,
    float3 normal   : TEXCOORD1,
    float3 viewdir  : TEXCOORD2) : SV_Target
{
    float4 MRT0 = tex2D(Gbuffer1Map, texcoord);
    float4 MRT1 = tex2D(Gbuffer2Map, texcoord);
    float4 MRT2 = tex2D(Gbuffer3Map, texcoord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float3 V = normalize(viewdir);

    float4 lighting = 0.0;

    if (material.lightModel != LIGHTINGMODEL_EMISSIVE)
    {
        float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
        float3 worldView = mul(V, (float3x3)matViewInverse);

        float mipLayer = EnvironmentMip(material.smoothness, 6);

        float3 R = EnvironmentReflect(worldNormal, worldView);
        float3 prefilteredDiffuse = tex2D(IBLDiffuseSampler, computeSphereCoord(worldNormal)).rgb;
        float3 prefilteredSpeculr = tex2Dlod(IBLSpecularSampler, float4(computeSphereCoord(R), 0, mipLayer)).rgb;
        float3 prefilteredTransmittance = tex2D(IBLDiffuseSampler, -computeSphereCoord(worldNormal)).rgb;

        lighting.rgb += prefilteredDiffuse * material.albedo;
        lighting.rgb += prefilteredTransmittance * material.transmittance;
        lighting.rgb += prefilteredSpeculr * EnvironmentSpecularBlackOpsII(worldNormal, worldView, material.smoothness, material.specular);
    }

    return lighting;
}