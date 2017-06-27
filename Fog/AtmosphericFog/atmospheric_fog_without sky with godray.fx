// ignore sky fog
#define FOG_DISCARD_SKY 1

#define FOG_WITH_GODRAY 1
#define FOG_WITH_GODRAY_SAMPLES 64

static const float FogSampleLength = 0.5f;

// R : default value
// G : min value for Slider Bar
// B : max value for Slider Bar
static const float3 FogRangeParams = float3(1.0, 1e-2, 20.0f);
static const float3 FogIntensityParams = float3(1.0, 0.1, 10.0f);
static const float3 FogDensityParams = float3(1000, 1, 50000);
static const float3 FogMiePhaseParams = float3(0.76, 0.1, 0.98);
static const float3 FogMieTurbidityParams = float3(100, 1, 1000);

static const float3 mWaveLength = float3(670e-9,620e-9,580e-9);

#include "atmospheric_fog.fxsub"