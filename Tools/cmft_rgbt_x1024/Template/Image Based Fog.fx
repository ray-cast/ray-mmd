#define SKYBOX_FOG_ENABLE 1
#define SKYBOX_FOG_TYPE 0
#define SKYBOX_FOG_MIPMAP_LEVEL 7
#define SKYBOX_FOG_DISCARD_SKY 0
#define SKYBOX_FOG_MAP_FILE "texture/skyspec_hdr.dds"

const float3 mFogBaseHeightLimit = float3(-50, 100, -100);
const float3 mFogMaximumHeightLimit = float3(1500, 3000, 0);
const float3 mFogAttenuationDistanceLimit = float3(200, 1000, 50);
const float3 mFogDensityLimit = float3(0.002, 0.1, 1e-5);

#include "../../shader/Image Based Fog.fxsub"