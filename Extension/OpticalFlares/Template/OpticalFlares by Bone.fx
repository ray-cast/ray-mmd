// 0 : Fetch Position from Sun
// 1 : Fetch Position from X/Y/Z or Bone but you need to set your follow bone
#define GHOST_MAP_TYPE 1
#define GHOST_MAP_FILE "textures/ghost.png"

#define LENSFLARE_INDEX 1
#define LENSFLARE_MAP_FILE "textures/lensflare.png"

float GhostAllBrightness = 10.0;

// x = Fixed scale
// y = Camera scale
// z = Offset
// w = Brightness
float4 GhostFlareParams = float4(1.8, 0.0, 0.0, 2.0);

// x = Fixed scale
// y = Camera scale
// z = Offset
// w = Brightness
float4 GhostParams[16] = { 
	float4(0.125, 1.0, 1.0, 1.0), float4(0.600, 0.0, 0.0, 1.0), float4(0.175, 1.0, 1.0, 1.0), float4(0.200, 1.0, 1.0, 1.0),
	float4(0.225, 1.0, 1.0, 1.0), float4(0.250, 1.0, 1.0, 1.0), float4(0.275, 1.0, 1.0, 1.0), float4(0.300, 1.0, 1.0, 1.0), 
	float4(0.325, 1.0, 1.0, 1.0), float4(0.350, 1.0, 1.0, 1.0), float4(0.375, 1.0, 1.0, 1.0), float4(0.400, 1.0, 1.0, 1.0),
	float4(0.425, 1.0, 1.0, 1.0), float4(0.450, 1.0, 1.0, 1.0), float4(0.475, 1.0, 1.0, 1.0), float4(0.500, 1.0, 1.0, 1.0)
};

#include "Shader/OpticalFlares.fxsub"