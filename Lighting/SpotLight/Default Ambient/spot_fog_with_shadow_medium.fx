#define VOLUMETRIC_FOG_ENABLE 1
#define VOLUMETRIC_FOG_MAP_QUALITY 0
#define VOLUMETRIC_FOG_SAMPLES_LENGTH 100
#define VOLUMETRIC_FOG_ANISOTROPY 1

static const float3 FogAngleParams = float3(45.0f, 30.0, 60.0f);
static const float3 FogRangeParams = float3(1.0, 0.0, 200.0);
static const float3 FogAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 FogIntensityParams = float3(1.0, 0.0, 20.0);
static const float3 FogMieParams = float3(0.76, 0.01, 0.999);
static const float3 FogDensityParams = float3(0.025, 0.001, 0.25);

#include "../spot_fog.fxsub"