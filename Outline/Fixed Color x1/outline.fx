#define OUTLINE_COLOR_TYPE 1

static float outlinePadding = 1;
static float outlineDepthBias = 0;
static float outlineDepthSlopeScaleBias = 1;

static float3 outlineColor = float3(0.8, 0.8, 0.8);

#include "../../shader/Outline.fxsub"