#include "../shader/common.fx"
#include "../shader/math.fx"
#include "../shader/gbuffer.fx"
#include "../shader/gbuffer_sampler.fx"

texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "X8R8G8B8";
>;
sampler ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
texture2D LinearDepthMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    string Format = "G16R16F";
>;
sampler2D LinearDepthSamp = sampler_state {
    texture = <LinearDepthMap>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = LINEAR;
    AddressU  = Clamp; AddressV = Clamp;
};
texture2D DownsampleMapX1 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 0;
    string Format = "X8R8G8B8";
>;
texture2D DownsampleMapX1Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
    string Format = "X8R8G8B8";
>;
sampler2D DownsampleSampX1 = sampler_state {
    texture = <DownsampleMapX1>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = LINEAR;
    AddressU  = Clamp; AddressV = Clamp;
};
sampler2D DownsampleSampX1Temp = sampler_state {
    texture = <DownsampleMapX1Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = LINEAR;
    AddressU  = Clamp; AddressV = Clamp;
};

float mFocalDepth : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalDepth"; >;
float mFocalLengthP : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalLength+"; >;
float mFocalLengthM : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalLength-"; >;
float mFocalStop : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalStop"; >;
float mFocalShow : CONTROLOBJECT < string name="BokehController.pmx"; string item = "FocalShow"; >;
float mBokehThreshold : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehThreshold"; >;
float mBokehIntensity : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehIntensity"; >;
float mBokehRadius : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehRadius"; >;
float mBokehInner : CONTROLOBJECT < string name="BokehController.pmx"; string item = "BokehInner"; >;

static float focalDepth = 10 + mFocalDepth * 500;
static float focalLength = max(0, (mFocalLengthP - mFocalLengthM) * 500);
static float focalStop = (1 + mFocalStop) * 5;
static float focusShow = mFocalShow;

static float bokehRadius = (1 + mBokehRadius * 2);
static float bokehInner = (0.5 + mBokehInner);
static float bokehIntensity = mBokehIntensity * 10;
static float bokehThreshold = (1.0 - mBokehThreshold);

#define RINGS_SAMPLER_COUNT 5
#define RINGS_SAMPLER_COUNT2 6

float CoC = 0.03;

float4 GlareDetection(sampler2D source, float2 coord, float radius)
{
    float3 col = tex2Dlod(source, float4(coord, 0, radius)).rgb;
    float3 bloom = max(0, col - bokehThreshold);
    return float4(col + bloom * bokehIntensity, 1);
}

void DofComputeCocVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float2 oTexcoord  : TEXCOORD0,
    out float4 oPosition  : POSITION)
{
    oTexcoord = Texcoord.xy + ViewportOffset.xy;
    oPosition = Position;
}

float4 DofComputeCocPS(in float2 coord  : TEXCOORD0) : COLOR0
{
    float2 wh = ViewportOffset2 * 1.25;
    
    float2 offset[9];    
    offset[0] = float2(-wh.x,-wh.y);
    offset[1] = float2( 0.0, -wh.y);
    offset[2] = float2( wh.x, -wh.y);
    
    offset[3] = float2(-wh.x,  0.0);
    offset[4] = float2( 0.0,   0.0);
    offset[5] = float2( wh.x,  0.0);
    
    offset[6] = float2(-wh.x, wh.y);
    offset[7] = float2( 0.0,  wh.y);
    offset[8] = float2( wh.x, wh.y);
    
    float kernel[9];
    kernel[0] = 1.0/16.0;   kernel[1] = 2.0/16.0;   kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;   kernel[4] = 4.0/16.0;   kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;   kernel[7] = 2.0/16.0;   kernel[8] = 1.0/16.0;
    
    float depth = 0;
    for (int i = 0; i < 9; i++)
    {
        float tmp = tex2D(Gbuffer4Map, coord + offset[i]).r;
        depth += tmp * kernel[i];
    }
    
    float f = focalLength;
    float d = focalDepth * 1000.0;
    float o = depth * 1000.0;
    
    float a = (o * f) / (o - f);
    float b = (d * f) / (d - f); 
    float c = (d - f) / (d * focalStop * CoC);
    
    float blur = saturate((b - a) * c);
    
    return float4(depth, blur, 0, 0);
}

void DofDownsampleBlurVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD,
    out float4 oTexcoord : TEXCOORD0,
    out float4 oPosition : POSITION)
{
    oPosition = Position;
    oTexcoord = Texcoord;
    oTexcoord.xy += ViewportOffset;
}

float4 DofDownsampleBlurPS(in float2 coord : TEXCOORD0, uniform sampler2D source, uniform float2 offset, uniform int n) : COLOR0
{
    float weight = 0.0;
    float4 color = 0.0f;
    
    for (int i = 0; i < n; ++i)
    {
        float w = 0.39894 * exp(-i * i / (n * n)) / n;
        color += tex2D(source, coord + offset * i) * w;
        color += tex2D(source, coord - offset * i) * w;
        weight += 2.0 * w;
    }

    return tex2D(source, coord);
}

float4 ShowDebugFocus(float4 color, float depth, float blur)
{
    float edge = 0.002 * depth;
    float m = 1.0 - clamp(smoothstep(0.0, edge, blur), 0.0, 1.0);
    float e = 1.0 - clamp(smoothstep(1.0 - edge, 1.0, blur), 0.0, 1.0);
    
    color = lerp(color, float4(1.0, 0.0, 0.0, 1.0), abs(min(0.0, (e - m) * 3)));
    color = lerp(color, float4(0.0, 1.0, 0.0, 1.0), e);
    return color;
}

void DepthOfFieldVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float4 oPosition  : POSITION)
{
    oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy;
    oPosition = Position;
}

float4 DepthOfFieldPS(in float2 coord : TEXCOORD) : COLOR0
{
    float2 depth = tex2D(LinearDepthSamp, coord).rg;
          
    float radius = depth.g * bokehRadius;
    float bias = bokehInner;
    
    float4 totalWeight = 1.0;
    float4 totalColor = tex2D(DownsampleSampX1, coord);
    
    for (int i = 1; i <= RINGS_SAMPLER_COUNT; i++)
    {   
        int ringsamples = i * RINGS_SAMPLER_COUNT2;
        
        for (int j = 0 ; j < ringsamples ; j++)   
        {
            float step = PI * 2.0 / float(ringsamples);
            float pw = (cos(step * j) * i);
            float ph = (sin(step * j) * i);
            
            float4 col = GlareDetection(DownsampleSampX1, coord + float2(pw, ph) * ViewportOffset2 * radius, radius);
            
            float weight = max(0, lerp(1.0, (float(i)) / (float(RINGS_SAMPLER_COUNT)), bias));
            float4 bokeh = pow(col * col * 1.5, 10.0) * radius * 500.0 + 0.4;
            
            totalColor += col * bokeh * weight;
            totalWeight += bokeh * weight;
        }
    }
    
    totalColor /= totalWeight;
    totalColor = lerp(totalColor, ShowDebugFocus(totalColor, depth.r, depth.g), focusShow);
    
    return totalColor;
}

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass  = "scene";
    string ScriptOrder  = "postprocess";
> = 0.8;

technique DepthOfField <
    string Script = 
    "RenderColorTarget0=ScnMap;"
    "RenderDepthStencilTarget=;"
    "ScriptExternal=Color;"
    
    "RenderColorTarget=LinearDepthMap;"
    "Pass=DofComputeCoc;"
       
    "RenderColorTarget=DownsampleMapX1Temp; Pass=DofDownsampleBlurX;"
    "RenderColorTarget=DownsampleMapX1;     Pass=DofDownsampleBlurY;"
    
    "RenderColorTarget=;"
    "Pass=DepthOfField;"
    ;
> {
    pass DofComputeCoc < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofComputeCocVS();
        PixelShader  = compile ps_3_0 DofComputeCocPS();
    }
    pass DofDownsampleBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleBlurVS();
        PixelShader  = compile ps_3_0 DofDownsampleBlurPS(ScnSamp, float2(ViewportOffset2.x, 0), 3);
    }
    pass DofDownsampleBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DofDownsampleBlurVS();
        PixelShader  = compile ps_3_0 DofDownsampleBlurPS(DownsampleSampX1Temp, float2(0, ViewportOffset2.y), 3);
    }
    pass DepthOfField < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DepthOfFieldVS();
        PixelShader  = compile ps_3_0 DepthOfFieldPS();
    }
}