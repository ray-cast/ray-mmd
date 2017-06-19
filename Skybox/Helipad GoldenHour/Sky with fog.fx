#define SKYBOX_FOG_ENABLE 1
#define SKYBOX_FOG_MIPMAP_LEVEL 7
#define SKYBOX_FOG_MAP_FILE "texture/skyspec_hdr.dds"

// R : default value
// G : min value
// B : max value
const float3 mFogNearLimit = float3(0.1f, 1e-5f, 1000.0f);
const float3 mFogFarLimit = float3(3000.0f, 1000.0f, 10000.0f);
const float3 mFogRangeLimit = float3(1.0f, 1e-5f, 2.0f);
const float3 mFogDensityLimit = float3(5000.0f, 1.0f, 10000.0f);

#include "../../shader/skybox_fog.fxsub"