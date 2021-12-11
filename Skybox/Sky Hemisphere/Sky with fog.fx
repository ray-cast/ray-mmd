#include "../../ray.conf"
#include "../../ray_advanced.conf"
#include "../../shader/math.fxsub"
#include "../../shader/Color.fxsub"
#include "../../shader/Packing.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"
#include "../../shader/VolumeRendering.fxsub"
#include "../../shader/MonteCarlo.fxsub"
#include "../../shader/PhaseFunctions.fxsub"

float mEnvRotateX : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateX";>;
float mEnvRotateY : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateY";>;
float mEnvRotateZ : CONTROLOBJECT<string name="(self)"; string item = "EnvRotateZ";>;
float mFogColorHP :  CONTROLOBJECT<string name="(self)"; string item = "FogColorH+";>;
float mFogColorSP :  CONTROLOBJECT<string name="(self)"; string item = "FogColorS+";>;
float mFogColorVP :  CONTROLOBJECT<string name="(self)"; string item = "FogColorV+";>;
float mFogColorVM :  CONTROLOBJECT<string name="(self)"; string item = "FogColorV-";>;
float mFogDensityP : CONTROLOBJECT<string name="(self)"; string item = "FogDensity+";>;
float mFogDensityM : CONTROLOBJECT<string name="(self)"; string item = "FogDensity-";>;
float mFogBaseHeightP : CONTROLOBJECT<string name="(self)"; string item = "FogBaseHeight+";>;
float mFogBaseHeightM : CONTROLOBJECT<string name="(self)"; string item = "FogBaseHeight-";>;
float mFogMaxHeightP : CONTROLOBJECT<string name="(self)"; string item = "FogMaxHeight+";>;
float mFogMaxHeightM : CONTROLOBJECT<string name="(self)"; string item = "FogMaxHeight-";>;
float mFogAttenDistanceP : CONTROLOBJECT<string name="(self)"; string item = "FogAttenDistance+";>;
float mFogAttenDistanceM : CONTROLOBJECT<string name="(self)"; string item = "FogAttenDistance-";>;
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

const float3 mFogBaseHeightLimit = float3(-50, 100, -100);
const float3 mFogMaximumHeightLimit = float3(1500, 3000, 0);
const float3 mFogAttenuationDistanceLimit = float3(200, 1000, 50);
const float3 mFogDensityLimit = float3(0.0002, 0.01, 1e-5);

static const float3 mTopColor = srgb2linear_fast(hsv2rgb(float3(mTopColorHP, mTopColorSP, lerp(lerp(1, 2, mTopColorVP), 0, mTopColorVM))));
static const float3 mBottomColor = srgb2linear_fast(hsv2rgb(float3(mBottomColorHP, mBottomColorSP, lerp(lerp(1, 2, mBottomColorVP), 0, mBottomColorVM))));
static const float3 mMediumColor = srgb2linear_fast(hsv2rgb(float3(mMediumColorHP, mMediumColorSP, lerp(lerp(1, 2, mMediumColorVP), 0, mMediumColorVM))));
static const float3 mSunColor = srgb2linear_fast(hsv2rgb(float3(mSunColorHP, mSunColorSP, lerp(lerp(1, 2, mSunColorVP), 0, mSunColorVM))));

static const float mTopExponent = lerp(lerp(1, 4, mTopExponentP), 1e-5, mTopExponentM);
static const float mBottomExponent = lerp(lerp(0.5, 4, mBottomExponentP), 1e-5, mBottomExponentM);
static const float mSunExponent = lerp(lerp(0.5, 1, mSunExponentP), 0, mSunExponentM);

static const float FogDensity = lerp(lerp(mFogDensityLimit.x, mFogDensityLimit.y, mFogDensityP), mFogDensityLimit.z, mFogDensityM);
static const float FogBaseHeight = lerp(lerp(mFogBaseHeightLimit.x, mFogBaseHeightLimit.y, mFogBaseHeightP), mFogBaseHeightLimit.z, mFogBaseHeightM);
static const float FogMaxHeight = lerp(lerp(mFogMaximumHeightLimit.x, mFogMaximumHeightLimit.y, mFogMaxHeightP), mFogMaximumHeightLimit.z, mFogMaxHeightM);
static const float FogAttenDistance = lerp(lerp(mFogAttenuationDistanceLimit.x, mFogAttenuationDistanceLimit.y, mFogAttenDistanceP), mFogAttenuationDistanceLimit.z, mFogAttenDistanceM);

static const float3 FogColor = hsv2rgb(float3(mFogColorHP, mFogColorSP, lerp(lerp(1, 2, mFogColorVP), 0, mFogColorVM)));
static const float3x3 matTransform = CreateRotate(float3(mEnvRotateX, mEnvRotateY, mEnvRotateZ) * PI_2);

float3 SampleSky(float3 N, float3 V)
{
	float3 color = 0;
	color = lerp(mMediumColor, mTopColor, pow(max(0, N.y), mTopExponent));
	color = lerp(color, mBottomColor, pow(max(0, -N.y), mBottomExponent));
	color = lerp(color, mSunColor, ComputePhaseMieHG(dot(V, -MainLightDirection), mSunExponent));

	return color;
}

float3 ImportanceSampleSky(float3 N, float3 V, float roughness)
{
	const uint NumSamples = 32;

	float3 lighting = 0;
	float weight = 0;

	for (uint i = 0; i < NumSamples; i++)
	{
		float2 E = HammersleyNoBitOps(i, NumSamples);
		float3 H = TangentToWorld(N, HammersleySampleGGX(E, roughness)).xyz;
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

float ComputeMipFogFactor(float z)
{
#if SKYBOX_FOG_TYPE == 0 || SKYBOX_FOG_TYPE == 1
    // factor = exp(-(density*z)^2)
    // -density * z computed at vertex
    return float(z * FogDensity);
#elif SKYBOX_FOG_TYPE == 2
    // factor = (end-z)/(end-start) = z * (-1/(end-start)) + (end/(end-start))
    float fogFactor = saturate(z * _MipFogFactorParams.z + _MipFogFactorParams.w);
    return float(fogFactor);
#else
    return 0.0;
#endif
}

void GradientBasedFogVertex(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = oPosition = mul(Position, matViewProject);
	oTexcoord0.xy = PosToCoord(oTexcoord0.xy / oTexcoord0.w) + ViewportOffset;
	oTexcoord0.xy = oTexcoord0.xy * oTexcoord0.w;
	oTexcoord1 = Position.xyz;
}

float4 GradientBasedFogFragment(
	in float4 texcoord : TEXCOORD0,
	in float3 worldPosition  : TEXCOORD1) : COLOR0
{
	float2 coord = texcoord.xy / texcoord.w;

	float4 MRT5 = tex2Dlod(Gbuffer5Map, float4(coord, 0, 0));
	float4 MRT6 = tex2Dlod(Gbuffer6Map, float4(coord, 0, 0));
	float4 MRT7 = tex2Dlod(Gbuffer7Map, float4(coord, 0, 0));
	float4 MRT8 = tex2Dlod(Gbuffer8Map, float4(coord, 0, 0));

	MaterialParam material;
	DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, material);

	float3 V = -normalize(CameraPosition - worldPosition);
	float3 P = CameraPosition + V * material.linearDepth;
	float3 N = mul(matTransform, V);

#if SKYBOX_FOG_TYPE == 0
	float fogFactor = ComputeMipFogFactor(material.linearDepth);
#elif SKYBOX_FOG_TYPE == 1
    float extinction = FogAttenDistance;
    float layerDepth = max(0.01f, FogMaxHeight - FogBaseHeight);
    float H = ScaleHeightFromLayerDepth(layerDepth);
    float heightFogExponents = float2(1.0f / H, H);

	float fogFactor = OpticalDepthHeightFog(extinction, FogBaseHeight, heightFogExponents, FogDensity, V.y, P.y, material.linearDepth);
#endif

	float3 mipFogColor = FogColor;
	mipFogColor *= ImportanceSampleSky(N, V, ComputeFogMip(0.01, 5000, material.linearDepth, 0.7, 1.0));

	return float4(mipFogColor, fogFactor);
}

#define OBJECT_TEC(name, mmdpass)\
	technique name<string MMDPass = mmdpass;\
	> {\
		pass DrawObject {\
			ZEnable = false; ZWriteEnable = false;\
			AlphaBlendEnable = true; AlphaTestEnable = FALSE;\
			SrcBlend = ONE; DestBlend = ONE;\
			VertexShader = compile vs_3_0 GradientBasedFogVertex();\
			PixelShader  = compile ps_3_0 GradientBasedFogFragment();\
		}\
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTec1, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ShadowTec<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}