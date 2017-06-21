// What does Physically Based Materials mean?
// You can see the UE4 docs for more information
// https://docs.unrealengine.com/latest/INT/Engine/Rendering/Materials/PhysicallyBased/index.html

// You can use a fixed color and texture to change colors in your model by set the code to the ALBEDO_MAP_FROM.
// Tips : albedo is also called "Base Color", default data will fetched params from texture from the pmx.
// 0 : Params fetch from fixed value from "const float3 albedo = 1.0".
// 1 : You can use an image (bmp, png, jpg, tga, dds) by enter a relative and absolutely path to the ALBEDO_MAP_FILE.
// 2 : You can use an animation image (gif, apng) by enter a relative and absolutely path to the ALBEDO_MAP_FILE.
// 3 : Params fetch from Texture from the pmx.
// 4 : Params fetch from Sphere map from the pmx.
// 5 : Params fetch from Toon map from the pmx.
// 6 : Params fetch from avi/screen from the DummyScreen.x inside extension folder.
// 7 : Params fetch from Ambient Color from the pmx.
// 8 : Params fetch from Specular Color from the pmx.
// 9 : Params fetch from Specular Power from the pmx. // this option can only be used for smoothness
#define ALBEDO_MAP_FROM 3

// You can flip your texture for the X and Y axis mirror by set code to the ALBEDO_MAP_UV_FLIP
// 1 : Flip axis x
// 2 : Flip axis y
// 3 : Flip axis x & y
#define ALBEDO_MAP_UV_FLIP 0

// You can apply color from "const float3 albedo = 1.0;" to change colors in your texture by set code to the ALBEDO_MAP_APPLY_SCALE
// 1 : map values * albedo;
// 2 : map values ^ albedo;
#define ALBEDO_MAP_APPLY_SCALE 0

#define ALBEDO_MAP_APPLY_DIFFUSE 1		// Texture colors to multiply with diffuse from the PMX.
#define ALBEDO_MAP_APPLY_MORPH_COLOR 0	// Texture colors to multiply with color from the morph controller (R+/G+/B+).

// If the ALBEDO_MAP_FROM is 1 or 2, you need to enter the path to the texture resource. 
// Tips : parent folder ref is "../" (in other words, using "../" instead of parent folder), and change all "\" to "/".
// For example : 
// If the xxx.png and material.fx is inside same folder
// You can set the xxx.png to the ALBEDO_MAP_FILE like : #define ALBEDO_MAP_FILE "xxx.png"
// If the xxx.png is inside parent path of the material.fx
// You can set the xxx.png to the ALBEDO_MAP_FILE like : #define ALBEDO_MAP_FILE "../xxx.png"
// If the xxx.png is inside other path from parent path of the material.fx
// You can set the xxx.png to the ALBEDO_MAP_FILE like : #define ALBEDO_MAP_FILE "../other path/xxx.png"
// If the xxx.png is inside your desktop or other disk
// You can set the xxx.png to the ALBEDO_MAP_FILE like : #define ALBEDO_MAP_FILE "C:/Users/User Name/Desktop/xxx.png"
#define ALBEDO_MAP_FILE "albedo.png"

// If the ALBEDO_MAP_FROM and ALBEDO_MAP_APPLY_SCALE is 1, you can set a color/rgb to albedo, and color range is between 0.0 and 1.0
// like const float3 albedo = float3(r, g, b) 
// For example : 
// if the red is normalized value, it can be set to albedo like : const float3 albedo = float3(1.0, 0.0, 0.0);
// if the red is unnormalized value, it can be set to albedo like : const float3 albedo = float3(255, 0.0, 0.0) / 255.0;
// And then
// If color is fetch from your monitor, you need to convert sRGB color-space to linear color-space by color ^ gamma
// Tips : The Gamma is near 2.2 and used most of time, but some old mac's used gamma of 1.8
// Tips : About sRGB and Gamma, you can see docs for more information : https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch24.html
// Convert srgb color-space from normalized value to linear color-space like : const float3 albedo = pow(float3(r, g, b), 2.2);
// Convert srgb color-space from unnormalized value to linear color-space like : const float3 albedo = pow(float3(r, g, b) / 255.0, 2.2);
const float3 albedo = 1.0;

// You can tile your texture for the X and Y axis separately by change albedoMapLoopNum = float2(x, y)
const float2 albedoMapLoopNum = 1.0; // between float2(0, 0) ~ float2(inf, inf) 

// You can apply second values for color of texture (albedo) change by change ALBEDO_SUB_ENABLE
// 0 : None
// 1 : albedo * albedoSub
// 2 : albedo ^ albedoSub
// 3 : albedo + albedoSub
// 4 : melanin
// 5 : Alpha Blend
#define ALBEDO_SUB_ENABLE 0
#define ALBEDO_SUB_MAP_FROM 0 	 		 // see ALBEDO_MAP_FROM for more information.
#define ALBEDO_SUB_MAP_UV_FLIP 0 		 // see ALBEDO_MAP_UV_FLIP for more information.
#define ALBEDO_SUB_MAP_APPLY_SCALE 0  	 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define ALBEDO_SUB_MAP_FILE "albedo.png" // see ALBEDO_MAP_FILE for more information.

const float3 albedoSub = 1.0;			// between 0 ~ 1
const float2 albedoSubMapLoopNum = 1.0;	// see albedoMapLoopNum

// it has no effect on opaque objects.
#define ALPHA_MAP_FROM 3	 		// see ALBEDO_MAP_FROM for more information.
#define ALPHA_MAP_UV_FLIP 0	 		// see ALBEDO_MAP_UV_FLIP for more information.

// The ordering of the data fetched from a texture from code. (R = 0, G = 1, B = 2, A = 3)
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"	// see ALBEDO_MAP_FILE for more information.

const float alpha = 1.0;			// between 0 ~ 1
const float alphaMapLoopNum = 1.0;	// see albedoMapLoopNum

// Tips : the NormalMap and SSAO & SSDO and Lighting only support non-empty the normals else will result a white edge issue
// When you see some effect that looks like some white edges, you can put the model in the PMXEditor 
// and check the model that all normals are not zero-length to be used
#define NORMAL_MAP_FROM 0  // see ALBEDO_MAP_FROM for more information.

// Other parameter types for tangent normal
// see UE4 docs for PerturbNormalLQ and PerturbNormalHQ.
// https://docs.unrealengine.com/latest/INT/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/index.html
// 0 : Calculate world-space normal from RGB tangent-space map.
// 1 : Calculate world-space normal from RG  compressed tangent-space map.
// 2 : Calculate world-space normal from Grayscale bump map by PerturbNormalLQ. It has no effect on small objects.
// 3 : Calculate world-space normal from Grayscale bump map by PerturbNormalHQ.
#define NORMAL_MAP_TYPE 0
#define NORMAL_MAP_UV_FLIP 0		 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define NORMAL_MAP_FILE "normal.png" // see ALBEDO_MAP_FILE for more information.

const float normalMapScale = 1.0;	// between 0 ~ inf
const float normalMapLoopNum = 1.0;	// see albedoMapLoopNum

#define NORMAL_SUB_MAP_FROM 0			 // see ALBEDO_MAP_FROM for more information.
#define NORMAL_SUB_MAP_TYPE 0	 		 // see NORMAL_MAP_TYPE for more information.
#define NORMAL_SUB_MAP_UV_FLIP 0		 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define NORMAL_SUB_MAP_FILE "normal.png" // see ALBEDO_MAP_FILE for more information.

const float normalSubMapScale = 1.0;	// between 0 ~ inf
const float normalSubMapLoopNum = 1.0;	// see albedoMapLoopNum

// Default data will fetched params from the SpecularPower and convert the SpecularPower to smoothness
#define SMOOTHNESS_MAP_FROM 9			// see ALBEDO_MAP_FROM for more information.

// Other parameter types for smoothness
// 0 : Smoothness (from Frostbite / CE5 textures)
// 1 : Calculate smoothness from roughness by 1.0 - Roughness ^ 0.5 (from UE4/GGX/SubstancePainter2 textures)
// 2 : Calculate smoothness from roughness by 1.0 - Roughness		(from UE4/GGX/SubstancePainter2 with roughness linear roughness)
#define SMOOTHNESS_MAP_TYPE 0
#define SMOOTHNESS_MAP_UV_FLIP 0		// see ALBEDO_MAP_UV_FLIP for more information.
#define SMOOTHNESS_MAP_SWIZZLE 0		// see ALPHA_MAP_SWIZZLE for more information.
#define SMOOTHNESS_MAP_APPLY_SCALE 0	// see ALBEDO_MAP_APPLY_SCALE for more information.
#define SMOOTHNESS_MAP_FILE "smoothness.png" // see ALBEDO_MAP_FILE for more information.

const float smoothness = 0.0;			// between 0 ~ 1
const float smoothnessMapLoopNum = 1.0;	// see albedoMapLoopNum

#define METALNESS_MAP_FROM 0				// see ALBEDO_MAP_FROM for more information.
#define METALNESS_MAP_UV_FLIP 0				// see ALBEDO_MAP_UV_FLIP for more information.
#define METALNESS_MAP_SWIZZLE 0				// see ALPHA_MAP_SWIZZLE for more information.
#define METALNESS_MAP_APPLY_SCALE 0			// see ALBEDO_MAP_APPLY_SCALE for more information.
#define METALNESS_MAP_FILE "metalness.png"	// see ALBEDO_MAP_FILE for more information.

const float metalness = 0.0;			// between 0 ~ 1
const float metalnessMapLoopNum = 1.0;	// see albedoMapLoopNum

// Minimum coefficient of specular reflection, it has no effect on metals and CUSTOM_ENABLE > 0.
#define SPECULAR_MAP_FROM 0 // see ALBEDO_MAP_FROM for more information.

// Other parameter types for Specular
// 0 : Calculate reflection coefficient from specular color by F(x) = 0.08*(x  ) (from UE4 textures)
// 1 : Calculate reflection coefficient from specular color by F(x) = 0.16*(x^2) (from Frostbite textures)
// 2 : Calculate reflection coefficient from specular grays by F(x) = 0.08*(x  ) (from UE4 textures)
// 3 : Calculate reflection coefficient from specular grays by F(x) = 0.16*(x^2) (from Frostbite textures)
// 4 : Using reflection coefficient (0.04) instead of specular value (0.5), Available when SPECULAR_MAP_FROM at 0
#define SPECULAR_MAP_TYPE 0
#define SPECULAR_MAP_UV_FLIP 0			 // see ALBEDO_MAP_UV_FLIP for more information.
#define SPECULAR_MAP_SWIZZLE 0			 // see ALPHA_MAP_SWIZZLE for more information.
#define SPECULAR_MAP_APPLY_SCALE 0  	 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define SPECULAR_MAP_FILE "specular.png" // see ALBEDO_MAP_FILE for more information.

// Default value is 0.5
// Notice : Anything less than 2% is physically impossible and is instead considered to be shadowing
// For example: The reflectance coefficient is equal to F(x) = (x - 1)^2 / (x + 1)^2
// Consider light that is incident upon a transparent medium with a refractive index of 1.5
// The result is (1.5 - 1)^2 / (1.5 + 1)^2 = 0.04 (or 4%).
// Specular to reflection coefficient is equal to F(x) = 0.08*x, if the x is equal to 0.5 the result will be 0.04.
// So default value is 0.5 for 0.04 coeff.
const float3 specular = 0.5; 			// between 0 ~ 1
const float2 specularMapLoopNum = 1.0;	// see albedoMapLoopNum

#define OCCLUSION_MAP_FROM 0		// see ALBEDO_MAP_FROM for more information.

// Other parameter types for occlusion
// 0 : Fetch ambient occlusion from linear color-space
// 1 : Fetch ambient occlusion from sRGB   color-space
// 2 : Fetch ambient occlusion from linear color-space from second UV set
// 3 : Fetch ambient occlusion from sRGB   color-space from second UV set
#define OCCLUSION_MAP_TYPE 0
#define OCCLUSION_MAP_UV_FLIP 0		// see ALBEDO_MAP_UV_FLIP for more information.
#define OCCLUSION_MAP_SWIZZLE 0		// see ALPHA_MAP_SWIZZLE for more information.
#define OCCLUSION_MAP_APPLY_SCALE 0 // see ALBEDO_MAP_APPLY_SCALE for more information.
#define OCCLUSION_MAP_FILE "occlusion.png" // see ALBEDO_MAP_FILE for more information.

const float occlusion = 1.0;			// between 0 ~ 1
const float occlusionMapLoopNum = 1.0;	// see albedoMapLoopNum

// In the DX9, the parallax map does not work with vertex displacement
#define PARALLAX_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.

// Other parameter types for parallax
// 0 : calculate without transparency
// 1 : calculate parallax occlusion with transparency and best SSDO
#define PARALLAX_MAP_TYPE 0
#define PARALLAX_MAP_UV_FLIP 0			// see ALBEDO_MAP_UV_FLIP for more information.
#define PARALLAX_MAP_SWIZZLE 0			// see ALPHA_MAP_SWIZZLE for more information.
#define PARALLAX_MAP_FILE "height.png"	// see ALBEDO_MAP_FILE for more information.

const float parallaxMapScale = 1.0;		// between 0 ~ inf

// Why increase number of parallaxMapLoopNum will increase the loops/tile/number of albedo, normals, etc
// Bacause parallax coordinates can be calculated from height map 
// That are then used to access textures with albedo, normals, smoothness, metalness, etc
// In other words like fetched data (albedo, normals, etc) from parallax coordinates * parallaxMapLoopNum * albedo/normal/MapLoopNum
const float parallaxMapLoopNum = 1.0;	// see albedoMapLoopNum

// Tips : Add a light source in MMD (PointLight or others)
// Key it as part of emissive of the model (set it to follow the bone of model)
// And same color set it to your light source and emissive color
#define EMISSIVE_ENABLE 0
#define EMISSIVE_MAP_FROM 0						// see ALBEDO_MAP_FROM for more information.
#define EMISSIVE_MAP_UV_FLIP 0					// see ALBEDO_MAP_UV_FLIP for more information.
#define EMISSIVE_MAP_APPLY_SCALE 0				// see ALBEDO_MAP_APPLY_SCALE for more information.
#define EMISSIVE_MAP_APPLY_MORPH_COLOR 0		// see ALBEDO_MAP_APPLY_MORPH_COLOR
#define EMISSIVE_MAP_APPLY_MORPH_INTENSITY 0	// Texture colors to multiply with intensity from morph controller (Intensity+/-).

// You can set the blink using the following code.
// 1 : colors to multiply with frequency from emissiveBlink. like : const float3 emissiveBlink = float3(1.0, 2.0, 3.0);
// 2 : colors to multiply with frequency from morph controller, see Blink morph inside PointLight.pmx
#define EMISSIVE_MAP_APPLY_BLINK 0
#define EMISSIVE_MAP_FILE "emissive.png"		// see ALBEDO_MAP_FILE for more information.

const float3 emissive = 1.0;			// between 0 ~ 1
const float3 emissiveBlink = 1.0; 		// between 0 ~ 10
const float  emissiveIntensity = 1.0; 	// between 0 ~ 100 and above
const float2 emissiveMapLoopNum = 1.0;	// see albedoMapLoopNum

// Shading Material ID
// The curvature also called "opacity"
// You can see the UE4 docs for more information
// https://docs.unrealengine.com/latest/INT/Engine/Rendering/Materials/LightingModels/SubSurfaceProfile/index.html

// 0 : Default            // customA = invalid,    customB = invalid
// 1 : PreIntegrated Skin // customA = curvature,  customB = transmittance color;
// 2 : Unlit placeholder  // customA = invalid,    customB = invalid

// If you always using this material to your skin, the SSSS must be disabled
// 3 : Toon               // customA = segment,    customB = shadow color

// In order to make refraction work, you must set alpha value of the pmx model to less then 0.999
// 4 : Glass              // customA = curvature   customB = transmittance color

// see paper for cloth information : http://blog.selfshadow.com/publications/s2013-shading-course/rad/s2013_pbs_rad_notes.pdf
// 5 : Cloth              // customA = sheen,      customB = Fuzz Color

// 6 : Clear Coat         // customA = smoothness, customB = invalid;
// 7 : Subsurface         // customA = curvature,  customB = transmittance color;
#define CUSTOM_ENABLE 0

#define CUSTOM_A_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.0;			 	// working in linear color-space, All between 0 ~ 1
const float customAMapLoopNum = 1.0;	// see albedoMapLoopNum

#define CUSTOM_B_MAP_FROM 0	// see ALBEDO_MAP_FROM for more information.
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_SCALE 0
#define CUSTOM_B_MAP_FILE "custom.png"

const float3 customB = 0.0;				// working in sRGB color-space, All between 0 ~ 1
const float2 customBMapLoopNum = 1.0;	// see albedoMapLoopNum

#include "material_common_2.0.fxsub"