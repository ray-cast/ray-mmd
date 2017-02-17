#include "ray.conf"
#include "ray_advanced.conf"

const float4 BackColor = 0.0;
const float4 WhiteColor = 1.0;
const float ClearDepth = 1.0;
const int ClearStencil = 0;

float mDirectionLightP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "DirectionLight+";>;
float mDirectionLightM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "DirectionLight-";>;
float mEnvShadowP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "EnvShadow+";>;
float mSSAOP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAO+";>;
float mSSAOM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAO-";>;
float mSSDOP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSDO+";>;
float mSSDOM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSDO-";>;
float mExposureP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Exposure";>;
float mVignette : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Vignette";>;
float mDispersion : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Dispersion";>;
float mDispersionRadius : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "DispersionRadius";>;
float mBloomThresholdP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomThreshold";>;
float mBloomRadius : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomRadius";>;
float mBloomIntensityP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomIntensity";>;
float mBloomStarFade : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomStarFade";>;
float mBloomTonemapping : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomTonemapping";>;
float mTonemapping : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Tonemapping";>;
float mContrastP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Contrast+";>;
float mContrastM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Contrast-";>;
float mColBalanceRP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceR+";>;
float mColBalanceGP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceG+";>;
float mColBalanceBP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceB+";>;
float mColBalanceRM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceR-";>;
float mColBalanceGM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceG-";>;
float mColBalanceBM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceB-";>;
float mColBalance : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceGray+";>;
float mTemperatureP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Temperature+";>;
float mTemperatureM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Temperature-";>;

float3 LightSpecular : SPECULAR< string Object = "Light";>;
float3 LightDirection : DIRECTION< string Object = "Light";>;

bool ExistSkybox : CONTROLOBJECT<string name = "skybox.pmx";>;
bool ExistSkyboxHDR : CONTROLOBJECT<string name = "skybox_hdr.pmx";>;
bool ExistTimeOfDay : CONTROLOBJECT<string name = "Time of day.pmx";>;

static float mSSAOScale = lerp(lerp(mSSAOIntensityMin, mSSAOIntensityMax, mSSAOP), 0, mSSAOM);
static float mSSDOScale = lerp(lerp(mSSDOIntensityMin, mSSDOIntensityMax, mSSDOP), 0, mSSDOM);
static float mMainLightIntensity = lerp(lerp(mLightIntensityMin, mLightIntensityMax, mDirectionLightP), 0, mDirectionLightM);
static float mColorTemperature = lerp(lerp(6400, 1000, mTemperatureP), 40000, mTemperatureM);
static float mExposure = mExposureMin + mExposureP * mExposureMax;
static float mContrast = lerp(lerp(1, 2, mContrastP), 0.5, mContrastM);
static float mBloomThreshold = (1.0 - mBloomThresholdP) / (mBloomThresholdP + 1e-5);
static float mBloomIntensity = lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomIntensityP);
static float3 mColorBalanceRGBP = float3(mColBalanceRP, mColBalanceGP, mColBalanceBP);
static float3 mColorBalanceRGBM = float3(mColBalanceRM, mColBalanceGM, mColBalanceBM);

#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/textures.fxsub"
#include "shader/gbuffer.fxsub"
#include "shader/lighting.fxsub"
#include "shader/ACES.fxsub"
#include "shader/fimic.fxsub"
#include "shader/ibl.fxsub"

#if SHADOW_QUALITY > 0 && MAIN_LIGHT_ENABLE
#   include "shader/csm.fxsub"
#   include "shader/shadowmap.fxsub"
#endif

#if SSAO_QUALITY > 0 && (IBL_QUALITY || MAIN_LIGHT_ENABLE)
#   include "shader/ssao.fxsub"
#endif

#if SSSS_QUALITY > 0
#   include "shader/ssss.fxsub"
#endif

#if SSR_QUALITY > 0
#   include "shader/ssr.fxsub"
#endif

#if AA_QUALITY == 1
#   include "shader/fxaa.fxsub"
#endif

#if AA_QUALITY >= 2 && AA_QUALITY <= 5
#   include "shader/smaa.fxsub"
#endif

#include "shader/shading.fxsub"

float4 ScreenSpaceQuadVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1) : POSITION
{
	oTexcoord0 = Texcoord;
	oTexcoord0.xy += ViewportOffset;
	oTexcoord0.zw = oTexcoord0.xy * ViewportSize;
	oTexcoord1 = -mul(Position, matProjectInverse).xyz;    
	return Position;
}

float4 ScreenSpaceQuadOffsetVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD,
	out float2 oTexcoord : TEXCOORD0,
	uniform float2 offset) : POSITION
{
	oTexcoord = Texcoord + offset * 0.5;
	return Position;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

technique DeferredLighting<
	string Script =
	"RenderColorTarget=;"
	"RenderDepthStencilTarget=DepthBuffer;"
	"ClearSetStencil=ClearStencil;"
	"ClearSetColor=BackColor;"
	"ClearSetDepth=ClearDepth;"
	"Clear=Color;"

#if SHADOW_QUALITY > 0 && MAIN_LIGHT_ENABLE
	"RenderColorTarget=ShadowmapMap;"
	"ClearSetColor=WhiteColor;"
	"Clear=Color;"
	"Pass=ShadowMapGen;"
	"RenderColorTarget=ShadowmapMapTemp; Pass=ShadowBlurX;"
	"RenderColorTarget=ShadowmapMap;     Pass=ShadowBlurY;"
	"ClearSetColor=BackColor;"
#endif

	"RenderColorTarget=ScnMap;"
	"RenderDepthStencilTarget=DepthBuffer;"
	"Clear=Color;"
	"Clear=Depth;"
	"ScriptExternal=Color;"

#if SSAO_QUALITY > 0 && (IBL_QUALITY || MAIN_LIGHT_ENABLE)
	"RenderColorTarget=SSAOMap;  Pass=SSAO;"
#if SSAO_BLUR_RADIUS > 0
	"RenderColorTarget=SSAOMapTemp; Pass=SSAOBlurX;"
	"RenderColorTarget=SSAOMap;     Pass=SSAOBlurY;"
#endif
#endif

	"RenderColorTarget0=ShadingMapTemp;"
	"RenderColorTarget1=ShadingMapTempSpecular;"
	"Pass=ShadingOpacity;"
	"RenderColorTarget1=;"
	
#if SSSS_QUALITY > 0
	"RenderDepthStencilTarget=DepthBuffer;"
	"Clear=Depth;"
	"Pass=SSSSStencilTest;"
	"RenderColorTarget=ShadingMap;     Pass=SSSSBlurX;"
	"RenderColorTarget=ShadingMapTemp; Pass=SSSSBlurY;"
	"RenderColorTarget=ShadingMapTemp; Pass=ShadingOpacityAlbedo;"
	"RenderColorTarget=ShadingMapTemp; Pass=ShadingOpacitySpecular;"
#else
	"RenderColorTarget=ShadingMapTemp; Pass=ShadingOpacitySpecular;"
#endif

	"RenderColorTarget=ShadingMap; Pass=ShadingTransparent;"
	
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
#if HDR_STAR_MODE == 1 || HDR_STAR_MODE == 2
	"RenderColorTarget=StreakMap1stTemp; Pass=Star1stStreak1st;"
	"RenderColorTarget=StreakMap1st;     Pass=Star1stStreak2nd;"
	"RenderColorTarget=StreakMap1stTemp; Pass=Star1stStreak3rd;"
	"RenderColorTarget=StreakMap1st;     Pass=Star1stStreak4th;"
	"RenderColorTarget=StreakMap2ndTemp; Pass=Star2ndStreak1st;"
	"RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak2nd;"
	"RenderColorTarget=StreakMap2ndTemp; Pass=Star2ndStreak3rd;"
	"RenderColorTarget=StreakMap2nd;     Pass=Star2ndStreak4th;"
#endif
#if HDR_STAR_MODE == 3 || HDR_STAR_MODE == 4
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

#if AA_QUALITY == 0
	"RenderColorTarget=;"
	"RenderDepthStencilTarget=;"
	"Pass=FimicToneMapping;"
#else
	"RenderColorTarget=ShadingMapTemp;"
	"Pass=FimicToneMapping;"
#endif

#if AA_QUALITY == 1
	"RenderColorTarget=;"
	"RenderDepthStencilTarget=;"
	"Pass=FXAA;"
#endif

#if AA_QUALITY == 2 || AA_QUALITY == 3
	"RenderColorTarget=SMAAEdgeMap;  Clear=Color; Pass=SMAAEdgeDetection;"
	"RenderColorTarget=SMAABlendMap; Clear=Color; Pass=SMAABlendingWeightCalculation;"
	"RenderColorTarget=; Pass=SMAANeighborhoodBlending;"
#endif

#if AA_QUALITY == 4 || AA_QUALITY == 5
	"RenderColorTarget=SMAAEdgeMap;  Clear=Color; Pass=SMAAEdgeDetection1x;"
	"RenderColorTarget=SMAABlendMap; Clear=Color; Pass=SMAABlendingWeightCalculation1x;"
	"RenderColorTarget=ShadingMap; Pass=SMAANeighborhoodBlending;"
	
	"RenderColorTarget=SMAAEdgeMap;  Clear=Color; Pass=SMAAEdgeDetection2x;"
	"RenderColorTarget=SMAABlendMap; Clear=Color; Pass=SMAABlendingWeightCalculation2x;"
	"RenderColorTarget=; Pass=SMAANeighborhoodBlendingFinal;"
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
#if SSAO_QUALITY && (IBL_QUALITY || MAIN_LIGHT_ENABLE)
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
	pass ShadingOpacitySpecular < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = ONE;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ShadingOpacitySpecularPS();
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
	pass ShadingOpacityAlbedo < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = DESTCOLOR; DestBlend = ZERO;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ShadingOpacityAlbedoPS();
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
		SrcBlend = ONE; DestBlend = INVSRCALPHA;
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
#if HDR_STAR_MODE == 1 || HDR_STAR_MODE == 2
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
#endif
#if HDR_STAR_MODE == 3 || HDR_STAR_MODE == 4
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
		PixelShader  = compile ps_3_0 GhostImagePS(DownsampleSamp3rd, BloomSamp2nd, BloomSamp2nd, ghost_modulation1st, mBloomStarFade);   
	}
	pass GhostImage2nd < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = ONE;
		VertexShader = compile vs_3_0 GhostImageVS(ghost_scalar2nd);
		PixelShader  = compile ps_3_0 GhostImagePS(GhostImageMapSamp, GhostImageMapSamp, BloomSamp2nd, ghost_modulation2nd, 0);
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
#if AA_QUALITY == 1
	pass FXAA < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 FXAA3(ShadingMapTempSamp, ViewportOffset2);
	}
#endif
#if AA_QUALITY == 2 || AA_QUALITY == 3
	pass SMAAEdgeDetection < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS();
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapTempSamp);
	}
	pass SMAABlendingWeightCalculation < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS();
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(0, 0, 0, 0));
	}
	pass SMAANeighborhoodBlending < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS();
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapTempSamp, 1);
	}
#endif
#if AA_QUALITY == 4 || AA_QUALITY == 5
	pass SMAAEdgeDetection1x < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS();
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapTempSamp);
	}
	pass SMAABlendingWeightCalculation1x < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS();
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(1, 1, 1, 0));
	}
	pass SMAANeighborhoodBlending < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS();
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapTempSamp, 0);
	}
	pass SMAAEdgeDetection2x < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS();
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapSamp);
	}
	pass SMAABlendingWeightCalculation2x < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS();
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(2, 2, 2, 0));
	}
	pass SMAANeighborhoodBlendingFinal < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS();
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapSamp, 1);
	}
#endif
}