#include "../../shader/math.fx"
#include "../../shader/common.fx"
#include "../../shader/gbuffer.fx"
#include "../../shader/gbuffer_sampler.fx"

texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "X8R8G8B8";
>;
texture2D DownsampleX0Map : RENDERCOLORTARGET <
    float2 ViewportRatio = {1.0, 1.0};
    bool AntiAlias = false;
    int MipLevels = 0;
    string Format = "A16B16G16R16F";
>;
texture2D DownsampleX1Map : RENDERCOLORTARGET <
    float2 ViewportRatio = {0.5, 0.5};
    bool AntiAlias = false;
    int MipLevels = 0;
    string Format = "A16B16G16R16F";
>;
texture2D DofFontBlurMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "A2B10G10R10";
>;
texture2D DofFarBlurMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "A2B10G10R10";
>;
sampler ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler DownsampleX0MapSamp = sampler_state {
    texture = <DownsampleX0Map>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU = BORDER; AddressV = BORDER; BorderColor = float4(0,0,0,0);
};
sampler DownsampleX1MapSamp = sampler_state {
    texture = <DownsampleX1Map>;
    MinFilter = POINT; MagFilter = POINT; MipFilter = LINEAR;
    AddressU = BORDER; AddressV = BORDER; BorderColor = float4(0,0,0,0);
};
sampler DofFontBlurMapSamp = sampler_state {
    texture = <DofFontBlurMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler DofFarBlurMapSamp = sampler_state {
    texture = <DofFarBlurMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

float mFocalDepth : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalDepth"; >;
float mFocalLengthP : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalLength+"; >;
float mFocalLengthM : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalLength-"; >;
float mFocalShow : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalShow"; >;
float mBokehIntensity : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehIntensity"; >;
float mBokehRadius : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehRadius"; >;
float mBokehInner : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehInner"; >;

float3 FocusPosition : CONTROLOBJECT < string name = "BokehBlur.x";>;

static float FocusDistance = length(FocusPosition - CameraPosition);

static float focalDepth = max(1, FocusDistance);
static float focalLength = max(0, 30 + (mFocalLengthP - mFocalLengthM) * 30);
static float focusShow = mFocalShow;

static float bokehRadius = (1 + mBokehRadius * 2);
static float bokehInner = (0.5 + mBokehInner);
static float bokehIntensity = mBokehIntensity * 10;

#define RINGS_SAMPLER_COUNT 5
#define RINGS_SAMPLER_COUNT2 6

float GetFocusDistance()
{
    float FocusDistance = distance(FocusPosition, CameraPosition);
    return FocusDistance;
}

float GetLinearDepth(sampler source, float2 coord, float2 offset)
{
    float2 wh = offset * 1.5;
    
    float2 offsets[9];    
    offsets[0] = float2(-wh.x, -wh.y);
    offsets[1] = float2( 0.0,  -wh.y);
    offsets[2] = float2( wh.x, -wh.y);
    
    offsets[3] = float2(-wh.x,  0.0);
    offsets[4] = float2( 0.0,   0.0);
    offsets[5] = float2( wh.x,  0.0);
    
    offsets[6] = float2(-wh.x, wh.y);
    offsets[7] = float2( 0.0,  wh.y);
    offsets[8] = float2( wh.x, wh.y);
    
    float kernel[9];
    kernel[0] = 1.0 / 16.0;   kernel[1] = 2.0 / 16.0;   kernel[2] = 1.0 / 16.0;
    kernel[3] = 2.0 / 16.0;   kernel[4] = 4.0 / 16.0;   kernel[5] = 2.0 / 16.0;
    kernel[6] = 1.0 / 16.0;   kernel[7] = 2.0 / 16.0;   kernel[8] = 1.0 / 16.0;
    
    float depth = 0;
    
    [unroll]
    for (int i = 0; i < 9; i++)
    {
        float tmp = tex2D(source, coord + offsets[i]).r;
        depth += tmp * kernel[i];
    }
    
    return depth;
}

float CalcFocusBlur(float depth)
{
    float CoC = 0.03;
    
    float f = focalLength;
    float d = focalDepth * 1000;
    float o = depth * 1000;
    
    float a = (o * f) / (o - f);
    float b = (d * f) / (d - f); 
    float c = (d - f) / (d * CoC);
    
    return (b - a) * c;
}

void DofDownsampleVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD,
    out float4 oTexcoord0 : TEXCOORD0,
    out float4 oTexcoord1 : TEXCOORD1,
    out float4 oTexcoord2 : TEXCOORD2,
    out float4 oPosition : POSITION,
    uniform float2 offset)
{
    oPosition = Position;   
    oTexcoord0 = Texcoord + (offset * 0.5).xyxy;
    oTexcoord1 = oTexcoord0.xyxy + offset.xyxy * float4(-1,-1, -1, 1);
    oTexcoord2 = oTexcoord0.xyxy + offset.xyxy * float4( 1,-1,  1, 1);
}

float4 DofComputeCocPS(
    in float4 coord0 : TEXCOORD0,
    in float4 coord1 : TEXCOORD1,
    in float4 coord2 : TEXCOORD2) : COLOR0
{
    float depth = GetLinearDepth(Gbuffer4Map, coord0.xy, ViewportOffset2);
    float blur = CalcFocusBlur(depth);
    
    float3 color = tex2D(ScnSamp, coord0.xy).rgb;
    color = srgb2linear(color);
    
    return float4(color, blur);
}

float4 DofDownsamplePS(
    in float4 coord0 : TEXCOORD0,
    in float4 coord1 : TEXCOORD1,
    in float4 coord2 : TEXCOORD2,
    uniform sampler source) : COLOR0
{
    float4 color = 0;
    color += tex2D(source, coord1.xy);
    color += tex2D(source, coord1.zw);
    color += tex2D(source, coord2.xy);
    color += tex2D(source, coord2.zw);
    
    return color /= 4;
}

float4 DofFrontBlurPS(
    in float4 coord0 : TEXCOORD0,
    in float4 coord1 : TEXCOORD1,
    in float4 coord2 : TEXCOORD2,
    uniform sampler source) : COLOR0
{
    float4 color = 0;
    color += tex2D(source, coord1.xy);
    color += tex2D(source, coord1.zw);
    color += tex2D(source, coord2.xy);
    color += tex2D(source, coord2.zw);
    color /= 4;
    
    return color;
}

float3 ShowDebugFocus(float3 color, float blur)
{
    color = lerp(color, float3(1.0, 0.5, 0.0), -min(0, blur));
    color = lerp(color, float3(0.0, 0.5, 1.0), max(0, blur));
    return color;
}

float4 DofFarBlurPS(in float2 coord : TEXCOORD, uniform sampler source) : COLOR0
{       
    float4 totalWeight = 1.0;
    float4 totalColor = tex2D(source, coord);
    
    float radius = totalColor.a;
    float radiusScaled = radius * bokehRadius;
    float bias = bokehInner;
    
    for (int i = 1; i <= RINGS_SAMPLER_COUNT; i++)
    {   
        int ringsamples = i * RINGS_SAMPLER_COUNT2;
        
        for (int j = 0 ; j < ringsamples ; j++)   
        {
            float step = PI * 2.0 / float(ringsamples);
            float pw = (cos(step * j) * i);
            float ph = (sin(step * j) * i);
            
            float2 offset = float2(pw, ph) * ViewportOffset2 * radiusScaled * radiusScaled;
            
            float4 col0 = tex2Dlod(source, float4(coord + offset, 0, radiusScaled / 2));
            float4 color = col0;
            
            float weight = max(0, lerp(1.0, (float(i)) / (float(RINGS_SAMPLER_COUNT)), bias));
            float4 bokeh = pow(color * color * 1.5, 10.0) * radiusScaled * 500.0 + 0.4;
            
            totalColor += color * bokeh * weight;
            totalWeight += bokeh * weight;
        }
    }
    
    totalColor /= totalWeight;        
    return totalColor;
}

float4 DepthOfFieldPS(
    in float4 coord0 : TEXCOORD0,
    in float4 coord1 : TEXCOORD1,
    in float4 coord2 : TEXCOORD2) : COLOR0
{
    float4 Coc = tex2D(DownsampleX0MapSamp, coord0.xy);
    
    float3 color = Coc.rgb;
    
    float3 front = 0;
    front += tex2D(DofFontBlurMapSamp, coord1.xy).rgb;
    front += tex2D(DofFontBlurMapSamp, coord1.zw).rgb;
    front += tex2D(DofFontBlurMapSamp, coord2.xy).rgb;
    front += tex2D(DofFontBlurMapSamp, coord2.zw).rgb;
    front /= 4;
    
    float3 back = 0;
    back += tex2D(DofFarBlurMapSamp, coord1.xy).rgb;
    back += tex2D(DofFarBlurMapSamp, coord1.zw).rgb;
    back += tex2D(DofFarBlurMapSamp, coord2.xy).rgb;
    back += tex2D(DofFarBlurMapSamp, coord2.zw).rgb;
    back /= 4;
    
    color = lerp(color, back, saturate(Coc.a));
    color = lerp(color, front, saturate(-Coc.a));
    
    color = lerp(color, ShowDebugFocus(color, Coc.a), focusShow);
    color = linear2srgb(color);
    
    return float4(color, 1);
}

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass  = "scene";
    string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique DepthOfField <
    string Script = 
    "RenderColorTarget0=ScnMap;"
    "RenderDepthStencilTarget=;"
    "ClearSetColor=ClearColor;"
    "ClearSetDepth=ClearDepth;"
    "Clear=Color;"
    "Clear=Depth;"
    "ScriptExternal=Color;"
    
    "RenderColorTarget=DownsampleX0Map; Pass=DofComputeCoc;"
    "RenderColorTarget=DownsampleX1Map; Pass=DofDownsampleX1;"
    
    "RenderColorTarget=DofFontBlurMap; Pass=DofFrontBlur;"
    "RenderColorTarget=DofFarBlurMap;  Pass=DofFarBlur;"
    
    "RenderColorTarget=;"
    "Pass=DepthOfField;"
;> 
{
    pass DofComputeCoc < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 DofComputeCocPS();
    }
    pass DofDownsampleX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 DofDownsamplePS(DownsampleX0MapSamp);
    }
    pass DofFrontBlur < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 DofFrontBlurPS(DownsampleX1MapSamp);
    }
    pass DofFarBlur < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 DofFarBlurPS(DownsampleX0MapSamp);
    }
    pass DepthOfField < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleVS(ViewportOffset2);
        PixelShader  = compile ps_3_0 DepthOfFieldPS();
    }
}