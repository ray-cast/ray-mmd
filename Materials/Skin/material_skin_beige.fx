#define USE_CUSTOM_MATERIAL 1

#define ALBEDO_MAP_ENABLE 1
#define ALBEDO_MAP_IN_TEXTURE 1
#define ALBEDO_MAP_APPLY_COLOR 1
#define ALBEDO_MAP_APPLY_DIFFUSE 0
#define ALBEDO_MAP_FILE "albedo.png"

const float albedoMapLoopNum = 1.0;
const float3 albedo = float3(247, 199, 149) / 256;

#define ALPHA_MAP_ENABLE 0
#define ALPHA_MAP_IN_TEXTURE 0
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

#define NORMAL_MAP_SUB_ENABLE 1
#define NORMAL_MAP_SUB_FILE "NormalMap/skin.png"

const float normalMapSubScale = 1.5;
const float normalMapSubLoopNum = 80.0;

#define SSS_ENABLE 1
const float curvature = 1.6;
const float3 transmittance = float3(238, 104, 94) / 255;

const float melanin = 0.2;

const float smoothness = 0.55;

const float metalness = 0.0;
const float metalnessBaseSpecular = 0.04;

#include "../material_common.fxsub"