#define MIDPOINT_8_BIT (127.0f / 255.0f)

shared texture LightSpecMap : RENDERCOLORTARGET;
shared texture LightAlphaMap : RENDERCOLORTARGET;
shared texture EnvLightAlphaMap : RENDERCOLORTARGET;

const float4 BackColor = float4(0,0,0,0);
const float4 IBLColor = float4(0, MIDPOINT_8_BIT, 0, MIDPOINT_8_BIT);

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass;\
    string Script = \
        "ClearSetColor=BackColor;"\
        "RenderColorTarget0=LightAlphaMap;"\
        "Clear=Color;"\
        "RenderColorTarget0=LightSpecMap;"\
        "Clear=Color;"\
        "RenderColorTarget0=EnvLightAlphaMap;" \
        "ClearSetColor=IBLColor;"\
        "Clear=Color;"\
    ;> { \
    }

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTech < string MMDPass = "shadow";  > {}
technique ZplotTec < string MMDPass = "zplot"; > {}