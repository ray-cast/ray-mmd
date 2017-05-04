float time : TIME;

float2 ViewportSize : VIEWPORTPIXELSIZE;

float mBloomRadiusP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomRadius+";>;
float mBloomRadiusM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomRadius-";>;
float mBloomThresholdP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomThreshold";>;
float mBloomColorAllHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColorAllH+";>;
float mBloomColorAllSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColorAllS+";>;
float mBloomColorAllVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColorAllV+";>;
float mBloomColorAllVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColorAllV-";>;
float mBloomColor1stHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor1stH+";>;
float mBloomColor1stSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor1stS+";>;
float mBloomColor1stVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor1stV+";>;
float mBloomColor1stVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor1stV-";>;
float mBloomColor2ndHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor2ndH+";>;
float mBloomColor2ndSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor2ndS+";>;
float mBloomColor2ndVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor2ndV+";>;
float mBloomColor2ndVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor2ndV-";>;
float mBloomColor3rdHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor3rdH+";>;
float mBloomColor3rdSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor3rdS+";>;
float mBloomColor3rdVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor3rdV+";>;
float mBloomColor3rdVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor3rdV-";>;
float mBloomColor4thHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor4thH+";>;
float mBloomColor4thSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor4thS+";>;
float mBloomColor4thVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor4thV+";>;
float mBloomColor4thVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor4thV-";>;
float mBloomColor5thHP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor5thH+";>;
float mBloomColor5thSP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor5thS+";>;
float mBloomColor5thVP : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor5thV+";>;
float mBloomColor5thVM : CONTROLOBJECT<string name="LightBloomController.pmx"; string item = "BloomColor5thV-";>;

static float2 ViewportOffset  = 0.5 / ViewportSize;
static float2 ViewportOffset2 = 1.0 / ViewportSize;
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

static float2 BloomOffset1 = ViewportOffset * 2;
static float2 BloomOffset2 = ViewportOffset * 4;
static float2 BloomOffset3 = ViewportOffset * 8;
static float2 BloomOffset4 = ViewportOffset * 16;
static float2 BloomOffset5 = ViewportOffset * 32;

static const float mBloomIntensityMin = 1.0;
static const float mBloomIntensityMax = 20.0;

static const float2 BloomScale = 512 * float2(ViewportAspect, 1);

static const float2 BloomOffsetX1 = float2( 2 / BloomScale.x, 0.0);
static const float2 BloomOffsetX2 = float2( 4 / BloomScale.x, 0.0);
static const float2 BloomOffsetX3 = float2( 8 / BloomScale.x, 0.0);
static const float2 BloomOffsetX4 = float2(16 / BloomScale.x, 0.0);
static const float2 BloomOffsetX5 = float2(32 / BloomScale.x, 0.0);

static const float2 BloomOffsetY1 = float2(0.0,  2 / BloomScale.y);
static const float2 BloomOffsetY2 = float2(0.0,  4 / BloomScale.y);
static const float2 BloomOffsetY3 = float2(0.0,  8 / BloomScale.y);
static const float2 BloomOffsetY4 = float2(0.0, 16 / BloomScale.y);
static const float2 BloomOffsetY5 = float2(0.0, 32 / BloomScale.y);

static float mBloomThreshold = (1.0 - mBloomThresholdP) / (mBloomThresholdP + 1e-5);
static float mBloomRadius = lerp(lerp(2.0, 10, mBloomRadiusP), 0.1, mBloomRadiusM);

static float3 mBloomColorAll = float3(mBloomColorAllHP, mBloomColorAllSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColorAllVP), 0, mBloomColorAllVM));
static float3 mBloomColor1st = float3(mBloomColor1stHP, mBloomColor1stSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColor1stVP), 0, mBloomColor1stVM));
static float3 mBloomColor2nd = float3(mBloomColor2ndHP, mBloomColor2ndSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColor2ndVP), 0, mBloomColor2ndVM));
static float3 mBloomColor3rd = float3(mBloomColor3rdHP, mBloomColor3rdSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColor3rdVP), 0, mBloomColor3rdVM));
static float3 mBloomColor4th = float3(mBloomColor4thHP, mBloomColor4thSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColor4thVP), 0, mBloomColor4thVM));
static float3 mBloomColor5th = float3(mBloomColor5thHP, mBloomColor5thSP, lerp(lerp(mBloomIntensityMin, mBloomIntensityMax, mBloomColor5thVP), 0, mBloomColor5thVM));

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewportRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "A16B16G16R16F";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = POINT; MagFilter = POINT; MipFilter = NONE;
	AddressU  = CLAMP; AddressV = CLAMP;
};

texture DownsampleMap1st : RENDERCOLORTARGET<float2 ViewportRatio={1.0, 1.0}; string Format="A16B16G16R16F";>;
texture DownsampleMap2nd : RENDERCOLORTARGET<float2 ViewportRatio={0.5, 0.5}; string Format="A16B16G16R16F";>;
texture DownsampleMap3rd : RENDERCOLORTARGET<float2 ViewportRatio={0.25, 0.25}; string Format="A16B16G16R16F";>;

sampler DownsampleSamp1st = sampler_state {
	texture = <DownsampleMap1st>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
sampler DownsampleSamp2nd = sampler_state {
	texture = <DownsampleMap2nd>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
sampler DownsampleSamp3rd = sampler_state {
	texture = <DownsampleMap3rd>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};

texture BloomMap1st : RENDERCOLORTARGET<float2 ViewportRatio={0.50, 0.50}; string Format="A16B16G16R16F";>;
texture BloomMap2nd : RENDERCOLORTARGET<float2 ViewportRatio={0.25, 0.25}; string Format="A16B16G16R16F";>;
texture BloomMap3rd : RENDERCOLORTARGET<float2 ViewportRatio={0.125, 0.125}; string Format="A16B16G16R16F";>;
texture BloomMap4th : RENDERCOLORTARGET<float2 ViewportRatio={0.0625, 0.0625}; string Format="A16B16G16R16F";>;
texture BloomMap5th : RENDERCOLORTARGET<float2 ViewportRatio={0.03125, 0.03125}; string Format="A16B16G16R16F";>;
texture BloomMap1stTemp : RENDERCOLORTARGET<float2 ViewportRatio={0.50, 0.50}; string Format="A16B16G16R16F";>;
texture BloomMap2ndTemp : RENDERCOLORTARGET<float2 ViewportRatio={0.25, 0.25}; string Format="A16B16G16R16F";>;
texture BloomMap3rdTemp : RENDERCOLORTARGET<float2 ViewportRatio={0.125, 0.125}; string Format="A16B16G16R16F";>;
texture BloomMap4thTemp : RENDERCOLORTARGET<float2 ViewportRatio={0.0625, 0.0625}; string Format="A16B16G16R16F";>;
texture BloomMap5thTemp : RENDERCOLORTARGET<float2 ViewportRatio={0.03125, 0.03125}; string Format="A16B16G16R16F";>;

sampler BloomSamp1st = sampler_state {
	texture = <BloomMap1st>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp1stTemp = sampler_state {
	texture = <BloomMap1stTemp>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp2nd = sampler_state {
	texture = <BloomMap2nd>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp2ndTemp = sampler_state {
	texture = <BloomMap2ndTemp>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp3rd = sampler_state {
	texture = <BloomMap3rd>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp3rdTemp = sampler_state {
	texture = <BloomMap3rdTemp>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp4th = sampler_state {
	texture = <BloomMap4th>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp4thTemp = sampler_state {
	texture = <BloomMap4thTemp>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp5th = sampler_state {
	texture = <BloomMap5th>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};
sampler BloomSamp5thTemp = sampler_state {
	texture = <BloomMap5thTemp>;
	MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
	AddressU = BORDER; AddressV = BORDER; BorderColor = 0.0;
};

float3 srgb2linear(float3 rgb)
{
	return pow(rgb, 2.2);
}

float4 srgb2linear(float4 c)
{
	return float4(srgb2linear(c.rgb), c.a);
}

float3 linear2srgb(float3 srgb)
{
	return pow(srgb, 1.0 / 2.2);
}

float4 linear2srgb(float4 c)
{
	return float4(linear2srgb(c.rgb), c.a);
}

float luminance(float3 rgb)
{
	return dot(rgb, float3(0.2126f, 0.7152f, 0.0722f));
}

float3 hsv2rgb(float3 hsv)
{
	float3 rgb = smoothstep(2.0,1.0, abs(fmod(hsv.x*6.0+float3(0,4,2), 6.0) - 3.0));
	return hsv.z * (1.0 - hsv.y * rgb);
}

float3 noise3(float2 seed)
{
	return frac(sin(dot(seed.xy, float2(34.483, 89.637))) * float3(29156.4765, 38273.5639, 47843.7546));
}

float3 ColorBanding(float2 uv)
{
	float3 noise = noise3(uv) + noise3(uv + 0.5789) - 0.5;
	return noise / 255.0;
}

float3 ColorDithering(float3 color, float2 uv)
{
	color += ColorBanding(uv * (time + 3.14));
	return color;
}

float4 TonemapHable(float4 x) 
{
	float A = 0.22;
	float B = 0.30;
	float C = 0.10;
	float D = 0.20;
	float E = 0.01;
	float F = 0.30;
	return ((x*(A*x+C*B)+D*E) / (x*(A*x+B)+D*F)) - E / F;
}

float3 TonemapHableInverseCurve(float3 x) 
{
	float A = 0.22;
	float B = 0.30;
	float C = 0.10;
	float D = 0.20;
	float E = 0.01;
	float F = 0.30;

	float3 q = B*(F*(C-x) - E);
	float3 d = A*(F*(x - 1.0) + E);

	return (q -sqrt(q*q - 4.0*D*F*F*x*d)) / (2.0*d);
}

float3 TonemapHableInverse(float3 color, float range = 8.0)
{
	color *= TonemapHable(range).r;
	return TonemapHableInverseCurve(color);
}

float4 ScreenSpaceQuadOffsetVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD,
	out float2 oTexcoord : TEXCOORD0,
	uniform float2 offset) : POSITION
{
	oTexcoord = Texcoord + offset;
	return Position;
}

void HDRDownsampleVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD,
	out float2 oTexcoord1 : TEXCOORD0,
	out float2 oTexcoord2 : TEXCOORD1,
	out float2 oTexcoord3 : TEXCOORD2,
	out float2 oTexcoord4 : TEXCOORD3,
	out float4 oPosition : POSITION,
	uniform float2 step)
{
	oPosition = Position;
	oTexcoord1 = Texcoord + step * 0.5;
	oTexcoord2 = oTexcoord1 + float2(step.x, 0);
	oTexcoord3 = oTexcoord1 + float2(step.x, step.y);
	oTexcoord4 = oTexcoord1 + float2(0, step.y);
}

float4 HDRDownsample4XPS(
	in float2 coord1 : TEXCOORD0,
	in float2 coord2 : TEXCOORD1,
	in float2 coord3 : TEXCOORD2,
	in float2 coord4 : TEXCOORD3,
	uniform sampler source) : COLOR
{
	float4 color = tex2Dlod(source, float4(coord1, 0, 0));
	color += tex2Dlod(source, float4(coord2, 0, 0));
	color += tex2Dlod(source, float4(coord3, 0, 0));
	color += tex2Dlod(source, float4(coord4, 0, 0));
	return color * 0.25;
}

float4 HDRDownsamplePS(in float2 coord : TEXCOORD0, uniform sampler source) : COLOR
{
	return tex2Dlod(source, float4(coord, 0, 0));
}

float4 GlareDetectionPS(
	in float2 coord : TEXCOORD0,
	uniform sampler source) : COLOR
{
	float3 color = tex2Dlod(source, float4(coord, 0, 0)).rgb;
	color = clamp(color, 0, 65535);

	float lum = luminance(color);
	float3 bloom = clamp(color * saturate((lum - mBloomThreshold) * 0.5), 0, 8);
	bloom *= hsv2rgb(mBloomColorAll);

	return float4(bloom, 0);
}

float4 BloomBlurPS(in float2 coord : TEXCOORD0, uniform sampler source, uniform float2 offset) : COLOR
{
	const float weights[15] = { 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153 };
	const float weightSum = 262106.0;

	float4 color = 0;
	float2 coords = coord - offset * 7.0;

	[unroll]
	for (int i = 0; i < 15; ++i)
	{
		color += tex2Dlod(source, float4(coords, 0, 0)) * (weights[i] / weightSum);
		coords += offset;
	}

	return color;
}

float4 GlareLightCompVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD,
	out float2 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float3 oTexcoord3 : TEXCOORD3,
	out float3 oTexcoord4 : TEXCOORD4,
	out float3 oTexcoord5 : TEXCOORD5) : POSITION
{
	float g1 = exp(-(0 * 0) / (2.0 * mBloomRadius * mBloomRadius));
	float g2 = exp(-(1 * 1) / (2.0 * mBloomRadius * mBloomRadius));
	float g3 = exp(-(2 * 2) / (2.0 * mBloomRadius * mBloomRadius));
	float g4 = exp(-(3 * 3) / (2.0 * mBloomRadius * mBloomRadius));
	float g5 = exp(-(4 * 4) / (2.0 * mBloomRadius * mBloomRadius));
	float weight = g1 + g2 + g3 + g4 + g5;

	oTexcoord0 = Texcoord;
	oTexcoord1 = g1 / weight * hsv2rgb(mBloomColor1st);
	oTexcoord2 = g2 / weight * hsv2rgb(mBloomColor2nd);
	oTexcoord3 = g3 / weight * hsv2rgb(mBloomColor3rd);
	oTexcoord4 = g4 / weight * hsv2rgb(mBloomColor4th);
	oTexcoord5 = g5 / weight * hsv2rgb(mBloomColor5th);

	return Position;
}

float4 GlareLightCompPS(
	in float2 coord1 : TEXCOORD0,
	in float3 coord2 : TEXCOORD1,
	in float3 coord3 : TEXCOORD2,
	in float3 coord4 : TEXCOORD3,
	in float3 coord5 : TEXCOORD4,
	in float3 coord6 : TEXCOORD5) : COLOR
{
	float3 bloom1 = tex2Dlod(BloomSamp1st, float4(coord1 + 0.5 / (ViewportSize * 0.5), 0, 0)).rgb;
	float3 bloom2 = tex2Dlod(BloomSamp2nd, float4(coord1 + 0.5 / (ViewportSize * 0.25), 0, 0)).rgb;
	float3 bloom3 = tex2Dlod(BloomSamp3rd, float4(coord1 + 0.5 / (ViewportSize * 0.125), 0, 0)).rgb;
	float3 bloom4 = tex2Dlod(BloomSamp4th, float4(coord1 + 0.5 / (ViewportSize * 0.0625), 0, 0)).rgb;
	float3 bloom5 = tex2Dlod(BloomSamp5th, float4(coord1 + 0.5 / (ViewportSize * 0.03125), 0, 0)).rgb;

	float3 bloom = 0.0f;
	bloom += bloom1 * coord2;
	bloom += bloom2 * coord3;
	bloom += bloom3 * coord4;
	bloom += bloom4 * coord5;
	bloom += bloom5 * coord6;

	return float4(bloom, 0);
}

float4 HDRInverseVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD,
	out float2 oTexcoord : TEXCOORD0) : POSITION
{
	oTexcoord = Texcoord.xy + ViewportOffset;
	return Position;
}

float4 HDRInversePS(in float4 coord: TEXCOORD0, uniform sampler source) : COLOR
{
	float3 color = tex2Dlod(ScnSamp, float4(coord.xy, 0, 0)).rgb;
	color = srgb2linear(color);
	color = TonemapHableInverse(color, 4.0);

	return float4(color, 1);
}

float4 HDRTonemappingVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD,
	out float2 oTexcoord : TEXCOORD0) : POSITION
{
	oTexcoord = Texcoord.xy + ViewportOffset;
	return Position;
}

float4 HDRTonemappingPS(in float4 coord: TEXCOORD0, uniform sampler source) : COLOR
{
	float3 color = tex2Dlod(ScnSamp, float4(coord.xy, 0, 0)).rgb;
	float3 bloom = tex2Dlod(BloomSamp1st, float4(coord.xy, 0, 0)).rgb;

	float4 curr = TonemapHable(float4(color + bloom, 4.0));
	curr = saturate(curr / curr.w);
	curr = linear2srgb(curr);

	return float4(curr.rgb, 1);
}

float Script : STANDARDSGLOBAL<
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique FimicGrain <
	string Script = 
	"RenderColorTarget0=;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"

	"RenderColorTarget0=ScnMap;"
	"Clear=Color;"
	"Clear=Depth;"
	"RenderDepthStencilTarget=;"
	"ScriptExternal=Color;"

	"RenderColorTarget=ScnMap;	 		 Pass=HDRInverse;"
	"RenderColorTarget=DownsampleMap1st; Pass=GlareDetection;"
	"RenderColorTarget=DownsampleMap2nd; Pass=HDRDownsample1st;"
	"RenderColorTarget=BloomMap1stTemp;  Pass=BloomBlurX1;"
	"RenderColorTarget=BloomMap1st;		 Pass=BloomBlurY1;"
	"RenderColorTarget=BloomMap2nd;		 Pass=BloomDownsampleX2;"
	"RenderColorTarget=BloomMap2ndTemp;  Pass=BloomBlurX2;"
	"RenderColorTarget=BloomMap2nd;		 Pass=BloomBlurY2;"
	"RenderColorTarget=BloomMap3rd;		 Pass=BloomDownsampleX3;"
	"RenderColorTarget=BloomMap3rdTemp;  Pass=BloomBlurX3;"
	"RenderColorTarget=BloomMap3rd;		 Pass=BloomBlurY3;"
	"RenderColorTarget=BloomMap4th;		 Pass=BloomDownsampleX4;"
	"RenderColorTarget=BloomMap4thTemp;  Pass=BloomBlurX4;"
	"RenderColorTarget=BloomMap4th;		 Pass=BloomBlurY4;"
	"RenderColorTarget=BloomMap5th;		 Pass=BloomDownsampleX5;"
	"RenderColorTarget=BloomMap5thTemp;  Pass=BloomBlurX5;"
	"RenderColorTarget=BloomMap5th;		 Pass=BloomBlurY5;"
	"RenderColorTarget=BloomMap1st;		 Pass=GlareLightComp;"
	"RenderColorTarget=;		 		 Pass=HDRTonemapping;"
;> {
	pass HDRInverse<string Script= "Draw=Buffer;";>{
		 AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 HDRInverseVS();
		PixelShader  = compile ps_3_0 HDRInversePS(ScnSamp);
	}
	pass GlareDetection<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(ViewportOffset);
		PixelShader  = compile ps_3_0 GlareDetectionPS(ScnSamp);
	}
	pass HDRDownsample1st<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 HDRDownsampleVS(ViewportOffset2);
		PixelShader  = compile ps_3_0 HDRDownsample4XPS(DownsampleSamp1st);
	}
	pass HDRDownsample2nd<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 HDRDownsampleVS(ViewportOffset2 * 2);
		PixelShader  = compile ps_3_0 HDRDownsample4XPS(DownsampleSamp2nd);
	}
	pass BloomBlurX1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
		PixelShader  = compile ps_3_0 BloomBlurPS(DownsampleSamp2nd, BloomOffsetX1);
	}
	pass BloomBlurY1<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp1stTemp, BloomOffsetY1);
	}
	pass BloomDownsampleX2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset1);
		PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp1st);
	}
	pass BloomBlurX2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2nd, BloomOffsetX2);
	}
	pass BloomBlurY2<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp2ndTemp, BloomOffsetY2);
	}
	pass BloomDownsampleX3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset2);
		PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp2nd);
	}
	pass BloomBlurX3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rd, BloomOffsetX3);
	}
	pass BloomBlurY3<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp3rdTemp, BloomOffsetY3);
	}
	pass BloomDownsampleX4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset3);
		PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp3rd);
	}
	pass BloomBlurX4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset4);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4th, BloomOffsetX4);
	}
	pass BloomBlurY4<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset4);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp4thTemp, BloomOffsetY4);
	}
	pass BloomDownsampleX5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset4);
		PixelShader  = compile ps_3_0 HDRDownsamplePS(BloomSamp4th);
	}
	pass BloomBlurX5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset5);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp5th, BloomOffsetX5);
	}
	pass BloomBlurY5<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 ScreenSpaceQuadOffsetVS(BloomOffset5);
		PixelShader  = compile ps_3_0 BloomBlurPS(BloomSamp5thTemp, BloomOffsetY5);
	}
	pass GlareLightComp<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = SRCALPHA;
		VertexShader = compile vs_3_0 GlareLightCompVS();
		PixelShader  = compile ps_3_0 GlareLightCompPS();
	}
	pass HDRTonemapping<string Script= "Draw=Buffer;";>{
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 HDRTonemappingVS();
		PixelShader  = compile ps_3_0 HDRTonemappingPS(ScnSamp);
	}
}