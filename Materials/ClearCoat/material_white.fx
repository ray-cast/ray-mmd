#define USE_CUSTOM_MATERIAL 1         // When set to 1, u can create a custom material.

// 反照率贴图
#define ALBEDO_MAP_ENABLE 0           // When set to 1, this allows u to use texture. set to 0, use albedo color.
#define ALBEDO_MAP_IN_TEXTURE 0       // Texture can be create from a pmx.
#define ALBEDO_MAP_IN_SCREEN_MAP 0    // Texture can be create from a screen map or AVI map, see "Tutorial\04-LED".
#define ALBEDO_MAP_ANIMATION_ENABLE 0 // Texture can be create from a GIF/APNG anim, see "Tutorial\01-GIF Animation".
#define ALBEDO_MAP_ANIMATION_SPEED 1  // The minimum speed is 1x.
#define ALBEDO_MAP_UV_FLIP 0          // Flip texture horizontal, X axis.
#define ALBEDO_MAP_UV_REPETITION 0    // Texture repetition/loop mode, 0 = Default Tile, 1 = Texture No Tile 1, 2 = Texture No Tile 2
#define ALBEDO_MAP_APPLY_COLOR 0      // Texture colors to multiply with the albedo color.
#define ALBEDO_MAP_APPLY_DIFFUSE 1    // Texture colors to multiply with the PMX.
#define ALBEDO_APPLY_MORPH_COLOR 0    // Texture colors to multiply with the "morph controller".
#define ALBEDO_MAP_FILE "albedo.png"  // Enter the path to the texture resource.

const float3 albedo = 1.0;            // albedo = float3(r, g, b) or albedo = float3(125,125,125) / 255;
const float albedoMapLoopNum = 1.0;   // Number of iterations // float2 albedoMapLoopNum = float2(x, y);

// 透明通道
#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_ANIMATION_ENABLE 0
#define ALPHA_MAP_ANIMATION_SPEED 0
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3           // The ordering of the data fetched from a texture from code. (R = 0, G = 1, B = 2, A = 3)
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

// 法线贴图
#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0      // Texture can be create from a sph map.
#define NORMAL_MAP_IS_COMPRESSED 0     // RG normal map to RGB normal.
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_UV_REPETITION 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapScale = 1.0;      // Normal map strength;
const float normalMapLoopNum = 1.0;

// 子法线贴图
#define NORMAL_MAP_SUB_ENABLE 0
#define NORMAL_MAP_SUB_IN_SPHEREMAP 0
#define NORMAL_MAP_SUB_IS_COMPRESSED 0
#define NORMAL_MAP_SUB_UV_FLIP 0
#define NORMAL_MAP_SUB_UV_REPETITION 0
#define NORMAL_MAP_SUB_FILE "normal.png"

const float normalMapSubScale = 1;
const float normalMapSubLoopNum = 1.0;

// 光滑度
#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_IN_TOONMAP 0    // Texture can be create from a toon map.
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0  // roughness is (1.0f - smoothness)^2 but not 1.0 - smoothness.
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE 0
#define SMOOTHNESS_MAP_APPLY_SCALE 0   // smoothness values to multiply with the smoothness.
#define SMOOTHNESS_MAP_FILE "smoothness.png"

const float smoothness = 0.9;
const float smoothnessMapLoopNum = 1.0;

// 金属程度
#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_IN_TOONMAP 0
#define METALNESS_MAP_UV_FLIP 0
#define METALNESS_MAP_SWIZZLE 0
#define METALNESS_MAP_APPLY_SCALE 0      // metalness values to multiply with the metalness.
#define METALNESS_MAP_FILE "metalness.png"

const float metalness = 0.0;
const float metalnessMapLoopNum = 1.0;
const float metalnessBaseSpecular = 0.04; // not calculate IBLspec when set to zero.

// 黑色素
#define MELANIN_MAP_ENABLE 0
#define MELANIN_MAP_IN_TOONMAP 0
#define MELANIN_MAP_UV_FLIP 0
#define MELANIN_MAP_SWIZZLE 0
#define MELANIN_MAP_FILE "melanin.png"

const float melanin = 0.0;
const float melaninMapLoopNum = 1.0;

// 发光贴图
#define EMISSIVE_ENABLE 0
#define EMISSIVE_USE_ALBEDO 0 // It can be used from albedo params, but u can still use the EMISSIVE_APPLY_COLOR or EMISSIVE_APPLY_MORPH_COLOR
#define EMISSIVE_MAP_ENABLE 0
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_SCREEN_MAP 0
#define EMISSIVE_MAP_ANIMATION_ENABLE 0
#define EMISSIVE_MAP_ANIMATION_SPEED 1
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 0
#define EMISSIVE_APPLY_MORPH_COLOR 0 // Light color for multi-light-source
#define EMISSIVE_APPLY_MORPH_INTENSITY 0 // Light intensity for multi-light-source
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 1.0;
const float emissiveIntensity = 1.0;
const float emissiveMapLoopNum = 1.0;

// 视差贴图
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
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.0;
const float customAMapLoopNum = 1.0;

#define CUSTOM_B_MAP_ENABLE 0
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_COLOR 0
#define CUSTOM_B_MAP_FILE "custom.png"

const float3 customB = 0.0;
const float customBMapLoopNum = 1.0;

#include "../material_common.fxsub"