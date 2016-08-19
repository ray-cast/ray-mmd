#if SSSS_QUALITY > 0

#define DEPTH_LENGTH (1.0 / (10000.0f + 1.0))

float SSSSlinearizeDepth(float2 texcoord)
{
    return tex2D(Gbuffer4Map, texcoord).r;
}

float4 GuassBlurPS(
    in float2 coord : TEXCOORD0,
    in float3 viewdir : TEXCOORD1,
    uniform sampler source,
    uniform float2 direction) : SV_TARGET0
{
    const float offsets[6] = { 0.352, 0.719, 1.117, 1.579, 2.177, 3.213 };

    const float3 profileVarArr[2] =
    {
        float3( 3.3, 2.8, 1.4 ),  // marble
        float3( 3.3, 1.4, 1.1 )   // skin
    };

    const float4 profileSpikeRadArr[2] =
    {
        float4( 0.7,  0.7, 0.7, 8.0 ),  // marble
        float4( 0.15, 0.2, 0.25, 1.0) // skin
    };

    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);

    float depthM = SSSSlinearizeDepth(coord);
    
    float3 V = normalize(viewdir);
    float3 P = V * depthM / V.z;

    float4 colorM = tex2D(source, coord.xy);

    if (material.lightModel != LIGHTINGMODEL_TRANSMITTANCE)
    {
        return colorM;
    }
    else
    {
        float perspectiveScaleX = dot(normalize(material.normal.xz), normalize(-P.xz));
        float perspectiveScaleY = dot(normalize(material.normal.yz), normalize(-P.yz));
        float perspectiveScale = max((direction.x > 0.001) ? perspectiveScaleX : perspectiveScaleY, 0.3);

        float profileIndex = floor(material.index);
        float sssAmount = frac(material.index);
        float radius = 0.0055 * profileSpikeRadArr[profileIndex].w;
        
        float2 finalStep = direction * perspectiveScale * radius / (depthM * DEPTH_LENGTH);

        float3 blurFalloff = -1.0f / (2 * profileVarArr[profileIndex]);

        float3 totalWeight = 1;
        float3 totalColor = colorM.rgb;

        [unroll]
        for (int i = 0; i < 6; i++)
        {
            float2 offset1 = coord.xy + offsets[i] / 5.5 * finalStep;
            float2 offset2 = coord.xy - offsets[i] / 5.5 * finalStep;

            float sampleDepth1 = SSSSlinearizeDepth(offset1).r;
            float sampleDepth2 = SSSSlinearizeDepth(offset2).r;

            float3 sampleColor1 = tex2D(source, offset1).rgb;
            float3 sampleColor2 = tex2D(source, offset2).rgb;

            float depthDiff1 = abs(sampleDepth1 - depthM) * 1000 * DEPTH_LENGTH;
            float depthDiff2 = abs(sampleDepth2 - depthM) * 1000 * DEPTH_LENGTH;

            float3 weight1 = exp((offsets[i] * offsets[i] + depthDiff1 * depthDiff1) * blurFalloff);
            float3 weight2 = exp((offsets[i] * offsets[i] + depthDiff2 * depthDiff2) * blurFalloff);

            totalWeight += weight1;
            totalWeight += weight2;

            totalColor += weight1 * sampleColor1;
            totalColor += weight2 * sampleColor2;
        }

        totalColor /= totalWeight;
        totalColor = lerp(totalColor, colorM.rgb, profileSpikeRadArr[profileIndex].xyz * (1 - sssAmount));

        return float4(totalColor, colorM.a);
    }
}
#endif