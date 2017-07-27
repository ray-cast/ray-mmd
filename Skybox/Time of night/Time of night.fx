#include "Time of night.conf"

#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/phasefunctions.fxsub"

#include "shader/common.fxsub"
#include "shader/stars.fxsub"
#include "shader/atmospheric.fxsub"

#define MILKYWAY_ENABLE 1

static const float3 moonScaling = 3800;
static const float3 moonTranslate = 80000;

static float3x3 matTransformMoon = CreateRotate(float3(0.0, 0.0, time / 50));
static float3x3 matTransformMilkWay = CreateRotate(float3(3.14 / 2,0.0, 0.0));

texture MoonMap<string ResourceName = "Shader/Textures/moon.jpg";>;
sampler MoonMapSamp = sampler_state
{
	texture = <MoonMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

#if MILKYWAY_ENABLE
texture MilkWayMap<string ResourceName = "Shader/Textures/milky way.jpg";>;
sampler MilkWayMapSamp = sampler_state
{
	texture = <MilkWayMap>;
	MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = NONE;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};
#endif

void StarsVS(
	in float4 Position    : POSITION,
	in float4 Texcoord    : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float4 oPosition  : POSITION)
{
	oTexcoord0 = normalize(Position);

	Position.xyz += CameraPosition;
	oTexcoord1 = normalize(CameraPosition - Position.xyz);
	oPosition = mul(Position, matViewProject);
}

float4 StarsPS(
	in float3 normal  : TEXCOORD0, 
	in float3 viewdir : TEXCOORD1) : COLOR
{
	float starBlink = 0.25;
	float starDencity = 0.04;
	float starDistance = 400;
	float starBrightness = 0.4;

	float3 V = normalize(viewdir);

	float3 stars1 = CreateStars(normal, starDistance, starDencity, starBrightness, starBlink * time + PI);
	float3 stars2 = CreateStars(normal, starDistance * 0.5, starDencity * 0.5, starBrightness, starBlink * time + PI);

	stars1 *= hsv2rgb(float3(dot(normal, SunDirection), mStarSaturation, mStarBrightness));
	stars2 *= hsv2rgb(float3(dot(normal, -V), mStarSaturation, mStarBrightness));

	float fadeSun = pow(saturate(dot(V, SunDirection)), 15);
	float fadeStars = saturate(pow(saturate(normal.y), 1.0 / 1.5)) * step(0, normal.y);

	float meteor = CreateMeteor(V, float3(SunDirection.x, -1, SunDirection.z) + float3(0.5,0,0.0), time / PI);

	float3 stars = lerp((stars1 + stars2) * fadeStars + meteor * mMeteor, 0, fadeSun);

	float3 up = mul(float3(0,0,1), matTransformMilkWay);
	float2 coord = ComputeSphereCoord(mul(V, matTransformMilkWay)) - float2(time / 1000, 0.0);

#if MILKYWAY_ENABLE
	stars = lerp(stars, tex2Dlod(MilkWayMapSamp, float4(coord, 0, 0)).rgb, pow2(saturate(-V.y)));
#endif

	return float4(stars, 1);
}

void SphereVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION,
	uniform float3 translate, uniform float3 scale)
{
	oTexcoord0 = Texcoord;
	oTexcoord1 = normalize(Position);
	oPosition = mul(float4(oTexcoord1.xyz * scale + translate, 1), matViewProject);
}

float4 SpherePS(
	in float2 coord : TEXCOORD0,
	in float3 normal : TEXCOORD1,
	uniform sampler source) : COLOR
{
	float4 diffuse = pow(tex2D(source, coord + float2(time / 200, 0)), 2.2);
	diffuse.rgb *= saturate(dot(normal, -SunDirection) + 0.15);
	return diffuse;
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
	oTexcoord2 = float4(oTexcoord1.xyz * scale * mSunRadius - SunDirection * translate, 1);
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
	diffuse *= (1 - mSunRadianceM) * (step(0, V.y) + exp2(-abs(V.y) * 500));
	return diffuse;
}

void ScatteringVS(
	in float4 Position   : POSITION,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position);
	oTexcoord1 = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity, 4);
	oTexcoord2 = ComputeWaveLengthRayleigh(mWaveLength) * mRayleighColor;
	oPosition = mul(Position + float4(CameraPosition, 0), matViewProject);
}

float4 ScatteringPS(
	in float3 viewdir : TEXCOORD0,
	in float3 mieLambda : TEXCOORD1,
	in float3 rayleight : TEXCOORD2) : COLOR
{
	float3 V = normalize(viewdir);

	float scaling = 1000;

	ScatteringParams setting;
	setting.sunSize = mSunRadius;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mMiePhase;
	setting.mieHeight = mMieHeight * scaling;
	setting.rayleighHeight = mRayleighHeight * scaling;
	setting.waveLambdaMie = mieLambda;
	setting.waveLambdaRayleigh = rayleight;

	float4 insctrColor = ComputeSkyScattering(setting, V, SunDirection);

	return linear2srgb(insctrColor);
}

#define SKYBOX_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass;>\
	{ \
		pass DrawStars { \
			AlphaTestEnable = FALSE; AlphaBlendEnable = FALSE; \
			VertexShader = compile vs_3_0 StarsVS(); \
			PixelShader  = compile ps_3_0 StarsPS(); \
		} \
		pass DrawMoon { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = ONE; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 MoonVS(moonTranslate, moonScaling); \
			PixelShader  = compile ps_3_0 MoonPS(MoonMapSamp); \
		} \
		pass DrawScattering { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = ONE; DestBlend = SRCALPHA;\
			VertexShader = compile vs_3_0 ScatteringVS(); \
			PixelShader  = compile ps_3_0 ScatteringPS(); \
		} \
	}

SKYBOX_TEC(ScatteringTec0, "object")
SKYBOX_TEC(ScatteringTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";> {}
technique ShadowTec<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}