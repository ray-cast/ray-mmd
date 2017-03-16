#define LUT_SIZE 32
#define LUT_WIDTH 1024
#define LUT_DEBUG_SHOW 1

float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset  = (float2(0.5,0.5) / ViewportSize);
static float2 ViewportOffset2 = (float2(1.0,1.0) / ViewportSize);
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	int MipLevels = 1;
	bool AntiAlias = false;
	string Format = "A16B16G16R16F";
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

float mContrastRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastR+";>;
float mContrastGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastG+";>;
float mContrastBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastB+";>;
float mSaturationRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationR+";>;
float mSaturationGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationG+";>;
float mSaturationBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationB+";>;
float mGammaRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaR+";>;
float mGammaGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaG+";>;
float mGammaBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaB+";>;
float mColorRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorR+";>;
float mColorGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorG+";>;
float mColorBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorB+";>;
float mColorOffsetRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetR+";>;
float mColorOffsetGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetG+";>;
float mColorOffsetBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetB+";>;

float mContrastLowRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastLowR+";>;
float mContrastLowGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastLowG+";>;
float mContrastLowBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastLowB+";>;
float mSaturationLowRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationLowR+";>;
float mSaturationLowGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationLowG+";>;
float mSaturationLowBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationLowB+";>;
float mGammaLowRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaLowR+";>;
float mGammaLowGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaLowG+";>;
float mGammaLowBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaLowB+";>;
float mColorLowRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorLowR+";>;
float mColorLowGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorLowG+";>;
float mColorLowBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorLowB+";>;
float mColorOffsetLowRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetLowR+";>;
float mColorOffsetLowGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetLowG+";>;
float mColorOffsetLowBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetLowB+";>;

float mContrastMidRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastMidR+";>;
float mContrastMidGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastMidG+";>;
float mContrastMidBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastMidB+";>;
float mSaturationMidRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationMidR+";>;
float mSaturationMidGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationMidG+";>;
float mSaturationMidBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationMidB+";>;
float mGammaMidRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaMidR+";>;
float mGammaMidGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaMidG+";>;
float mGammaMidBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaMidB+";>;
float mColorMidRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorMidR+";>;
float mColorMidGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorMidG+";>;
float mColorMidBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorMidB+";>;
float mColorOffsetMidRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetMidR+";>;
float mColorOffsetMidGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetMidG+";>;
float mColorOffsetMidBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetMidB+";>;

float mContrastHighRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastHighR+";>;
float mContrastHighGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastHighG+";>;
float mContrastHighBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ContrastHighB+";>;
float mSaturationHighRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationHighR+";>;
float mSaturationHighGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationHighG+";>;
float mSaturationHighBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "SaturationHighB+";>;
float mGammaHighRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaHighR+";>;
float mGammaHighGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaHighG+";>;
float mGammaHighBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "GammaHighB+";>;
float mColorHighRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorHighR+";>;
float mColorHighGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorHighG+";>;
float mColorHighBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorHighB+";>;
float mColorOffsetHighRP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetHighR+";>;
float mColorOffsetHighGP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetHighG+";>;
float mColorOffsetHighBP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "ColorOffsetHighB+";>;

float mWeightLowP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "WeightLow+";>;
float mWeightLowM : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "WeightLow-";>;
float mWeightHighP : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "WeightHigh+";>;
float mWeightHighM : CONTROLOBJECT<string name="ColorGradingController.pmx"; string item = "WeightHigh-";>;

static float3 mColorContrastP = float3(mContrastRP, mContrastGP, mContrastBP);
static float3 mColorSaturationP = float3(mSaturationRP, mSaturationGP, mSaturationBP);
static float3 mColorGammaP = float3(mGammaRP, mGammaGP, mGammaBP);
static float3 mColorGainP = float3(mColorRP, mColorGP, mColorBP);
static float3 mColorOffsetP = float3(mColorOffsetRP, mColorOffsetGP, mColorOffsetBP);

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

static float4 mColorContrast   = float4(lerp(1.0, 2.0, mColorContrastP), 1);
static float4 mColorSaturation = float4(lerp(1.0, 2.0, mColorSaturationP), 1);
static float4 mColorGamma      = float4(lerp(1.0, 0.45, mColorGammaP), 1);
static float4 mColorGain       = float4(lerp(1.0, 2.0, mColorGainP), 1);
static float4 mColorOffset     = float4(lerp(0.0, 2.0, mColorOffsetP), 1);

static float4 mColorContrastLow   = float4(lerp(1.0, 2.0, mColorContrastLowP), 1);
static float4 mColorSaturationLow = float4(lerp(1.0, 2.0, mColorSaturationLowP), 1);
static float4 mColorGammaLow      = float4(lerp(1.0, 0.45, mColorGammaLowP), 1);
static float4 mColorGainLow       = float4(lerp(1.0, 2.0, mColorGainLowP), 1);
static float4 mColorOffsetLow     = float4(lerp(0.0, 1.0, mColorOffsetLowP), 1);

static float4 mColorContrastMid   = float4(lerp(1.0, 2.0, mColorContrastMidP), 1);
static float4 mColorSaturationMid = float4(lerp(1.0, 2.0, mColorSaturationMidP), 1);
static float4 mColorGammaMid      = float4(lerp(1.0, 0.45, mColorGammaMidP), 1);
static float4 mColorGainMid       = float4(lerp(1.0, 2.0, mColorGainMidP), 1);
static float4 mColorOffsetMid     = float4(lerp(0.0, 2.0, mColorOffsetMidP), 1);

static float4 mColorContrastHigh   = float4(lerp(1.0, 2.0, mColorContrastHighP), 1);
static float4 mColorSaturationHigh = float4(lerp(1.0, 2.0, mColorSaturationHighP), 1);
static float4 mColorGammaHigh      = float4(lerp(1.0, 0.45, mColorGammaHighP), 1);
static float4 mColorGainHigh       = float4(lerp(1.0, 2.0, mColorGainHighP), 1);
static float4 mColorOffsetHigh     = float4(lerp(0.0, 2.0, mColorOffsetHighP), 1);

static float mColorCorrectionLowThreshold  = lerp(lerp(0.5, 1.0, mWeightLowP), 0.0, mWeightLowM);
static float mColorCorrectionHighThreshold = lerp(lerp(0.5, 0.0, mWeightHighP), 1.0, mWeightHighM);

float luminance(float3 rgb)
{
	const float3 lumfact = float3(0.2126f, 0.7152f, 0.0722f);
	return dot(rgb, lumfact);
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
	color = pow(color, colorGamma.rgb * colorGamma.a);
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
	float3 LUTEncodedColor = pow(max(0, color), 2.2);	
	float3 deviceColor = ColorLookupTable2D(ColorGradingLUTSamp, LUTEncodedColor, size).rgb;
	return pow(max(0, deviceColor), 1.0 / 2.2);
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
	color = ColorCorrectAll(
		color,
		mColorSaturation,
		mColorContrast,
		mColorGamma,
		mColorGain,
		mColorOffset,

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

#if LUT_DEBUG_SHOW
	float tileX = LUT_SIZE / 46.0;
	float tileY = 1 - tileX / LUT_SIZE * ViewportAspect;

	if (coord.x <= tileX && coord.y >= tileY)
	{
		coord = float2(coord.x / tileX, (coord.y - tileY) / (1 - tileY));
		return tex2Dlod(ColorGradingLUTSamp, float4(coord, 0, 0));
	}
#endif
	return color;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique MainTech <
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
	;
> {
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