#define ATM_SAMPLES_NUMS 16
#define ATM_CLOUD_ENABLE 0
#define ATM_LIMADARKENING_ENABLE 1

#include "Time of day.conf"

#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/phasefunctions.fxsub"

#include "shader/common.fxsub"
#include "shader/atmospheric.fxsub"

void ScatteringVS(
	in float4 Position   : POSITION,
	out float3 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position.xyz);
	oTexcoord1 = ComputeWaveLengthMie(mWaveLength, mMieColor, mSunTurbidity);
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
	setting.sunRadius = mSunRadius;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mSunPhase;
	setting.mieHeight = mMieHeight * mUnitDistance;
	setting.rayleighHeight = mRayleighHeight * mUnitDistance;
	setting.earthRadius = mEarthRadius * mUnitDistance;
	setting.earthAtmTopRadius = mEarthAtmoRadius * mUnitDistance;
	setting.earthCenter = float3(0, -setting.earthRadius, 0);
	setting.waveLambdaMie = mieLambda;
	setting.waveLambdaOzone = mOzoneScatteringCoeff * mOzoneMass;
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
	"Pass=DrawScattering;";
>{
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
	"Pass=DrawScattering;";
>{
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