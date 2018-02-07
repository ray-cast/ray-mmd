#define LIGHT_PARAMS_TYPE 1

static const float3 lightRangeParams = float3(100.0, 0.0, 200.0);
static const float3 lightIntensityParams = float3(100, 0.0, 2000.0);
static const float3 lightAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 lightTemperatureLimits = float3(6600, 1000, 12500);

#define SHADOW_MAP_FROM 0
#define SHADOW_MAP_QUALITY 0

static const float2 shadowHardness = float2(0.15, 0.5);

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 3;
static const float sampleKernel[7] = {0.071303, 0.131514, 0.189879, 0.214607, 0.189879, 0.131514, 0.071303};

#include "../spot_lighting.fxsub"