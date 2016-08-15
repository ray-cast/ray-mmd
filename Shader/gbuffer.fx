#ifndef _H_GBUFFER_H_
#define _H_GBUFFER_H_

#define LIGHTINGMODEL_NORMAL         0
#define LIGHTINGMODEL_TRANSMITTANCE  1
#define LIGHTINGMODEL_EMISSIVE       2

#define SUBSURFACESCATTERING_MARBLE 0
#define SUBSURFACESCATTERING_SKIN   1

#define MAX_FRACTIONAL_8_BIT        (255.0f / 256.0f)
#define TWO_BITS_EXTRACTION_FACTOR  (3.0f + MAX_FRACTIONAL_8_BIT)

struct MaterialParam
{
    float3 normal;
    float3 albedo;
    float3 specular;
    float3 transmittance;
    float smoothness;
    float distance;
    int index;
    int lightModel;
};

struct GbufferParam
{
    float4 buffer1 : COLOR0;
    float4 buffer2 : COLOR1;
    float4 buffer3 : COLOR2;
};

float3 EncodeFloatRGB(float v)
{
    float3 enc = float3(256.0 * 256.0, 256.0, 1.0);
    enc = frac(v * enc);
    enc -= enc.xxy * float3(0.0, 1.0/256.0, 1.0/256.0);
    return enc;
}

float DecodeFloatRGB(float3 rgb)
{
    return dot(rgb, float3(1.0 / (256.0 * 256.0), 1.0 / 256.0, 1.0));
}

float4 EncodeFloatRGBA(float v)
{
    // http://aras-p.info/blog/2009/07/30/encoding-floats-to-rgba-the-final/
    float4 enc = float4(1.0f, 255.0f, 65025.0f, 16581375.0f);
    enc = frac(v * enc);
    enc -= enc.yzww * float4(1 / 255.0f, 1 / 255.0f, 1 / 255.0f, 0);
    return enc;
}

float DecodeFloatRGBA(float4 rgba)
{
   return dot(rgba, float4(1, 1 / 255.0f, 1 / 65025.0f, 1 / 16581375.0f));
}

float3 EncodeNormal(float3 normal)
{
    // http://aras-p.info/texts/CompactNormalStorage.html
    float p = sqrt(-normal.z * 8 + 8);
    float2 enc = normal.xy / p + 0.5f;
    float2 enc255 = enc * 255;
    float2 residual = floor(frac(enc255) * 16);
    return float3(floor(enc255), residual.x * 16 + residual.y) / 255;
}

float3 DecodeNormal(float3 enc)
{
    float nz = floor(enc.z * 255) / 16;
    enc.xy += float2(floor(nz) / 16, frac(nz)) / 255;
    float2 fenc = enc.xy * 4 - 2;
    float f = dot(fenc, fenc);
    float g = sqrt(1 - f / 4);
    float3 normal;
    normal.xy = fenc * g;
    normal.z = f / 2 - 1;
    return normalize(normal);
}

GbufferParam EncodeGbuffer(MaterialParam material)
{
    GbufferParam gbuffer;
    gbuffer.buffer1.xyz = srgb2linear(material.albedo);
    gbuffer.buffer1.w = material.smoothness;

    gbuffer.buffer2.xyz = normalize(material.normal);
    gbuffer.buffer2.w = material.distance;

    gbuffer.buffer3.xyz = rgb2ycbcr(material.specular);
    gbuffer.buffer3.w = 0;

    if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
    {
        material.transmittance = rgb2ycbcr(material.transmittance);
        gbuffer.buffer3.yz = material.transmittance.gb;
        gbuffer.buffer3.w = material.transmittance.r * MAX_FRACTIONAL_8_BIT;
    }

    gbuffer.buffer3.w = ((float)material.lightModel + gbuffer.buffer3.w) / TWO_BITS_EXTRACTION_FACTOR;
    return gbuffer;
}

GbufferParam EncodeGbufferWithAlpha(MaterialParam material, float alphaDiffuse, float alphaNormals, float alphaSpecular)
{
    GbufferParam gbuffer;
    gbuffer = EncodeGbuffer(material);
    gbuffer.buffer1.w = alphaDiffuse;
    gbuffer.buffer2.w = alphaNormals;
    gbuffer.buffer3.w = alphaSpecular;
    return gbuffer;
}

void DecodeGbuffer(float4 buffer1, float4 buffer2, float4 buffer3, out MaterialParam material)
{
    material.lightModel = (int)floor(buffer3.w * TWO_BITS_EXTRACTION_FACTOR);

    material.albedo = buffer1.xyz;
    material.smoothness = buffer1.w;

    material.normal = normalize(buffer2.xyz);
    material.distance = buffer2.w;
    material.index = 1;

    if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
    {
        material.specular = buffer3.xxx;
        material.transmittance = ycbcr2rgb(float3(frac(buffer3.w * TWO_BITS_EXTRACTION_FACTOR), buffer3.yz));
    }
    else
    {
        material.specular = ycbcr2rgb(buffer3.xyz);
        material.transmittance = 0;
    }
}

void DecodeLinearDepth(float4 buffer2, out float depth)
{
    depth = buffer2.w;
}

void DecodeNormalAndDepth(float4 buffer2, out float3 N, out float depth)
{
    N = normalize(buffer2.xyz);
    DecodeLinearDepth(buffer2, depth);
}

float3 ReconstructPos(float2 Tex, float depth)
{
    float3 v = mul(float4(CoordToPos(Tex), 0, 1), matProjectInverse).xyz;
    return v * depth / v.z;
}

void DecodePositionAndNormal(sampler Gbuffer2Map, float2 coord, out float3 WPos, out float3 N)
{
    float4 ND = tex2D(Gbuffer2Map, coord);
    float depth;
    DecodeNormalAndDepth(ND, N, depth);
    WPos = ReconstructPos(coord - ViewportOffset, depth);
}

float3 DecodePosition(sampler Gbuffer2Map, float2 coord)
{
    float depth;
    DecodeLinearDepth(tex2D(Gbuffer2Map, coord), depth);
    return ReconstructPos(coord - ViewportOffset, depth);
}

#endif