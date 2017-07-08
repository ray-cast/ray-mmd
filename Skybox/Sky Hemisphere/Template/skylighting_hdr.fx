#include "skybox.conf"
#include "../../../shader/math.fxsub"
#include "../../../shader/common.fxsub"
#include "../../../shader/gbuffer.fxsub"
#include "../../../shader/gbuffer_sampler.fxsub"
#include "../../../shader/ibl.fxsub"

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
float mEnvRotateX : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateX";>;
float mEnvRotateY : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateY";>;
float mEnvRotateZ : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateZ";>;
float mEnvSSSLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight+";>;
float mEnvSSSLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight-";>;
float mEnvDiffLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight+";>;
float mEnvDiffLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight-";>;
float mEnvSpecLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight+";>;
float mEnvSpecLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight-";>;

static const float3 mTopColor = srgb2linear_fast(hsv2rgb(float3(mTopColorHP, mTopColorSP, lerp(lerp(1, 2, mTopColorVP), 0, mTopColorVM))));
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

static float mEnvIntensitySSS  = lerp(lerp(1, 5, mEnvSSSLightP),  0, mEnvSSSLightM);
static float mEnvIntensitySpec = lerp(lerp(1, 5, mEnvSpecLightP), 0, mEnvSpecLightM);
static float mEnvIntensityDiff = lerp(lerp(1, 5, mEnvDiffLightP), 0, mEnvDiffLightM);

static float3x3 matTransform = CreateRotate(float3(mEnvRotateX, mEnvRotateY, mEnvRotateZ) * PI_2);

float3 SampleSky(float3 N, float smoothness)
{
	float3 color = 0;
	color = lerp(mMediumColor, mTopColor, pow(max(0, N.y), lerp(mTopExponent * 2, mTopExponent, pow2(smoothness))));
	color = lerp(color, mBottomColor, pow(max(0, -N.y), lerp(mBottomExponent * 4, mBottomExponent, pow2(smoothness))));
	return color / PI;
}

float3 ImageBasedLightSubsurface(MaterialParam material, float3 N, float3 prefilteredDiffuse)
{
	float3 dependentSplit = 0.5;
	float3 scattering = prefilteredDiffuse + SampleSky(-N, 0);
	scattering *= material.customDataB * material.customDataA * dependentSplit;
	return scattering * mEnvIntensitySSS;
}

void ShadingMaterial(MaterialParam material, float3 worldView, float finalSmoothness, out float3 diffuse, out float3 specular)
{
	float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
	float3 worldReflect = EnvironmentReflect(worldNormal, worldView);

	float3 V = mul(matTransform, worldView);
	float3 N = mul(matTransform, worldNormal);
	float3 R = mul(matTransform, worldReflect);

	float3 fresnel = EnvironmentSpecularUnreal4(worldNormal, worldView, finalSmoothness, material.specular);

	float3 prefilteredDiffuse = SampleSky(N, 0) * (1 - fresnel);
	float3 prefilteredSpeculr = SampleSky(R, material.smoothness);

	diffuse = prefilteredDiffuse * mEnvIntensityDiff;
	specular = prefilteredSpeculr * fresnel;

	if (material.lightModel == SHADINGMODELID_SKIN || 
		material.lightModel == SHADINGMODELID_SUBSURFACE ||
		material.lightModel == SHADINGMODELID_GLASS)
	{
		diffuse += ImageBasedLightSubsurface(material, N, prefilteredDiffuse) * (1 + fresnel);
	}

	specular *= mEnvIntensitySpec;
	specular *= step(0, dot(material.specular, 1) - 1e-5);
}

void EnvLightingVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oTexcoord1= CameraPosition - Position.xyz;
	oTexcoord0 = oPosition = mul(Position, matViewProject);
	oTexcoord0.xy = PosToCoord(oTexcoord0.xy / oTexcoord0.w) + ViewportOffset;
	oTexcoord0.xy = oTexcoord0.xy * oTexcoord0.w;
}

void EnvLightingPS(
	in float4 texcoord : TEXCOORD0,
	in float3 viewdir  : TEXCOORD1,
	in float4 screenPosition : SV_Position,
	out float4 oColor0 : COLOR0,
	out float4 oColor1 : COLOR1)
{
	float2 coord = texcoord.xy / texcoord.w;

	float4 MRT5 = tex2Dlod(Gbuffer5Map, float4(coord, 0, 0));
	float4 MRT6 = tex2Dlod(Gbuffer6Map, float4(coord, 0, 0));
	float4 MRT7 = tex2Dlod(Gbuffer7Map, float4(coord, 0, 0));
	float4 MRT8 = tex2Dlod(Gbuffer8Map, float4(coord, 0, 0));

	MaterialParam materialAlpha;
	DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);

	float3 sum1 = materialAlpha.albedo + materialAlpha.specular;
	clip(dot(sum1, 1) - 1e-5);

	float4 MRT1 = tex2Dlod(Gbuffer1Map, float4(coord, 0, 0));
	float4 MRT2 = tex2Dlod(Gbuffer2Map, float4(coord, 0, 0));
	float4 MRT3 = tex2Dlod(Gbuffer3Map, float4(coord, 0, 0));
	float4 MRT4 = tex2Dlod(Gbuffer4Map, float4(coord, 0, 0));

	MaterialParam material;
	DecodeGbuffer(MRT1, MRT2, MRT3, MRT4, material);

	float3 V = normalize(viewdir);

	float3 diffuse, specular;
	ShadingMaterial(material, V, material.smoothness, diffuse, specular);

	float3 diffuse2, specular2;
	ShadingMaterial(materialAlpha, V, materialAlpha.smoothness, diffuse2, specular2);

	oColor0 = EncodeYcbcr(screenPosition, diffuse, specular);
	oColor1 = EncodeYcbcr(screenPosition, diffuse2, specular2);
}

const float4 BackColor = float4(0,0,0,0);
const float4 IBLColor  = float4(0,0.5,0,0.5);

shared texture EnvLightAlphaMap : RENDERCOLORTARGET;

#define OBJECT_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; \
		string Script =\
		"ClearSetColor=BackColor;"\
		"RenderColorTarget0=LightAlphaMap;"\
		"Clear=Color;"\
		"RenderColorTarget0=LightSpecMap;"\
		"Clear=Color;"\
		"RenderColorTarget0=;"\
		"RenderColorTarget1=EnvLightAlphaMap;"\
		"ClearSetColor=IBLColor;"\
		"Clear=Color;"\
		"Pass=DrawObject;"\
;> {\
	pass DrawObject {\
		AlphaBlendEnable = false; AlphaTestEnable = false;\
		CullMode = CCW;\
		VertexShader = compile vs_3_0 EnvLightingVS();\
		PixelShader  = compile ps_3_0 EnvLightingPS();\
	}\
}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ShadowTech<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}