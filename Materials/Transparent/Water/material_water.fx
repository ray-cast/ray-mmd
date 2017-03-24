#define USE_CUSTOM_MATERIAL 1

#define ALBEDO_MAP_APPLY_COLOR 0
#define ALBEDO_MAP_APPLY_DIFFUSE 0
#define ALBEDO_APPLY_MORPH_COLOR 0
#define ALBEDO_MAP_FILE "albedo.png"

const float3 albedo = 0.2; //pow(float3(0.1372549, 0.3490196, 0.5882353), 2.2);
const float2 albedoMapLoopNum = 1.0;

#define ALPHA_MAP_ENABLE 1
#define ALPHA_MAP_IN_TEXTURE 1
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaMapLoopNum = 1.0;

const float smoothness = 1.0;

const float metalness = 0.0;
const float metalnessBaseSpecular = 0.02; 

const float customA = 0.0;
const float customAMapLoopNum = 1.0;

const float3 customB = exp(-float3(40, 25, 25) * 0.125); //pow(float3(0.03, 0.05, 0.05), 1.2);
const float customBMapLoopNum = 1.0;

#include "material_common.fxsub"