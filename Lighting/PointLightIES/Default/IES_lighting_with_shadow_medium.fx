#define LIGHT_PARAMS_FROM 0
#define LIGHT_PARAMS_TYPE 0
#define LIGHT_PARAMS_FILE "IES.HDR"

static const float lightRange = 200.0;
static const float lightAttenuationBulb = 1.0;

static const float3 lightBlink = 0.0;
static const float3 lightColor = float3(1.0, 1.0, 1.0) * 500.0;

static const float2 lightRangeLimits = float2(1.0, 200.0);
static const float2 lightIntensityLimits = float2(100.0, 2000.0);

#define SHADOW_MAP_FROM 1
#define SHADOW_MAP_QUALITY 1

static const float shadowHardness = 0.20;

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#include "../ies_lighting.fxsub"