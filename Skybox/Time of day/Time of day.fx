#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/stars.fxsub"
#include "shader/cloud.fxsub"
#include "shader/atmospheric.fxsub"

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
	
	float3 stars = stars1 + stars2;	

	float fadeSun = pow(saturate(dot(V, LightDirection)), 15);
	float fadeStars = saturate(pow(saturate(normal.y), 1.0 / 1.5)) * step(0, normal.y);
	
	float meteor = CreateMeteor(V, float3(LightDirection.x, -1, LightDirection.z) + float3(0.5,0,0.0), time / PI);
	
	return float4(lerp(stars * fadeStars + meteor, 0, fadeSun), 1);
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
	out float3 oTexcoord : TEXCOORD,
	out float4 oPosition : POSITION)
{
	Position.xyz += CameraPosition;
	oTexcoord = normalize(Position.xyz - CameraPosition);
	oPosition = mul(Position, matViewProject);
}

float4 ScatteringPS(in float3 viewdir : TEXCOORD0) : COLOR
{
	float scaling = 1000;
	
	ScatteringParams setting;
	setting.sunSize = 0.99;
	setting.sunRadiance = 10.0;
	setting.mieG = 0.76;
	setting.mieHeight = 1.2 * scaling;
	setting.mieCoefficient = 1.0;
	setting.rayleighHeight = 7.994 * scaling;
	setting.rayleighCoefficient = 1.0;
	setting.earthRadius = 6360 * scaling;
	setting.earthAtmTopRadius = 6380 * scaling;
	setting.earthCenter = float3(0, -6361, 0) * scaling;
	setting.waveLambdaMie = 2e-5;
	setting.waveLambdaRayleigh = float3(5.8e-6, 13.5e-6, 33.1e-6);
	setting.cloud = 0.6;
	setting.cloudBias = time / 20;
	setting.clouddir = float3(0, 0, -time * 3e+3);

	float3 V = normalize(viewdir);
	float4 insctrColor = ComputeUnshadowedInscattering(setting, CameraPosition, V, LightDirection);

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

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}