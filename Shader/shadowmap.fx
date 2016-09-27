#if SHADOW_QUALITY == 1
#   define SHADOW_MAP_SIZE 1024
#elif SHADOW_QUALITY == 2
#   define SHADOW_MAP_SIZE 2048
#elif SHADOW_QUALITY == 3
#   define SHADOW_MAP_SIZE 4096
#elif SHADOW_QUALITY == 4
#   define SHADOW_MAP_SIZE 8192
#endif

texture ShadowMap : OFFSCREENRENDERTARGET <
    string Description = "Shadow Rendering for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "G16R16F";
    float4 ClearColor = { 1, 0, 0, 0 };
    float ClearDepth = 1.0;
    int MipLevels = 1;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox*.*=hide;"
        "AmbientLight*.* =shadow/shadow_noalpha.fx;"
        "PointLight*.*=shadow/shadow_noalpha.fx;"
        "SpotLight*.*=shadow/shadow_noalpha.fx;"
        "SphereLight*.*=shadow/shadow_noalpha.fx;"
        "TubeLight*.* =shadow/shadow_noalpha.fx;"
        "LED*.*=shadow/shadow_noalpha.fx;"
        "RectangleLight*.*=shadow/shadow_noalpha.fx;"
        "*.pmx=shadow/shadow.fx;"
        "*.pmd=shadow/shadow.fx;"
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
        "skybox*.*=hide;"
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
sampler ShadowSamp = sampler_state {
    texture = <ShadowMap>;
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

float BilateralWeight(float r, float depth, float center_d)
{
    const float blurSharpness = 4;
    const float blurSigma = 6 * 0.5f;
    const float blurFalloff = 1.0f / (2.0f * blurSigma * blurSigma);

    float ddiff = (depth - center_d) * blurSharpness;
    return exp2(-r * r * blurFalloff - ddiff * ddiff);
}

float4 ShadowMapBlurPS(float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : COLOR
{
    float2 center = tex2D(source, coord).xy;

    float2 sum = float2(center.x, 1);

    [unroll]
    for(int r = 1; r < SHADOW_BLUR_COUNT; r++)
    {
        float2 offset1 = coord + offset * r;
        float2 offset2 = coord - offset * r;
        
        float2 shadow1 = tex2D(source, offset1).xy;
        float2 shadow2 = tex2D(source, offset2).xy;
        
        float bilateralWeight1 = BilateralWeight(r, shadow1.y, center.y);
        float bilateralWeight2 = BilateralWeight(r, shadow2.y, center.y);
        
        sum.x += shadow1.x * bilateralWeight1;
        sum.x += shadow2.x * bilateralWeight2;

        sum.y += bilateralWeight1;
        sum.y += bilateralWeight2;
    }

    return float4(sum.x / sum.y, center.y, 1, 1);
}

float4 ShadowMapNoBlurPS(float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset) : COLOR
{
    return tex2D(source, coord);
}