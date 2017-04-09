// What does Physically Based Materials mean?
// You can see the UE4 docs for more information
// https://docs.unrealengine.com/latest/INT/Engine/Rendering/Materials/PhysicallyBased/index.html

// Paramters in the data fetch from code
// 0 : Fixed value
// 1 : Image (bmp, png, jpg, tga, dds)
// 2 : Animation (gif, apng)
// 3 : Params fetch from Texture from the pmx
// 4 : Params fetch from Sphere map from the pmx
// 5 : Params fetch from Toon map from the pmx
// 6 : Params fetch from avi/screen from the DummyScreen.x
// 7 : Params fetch from Ambient Color from the pmx
// 8 : Params fetch from Specular Color from the pmx
// 9 : Params fetch from Specular Power from the pmx // for smoothness, see SMOOTHNESS_MAP_TYPE at 3
#define ALBEDO_MAP_FROM 3

// You can flip your texture for the U and V axis mirror by change ALBEDO_MAP_UV_FLIP
// 1 : Flip x axis
// 2 : Flip y axis
// 3 : Flip x & y axis
#define ALBEDO_MAP_UV_FLIP 0

// You can apply values for color of texture change by change ALBEDO_MAP_APPLY_SCALE
// 1 : map values * albedo;
// 2 : map values ^ albedo;
#define ALBEDO_MAP_APPLY_SCALE 0

// Texture colors to multiply with diffuse from the PMX.
#define ALBEDO_MAP_APPLY_DIFFUSE 1

// Texture colors to multiply with color from controller (R+/G+/B+).
#define ALBEDO_MAP_APPLY_MORPH_COLOR 0

// If ALBEDO_MAP_FROM is 1 or 2, you need to enter the path to the texture resource. parent folder ref is "../"
#define ALBEDO_MAP_FILE "albedo.png"

// Constant value or scale color, between float3(0, 0, 0) ~ float3(1, 1, 1) or albedo = float3(125, 125, 125) / 255;
const float3 albedo = 1.0;

// You can tile your texture for the U and V axis separately by change albedoMapLoopNum = float2(x, y)
const float2 albedoMapLoopNum = 1.0; // Between 0.0 ~ inf

// You can apply second values for color of texture (albedo) change by change ALBEDO_SUB_ENABLE
// 0 : None
// 1 : albedo * albedoSub
// 2 : albedo ^ albedoSub
// 3 : albedo + albedoSub
// 4 : melanin
#define ALBEDO_SUB_ENABLE 0
#define ALBEDO_SUB_MAP_FROM 0 	 		 // see ALBEDO_MAP_FROM for more information.
#define ALBEDO_SUB_MAP_UV_FLIP 0 		 // see ALBEDO_MAP_UV_FLIP for more information.
#define ALBEDO_SUB_MAP_APPLY_SCALE 0  	 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define ALBEDO_SUB_MAP_FILE "albedo.png" // see ALBEDO_MAP_FILE for more information.

const float3 albedoSub = 1.0;
const float2 albedoSubMapLoopNum = 1.0;

#define ALPHA_MAP_FROM 3	 		// see ALBEDO_MAP_FROM for more information.
#define ALPHA_MAP_UV_FLIP 0	 		// see ALBEDO_MAP_UV_FLIP for more information.
#define ALPHA_MAP_SWIZZLE 3 		// The ordering of the data fetched from a texture from code. (R = 0, G = 1, B = 2, A = 3)
#define ALPHA_MAP_FILE "alpha.png"	// see ALBEDO_MAP_FILE for more information.

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_FROM 0		     // see ALBEDO_MAP_FROM for more information.

// Other parameter types for tangent normal
// see UE4 docs for more information.
// https://docs.unrealengine.com/latest/INT/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/index.html
// 0 : RGB tangent normal
// 1 : Convert RG texture to RGB tangent normal.
// 2 : Convert R/bump texture to RGB tanget normal by PerturbNormalLQ
#define NORMAL_MAP_TYPE 0
#define NORMAL_MAP_UV_FLIP 0		 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define NORMAL_MAP_FILE "normal.png" // see ALBEDO_MAP_FILE for more information.

const float normalMapScale = 1.0;
const float normalMapLoopNum = 1.0;

#define NORMAL_SUB_MAP_FROM 0			 // see ALBEDO_MAP_FROM for more information.
#define NORMAL_SUB_MAP_TYPE 0	 		 // see NORMAL_MAP_IS_TYPES  for more information.
#define NORMAL_SUB_MAP_UV_FLIP 0		 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define NORMAL_SUB_MAP_FILE "normal.png" // see ALBEDO_MAP_FILE for more information.

const float normalSubMapScale = 1.0;
const float normalSubMapLoopNum = 1.0;

#define SMOOTHNESS_MAP_FROM 0			// see ALBEDO_MAP_FROM for more information.

// Other parameter types for smoothness
// 0 : Smoothness (from CE5 textures)
// 1 : Convert roughtness to smoothness by 1.0 - Roughness ^ 0.5 (from UE4 textures)
// 2 : Convert roughtness to smoothness by 1.0 - Roughness
// 3 : Convert shininess  to smoothness by 1.0 - (2.0 / (Shininess + 2)) ^ 0.25
#define SMOOTHNESS_MAP_TYPE 0
#define SMOOTHNESS_MAP_UV_FLIP 0		// see ALBEDO_MAP_UV_FLIP for more information.
#define SMOOTHNESS_MAP_SWIZZLE 0		// see ALPHA_MAP_SWIZZLE for more information.
#define SMOOTHNESS_MAP_APPLY_SCALE 0	// see ALBEDO_MAP_APPLY_SCALE for more information.
#define SMOOTHNESS_MAP_FILE "smoothness.png" // see ALBEDO_MAP_FILE for more information.

const float smoothness = 0.0;
const float smoothnessMapLoopNum = 1.0;

#define METALNESS_MAP_FROM 0				// see ALBEDO_MAP_FROM for more information.

// Other parameter types for metalness
// 0 : Metalness
// 1 : Convert specular coefficient to metalness by 0.16 * (specular ^ 2)
#define METALNESS_MAP_TYPE 0
#define METALNESS_MAP_UV_FLIP 0				// see ALBEDO_MAP_UV_FLIP for more information.
#define METALNESS_MAP_SWIZZLE 0				// see ALPHA_MAP_SWIZZLE for more information.
#define METALNESS_MAP_APPLY_SCALE 0			// see ALBEDO_MAP_APPLY_SCALE for more information.
#define METALNESS_MAP_FILE "metalness.png"	// see ALBEDO_MAP_FILE for more information.

const float metalness = 0.0;
const float metalnessMapLoopNum = 1.0;

// Minimum coefficient of specular reflection
// Anything less than 2% is physically impossible and is instead considered to be shadowing
// For example: Consider light that is incident upon a transparent medium with a refractive index of 1.5
// The reflectance is equal to (1.5 - 1)^2 / (1.5 + 1)^2 = 0.04 (or 4%).
const float metalnessBaseSpecular = 0.04; 

#define OCCLUSION_MAP_FROM 0		// see ALBEDO_MAP_FROM for more information.
#define OCCLUSION_MAP_UV_FLIP 0		// see ALBEDO_MAP_UV_FLIP for more information.
#define OCCLUSION_MAP_SWIZZLE 0		// see ALPHA_MAP_SWIZZLE for more information.
#define OCCLUSION_MAP_APPLY_SCALE 0 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define OCCLUSION_MAP_FILE "occlusion.png" // see ALBEDO_MAP_FILE for more information.

const float occlusion = 1.0;	// between 0 ~ 1
const float occlusionMapLoopNum = 1.0;

#define PARALLAX_MAP_FROM 0				// see ALBEDO_MAP_FROM for more information.
#define PARALLAX_MAP_UV_FLIP 0			// see ALBEDO_MAP_UV_FLIP for more information.
#define PARALLAX_MAP_SUPPORT_ALPHA 0 	// calculate parallax occlusion with transparency
#define PARALLAX_MAP_FILE "height.png"	// see ALBEDO_MAP_FILE for more information.

const float parallaxMapScale = 1.0;
const float parallaxMapLoopNum = 1.0;

#define EMISSIVE_ENABLE 0
#define EMISSIVE_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_MAP_APPLY_SCALE 0
#define EMISSIVE_MAP_APPLY_MORPH_COLOR 0
#define EMISSIVE_MAP_APPLY_MORPH_INTENSITY 0
#define EMISSIVE_MAP_APPLY_BLINK 0
#define EMISSIVE_MAP_FILE "emissive.png"

const float3 emissive = 1.0;
const float3 emissiveBlink = 1.0;
const float  emissiveIntensity = 1.0;
const float2 emissiveMapLoopNum = 1.0;

#define CUSTOM_ENABLE 0

#define CUSTOM_A_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.0;
const float customAMapLoopNum = 1.0;

#define CUSTOM_B_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_SCALE 0
#define CUSTOM_B_MAP_FILE "custom.png"

const float3 customB = 0.0;
const float2 customBMapLoopNum = 1.0;

#include "material_common_2.0.fxsub"