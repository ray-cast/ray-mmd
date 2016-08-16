shared texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
    string Format = "D24S8";
>;

texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "A8R8G8B8";
>;
sampler ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

#if IBL_QUALITY > 0
shared texture EnvLightingMap: OFFSCREENRENDERTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox.* = ./EnvLighting/envlighting.fx;"
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
    string Format = "R32F" ;
    bool AntiAlias = false;
    int MipLevels = 1;
>;

sampler Gbuffer4Map = sampler_state {
    texture = <Gbuffer4RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

texture2D ReflectionWorkMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
sampler ReflectionWorkMapSamp = sampler_state {
    texture = <ReflectionWorkMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ReflectionWorkMapSampPoint = sampler_state {
    texture = <ReflectionWorkMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

texture2D ReflectionWorkMap2 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
sampler ReflectionWorkMapSamp2 = sampler_state {
    texture = <ReflectionWorkMap2>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

texture2D OpaqueMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
sampler OpaqueSamp = sampler_state {
    texture = <OpaqueMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};