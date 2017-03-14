#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/stars.fxsub"
#include "shader/phase.fxsub"
#include "shader/atmospheric.fxsub"

static const float3 moonScaling = 2000;
static const float3 moonTranslate = -float3(10000, -5000,10000);

static const float3 jupiterScaling = 4000;
static const float3 jupiterTranslate = float3(10000, 5000, 10000);

static float3x3 matTransform = CreateRotate(float3(3.14 / 2,0.0,0.0));

texture MilkWayMap<string ResourceName = "Shader/Textures/milky way.jpg";>;
sampler MilkWayMapSamp = sampler_state
{
	texture = <MilkWayMap>;
	MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = NONE;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};
texture MoonMap<string ResourceName = "Shader/Textures/moon.jpg";>;
sampler MoonMapSamp = sampler_state
{
	texture = <MoonMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};
texture JupiterMap<string ResourceName = "Shader/Textures/jupiter.jpg";>;
sampler JupiterMapSamp = sampler_state
{
	texture = <JupiterMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

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

	stars1 *= hsv2rgb(float3(dot(normal, LightDirection), 0.2, 1.5));
	stars2 *= hsv2rgb(float3(dot(normal, -V), 0.2, 1.5));

	float fadeSun = pow(saturate(dot(V, LightDirection)), 15);
	float fadeStars = saturate(pow(saturate(normal.y), 1.0 / 1.5)) * step(0, normal.y);

	float meteor = CreateMeteor(V, float3(LightDirection.x, -1, LightDirection.z) + float3(0.5,0,0.0), time / PI);
	
	float3 start = lerp((stars1 + stars2) * fadeStars + meteor, 0, fadeSun);
	
	float3 up = mul(float3(0,0,1), matTransform);
	float2 coord = ComputeSphereCoord(mul(V, matTransform));
	start = lerp(start, tex2Dlod(MilkWayMapSamp, float4(coord, 0, 0)).rgb, dot(-V, up));

	return float4(start, 1);
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
	float4 diffuse = tex2D(source, coord + float2(time / 200, 0));
	diffuse.rgb *= saturate(dot(normal, -LightDirection) + 0.15);
	return diffuse;
}

void ScatteringVS(
	in float4 Position   : POSITION,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position);
	oPosition = mul(Position + float4(CameraPosition, 0), matViewProject);
}

float4 ScatteringPS(in float3 viewdir : TEXCOORD0) : COLOR
{
	float3 V = normalize(viewdir);

	float scaling = 1000;

	ScatteringParams setting;
	setting.sunSize = mSunRadius;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mMiePhase;
	setting.mieHeight = mMieHeight * scaling;
	setting.rayleighHeight = mRayleighHeight * scaling;
	setting.waveLambdaMie = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity * scaling, 3);
	setting.waveLambdaRayleigh = ComputeWaveLengthRayleigh(mWaveLength) * mRayleighColor;

	float4 insctrColor = ComputeSkyScattering(setting, V, LightDirection);

	return linear2srgb(insctrColor);
}

#define SKYBOX_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="0";>\
	{ \
		pass DrawStars { \
			AlphaTestEnable = FALSE; AlphaBlendEnable = FALSE; \
			VertexShader = compile vs_3_0 StarsVS(); \
			PixelShader  = compile ps_3_0 StarsPS(); \
		} \
		pass DrawJupiter { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 SphereVS(jupiterTranslate, jupiterScaling); \
			PixelShader  = compile ps_3_0 SpherePS(JupiterMapSamp); \
		} \
		pass DrawMoon { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 SphereVS(moonTranslate, moonScaling); \
			PixelShader  = compile ps_3_0 SpherePS(MoonMapSamp); \
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
technique ShadowTec<string MMDPass = "shadow";> {}
technique ZplotTec<string MMDPass = "zplot";> {}