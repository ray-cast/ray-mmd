#define SKYBOX_FOG_TYPE 0

const float3 mFogBaseHeightLimit = float3(-50, 100, -100);
const float3 mFogMaximumHeightLimit = float3(1500, 3000, 0);
const float3 mFogAttenuationDistanceLimit = float3(200, 1000, 50);
const float3 mFogDensityLimit = float3(0.0002, 0.01, 1e-5);

#include "../../shader/Gradient Based Fog.fxsub"