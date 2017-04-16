// 最大范围
#define LIGHTSOURCE_MAX_RANGE 200

// 最小强度
#define LIGHTSOURCE_MIN_INTENSITY 100

// 最大强度
#define LIGHTSOURCE_MAX_INTENSITY 2000

// 是否去掉镜面光
#define LIGHTSOURCE_DIFFUSE_ONLY 0

// 阴影
#define SHADOW_MAP_ENABLE 0
#define SHADOW_MAP_QUALITY 0 // (0 ~ 3)
#define SHADOW_MAP_SOFT_QUALITY 0 // (0 ~ 3)
#define SHADOW_MAP_BLUR_QUALITY 1 // (0 ~ 2)

#define IES_FILE_PATH "Textures/TopPost.hdr"

#include "../IES_lighting.fxsub"