shared texture OutdoorMap : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for OutdoorFloor";
    string Format = "A16B16G16R16F";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0.5 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect = 
        "*controller.pmx = hide;"
        "skybox.*=shader/OutdoorFloor/OutdoorSkybox.fx;"
        "skybox_hdr.*=shader/OutdoorFloor/OutdoorSkyboxHDR.fx;"
        "*.pmd = shader/OutdoorFloor/OutdoorObject.fx;"
        "*.pmx = shader/OutdoorFloor/OutdoorObject.fx;"
        "* = hide;" ;
>;
shared texture OutdoorDepthMap : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for OutdoorFloor";
    string Format = "A16B16G16R16F";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect = 
        "*controller.pmx = hide;"
        "skybox*.*=shader/OutdoorFloor/OutdoorSkyboxDepth.fx;"
        "*.pmd = shader/OutdoorFloor/OutdoorDepth.fx;"
        "*.pmx = shader/OutdoorFloor/OutdoorDepth.fx;"
        "* = hide;" ;
>;
shared texture OutdoorShadingMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
#if OUTDOORFLOOR_QUALITY >= 3
    int Miplevels = 0;
#else
    int Miplevels = 1;
#endif
    bool AntiAlias = false;
>;
sampler OutdoorMapSamp = sampler_state 
{
    texture = <OutdoorMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU = CLAMP; AddressV = CLAMP;
};
sampler OutdoorDepthMapSamp = sampler_state 
{
    texture = <OutdoorDepthMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU = CLAMP; AddressV = CLAMP;
};
sampler OutdoorShadingMapSamp = sampler_state {
    texture = <OutdoorShadingMap>;
#if OUTDOORFLOOR_QUALITY >= 3
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = LINEAR;
#else
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = NONE;
#endif
    AddressU  = CLAMP;  AddressV = CLAMP;
};