#define USE_CUSTOM_MATERIAL 1

#define ALBEDO_MAP_ENABLE 1
#define ALBEDO_MAP_IN_TEXTURE 0
#define ALBEDO_MAP_IN_SCREEN_MAP 0
#define ALBEDO_MAP_ANIMATION_ENABLE 0
#define ALBEDO_MAP_UV_FLIP 0
#define ALBEDO_MAP_UV_REPETITION 0
#define ALBEDO_MAP_APPLY_COLOR 0
#define ALBEDO_MAP_APPLY_DIFFUSE 1
#define ALBEDO_APPLY_MORPH_COLOR 0
#define ALBEDO_MAP_FILE "textures/Skin_-_Human_Albedo.png"

const float3 albedo = 1.0;
const float2 albedoMapLoopNum = 5.0;

#define ALBEDO_SUB_ENABLE 4
#define ALBEDO_SUB_MAP_ENABLE 0
#define ALBEDO_SUB_MAP_IN_TEXTURE 0
#define ALBEDO_SUB_MAP_UV_FLIP 0
#define ALBEDO_SUB_MAP_APPLY_SCALE 0
#define ALBEDO_SUB_MAP_FILE "albedo.png"

const float3 albedoSub = 0.1;
const float2 albedoSubMapLoopNum = 1.0;

#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_ANIMATION_ENABLE 0
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_ENABLE 1
#define NORMAL_MAP_IN_SPHEREMAP 0
#define NORMAL_MAP_IS_COMPRESSED 0
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_UV_REPETITION 0
#define NORMAL_MAP_FILE "textures/Skin_-_Human_Normal.png"

const float normalMapScale = 1.0;
const float normalMapLoopNum = 5.0;

#define NORMAL_MAP_SUB_ENABLE 1
#define NORMAL_MAP_SUB_IN_SPHEREMAP 0
#define NORMAL_MAP_SUB_IS_COMPRESSED 0
#define NORMAL_MAP_SUB_UV_FLIP 0
#define NORMAL_MAP_SUB_UV_REPETITION 0
#define NORMAL_MAP_SUB_FILE "../../_MaterialMap/skin.png"

const float normalMapSubScale = 1.0;
const float normalMapSubLoopNum = 60.0;

#define SMOOTHNESS_MAP_ENABLE 1
#define SMOOTHNESS_MAP_IN_TOONMAP 0
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE 0
#define SMOOTHNESS_MAP_APPLY_SCALE 0
#define SMOOTHNESS_MAP_FILE "textures/Skin_-_Human_Gloss.PNG"

const float smoothness = 1.0;
const float smoothnessMapLoopNum = 5.0;

#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_IN_TOONMAP 0
#define METALNESS_MAP_UV_FLIP 0
#define METALNESS_MAP_SWIZZLE 0
#define METALNESS_MAP_APPLY_SCALE 0
#define METALNESS_MAP_FILE "metalness.png"

const float metalness = 0.05;
const float metalnessMapLoopNum = 1.0;
const float metalnessBaseSpecular = 0.04; 

#define EMISSIVE_ENABLE 0
#define EMISSIVE_USE_ALBEDO 0
#define EMISSIVE_MAP_ENABLE 0
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_SCREEN_MAP 0
#define EMISSIVE_MAP_ANIMATION_ENABLE 0
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 0
#define EMISSIVE_APPLY_MORPH_COLOR 0
#define EMISSIVE_APPLY_MORPH_INTENSITY 0
#define EMISSIVE_APPLY_BLINK 0
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 1.0;
const float3 emissiveBlink = 1.0;
const float  emissiveIntensity = 1.0;
const float2 emissiveMapLoopNum = 1.0;

#define PARALLAX_MAP_ENABLE 0
#define PARALLAX_MAP_UV_FLIP 0
#define PARALLAX_MAP_SUPPORT_ALPHA 0
#define PARALLAX_MAP_FILE "height.png"

const float parallaxMapScale = 0.01;
const float parallaxMapLoopNum = 1.0;

#define OCCLUSION_MAP_ENABLE 0
#define OCCLUSION_MAP_IN_TOONMAP 0
#define OCCLUSION_MAP_UV_FLIP 0
#define OCCLUSION_MAP_SWIZZLE 0
#define OCCLUSION_MAP_APPLY_SCALE 0 
#define OCCLUSION_MAP_FILE "occlusion.png"

const float occlusionMapScale = 1.0;
const float occlusionMapLoopNum = 1.0;

#define CUSTOM_ENABLE 1

#define CUSTOM_A_MAP_ENABLE 0
#define CUSTOM_A_MAP_IN_TOONMAP 0
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.6;
const float customAMapLoopNum = 1.0;

#define CUSTOM_B_MAP_ENABLE 0
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_COLOR 0
#define CUSTOM_B_MAP_FILE "custom.png"
#define SSS_SKIN_TRANSMITTANCE(x) exp((1 - saturate(x)) * float3(-8, -40, -64))

const float3 customB = SSS_SKIN_TRANSMITTANCE(0.8);
const float2 customBMapLoopNum = 1.0;

#include "../../material_common.fxsub"