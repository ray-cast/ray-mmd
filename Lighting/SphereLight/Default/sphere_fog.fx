#define VOLUMETRIC_FOG_ENABLE 0
#define VOLUMETRIC_FOG_MAP_QUALITY 0
#define VOLUMETRIC_FOG_SAMPLES_LENGTH 48
#define VOLUMETRIC_FOG_ANISOTROPY 1

static const float3 FogRangeParams = float3(100.0, 0.0, 200.0);
static const float3 FogAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 FogIntensityParams = float3(5.0, 0.0, 50.0);
static const float3 FogMieParams = float3(0.76, 0.01, 0.999);
static const float3 FogDensityParams = float3(0.025, 0.001, 0.25);
static const float3 FogTemperatureLimits = float3(6600, 1000, 40000);

#include "../sphere_fog.fxsub"