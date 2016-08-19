#define USE_CUSTOM_MATERIAL

// 金属程度
const float metalness = 0.0;

// 光滑度
const float smoothness = 0.9;

// 黑色素
const float melanin = 0.0;

#define ENABLE_SSS
const float3 transmittance = float3(0.1, 0.1, 0.1);

#include "material_common.fxsub"