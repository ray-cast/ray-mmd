#define LUT_SIZE 32
#define LUT_WIDTH 1024

float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset  = (float2(0.5,0.5) / ViewportSize);
static float2 ViewportOffset2 = (float2(1.0,1.0) / ViewportSize);
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	int MipLevels = 1;
	bool AntiAlias = false;
	string Format = "A2B10G10R10";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = POINT; MagFilter = POINT; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
texture ColorGradingLUT : RENDERCOLORTARGET<
	int2 Dimensions = {LUT_WIDTH, LUT_SIZE};
	int MipLevels = 1;
	bool AntiAlias = false;
	string Format = "A2B10G10R10";
>;
sampler ColorGradingLUTSamp = sampler_state {
	texture = <ColorGradingLUT>;
	MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};

float mContrastAllRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastAllR+";>;
float mContrastAllGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastAllG+";>;
float mContrastAllBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastAllB+";>;
float mSaturationAllRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationAllR+";>;
float mSaturationAllGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationAllG+";>;
float mSaturationAllBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationAllB+";>;
float mGammaAllRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaAllR+";>;
float mGammaAllGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaAllG+";>;
float mGammaAllBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaAllB+";>;
float mColorAllRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorAllR+";>;
float mColorAllGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorAllG+";>;
float mColorAllBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorAllB+";>;
float mColorOffsetAllRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetAllR+";>;
float mColorOffsetAllGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetAllG+";>;
float mColorOffsetAllBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetAllB+";>;

float mContrastLowRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastLowR+";>;
float mContrastLowGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastLowG+";>;
float mContrastLowBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastLowB+";>;
float mSaturationLowRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationLowR+";>;
float mSaturationLowGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationLowG+";>;
float mSaturationLowBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationLowB+";>;
float mGammaLowRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaLowR+";>;
float mGammaLowGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaLowG+";>;
float mGammaLowBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaLowB+";>;
float mColorLowRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorLowR+";>;
float mColorLowGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorLowG+";>;
float mColorLowBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorLowB+";>;
float mColorOffsetLowRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetLowR+";>;
float mColorOffsetLowGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetLowG+";>;
float mColorOffsetLowBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetLowB+";>;

float mContrastMidRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastMidR+";>;
float mContrastMidGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastMidG+";>;
float mContrastMidBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastMidB+";>;
float mSaturationMidRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationMidR+";>;
float mSaturationMidGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationMidG+";>;
float mSaturationMidBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationMidB+";>;
float mGammaMidRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaMidR+";>;
float mGammaMidGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaMidG+";>;
float mGammaMidBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaMidB+";>;
float mColorMidRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorMidR+";>;
float mColorMidGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorMidG+";>;
float mColorMidBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorMidB+";>;
float mColorOffsetMidRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetMidR+";>;
float mColorOffsetMidGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetMidG+";>;
float mColorOffsetMidBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetMidB+";>;

float mContrastHighRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastHighR+";>;
float mContrastHighGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastHighG+";>;
float mContrastHighBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ContrastHighB+";>;
float mSaturationHighRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationHighR+";>;
float mSaturationHighGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationHighG+";>;
float mSaturationHighBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "SaturationHighB+";>;
float mGammaHighRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaHighR+";>;
float mGammaHighGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaHighG+";>;
float mGammaHighBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "GammaHighB+";>;
float mColorHighRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorHighR+";>;
float mColorHighGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorHighG+";>;
float mColorHighBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorHighB+";>;
float mColorOffsetHighRP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetHighR+";>;
float mColorOffsetHighGP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetHighG+";>;
float mColorOffsetHighBP : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "ColorOffsetHighB+";>;

float mContrastAllRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastAllR-";>;
float mContrastAllGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastAllG-";>;
float mContrastAllBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastAllB-";>;
float mSaturationAllRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationAllR-";>;
float mSaturationAllGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationAllG-";>;
float mSaturationAllBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationAllB-";>;
float mGammaAllRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaAllR-";>;
float mGammaAllGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaAllG-";>;
float mGammaAllBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaAllB-";>;
float mColorAllRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorAllR-";>;
float mColorAllGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorAllG-";>;
float mColorAllBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorAllB-";>;
float mColorOffsetAllRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetAllR-";>;
float mColorOffsetAllGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetAllG-";>;
float mColorOffsetAllBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetAllB-";>;

float mContrastLowRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastLowR-";>;
float mContrastLowGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastLowG-";>;
float mContrastLowBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastLowB-";>;
float mSaturationLowRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationLowR-";>;
float mSaturationLowGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationLowG-";>;
float mSaturationLowBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationLowB-";>;
float mGammaLowRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaLowR-";>;
float mGammaLowGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaLowG-";>;
float mGammaLowBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaLowB-";>;
float mColorLowRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorLowR-";>;
float mColorLowGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorLowG-";>;
float mColorLowBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorLowB-";>;
float mColorOffsetLowRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetLowR-";>;
float mColorOffsetLowGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetLowG-";>;
float mColorOffsetLowBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetLowB-";>;

float mContrastMidRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastMidR-";>;
float mContrastMidGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastMidG-";>;
float mContrastMidBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastMidB-";>;
float mSaturationMidRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationMidR-";>;
float mSaturationMidGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationMidG-";>;
float mSaturationMidBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationMidB-";>;
float mGammaMidRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaMidR-";>;
float mGammaMidGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaMidG-";>;
float mGammaMidBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaMidB-";>;
float mColorMidRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorMidR-";>;
float mColorMidGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorMidG-";>;
float mColorMidBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorMidB-";>;
float mColorOffsetMidRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetMidR-";>;
float mColorOffsetMidGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetMidG-";>;
float mColorOffsetMidBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetMidB-";>;

float mContrastHighRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastHighR-";>;
float mContrastHighGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastHighG-";>;
float mContrastHighBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ContrastHighB-";>;
float mSaturationHighRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationHighR-";>;
float mSaturationHighGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationHighG-";>;
float mSaturationHighBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "SaturationHighB-";>;
float mGammaHighRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaHighR-";>;
float mGammaHighGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaHighG-";>;
float mGammaHighBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "GammaHighB-";>;
float mColorHighRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorHighR-";>;
float mColorHighGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorHighG-";>;
float mColorHighBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorHighB-";>;
float mColorOffsetHighRM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetHighR-";>;
float mColorOffsetHighGM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetHighG-";>;
float mColorOffsetHighBM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "ColorOffsetHighB-";>;

float mWeightLowP : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "WeightLow+";>;
float mWeightLowM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "WeightLow-";>;
float mWeightHighP : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "WeightHigh+";>;
float mWeightHighM : CONTROLOBJECT<string name="ColorGradingControllerMinus.pmx"; string item = "WeightHigh-";>;

float mVisualizationLUT : CONTROLOBJECT<string name="ColorGradingControllerPlus.pmx"; string item = "VisualizationLUT";>;

static float3 mColorContrastAllP = float3(mContrastAllRP, mContrastAllGP, mContrastAllBP);
static float3 mColorSaturationAllP = float3(mSaturationAllRP, mSaturationAllGP, mSaturationAllBP);
static float3 mColorGammaAllP = float3(mGammaAllRP, mGammaAllGP, mGammaAllBP);
static float3 mColorGainAllP = float3(mColorAllRP, mColorAllGP, mColorAllBP);
static float3 mColorOffsetAllP = float3(mColorOffsetAllRP, mColorOffsetAllGP, mColorOffsetAllBP);

static float3 mColorContrastLowP = float3(mContrastLowRP, mContrastLowGP, mContrastLowBP);
static float3 mColorSaturationLowP = float3(mSaturationLowRP, mSaturationLowGP, mSaturationLowBP);
static float3 mColorGammaLowP = float3(mGammaLowRP, mGammaLowGP, mGammaLowBP);
static float3 mColorGainLowP = float3(mColorLowRP, mColorLowGP, mColorLowBP);
static float3 mColorOffsetLowP = float3(mColorOffsetLowRP, mColorOffsetLowGP, mColorOffsetLowBP);

static float3 mColorContrastMidP = float3(mContrastMidRP, mContrastMidGP, mContrastMidBP);
static float3 mColorSaturationMidP = float3(mSaturationMidRP, mSaturationMidGP, mSaturationMidBP);
static float3 mColorGammaMidP = float3(mGammaMidRP, mGammaMidGP, mGammaMidBP);
static float3 mColorGainMidP = float3(mColorMidRP, mColorMidGP, mColorMidBP);
static float3 mColorOffsetMidP = float3(mColorOffsetMidRP, mColorOffsetMidGP, mColorOffsetMidBP);

static float3 mColorContrastHighP = float3(mContrastHighRP, mContrastHighGP, mContrastHighBP);
static float3 mColorSaturationHighP = float3(mSaturationHighRP, mSaturationHighGP, mSaturationHighBP);
static float3 mColorGammaHighP = float3(mGammaHighRP, mGammaHighGP, mGammaHighBP);
static float3 mColorGainHighP = float3(mColorHighRP, mColorHighGP, mColorHighBP);
static float3 mColorOffsetHighP = float3(mColorOffsetHighRP, mColorOffsetHighGP, mColorOffsetHighBP);

static float3 mColorContrastAllM = float3(mContrastAllRM, mContrastAllGM, mContrastAllBM);
static float3 mColorSaturationAllM = float3(mSaturationAllRM, mSaturationAllGM, mSaturationAllBM);
static float3 mColorGammaAllM = float3(mGammaAllRM, mGammaAllGM, mGammaAllBM);
static float3 mColorGainAllM = float3(mColorAllRM, mColorAllGM, mColorAllBM);
static float3 mColorOffsetAllM = float3(mColorOffsetAllRM, mColorOffsetAllGM, mColorOffsetAllBM);

static float3 mColorContrastLowM = float3(mContrastLowRM, mContrastLowGM, mContrastLowBM);
static float3 mColorSaturationLowM = float3(mSaturationLowRM, mSaturationLowGM, mSaturationLowBM);
static float3 mColorGammaLowM = float3(mGammaLowRM, mGammaLowGM, mGammaLowBM);
static float3 mColorGainLowM = float3(mColorLowRM, mColorLowGM, mColorLowBM);
static float3 mColorOffsetLowM = float3(mColorOffsetLowRM, mColorOffsetLowGM, mColorOffsetLowBM);

static float3 mColorContrastMidM = float3(mContrastMidRM, mContrastMidGM, mContrastMidBM);
static float3 mColorSaturationMidM = float3(mSaturationMidRM, mSaturationMidGM, mSaturationMidBM);
static float3 mColorGammaMidM = float3(mGammaMidRM, mGammaMidGM, mGammaMidBM);
static float3 mColorGainMidM = float3(mColorMidRM, mColorMidGM, mColorMidBM);
static float3 mColorOffsetMidM = float3(mColorOffsetMidRM, mColorOffsetMidGM, mColorOffsetMidBM);

static float3 mColorContrastHighM = float3(mContrastHighRM, mContrastHighGM, mContrastHighBM);
static float3 mColorSaturationHighM = float3(mSaturationHighRM, mSaturationHighGM, mSaturationHighBM);
static float3 mColorGammaHighM = float3(mGammaHighRM, mGammaHighGM, mGammaHighBM);
static float3 mColorGainHighM = float3(mColorHighRM, mColorHighGM, mColorHighBM);
static float3 mColorOffsetHighM = float3(mColorOffsetHighRM, mColorOffsetHighGM, mColorOffsetHighBM);

static float4 mColorContrastAll   = float4(lerp(lerp(1.0, 2.0, mColorContrastAllP), 0, mColorContrastAllM), 1);
static float4 mColorSaturationAll = float4(lerp(lerp(1.0, 2.0, mColorSaturationAllP), 0, mColorSaturationAllM), 1);
static float4 mColorGammaAll      = float4(lerp(lerp(1.0, 2.0, mColorGammaAllP), 0, mColorGammaAllM), 1);
static float4 mColorGainAll       = float4(lerp(lerp(1.0, 2.0, mColorGainAllP), 0, mColorGainAllM), 1);
static float4 mColorOffsetAll     = float4(lerp(lerp(0.0, 2.0, mColorOffsetAllP), 0, mColorOffsetAllM), 1);

static float4 mColorContrastLow   = float4(lerp(lerp(1.0, 2.0, mColorContrastLowP), 0, mColorContrastLowM), 1);
static float4 mColorSaturationLow = float4(lerp(lerp(1.0, 2.0, mColorSaturationLowP), 0, mColorSaturationLowM), 1);
static float4 mColorGammaLow      = float4(lerp(lerp(1.0, 2.0, mColorGammaLowP), 0, mColorGammaLowM), 1);
static float4 mColorGainLow       = float4(lerp(lerp(1.0, 2.0, mColorGainLowP), 0, mColorGainLowM), 1);
static float4 mColorOffsetLow     = float4(lerp(lerp(0.0, 1.0, mColorOffsetLowP), 0, mColorOffsetLowM), 1);

static float4 mColorContrastMid   = float4(lerp(lerp(1.0, 2.0, mColorContrastMidP), 0, mColorContrastMidM), 1);
static float4 mColorSaturationMid = float4(lerp(lerp(1.0, 2.0, mColorSaturationMidP), 0, mColorSaturationMidM), 1);
static float4 mColorGammaMid      = float4(lerp(lerp(1.0, 2.0, mColorGammaMidP), 0, mColorGammaMidM), 1);
static float4 mColorGainMid       = float4(lerp(lerp(1.0, 2.0, mColorGainMidP), 0, mColorGainMidM), 1);
static float4 mColorOffsetMid     = float4(lerp(lerp(0.0, 2.0, mColorOffsetMidP), 0, mColorOffsetMidM), 1);

static float4 mColorContrastHigh   = float4(lerp(lerp(1.0, 2.0, mColorContrastHighP), 0, mColorContrastHighM), 1);
static float4 mColorSaturationHigh = float4(lerp(lerp(1.0, 2.0, mColorSaturationHighP), 0, mColorSaturationHighM), 1);
static float4 mColorGammaHigh      = float4(lerp(lerp(1.0, 2.0, mColorGammaHighP), 0, mColorGammaHighM), 1);
static float4 mColorGainHigh       = float4(lerp(lerp(1.0, 2.0, mColorGainHighP), 0, mColorGainHighM), 1);
static float4 mColorOffsetHigh     = float4(lerp(lerp(0.0, 2.0, mColorOffsetHighP), 0, mColorOffsetHighM), 1);

static float mColorCorrectionLowThreshold  = lerp(lerp(0.25, 1.0, mWeightLowP) , 0.0, mWeightLowM);
static float mColorCorrectionHighThreshold = lerp(lerp(0.75, 0.0, mWeightHighP), 1.0, mWeightHighM);

const float A = 0.22;
const float B = 0.3;
const float C = 0.1;
const float D = 0.20;
const float E = 0.01;
const float F = 0.30;

float3 inverse_filmic_curve(float3 x) 
{
	float3 q = B*(F*(C-x) - E);
	float3 d = A*(F*(x - 1.0) + E);
	return (q -sqrt(q*q - 4.0*D*F*F*x*d)) / (2.0*d);
}

float filmic_curve(float x) 
{
	return ((x*(A*x+C*B)+D*E) / (x*(A*x+B)+D*F)) - E / F;
}

float4 filmic_curve(float4 x) 
{
	return ((x*(A*x+C*B)+D*E) / (x*(A*x+B)+D*F)) - E / F;
}

float3 filmic(float3 color, float range = 8.0)
{
	float4 curr = filmic_curve(float4(color, range));
	curr = curr / curr.w;
	return curr.rgb;
}

float3 inverse_filmic(float3 color, float range = 8.0)
{
	color *= filmic_curve(range);
	return inverse_filmic_curve(color);
}

float luminance(float3 rgb)
{
	const float3 lumfact = float3(0.2126f, 0.7152f, 0.0722f);
	return dot(rgb, lumfact);
}

float3 srgb2linear(float3 rgb)
{
	rgb = max(6.10352e-5, rgb);
	return rgb < 0.04045f ? rgb * (1.0 / 12.92) : pow(rgb * (1.0 / 1.055) + 0.0521327, 2.4);
}

float3 linear2srgb(float3 srgb)
{
	srgb = max(6.10352e-5, srgb);
	return min(srgb * 12.92, pow(max(srgb, 0.00313067), 1.0/2.4) * 1.055 - 0.055);
}

float3 ColorCorrect(
	float3 color, 
	float4 colorContrast, 
	float4 colorSaturation, 
	float4 colorGamma, 
	float4 colorGainP,
	float4 colorGainM)
{
	float3 lum = luminance(color);
	color = max(0, lerp(lum, color, colorSaturation.rgb * colorSaturation.a));
	color = pow(color * (1.0 / 0.18), colorContrast.rgb * colorContrast.a) * 0.18;
	color = pow(color, 1.0 / colorGamma.rgb * colorGamma.a);
	color = color * (colorGainP.rgb * colorGainP.a + colorGainM.rgb * colorGainM.a);
	return color;
}

float3 ColorCorrectAll(
	float3 color,
	float4 colorSaturation,
	float4 colorContrast,
	float4 colorGamma,
	float4 colorGain,
	float4 colorOffset,

	float4 colorSaturationShadows,
	float4 colorContrastShadows,
	float4 colorGammaShadows,
	float4 colorGainShadows,
	float4 colorOffsetShadows,

	float4 colorSaturationMidtones,
	float4 colorContrastMidtones,
	float4 colorGammaMidtones,
	float4 colorGainMidtones,
	float4 colorOffsetMidtones,

	float4 colorSaturationHighlights,
	float4 colorContrastHighlights,
	float4 colorGammaHighlights,
	float4 colorGainHighlights,
	float4 colorOffsetHighlights,

	float colorCorrectionShadowsMax,
	float colorCorrectionHighlightsMin)
{
	float3 colorShadows = ColorCorrect(color, 
		colorSaturationShadows*colorSaturation, 
		colorContrastShadows*colorContrast, 
		colorGammaShadows*colorGamma, 
		colorGainShadows*colorGain, 
		colorOffsetShadows+colorOffset);

	float3 colorHighlights = ColorCorrect(color, 
		colorSaturationHighlights*colorSaturation, 
		colorContrastHighlights*colorContrast, 
		colorGammaHighlights*colorGamma, 
		colorGainHighlights*colorGain, 
		colorOffsetHighlights+colorOffset);

	float3 colorMidtones = ColorCorrect(color, 
		colorSaturationMidtones*colorSaturation, 
		colorContrastMidtones*colorContrast, 
		colorGammaMidtones*colorGamma, 
		colorGainMidtones*colorGain, 
		colorOffsetMidtones+colorOffset);

	float weightLuma = luminance(color);
	float weightShadows = 1 - smoothstep(0, colorCorrectionShadowsMax, weightLuma);
	float weightHighlights = smoothstep(colorCorrectionHighlightsMin, 1, weightLuma);
	float weightMidtones = 1 - weightShadows - weightHighlights;

	colorShadows *= weightShadows;
	colorMidtones *= weightMidtones;
	colorHighlights *= weightHighlights;

	float3 blend = colorShadows + colorMidtones + colorHighlights;
	return blend;
}

float3 CreateColorSpectrum(float2 coord, float size = LUT_SIZE)
{
	float3 rgb;
	rgb.r = frac(coord.x * size);
	rgb.b = coord.x - rgb.r / size;
	rgb.g = coord.y;
	return rgb * size / (size - 1);
}

float3 CreateColorSpectrumDebug(float3 color, sampler sourceLUT, float2 coord, float ratio, float alpha, float size = LUT_SIZE)
{
	float tileX = size / 46.0;
	float tileY = 1 - tileX / size * ratio;

	if (coord.x <= tileX && coord.y >= tileY)
	{
		coord = float2(coord.x / tileX, (coord.y - tileY) / (1 - tileY));
		color = lerp(color, tex2Dlod(sourceLUT, float4(coord, 0, 0)).rgb, alpha);
	}

	return color;
}

float4 ColorLookupTable2D(sampler lut, float3 color, float size = LUT_SIZE)
{
	color = color * ((size - 1) / size) + (0.5f / size);

	float slice = color.z * size - 0.5;
	float s = frac(slice);
	slice -= s;

	float u = (color.x + slice) / size;
	float v = color.y;

	float2 uv0 = float2(u, v);
	float2 uv1 = float2(u + 1.0f / size, v);

	float4 col0 = tex2Dlod(lut, float4(uv0, 0, 0));
	float4 col1 = tex2Dlod(lut, float4(uv1, 0, 0));

	return lerp(col0, col1, s);
}

float3 ColorLookupTable(float3 color, float size = LUT_SIZE)
{
	float3 LUTEncodedColor = srgb2linear(color);	
	float3 deviceColor = ColorLookupTable2D(ColorGradingLUTSamp, LUTEncodedColor, size).rgb;
	return linear2srgb(deviceColor);
}

void GenerateColorVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord;
	oTexcoord.zw = Texcoord.xy * ViewportSize;
	oPosition = Position;
}

float4 GenerateColorPS(in float2 coord : TEXCOORD0) : COLOR 
{
	float3 color = CreateColorSpectrum(coord.xy, LUT_SIZE);
	color = inverse_filmic(color);
	color = ColorCorrectAll(
		color,
		mColorSaturationAll,
		mColorContrastAll,
		mColorGammaAll,
		mColorGainAll,
		mColorOffsetAll,

		mColorSaturationLow,
		mColorContrastLow,
		mColorGammaLow,
		mColorGainLow,
		mColorOffsetLow,

		mColorSaturationMid,
		mColorContrastMid,
		mColorGammaMid,
		mColorGainMid,
		mColorOffsetMid,

		mColorSaturationHigh,
		mColorContrastHigh,
		mColorGammaHigh,
		mColorGainHigh,
		mColorOffsetHigh,

		mColorCorrectionLowThreshold,
		mColorCorrectionHighThreshold);
	color = filmic(color);
	return float4(color, 0);
}

void ColorGradingVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord;
	oTexcoord.zw = Texcoord.xy * ViewportSize;
	oTexcoord.xy += ViewportOffset.xy;
	oPosition = Position;
}

float4 ColorGradingPS(in float2 coord : TEXCOORD0, in float4 screenPosition : SV_Position) : COLOR 
{
	float4 color = tex2Dlod(ScnSamp, float4(coord, 0, 0));
	color.rgb = ColorLookupTable(color.rgb);
	color.rgb = CreateColorSpectrumDebug(color.rgb, ColorGradingLUTSamp, coord, ViewportAspect, mVisualizationLUT);
	return color;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique MainTech<
	string Script = 
	"RenderColorTarget0=ScnMap;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"
	"Clear=Color;"
	"Clear=Depth;"
	"ScriptExternal=Color;"

	"RenderColorTarget=ColorGradingLUT;"
	"RenderDepthStencilTarget=;"
	"Pass=ColorGenerate;"

	"RenderColorTarget=;"
	"RenderDepthStencilTarget=;"
	"Pass=ColorGrading;"
;>{
	pass ColorGenerate < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = False; ZWriteEnable = False;
		VertexShader = compile vs_3_0 GenerateColorVS();
		PixelShader  = compile ps_3_0 GenerateColorPS();
	}
	pass ColorGrading < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = False; ZWriteEnable = False;
		VertexShader = compile vs_3_0 ColorGradingVS();
		PixelShader  = compile ps_3_0 ColorGradingPS();
	}
}