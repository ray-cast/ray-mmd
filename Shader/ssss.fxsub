#define DEPTH_LENGTH (1.0 / (5000.0f + 1.0))

float4 SSSSStencilTestPS(in float2 coord : TEXCOORD0) : SV_TARGET0
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);
    float4 MRT4 = tex2D(Gbuffer4Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, MRT4, material);
    
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    float4 MRT8 = tex2D(Gbuffer8Map, coord);
    
    MaterialParam materialAlpha;
    DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);
    
    if (material.lightModel != LIGHTINGMODEL_TRANSMITTANCE && materialAlpha.lightModel != LIGHTINGMODEL_TRANSMITTANCE)
    {
        clip(-1);
    }
    
    return 1;
}

float4 GuassBlurPS(
    in float2 coord : TEXCOORD0,
    in float3 viewdir : TEXCOORD1,
    uniform sampler source,
    uniform float2 direction) : SV_TARGET0
{
    const float offsets[6] = { 0.352, 0.719, 1.117, 1.579, 2.177, 3.213 };

    const float3 profileVarArr[4] =
    {
        float3( 3.3, 2.8, 1.4 ),  // marble
        float3( 3.3, 1.4, 1.1 ),   // skin
        float3( 1.0, 1.0, 1.0 ),
        float3( 1.0, 1.0, 1.0 )
    };

    const float4 profileSpikeRadArr[4] =
    {
        float4( 0.35, 0.35, 0.35, 8.0 ), // marble
        float4( 0.15, 0.2, 0.25, 1.0), // skin
        float4( 1.0, 1.0, 1.0, 1.0),
        float4( 1.0, 1.0, 1.0, 1.0)
    };

    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);
    float4 MRT3 = tex2D(Gbuffer4Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, MRT3, material);
    
    float4 colorM = tex2D(source, coord.xy);
    
    float3 V = normalize(viewdir);
    float3 P = V * colorM.a / V.z;

    float perspectiveScaleX = dot(normalize(material.normal.xz), normalize(-P.xz));
    float perspectiveScaleY = dot(normalize(material.normal.yz), normalize(-P.yz));
    float perspectiveScale = max((direction.x > 0.001) ? perspectiveScaleX : perspectiveScaleY, 0.3);

    float profileIndex = floor(material.index);
    float sssAmount = frac(material.index);
    float sssStrength = (profileIndex != SUBSURFACESCATTERING_SKIN) ? sssAmount : 1.0;
    float radius = 0.0055 * profileSpikeRadArr[profileIndex].w * sssStrength;
    
    float2 finalStep = direction * perspectiveScale * radius / (colorM.a * DEPTH_LENGTH);

    float3 blurFalloff = -1.0f / (2 * profileVarArr[profileIndex]);

    float3 totalWeight = 1;
    float3 totalColor = colorM.rgb;

    [unroll]
    for (int i = 0; i < 6; i++)
    {
        float2 offset1 = coord.xy + offsets[i] / 5.5 * finalStep;
        float2 offset2 = coord.xy - offsets[i] / 5.5 * finalStep;

        float4 sampleColor1 = tex2D(source, offset1);
        float4 sampleColor2 = tex2D(source, offset2);

        float depthDiff1 = abs(sampleColor1.a - colorM.a) * 1000 * DEPTH_LENGTH;
        float depthDiff2 = abs(sampleColor2.a - colorM.a) * 1000 * DEPTH_LENGTH;

        float3 weight1 = exp((offsets[i] * offsets[i] + depthDiff1 * depthDiff1) * blurFalloff);
        float3 weight2 = exp((offsets[i] * offsets[i] + depthDiff2 * depthDiff2) * blurFalloff);

        totalWeight += weight1;
        totalWeight += weight2;

        totalColor += weight1 * sampleColor1.rgb;
        totalColor += weight2 * sampleColor2.rgb;
    }

    totalColor /= totalWeight;
    totalColor = lerp(totalColor, colorM.rgb, profileSpikeRadArr[profileIndex].xyz * (1 - sssAmount));

    return float4(totalColor, colorM.a);
}