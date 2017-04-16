// 0 : Params fetch from moprh controller from the pmx.
// 1 : Use the below params : lightRange, lightHardness, lightColor, lightBlink
#define LIGHT_PARAMS_FROM 0

// 0 : Diffuse & Specular
// 1 : Diffuse Only
// 2 : Diffuse & Specular & Clamp Range
// 3 : Diffuse & Clamp Range
#define LIGHT_PARAMS_TYPE 0

static const float3 lightBlink = 0.0;	// 0 ~ inf
static const float3 lightColor = 1.0;	// float3(r, g, b) * lightIntensity
static const float2 lightIntensityLimits = float2(1.0, 10.0); // for moprh controller

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

// static const float radius = 1;
// static const float kernel[3] = {0.27901, 0.44198, 0.27901};

// static const float radius = 3;
// static const float kernel[7] = {0.071303, 0.131514, 0.189879, 0.214607, 0.189879, 0.131514, 0.071303};

#include "../directional_lighting.fxsub"