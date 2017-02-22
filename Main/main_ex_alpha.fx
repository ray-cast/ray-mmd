#define DISCARD_ALPHA_ENABLE 1
#define DISCARD_ALPHA_MAP_ENABLE 1

// 大于以上阈值则认为是不透明物体
const float DiscardAlphaThreshold = 1.1;

#include "main.fxsub"