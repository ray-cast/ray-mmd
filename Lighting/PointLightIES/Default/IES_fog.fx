#define LIGHT_PARAMS_FROM 0
#define LIGHT_PARAMS_TYPE 0
#define LIGHT_PARAMS_FILE "IES.HDR"

#define VOLUMETRIC_FOG_ENABLE 0
#define VOLUMETRIC_FOG_MAP_QUALITY 0
#define VOLUMETRIC_FOG_SAMPLES_LENGTH 64
#define VOLUMETRIC_FOG_ANISOTROPY 2

static const float3 FogRangeParams = float3(1.0, 0.0, 200.0);
static const float3 FogAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 FogIntensityParams = float3(1.0, 0.0, 20.0);
static const float3 FogMieParams = float3(0.76, 0.01, 0.999);
static const float3 FogDensityParams = float3(0.025, 0.25, 0.001);

#include "../ies_fog.fxsub"