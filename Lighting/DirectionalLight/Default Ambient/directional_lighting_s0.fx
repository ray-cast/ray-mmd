#define LIGHT_PARAMS_FROM 0
#define LIGHT_PARAMS_TYPE 1

static const float3 lightBlink = 0.0;
static const float3 lightColor = 1.0;
static const float2 lightIntensityLimits = float2(1.0, 10.0);

#define SHADOW_MAP_FROM 1
#define SHADOW_MAP_QUALITY 0

static const float shadowRange = 200;
static const float shadowHardness = 0.15;

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#include "../directional_lighting.fxsub"