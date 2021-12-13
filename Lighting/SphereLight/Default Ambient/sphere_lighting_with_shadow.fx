#define SHADOW_MAP_FROM 1
#define LIGHT_PARAMS_TYPE 1

#define IBL_MAP_FROM 0
#define IBL_MAP_MIPMAP_LEVEL 7

#define IBLDIFF_MAP_FILE "texture/skydiff_hdr.dds"
#define IBLSPEC_MAP_FILE "texture/skyspec_hdr.dds"

static const float3 lightRangeParams = float3(100.0, 0.0, 200.0);
static const float3 lightIntensityParams = float3(1000, 0.0, 20000.0);
static const float3 lightAttenuationBulbParams = float3(1.0, 0.0, 5.0);
static const float3 lightTemperatureLimits = float3(6600, 1000, 40000);

#include "../sphere_lighting.fxsub"