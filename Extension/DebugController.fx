#include "../shader/common.fx"
#include "../shader/math.fx"
#include "../shader/gbuffer.fx"
#include "../shader/gbuffer_sampler.fx"

float showAlbedo : CONTROLOBJECT < string name="(self)"; string item = "Albedo"; >;
float showNormal : CONTROLOBJECT < string name="(self)"; string item = "Normal"; >;
float showSpecular : CONTROLOBJECT < string name="(self)"; string item = "Specular"; >;
float showSmoothness : CONTROLOBJECT < string name="(self)"; string item = "Smoothness"; >;
float showTransmittance : CONTROLOBJECT < string name="(self)"; string item = "Transmittance"; >;
float showEmissive : CONTROLOBJECT < string name="(self)"; string item = "Emissive"; >;
float showDepth : CONTROLOBJECT < string name="(self)"; string item = "Depth"; >;

float showAlpha : CONTROLOBJECT < string name="(self)"; string item = "Alpha"; >;
float showAlbedoAlpha : CONTROLOBJECT < string name="(self)"; string item = "AlbedoAlpha"; >;
float showNormalAlpha : CONTROLOBJECT < string name="(self)"; string item = "NormalAlpha"; >;
float showSpecularAlpha : CONTROLOBJECT < string name="(self)"; string item = "SpecularAlpha"; >;
float showSmoothnessAlpha : CONTROLOBJECT < string name="(self)"; string item = "SmoothnessAlpha"; >;
float showDepthAlpha : CONTROLOBJECT < string name="(self)"; string item = "DepthAlpha"; >;

float showSSAO : CONTROLOBJECT < string name="(self)"; string item = "SSAO"; >;

shared texture2D OpaqueMap : RENDERCOLORTARGET;
sampler OpaqueSamp = sampler_state {
    texture = <OpaqueMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture2D SSAOMap : RENDERCOLORTARGET;
sampler SSAOMapSamp = sampler_state {
    texture = <SSAOMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

void DebugControllerVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD0,
    out float4 oTexcoord  : TEXCOORD0,
    out float4 oPosition  : POSITION)
{
    oTexcoord = Texcoord.xyxy + ViewportOffset.xyxy;
    oPosition = Position;
}

float4 DebugControllerPS(in float2 coord : TEXCOORD0) : COLOR 
{
    float4 MRT0 = tex2D(Gbuffer1Map, coord);
    float4 MRT1 = tex2D(Gbuffer2Map, coord);
    float4 MRT2 = tex2D(Gbuffer3Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, material);
    
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    
    float alphaDiffuse = 0;
    MaterialParam materialAlpha;
    DecodeGbufferWithAlpha(MRT5, MRT6, MRT7, materialAlpha, alphaDiffuse);
    
    float showTotal = showAlbedo + showNormal + showSpecular + showSmoothness + showTransmittance + showEmissive;
    showTotal += showAlbedoAlpha + showSpecularAlpha + showNormalAlpha + showSmoothnessAlpha;
    showTotal += showDepth + showDepthAlpha + showSSAO;
    
    float3 result = tex2D(OpaqueSamp, coord).rgb * (showTotal > 0.0 ? 0.0 : 1.0);
    result += material.albedo * showAlbedo;
    result += (material.normal * 0.5 + 0.5) * showNormal;
    result += material.specular * showSpecular;
    result += material.smoothness * showSmoothness;
    result += material.transmittance * showTransmittance;
    result += material.emissive * showEmissive;
    
    result += materialAlpha.albedo * showAlbedoAlpha;
    result += (materialAlpha.normal * 0.5 + 0.5) * showNormalAlpha;
    result += materialAlpha.specular * showSpecularAlpha;
    result += materialAlpha.smoothness * showSmoothnessAlpha;
    result = linear2srgb(result);
    
    result += alphaDiffuse * showAlpha;
    result += tex2D(Gbuffer4Map, coord).r / 200 * showDepth;
    result += tex2D(Gbuffer8Map, coord).r / 200 * showDepthAlpha;
    result += tex2D(SSAOMapSamp, coord).r * showSSAO;
    
    return float4(result, 1);
}

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass  = "scene";
    string ScriptOrder  = "postprocess";
> = 0.8;

technique DebugController <
    string Script = 
    "ScriptExternal=Color;"    
    "RenderColorTarget=;"
    "RenderDepthStencilTarget=;"
    "Pass=DebugController;"
    ;
> {
    pass DebugController < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false; AlphaTestEnable = false;
        ZEnable = False; ZWriteEnable = False;
        VertexShader = compile vs_3_0 DebugControllerVS();
        PixelShader  = compile ps_3_0 DebugControllerPS();
    }
}
