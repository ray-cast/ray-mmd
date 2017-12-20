#define ALPHA_MAP_FROM 3
#define ALPHA_MAP_UV_FLIP 0
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"

const float alpha = 1.0;
const float alphaThreshold = 0.999;
const float alphaMapLoopNum = 1.0;

// it has no effect on transparent objects, only used for matcap right now
#define NORMAL_MAP_FROM 0
#define NORMAL_MAP_TYPE 0
#define NORMAL_MAP_UV_FLIP 0
#define NORMAL_MAP_FILE "normal.png"

const float normalMapScale = 1.0;
const float normalMapLoopNum = 1.0;

// it has no effect on transparent objects, only used for matcap right now
#define NORMAL_SUB_MAP_FROM 0
#define NORMAL_SUB_MAP_TYPE 0
#define NORMAL_SUB_MAP_UV_FLIP 0
#define NORMAL_SUB_MAP_FILE "normal.png"

const float normalSubMapScale = 1.0;
const float normalSubMapLoopNum = 1.0;

// it has no effect on transparent objects
#define MATCAP_MAP_FROM 4
#define MATCAP_MAP_UV_FLIP 2 // for DX9
#define MATCAP_MAP_FILE "matcap.png"

const float matCapScale = 1.0;
const float matCapMapLoopNum = 1.0;

#include "main.fxsub"