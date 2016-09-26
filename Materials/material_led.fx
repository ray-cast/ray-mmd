#define USE_CUSTOM_MATERIAL 1

// 反照率贴图
#define ALBEDO_MAP_ENABLE 0
#define ALBEDO_MAP_IN_TEXTURE 0
#define ALBEDO_MAP_ANIMATION_ENABLE 0 // 指定图片是GIF/APNG时启用 (ALBEDO_MAP_IN_TEXTURE 必须为 0)
#define ALBEDO_MAP_ANIMATION_SPEED 1  // 最小为1倍速
#define ALBEDO_MAP_UV_FLIP 0
#define ALBEDO_MAP_APPLY_COLOR 0
#define ALBEDO_MAP_APPLY_DIFFUSE 0
#define ALBEDO_APPLY_MORPH_COLOR 0
#define ALBEDO_MAP_FILE "albedo.png"

const float3 albedo = 0.0;
const float albedoMapLoopNum = 1.0;

// 法线贴图
#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapLoopNum = 1.0;
const float normalMapScale = 1.0;

// 子法线贴图
#define NORMAL_MAP_SUB_ENABLE 0
#define NORMAL_MAP_SUB_UV_FLIP 0
#define NORMAL_MAP_SUB_UV_ROTATE 0
#define NORMAL_MAP_SUB_FILE "normal.png"

const float normalMapSubLoopNum = 1.0;
const float normalMapSubScale = 1;

// 光滑度
#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_IN_TONEMAP 0
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE  0
#define SMOOTHNESS_MAP_FILE "smoothness.png"

const float smoothness = 0.0;
const float smoothnessMapLoopNum = 1.0;

// 金属程度
#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_IN_TONEMAP 0
#define METALNESS_MAP_UV_FLIP 0
#define METALNESS_MAP_SWIZZLE  0
#define METALNESS_MAP_FILE "metalness.png"

const float metalness = 0.0;
const float metalnessBaseSpecular = 0.04;
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
#define MELANIN_MAP_UV_FLIP 0
#define MELANIN_MAP_SWIZZLE  0
#define MELANIN_MAP_FILE "melanin.png"

const float melanin = 0.0;
const float melaninMapLoopNum = 0.0;

// 发光贴图
#define EMISSIVE_ENABLE 1
#define EMISSIVE_USE_ALBEDO 0 //参数来至albedo,但可以使用EMISSIVE_APPLY_COLOR 和 EMISSIVE_APPLY_MORPH_COLOR
#define EMISSIVE_MAP_ENABLE 1
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_SCREEN_MAP 1 // 使用来至屏幕或avi的纹理
#define EMISSIVE_MAP_ANIMATION_ENABLE 0 // 指定图片是GIF/APNG时启用 (ALBEDO_MAP_IN_TEXTURE 必须为 0)
#define EMISSIVE_MAP_ANIMATION_SPEED 1  // 最小为1倍速
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 1
#define EMISSIVE_APPLY_MORPH_COLOR 1
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 0.45;
const float emissiveMapLoopNum = 1.0;

// 视差贴图
#define PARALLAX_MAP_ENABLE 0
#define PARALLAX_MAP_UV_FLIP 0
#define PARALLAX_MAP_FILE "height.png"

const float parallaxMapScale = 0.01;
const float parallaxMapLoopNum = 1.0;

// 纹理过滤方式
#define TEXTURE_USE_LINEAR 0
#define TEXTURE_USE_NEAREST 0
#define TEXTURE_USE_ANISOTROPY 1
#define TEXTURE_USE_MIP_NONE 0
#define TEXTURE_USE_MIP_LINEAR 0
#define TEXTURE_USE_MIP_NEAREST 1
#define TEXTURE_ANISOTROPY_LEVEL  16 // 启用各向异性采样时最大的采样等级 (0 ~ 16)

#include "material_common.fxsub"