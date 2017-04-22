// 0 : Fetch Position from Sun
// 1 : Fetch Position from X/Y/Z or Bone but you need to set your follow bone
#define GHOST_MAP_TYPE 1
#define GHOST_COLOR_SHIFT_ENABLE 1
#define GHOST_MAP_FILE "textures by 2gou/ghost.png"

#define LENSFLARE_INDEX 1
#define LENSFLARE_COLOR_SHIFT_ENABLE 1
#define LENSFLARE_MAP_FILE "textures by 2gou/lensflare.png"

// R = Fixed Scale
// G = Fixed Scale by camera
// B = Accum Scale by ID
float3 GhostAllScale = float3(0.125, 0.5, 0.025);

// R = Fixed offset
// G = Accum offset by ID
float2 GhostAllOffset = float2(0.0, 0.25);

// R = Fixed Brightness
// G = Accum Brightness by id
float2 GhostAllBrightness = float2(10.0, 0.0);

// R = Fixed Flare shift
// G = Fixed Ghost shift
// B = Begin Accum shift by ID
// A = End   Accum shift by ID
float4 GhostAllColorShift = float4(0.01, 0.05, 0.1, 1.0);

// R = Fixed scale
// G = Fixed scale by camera
// B = Fixed Offset
// A = Fixed Brightness
float4 GhostFlareParams = float4(10, 0.0, 0.0, 2.0);

// Control of single ghost image params
// R = Fixed scale
// G = Fixed scale by camera
// B = Fixed Offset
// A = Fixed Brightness
float4 GhostParams[16] = { 
	float4(1.0, 1.0, 1.0, 1.0), float4(3.0, 0.0, 0.0, 1.0), float4(0.8, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0),
	float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), 
	float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0),
	float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0), float4(1.0, 1.0, 1.0, 1.0)
};

// Control of single color shift params
float GhostShiftParams[16] = { 
	1.0, 1.0, 1.0, 1.0,
	1.0, 1.0, 1.0, 1.0, 
	1.0, 1.0, 1.0, 1.0,
	1.0, 1.0, 0.4, 0.5
};

#include "Shader/OpticalFlares.fxsub"