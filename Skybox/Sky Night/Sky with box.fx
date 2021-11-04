#include "Sky with box.conf"
#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/Color.fxsub"

float mEnvRotateX : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateX";>;
float mEnvRotateY : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateY";>;
float mEnvRotateZ : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateZ";>;

#if USE_CUSTOM_PARAMS == 0
float mTopColorHP :  CONTROLOBJECT<string name="(self)"; string item = "TopH+";>;
float mTopColorSP :  CONTROLOBJECT<string name="(self)"; string item = "TopS+";>;
float mTopColorVP :  CONTROLOBJECT<string name="(self)"; string item = "TopV+";>;
float mTopExponentP :  CONTROLOBJECT<string name="(self)"; string item = "TopExponent+";>;
float mTopExponentM :  CONTROLOBJECT<string name="(self)"; string item = "TopExponent-";>;
float mBottomColorHP :  CONTROLOBJECT<string name="(self)"; string item = "BottomH+";>;
float mBottomColorSP :  CONTROLOBJECT<string name="(self)"; string item = "BottomS+";>;
float mBottomColorVP :  CONTROLOBJECT<string name="(self)"; string item = "BottomV+";>;
float mBottomExponentP :  CONTROLOBJECT<string name="(self)"; string item = "BottomExponent+";>;
float mBottomExponentM :  CONTROLOBJECT<string name="(self)"; string item = "BottomExponent-";>;
float mMediumColorHP :  CONTROLOBJECT<string name="(self)"; string item = "MediumH+";>;
float mMediumColorSP :  CONTROLOBJECT<string name="(self)"; string item = "MediumS+";>;
float mMediumColorVP :  CONTROLOBJECT<string name="(self)"; string item = "MediumV+";>;

static const float3 mTopColor    = srgb2linear_fast(hsv2rgb(float3(mTopColorHP, mTopColorSP, mTopColorVP * 2)));
static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(float3(mBottomColorHP, mBottomColorSP, mBottomColorVP * 2)));
static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(float3(mMediumColorHP, mMediumColorSP, mMediumColorVP * 2)));

static const float mTopExponent = lerp(lerp(1, 4, mTopExponentP), 1e-5, mTopExponentM);
static const float mBottomExponent = lerp(lerp(0.5, 4, mBottomExponentP), 1e-5, mBottomExponentM);
#else
#if USE_RGB_COLORSPACE
	static const float3 mTopColor = srgb2linear_fast(TopColor);
	static const float3 mBottomColor = srgb2linear_fast(BottomColor);
	static const float3 mMediumColor = srgb2linear_fast(MediumColor);
#else
	static const float3 mTopColor = srgb2linear_fast(hsv2rgb(TopColor));
	static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(BottomColor));
	static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(MediumColor));
#endif

static const float mTopExponent = TopExponent;
static const float mBottomExponent = BottomExponent;
#endif

static const float3 moonScaling = 2500;
static const float3 moonTranslate = 60000;

static float3x3 matTransform = CreateRotate(float3(mEnvRotateX, mEnvRotateY, mEnvRotateZ) * PI_2);
static float3x3 matTransformMoon = CreateRotate(float3(0.0, 0.0, time / 50));

texture MoonMap<string ResourceName = "Textures/moon.jpg";>;
sampler MoonMapSamp = sampler_state
{
	texture = <MoonMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

float ComputeStarNoise(float3 p3)
{
    p3 = frac(p3 * float3(0.1031,0.11369,0.13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z);
}

float CreateStars(float3 viewdir, float starDistance, float starDencity, float starBrigtness, float starBlink)
{
    float3 p = viewdir * starDistance;
    float brigtness = smoothstep(1.0 - starDencity, 1.0, ComputeStarNoise(floor(p)));
    float blink = saturate(SmoothTriangleWave(brigtness * starBlink));
    return smoothstep(starBrigtness, 0, length(frac(p) - 0.5)) * brigtness * blink;
}

void MoonVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oTexcoord1 : TEXCOORD1,
	out float4 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION,
	uniform float3 translate, uniform float3 scale)
{
	oTexcoord0 = Texcoord;
	oTexcoord1 = float4(mul(normalize(Position).xyz, matTransformMoon), 1);
	oTexcoord2 = float4(oTexcoord1.xyz * scale * 1 - SunDirection * translate, 1);
	oPosition = mul(oTexcoord2, matViewProject);
}

float4 MoonPS(
	in float2 coord : TEXCOORD0,
	in float3 normal : TEXCOORD1,
	in float3 viewdir : TEXCOORD2,
	uniform sampler source) : COLOR
{
	float3 V = normalize(viewdir - CameraPosition);
	float4 diffuse = tex2D(source, coord + float2(0.4, 0.0));
	diffuse *= saturate(dot(normalize(normal), -SunDirection) + 0.1) * 1.5;	
	return diffuse;
}

void SkyboxVS(
	in float4 Position   : POSITION,
	out float3 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position);
	oTexcoord1 = normalize(CameraPosition - Position.xyz);
	oPosition = mul(Position, matViewProject);
}

float4 SkyboxPS(in float3 normal : TEXCOORD0, in float3 viewdir : TEXCOORD0) : COLOR
{
  	float3 V = mul(matTransform, normalize(viewdir));

  	float3 color = 0;
  	color = lerp(mMediumColor, mTopColor, pow(max(0, V.y), mTopExponent));
  	color = lerp(color, mBottomColor, pow(max(0, -V.y), mBottomExponent));

	float starBlink = 0.25;
	float starDencity = 0.02;
	float starDistance = 300;
	float starBrightness = 0.3;
  	float3 stars1 = CreateStars(viewdir, starDistance, starDencity, starBrightness, starBlink * time + PI);

  	float kelvin = clamp(dot(viewdir, SunDirection) * viewdir.y, 0.05, 1) * 50000;
  	color += stars1 * ColorTemperature(float3(1.0, 1.0, 1.0), kelvin)*5;
  	
	return float4(linear2srgb(color), 1);
}

const float4 ClearColor = 0.0;

#define OBJECT_TEC(name, mmdpass)\
	technique name<string MMDPass = mmdpass;\
	> {\
		pass DrawObject {\
			AlphaTestEnable = FALSE; AlphaBlendEnable = FALSE;\
			VertexShader = compile vs_3_0 SkyboxVS();\
			PixelShader  = compile ps_3_0 SkyboxPS();\
		}\
		pass DrawMoon { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = ONE; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 MoonVS(moonTranslate, moonScaling); \
			PixelShader  = compile ps_3_0 MoonPS(MoonMapSamp); \
		} \
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTec1, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ShadowTec<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}