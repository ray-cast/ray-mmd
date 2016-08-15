#define USE_CUSTOM_MATERIAL

// 金属程度
const float metalness = 0.0;

// 光滑度
const float smoothness = 0.3;

// 黑色素
const float melanin = 0.0;

// 反射率
const float3 reflection = 0.04;

#define ENABLE_SSS
#define ENABLE_SSS_SKIN

// 皮肤的次表面散射通透度
const float translucency = 0.75;
const float3 transmittance = float3(1, 0, 0);

#include "material_common.fxsub"