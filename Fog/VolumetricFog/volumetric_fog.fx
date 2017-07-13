#define VOLUMETRIC_FOG_ANISOTROPY 1
#define VOLUMETRIC_FOG_WITH_JITTER 1
#define VOLUMETRIC_FOG_HEIGHT_ADJUST 0
#define VOLUMETRIC_FOG_SAMPLES_LENGTH 48

static const float3 FogRangeParams = float3(1.0, 0.0, 100.0);
static const float3 FogHeightParams = float3(1.0, 0.0, 20.0);
static const float3 FogIntensityParams = float3(1.0, 0.0, 10.0);
static const float3 FogMieParams = float3(0.76, 0.01, 0.999);
static const float3 FogDensityParams = float3(0.01, 0.0001, 0.25);

#include "volumetric_fog.fxsub"