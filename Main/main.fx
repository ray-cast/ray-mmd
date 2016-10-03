// main.fx 没有载入ray的时候会计算主光源
// main_ex.fx 用于载入ray的优化(去掉了没有挂ray时计算主光源的代码)
// main_ex_mask.fx 对不透明物体优化，但以alpha为mask剔除的(例:树叶，蜘蛛网)
// main_ex_noalpha.fx 对不透明物体优化

#define DISCARD_ALPHA_ENABLE 1
#define DISCARD_ALPHA_MAP_ENABLE 1

// 大于以上阈值则认为是不透明物体
const float DiscardAlphaThreshold = 0.98;

#include "main.fxsub"