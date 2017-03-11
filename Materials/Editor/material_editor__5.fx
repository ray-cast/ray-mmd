#define CONTROLLER_NAME "material_editor_5.pmx"
#include "material_editor.fxsub"

#define USE_CUSTOM_MATERIAL 1

#define ALBEDO_MAP_ENABLE 1
#define ALBEDO_MAP_IN_TEXTURE 1
#define ALBEDO_MAP_IN_SCREEN_MAP 0
#define ALBEDO_MAP_ANIMATION_ENABLE 0
#define ALBEDO_MAP_ANIMATION_SPEED 1
#define ALBEDO_MAP_UV_FLIP 0
#define ALBEDO_MAP_UV_REPETITION 0
#define ALBEDO_MAP_APPLY_COLOR 1
#define ALBEDO_MAP_APPLY_DIFFUSE 1
#define ALBEDO_APPLY_MORPH_COLOR 0
#define ALBEDO_MAP_FILE "albedo.png"

static const float3 albedo = mAlbedoColor;
static const float2 albedoMapLoopNum = mAlbedoLoops;

#define ALBEDO_SUB_ENABLE 1
#define ALBEDO_SUB_MAP_ENABLE 0
#define ALBEDO_SUB_MAP_IN_TEXTURE 0
#define ALBEDO_SUB_MAP_UV_FLIP 0
#define ALBEDO_SUB_MAP_APPLY_SCALE 0
#define ALBEDO_SUB_MAP_FILE "albedo.png"

static const float3 albedoSub = mMelanin;
static const float2 albedoSubMapLoopNum = mMelaninLoops;

#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_ANIMATION_ENABLE 0
#define ALPHA_MAP_ANIMATION_SPEED 0
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"

static const float alpha = 1.0;
static const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_ENABLE 0
#define NORMAL_MAP_IN_SPHEREMAP 0
#define NORMAL_MAP_IS_COMPRESSED 0
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_UV_REPETITION 0
#define NORMAL_MAP_FILE "normal.png"

static const float normalMapScale = mNormalScale;
static const float normalMapLoopNum = mNormalLoops;

#define NORMAL_MAP_SUB_ENABLE 0
#define NORMAL_MAP_SUB_IN_SPHEREMAP 0
#define NORMAL_MAP_SUB_IS_COMPRESSED 0
#define NORMAL_MAP_SUB_UV_FLIP 0
#define NORMAL_MAP_SUB_UV_REPETITION 0
#define NORMAL_MAP_SUB_FILE "normal.png"

static const float normalMapSubScale = mNormalSubScale;
static const float normalMapSubLoopNum = mNormalSubLoops;

#define SMOOTHNESS_MAP_ENABLE 0
#define SMOOTHNESS_MAP_IN_TOONMAP 0
#define SMOOTHNESS_MAP_IS_ROUGHNESS 0
#define SMOOTHNESS_MAP_UV_FLIP 0
#define SMOOTHNESS_MAP_SWIZZLE 0
#define SMOOTHNESS_MAP_APPLY_SCALE 0 
#define SMOOTHNESS_MAP_FILE "smoothness.png"

static const float smoothness = mSmoothness;
static const float smoothnessMapLoopNum = mSmoothnessLoops;

#define METALNESS_MAP_ENABLE 0
#define METALNESS_MAP_IN_TOONMAP 0
#define METALNESS_MAP_UV_FLIP 0
#define METALNESS_MAP_SWIZZLE 0
#define METALNESS_MAP_APPLY_SCALE 0
#define METALNESS_MAP_FILE "metalness.png"

static const float metalness = mMetalness;
static const float metalnessMapLoopNum = mMetalnessLoops;
static const float metalnessBaseSpecular = mMetalnessBaseSpecular;

#define MELANIN_MAP_ENABLE 0
#define MELANIN_MAP_IN_TOONMAP 0
#define MELANIN_MAP_UV_FLIP 0
#define MELANIN_MAP_SWIZZLE 0
#define MELANIN_MAP_APPLY_SCALE 0
#define MELANIN_MAP_FILE "melanin.png"

static const float melanin = mMelanin;
static const float melaninMapLoopNum = mMelaninLoops;

#define EMISSIVE_ENABLE 1
#define EMISSIVE_USE_ALBEDO 0
#define EMISSIVE_MAP_ENABLE 0
#define EMISSIVE_MAP_IN_TEXTURE 0
#define EMISSIVE_MAP_IN_SCREEN_MAP 0
#define EMISSIVE_MAP_ANIMATION_ENABLE 0
#define EMISSIVE_MAP_ANIMATION_SPEED 1
#define EMISSIVE_MAP_UV_FLIP 0
#define EMISSIVE_APPLY_COLOR 0
#define EMISSIVE_APPLY_MORPH_COLOR 0
#define EMISSIVE_APPLY_MORPH_INTENSITY 0
#define EMISSIVE_APPLY_BLINK 1
#define EMISSIVE_MAP_FILE "emissive.png"

static const float3 emissive = mEmissiveColor;
static const float emissiveBlink = mEmissiveBlink; 
static const float emissiveIntensity = mEmissiveIntensity;
static const float emissiveMapLoopNum = mEmissiveLoops;

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

#define CUSTOM_ENABLE 0

#define CUSTOM_A_MAP_ENABLE 0
#define CUSTOM_A_MAP_IN_TOONMAP 0
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

static const float customA = mCustomA;
static const float customAMapLoopNum = mCustomALoops;

#define CUSTOM_B_MAP_ENABLE 0
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_COLOR 0
#define CUSTOM_B_MAP_FILE "custom.png"

static const float3 customB = mCustomBColor;
static const float2 customBMapLoopNum = mCustomBLoops;

#include "../material_common.fxsub"