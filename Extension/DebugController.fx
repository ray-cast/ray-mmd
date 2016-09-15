#include "../shader/common.fx"
#include "../shader/math.fx"
#include "../shader/gbuffer.fx"
#include "../shader/gbuffer_sampler.fx"

#if !defined(MIKUMIKUMOVING)
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
float showEmissiveAlpha : CONTROLOBJECT < string name="(self)"; string item = "EmissiveAlpha"; >;
float showDepthAlpha : CONTROLOBJECT < string name="(self)"; string item = "DepthAlpha"; >;

float showSSAO : CONTROLOBJECT < string name="(self)"; string item = "SSAO"; >;
float showSSR : CONTROLOBJECT < string name="(self)"; string item = "SSR"; >;
#else
float showAlbedo <string UIName = "showAlbedo"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showNormal <string UIName = "showNormal"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSpecular <string UIName = "showSpecular"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSmoothness <string UIName = "showSmoothness"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showTransmittance <string UIName = "showTransmittance"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showEmissive <string UIName = "showEmissive"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showDepth <string UIName = "showDepth"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showAlpha <string UIName = "showAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showAlbedoAlpha <string UIName = "showAlbedoAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showNormalAlpha <string UIName = "showNormalAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSpecularAlpha <string UIName = "showSpecularAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSmoothnessAlpha <string UIName = "showSmoothnessAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showEmissiveAlpha <string UIName = "showEmissiveAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showDepthAlpha <string UIName = "showDepthAlpha"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSSAO <string UIName = "showSSAO"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
float showSSR <string UIName = "showSSR"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
#endif

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
    showTotal += showAlbedoAlpha + showSpecularAlpha + showNormalAlpha + showSmoothnessAlpha + showEmissiveAlpha;
    showTotal += showDepth + showDepthAlpha + showSSAO + showSSR;
    
    float3 result = srgb2linear(tex2D(OpaqueSamp, coord).rgb) * !any(showTotal);
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
    result += materialAlpha.emissive * showEmissiveAlpha;
        
    result = linear2srgb(result);
    
    result += alphaDiffuse * showAlpha;
    result += pow(tex2D(Gbuffer4Map, coord).r / 200, 0.5) * showDepth;
    result += pow(tex2D(Gbuffer8Map, coord).r / 200, 0.5) * showDepthAlpha;
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
