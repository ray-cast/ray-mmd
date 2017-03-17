#define USE_CUSTOM_MATERIAL 0         // When set to 1, u can create a custom material.

#define ALBEDO_MAP_ENABLE 1           // When set to 1, this allows u to use texture. set to 0, use albedo color.
#define ALBEDO_MAP_ANIMATION_ENABLE 0 // Texture can be create from a GIF/APNG anim
#define ALBEDO_MAP_IN_TEXTURE 1       // Texture can be create from a pmx.
#define ALBEDO_MAP_IN_SCREEN_MAP 0    // Texture can be create from a screen map or AVI map
#define ALBEDO_MAP_UV_FLIP 0          // Flip texture horizontal, X axis.
#define ALBEDO_MAP_UV_REPETITION 0    // Loop mode : 1 : tile, 2 : no tile mode1, 3 : no tile mode2
#define ALBEDO_MAP_APPLY_COLOR 0      // Texture colors to multiply with the with the (1 = map*albedo, 2 = map^albedo).
#define ALBEDO_MAP_APPLY_DIFFUSE 1    // Texture colors to multiply with the diffuse of PMX.
#define ALBEDO_APPLY_MORPH_COLOR 0    // Texture colors to multiply with the morph (R+,G+,B+) of controller.
#define ALBEDO_MAP_FILE "albedo.png"  // Enter the path to the texture resource. parent folder ref is "../"

const float3 albedo = 1.0;            // between float3(0, 0, 0) ~ float3(1, 1, 1) or albedo = float3(125, 125, 125) / 255;
const float2 albedoMapLoopNum = 1.0;  // between 0.0 ~ inf or float2 albedoMapLoopNum = float2(x, y);

#define ALBEDO_SUB_ENABLE 0           // 1 : melanin, 2 : albedo * albedoSub, 3 : albedo ^ albedoSub, 4 : albedo + albedoSub
#define ALBEDO_SUB_MAP_ANIMATION_ENABLE 0
#define ALBEDO_SUB_MAP_ENABLE 0
#define ALBEDO_SUB_MAP_IN_TEXTURE 0
#define ALBEDO_SUB_MAP_UV_FLIP 0
#define ALBEDO_SUB_MAP_APPLY_SCALE 0
#define ALBEDO_SUB_MAP_FILE "albedo.png"

const float3 albedoSub = 0.0;
const float2 albedoSubMapLoopNum = 1.0;

#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_ANIMATION_ENABLE 0
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3           // The ordering of the data fetched from a texture from code. (R = 0, G = 1, B = 2, A = 3)
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_ANIMATION_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0   // Texture can be create from a sph map.
#define NORMAL_MAP_IS_COMPRESSED 0  // RG normal map to RGB normal
#define NORMAL_MAP_UV_FLIP 0        // 1 : Filp texture x-axis, 2 : Filp normal x-axis (ignore map)
#define NORMAL_MAP_UV_REPETITION 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapScale = 1.0;
const float normalMapLoopNum = 1.0;

#define NORMAL_MAP_SUB_ENABLE 0
#define NORMAL_MAP_SUB_ANIMATION_ENABLE 0
#define NORMAL_MAP_SUB_IN_SPHEREMAP 0   // Texture can be create from a sph map.
#define NORMAL_MAP_SUB_IS_COMPRESSED 0  // RG normal map to RGB normal
#define NORMAL_MAP_SUB_UV_FLIP 0        // Filp texture x-axis
#define NORMAL_MAP_SUB_UV_REPETITION 0
#define NORMAL_MAP_SUB_FILE "normal.png"

const float normalMapSubScale = 1.0;
const float normalMapSubLoopNum = 1.0;

#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_ANIMATION_ENABLE 0
#define SMOOTHNESS_MAP_IN_TOONMAP 0    // Texture can be create from a toon map.
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0  // Roughness map to smoothness
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE 0
#define SMOOTHNESS_MAP_APPLY_SCALE 0   // Map values to multiply with the (1 = map * smoothness, 2 = map ^ smoothness).
#define SMOOTHNESS_MAP_FILE "smoothness.png"

const float smoothness = 0.5;
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
const float metalnessBaseSpecular = 0.04; // minimum of specular coefficient

#define EMISSIVE_ENABLE 0
#define EMISSIVE_USE_ALBEDO 0
#define EMISSIVE_MAP_ENABLE 0
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_SCREEN_MAP 0
#define EMISSIVE_MAP_ANIMATION_ENABLE 
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 0
#define EMISSIVE_APPLY_MORPH_COLOR 0
#define EMISSIVE_APPLY_MORPH_INTENSITY 0
#define EMISSIVE_APPLY_BLINK 0
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 1.0;
const float3 emissiveBlink = 1.0;       // between float3(0, 0, 0) ~ float3(10, 10, 10)
const float  emissiveIntensity = 1.0;
const float2 emissiveMapLoopNum = 1.0;

#define OCCLUSION_MAP_ENABLE 0
#define OCCLUSION_MAP_IN_TOONMAP 0
#define OCCLUSION_MAP_UV_FLIP 0
#define OCCLUSION_MAP_SWIZZLE 0
#define OCCLUSION_MAP_APPLY_SCALE 0 
#define OCCLUSION_MAP_FILE "occlusion.png"

const float occlusionMapScale = 1.0;
const float occlusionMapLoopNum = 1.0;

#define PARALLAX_MAP_ENABLE 0
#define PARALLAX_MAP_UV_FLIP 0
#define PARALLAX_MAP_SUPPORT_ALPHA 0
#define PARALLAX_MAP_FILE "height.png"

const float parallaxMapScale = 0.01;
const float parallaxMapLoopNum = 1.0;

// Shading Material ID
// 0 : Default            // customA = invalid,    customB = invalid
// 1 : PreIntegrated Skin // customA = curvature,  customB = transmittance color;
// 2 : Unlit placeholder  // customA = invalid,    customB = invalid
// 3 : Reserved
// 4 : Glass              // customA = Fake Ior    customB = Refract Color
// 5 : Cloth              // customA = sheen,      customB = Fuzz Color
// 6 : Clear Coat         // customA = smoothness, customB = invalid;
// 7 : Subsurface         // customA = curvature,  customB = transmittance color;
#define CUSTOM_ENABLE 0  // ID

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

const float3 customB = 0.0;
const float2 customBMapLoopNum = 1.0;

#include "material_common.fxsub"