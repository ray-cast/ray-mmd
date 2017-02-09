#include "../../ray.conf"
#include "../../ray_advanced.conf"
#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"
#include "shader/atmospheric.fxsub"

float3 LightSpecular : SPECULAR< string Object = "Light";>;
float3 LightDirection : DIRECTION< string Object = "Light";>;

void ScatteringFogVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float4 oTexcoord : TEXCOORD0,
	out float3 oViewdir  : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oViewdir = CameraPosition - Position.xyz;
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
	clip(sum(sum1) - 1e-5);
	
	float3 V = normalize(viewdir);
	
	ScatteringParams setting;
	setting.sunSize = 0.99;
	setting.sunRadiance = 10.0;
	setting.mieG = 0.76;
	setting.mieUpsilon = 4.0;
	setting.mieTurbidity = 1.0;
	setting.mieCoefficient = 0.005;
	setting.mieHeight = 1.25E3;
	setting.rayleighCoefficient = 2.0;
	setting.rayleighHeight = 8.4E3;
	setting.waveLambda = float3(680E-9, 550E-9, 450E-9);
	setting.waveLambdaMie = float3(0.686, 0.678, 0.666);
	setting.waveLambdaRayleigh = float3(94, 40, 18);
	setting.earthRadius = 6360e3;
	setting.earthAtmTopRadius = 6380e3;    
	setting.earthCenter = float3(0, -6360e3, 0);
	
	float3 fog = ComputeSkyFog(setting, materialAlpha.linearDepth, V, LightDirection);
	
	return float4(fog * LightSpecular, 0);
}

#define OBJECT_TEC(name, mmdpass) \
	technique name<string MMDPass = mmdpass; string Subset="0";>{\
		pass DrawObject {\
			ZEnable = false; ZWriteEnable = false;\
			AlphaBlendEnable = TRUE; AlphaTestEnable = FALSE;\
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