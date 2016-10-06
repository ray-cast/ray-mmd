#include "ray.conf"

const float4 BackColor = float4(0,0,0,0);
const float ClearDepth = 1.0;
const int ClearStencil = 0;

float mDirectLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectLight+"; >;
float mDirectLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectLight-"; >;
float mIndirectLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "IndirectLight+"; >;
float mIndirectLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "IndirectLight-"; >;
float mEnvShadowP  : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "EnvShadow+"; >;
float mSSAOP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO+"; >;
float mSSAOM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO-"; >;
float mSSAORadiusP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO Radius+"; >;
float mSSAORadiusM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO Radius-"; >;
float mExposure : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Exposure"; >;
float mVignette : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Vignette"; >;
float mDispersion : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Dispersion"; >;
float mDispersionRadius : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DispersionRadius"; >;
float mBloomThreshold : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomThreshold"; >;
float mBloomRadius : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomRadius"; >;
float mBloomIntensity : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomIntensity"; >;
float mToneMapping : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "ToneMapping"; >;
float mColBalanceRP :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceR+"; >;
float mColBalanceGP :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceG+"; >;
float mColBalanceBP :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceB+"; >;
float mColBalanceRM :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceR-"; >;
float mColBalanceGM :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceG-"; >;
float mColBalanceBM :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceB-"; >;
float mColBalance  :  CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BalanceGray+"; >;

float mSSRRangeP :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "Range+"; >;
float mSSRRangeM :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "Range-"; >;
float mSSRThickness :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "Thickness"; >;
float mSSRJitter :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "Jitter"; >;
float mSSRStride :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "Stride"; >;
float mSSRStrideZCutoff :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "StrideZCutoff"; >;
float mSSRFadeStart :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "FadeStart"; >;
float mSSRFadeEnd :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "FadeEnd"; >;
float mSSRFadeDistance :  CONTROLOBJECT < string name="SSRController.pmx"; string item = "FadeDistance"; >;

#if FOG_ENABLE
    float mFogR :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "R+"; >;
    float mFogG :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "G+"; >;
    float mFogB :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "B+"; >;
    float mFogDensity :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "Density"; >;
    float mFogHeight :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "Height"; >;
    float mFogRadius :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "Radius"; >;
    float mFogFadeoff :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "Fadeoff"; >;
    float mFogSky :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "Sky"; >;
    float mFogSkyTwoColor :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "SkyTwoColor"; >;
    float mFogSkyR :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "SkyR+"; >;
    float mFogSkyG :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "SkyG+"; >;
    float mFogSkyB :  CONTROLOBJECT < string name="GroundFogController.pmx"; string item = "SkyB+"; >;
#endif

float3 LightDiffuse   : DIFFUSE   < string Object = "Light"; >;
float3 LightSpecular  : SPECULAR  < string Object = "Light"; >;
float3 LightDirection : DIRECTION < string Object = "Light"; >;

#include "shader/math.fx"
#include "shader/common.fx"
#include "shader/textures.fx"
#include "shader/gbuffer.fx"
#include "shader/lighting.fx"
#include "shader/fimic.fx"

#if SHADOW_QUALITY > 0
#   include "shader/shadowmap.fx"
#endif

#if SSAO_QUALITY > 0
#   include "shader/ssao.fx"
#endif

#if SSSS_QUALITY > 0
#   include "shader/ssss.fx"
#endif

#if SSR_QUALITY > 0
#   include "shader/ssr.fx"
#endif

#if AA_QUALITY > 0
#   include "shader/fxaa.fx"
#endif

#include "shader/shading.fx"

void ScreenSpaceQuadVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD,
    out float4 oTexcoord : TEXCOORD0,
    out float3 oViewdir : TEXCOORD1,
    out float4 oPosition : SV_Position)
{
    oPosition = Position;
    oViewdir = -mul(Position, matProjectInverse).xyz;
    oTexcoord = Texcoord;
    oTexcoord.xy += ViewportOffset;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

technique DeferredLighting<
	string Script =
    "RenderColorTarget0=;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "ClearSetColor=BackColor;"
    "ClearSetDepth=ClearDepth;"
    "ClearSetStencil=ClearStencil;"
    
#if SHADOW_QUALITY && SHADOW_SOFT_ENABLE
    "RenderColorTarget0=ShadowmapMapTemp; Pass=ShadowBlurPassX;"
    "RenderColorTarget0=ShadowmapMap;     Pass=ShadowBlurPassY;"
#elif SHADOW_QUALITY
    "RenderColorTarget0=ShadowmapMap; Pass=ShadowMapNoBlur;"
#endif

    "RenderColorTarget0=ScnMap;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Color;"
    "Clear=Depth;"
    "ScriptExternal=Color;"

#if SSAO_QUALITY
    "RenderColorTarget0=SSAOMap;  Pass=SSAO;"
    "RenderColorTarget0=SSAOMapTemp; Pass=SSAOBlurX;"
    "RenderColorTarget0=SSAOMap;     Pass=SSAOBlurY;"
#endif

    "RenderColorTarget0=ShadingMap;"
    "RenderDepthStencilTarget=;"
    "Pass=DeferredShading;"
    
#if SSR_QUALITY > 0
    "RenderColorTarget=SSRayTracingMap;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Depth;"
    "Clear=Color;"
    "Pass=SSRayTracing;"
    
    "RenderColorTarget0=SSRLightMapTemp; Pass=SSRGaussionBlurX1;"
    "RenderColorTarget0=SSRLightMap;     Pass=SSRGaussionBlurY1;"
    
    "RenderColorTarget=ShadingMap;"
    "Pass=SSRConeTracing;"
#endif

#if SSSS_QUALITY > 0
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Depth;"
    "Pass=SSSSStencilTest;"
    "RenderColorTarget0=ShadingMapTemp; Pass=SSSSBlurX;"
    "RenderColorTarget0=ShadingMap;     Pass=SSSSBlurY;"
#endif

#if HDR_BLOOM_QUALITY > 0
    "RenderColorTarget0=BloomMapX1;     Pass=GlareDetection;"
    "RenderColorTarget0=BloomMapX2Temp; Pass=BloomBlurX2;"
    "RenderColorTarget0=BloomMapX2;     Pass=BloomBlurY2;"
    "RenderColorTarget0=BloomMapX3Temp; Pass=BloomBlurX3;"
    "RenderColorTarget0=BloomMapX3;     Pass=BloomBlurY3;"
    "RenderColorTarget0=BloomMapX4Temp; Pass=BloomBlurX4;"
    "RenderColorTarget0=BloomMapX4;     Pass=BloomBlurY4;"
    "RenderColorTarget0=BloomMapX5Temp; Pass=BloomBlurX5;"
    "RenderColorTarget0=BloomMapX5;     Pass=BloomBlurY5;"
#endif

#if AA_QUALITY > 0
    "RenderColorTarget0=FinalMap;"
    "Pass=FimicToneMapping;"

    "RenderColorTarget0=;"
    "RenderDepthStencilTarget=;"
    "Pass=AntiAliasing;"
#else
    "RenderColorTarget0=;"
    "RenderDepthStencilTarget=;"
    "Pass=FimicToneMapping;"
#endif
;>
{
#if SHADOW_QUALITY && SHADOW_SOFT_ENABLE
    pass ShadowBlurPassX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapBlurPS(DepthMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass ShadowBlurPassY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapBlurPS(ShadowmapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#elif SHADOW_QUALITY
    pass ShadowMapNoBlur < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapNoBlurPS(DepthMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
#endif
#if SSAO_QUALITY
    pass SSAO < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAO();
    }
    #if SSAO_BLUR_RADIUS > 0
    pass SSAOBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAOBlur(SSAOMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass SSAOBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAOBlur(SSAOMapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
    #endif
#endif
    pass DeferredShading < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 DeferredShadingPS();
    }
#if SSSS_QUALITY > 0
    pass SSSSStencilTest < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        ColorWriteEnable = false;
        StencilEnable = true;
        StencilFunc = ALWAYS;
        StencilRef = 1;
        StencilPass = REPLACE;
        StencilFail = KEEP;
        StencilZFail = KEEP;
        StencilWriteMask = 1;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSSSStencilTestPS();
    }
    pass SSSSBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GuassBlurPS(ShadingMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass SSSSBlurY < string Script= "Draw=Buffer;"; > {
         AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GuassBlurPS(ShadingMapTempSamp, float2(0.0f, ViewportOffset2.y));
    }
#endif
#if SSR_QUALITY > 0
    pass SSRayTracing < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = ALWAYS;
        StencilRef = 1;
        StencilPass = REPLACE;
        StencilFail = KEEP;
        StencilZFail = KEEP;
        StencilWriteMask = 1;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRayTracingPS();
    }
    pass SSRGaussionBlurX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(ShadingMapSamp, float2(ViewportOffset.x, 0.0));
    }
    pass SSRGaussionBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightSampTemp, float2(0.0, ViewportOffset.y));
    }
    pass SSRConeTracing < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = true; AlphaTestEnable = false;
        SrcBlend = SRCALPHA; DestBlend = ONE;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRConeTracingPS();
    }
#endif
#if HDR_BLOOM_QUALITY > 0
    pass GlareDetection < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GlareDetectionPS(ShadingMapSamp, float4(-1,0,1,0) * ViewportOffset2.xyxy, float4(0,-1,0,1) * ViewportOffset2.xyxy);
    }
    pass BloomBlurX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1, float2(ViewportOffset2.x, 0.0));
    }
    pass BloomBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1Temp, float2(0.0f, ViewportOffset2.y));
    }
    pass BloomBlurX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1, float2(ViewportOffset2.x, 0.0));
    }
    pass BloomBlurY2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX2Temp, float2(0.0f, ViewportOffset2.y * 2));
    }
    pass BloomBlurX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX2, float2(ViewportOffset2.x * 4, 0.0));
    }
    pass BloomBlurY3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX3Temp, float2(0.0f, ViewportOffset2.y * 4));
    }
    pass BloomBlurX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX3, float2(ViewportOffset2.x * 8, 0.0));
    }
    pass BloomBlurY4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(8);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX4Temp, float2(0.0f, ViewportOffset2.y * 8));
    }
    pass BloomBlurX5 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(8);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX4, float2(ViewportOffset2.x * 16, 0.0));
    }
    pass BloomBlurY5 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(16);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX5Temp, float2(0.0f, ViewportOffset2.y * 16));
    }
#endif
    pass FimicToneMapping < string Script= "Draw=Buffer;"; > {
         AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 FimicToneMappingPS(ShadingMapSamp);
    }
#if AA_QUALITY > 0
    pass AntiAliasing < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 FXAA3(FinalMapSamp, ViewportOffset2);
    }
#endif
}