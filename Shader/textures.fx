shared texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
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
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

texture LightingMap: OFFSCREENRENDERTARGET <
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
        "SpotLight*.* =./Lighting/shader/spot_lighting.fx;"
        "PointLight*.* =./Lighting/shader/point_lighting.fx;"
        "SphereLight*.* =./Lighting/shader/sphere_lighting.fx;"
        "RectangleLight*.* =./Lighting/shader/rectangle_lighting.fx;"
        "* = hide;";
>;

sampler LightingSampler = sampler_state {
    texture = <LightingMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

#if IBL_QUALITY > 0
texture EnvLightingMap: OFFSCREENRENDERTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
#if IBL_QUALITY > 1
    float4 ClearColor = { 0, 0.5, 0, 0.5 };
#else
    float4 ClearColor = { 0, 0, 0, 0 };
#endif
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "SpotLight*.*=hide;"
        "PointLight*.*=hide;"
        "SphereLight*.*=hide;"
        "skybox_hdr.*=./Lighting/shader/envlighting_hdr.fx;"
        "skybox.*=./Lighting/shader/envlighting.fx;"
        "* = hide;";
>;

sampler EnvLightingSampler = sampler_state {
    texture = <EnvLightingMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

shared texture MaterialMap: OFFSCREENRENDERTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox*.* = ./materials/material_skybox.fx;"
        "*.pmd = ./materials/material.fx;"
        "*.pmx = ./materials/material.fx;"
        "*.x = ./materials/material.fx;"
        "* = hide;";
>;

sampler Gbuffer1Map = sampler_state {
    texture = <MaterialMap>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

shared texture Gbuffer2RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8" ;
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer2Map = sampler_state {
    texture = <Gbuffer2RT>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

shared texture Gbuffer3RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer3Map = sampler_state {
    texture = <Gbuffer3RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer4RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "R16F" ;
    bool AntiAlias = false;
    int MipLevels = 1;
>;
sampler Gbuffer4Map = sampler_state {
    texture = <Gbuffer4RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer5RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer5Map = sampler_state {
    texture = <Gbuffer5RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer6RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer6Map = sampler_state {
    texture = <Gbuffer6RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer7RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer7Map = sampler_state {
    texture = <Gbuffer7RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer8RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer8Map = sampler_state {
    texture = <Gbuffer8RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

#if SHADOW_QUALITY > 0
shared texture2D ShadowmapMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "G16R16F";
>;
texture2D ShadowmapMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
>;
sampler ShadowmapSamp = sampler_state {
    texture = <ShadowmapMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ShadowmapSampTemp = sampler_state {
    texture = <ShadowmapMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

#if SSAO_SAMPLER_COUNT > 0 || SSGI_SAMPLER_COUNT > 0
texture2D SSAOMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "R16F";
#endif
>;
texture2D SSAOMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
#if SSGI_SAMPLER_COUNT > 0
    string Format = "A8R8G8B8";
#else
    string Format = "R16F";
#endif
>;
sampler SSAOMapSamp = sampler_state {
    texture = <SSAOMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler SSAOMapSampTemp = sampler_state {
    texture = <SSAOMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

texture2D OpaqueMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
texture2D OpaqueMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
sampler OpaqueSamp = sampler_state {
    texture = <OpaqueMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler OpaqueSampTemp = sampler_state {
    texture = <OpaqueMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

#if HDR_BLOOM_QUALITY > 0
#if HDR_BLOOM_QUALITY > 2
texture2D BloomMapX1Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
texture2D BloomMapX1 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
#endif
texture2D BloomMapX2Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
texture2D BloomMapX2 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
texture2D BloomMapX3Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
texture2D BloomMapX3 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int MipLevels = 1;
    string Format = "A8R8G8B8";
>;
texture2D BloomMapX4Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int MipLevels = 1;
    string Format = "A16B16G16R16F";
>;
texture2D BloomMapX4 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int MipLevels = 1;
    string Format = "A16B16G16R16F";
>;
texture2D BloomMapX5Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int MipLevels = 1;
    string Format = "A16B16G16R16F";
>;
texture2D BloomMapX5 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int MipLevels = 1;
    string Format = "A16B16G16R16F";
>;
#if HDR_BLOOM_QUALITY > 2
sampler2D BloomSampX1Temp = sampler_state {
    texture = <BloomMapX1Temp>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX1 = sampler_state {
    texture = <BloomMapX1>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
#endif
sampler2D BloomSampX2Temp = sampler_state {
    texture = <BloomMapX2Temp>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX2 = sampler_state {
    texture = <BloomMapX2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX3Temp = sampler_state {
    texture = <BloomMapX3Temp>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX3 = sampler_state {
    texture = <BloomMapX3>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX4Temp = sampler_state {
    texture = <BloomMapX4Temp>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX4 = sampler_state {
    texture = <BloomMapX4>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX5Temp = sampler_state {
    texture = <BloomMapX5Temp>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
sampler2D BloomSampX5 = sampler_state {
    texture = <BloomMapX5>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV = Clamp;
};
#endif