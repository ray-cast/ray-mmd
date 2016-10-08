// 最大半径
#define LIGHTSOURCE_MAX_RANGE 50

// 最小强度
#define LIGHTSOURCE_MIN_INTENSITY 100

// 最大强度
#define LIGHTSOURCE_MAX_INTENSITY 2000

// 启用矩形区域光
#define RECTANGLIELIGHT_ENABLE 1

// 双面光照
#define RECTANGLELIGHT_TWOSIDE_LIGHTING 0

// 视频贴图
#define VIDEO_MAP_ENABLE 1
#define VIDEO_MAP_IN_TEXTURE 0
#define VIDEO_MAP_IN_SCREEN_MAP 1
#define VIDEO_MAP_ANIMATION_ENABLE 0 // 指定图片是GIF/APNG时启用 (VIDEO_MAP_IN_TEXTURE 必须为 0)
#define VIDEO_MAP_ANIMATION_SPEED 1  // 最小为1倍速
#define VIDEO_MAP_UV_FLIP 0
#define VIDEO_MAP_FILE "video.png"

const float vedioMapLoopNum = 1.0;

#include "rectangle_lighting.fxsub"