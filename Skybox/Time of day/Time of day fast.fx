#include "Time of day.conf"

#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/phasefunctions.fxsub"

#include "shader/common.fxsub"
#include "shader/atmospheric.fxsub"

static const float3 sunTranslate = 80000;

texture SunMap<string ResourceName = "Shader/Textures/realsun.jpg";>;
sampler SunMapSamp = sampler_state
{
	texture = <SunMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

void SunVS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oTexcoord1 : TEXCOORD1,
	out float4 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION,
	uniform float3 translate)
{
	float3 sunDirection = normalize(-SunDirection);

	oTexcoord0 = Texcoord;
	oTexcoord1 = float4(normalize(Position.xyz), 1);
	oTexcoord2 = float4(oTexcoord1.xyz * mUnitDistance * mSunRadius + sunDirection * translate, 1);
	oPosition = mul(oTexcoord2, matViewProject);
}

float4 SunPS(
	in float2 coord : TEXCOORD0,
	in float3 normal : TEXCOORD1,
	in float3 viewdir : TEXCOORD2,
	uniform sampler source) : COLOR
{
	float3 V = normalize(viewdir - CameraPosition);
	float4 diffuse = tex2D(source, coord);
	diffuse *= diffuse;
	diffuse *= saturate(dot(normalize(normal), -SunDirection) + 0.1) * 1.5;
	diffuse *= (1 - mSunRadianceM) * (step(0, V.y) + exp2(-abs(V.y) * 100));
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
	oTexcoord1 = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity);
	oTexcoord2 = ComputeWaveLengthRayleigh(mWaveLength) * mRayleighColor;
	oPosition = mul(Position + float4(CameraPosition, 0), matViewProject);
}

float4 ScatteringPS(
	in float3 viewdir : TEXCOORD0,
	in float3 mieLambda : TEXCOORD1,
	in float3 rayleight : TEXCOORD2) : COLOR
{
	float3 V = normalize(viewdir);

	ScatteringParams setting;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mMiePhase;
	setting.mieHeight = mMieHeight * mUnitDistance;
	setting.rayleighHeight = mRayleighHeight * mUnitDistance;
	setting.earthRadius = mEarthRadius * mUnitDistance;
	setting.earthAtmTopRadius = mEarthAtmoRadius * mUnitDistance;
	setting.earthCenter = float3(0, -setting.earthRadius, 0);
	setting.waveLambdaMie = mieLambda;
	setting.waveLambdaRayleigh = rayleight;

	float4 insctrColor = ComputeSkyInscattering(setting, CameraPosition + float3(0, mEarthPeopleHeight * mUnitDistance, 0), V, SunDirection);

	return linear2srgb(insctrColor);
}

const float4 BackColor = 0.0;

technique MainTech<string MMDPass = "object";
	string Script =
	"RenderColorTarget=;"
	"ClearSetColor=BackColor;"
	"Clear=Color;"
	"Pass=DrawSun;"
	"Pass=DrawScattering;";
>{
	pass DrawSun {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = INVSRCALPHA;
		VertexShader = compile vs_3_0 SunVS(sunTranslate);
		PixelShader  = compile ps_3_0 SunPS(SunMapSamp);
	}
	pass DrawScattering {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = SRCALPHA;
		VertexShader = compile vs_3_0 ScatteringVS();
		PixelShader  = compile ps_3_0 ScatteringPS();
	}
}
technique MainTechSS<string MMDPass = "object_ss";
	string Script =
	"RenderColorTarget=;"
	"ClearSetColor=BackColor;"
	"Clear=Color;"
	"Pass=DrawSun;"
	"Pass=DrawScattering;";
>{
	pass DrawSun {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = INVSRCALPHA;
		VertexShader = compile vs_3_0 SunVS(sunTranslate);
		PixelShader  = compile ps_3_0 SunPS(SunMapSamp);
	}
	pass DrawScattering {
		AlphaBlendEnable = true; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		SrcBlend = ONE; DestBlend = SRCALPHA;
		VertexShader = compile vs_3_0 ScatteringVS();
		PixelShader  = compile ps_3_0 ScatteringPS();
	}
}

technique EdgeTec<string MMDPass = "edge";>{}
technique ShadowTec<string MMDPass = "shadow";>{}
technique ZplotTec<string MMDPass = "zplot";>{}