#if SHADOW_QUALITY == 1
#   define SHADOW_MAP_SIZE 1024
#elif SHADOW_QUALITY == 2
#   define SHADOW_MAP_SIZE 2048
#elif SHADOW_QUALITY == 3
#   define SHADOW_MAP_SIZE 4096
#elif SHADOW_QUALITY == 4
#   define SHADOW_MAP_SIZE 8192
#endif

texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "D24S8";
>;
texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "A16B16G16R16F";
>;
sampler ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
texture LightMap: OFFSCREENRENDERTARGET <
    string Description = "Multi light source map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox_hdr.*=hide;"
        "skybox.*=hide;"
        "AmbientLight*.* =./Lighting/AmbientLight/ambient_lighting.fx;"
        "SpotLight*.* =./Lighting/SpotLight/spot_lighting.fx;"
        "PointLight*.* =./Lighting/PointLight/point_lighting.fx;"
        "SphereLight*.* =./Lighting/SphereLight/sphere_lighting.fx;"
        "TubeLight*.* =./Lighting/TubeLight/tube_lighting.fx;"
        "LED*.pmx =./Lighting/RectangleLight/rectangle_lighting_led.fx;"
        "RectangleLight*.* =./Lighting/RectangleLight/rectangle_lighting.fx;"
        "* = hide;";
>;
sampler LightMapSamp = sampler_state {
    texture = <LightMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#if IBL_QUALITY
texture EnvLightMap: OFFSCREENRENDERTARGET <
    string Description = "Image-based-lighting map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    float4 ClearColor = { 0, 0.5, 0, 0.5 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "skybox_hdr*.*=./Skybox/skylighting_none.fx;"
        "skybox*.*=./Skybox/skylighting_none.fx;"
        "*= hide;";
>;
shared texture EnvLightSpecMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
sampler EnvLightMapSamp = sampler_state {
    texture = <EnvLightMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler EnvLightSpecMapSamp = sampler_state {
    texture = <EnvLightSpecMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif
shared texture MaterialMap: OFFSCREENRENDERTARGET <
    string Description = "Material cache map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "*controller.pmx=hide;"
        "skybox*.* = ./materials/material_skybox.fx;"
        "LED*.pmx =./materials/material_led.fx;"
        "*.pmd = ./materials/material.fx;"
        "*.pmx = ./materials/material.fx;"
        "*.x = hide;"
        "* = hide;";
>;
texture DepthMap : OFFSCREENRENDERTARGET <
    string Description = "SSAO and shadow rendering for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "G16R16F";
    float4 ClearColor = { 1, 0, 0, 0 };
    float ClearDepth = 1.0;
    int MipLevels = 1;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox*.* =shadow/Depth_noalpha.fx;"
        "AmbientLight*.* =shadow/Depth_noalpha.fx;"
        "PointLight*.*=shadow/Depth_noalpha.fx;"
        "SpotLight*.*=shadow/Depth_noalpha.fx;"
        "SphereLight*.*=shadow/Depth_noalpha.fx;"
        "TubeLight*.* =shadow/Depth_noalpha.fx;"
        "LED*.*=shadow/Depth_noalpha.fx;"
        "RectangleLight*.*=shadow/Depth_noalpha.fx;"
        "*.pmx=shadow/Depth.fx;"
        "*.pmd=shadow/Depth.fx;"
        "*.x=hide;";
>;

shared texture PSSM : OFFSCREENRENDERTARGET <
    string Description = "Cascade shadow map for ray";
    int Width = SHADOW_MAP_SIZE;
    int Height = SHADOW_MAP_SIZE;
    string Format = "R32F";
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    int MipLevels = 1;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox*.* =shadow/PSSM_noalpha.fx;"
        "AmbientLight*.* =shadow/PSSM_noalpha.fx;"
        "PointLight*.*=shadow/PSSM_noalpha.fx;"
        "SpotLight*.*=shadow/PSSM_noalpha.fx;"
        "SphereLight*.*=shadow/PSSM_noalpha.fx;"
        "TubeLight*.* =shadow/PSSM_noalpha.fx;"
        "LED*.*=shadow/PSSM_noalpha.fx;"
        "RectangleLight*.*=shadow/PSSM_noalpha.fx;"
        "*.pmx=shadow/PSSM.fx;"
        "*.pmd=shadow/PSSM.fx;"
        "*.x=hide;";
>;
shared texture2D ShadowmapMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "G16R16F";
>;
texture2D ShadowmapMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "G16R16F";
>;
sampler DepthMapSamp = sampler_state {
    texture = <DepthMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ShadowmapSamp = sampler_state {
    texture = <ShadowmapMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ShadowmapSampTemp = sampler_state {
    texture = <ShadowmapMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
shared texture Gbuffer2RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8" ;
    int Miplevels = 1;
    bool AntiAlias = false;
>;
shared texture Gbuffer3RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
shared texture Gbuffer4RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F" ;
    bool AntiAlias = false;
    int MipLevels = 1;
>;
shared texture Gbuffer5RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
shared texture Gbuffer6RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
shared texture Gbuffer7RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
shared texture Gbuffer8RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
texture GbufferFilterRT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
sampler Gbuffer1Map = sampler_state {
    texture = <MaterialMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP; AddressV  = CLAMP;
};
sampler Gbuffer2Map = sampler_state {
    texture = <Gbuffer2RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP; AddressV  = CLAMP;
};
sampler Gbuffer3Map = sampler_state {
    texture = <Gbuffer3RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler Gbuffer4Map = sampler_state {
    texture = <Gbuffer4RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler Gbuffer5Map = sampler_state {
    texture = <Gbuffer5RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler Gbuffer6Map = sampler_state {
    texture = <Gbuffer6RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler Gbuffer7Map = sampler_state {
    texture = <Gbuffer7RT>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler Gbuffer8Map = sampler_state {
    texture = <Gbuffer8RT>;
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler GbufferFilterMap = sampler_state {
    texture = <GbufferFilterRT>;
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
texture2D ShadingMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
texture2D ShadingMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
texture2D FinalMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
sampler ShadingMapSamp = sampler_state {
    texture = <ShadingMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ShadingMapTempSamp = sampler_state {
    texture = <ShadingMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler FinalMapSamp = sampler_state {
    texture = <FinalMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#if HDR_BLOOM_QUALITY > 0
texture2D BloomMapX1Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int Miplevels = 1;
    bool AntiAlias = false;
#if HDR_BLOOM_QUALITY > 2
    string Format = "A16B16G16R16F";
#else
    string Format = "A2R10G10B10";
#endif
>;
texture2D BloomMapX1 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int Miplevels = 1;
    bool AntiAlias = false;
#if HDR_BLOOM_QUALITY > 2
    string Format = "A16B16G16R16F";
#else
    string Format = "A2R10G10B10";
#endif
>;
texture2D BloomMapX2Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX2 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX3Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX3 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX4Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX4 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX5Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX5 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int Miplevels = 1;
    bool AntiAlias = false;
    string Format="A2R10G10B10";
>;
sampler2D BloomSampX1Temp = sampler_state {
    texture = <BloomMapX1Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX1 = sampler_state {
    texture = <BloomMapX1>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX2Temp = sampler_state {
    texture = <BloomMapX2Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX2 = sampler_state {
    texture = <BloomMapX2>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX3Temp = sampler_state {
    texture = <BloomMapX3Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX3 = sampler_state {
    texture = <BloomMapX3>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX4Temp = sampler_state {
    texture = <BloomMapX4Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX4 = sampler_state {
    texture = <BloomMapX4>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX5Temp = sampler_state {
    texture = <BloomMapX5Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX5 = sampler_state {
    texture = <BloomMapX5>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
#endif