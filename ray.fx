// +----------------------------------------------------------------------
// | Project : ray.
// | All rights reserved.
// +----------------------------------------------------------------------
// | Copyright (c) 2016-2017.
// +----------------------------------------------------------------------
// | * Redistribution and use of this software in source and binary forms,
// |   with or without modification, are permitted provided that the following
// |   conditions are met:
// |
// | * Redistributions of source code must retain the above
// |   copyright notice, this list of conditions and the
// |   following disclaimer.
// |
// | * Redistributions in binary form must reproduce the above
// |   copyright notice, this list of conditions and the
// |   following disclaimer in the documentation and/or other
// |   materials provided with the distribution.
// |
// | * Neither the name of the ray team, nor the names of its
// |   contributors may be used to endorse or promote products
// |   derived from this software without specific prior
// |   written permission of the ray team.
// |
// | THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// | "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// | LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// | A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// | OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// | SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// | LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// | DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// | THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// | (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// | OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// +----------------------------------------------------------------------
#include "ray.conf"

const float4 BackColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

float mDirectLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectLight+"; >;
float mDirectLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DirectLight-"; >;
float mIndirectLightP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "IndirectLight+"; >;
float mIndirectLightM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "IndirectLight-"; >;
float mSSAOP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO+"; >;
float mSSAOM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO-"; >;
float mSSAORadiusP : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO Radius+"; >;
float mSSAORadiusM : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "SSAO Radius-"; >;
float mExposure : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Exposure"; >;
float mVignette : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Vignette"; >;
float mDispersion : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "Dispersion"; >;
float mDispersionRadius : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "DispersionRadius"; >;
float mFilmGrain : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "FilmGrain"; >;
float mBloomThreshold : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomThreshold"; >;
float mBloomRadius : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomRadius"; >;
float mBloomIntensity : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "BloomIntensity"; >;
float mShoStrength : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "ShoStrength"; >;
float mLinStrength : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "LinStrength"; >;
float mLinWhite : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "LinWhite"; >;
float mToeNum : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "ToeNum"; >;
float mToneMapping : CONTROLOBJECT < string name="ray_controller.pmx"; string item = "ToneMapping"; >;

float mColBalanceR :  CONTROLOBJECT < string name="ColorBalance.pmx"; string item = "Red-"; >;
float mColBalanceG :  CONTROLOBJECT < string name="ColorBalance.pmx"; string item = "Green-"; >;
float mColBalanceB :  CONTROLOBJECT < string name="ColorBalance.pmx"; string item = "Blue-"; >;
float mColBalance  :  CONTROLOBJECT < string name="ColorBalance.pmx"; string item = "Weight"; >;

#include "shader/math.fx"
#include "shader/common.fx"
#include "shader/textures.fx"
#include "shader/gbuffer.fx"
#include "shader/lighting.fx"
#include "shadow/shadowmap.fxsub"
#include "shader/shading.fx"
#include "shader/ssao.fx"
#include "shader/ssss.fx"
#include "shader/ssr.fx"
#include "shader/fimic.fx"
#include "shader/fxaa.fx"

void ScreenSpaceQuadVS(
    in float4 Position : POSITION,
    in float4 Texcoord : TEXCOORD,
    out float4 oTexcoord : TEXCOORD0,
    out float3 oViewdir : TEXCOORD1,
    out float4 oPosition : SV_Position)
{
    oPosition = Position;
    oViewdir = mul(Position, matProjectInverse).xyz;
    oTexcoord = Texcoord;
    oTexcoord.xy += ViewportOffset;
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

technique DeferredLighting<
	string Script =
    "RenderDepthStencilTarget=DepthBuffer;"
    "ClearSetColor=BackColor;"
    "ClearSetDepth=ClearDepth;"
    "ClearSetStencil=0;"

#if SHADOW_QUALITY > 0
    "RenderColorTarget0=ShadowmapMapTemp;  Pass=ShadowBlurPassX;"
    "RenderColorTarget0=ShadowmapMap;      Pass=ShadowBlurPassY;"
#endif

    "RenderColorTarget0=ScnMap;"
    "RenderDepthStencilTarget=DepthBuffer;"
    "Clear=Color;"
    "Clear=Depth;"
    "ScriptExternal=Color;"

#if SSAO_SAMPLER_COUNT > 0
    "RenderColorTarget0=SSAOMap;  Pass=SSAO;"
#if SSAO_BLUR_RADIUS > 0
    "RenderColorTarget0=SSAOMapTemp; Pass=SSAOBlurX;"
    "RenderColorTarget0=SSAOMap;     Pass=SSAOBlurY;"
#endif
#endif

    "RenderColorTarget0=OpaqueMap;"
    "RenderDepthStencilTarget=;"
    "Pass=DeferredLighting;"
    
#if SSGI_SAMPLER_COUNT > 0
    "RenderColorTarget0=SSAOMap;  Pass=SSGI;"
#if SSGI_BLUR_RADIUS > 0
    "RenderColorTarget0=SSAOMapTemp; Pass=SSGIBlurX;"
    "RenderColorTarget0=OpaqueMap;   Pass=SSGIBlurY;"
#endif
#endif

#if SSSS_QUALITY > 0
    "RenderDepthStencilTarget=DepthBuffer;"
    "RenderColorTarget0=OpaqueMapTemp;  Pass=SSSSStencilTestPS;"
    "RenderColorTarget0=OpaqueMapTemp;  Pass=SSSSBlurX;"
    "RenderColorTarget0=OpaqueMap;      Pass=SSSSBlurY;"
#endif

#if SSR_SAMPLER_COUNT > 0
    "RenderColorTarget0=OpaqueMapTemp;  Pass=SSR;"
#endif

#if HDR_BLOOM_QUALITY > 0
#if HDR_BLOOM_QUALITY > 2
    "RenderColorTarget0=BloomMapX1;      Pass=GlareDetection;"
    "RenderColorTarget0=BloomMapX1Temp;  Pass=BloomBlurX1;"
    "RenderColorTarget0=BloomMapX1;      Pass=BloomBlurY1;"
#else
    "RenderColorTarget0=BloomMapX2;      Pass=GlareDetection;"
#endif
    "RenderColorTarget0=BloomMapX2Temp;  Pass=BloomBlurX2;"
    "RenderColorTarget0=BloomMapX2;      Pass=BloomBlurY2;"
    "RenderColorTarget0=BloomMapX3Temp;  Pass=BloomBlurX3;"
    "RenderColorTarget0=BloomMapX3;      Pass=BloomBlurY3;"
    "RenderColorTarget0=BloomMapX4Temp;  Pass=BloomBlurX4;"
    "RenderColorTarget0=BloomMapX4;      Pass=BloomBlurY4;"
    "RenderColorTarget0=BloomMapX5Temp;  Pass=BloomBlurX5;"
    "RenderColorTarget0=BloomMapX5;      Pass=BloomBlurY5;"
#endif

#if AA_QUALITY > 0
    "RenderColorTarget0=OpaqueMapTemp;"
    "Pass=FimicToneMapping;"

    "RenderColorTarget0=;"
    "RenderDepthStencilTarget=;"
    "Pass=AntiAliasing;"
#else
    "RenderColorTarget0=;"
    "RenderDepthStencilTarget=;"
    "Pass=FimicToneMapping;"
#endif
;>
{
#if SHADOW_QUALITY > 0
    pass ShadowBlurPassX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ShadowMappingVS();
        PixelShader  = compile ps_3_0 ShadowMappingPS(ShadowSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass ShadowBlurPassY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ShadowMappingVS();
        PixelShader  = compile ps_3_0 ShadowMappingPS(ShadowmapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#endif
#if SSAO_SAMPLER_COUNT > 0
    pass SSAO < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAO();
    }
#   if SSAO_BLUR_RADIUS > 0
    pass SSAOBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAOBlur(SSAOMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass SSAOBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSAOBlur(SSAOMapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#   endif
#endif
    pass DeferredLighting < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 DeferredLightingPS();
    }
#if SSAO_SAMPLER_COUNT > 0
    pass SSGI < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSGI();
    }
#   if SSGI_BLUR_RADIUS > 0
    pass SSGIBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSGIBlur(SSAOMapSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass SSGIBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = true;
        SrcBlend = ONE;
        DestBlend = ONE;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSGIBlur(SSAOMapSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#   endif
#endif
#if SSSS_QUALITY > 0
    pass SSSSStencilTestPS < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = ALWAYS;
        StencilRef = 1;
        StencilPass = REPLACE;
        StencilFail = KEEP;
        StencilZFail = KEEP;
        StencilWriteMask = 1;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 SSSSStencilTestPS();
    }
    pass SSSSBlurX < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GuassBlurPS(OpaqueSamp, float2(ViewportOffset2.x, 0.0f));
    }
    pass SSSSBlurY < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        StencilEnable = true;
        StencilFunc = EQUAL;
        StencilRef = 1;
        StencilWriteMask = 0;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GuassBlurPS(OpaqueSampTemp, float2(0.0f, ViewportOffset2.y));
    }
#endif
#if SSR_SAMPLER_COUNT > 0
    pass SSR < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 LocalReflectionPS();
    }
#endif
#if HDR_BLOOM_QUALITY > 0
    pass GlareDetection < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 GlareDetectionPS(OpaqueSamp, ViewportOffset2);
    }
#if HDR_BLOOM_QUALITY > 2
    pass BloomBlurX1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1, float2(ViewportOffset2.x, 0.0), 3);
    }
    pass BloomBlurY1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(1);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1Temp, float2(0.0f, ViewportOffset2.y), 3);
    }
#endif
    pass BloomBlurX2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(2);
#if HDR_BLOOM_QUALITY > 2
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX1, float2(ViewportOffset2.x, 0.0), 5);
#else
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX2, float2(ViewportOffset2.x * 2, 0.0), 5);
#endif
    }
    pass BloomBlurY2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(2);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX2Temp, float2(0.0f, ViewportOffset2.y * 2), 5);
    }
    pass BloomBlurX3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX2, float2(ViewportOffset2.x * 4, 0.0), 7);
    }
    pass BloomBlurY3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(4);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX3Temp, float2(0.0f, ViewportOffset2.y * 4), 7);
    }
    pass BloomBlurX4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(8);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX3, float2(ViewportOffset2.x * 8, 0.0), 9);
    }
    pass BloomBlurY4 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(8);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX4Temp, float2(0.0f, ViewportOffset2.y * 8), 9);
    }
    pass BloomBlurX5 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(16);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX4, float2(ViewportOffset2.x * 16, 0.0), 11);
    }
    pass BloomBlurY5 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 BloomBlurVS(16);
        PixelShader  = compile ps_3_0 BloomBlurPS(BloomSampX5Temp, float2(0.0f, ViewportOffset2.y * 16), 11);
    }
#endif
    pass FimicToneMapping < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 FimicToneMappingPS(OpaqueSamp);
    }
#if AA_QUALITY > 0
    pass AntiAliasing < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = false;
        AlphaTestEnable = false;
        ZEnable = false;
        ZWriteEnable = false;
        VertexShader = compile vs_3_0 ScreenSpaceQuadVS();
        PixelShader  = compile ps_3_0 FXAA3(OpaqueSampTemp, ViewportOffset2);
    }
#endif
}