#include "ray.conf"
#include "ray_advanced.conf"

const float4 BackColor = 0.0;
const float4 WhiteColor = 1.0;
const float ClearDepth = 1.0;
const int ClearStencil = 0;

float mSunLightP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunLight+";>;
float mSunLightM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunLight-";>;
float mSunShadowRP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunShadowR+";>;
float mSunShadowGP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunShadowG+";>;
float mSunShadowBP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunShadowB+";>;
float mSunShadowVM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunShadowV-";>;
float mSunTemperatureP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunTemperature+";>;
float mSunTemperatureM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SunTemperature-";>;
float mSSAOP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAO+";>;
float mSSAOM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAO-";>;
float mSSAORadiusP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAORadius+";>;
float mSSAORadiusM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSAORadius-";>;
float mSSDOP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSDO+";>;
float mSSDOM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSDO-";>;
float mSSSSP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSSS+";>;
float mSSSSM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "SSSS-";>;
float mExposureP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Exposure+";>;
float mExposureM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Exposure-";>;
float mFstopP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Fstop+";>;
float mFstopM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Fstop-";>;
float mFocalDistanceP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "FocalDistance+";>;
float mFocalDistanceM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "FocalDistance-";>;
float mFocalRegionP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "FocalRegion+";>;
float mFocalRegionM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "FocalRegion-";>;
float mMeasureMode : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "MeasureMode";>;
float mTestMode : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "TestMode";>;
float mVignette : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Vignette";>;
float mDispersion : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Dispersion";>;
float mDispersionRadius : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "DispersionRadius";>;
float mBloomThresholdP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomThreshold+";>;
float mBloomThresholdM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomThreshold-";>;
float mBloomRadiusP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomRadius+";>;
float mBloomRadiusM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomRadius-";>;
float mBloomColorAllHP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomColorAllH+";>;
float mBloomColorAllSP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomColorAllS+";>;
float mBloomColorAllVP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomColorAllV+";>;
float mBloomColorAllVM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomColorAllV-";>;
float mBloomStarFade : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BloomStarFade";>;
float mContrastP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Contrast+";>;
float mContrastM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Contrast-";>;
float mSaturationP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Saturation+";>;
float mSaturationM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Saturation-";>;
float mGammaP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Gamma+";>;
float mGammaM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Gamma-";>;
float mColBalanceRP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceR+";>;
float mColBalanceGP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceG+";>;
float mColBalanceBP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceB+";>;
float mColBalanceRM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceR-";>;
float mColBalanceGM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceG-";>;
float mColBalanceBM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "BalanceB-";>;
float mTemperatureP : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Temperature+";>;
float mTemperatureM : CONTROLOBJECT<string name="ray_controller.pmx"; string item = "Temperature-";>;

static float mSSAOScale = lerp(lerp(mSSDOIntensityMin, mSSDOIntensityMax, mSSAOP), 0, mSSAOM);
static float mSSAORadius = lerp(lerp(1.0, 2.0, mSSAORadiusP), 0.5, mSSAORadiusM);
static float mSSDOScale = lerp(lerp(mSSDOIntensityMin, mSSDOIntensityMax, mSSDOP), 0, mSSDOM);
static float mSSSSScale = lerp(lerp(mSSSSIntensityMin, mSSSSIntensityMax, mSSSSP), 0.25, mSSSSM);
static float mSunIntensity = lerp(lerp(mLightIntensityMin, mLightIntensityMax, mSunLightP), 0, mSunLightM);
static float mSunTemperature = lerp(lerp(6600, 1000, mSunTemperatureP), 40000, mSunTemperatureM);
static float mExposure = lerp(lerp(mExposureMin, mExposureMax, mExposureP), 0, mExposureM);
static float mBloomRadius = lerp(lerp(0.75, 1.0, mBloomRadiusP), 0.0, mBloomRadiusM);
static float mBloomThreshold = lerp(lerp(1.0, mBloomThresholdMax, mBloomThresholdP), mBloomThresholdMin, mBloomThresholdM);
static float mColorContrast = lerp(lerp(1, 2, mContrastP), 0.5, mContrastM);
static float mColorSaturation = lerp(lerp(1, 2, mSaturationP), 0.0, mSaturationM);
static float mColorGamma = lerp(lerp(1.0, 0.45, mGammaP), 2.2, mGammaM);
static float mColorTemperature = lerp(lerp(mTemperature, 1000, mTemperatureP), 40000, mTemperatureM);
static float mFstop = lerp(lerp(5.6, 32.0, mFstopP), 1.0, mFstopM);
static float mFocalDistance = lerp(lerp(1, 10.0, mFocalDistanceP), -10.0, mFocalDistanceM);
static float mFocalRegion = lerp(lerp(0.1, 5.0, mFocalRegionP), 0.0, mFocalRegionM);
static float3 mColorShadowSunP = pow(float3(mSunShadowRP, mSunShadowGP, mSunShadowBP), 2);
static float3 mColorBalanceP = float3(mColBalanceRP, mColBalanceGP, mColBalanceBP);
static float3 mColorBalanceM = float3(mColBalanceRM, mColBalanceGM, mColBalanceBM);

#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/textures.fxsub"
#include "shader/Color.fxsub"
#include "shader/Packing.fxsub"
#include "shader/gbuffer.fxsub"
#include "shader/DeclareGbufferTexture.fxsub"
#include "shader/BRDF.fxsub"
#include "shader/ACES.fxsub"
#include "shader/ColorGrading.fxsub"
#include "shader/VolumeRendering.fxsub"
#include "shader/ScreenSpaceLighting.fxsub"

#if SUN_SHADOW_QUALITY && SUN_LIGHT_ENABLE
#	include "shader/ShadowMapCascaded.fxsub"
#	include "shader/ScreenSpaceShadow.fxsub"
#endif

#if SSDO_QUALITY && (IBL_QUALITY || SUN_LIGHT_ENABLE)
#	include "shader/ScreenSpaceAmbientOcclusion.fxsub"
#endif

#if SSSS_QUALITY
#	include "shader/ScreenSpaceSubsurfaceScattering.fxsub"
#endif

#if TOON_ENABLE == 2
#	include "shader/PostProcessDiffusion.fxsub"
#endif

#if SSR_QUALITY
#	include "shader/PostProcessSSR.fxsub"
#endif

#if BOKEH_MODE
#	include "shader/PostProcessBokeh.fxsub"
#endif

#if EYE_ADAPTATION
#	include "shader/PostProcessEyeAdaptation.fxsub"
#endif

#if HDR_BLOOM_MODE
#	include "shader/PostProcessBloom.fxsub"
#endif

#if HDR_STAR_MODE
#	include "shader/PostProcessLensflare.fxsub"
#endif

#if HDR_FLARE_MODE
#	include "shader/PostProcessGhost.fxsub"
#endif

#include "shader/PostProcessUber.fxsub"

#if AA_QUALITY == 1
#	include "shader/FXAA3.fxsub"
#endif

#if AA_QUALITY >= 2 && AA_QUALITY <= 5
#	include "shader/SMAA.fxsub"
#endif

#if AA_QUALITY == 6
#	include "shader/CameraMotion.fxsub"
#endif

#if AA_QUALITY == 6
#	include "shader/TAA.fxsub"
#endif

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
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	uniform float2 _MainTex_TexelSize) : POSITION
{
	oTexcoord0.xy = Texcoord + _MainTex_TexelSize * 0.5;
	oTexcoord0.zw = oTexcoord0.xy * ViewportSize;
	oTexcoord1 = -mul(Position, matProjectInverse).xyz;
	return Position;
}

float4 ScreenSpaceQuadPS(
	in float2 uv : TEXCOORD0,
	uniform sampler _MainTex) : COLOR
{
	float4 color = tex2Dlod(_MainTex, float4(uv, 0, 0));
	return color;
}

float Script : STANDARDSGLOBAL<
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

technique DeferredLighting<
	string Script =
	"RenderColorTarget=_CameraColorAttachment;"
	"RenderDepthStencilTarget=_CameraDepthAttachment;"
	"ClearSetColor=BackColor;"
	"ClearSetDepth=ClearDepth;"
	"ClearSetStencil=ClearStencil;"
	"Clear=Color;"
	"Clear=Depth;"
	"ScriptExternal=Color;"

#if SUN_SHADOW_QUALITY && SUN_LIGHT_ENABLE
	"RenderColorTarget=_CameraShadowTexture;"
	"ClearSetColor=WhiteColor;"
	"Clear=Color;"
	"Pass=ScreenSapceShadowMap;"
	"ClearSetColor=BackColor;"
#if SHADOW_BLUR_COUNT
	"RenderColorTarget=_CameraShadowTextureTemp;	Pass=ScreenSpaceShadowBlurX;"
	"RenderColorTarget=_CameraShadowTexture;		Pass=ScreenSpaceShadowBlurY;"
#endif
#endif

#if SSDO_QUALITY && (IBL_QUALITY || SUN_LIGHT_ENABLE)
	"RenderColorTarget=SSDOMap;		Clear=Color; Pass=ScreenSpaceAmbientOcclusion;"
	"RenderColorTarget=SSDOMapTemp; Clear=Color; Pass=ScreenSpaceAmbientOcclusionBlurX;"
	"RenderColorTarget=SSDOMap;	    Clear=Color; Pass=ScreenSpaceAmbientOcclusionBlurY;"
#endif

	"RenderColorTarget0=ShadingMapTemp;"
	"RenderColorTarget1=ShadingMapTempSpecular;"
	"Clear=Color;"
	"Pass=ScreenSpaceOpacityLighting;"
	"RenderColorTarget1=;"

#if SSSS_QUALITY
	"RenderColorTarget=ShadingMap;		Clear=Color; Pass=ScreenSpaceSubsurfaceBlurX;"
	"RenderColorTarget=ShadingMapTemp;	Clear=Color; Pass=ScreenSpaceSubsurfaceBlurY;"
#endif

	"RenderColorTarget=ShadingMap;		Clear=Color; Pass=ScreenSpaceLightingFinal;"

#if SSR_QUALITY
	"RenderColorTarget=SSRLightX1Map;"
	"Clear=Color;"
	"Pass=SSRConeTracing;"

	"RenderColorTarget=SSRLightX1MapTemp; Pass=SSRGaussionBlurX1;"
	"RenderColorTarget=SSRLightX1Map;	  Pass=SSRGaussionBlurY1;"
	"RenderColorTarget=SSRLightX2MapTemp; Pass=SSRGaussionBlurX2;"
	"RenderColorTarget=SSRLightX2Map;	  Pass=SSRGaussionBlurY2;"
	"RenderColorTarget=SSRLightX3MapTemp; Pass=SSRGaussionBlurX3;"
	"RenderColorTarget=SSRLightX3Map;	  Pass=SSRGaussionBlurY3;"
	"RenderColorTarget=SSRLightX4MapTemp; Pass=SSRGaussionBlurX4;"
	"RenderColorTarget=SSRLightX4Map;	  Pass=SSRGaussionBlurY4;"

	"RenderColorTarget=ShadingMap;		  Pass=SSRFinalCombie;"
#endif

#if BOKEH_MODE
	"RenderColorTarget=_CameraFocalDistanceTexture; Clear=Color; Pass=ComputeFocalDistance;"
	"RenderColorTarget=_CameraCoCTexture;			Clear=Color; Pass=ComputeBokehWeight;"
	"RenderColorTarget=_CameraFocalPingTexture;		Clear=Color; Pass=ComputeBokehPrefilter;"
	"RenderColorTarget=_CameraFocalPongTexture; 	Clear=Color; Pass=ComputeBokehBlur;"
	"RenderColorTarget=_CameraFocalPingTexture; 	Clear=Color; Pass=ComputeBilinearBlur;"

	"RenderColorTarget=ShadingMap; Pass=ComputeBokehFinal;"
#endif

#if AA_QUALITY == 1
	"RenderColorTarget=ShadingMapTemp;	Clear=Color; Pass=FXAA;"
	"RenderColorTarget=ShadingMap;		Clear=Color; Pass=Blit;"
#endif

#if AA_QUALITY == 2 || AA_QUALITY == 3
	"RenderColorTarget=_SMAAEdgeMap;	Clear=Color; Pass=SMAAEdgeDetection;"
	"RenderColorTarget=_SMAABlendMap;	Clear=Color; Pass=SMAABlendingWeightCalculation;"
	"RenderColorTarget=ShadingMapTemp;	Clear=Color; Pass=SMAANeighborhoodBlending;"
	"RenderColorTarget=ShadingMap;		Clear=Color; Pass=Blit;"
#endif

#if AA_QUALITY == 4 || AA_QUALITY == 5
	"RenderColorTarget=_SMAAEdgeMap;	Clear=Color; Pass=SMAAEdgeDetection1x;"
	"RenderColorTarget=_SMAABlendMap;	Clear=Color; Pass=SMAABlendingWeightCalculation1x;"
	"RenderColorTarget=ShadingMapTemp;	Clear=Color; Pass=SMAANeighborhoodBlending;"

	"RenderColorTarget=_SMAAEdgeMap;	Clear=Color; Pass=SMAAEdgeDetection2x;"
	"RenderColorTarget=_SMAABlendMap;	Clear=Color; Pass=SMAABlendingWeightCalculation2x;"
	"RenderColorTarget=ShadingMap;		Clear=Color; Pass=SMAANeighborhoodBlendingFinal;"
#endif

#if TOON_ENABLE == 2
	"RenderColorTarget=ShadingMapTemp; 	Pass=DiffusionBlurX;"
	"RenderColorTarget=ShadingMap; 		Pass=DiffusionBlurY;"
#endif

#if EYE_ADAPTATION
	"RenderColorTarget=_EyeLumMap0;		Clear=Color; Pass=EyePrefilter;"
	"RenderColorTarget=_EyeLumMap1;		Clear=Color; Pass=EyeLumDownsample1;"
	"RenderColorTarget=_EyeLumMap2;		Clear=Color; Pass=EyeLumDownsample2;"
	"RenderColorTarget=_EyeLumMap3;		Clear=Color; Pass=EyeLumDownsample3;"
	"RenderColorTarget=_EyeLumMap4;		Clear=Color; Pass=EyeLumDownsample4;"
	"RenderColorTarget=_EyeLumMap5;		Clear=Color; Pass=EyeLumDownsample5;"
	"RenderColorTarget=_EyeLumMap6;		Clear=Color; Pass=EyeLumDownsample6;"
	"RenderColorTarget=_EyeLumMap7;		Clear=Color; Pass=EyeLumDownsample7;"
	"RenderColorTarget=_EyeLumAveMap; 	Pass=EyeAdapation;"
#endif

#if HDR_BLOOM_MODE
	"RenderColorTarget=_BloomDownMap0;  Clear=Color; Pass=BloomPrefilter;"
	"RenderColorTarget=_BloomUpMap1;	Clear=Color; Pass=BloomBlurX1;"
	"RenderColorTarget=_BloomDownMap1;	Clear=Color; Pass=BloomBlurY1;"
	"RenderColorTarget=_BloomUpMap2;	Clear=Color; Pass=BloomBlurX2;"
	"RenderColorTarget=_BloomDownMap2;	Clear=Color; Pass=BloomBlurY2;"
	"RenderColorTarget=_BloomUpMap3;	Clear=Color; Pass=BloomBlurX3;"
	"RenderColorTarget=_BloomDownMap3;	Clear=Color; Pass=BloomBlurY3;"
	"RenderColorTarget=_BloomUpMap4;	Clear=Color; Pass=BloomBlurX4;"
	"RenderColorTarget=_BloomDownMap4;	Clear=Color; Pass=BloomBlurY4;"
	"RenderColorTarget=_BloomUpMap5;	Clear=Color; Pass=BloomBlurX5;"
	"RenderColorTarget=_BloomDownMap5;	Clear=Color; Pass=BloomBlurY5;"
	"RenderColorTarget=_BloomUpMap6;	Clear=Color; Pass=BloomBlurX6;"
	"RenderColorTarget=_BloomDownMap6;	Clear=Color; Pass=BloomBlurY6;"
	"RenderColorTarget=_BloomUpMap7;	Clear=Color; Pass=BloomBlurX7;"
	"RenderColorTarget=_BloomDownMap7;	Clear=Color; Pass=BloomBlurY7;"
	"RenderColorTarget=_BloomUpMap8;	Clear=Color; Pass=BloomBlurX8;"
	"RenderColorTarget=_BloomDownMap8;	Clear=Color; Pass=BloomBlurY8;"
	"RenderColorTarget=_BloomUpMap9;	Clear=Color; Pass=BloomBlurX9;"
	"RenderColorTarget=_BloomDownMap9;	Clear=Color; Pass=BloomBlurY9;"
	"RenderColorTarget=_BloomUpMap8;	Clear=Color; Pass=BloomUpsample9;"
	"RenderColorTarget=_BloomUpMap7;	Clear=Color; Pass=BloomUpsample8;"
	"RenderColorTarget=_BloomUpMap6;	Clear=Color; Pass=BloomUpsample7;"
	"RenderColorTarget=_BloomUpMap5;	Clear=Color; Pass=BloomUpsample6;"
	"RenderColorTarget=_BloomUpMap4;	Clear=Color; Pass=BloomUpsample5;"
	"RenderColorTarget=_BloomUpMap3;	Clear=Color; Pass=BloomUpsample4;"
	"RenderColorTarget=_BloomUpMap2;	Clear=Color; Pass=BloomUpsample3;"
	"RenderColorTarget=_BloomUpMap1;	Clear=Color; Pass=BloomUpsample2;"
	"RenderColorTarget=_BloomUpMap0;	Clear=Color; Pass=BloomUpsample1;"
#if HDR_STAR_MODE || HDR_FLARE_MODE
	"RenderColorTarget=_GlareMap;		Pass=GlarePrefilter;"
#endif
#if HDR_STAR_MODE == 1 || HDR_STAR_MODE == 2
	"RenderColorTarget=_StreakMap1Temp;	Pass=Star1stStreak1;"
	"RenderColorTarget=_StreakMap1;	 	Pass=Star1stStreak2;"
	"RenderColorTarget=_StreakMap1Temp;	Pass=Star1stStreak3;"
	"RenderColorTarget=_StreakMap1;		Pass=Star1stStreak4;"
	"RenderColorTarget=_StreakMap2Temp;	Pass=Star2ndStreak1;"
	"RenderColorTarget=_StreakMap2;		Pass=Star2ndStreak2;"
	"RenderColorTarget=_StreakMap2Temp;	Pass=Star2ndStreak3;"
	"RenderColorTarget=_StreakMap2;		Pass=Star2ndStreak4;"
#endif
#if HDR_STAR_MODE == 3 || HDR_STAR_MODE == 4
	"RenderColorTarget=_StreakMap1;		Pass=Star1stStreak1;"
	"RenderColorTarget=_StreakMap1Temp;	Pass=Star1stStreak2;"
	"RenderColorTarget=_StreakMap1;		Pass=Star1stStreak3;"
	"RenderColorTarget=_StreakMap2;		Pass=Star2ndStreak1;"
	"RenderColorTarget=_StreakMap2Temp;	Pass=Star2ndStreak2;"
	"RenderColorTarget=_StreakMap2;		Pass=Star2ndStreak3;"
	"RenderColorTarget=_StreakMap3;		Pass=Star3rdStreak1;"
	"RenderColorTarget=_StreakMap3Temp;	Pass=Star3rdStreak2;"
	"RenderColorTarget=_StreakMap3;		Pass=Star3rdStreak3;"
	"RenderColorTarget=_StreakMap4;		Pass=Star4thStreak1;"
	"RenderColorTarget=_StreakMap4Temp;	Pass=Star4thStreak2;"
	"RenderColorTarget=_StreakMap4;		Pass=Star4thStreak3;"
#endif
#if HDR_FLARE_MODE
	"RenderColorTarget=_BloomDownMap0;	Pass=GhostImage1;"
	"RenderColorTarget=_BloomUpMap0;	Pass=GhostImage2;"
#endif
#endif

	"RenderColorTarget=;"
	"RenderDepthStencilTarget=;"
	"Pass=PostProcessUber;"
;>
{
#if SUN_LIGHT_ENABLE && SUN_SHADOW_QUALITY
	pass ScreenSapceShadowMap<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ScreenSapceShadowMapPS();
	}
#if SHADOW_BLUR_COUNT
	pass ScreenSpaceShadowBlurX<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 ScreenSapceShadowMapBlurPS(_CameraShadowTexture_PointSampler, float2(ViewportOffset2.x, 0.0f));
	}
	pass ScreenSpaceShadowBlurY<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 ScreenSapceShadowMapBlurPS(_CameraShadowTextureTemp_PointSampler, float2(0.0f, ViewportOffset2.y));
	}
#endif
#endif
#if SSDO_QUALITY && (IBL_QUALITY || SUN_LIGHT_ENABLE)
	pass ScreenSpaceAmbientOcclusion<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceDirOccPassVS();
		PixelShader  = compile ps_3_0 ScreenSpaceDirOccPassPS();
	}
	pass ScreenSpaceAmbientOcclusionBlurX<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ScreenSpaceDirOccBlurPS(SSDOMap_PointSampler, float2(ViewportOffset2.x, 0.0f));
	}
	pass ScreenSpaceAmbientOcclusionBlurY<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ScreenSpaceDirOccBlurPS(SSDOMapTemp_PointSampler, float2(0.0f, ViewportOffset2.y));
	}
#endif
	pass ScreenSpaceOpacityLighting<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceLightingVS();
		PixelShader  = compile ps_3_0 ScreenSpaceOpacityLightingPS();
	}
	pass ScreenSpaceLightingFinal<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceLightingVS();
		PixelShader  = compile ps_3_0 ScreenSpaceLightingFinalPS();
	}
#if SSSS_QUALITY
	pass ScreenSpaceSubsurfaceBlurX<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SSSGaussBlurVS();
		PixelShader  = compile ps_3_0 SSSGaussBlurPS(ShadingMapTempPointSamp, ShadingMapTempPointSamp, float2(1.0, 0.0));
	}
	pass ScreenSpaceSubsurfaceBlurY<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SSSGaussBlurVS();
		PixelShader  = compile ps_3_0 SSSGaussBlurPS(ShadingMapPointSamp, ShadingMapTempPointSamp,float2(0.0, 1.0));
	}
#endif
#if TOON_ENABLE == 2
	pass DiffusionBlurX<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ScreenSpaceBilateralFilterPS(ShadingMapSamp, mDiffusionOffsetX);
	}
	pass DiffusionBlurY<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ScreenSpaceBilateralFilterPS(ShadingMapTempSamp, mDiffusionOffsetY);
	}
#endif
#if SSR_QUALITY
	pass SSRConeTracing<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 SSRConeTracingPS();
	}
	pass SSRGaussionBlurX1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1Samp, SSROffsetX1);
	}
	pass SSRGaussionBlurY1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1SampTemp, SSROffsetY1);
	}
	pass SSRGaussionBlurX2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX1Samp, SSROffsetX2);
	}
	pass SSRGaussionBlurY2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 2);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX2SampTemp, SSROffsetY2);
	}
	pass SSRGaussionBlurX3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 2);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX2Samp, SSROffsetX3);
	}
	pass SSRGaussionBlurY3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 4);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX3SampTemp, SSROffsetY3);
	}
	pass SSRGaussionBlurX4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 4);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX3Samp, SSROffsetX4);
	}
	pass SSRGaussionBlurY4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2.x * 8);
		PixelShader  = compile ps_3_0 SSRGaussionBlurPS(SSRLightX4SampTemp, SSROffsetY4);
	}
	pass SSRFinalCombie<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = INVSRCALPHA;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 SSRFinalCombiePS();
	}
#endif
#if BOKEH_MODE
	pass ComputeFocalDistance<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ComputeFocalDistancePS();
	}
	pass ComputeBokehWeight<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ComputeBokehWeightVS();
		PixelShader  = compile ps_3_0 ComputeBokehWeightPS();
	}
	pass ComputeBokehPrefilter<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 ComputeBokehPrefilterPS(_CamraColorTexture_PointSampler, _CamraColorTexture_TexelSize);
	}
	pass ComputeBokehBlur<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_CameraPingTexture_TexelSize);
		PixelShader  = compile ps_3_0 ComputeBokehBlurPS(_CameraFocalPingTexture_LinearSampler, _CameraPingTexture_TexelSize);
	}
	pass ComputeBilinearBlur<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_CameraPongTexture_TexelSize);
		PixelShader  = compile ps_3_0 ComputeBilinearBlurPS(_CameraFocalPongTexture_LinearSampler, _CameraPongTexture_TexelSize);
	}
	pass ComputeBokehFinal<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_CameraPingTexture_TexelSize);
		PixelShader  = compile ps_3_0 ComputeBokehFinalPS(_CameraFocalPingTexture_LinearSampler, _CameraPingTexture_TexelSize);
	}
#endif
#if AA_QUALITY > 0
	pass Blit<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 ScreenSpaceQuadPS(ShadingMapTempSamp);
	}
#endif
#if AA_QUALITY == 1
	pass FXAA<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 FXAA3(ShadingMapSamp, ViewportOffset2);
	}
#endif
#if AA_QUALITY == 2 || AA_QUALITY == 3
	pass SMAAEdgeDetection<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapPointSamp);
	}
	pass SMAABlendingWeightCalculation<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS(float4(ViewportOffset2, ViewportSize));
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(0, 0, 0, 0), float4(ViewportOffset2, ViewportSize));
	}
	pass SMAANeighborhoodBlending<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapSamp, ViewportOffset2, true);
	}
#endif
#if AA_QUALITY == 4 || AA_QUALITY == 5
	pass SMAAEdgeDetection1x<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapSamp);
	}
	pass SMAABlendingWeightCalculation1x<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS(float4(ViewportOffset2, ViewportSize));
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(1, 1, 1, 0), float4(ViewportOffset2, ViewportSize));
	}
	pass SMAANeighborhoodBlending<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapSamp, ViewportOffset2, false);
	}
	pass SMAAEdgeDetection2x<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAAEdgeDetectionVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAALumaEdgeDetectionPS(ShadingMapTempSamp);
	}
	pass SMAABlendingWeightCalculation2x<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAABlendingWeightCalculationVS(float4(ViewportOffset2, ViewportSize));
		PixelShader  = compile ps_3_0 SMAABlendingWeightCalculationPS(float4(2, 2, 2, 0), float4(ViewportOffset2, ViewportSize));
	}
	pass SMAANeighborhoodBlendingFinal<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 SMAANeighborhoodBlendingVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 SMAANeighborhoodBlendingPS(ShadingMapTempSamp, ViewportOffset2, true);
	}
#endif
#if EYE_ADAPTATION
	pass EyePrefilter<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 EyePrefilterPS(ShadingMapSamp, _EyeLumMap0_TexelSize * 0.5);
	}
	pass EyeLumDownsample1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap0_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap0_PointSampler, _EyeLumMap0_TexelSize);
	}
	pass EyeLumDownsample2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap1_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap1_PointSampler, _EyeLumMap1_TexelSize);
	}
	pass EyeLumDownsample3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap2_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap2_PointSampler, _EyeLumMap2_TexelSize);
	}
	pass EyeLumDownsample4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap3_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap3_PointSampler, _EyeLumMap3_TexelSize);
	}
	pass EyeLumDownsample5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap4_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap4_PointSampler, _EyeLumMap4_TexelSize);
	}
	pass EyeLumDownsample6<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap5_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap5_PointSampler, _EyeLumMap5_TexelSize);
	}
	pass EyeLumDownsample7<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap6_TexelSize);
		PixelShader  = compile ps_3_0 EyeDownsamplePS(_EyeLumMap6_PointSampler, _EyeLumMap6_TexelSize);
	}
	pass EyeAdapation<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_EyeLumMap7_TexelSize);
		PixelShader  = compile ps_3_0 EyeAdapationPS(_EyeLumMap6_PointSampler, _EyeLumMap6_TexelSize);
	}
#endif
#if HDR_BLOOM_MODE
	pass BloomPrefilter<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 BloomPrefilterVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 BloomPrefilterPS(ShadingMapPointSamp);
	}
	pass BloomBlurX1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap0_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap0_LinearSampler, _BloomMap0_TexelSize);
	}
	pass BloomBlurY1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap1_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap1_LinearSampler, _BloomMap1_TexelSize);
	}
	pass BloomBlurX2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap1_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap1_LinearSampler, _BloomMap1_TexelSize);
	}
	pass BloomBlurY2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap2_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap2_LinearSampler, _BloomMap2_TexelSize);
	}
	pass BloomBlurX3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap2_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap2_LinearSampler, _BloomMap2_TexelSize);
	}
	pass BloomBlurY3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap3_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap3_LinearSampler, _BloomMap3_TexelSize);
	}
	pass BloomBlurX4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap3_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap3_LinearSampler, _BloomMap3_TexelSize);
	}
	pass BloomBlurY4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap4_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap4_LinearSampler, _BloomMap4_TexelSize);
	}
	pass BloomBlurX5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap4_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap4_LinearSampler, _BloomMap4_TexelSize);
	}
	pass BloomBlurY5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap5_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap5_LinearSampler, _BloomMap5_TexelSize);
	}
	pass BloomBlurX6<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap5_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap5_LinearSampler, _BloomMap5_TexelSize);
	}
	pass BloomBlurY6<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap6_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap6_LinearSampler, _BloomMap6_TexelSize);
	}
	pass BloomBlurX7<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap6_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap6_LinearSampler, _BloomMap6_TexelSize);
	}
	pass BloomBlurY7<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap7_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap7_LinearSampler, _BloomMap7_TexelSize);
	}
	pass BloomBlurX8<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap7_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap7_LinearSampler, _BloomMap7_TexelSize);
	}
	pass BloomBlurY8<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap8_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap8_LinearSampler, _BloomMap8_TexelSize);
	}
	pass BloomBlurX9<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap8_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomH(_BloomDownMap8_LinearSampler, _BloomMap8_TexelSize);
	}
	pass BloomBlurY9<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(_BloomMap9_TexelSize);
		PixelShader  = compile ps_3_0 GaussianBlurBloomV(_BloomUpMap9_LinearSampler, _BloomMap9_TexelSize);
	}
	pass BloomUpsample9<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(9, _BloomDownMap8_LinearSampler, _BloomMap8_TexelSize, _BloomDownMap9_LinearSampler, _BloomMap9_TexelSize);
	}
	pass BloomUpsample8<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(8, _BloomDownMap7_LinearSampler, _BloomMap7_TexelSize, _BloomUpMap8_LinearSampler, _BloomMap8_TexelSize);
	}
	pass BloomUpsample7<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(7, _BloomDownMap6_LinearSampler, _BloomMap6_TexelSize, _BloomUpMap7_LinearSampler, _BloomMap7_TexelSize);
	}
	pass BloomUpsample6<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(6, _BloomDownMap5_LinearSampler, _BloomMap5_TexelSize, _BloomUpMap6_LinearSampler, _BloomMap6_TexelSize);
	}
	pass BloomUpsample5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(5, _BloomDownMap4_LinearSampler, _BloomMap4_TexelSize, _BloomUpMap5_LinearSampler, _BloomMap5_TexelSize);
	}
	pass BloomUpsample4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(4, _BloomDownMap3_LinearSampler, _BloomMap3_TexelSize, _BloomUpMap4_LinearSampler, _BloomMap4_TexelSize);
	}
	pass BloomUpsample3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(3, _BloomDownMap2_LinearSampler, _BloomMap2_TexelSize, _BloomUpMap3_LinearSampler, _BloomMap3_TexelSize);
	}
	pass BloomUpsample2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(2, _BloomDownMap1_LinearSampler, _BloomMap1_TexelSize, _BloomUpMap2_LinearSampler, _BloomMap2_TexelSize);
	}
	pass BloomUpsample1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
		PixelShader  = compile ps_3_0 UpsampleBloomPS(1, _BloomDownMap0_LinearSampler, _BloomMap0_TexelSize, _BloomUpMap1_LinearSampler, _BloomMap1_TexelSize);
	}
#if HDR_STAR_MODE || HDR_FLARE_MODE
	pass GlarePrefilter<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 GlarePrefilterVS(_BloomMap0_TexelSize);
		PixelShader  = compile ps_3_0 GlarePrefilterPS(_BloomDownMap0_LinearSampler);
	}
#endif
#if HDR_STAR_MODE == 1 || HDR_STAR_MODE == 2
	pass Star1stStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star1stStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap1Temp_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star1stStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap1_LinearSampler, _StarColorCoeff3, 0);
	}
	pass Star1stStreak4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0), 64);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap1Temp_LinearSampler, _StarColorCoeff4, 0);
	}
	pass Star2ndStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star2ndStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap2Temp_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star2ndStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap2_LinearSampler, _StarColorCoeff3, 0);
	}
	pass Star2ndStreak4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0), 64);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap2Temp_LinearSampler, _StarColorCoeff4, 0);
	}
#endif
#if HDR_STAR_MODE == 3 || HDR_STAR_MODE == 4
	pass Star1stStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star1stStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap1_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star1stStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, 0.9), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap1Temp_LinearSampler, _StarColorCoeff3, 0);
	}
	pass Star2ndStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star2ndStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap2_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star2ndStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, 0.9), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap2Temp_LinearSampler, _StarColorCoeff3, 0);
	}
	pass Star3rdStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star3rdStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap3_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star3rdStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(0.9, -0.9), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap3Temp_LinearSampler, _StarColorCoeff3, 0);
	}
	pass Star4thStreak1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 1);
		PixelShader  = compile ps_3_0 StarStreakPS(_GlareMap_LinearSampler, _StarColorCoeff1, mBloomStarFade);
	}
	pass Star4thStreak2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 4);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap4_LinearSampler, _StarColorCoeff2, 0);
	}
	pass Star4thStreak3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 StarStreakVS(float2(-0.9, -0.9), 16);
		PixelShader  = compile ps_3_0 StarStreakPS(_StreakMap4Temp_LinearSampler, _StarColorCoeff3, 0);
	}
#endif
#if HDR_FLARE_MODE
	pass GhostImage1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 GhostImageVS(_GhostScalar1);
		PixelShader  = compile ps_3_0 GhostImagePS(_GlareMap_LinearSampler, _BloomDownMap2_LinearSampler, _BloomDownMap2_LinearSampler, _GhostModulation1, mBloomStarFade);
	}
	pass GhostImage2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = ONE;
		VertexShader = compile vs_3_0 GhostImageVS(_GhostScalar2);
		PixelShader  = compile ps_3_0 GhostImagePS(_BloomDownMap1_LinearSampler, _BloomDownMap1_LinearSampler, _BloomDownMap2_LinearSampler, _GhostModulation2, 0);
	}
#endif
#endif
	pass PostProcessUber<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 PostProcessUberPS(ShadingMapPointSamp);
	}
}