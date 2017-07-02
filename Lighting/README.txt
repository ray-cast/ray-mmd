// 0 : Diffuse with specular
// 1 : Diffuse without specular
#define LIGHT_PARAMS_TYPE 0

// Sets the reach of the light
// R : default
// G : min for SilderBar
// B : max for SilderBar
static const float3 lightRangeParams = float3(100.0, 0.0, 200.0);

// Light Instensity
static const float3 lightIntensityParams = float3(1.0, 10.0);

// 0 : Disable
// 1 : Calculate shadow by create shadow map tab
#define SHADOW_MAP_FROM 0
#define SHADOW_MAP_QUALITY 0 // (0 ~ 3)

static const float shadowRange = 200;		// 0 ~ 200 and above
static const float shadowHardness = 0.15; 	// 0.15 ~ 0.5

// NOTICE : DO NOT MODIFY IT IF YOU CANT'T UNDERSTAND WHAT IT IS
// You can customize GaussianBlur coefficient by : http://dev.theomader.com/gaussian-kernel-calculator
static const float sampleRadius = 2;  // suggest 2 or 3
static const float sampleKernel[5] = {0.1784, 0.210431, 0.222338, 0.210431, 0.1784};

// Example :
// static const float sampleRadius = 1;
// static const float sampleKernel[3] = {0.27901, 0.44198, 0.27901};

// static const float sampleRadius = 3;
// static const float sampleKernel[7] = {0.071303, 0.131514, 0.189879, 0.214607, 0.189879, 0.131514, 0.071303};

#include "directional_lighting.fxsub"