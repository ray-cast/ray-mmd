#include "Sky with box.conf"
#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/Color.fxsub"
#include "../../shader/Packing.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"
#include "../../shader/BRDF.fxsub"
#include "../../shader/MonteCarlo.fxsub"
#include "../../shader/PhaseFunctions.fxsub"

float mEnvRotateX : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateX";>;
float mEnvRotateY : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateY";>;
float mEnvRotateZ : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateZ";>;
float mEnvSSSLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight+";>;
float mEnvSSSLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight-";>;
float mEnvDiffLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight+";>;
float mEnvDiffLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight-";>;
float mEnvSpecLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight+";>;
float mEnvSpecLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight-";>;

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
float mSunColorHP :  CONTROLOBJECT<string name="(self)"; string item = "SunH+";>;
float mSunColorSP :  CONTROLOBJECT<string name="(self)"; string item = "SunS+";>;
float mSunColorVP :  CONTROLOBJECT<string name="(self)"; string item = "SunV+";>;
float mSunColorVM :  CONTROLOBJECT<string name="(self)"; string item = "SunV-";>;
float mSunExponentP :  CONTROLOBJECT<string name="(self)"; string item = "SunExponent+";>;
float mSunExponentM :  CONTROLOBJECT<string name="(self)"; string item = "SunExponent-";>;

static const float3 mTopColor = srgb2linear_fast(hsv2rgb(float3(mTopColorHP, mTopColorSP, lerp(lerp(1, 2, mTopColorVP), 0, mTopColorVM))));
static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(float3(mBottomColorHP, mBottomColorSP, lerp(lerp(1, 2, mBottomColorVP), 0, mBottomColorVM))));
static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(float3(mMediumColorHP, mMediumColorSP, lerp(lerp(1, 2, mMediumColorVP), 0, mMediumColorVM))));
static const float3 mSunColor = srgb2linear_fast(hsv2rgb(float3(mSunColorHP, mSunColorSP, lerp(lerp(1, 2, mSunColorVP), 0, mSunColorVM))));

static const float mTopExponent = lerp(lerp(1, 4, mTopExponentP), 1e-5, mTopExponentM);
static const float mBottomExponent = lerp(lerp(0.5, 4, mBottomExponentP), 1e-5, mBottomExponentM);
static const float mSunExponent = lerp(lerp(0.5, 1, mSunExponentP), 0, mSunExponentM);
#else
#if USE_RGB_COLORSPACE
	static const float3 mTopColor = srgb2linear_fast(TopColor);
	static const float3 mBottomColor = srgb2linear_fast(BottomColor);
	static const float3 mMediumColor = srgb2linear_fast(MediumColor);
	static const float3 mSunColor = srgb2linear_fast(SunColor);
#else
	static const float3 mTopColor = srgb2linear_fast(hsv2rgb(TopColor));
	static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(BottomColor));
	static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(MediumColor));
	static const float3 mSunColor = srgb2linear_fast(hsv2rgb(SunColor));
#endif

static const float mTopExponent = TopExponent;
static const float mBottomExponent = BottomExponent;
static const float mSunExponent = SunExponent;
#endif

static float mEnvIntensitySSS  = lerp(lerp(1, 5, mEnvSSSLightP),  0, mEnvSSSLightM);
static float mEnvIntensitySpec = lerp(lerp(1, 5, mEnvSpecLightP), 0, mEnvSpecLightM);
static float mEnvIntensityDiff = lerp(lerp(1, 5, mEnvDiffLightP), 0, mEnvDiffLightM);

static float3x3 matTransform = CreateRotate(float3(mEnvRotateX, mEnvRotateY, mEnvRotateZ) * PI_2);

texture BRDF<string ResourceName = "Textures/BRDF.hdr"; int Miplevels = 1;>;
sampler BRDFSamp = sampler_state {
	texture = <BRDF>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
	ADDRESSU = CLAMP; ADDRESSV = CLAMP;
};
texture SpecularMap<string ResourceName = "Textures/skyspec_hdr.dds";>;
sampler SpecularMapSamp = sampler_state {
	texture = <SpecularMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = CLAMP; ADDRESSV = CLAMP;
};

float3 SampleSky(float3 N, float3 V)
{
	float3 color = 0;
	color = lerp(mMediumColor, mTopColor, pow(max(0, N.y), mTopExponent));
	color = lerp(color, mBottomColor, pow(max(0, -N.y), mBottomExponent));
	color = lerp(color, mSunColor, ComputePhaseMieHG(dot(V, -MainLightDirection), mSunExponent));

	return color;
}

float3 ImageBasedLightSubsurface(MaterialParam material, float3 N, float3 V, float3 prefilteredDiffuse)
{
	float3 dependentSplit = 0.5 + (1 - material.visibility);
	float3 scattering = prefilteredDiffuse + SampleSky(-N, V);
	scattering *= material.customDataB * material.customDataA * dependentSplit;
	return scattering * mEnvIntensitySSS / PI;
}

float3 ComputeAnisotropyDominantDir(float3 N, float3 V, float roughness, float anisotropy, float shift)
{
	float3 X = normalize(cross(N, float3(0,1,0)) + N * shift);
	float3 Y = normalize(cross(X, N) - N * shift);

	float3 B = cross(Y, V);
	float3 T = cross(B, Y);

	float3 bentNormal = normalize(lerp(N, lerp(N, T, anisotropy), roughness));

	return reflect(-V, bentNormal);
}

float3 ImportanceSampleDiffuseSky(float3 N, float3 V, float roughness)
{
	const uint NumSamples = 32;

	float3 lighting = 0;
	float weight = 0;

	for (uint i = 0; i < NumSamples; i++)
	{
		float2 E = HammersleyNoBitOps(i, NumSamples);
		float3 L = TangentToWorld(N, HammersleySampleCos(E));
		float3 H = normalize(N + L);

		float nl = saturate(dot(N, L));
		if (nl > 0.0)
		{
			lighting += SampleSky(L, V) * nl;
			weight += nl;
		}
	}

	return lighting / max(0.001f, weight);
}

float3 ImportanceSampleSpecularSky(float3 N, float3 V, float roughness)
{
	const uint NumSamples = 32;

	float3 lighting = 0;
	float weight = 0;

	for (uint i = 0; i < NumSamples; i++)
	{
		float2 E = HammersleyNoBitOps(i, NumSamples);
		float3 H = TangentToWorld(N, HammersleySampleGGX(E, roughness));
		float3 L = 2 * dot(N, H) * H - N;

		float nl = saturate(dot(N, L));
		if (nl > 0)
		{
			lighting += SampleSky(L, V) * nl;
			weight += nl;
		}
	}

	return lighting / max(0.001f, weight);
}

void ShadingMaterial(MaterialParam material, float3 worldView, out float3 diffuse, out float3 specular)
{
	float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);

	float3 V = mul(matTransform, worldView);
	float3 N = mul(matTransform, worldNormal);
	float3 R = EnvironmentReflect(N, V);

	float nv = abs(dot(worldNormal, worldView));
	float roughness = SmoothnessToRoughness(material.smoothness);

	float3 fresnel = 0;

	[branch]
	if (material.lightModel == SHADINGMODELID_CLOTH)
		fresnel = EnvironmentSpecularCloth(nv, material.smoothness, material.customDataB);
	else
		fresnel = EnvironmentSpecularLUT(BRDFSamp, nv, material.smoothness, material.specular);

	if (material.lightModel == SHADINGMODELID_ANISOTROPY)
	{
		R = ComputeAnisotropyDominantDir(N, V, SmoothnessToRoughness(material.smoothness), material.customDataA, material.customDataB.r);
	}

	float mipLayer = EnvironmentMip(6, material.smoothness);

	float3 prefilteredDiffuse = ImportanceSampleDiffuseSky(N, V, roughness);
	float3 prefilteredSpeculr = ImportanceSampleSpecularSky(R, V, roughness);
	prefilteredSpeculr *= luminance(DecodeRGBT(tex2Dlod(SpecularMapSamp, float4(SampleLatlong(R), 0, mipLayer)))) * PI_2;

	diffuse = prefilteredDiffuse * mEnvIntensityDiff;
	specular = prefilteredSpeculr * fresnel * mEnvIntensitySpec;

	if (material.lightModel == SHADINGMODELID_SKIN || 
		material.lightModel == SHADINGMODELID_SUBSURFACE ||
		material.lightModel == SHADINGMODELID_GLASS)
	{
		diffuse += ImageBasedLightSubsurface(material, N, V, prefilteredDiffuse);
	}
}

void GradientLightingVertex(
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

void GradientLightingFragment(
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
	ShadingMaterial(material, V, diffuse, specular);

	float3 diffuse2, specular2;
	ShadingMaterial(materialAlpha, V, diffuse2, specular2);

	oColor0 = EncodeYcbcr(screenPosition, diffuse, specular);
	oColor1 = EncodeYcbcr(screenPosition, diffuse2, specular2);
}

#define MIDPOINT_8_BIT (127.0f / 255.0f)

const float4 BackColor = float4(0,0,0,0);
const float4 IBLColor  = float4(0,MIDPOINT_8_BIT,0,MIDPOINT_8_BIT);

shared texture EnvLightAlphaMap : RENDERCOLORTARGET;

#define OBJECT_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; \
		string Script =\
		"ClearSetColor=BackColor;"\
		"RenderColorTarget0=LightAlphaMap; Clear=Color;"\
		"RenderColorTarget0=LightSpecMap;  Clear=Color;"\
		"RenderColorTarget0=; RenderColorTarget1=EnvLightAlphaMap; ClearSetColor=IBLColor; Clear=Color;"\
		"Pass=DrawObject;"\
	;>{\
		pass DrawObject {\
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			CullMode = CCW;\
			VertexShader = compile vs_3_0 GradientLightingVertex();\
			PixelShader  = compile ps_3_0 GradientLightingFragment();\
		}\
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec<string MMDPass="edge";>{}
technique ShadowTech<string MMDPass="shadow";>{}
technique ZplotTec<string MMDPass="zplot";>{}