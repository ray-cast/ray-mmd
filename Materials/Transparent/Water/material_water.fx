const float smoothness = 1.0;
const float smoothnessBaseSpecular = 0.02;

const float3 scatteringLow = exp(-float3(4.0, 2.5, 2.4) * 1.25);
const float3 scatteringHigh = exp(-float3(4.0, 2.5, 2.5) * 1.25);

#define WAVE_MAP_ENABLE 1
#define WAVE_MAP_FILE "textures/wave.png"

#define RIPPLE_MAP_ENABLE 0
#define RIPPLE_MAP_FILE "textures/ripple.png"

#include "material_common.fxsub"