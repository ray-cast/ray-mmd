#include "shader/math.fxsub"
#include "shader/common.fxsub"
#include "shader/phase.fxsub"
#include "shader/fog.fxsub"

#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"

void ScatteringFogVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float4 oTexcoord : TEXCOORD0,
	out float3 oTexcoord0  : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = normalize(Position.xyz - CameraPosition);
	oTexcoord = oPosition = mul(Position, matWorldViewProject);
}

float4 ScatteringFogPS(
	in float4 texcoord : TEXCOORD0,
	in float3 viewdir  : TEXCOORD1) : COLOR
{
	float2 coord = texcoord.xy / texcoord.w;
	coord = PosToCoord(coord);
	coord += ViewportOffset;

	float4 MRT5 = tex2Dlod(Gbuffer5Map, float4(coord, 0, 0));
	float4 MRT6 = tex2Dlod(Gbuffer6Map, float4(coord, 0, 0));
	float4 MRT7 = tex2Dlod(Gbuffer7Map, float4(coord, 0, 0));
	float4 MRT8 = tex2Dlod(Gbuffer8Map, float4(coord, 0, 0));

	MaterialParam materialAlpha;
	DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);

	float3 sum1 = materialAlpha.albedo + materialAlpha.specular;
	clip(dot(sum1, 1.0) - 1e-5);

	float3 V = normalize(viewdir);

	float scaling = 1000;

	ScatteringParams setting;
	setting.sunSize = mSunRadius;
	setting.sunRadiance = mSunRadiance;
	setting.mieG = mMiePhase;
	setting.mieHeight = mMieHeight * scaling;
	setting.rayleighHeight = mRayleighHeight * scaling;
	setting.waveLambdaMie = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity * scaling, 4);
	setting.waveLambdaRayleigh = ComputeWaveLengthRayleigh(mWaveLength) * mRayleighColor;

	float3 fog = ComputeSkyFog(setting, materialAlpha.linearDepth, V, LightDirection);	
	return float4(fog * LightSpecular, 0);
}

#define OBJECT_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass;>{\
		pass DrawObject {\
			ZEnable = false; ZWriteEnable = false;\
			AlphaBlendEnable = true; AlphaTestEnable = false;\
			SrcBlend = ONE; DestBlend = ONE;\
			CullMode = NONE;\
			VertexShader = compile vs_3_0 ScatteringFogVS();\
			PixelShader  = compile ps_3_0 ScatteringFogPS();\
		}\
	}

OBJECT_TEC(FogTec0, "object")
OBJECT_TEC(FogTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";> {}
technique ShadowTech<string MMDPass = "shadow";> {}
technique ZplotTec<string MMDPass = "zplot";> {}
technique MainTec1<string MMDPass = "object";> {}
technique MainTecBS1<string MMDPass = "object_ss";> {}