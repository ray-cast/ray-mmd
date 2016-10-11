// 启用IBL
#define IBL_ENABLE 1
// 输入的纹理是HDR的DDS文件时启用
#define IBL_HDR_ENABLE 0
// 环境光贴图的mipmap层数
#define IBL_MIPMAP_LEVEL 7

#define IBLDIFF_MAP_FILE "texture/skydiff.dds"
#define IBLSPEC_MAP_FILE "texture/skyspec.dds"

#include "../shader/skylighting.fxsub"