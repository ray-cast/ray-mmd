#define LIGHT_PARAMS_TYPE 0
#define LIGHT_PARAMS_FILE "IES.HDR"

static const float3 lightRangeParams = float3(100.0, 0.0, 200.0);
static const float3 lightIntensityParams = float3(100.0, 0.0, 2000.0);
static const float3 lightAttenuationBulbParams = float3(1.0, 0.0, 5.0);

#define SHADOW_MAP_FROM 1
#define SHADOW_MAP_QUALITY 3

static const float2 shadowHardness = float2(0.15, 0.5);

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#define VIDEO_MAP_FROM 2
#define VIDEO_MAP_UV_FLIP 0
#define VIDEO_MAP_FILE "texture/rance.gif"

const float vedioMapLoopNum = 1.0;

#include "../rectangle_lighting.fxsub"