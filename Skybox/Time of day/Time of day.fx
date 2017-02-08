#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"

#include "shader/stars.fxsub"
#include "shader/atmospheric.fxsub"
#include "shader/clound.fxsub"

float3 LightSpecular : SPECULAR< string Object = "Light";>;
float3 LightDirection : DIRECTION< string Object = "Light";>;

static const float3 moonScaling = 2000;
static const float3 moonTranslate = -float3(10000, -5000,10000);

static const float3 jupiterScaling = 4000;
static const float3 jupiterTranslate = float3(10000, 5000, 10000);

texture DiffuseMap: MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
	texture = <DiffuseMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
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
	oTexcoord1 = normalize(CameraPosition - Position.xyz);
	oPosition = mul(Position, matViewProject);
}

float4 StarsPS(
	in float3 normal  : TEXCOORD0, 
	in float3 viewdir : TEXCOORD1) : COLOR
{
	float starDistance = 400;
	float starBrightness = 0.4;
	float starDencity = 0.04;
	float starBlink = 0.25;

	float3 stars1 = CreateStars(normal, starDistance, starDencity, starBrightness, starBlink, time + PI);
	float3 stars2 = CreateStars(normal, starDistance * 0.5, starDencity * 0.5, starBrightness, starBlink, time + PI);
	stars1 *= hsv2rgb(float3(dot(normal, LightDirection), 0.2, 1.5));
	stars2 *= hsv2rgb(float3(dot(normal, -viewdir), 0.2, 1.5));
	
	float3 stars = stars1 + stars2;
	
	float3 V = normalize(viewdir);

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
	float4 diffuse = tex2Dlod(DiffuseMapSamp, float4(coord, 0, 0));
	diffuse.rgb *= saturate(dot(normal, -LightDirection) + 0.15);
	diffuse.rgb += SpecularBRDF_GGX(normal, -LightDirection, viewdir, 1.0, 0.04, PI);
	return diffuse;
}

float3 ACESFilmLinear(float3 x)
{
	const float A = 2.51f;
	const float B = 0.03f;
	const float C = 2.43f;
	const float D = 0.59f;
	const float E = 0.14f;
	return (x * (A * x + B)) / (x * (C * x + D) + E);
}

void ScatteringVS(
	in float4 Position    : POSITION,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord0 = Position;
	oPosition = mul(Position, matViewProject);
}

float4 ScatteringPS(in float3 Position : TEXCOORD0) : COLOR
{
	ScatteringParams setting;
	setting.sunRadiance = 1000.0;
	setting.sunSteepness = 1.0;
	setting.sunCutoffAngle = PI / 1.95;
	setting.mieG = 0.76;
	setting.mieSunGloss = 0.99;
	setting.mieUpsilon = 4.0;
	setting.mieTurbidity = 1.0;
	setting.mieCoefficient = 0.005;
	setting.mieZenithLength = 1.25E3;
	setting.rayleighCoefficient = 2.0;
	setting.rayleighZenithLength = 8.4E3;
	setting.waveLambda = float3(680E-9, 550E-9, 450E-9);
	setting.waveLambdaMie = float3(0.686, 0.678, 0.666);
	setting.waveLambdaRayleigh = float3(94, 40, 18);
	
	float3 viewdir = normalize(Position - CameraPosition);
	float3 insctrColor = ComputeSkyScattering(setting, viewdir, LightDirection);

	return linear2srgb(float4(insctrColor, 1.0));
}

void CloundVS(
	in float4 Position    : POSITION,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord0 = Position;
	oPosition = mul(Position, matViewProject);
}

float4 CloundPS(in float3 Position : TEXCOORD0) : COLOR
{
	float3 viewdir = normalize(Position - CameraPosition);
	float4 cound = ComputeClound(viewdir, LightSpecular);
    return float4(cound.rgb, cound.a * cound.a);
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
			SrcBlend = ONE; DestBlend = ONE;\
			VertexShader = compile vs_3_0 ScatteringVS(); \
			PixelShader  = compile ps_3_0 ScatteringPS(); \
		} \
		pass DrawObject { \
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			ZEnable = false; ZWriteEnable = false;\
			SrcBlend = SRCALPHA; DestBlend = INVSRCALPHA;\
			VertexShader = compile vs_3_0 CloundVS(); \
			PixelShader  = compile ps_3_0 CloundPS(); \
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