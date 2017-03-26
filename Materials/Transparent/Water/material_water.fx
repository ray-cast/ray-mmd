const float smoothness = 1.0;
const float smoothnessBaseSpecular = 0.02;

const float3 scatteringLow = exp(-float3(4.0, 2.9, 2.8) * 1.0) * 2;
const float3 scatteringHigh = exp(-float3(4.0, 2.5, 2.5) * 1.25);

#define WAVE_MAP_ENABLE 1
#define WAVE_MAP_FILE "textures/wave.png"

const float waveMapScaleLow = 0.5;
const float waveMapScaleHigh = 0.5;

const float2 waveMapLoopNumLow = 10.0;
const float2 waveMapLoopNumHigh = 2.5;

const float2 waveMapTranslate = float2(1, 1);

#define WAVE_NOISE_MAP_ENABLE 1
#define WAVE_NOISE_MAP_FILE "textures/noise.png"

#define WAVE_FLOW_MAP_ENABLE 0
#define WAVE_FLOW_MAP_FILE "textures/flow.png"

#define WAVE_FOAM_MAP_ENABLE 0
#define WAVE_FOAM_MAP_FILE "textures/foam.png"

#define WAVE_RIPPLE_MAP_ENABLE 0
#define WAVE_RIPPLE_MAP_FILE "textures/ripple.png"

const float2 rippleMapLoopNumLow = 10.0;

#include "material_common.fxsub"