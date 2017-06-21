#define ALPHA_MAP_FROM 3
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaThreshold = 0.999;
const float alphaMapLoopNum = 1.0;

// it has no effect on transparent objects
#define MATCAP_MAP_FROM 0
#define MATCAP_MAP_UV_FLIP 2 // for DX9
#define MATCAP_MAP_FILE "matcap.png"

const float matCapScale = 1.0;
const float matCapMapLoopNum = 1.0;

#include "main.fxsub"