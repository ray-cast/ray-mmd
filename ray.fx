#include "ray.conf"

const float4 BackColor = float4(0,0,0,0);
const float ClearDepth = 1.0;
const int ClearStencil = 0;

float mDirectionLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectionLight+"; >;
float mDirectionLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectionLight-"; >;
float mMultiLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "MultiLight+"; >;
float mMultiLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "MultiLight-"; >;
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
float mBloomStarFade : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomStarFade"; >;
float mTonemapping : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Tonemapping"; >;
float mContrastP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Contrast+"; >;
float mContrastM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Contrast-"; >;
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

#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/textures.fxsub"
#include "shader/gbuffer.fxsub"
#include "shader/lighting.fxsub"
#include "shader/fimic.fxsub"

#if SHADOW_QUALITY > 0
#   include "shader/shadowmap.fxsub"
#endif

#if SSAO_QUALITY > 0
#   include "shader/ssao.fxsub"
#endif

#if OUTDOORFLOOR_QUALITY > 0
#   include "shader/OutdoorFloor/OutdoorFloor.fxsub"
#endif

#if SSSS_QUALITY > 0
#   include "shader/ssss.fxsub"
#endif

#if SSR_QUALITY > 0
#   include "shader/ssr.fxsub"
#endif

#if AA_QUALITY > 0
#   include "shader/fxaa.fxsub"
#endif

#include "shader/shading.fxsub"

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

#if SSAO_QUALITY > 0
    "RenderColorTarget0=SSAOMap;  Pass=SSAO;"
#if SSAO_BLUR_RADIUS > 0
    "RenderColorTarget0=SSAOMapTemp; Pass=SSAOBlurX;"
    "RenderColorTarget0=SSAOMap;     Pass=SSAOBlurY;"
#endif
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
    "RenderColorTarget0=DownsampleMap1st; Pass=GlareDetection;"
    "RenderColorTarget0=DownsampleMap2nd; Pass=HDRDownsample1st;"
    "RenderColorTarget0=DownsampleMap3rd; Pass=HDRDownsample2nd;"
    "RenderColorTarget0=BloomMap1stTemp; Pass=BloomBlurX1;"
    "RenderColorTarget0=BloomMap1st;     Pass=BloomBlurY1;"
    "RenderColorTarget0=BloomMap2nd;     Pass=BloomDownsampleX2;"
    "RenderColorTarget0=BloomMap2ndTemp; Pass=BloomBlurX2;"
    "RenderColorTarget0=BloomMap2nd;     Pass=BloomBlurY2;"
    "RenderColorTarget0=BloomMap3rd;     Pass=BloomDownsampleX3;"
    "RenderColorTarget0=BloomMap3rdTemp; Pass=BloomBlurX3;"
    "RenderColorTarget0=BloomMap3rd;     Pass=BloomBlurY3;"
    "RenderColorTarget0=BloomMap4th;     Pass=BloomDownsampleX4;"
    "RenderColorTarget0=BloomMap4thTemp; Pass=BloomBlurX4;"
    "RenderColorTarget0=BloomMap4th;     Pass=BloomBlurY4;"
#if HDR_BLOOM_QUALITY == 2
    "RenderColorTarget0=StreakMap1stTemp; Pass=Star1stStreak1st;"
    "RenderColorTarget0=StreakMap1st;     Pass=Star1stStreak2nd;"
    "RenderColorTarget0=StreakMap1stTemp; Pass=Star1stStreak3rd;"
    "RenderColorTarget0=StreakMap1st;     Pass=Star1stStreak4th;"
    "RenderColorTarget0=StreakMap2ndTemp; Pass=Star2ndStreak1st;"
    "RenderColorTarget0=StreakMap2nd;     Pass=Star2ndStreak2nd;"
    "RenderColorTarget0=StreakMap2ndTemp; Pass=Star2ndStreak3rd;"
    "RenderColorTarget0=StreakMap2nd;     Pass=Star2ndStreak4th;"
#elif HDR_BLOOM_QUALITY >= 3
    "RenderColorTarget0=StreakMap1st;     Pass=Star1stStreak1st;"
    "RenderColorTarget0=StreakMap1stTemp; Pass=Star1stStreak2nd;"
    "RenderColorTarget0=StreakMap1st;     Pass=Star1stStreak3rd;"
    "RenderColorTarget0=StreakMap2nd;     Pass=Star2ndStreak1st;"
    "RenderColorTarget0=StreakMap2ndTemp; Pass=Star2ndStreak2nd;"
    "RenderColorTarget0=StreakMap2nd;     Pass=Star2ndStreak3rd;"
    "RenderColorTarget0=StreakMap3rd;     Pass=Star3rdStreak1st;"
    "RenderColorTarget0=StreakMap3rdTemp; Pass=Star3rdStreak2nd;"
    "RenderColorTarget0=StreakMap3rd;     Pass=Star3rdStreak3rd;"
    "RenderColorTarget0=StreakMap4th;     Pass=Star4thStreak1st;"
    "RenderColorTarget0=StreakMap4thTemp; Pass=Star4thStreak2nd;"
    "RenderColorTarget0=StreakMap4th;     Pass=Star4thStreak3rd;"
#endif
    "RenderColorTarget0=GlareLightMap;   Pass=GlareLightComp;"
#if HDR_FLARE_ENABLE > 0
    "RenderColorTarget0=GhostImageMap;   Pass=GhostImage1st;"
    "RenderColorTarget0=GlareLightMap;   Pass=GhostImage2nd;"
#endif
#endif

#if AA_QUALITY > 0
    "RenderColorTarget0=ShadingMapTemp;"
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
        PixelShader  = compile ps_3_0 SSSGuassBlurPS(ShadingMapSamp, ShadingMapSamp, float2(ViewportOffset2.x * ViewportAspect, 0.0f));
    }
    pass SSSSBlurY < string Script= "Draw=Buffer;"; > {
         AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSSGuassBlurPS(ShadingMapTempSamp, ShadingMapSamp,float2(0.0f, ViewportOffset2.y));
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
        VertexShader = compile vs_3_0 GlareDetectionVS();
        PixelShader  = compile ps_3_0 GlareDetectionPS(ShadingMapSamp);
    }
    pass HDRDownsample1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 HDRDownsample4XPS(DownsampleSamp1st);
    }
    pass HDRDownsample2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRDownsampleVS(ViewportOffset2 * 2);
        PixelShader  = compile ps_3_0 HDRDownsample4XPS(DownsampleSamp2nd);
    }
    pass BloomBlurX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset1);
        PixelShader  = compile ps_3_0 BloomBlurPS(DownsampleSamp2nd, BloomOffsetX1);
    }
    pass BloomBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp1stTemp, BloomOffsetY1);
    }
    pass BloomDownsampleX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset1);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp1st);
    }
    pass BloomBlurX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2nd, BloomOffsetX2);
    }
    pass BloomBlurY2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2ndTemp, BloomOffsetY2);
    }
    pass BloomDownsampleX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset2);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp2nd);
    }
    pass BloomBlurX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset3);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rd, BloomOffsetX3);
    }
    pass BloomBlurY3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset3);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rdTemp, BloomOffsetY3);
    }
    pass BloomDownsampleX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset3);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp3rd);
    }
    pass BloomBlurX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4th, BloomOffsetX4);
    }
    pass BloomBlurY4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(BloomOffset4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4thTemp, BloomOffsetY4);
    }
#if HDR_BLOOM_QUALITY == 2
    pass Star1stStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star1stStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp1stTemp, star_colorCoeff2nd, 0);
    }
    pass Star1stStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp1st, star_colorCoeff3rd, 0);
    }
    pass Star1stStreak4th < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 64);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp1stTemp, star_colorCoeff4th, 0);
    }
    pass Star2ndStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star2ndStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp2ndTemp, star_colorCoeff2nd, 0);
    }
    pass Star2ndStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp2nd, star_colorCoeff3rd, 0);
    }
    pass Star2ndStreak4th < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 64);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp2ndTemp, star_colorCoeff4th, 0);
    }
#elif HDR_BLOOM_QUALITY >= 3
    pass Star1stStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star1stStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp1st, star_colorCoeff2nd, 0);
    }
    pass Star1stStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp1stTemp, star_colorCoeff3rd, 0);
    }
    pass Star2ndStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star2ndStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp2nd, star_colorCoeff2nd, 0);
    }
    pass Star2ndStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp2ndTemp, star_colorCoeff3rd, 0);
    }
    pass Star3rdStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star3rdStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp3rd, star_colorCoeff2nd, 0);
    }
    pass Star3rdStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp3rdTemp, star_colorCoeff3rd, 0);
    }
    pass Star4thStreak1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 1);
        PixelShader  = compile ps_3_0 StarStreakPS(DownsampleSamp3rd, star_colorCoeff1st, mBloomStarFade);
    }
    pass Star4thStreak2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 4);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp4th, star_colorCoeff2nd, 0);
    }
    pass Star4thStreak3rd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 16);
        PixelShader  = compile ps_3_0 StarStreakPS(StreakSamp4thTemp, star_colorCoeff3rd, 0);
    }
#endif
#if HDR_FLARE_ENABLE
    pass GhostImage1st < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 GhostImageVS(ghost_scalar1st);
        PixelShader  = compile ps_3_0 GhostImagePS(DownsampleSamp3rd, BloomSamp2nd, BloomSamp2nd, GhostMaskMapSamp, ghost_modulation1st, mBloomStarFade);   
    }
    pass GhostImage2nd < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = true; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        SrcBlend = ONE; DestBlend = ONE;
        VertexShader = compile vs_3_0 GhostImageVS(ghost_scalar2nd);
        PixelShader  = compile ps_3_0 GhostImagePS(GhostImageMapSamp, GhostImageMapSamp, BloomSamp3rd, GhostMaskMapSamp, ghost_modulation2nd, 0);
    }
#endif
    pass GlareLightComp < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 HDRScreenQuadVS(ViewportOffset2 * 2);
        PixelShader  = compile ps_3_0 GlareLightCompPS();
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
        PixelShader  = compile ps_3_0 FXAA3(ShadingMapTempSamp, ViewportOffset2);
    }
#endif
}