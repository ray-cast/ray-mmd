#include "Time of day.conf"

#include "../../shader/math.fxsub"
#include "../../shader/common.fxsub"
#include "../../shader/phasefunctions.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"
#include "../../shader/ibl.fxsub"

#include "shader/common.fxsub"
#include "shader/skylighting.fxsub"

float mEnvDiffLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight+";>;
float mEnvDiffLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvDiffLight-";>;
float mEnvSpecLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight+";>;
float mEnvSpecLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSpecLight-";>;
float mEnvSSSLightP : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight+";>;
float mEnvSSSLightM : CONTROLOBJECT<string name="(self)"; string item = "EnvSSSLight-";>;

static float mEnvIntensitySSS  = lerp(lerp(1, PI_2, mEnvSSSLightP),  0, mEnvSSSLightM);
static float mEnvIntensitySpec = lerp(lerp(1, PI_2, mEnvSpecLightP), 0, mEnvSpecLightM);
static float mEnvIntensityDiff = lerp(lerp(1, PI_2, mEnvDiffLightP), 0, mEnvDiffLightM);

#define IBL_MIPMAP_LEVEL 7

texture SpecularMap : RENDERCOLORTARGET<int2 Dimensions={ 512, 256 }; int Miplevels=0;>;
sampler SpecularMapSamp = sampler_state {
	texture = <SpecularMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = LINEAR;
	ADDRESSU = CLAMP; ADDRESSV = CLAMP;
};
texture DiffuseMap : RENDERCOLORTARGET<int2 Dimensions={ 512, 256 };>;
sampler DiffuseMapSamp = sampler_state {
	texture = <DiffuseMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
	ADDRESSU = CLAMP; ADDRESSV = CLAMP;
};

float4 ImageBasedLightClearCost(MaterialParam material, float3 N, float3 V, float3 prefilteredSpeculr)
{
	float fresnel = EnvironmentSpecularUnreal4(N, V, material.customDataA);
	return float4(prefilteredSpeculr, fresnel);
}

float3 ImageBasedLightSubsurface(MaterialParam material, float3 N, float3 prefilteredDiffuse)
{
	float3 dependentSplit = 0.5;
	float3 scattering = prefilteredDiffuse + DecodeRGBT(tex2Dlod(DiffuseMapSamp, float4(ComputeSphereCoord(-N), 0, 0)));
	scattering *= material.customDataB * material.customDataA * dependentSplit;
	return scattering * mEnvIntensitySSS;
}

float3 GetSpecularColor(float2 coord, float mipLayer, float3 fresnel, float roughness)
{
	float3 prefilteredSpeculr0 = DecodeRGBT(tex2Dlod(SpecularMapSamp, float4(coord, 0, mipLayer)));
	float3 prefilteredSpeculr1 = DecodeRGBT(tex2Dlod(DiffuseMapSamp, float4(coord, 0, 0)));
	float3 prefilteredSpeculr = 0;
	prefilteredSpeculr = lerp(prefilteredSpeculr0, prefilteredSpeculr1, roughness);
	prefilteredSpeculr = lerp(prefilteredSpeculr, prefilteredSpeculr1, pow2(1 - fresnel) * roughness);
	return prefilteredSpeculr;
}

void ShadingMaterial(MaterialParam material, float3 worldView, out float3 diffuse, out float3 specular)
{
	float3 worldNormal = mul(material.normal, (float3x3)matViewInverse);
	float3 worldReflect = EnvironmentReflect(worldNormal, worldView);

	float3 V = normalize(worldView);
	float3 N = normalize(worldNormal);
	float3 R = normalize(worldReflect);

	float roughness = max(SmoothnessToRoughness(material.smoothness), 0.001);
	N = ComputeDiffuseDominantDir(N, V, roughness);
	R = ComputeSpecularDominantDir(N, R, roughness);

	float mipLayer = EnvironmentMip(IBL_MIPMAP_LEVEL - 1, pow2(material.smoothness));
	float3 fresnel = EnvironmentSpecularUnreal4(worldNormal, worldView, material.smoothness, material.specular);

	float3 prefilteredDiffuse = DecodeRGBT(tex2Dlod(DiffuseMapSamp, float4(ComputeSphereCoord(N), 0, 0)));
	float3 prefilteredSpeculr = GetSpecularColor(ComputeSphereCoord(R), mipLayer, fresnel, roughness);

	diffuse = prefilteredDiffuse * mEnvIntensityDiff * saturate(1 - fresnel);

	[branch]
	if (material.lightModel == SHADINGMODELID_CLEAR_COAT)
	{
		float4 specular2 = ImageBasedLightClearCost(material, worldNormal, worldView, prefilteredSpeculr);
		specular = lerp(specular, specular2.rgb, specular2.a);
	}
	else if (material.lightModel == SHADINGMODELID_SKIN || 
			 material.lightModel == SHADINGMODELID_SUBSURFACE ||
			 material.lightModel == SHADINGMODELID_GLASS)
	{
		diffuse += ImageBasedLightSubsurface(material, N, prefilteredDiffuse);
	}

	specular = prefilteredSpeculr * fresnel * mEnvIntensitySpec;
}

void GenSpecularMapVS(
	in float4 Position : POSITION,
	out float4 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = oPosition = mul(Position * float4(2, 2, 2, 1), matViewProject);
	oTexcoord0.xy = PosToCoord(oTexcoord0.xy / oTexcoord0.w);
	oTexcoord0.xy = oTexcoord0.xy * oTexcoord0.w;
	oTexcoord1 = ComputeWaveLengthMie(mWaveLength, mMieColor, mMieTurbidity);
	oTexcoord2 = ComputeWaveLengthRayleigh(mWaveLength) * mRayleighColor;
}

float4 GenSpecularMapPS(
	in float4 coord : TEXCOORD0,
	in float3 mieLambda : TEXCOORD1,
	in float3 rayleight : TEXCOORD2) : COLOR0
{
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

	float3 V = ComputeSphereNormal(coord.xy / coord.w);
	float3 insctrColor = ComputeSkyInscattering(setting, CameraPosition + float3(0, mEarthPeopleHeight * mUnitDistance, 0), V, SunDirection).rgb;

	return EncodeRGBT(insctrColor);
}

void GenDiffuseMapVS(
	in float4 Position : POSITION,
	out float3 oTexcoord0 : TEXCOORD0,
	out float3 oTexcoord1 : TEXCOORD1,
	out float3 oTexcoord2 : TEXCOORD2,
	out float3 oTexcoord3 : TEXCOORD3,
	out float3 oTexcoord4 : TEXCOORD4,
	out float3 oTexcoord5 : TEXCOORD5,
	out float4 oTexcoord6 : TEXCOORD6,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = SHSamples(SpecularMapSamp, 0);
	oTexcoord1 = SHSamples(SpecularMapSamp, 1);
	oTexcoord2 = SHSamples(SpecularMapSamp, 2);
	oTexcoord3 = SHSamples(SpecularMapSamp, 3);
	oTexcoord4 = SHSamples(SpecularMapSamp, 4);
	oTexcoord5 = SHSamples(SpecularMapSamp, 5);
	oTexcoord6 = oPosition = mul(Position * float4(2, 2, 2, 1), matViewProject);
	oTexcoord6.xy = (oTexcoord6.xy / oTexcoord6.w) * 0.5 + 0.5;
	oTexcoord6.xy = oTexcoord6.xy * oTexcoord6.w;
	oTexcoord6.z = oTexcoord6.w;
}

float4 GenDiffuseMapPS(
	in float3 SH0 : TEXCOORD0,
	in float3 SH1 : TEXCOORD1,
	in float3 SH2 : TEXCOORD2,
	in float3 SH3 : TEXCOORD3,
	in float3 SH4 : TEXCOORD4,
	in float3 SH5 : TEXCOORD5,
	in float4 coord : TEXCOORD6) : COLOR0
{
	float3 normal = ComputeSphereNormal(coord.xy / coord.z);
	float3 irradiance = SHCreateIrradiance(normal, SH0, SH1, SH2, SH3, SH4, SH5);

	return EncodeRGBT(irradiance / PI);
}

void EnvLightingVS(
	in float4 Position : POSITION,
	in float2 Texcoord : TEXCOORD0,
	out float4 oTexcoord : TEXCOORD0,
	out float3 oViewdir  : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oViewdir = normalize(CameraPosition - Position.xyz);
	oTexcoord = oPosition = mul(Position, matViewProject);
	oTexcoord.xy = PosToCoord(oTexcoord.xy / oTexcoord.w) + ViewportOffset;
	oTexcoord.xy = oTexcoord.xy * oTexcoord.w;
}

void EnvLightingPS(
	in float4 texcoord : TEXCOORD0,
	in float3 viewdir  : TEXCOORD1,
	in float4 screenPosition : SV_Position,
	out float4 oColor0 : COLOR0,
	out float4 oColor1 : COLOR1)
{
	float2 coord = texcoord.xy / texcoord.w;

	float4 MRT5 = tex2Dlod(Gbuffer5Map, float4(coord, 0, 0));
	float4 MRT6 = tex2Dlod(Gbuffer6Map, float4(coord, 0, 0));
	float4 MRT7 = tex2Dlod(Gbuffer7Map, float4(coord, 0, 0));
	float4 MRT8 = tex2Dlod(Gbuffer8Map, float4(coord, 0, 0));

	MaterialParam materialAlpha;
	DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);

	float3 sum1 = materialAlpha.albedo + materialAlpha.specular;
	clip(dot(sum1, 1) - 1e-5);

	float4 MRT1 = tex2Dlod(Gbuffer1Map, float4(coord, 0, 0));
	float4 MRT2 = tex2Dlod(Gbuffer2Map, float4(coord, 0, 0));
	float4 MRT3 = tex2Dlod(Gbuffer3Map, float4(coord, 0, 0));
	float4 MRT4 = tex2Dlod(Gbuffer4Map, float4(coord, 0, 0));

	MaterialParam material;
	DecodeGbuffer(MRT1, MRT2, MRT3, MRT4, material);

	float3 V = normalize(viewdir);

	float3 diffuse = 0, specular = 0;
	ShadingMaterial(material, V, diffuse, specular);

	float3 diffuse2, specular2;
	ShadingMaterial(materialAlpha, V, diffuse2, specular2);

	oColor0 = EncodeYcbcr(screenPosition, diffuse, specular);
	oColor1 = EncodeYcbcr(screenPosition, diffuse2, specular2);
}

const float4 BackColor = float4(0,0,0,0);
const float4 IBLColor  = float4(0,0.5,0,0.5);

shared texture EnvLightAlphaMap : RENDERCOLORTARGET;

#define OBJECT_TEC(name, mmdpass) \
	technique name < string MMDPass = mmdpass;  string Subset="0";\
	string Script = \
		"ClearSetColor=BackColor;"\
		"RenderColorTarget=LightAlphaMap;"\
		"Clear=Color;"\
		"RenderColorTarget=LightSpecMap;"\
		"Clear=Color;"\
		"RenderColorTarget=SpecularMap;" \
		"Clear=Color;"\
		"Pass=GenSpecularMap;" \
		"RenderColorTarget=DiffuseMap;" \
		"Clear=Color;"\
		"Pass=GenDiffuseMap;" \
		"RenderColorTarget=;" \
		"RenderColorTarget1=EnvLightAlphaMap;" \
		"ClearSetColor=IBLColor;"\
		"Clear=Color;"\
		"Pass=ImageBasedLighting;" \
	;>{ \
		pass GenSpecularMap { \
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			VertexShader = compile vs_3_0 GenSpecularMapVS(); \
			PixelShader  = compile ps_3_0 GenSpecularMapPS(); \
		} \
		pass GenDiffuseMap { \
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			VertexShader = compile vs_3_0 GenDiffuseMapVS(); \
			PixelShader  = compile ps_3_0 GenDiffuseMapPS(); \
		} \
		pass ImageBasedLighting { \
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			CullMode = CCW;\
			VertexShader = compile vs_3_0 EnvLightingVS(); \
			PixelShader  = compile ps_3_0 EnvLightingPS(); \
		} \
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge";>{}
technique ShadowTech < string MMDPass = "shadow";>{}
technique ZplotTec < string MMDPass = "zplot";>{}