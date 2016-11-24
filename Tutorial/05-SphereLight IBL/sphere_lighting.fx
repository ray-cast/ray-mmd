// 最大光照范围
#define LIGHTSOURCE_MAX_RANGE 200

// 最小强度
#define LIGHTSOURCE_MIN_INTENSITY 100

// 最大强度
#define LIGHTSOURCE_MAX_INTENSITY 2000

// 阴影
#define SHADOW_MAP_ENABLE 0
#define SHADOW_MAP_QUALITY 0 // (0 ~ 3)
#define SHADOW_MAP_SOFT_QUALITY 1 // (0 ~ 3)

#define IBL_ENABLE 1
#define IBL_MIPMAP_LEVEL 7
#define IBL_RGBM_RANGE 6

#define IBLDIFF_MAP_FILE "texture/skydiff_hdr.dds"
#define IBLSPEC_MAP_FILE "texture/skyspec_hdr.dds"

#include "sphere_lighting.fxsub"