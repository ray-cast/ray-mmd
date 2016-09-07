#define USE_CUSTOM_MATERIAL 1
#define SKYBOX_ENABLE 1

// 反照率贴图
#define ALBEDO_MAP_ENABLE 0
#define ALBEDO_MAP_IN_TEXTURE 0
#define ALBEDO_MAP_UV_FLIP 0
#define ALBEDO_MAP_APPLY_COLOR 0
#define ALBEDO_MAP_FILE "albedo.png"

const float3 albedo = 1;
const float albedoMapLoopNum = 1.0;

// 透明通道
#define ALPHA_ENABLE 1
#define ALPHA_MAP_ENABLE 0
#define ALPHA_MAP_IN_TEXTURE 0
#define ALPHA_MAP_SWIZZLE_R  0
#define ALPHA_MAP_SWIZZLE_G  0
#define ALPHA_MAP_SWIZZLE_B  0
#define ALPHA_MAP_SWIZZLE_A  0
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1;
const float alphaMapLoopNum = 1.0;

// 法线贴图
#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapLoopNum = 1.0;
const float normalMapScale = 1.0;

// 光滑度
#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_IN_TONEMAP 1
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0
#define SMOOTHNESS_MAP_SWIZZLE_R  0
#define SMOOTHNESS_MAP_SWIZZLE_G  0
#define SMOOTHNESS_MAP_SWIZZLE_B  0
#define SMOOTHNESS_MAP_SWIZZLE_A  0
#define SMOOTHNESS_MAP_FILE "smoothness.png"

const float smoothness = 0.0;
const float smoothnessMapLoopNum = 1.0;

// 金属程度
#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_IN_TONEMAP 0
#define METALNESS_MAP_SWIZZLE_R  0
#define METALNESS_MAP_SWIZZLE_G  1
#define METALNESS_MAP_SWIZZLE_B  0
#define METALNESS_MAP_SWIZZLE_A  0
#define METALNESS_MAP_FILE "metalness.png"

const float metalness = 0.0;
const float metalnessBaseSpecular = 0.0;
const float metalnessMapLoopNum = 1.0;

// 次表面散射
#define SSS_ENABLE 0
#define SSS_MAP_ENABLE 0
#define SSS_MAP_UV_FLIP 0
#define SSS_MAP_APPLY_COLOR 0
#define SSS_MAP_FILE "transmittance.png"

const float3 transmittance = 0.0;
const float transmittanceStrength = 0.0f;
const float transmittanceMapLoopNum = 1.0;

// 黑色素
#define MELANIN_MAP_ENABLE 0
#define MELANIN_MAP_SWIZZLE_R  0
#define MELANIN_MAP_SWIZZLE_G  0
#define MELANIN_MAP_SWIZZLE_B  0
#define MELANIN_MAP_SWIZZLE_A  0
#define MELANIN_MAP_FILE "melanin.png"

const float melanin = 0.0;
const float melaninMapLoopNum = 1.0;

// 发光贴图
#define EMISSIVE_ENABLE 0
#define EMISSIVE_MAP_ENABLE 0
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_ALBEDO 0 // 使用albedo指定的纹理
#define EMISSIVE_MAP_ANIMATION_ENABLE 0 // 指定图片是GIF/APNG时启用 (ALBEDO_MAP_IN_TEXTURE 必须为 0)
#define EMISSIVE_MAP_ANIMATION_SPEED 1  // 最小为1倍速
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 0
#define EMISSIVE_APPLY_MORPH_COLOR 0
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 1.0;
const float emissiveMapLoopNum = 1.0;

#include "material_common.fxsub"