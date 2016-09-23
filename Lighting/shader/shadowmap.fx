#include "../../ray.conf"
#include "../../shader/math.fx"
#include "../../shader/common.fx"
#include "../../shader/shadowcommon.fx"

float mRangeP : CONTROLOBJECT < string name="(OffscreenOwner)"; string item = "Range+"; >;
float mAngleM : CONTROLOBJECT < string name="(OffscreenOwner)"; string item = "Angle-"; >;
float mIntensityM : CONTROLOBJECT < string name="(OffscreenOwner)"; string item = "Intensity-"; >;
float3 mPosition : CONTROLOBJECT < string name="(OffscreenOwner)"; string item = "Position"; >;
float3 mDirection : CONTROLOBJECT < string name="(OffscreenOwner)"; string item = "Direction"; >;

static float LightSpotAngle = radians(lerp(60.0f, 0.0f, mAngleM));
static float3 LightDirection = normalize(mDirection - mPosition);
static float3 LightPosition = mPosition;

texture DiffuseMap : MATERIALTEXTURE;
sampler DiffuseMapSamp = sampler_state 
{
    texture = <DiffuseMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

void ShadowMapVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord0 : TEXCOORD0,
    out float4 oTexcoord1 : TEXCOORD1,
    out float4 oPosition : POSITION)
{
    oTexcoord0 = Texcoord;
    oPosition = mul(Position, GetLightViewMatrix(LightDirection, LightPosition));
    oPosition = oTexcoord1 = CalcLightProjPos(LightSpotAngle, LightPlaneNear, LightPlaneFar, oPosition);
}

float4 ShadowMapPS(in float4 coord : TEXCOORD0, in float4 position : TEXCOORD1, uniform bool useTexture) : COLOR
{
    clip(!opadd - 0.001f);
    
    float alpha = MaterialDiffuse.a;
    if ( useTexture ) alpha *= tex2D(DiffuseMapSamp, coord).a;
    clip(alpha - CasterAlphaThreshold);

    return exp(position.z * 0.5);
}

#define OBJECT_TEC(name, mmdpass, tex) \
    technique name < string MMDPass = mmdpass; bool UseTexture = tex; \
    > { \
        pass DrawObject {\
            AlphaBlendEnable = FALSE; AlphaTestEnable = FALSE;\
            VertexShader = compile vs_3_0 ShadowMapVS();\
            PixelShader  = compile ps_3_0 ShadowMapPS(tex);\
        }\
    }

OBJECT_TEC(DepthTec0, "object", false)
OBJECT_TEC(DepthTec1, "object", true)
OBJECT_TEC(DepthTecSS0, "object_ss", false)
OBJECT_TEC(DepthTecSS1, "object_ss", true)

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTec < string MMDPass = "shadow"; > {}
technique ZplotTec < string MMDPass = "zplot"; > {}