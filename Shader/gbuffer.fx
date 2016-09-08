#ifndef _H_GBUFFER_H_
#define _H_GBUFFER_H_

#define LIGHTINGMODEL_NORMAL         0
#define LIGHTINGMODEL_TRANSMITTANCE  1
#define LIGHTINGMODEL_EMISSIVE       2
#define LIGHTINGMODEL_EMISSIVE2      3

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
    float3 emissive;
    float smoothness;
    float index;
    int lightModel;
};

struct GbufferParam
{
    float4 buffer1 : COLOR0;
    float4 buffer2 : COLOR1;
    float4 buffer3 : COLOR2;
    float4 buffer4 : COLOR3;
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

GbufferParam EncodeGbuffer(MaterialParam material, float linearDepth)
{
    GbufferParam gbuffer;
    gbuffer.buffer1.xyz = material.albedo;
    gbuffer.buffer1.w = material.smoothness;

    gbuffer.buffer2.xyz = EncodeNormal(normalize(material.normal));
    gbuffer.buffer2.w = 0;

    gbuffer.buffer3.xyz = rgb2ycbcr(material.specular);
    gbuffer.buffer3.w = 0;

    if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
    {
        float scatteringAmount = frac(material.index);
        gbuffer.buffer2.w = scatteringAmount > 0.01 ? material.index / TWO_BITS_EXTRACTION_FACTOR : 0;
        
        material.transmittance = rgb2ycbcr(material.transmittance);
        gbuffer.buffer3.yz = material.transmittance.gb;
        gbuffer.buffer3.w = material.transmittance.r * MAX_FRACTIONAL_8_BIT;
    }
    else if (material.lightModel == LIGHTINGMODEL_EMISSIVE)
    {
        material.emissive = rgb2ycbcr(material.emissive);
        gbuffer.buffer3.yz = material.emissive.gb;
        gbuffer.buffer3.w = material.emissive.r * MAX_FRACTIONAL_8_BIT;
    }

    gbuffer.buffer3.w = ((float)material.lightModel + gbuffer.buffer3.w) / TWO_BITS_EXTRACTION_FACTOR;
    
    gbuffer.buffer4 = linearDepth;
    
    return gbuffer;
}

void DecodeGbuffer(float4 buffer1, float4 buffer2, float4 buffer3, out MaterialParam material)
{
    material.lightModel = (int)floor(buffer3.w * TWO_BITS_EXTRACTION_FACTOR);

    material.albedo = buffer1.xyz;
    material.smoothness = buffer1.w;

    material.normal = DecodeNormal(buffer2.xyz);
    material.index = buffer2.w * TWO_BITS_EXTRACTION_FACTOR;

    if (material.lightModel == LIGHTINGMODEL_TRANSMITTANCE)
    {
        material.specular = buffer3.xxx;
        material.transmittance = ycbcr2rgb(float3(frac(buffer3.w * TWO_BITS_EXTRACTION_FACTOR), buffer3.yz));
    }
    else if (material.lightModel == LIGHTINGMODEL_EMISSIVE)
    {
        material.specular = buffer3.xxx;
        material.emissive = ycbcr2rgb(float3(frac(buffer3.w * TWO_BITS_EXTRACTION_FACTOR), buffer3.yz));
    }
    else
    {
        material.specular = ycbcr2rgb(buffer3.xyz);
        material.transmittance = 0;
    }
}

GbufferParam EncodeGbufferWithAlpha(MaterialParam material, float linearDepth, float alphaDiffuse)
{
    GbufferParam gbuffer;
    gbuffer.buffer1.xyz = material.albedo;
    gbuffer.buffer1.w = material.smoothness;

    gbuffer.buffer2.xyz = EncodeNormal(normalize(material.normal));
    gbuffer.buffer2.w = alphaDiffuse;

    gbuffer.buffer3.xyz = rgb2ycbcr(material.specular);
    gbuffer.buffer3.w = 0;

    gbuffer.buffer4 = linearDepth;
    
    return gbuffer;
}

void DecodeGbufferWithAlpha(float4 buffer1, float4 buffer2, float4 buffer3, out MaterialParam material, out float alphaDiffuse)
{
    material.lightModel = (int)floor(buffer3.w * TWO_BITS_EXTRACTION_FACTOR);

    material.albedo = buffer1.xyz;
    material.smoothness = buffer1.w;

    material.normal = DecodeNormal(buffer2.xyz);
    material.index = 0;

    material.specular = ycbcr2rgb(buffer3.xyz);
    material.transmittance = 0;
    material.emissive = 0;
    
    alphaDiffuse = buffer2.w;
}

float3 DecodeGBufferNormal(float4 buffer2)
{
    return DecodeNormal(buffer2.rgb);
}

float3 ReconstructPos(float2 Tex, float4x4 matProjectInverse, float depth)
{
    float3 v = mul(float4(CoordToPos(Tex), 0, 1), matProjectInverse).xyz;
    return v * depth / v.z;
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

float4 EncodeYcbcr(float4 screenPosition, float3 color1, float3 color2)
{
    bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));

    color1 = rgb2ycbcr(color1);
    color2 = rgb2ycbcr(color2);

    float4 result = 0.0f;
    result.r = color1.r;
    result.g = (pattern) ? color1.g: color1.b;
    result.b = color2.r;
    result.a = (pattern) ? color2.g: color2.b;
    return result;   
}

void DecodeYcbcr(sampler source, float2 coord, float4 screenPosition, float2 offset, out float3 color1, out float3 color2)
{
    float4 packed = tex2D(source, coord);
    
    float4 env2 = tex2D(source, coord + float2(offset.x, 0.0));
    float4 env3 = tex2D(source, coord - float2(offset.x, 0.0));
    float4 env4 = tex2D(source, coord + float2(0.0, offset.y));
    float4 env5 = tex2D(source, coord - float2(0.0, offset.y));
    
    env2.rg = EdgeFilter(packed.rg, env2.rg, env3.rg, env4.rg, env5.rg);
    env2.ba = EdgeFilter(packed.ba, env2.ba, env3.ba, env4.ba, env5.ba);

    bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));
    
    color1 = (pattern) ? float3(packed.rg, env2.g) : float3(packed.r, env2.g, packed.g);
    color2 = (pattern) ? float3(packed.ba, env2.a) : float3(packed.b, env2.a, packed.a);

    color1 = ycbcr2rgb(color1);
    color2 = ycbcr2rgb(color2);
}

#endif