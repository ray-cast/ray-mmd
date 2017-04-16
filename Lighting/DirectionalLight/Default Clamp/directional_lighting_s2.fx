#define LIGHT_PARAMS_FROM 0
#define LIGHT_PARAMS_TYPE 2
#define LIGHT_PARAMS_APPLY_SCALE 0

static const float3 lightColor = 1.0;
static const float2 lightIntensityLimits = float2(1.0, 10.0);

#define SHADOW_MAP_ENABLE 1
#define SHADOW_MAP_QUALITY 2 // (0 ~ 3)

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
// You can customize GaussianBlur coefficient by : http://dev.theomader.com/gaussian-kernel-calculator
static const float sampleRadius = 2;  // suggest 2 or 3
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#include "../directional_lighting.fxsub"