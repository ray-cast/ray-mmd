float4x4 matView               : VIEW;
float4x4 matViewInverse        : VIEWINVERSE;
float4x4 matProject            : PROJECTION;
float4x4 matProjectInverse     : PROJECTIONINVERSE;
float4x4 matViewProject        : VIEWPROJECTION;
float4x4 matViewProjectInverse : VIEWPROJECTIONINVERSE;

float4 MaterialDiffuse  : DIFFUSE<string Object = "Geometry";>;
float3 MaterialSpecular : SPECULAR<string Object = "Geometry";>;
float  MaterialPower    : SPECULARPOWER<string Object = "Geometry";>;

float2 ViewportSize : VIEWPORTPIXELSIZE;

static float2 ViewportOffset  = 0.5 / ViewportSize;
static float2 ViewportOffset2 = 1.0 / ViewportSize;
static float  ViewportAspect  = ViewportSize.x / ViewportSize.y;

uniform bool use_texture;
uniform bool use_subtexture;
uniform bool use_spheremap;
uniform bool use_toon;

texture DiffuseMap : MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state
{
	texture = <DiffuseMap>;
	MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = POINT;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

texture ToonMap : MATERIALTOONTEXTURE;
sampler ToonMapSamp = sampler_state
{
	texture = <ToonMap>;
	MINFILTER = POINT; MAGFILTER = POINT; MIPFILTER = POINT;
	ADDRESSU = WRAP; ADDRESSV = WRAP;
};

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
	oPosition = float4(CoordToPos(oTexcoord1.xy) / float2(ViewportAspect, 1), 0, 1);
}

float4 DrawObjectPS(float4 texcoord : TEXCOORD0, float4 texcoord1 : TEXCOORD1) : COLOR
{
#if DISCARD_ALPHA_ENABLE
	float alpha = MaterialDiffuse.a;
#if DISCARD_ALPHA_MAP_ENABLE
	if (use_texture) alpha *= tex2D(DiffuseMapSamp, texcoord.xy).a;
#endif
	clip(alpha - DiscardAlphaThreshold);
#endif
	return float4(0,0,0,0);
}

#define OBJECT_TEC(name, mmdpass)\
	technique name<string MMDPass = mmdpass;\
	>{\
		pass DrawObject {\
			AlphaBlendEnable = false; AlphaTestEnable = false;\
			ZEnable = true; ZWriteEnable = true;\
			FillMode = WIREFRAME;\
			CullMode = NONE;\
			VertexShader = compile vs_3_0 DrawObjectVS();\
			PixelShader = compile ps_3_0 DrawObjectPS();\
		}\
	}

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec<string MMDPass = "edge";>{}
technique ZplotTec<string MMDPass = "zplot";>{}
technique ShadowTech<string MMDPass = "shadow";>{}