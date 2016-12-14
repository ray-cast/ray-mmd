#include "ray.conf"
#include "ray_advanced.conf"

const float4 BackColor = 0.0;
const float4 WhiteColor = 1.0;
const float ClearDepth = 1.0;
const int ClearStencil = 0;

float mDirectionLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectionLight+"; >;
float mDirectionLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectionLight-"; >;
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
float mBloomTonemapping : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomTonemapping"; >;
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

float3 LightDiffuse   : DIFFUSE   < string Object = "Light"; >;
float3 LightSpecular  : SPECULAR  < string Object = "Light"; >;
float3 LightDirection : DIRECTION < string Object = "Light"; >;

#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/textures.fxsub"
#include "shader/gbuffer.fxsub"
#include "shader/lighting.fxsub"
#include "shader/ACES.fxsub"
#include "shader/fimic.fxsub"

#if SHADOW_QUALITY > 0
#   include "shader/shadowcommon.fxsub"
#   include "shader/shadowmap.fxsub"
#endif

#if SSAO_QUALITY > 0
#   include "shader/ssao.fxsub"
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
    oTexcoord.zw = oTexcoord.xy * ViewportSize;
}

void ScreenSpaceQuadOffsetVS(
    in float4 Position : POSITION,
    in float2 Texcoord : TEXCOORD,
    out float2 oTexcoord : TEXCOORD0,
    out float4 oPosition : POSITION,
    uniform float2 offset)
{
    oPosition = Position;
    oTexcoord = Texcoord + offset * 0.5;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

technique DeferredLighting<
	string Script =
    "RenderColorTarget=ScnMap;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "ClearSetStencil=ClearStencil;"
    "ClearSetColor=BackColor;"
    "ClearSetDepth=ClearDepth;"
    "Clear=Color;"
    "Clear=Depth;"
    "ScriptExternal=Color;"

#if SHADOW_QUALITY > 0 && MAIN_LIGHT_ENABLE
    "RenderColorTarget=ShadowmapMap;"
    "ClearSetColor=WhiteColor;"
    "Clear=Color;"
    "Pass=ShadowMapGen;"
    "RenderColorTarget=ShadowmapMapTemp; Pass=ShadowBlurX;"
    "RenderColorTarget=ShadowmapMap;     Pass=ShadowBlurY;"
    "ClearSetColor=BackColor;"
#endif

#if SSAO_QUALITY > 0
    "RenderColorTarget=SSAOMap;  Pass=SSAO;"
#if SSAO_BLUR_RADIUS > 0
    "RenderColorTarget=SSAOMapTemp; Pass=SSAOBlurX;"
    "RenderColorTarget=SSAOMap;     Pass=SSAOBlurY;"
#endif
#endif

    "RenderColorTarget=ShadingMapTemp; Pass=ShadingOpacity;"   
    
#if SSSS_QUALITY > 0
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Depth;"
    "Pass=SSSSStencilTest;"
    "RenderColorTarget=ShadingMap;     Pass=SSSSBlurX;"
    "RenderColorTarget=ShadingMapTemp; Pass=SSSSBlurY;"
    "RenderColorTarget=ShadingMapTemp; Pass=ShadingOpacitySpecular;"
#endif

    "RenderColorTarget=ShadingMap;     Pass=ShadingTransparent;"
    
#if SSR_QUALITY > 0
    "RenderColorTarget=SSRLightX1Map;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Depth;"
    "Clear=Color;"
    "Pass=SSRConeTracing;"
          
    "RenderColorTarget=SSRLightX1MapTemp; Pass=SSRGaussionBlurX1;"
    "RenderColorTarget=SSRLightX1Map;     Pass=SSRGaussionBlurY1;"
    "RenderColorTarget=SSRLightX2MapTemp; Pass=SSRGaussionBlurX2;"
    "RenderColorTarget=SSRLightX2Map;     Pass=SSRGaussionBlurY2;"
    "RenderColorTarget=SSRLightX3MapTemp; Pass=SSRGaussionBlurX3;"
    "RenderColorTarget=SSRLightX3Map;     Pass=SSRGaussionBlurY3;"
    "RenderColorTarget=SSRLightX4MapTemp; Pass=SSRGaussionBlurX4;"
    "RenderColorTarget=SSRLightX4Map;     Pass=SSRGaussionBlurY4;"
    
    "RenderColorTarget=ShadingMap;        Pass=SSRFinalCombie;"    
#endif

#if HDR_BLOOM_MODE > 0
    "RenderColorTarget=DownsampleMap1st; Pass=GlareDetection;"
    "RenderColorTarget=DownsampleMap2nd; Pass=HDRDownsample1st;"
    "RenderColorTarget=DownsampleMap3rd; Pass=HDRDownsample2nd;"
    "RenderColorTarget=BloomMap1stTemp;  Pass=BloomBlurX1;"
    "RenderColorTarget=BloomMap1st;      Pass=BloomBlurY1;"
    "RenderColorTarget=BloomMap2nd;      Pass=BloomDownsampleX2;"
    "RenderColorTarget=BloomMap2ndTemp;  Pass=BloomBlurX2;"
    "RenderColorTarget=BloomMap2nd;      Pass=BloomBlurY2;"
    "RenderColorTarget=BloomMap3rd;      Pass=BloomDownsampleX3;"
    "RenderColorTarget=BloomMap3rdTemp;  Pass=BloomBlurX3;"
    "RenderColorTarget=BloomMap3rd;      Pass=BloomBlurY3;"
    "RenderColorTarget=BloomMap4th;      Pass=BloomDownsampleX4;"
    "RenderColorTarget=BloomMap4thTemp;  Pass=BloomBlurX4;"
    "RenderColorTarget=BloomMap4th;      Pass=BloomBlurY4;"
#if HDR_STAR_MODE == 1
    "RenderColorTarget=StreakMap1stTemp; Pass=Star1stStreak1st;"
    "RenderColorTarget=StreakMap1st;     Pass=Star1stStreak2nd;"
    "RenderColorTarget=StreakMap1stTemp; Pass=Star1stStreak3rd;"
    "RenderColorTarget=StreakMap1st;     Pass=Star1stStreak4th;"
    "RenderColorTarget=StreakMap2ndTemp; Pass=Star2ndStreak1st;"
    "RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak2nd;"
    "RenderColorTarget=StreakMap2ndTemp; Pass=Star2ndStreak3rd;"
    "RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak4th;"
#elif HDR_STAR_MODE >= 2
    "RenderColorTarget=StreakMap1st;     Pass=Star1stStreak1st;"
    "RenderColorTarget=StreakMap1stTemp; Pass=Star1stStreak2nd;"
    "RenderColorTarget=StreakMap1st;     Pass=Star1stStreak3rd;"
    "RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak1st;"
    "RenderColorTarget=StreakMap2ndTemp; Pass=Star2ndStreak2nd;"
    "RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak3rd;"
    "RenderColorTarget=StreakMap3rd;     Pass=Star3rdStreak1st;"
    "RenderColorTarget=StreakMap3rdTemp; Pass=Star3rdStreak2nd;"
    "RenderColorTarget=StreakMap3rd;     Pass=Star3rdStreak3rd;"
    "RenderColorTarget=StreakMap4th;     Pass=Star4thStreak1st;"
    "RenderColorTarget=StreakMap4thTemp; Pass=Star4thStreak2nd;"
    "RenderColorTarget=StreakMap4th;     Pass=Star4thStreak3rd;"
#endif
    "RenderColorTarget=GlareLightMap; Pass=GlareLightComp;"
#if HDR_FLARE_MODE > 0
    "RenderColorTarget=GhostImageMap; Pass=GhostImage1st;"
    "RenderColorTarget=GlareLightMap; Pass=GhostImage2nd;"
#endif
#endif

#if AA_QUALITY > 0
    "RenderColorTarget=ShadingMapTemp;"
    "Pass=FimicToneMapping;"

    "RenderColorTarget=;"
    "RenderDepthStencilTarget=;"
    "Pass=AntiAliasing;"
#else
    "RenderColorTarget=;"
    "RenderDepthStencilTarget=;"
    "Pass=FimicToneMapping;"
#endif
;>
{
#if MAIN_LIGHT_ENABLE && SHADOW_QUALITY
    pass ShadowMapGen < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapGenPS();
    }
    pass ShadowBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapBlurPS(ShadowmapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass ShadowBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadowMapBlurPS(ShadowmapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#endif
#if SSAO_QUALITY
    pass SSAO < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAO();
    }
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
    pass ShadingOpacity < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadingOpacityPS();
    }
    pass ShadingTransparent < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadingTransparentPS();
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
        PixelShader  = compile ps_3_0 SSSGuassBlurPS(ShadingMapTempSamp, ShadingMapTempSamp, float2(1.0, 0.0));
    }
    pass SSSSBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSSGuassBlurPS(ShadingMapSamp, ShadingMapTempSamp,float2(0.0, 1.0));
    }
    pass ShadingOpacitySpecular < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = true; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        SrcBlend = ONE; DestBlend = ONE;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 ShadingOpacitySpecularPS();
    }
#endif
#if SSR_QUALITY > 0
    pass SSRConeTracing < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRConeTracingPS();
    }
    pass SSRGaussionBlurX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1Samp, SSROffsetX1);
    }
    pass SSRGaussionBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1SampTemp, SSROffsetY1);
    }
    pass SSRGaussionBlurX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1Samp, SSROffsetX2);
    }
    pass SSRGaussionBlurY2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 2);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX2SampTemp, SSROffsetY2);
    }
    pass SSRGaussionBlurX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 2);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX2Samp, SSROffsetX3);
    }
    pass SSRGaussionBlurY3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 4);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX3SampTemp, SSROffsetY3);
    }
    pass SSRGaussionBlurX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 4);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX3Samp, SSROffsetX4);
    }
    pass SSRGaussionBlurY4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 8);
        PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX4SampTemp, SSROffsetY4);
    }
    pass SSRFinalCombie < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = true; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSRFinalCombiePS();
    }
#endif
#if HDR_ENABLE && HDR_BLOOM_MODE > 0
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
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
        PixelShader  = compile ps_3_0 BloomBlurPS(DownsampleSamp2nd, BloomOffsetX1, 5);
    }
    pass BloomBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp1stTemp, BloomOffsetY1, 5);
    }
    pass BloomDownsampleX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp1st);
    }
    pass BloomBlurX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2nd, BloomOffsetX2, 7);
    }
    pass BloomBlurY2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2ndTemp, BloomOffsetY2, 7);
    }
    pass BloomDownsampleX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp2nd);
    }
    pass BloomBlurX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rd, BloomOffsetX3, 9);
    }
    pass BloomBlurY3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rdTemp, BloomOffsetY3, 9);
    }
    pass BloomDownsampleX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
        PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp3rd);
    }
    pass BloomBlurX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4th, BloomOffsetX4, 11);
    }
    pass BloomBlurY4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4thTemp, BloomOffsetY4, 11);
    }
#if HDR_STAR_MODE == 1
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
#elif HDR_STAR_MODE >= 2
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
#if HDR_FLARE_MODE
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
        VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2 * 2);
        PixelShader  = compile ps_3_0 GlareLightCompPS();
    }
#endif
    pass FimicToneMapping < string Script= "Draw=Buffer;"; > {
         AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = false; ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 FilmicToneMappingPS(ShadingMapSamp);
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