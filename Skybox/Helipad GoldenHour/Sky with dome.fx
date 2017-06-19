#define SKYDOME_ENABLE 1

#define SKYBOX_HDR_ENABLE 1
#define SKYBOX_HDR_RGBT_ENABLE 1
#define SKYBOX_HDR_FILE "texture/skybox.dds"

#define SKYBOX_MAP_ENABLE 0
#define SKYBOX_MAP_FILE "texture/skybox.png"

#define SKYBOX_BLUR_ENABLE 0
#define SKYBOX_BLUR_MIPMAP_LEVEL 3
#define SKYBOX_BLUR_COLOR_RANGE 1024
#define SKYBOX_BLUR_MAP_FILE "texture/skyspec_hdr.dds"

#include "../../shader/skybox.fxsub"