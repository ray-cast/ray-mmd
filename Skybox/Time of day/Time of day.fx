#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/stars.fxsub"
#include "shader/cloud.fxsub"
#include "shader/atmospheric.fxsub"

float mSunRadiusP : CONTROLOBJECT<string name="(self)"; string item = "SunRadius+";>;
float mSunRadiusM : CONTROLOBJECT<string name="(self)"; string item = "SunRadius-";>;
float mSunRadianceP : CONTROLOBJECT<string name="(self)"; string item = "SunRadiance+";>;
float mSunRadianceM : CONTROLOBJECT<string name="(self)"; string item = "SunRadiance-";>;
float mMiePhaseP : CONTROLOBJECT<string name="(self)"; string item = "MiePhase+";>;
float mMiePhaseM : CONTROLOBJECT<string name="(self)"; string item = "MiePhase-";>;
float mMieTurbidityP : CONTROLOBJECT<string name="(self)"; string item = "MieTurbidity+";>;
float mMieTurbidityM : CONTROLOBJECT<string name="(self)"; string item = "MieTurbidity-";>;

float mCloudP : CONTROLOBJECT<string name="(self)"; string item = "Cloud+";>;
float mCloudM : CONTROLOBJECT<string name="(self)"; string item = "Cloud-";>;
float mCloudSpeedP : CONTROLOBJECT<string name="(self)"; string item = "CloudSpeed+";>;
float mCloudSpeedM : CONTROLOBJECT<string name="(self)"; string item = "CloudSpeed-";>;
float mCloudBiasP : CONTROLOBJECT<string name="(self)"; string item = "CloudBias+";>;
float mCloudBiasM : CONTROLOBJECT<string name="(self)"; string item = "CloudBias-";>;

float mRayleightH : CONTROLOBJECT<string name="(self)"; string item = "RayleighH";>;
float mRayleightS : CONTROLOBJECT<string name="(self)"; string item = "RayleighS";>;
float mRayleightVP : CONTROLOBJECT<string name="(self)"; string item = "RayleighV+";>;

float mSkyNightP : CONTROLOBJECT<string name="(self)"; string item = "SkyNight+";>;

static float mSunRadius = lerp(lerp(0.99, 1.0, mSunRadiusM), 0.65, mSunRadiusP);
static float mSunRadiance = lerp(lerp(10, 20, mSunRadianceP), 1.0, mSunRadianceM);
static float mMiePhase = lerp(lerp(0.76, 1.0, mMiePhaseP), 0.65, mMiePhaseM);
static float mMieTurbidity = lerp(lerp(1.0, 2.5, mMieTurbidityP), 1e-5, mMieTurbidityM);

static float mCloudDensity = lerp(lerp(0.5, 1.0, mCloudP), 0.0, mCloudM);
static float mCloudBias = time * lerp(lerp(0.05, 0.2, mCloudBiasP), 0, mCloudBiasM);
static float mCloudSpeed = time * lerp(lerp(0.1, 1, mCloudSpeedP), 0, mCloudSpeedM);

static float3 mWaveLength = float3(680e-9,550e-9,440e-9);
static float3 mMieColor = float3(0.686, 0.678, 0.666) * LightSpecular;
static float3 mRayleightColor = hsv2rgb(float3(mRayleightH, mRayleightS, 1 + mRayleightVP));

static const float3 moonScaling = 2000;
static const float3 moonTranslate = -float3(10000, -5000,10000);

static const float3 jupiterScaling = 4000;
static const float3 jupiterTranslate = float3(10000, 5000, 10000);

texture DiffuseMap: MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
	texture = <DiffuseMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

float3 SpecularBRDF_GGX(float3 N, float3 L, float3 V, float roughness, float3 specular, float NormalizationFactor)
{
	float3 H = normalize(V + L);

	float nh = saturate(dot(N, H));
	float nl = saturate(dot(N, L));
	float vh = saturate(dot(V, H));
	float nv = abs(dot(N, V)) + 1e-5h;

	float m2 = roughness * roughness;
	float spec = (nh * m2 - nh) * nh + 1;
	spec = m2 / (spec * spec) * NormalizationFactor;

	float Gv = nl * sqrt((-nv * m2 + nv) * nv + m2);
	float Gl = nv * sqrt((-nl * m2 + nl) * nl + m2);
	spec *= 0.5h / (Gv + Gl);

	float3 f0 = max(0.02, specular);
	float3 fresnel = lerp(f0, 1.0, pow5(1 - vh));

	return fresnel * spec * nl;
}

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
	start = lerp(0, start, mSkyNightP);
	
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
	oTexcoord2 = normalize(CameraPosition - (oTexcoord1.xyz * scale + translate));
	oPosition = mul(float4(oTexcoord1.xyz * scale + translate, 1), matViewProject);
}

float4 SpherePS(
	in float2 coord : TEXCOORD0,
	in float3 normal : TEXCOORD1,
	in float3 viewdir : TEXCOORD2) : COLOR
{
	float4 diffuse = tex2D(DiffuseMapSamp, coord);
	diffuse.rgb *= saturate(dot(normal, -LightDirection) + 0.15);
	diffuse.rgb += SpecularBRDF_GGX(normal, -LightDirection, viewdir, 1.0, 0.04, PI);
	return diffuse;
}

void ScatteringVS(
	in float4 Position   : POSITION,
	out float3 oTexcoord0 : TEXCOORD0,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position).xyz;
	oPosition = mul(Position + float4(CameraPosition, 0), matWorldViewProject);
}

float4 ScatteringPS(in float3 viewdir : TEXCOORD0) : COLOR
{
	float3 V = normalize(viewdir);
	
	float scaling = 1000;

	ScatteringParams setting;
	setting.sunSize = mSunRadius;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mMiePhase;
	setting.mieHeight = 1.2 * scaling;
	setting.rayleighHeight = 15 * scaling;
	setting.earthRadius = 6360 * scaling;
	setting.earthAtmTopRadius = 6380 * scaling;
	setting.earthCenter = float3(0, -setting.earthRadius, 0);
	setting.waveLambdaMie = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity * scaling, 3);
	setting.waveLambdaRayleigh = ComputeWaveLengthRayleigh(mWaveLength) * mRayleightColor;
	setting.cloud = mCloudDensity;
	setting.cloudMie = 0.5;
	setting.cloudBias = mCloudBias;
    setting.cloudTop = 8 * scaling;
    setting.cloudBottom = 5 * scaling;
	setting.clouddir = float3(23175.7, 0, -3e+3 * mCloudSpeed);

	float4 insctrColor = ComputeCloudsInscattering(setting, CameraPosition + float3(0, scaling, 0), V, LightDirection);

	return linear2srgb(insctrColor);
}

#define BACKGROUND_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="0";>\
	{ \
		pass DrawObject { \
			AlphaTestEnable = FALSE; AlphaBlendEnable = FALSE; \
			VertexShader = compile vs_3_0 StarsVS(); \
			PixelShader  = compile ps_3_0 StarsPS(); \
		} \
	}
   
#define MOON_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="1";>\
	{ \
		pass DrawObject { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 SphereVS(moonTranslate, moonScaling); \
			PixelShader  = compile ps_3_0 SpherePS(); \
		} \
	}

#define JUPITER_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="2";>\
	{ \
		pass DrawObject { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 SphereVS(jupiterTranslate, jupiterScaling); \
			PixelShader  = compile ps_3_0 SpherePS(); \
		} \
	}

#define SKYBOX_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="3";>\
	{ \
		pass DrawObject { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = ONE; DestBlend = SRCALPHA;\
			VertexShader = compile vs_3_0 ScatteringVS(); \
			PixelShader  = compile ps_3_0 ScatteringPS(); \
		} \
	}

MOON_TEC(MoonTec1, "object")
MOON_TEC(MoonTecBS1, "object_ss")
JUPITER_TEC(Jupiter1, "object")
JUPITER_TEC(JupiterBS1, "object_ss")
SKYBOX_TEC(ScatteringTec0, "object")
SKYBOX_TEC(ScatteringTecBS0, "object_ss")
BACKGROUND_TEC(StarsTec0, "object")
BACKGROUND_TEC(StarsTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";> {}
technique ShadowTec<string MMDPass = "shadow";> {}
technique ZplotTec<string MMDPass = "zplot";> {}