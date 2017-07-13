#include "skybox.conf"
#include "../../../shader/math.fxsub"
#include "../../../shader/common.fxsub"

float mEnvRotateX : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateX";>;
float mEnvRotateY : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateY";>;
float mEnvRotateZ : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateZ";>;

#if USE_CUSTOM_PARAMS == 0
float mTopColorHP :  CONTROLOBJECT<string name="(self)"; string item = "TopH+";>;
float mTopColorSP :  CONTROLOBJECT<string name="(self)"; string item = "TopS+";>;
float mTopColorVP :  CONTROLOBJECT<string name="(self)"; string item = "TopV+";>;
float mTopColorVM :  CONTROLOBJECT<string name="(self)"; string item = "TopV-";>;
float mTopExponentP :  CONTROLOBJECT<string name="(self)"; string item = "TopExponent+";>;
float mTopExponentM :  CONTROLOBJECT<string name="(self)"; string item = "TopExponent-";>;
float mBottomColorHP :  CONTROLOBJECT<string name="(self)"; string item = "BottomH+";>;
float mBottomColorSP :  CONTROLOBJECT<string name="(self)"; string item = "BottomS+";>;
float mBottomColorVP :  CONTROLOBJECT<string name="(self)"; string item = "BottomV+";>;
float mBottomColorVM :  CONTROLOBJECT<string name="(self)"; string item = "BottomV-";>;
float mBottomExponentP :  CONTROLOBJECT<string name="(self)"; string item = "BottomExponent+";>;
float mBottomExponentM :  CONTROLOBJECT<string name="(self)"; string item = "BottomExponent-";>;
float mMediumColorHP :  CONTROLOBJECT<string name="(self)"; string item = "MediumH+";>;
float mMediumColorSP :  CONTROLOBJECT<string name="(self)"; string item = "MediumS+";>;
float mMediumColorVP :  CONTROLOBJECT<string name="(self)"; string item = "MediumV+";>;
float mMediumColorVM :  CONTROLOBJECT<string name="(self)"; string item = "MediumV-";>;

static const float3 mTopColor    = srgb2linear_fast(hsv2rgb(float3(mTopColorHP, mTopColorSP, lerp(lerp(1, 2, mTopColorVP), 0, mTopColorVM))));
static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(float3(mBottomColorHP, mBottomColorSP, lerp(lerp(1, 2, mBottomColorVP), 0, mBottomColorVM))));
static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(float3(mMediumColorHP, mMediumColorSP, lerp(lerp(1, 2, mMediumColorVP), 0, mMediumColorVM))));

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

static float3x3 matTransform = CreateRotate(float3(mEnvRotateX, mEnvRotateY, mEnvRotateZ) * PI_2);

void SkyboxVS(
	in float4 Position   : POSITION,
	out float4 oTexcoord : TEXCOORD0,
	out float4 oPosition : POSITION)
{
	oTexcoord = normalize(Position);
	oPosition = mul(Position, matViewProject);
}

float4 SkyboxPS(in float3 viewdir : TEXCOORD0) : COLOR
{
  	float3 V = mul(matTransform, normalize(viewdir));

  	float3 color = 0;
  	color = lerp(mMediumColor, mTopColor, pow(max(0, V.y), mTopExponent));
  	color = lerp(color, mBottomColor, pow(max(0, -V.y), mBottomExponent));
  	
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
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTec1, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ShadowTec<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}