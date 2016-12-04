#include "../../ray.conf"
#include "../../shader/common.fxsub"
#include "../../shader/math.fxsub"
#include "../../shader/gbuffer.fxsub"
#include "../../shader/gbuffer_sampler.fxsub"

#if !defined(MIKUMIKUMOVING)
float showAlbedo : CONTROLOBJECT < string name="(self)"; string item = "Albedo"; >;
float showNormal : CONTROLOBJECT < string name="(self)"; string item = "Normal"; >;
float showSpecular : CONTROLOBJECT < string name="(self)"; string item = "Specular"; >;
float showSmoothness : CONTROLOBJECT < string name="(self)"; string item = "Smoothness"; >;
float showTransmittance : CONTROLOBJECT < string name="(self)"; string item = "Transmittance"; >;
float showCurvature : CONTROLOBJECT < string name="(self)"; string item = "Curvature"; >;
float showEmissive : CONTROLOBJECT < string name="(self)"; string item = "Emissive"; >;
float showDepth : CONTROLOBJECT < string name="(self)"; string item = "Depth"; >;

float showAlpha : CONTROLOBJECT < string name="(self)"; string item = "Alpha"; >;
float showAlbedoAlpha : CONTROLOBJECT < string name="(self)"; string item = "AlbedoAlpha"; >;
float showNormalAlpha : CONTROLOBJECT < string name="(self)"; string item = "NormalAlpha"; >;
float showSpecularAlpha : CONTROLOBJECT < string name="(self)"; string item = "SpecularAlpha"; >;
float showSmoothnessAlpha : CONTROLOBJECT < string name="(self)"; string item = "SmoothnessAlpha"; >;
float showTransmittanceAlpha : CONTROLOBJECT < string name="(self)"; string item = "TransmittanceAlpha"; >;
float showCurvatureAlpha : CONTROLOBJECT < string name="(self)"; string item = "CurvatureAlpha"; >;
float showEmissiveAlpha : CONTROLOBJECT < string name="(self)"; string item = "EmissiveAlpha"; >;
float showDepthAlpha : CONTROLOBJECT < string name="(self)"; string item = "DepthAlpha"; >;

float showSSAO : CONTROLOBJECT < string name="(self)"; string item = "SSAO"; >;
float showSSR : CONTROLOBJECT < string name="(self)"; string item = "SSR"; >;
float showPSSM : CONTROLOBJECT < string name="(self)"; string item = "PSSM"; >;
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
float showPSSM <string UIName = "showPSSM"; string UIWidget = "Slider"; bool UIVisible =  true; float UIMin = 0; float UIMax = 1;> = 0;
#endif

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

#if SSAO_QUALITY > 0
shared texture SSAOMap : RENDERCOLORTARGET;
sampler SSAOMapSamp = sampler_state {
    texture = <SSAOMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

#if SSR_QUALITY > 0
shared texture SSRayTracingMap: RENDERCOLORTARGET;
sampler SSRayTracingSamp = sampler_state {
    texture = <SSRayTracingMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

#if SHADOW_QUALITY > 0
shared texture PSSM : OFFSCREENRENDERTARGET;
sampler PSSMsamp = sampler_state {
    texture = <PSSM>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

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
    float4 MRT4 = tex2D(Gbuffer4Map, coord);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, MRT4, material);
    
    float4 MRT5 = tex2D(Gbuffer5Map, coord);
    float4 MRT6 = tex2D(Gbuffer6Map, coord);
    float4 MRT7 = tex2D(Gbuffer7Map, coord);
    float4 MRT8 = tex2D(Gbuffer8Map, coord);
    
    MaterialParam materialAlpha;
    DecodeGbuffer(MRT5, MRT6, MRT7, MRT8, materialAlpha);
    
    float showTotal = showAlbedo + showNormal + showSpecular + showSmoothness + showTransmittance + showCurvature + showEmissive;
    showTotal += showAlpha + showAlbedoAlpha + showSpecularAlpha + showNormalAlpha + showSmoothnessAlpha + showTransmittanceAlpha + showCurvatureAlpha + showEmissiveAlpha;
    showTotal += showDepth + showDepthAlpha + showSSAO + showSSR + showPSSM;
    
    float3 result = srgb2linear(tex2D(ScnSamp, coord).rgb) * !any(showTotal);
    result += material.albedo * showAlbedo;
    result += (mul(material.normal, (float3x3)matViewInverse).xyz * 0.5 + 0.5) * showNormal;
    result += material.specular * showSpecular;
    result += material.smoothness * showSmoothness;
    result += material.transmittance * showTransmittance;
    result += material.customData * showCurvature;
    result += material.emissive * showEmissive;
    
    result += materialAlpha.albedo * showAlbedoAlpha;
    result += (mul(materialAlpha.normal, (float3x3)matViewInverse).xyz * 0.5 + 0.5) * showNormalAlpha;
    result += materialAlpha.specular * showSpecularAlpha;
    result += materialAlpha.smoothness * showSmoothnessAlpha;
    result += materialAlpha.transmittance * showTransmittanceAlpha;
    result += material.customData * showCurvatureAlpha;
    result += materialAlpha.transmittance * showEmissiveAlpha;

    result = linear2srgb(result);

    result += materialAlpha.alpha * showAlpha;
    result += pow(material.linearDepth / 200, 0.5) * showDepth;
    result += pow(materialAlpha.linearDepth / 200, 0.5) * showDepthAlpha;

    #if SSAO_QUALITY > 0
        result += tex2D(SSAOMapSamp, coord).r * showSSAO;
    #endif

    #if SSR_QUALITY > 0
        result += tex2D(SSRayTracingSamp, coord).rgb * showSSR;
    #endif

    #if SHADOW_QUALITY > 0
        result += pow(tex2D(PSSMsamp, coord).r * 4, 10) * showPSSM;
    #endif

    return float4(result, 1);
}

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass  = "scene";
    string ScriptOrder  = "postprocess";
> = 0.8;

technique DebugController <
    string Script = 
    "RenderColorTarget0=ScnMap;"
    "RenderDepthStencilTarget=;"
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
