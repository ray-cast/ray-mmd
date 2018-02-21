#define LIGHT_PARAMS_TYPE 1

static const float3 lightRangeParams = float3(100.0, 0.0, 200.0);
static const float3 lightIntensityParams = float3(100.0, 0.0, 2000.0);
static const float3 lightAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 lightTemperatureLimits = float3(6600, 1000, 12500);

#define SHADOW_MAP_FROM 1
#define SHADOW_MAP_QUALITY 0

static const float2 shadowHardness = float2(0.15, 0.5);

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#define VIDEO_MAP_FROM 0
#define VIDEO_MAP_UV_FLIP 0
#define VIDEO_MAP_FILE "video.png"

const float vedioMapLoopNum = 1.0;

#include "../rectangle_lighting.fxsub"