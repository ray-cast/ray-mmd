#define USE_CUSTOM_MATERIAL 1

#define ALBEDO_MAP_ENABLE 1
#define ALBEDO_MAP_ANIMATION_ENABLE 0
#define ALBEDO_MAP_IN_TEXTURE 1
#define ALBEDO_MAP_IN_SCREEN_MAP 0
#define ALBEDO_MAP_UV_FLIP 0
#define ALBEDO_MAP_UV_REPETITION 0
#define ALBEDO_MAP_APPLY_COLOR 0
#define ALBEDO_MAP_APPLY_DIFFUSE 0
#define ALBEDO_APPLY_MORPH_COLOR 0
#define ALBEDO_MAP_FILE "albedo.png"

const float3 albedo = pow(float3(0.1372549, 0.3490196, 0.5882353), 2.2);
const float2 albedoMapLoopNum = 1.0;

#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_ANIMATION_ENABLE 0
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_ANIMATION_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0
#define NORMAL_MAP_IS_COMPRESSED 0
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_UV_REPETITION 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapScale = 1.0;
const float normalMapLoopNum = 1.0;

#define NORMAL_MAP_SUB_ENABLE 0
#define NORMAL_MAP_SUB_ANIMATION_ENABLE 0
#define NORMAL_MAP_SUB_IN_SPHEREMAP 0
#define NORMAL_MAP_SUB_IS_COMPRESSED 0
#define NORMAL_MAP_SUB_UV_FLIP 0
#define NORMAL_MAP_SUB_UV_REPETITION 0
#define NORMAL_MAP_SUB_FILE "normal.png"

const float normalMapSubScale = 1.0;
const float normalMapSubLoopNum = 1.0;

#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_ANIMATION_ENABLE 0
#define SMOOTHNESS_MAP_IN_TOONMAP 0
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE 0
#define SMOOTHNESS_MAP_APPLY_SCALE 0
#define SMOOTHNESS_MAP_FILE "smoothness.png"

const float smoothness = 1.0;
const float smoothnessMapLoopNum = 1.0;

#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_ANIMATION_ENABLE 0
#define METALNESS_MAP_IN_TOONMAP 0
#define METALNESS_MAP_UV_FLIP 0
#define METALNESS_MAP_SWIZZLE 0
#define METALNESS_MAP_APPLY_SCALE 0
#define METALNESS_MAP_FILE "metalness.png"

const float metalness = 0.0;
const float metalnessMapLoopNum = 1.0;
const float metalnessBaseSpecular = 0.02; 

#define CUSTOM_ENABLE 4

#define CUSTOM_A_MAP_ENABLE 0
#define CUSTOM_A_MAP_IN_TOONMAP 0
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.0;
const float customAMapLoopNum = 1.0;

#define CUSTOM_B_MAP_ENABLE 0
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_COLOR 0
#define CUSTOM_B_MAP_FILE "custom.png"

const float3 customB = exp(-float3(40, 25, 25) * 0.125); //pow(float3(0.03, 0.05, 0.05), 1.2);
const float customBMapLoopNum = 1.0;

#include "material_common.fxsub"