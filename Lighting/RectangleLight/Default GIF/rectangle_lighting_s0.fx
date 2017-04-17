#define LIGHT_PARAMS_FROM 0
#define LIGHT_PARAMS_TYPE 0

static const float lightRange = 200.0;
static const float lightAttenuationBulb = 1.0;

static const float3 lightBlink = 0.0;
static const float2 lightSize = float2(10, 1.0);
static const float3 lightColor = float3(1.0, 1.0, 1.0) * 100.0;

static const float2 lightRangeLimits = float2(1.0, 200.0);
static const float2 lightIntensityLimits = float2(100.0, 2000.0);

#define SHADOW_MAP_FROM 1
#define SHADOW_MAP_QUALITY 0

static const float shadowHardness = 0.15;

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
static const float sampleRadius = 2;
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

#define VIDEO_MAP_FROM 2
#define VIDEO_MAP_UV_FLIP 0
#define VIDEO_MAP_FILE "texture/rance.gif"

const float vedioMapLoopNum = 1.0;

#include "../rectangle_lighting.fxsub"