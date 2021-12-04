#define LIGHT_PARAMS_TYPE 0

static const float3 lightBlink = 0.0;
static const float3 lightColor = 1.0;
static const float3 lightIntensityLimits = float3(1.0, 0.0, 10.0);
static const float3 lightTemperatureLimits = float3(6600, 1000, 12500);

#define SHADOW_MAP_FROM 0

static const float2 shadowHardness = float2(0.15, 0.5);

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#include "directional_lighting.fxsub"