const float smoothness = 1.0;
const float smoothnessBaseSpecular = 0.02;

const float3 scatteringLow = exp(-float3(4.0, 2.9, 2.8) * 1.0) * 2;
const float3 scatteringHigh = exp(-float3(4.0, 2.5, 2.5) * 1.25);

#define WAVE_MAP_ENABLE 1
#define WAVE_MAP_FILE "textures/wave.png"

const float waveHeightLow = 0.6;
const float waveHeightHigh  = 0.5;

const float waveLoopsLow = 0.6;
const float waveLoopsHigh = 4.0;

const float waveMapScaleLow = 1.0;

const float2 waveMapLoopNumLow = 4.0;

const float2 waveMapTranslate = float2(1, 1);

#define WAVE_NOISE_MAP_ENABLE 1
#define WAVE_NOISE_MAP_FILE "textures/noise.png"

#include "material_common.fxsub"