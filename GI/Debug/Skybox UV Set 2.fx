float time : TIME;
float elapsed : ELAPSEDTIME;

float2 MousePosition : MOUSEPOSITION;

float4x4 matWorld              : WORLD;
float4x4 matWorldInverse       : WORLDINVERSE;
float4x4 matWorldView          : WORLDVIEW;
float4x4 matWorldViewProject   : WORLDVIEWPROJECTION;
float4x4 matView               : VIEW;
float4x4 matViewInverse        : VIEWINVERSE;
float4x4 matProject            : PROJECTION;
float4x4 matProjectInverse     : PROJECTIONINVERSE;
float4x4 matViewProject        : VIEWPROJECTION;
float4x4 matViewProjectInverse : VIEWPROJECTIONINVERSE;

float3 CameraPosition  : POSITION<string Object = "Camera";>;
float3 CameraDirection : DIRECTION<string Object = "Camera";>;

float4 MaterialDiffuse  : DIFFUSE<string Object = "Geometry";>;
float3 MaterialAmbient  : AMBIENT<string Object = "Geometry";>;
float4 MaterialEmissive  : EMISSIVE<string Object = "Geometry";>;
float3 MaterialSpecular : SPECULAR<string Object = "Geometry";>;
float3 MaterialToon     : TOONCOLOR;
float  MaterialPower    : SPECULARPOWER<string Object = "Geometry";>;

float2 ViewportSize : VIEWPORTPIXELSIZE;

static float2 ViewportOffset  = 0.5 / ViewportSize;
static float2 ViewportOffset2 = 1.0 / ViewportSize;
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

uniform bool use_texture;
uniform bool use_subtexture;
uniform bool use_spheremap;
uniform bool use_toon;

uniform bool opadd;

texture DiffuseMap : MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
	texture = <DiffuseMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

texture SphereMap : MATERIALSPHEREMAP;
sampler ToonMapSamp = sampler_state
{
	texture = <SphereMap>;
	MINFILTER = LINEAR; MAGFILTER = LINEAR; MIPFILTER = NONE;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

#define MIDPOINT_8_BIT (127.0f / 255.0f)

float3 rgb2ycbcr(float3 col)
{
	float3 encode;
	encode.x = dot(float3(0.299, 0.587, 0.114),   col.rgb);
	encode.y = dot(float3(-0.1687, -0.3312, 0.5), col.rgb) * MIDPOINT_8_BIT + MIDPOINT_8_BIT;
	encode.z = dot(float3(0.5, -0.4186, -0.0813), col.rgb) * MIDPOINT_8_BIT + MIDPOINT_8_BIT;
	return encode;
}

float4 EncodeYcbcr(float4 screenPosition, float3 color1, float3 color2)
{
	bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));

	color1 = rgb2ycbcr(color1);
	color2 = rgb2ycbcr(color2);

	float4 result = 0.0f;
	result.r = color1.r;
	result.g = (pattern) ? color1.g: color1.b;
	result.b = color2.r;
	result.a = (pattern) ? color2.g: color2.b;
	return result;  
}

float2 PosToCoord(float2 position)
{
	position = position * 0.5 + 0.5;
	return float2(position.x, 1 - position.y);
}

float2 CoordToPos(float2 coord)
{
	coord.y = 1 - coord.y;
	return coord * 2 - 1;
}

float3 DecodeRGBT(float4 rgbt, float range = 1024)
{
	rgbt.a = rgbt.a / (1 + 1 / range - rgbt.a);
	return rgbt.rgb * rgbt.a;
}

float3 TonemapACES(float3 x)
{
	const float A = 2.51f;
	const float B = 0.03f;
	const float C = 2.43f;
	const float D = 0.59f;
	const float E = 0.14f;
	return (x * (A * x + B)) / (x * (C * x + D) + E);
}

void DrawObjectVS(
	in float4 Position : POSITION,
	in float4 Texcoord0 : TEXCOORD0,
	in float4 Texcoord1 : TEXCOORD1,
	out float4 oTexcoord0 : TEXCOORD0,
	out float4 oTexcoord1 : TEXCOORD1,
	out float4 oPosition : POSITION)
{
	oTexcoord0 = Texcoord0;
	oTexcoord1 = Texcoord1;
	oPosition = mul(Position, matViewProject);
}

void DrawObjectPS(
	float4 texcoord : TEXCOORD0, 
	float4 texcoord1 : TEXCOORD1,
	out float4 oColor0 : COLOR0,
	out float4 oColor1 : COLOR1,
	float4 screenPosition : SV_Position)
{
#if DISCARD_ALPHA_ENABLE
	float alpha = MaterialDiffuse.a;
#if DISCARD_ALPHA_MAP_ENABLE
	if (use_texture) alpha *= tex2D(DiffuseMapSamp, texcoord.xy).a;
#endif
	clip(alpha - DiscardAlphaThreshold);
#endif
	
	float3 lightng = DecodeRGBT(tex2D(ToonMapSamp, texcoord1.xy));
	
	oColor0 = EncodeYcbcr(screenPosition, lightng * 2, 0);
	oColor1 = EncodeYcbcr(screenPosition, lightng * 2, 0);
}

#define OBJECT_TEC(name, mmdpass)\
	technique name<string MMDPass = mmdpass;\
	>{\
		pass DrawObject {\
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			ZEnable = true; ZWriteEnable = true;\
			VertexShader = compile vs_3_0 DrawObjectVS();\
			PixelShader = compile ps_3_0 DrawObjectPS();\
		}\
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ZplotTec<string MMDPass = "zplot";>{}
technique ShadowTech<string MMDPass = "shadow";>{}