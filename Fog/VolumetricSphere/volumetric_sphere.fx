#define VOLUMETRIC_FOG_ANISOTROPY 1
#define VOLUMETRIC_FOG_SAMPLES_LENGTH 8

static const float3 FogRangeParams = float3(10.0, 0.0, 100.0);
static const float3 FogAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 FogIntensityParams = float3(1.0, 0.0, 20.0);
static const float3 FogMieParams = float3(0.76, 0.01, 0.999);
static const float3 FogDensityParams = float3(0.025, 0.001, 0.25);

#include "volumetric_sphere.fxsub"