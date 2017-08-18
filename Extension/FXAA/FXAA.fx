// ==============================================================================
// NVIDIA FXAA 3.11 for Ray-MMD converted and originaly made by TIMOTHY LOTTES
// ------------------------------------------------------------------------------
// Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
// ------------------------------------------------------------------------------
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of NVIDIA CORPORATION nor the names of its
//   contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ==============================================================================
#if 0
#define FXAA_QUALITY__PS 12
#define FXAA_QUALITY__P0 1.0
#define FXAA_QUALITY__P1 1.0
#define FXAA_QUALITY__P2 1.0
#define FXAA_QUALITY__P3 1.0
#define FXAA_QUALITY__P4 1.0
#define FXAA_QUALITY__P5 1.5
#define FXAA_QUALITY__P6 2.0
#define FXAA_QUALITY__P7 2.0
#define FXAA_QUALITY__P8 2.0
#define FXAA_QUALITY__P9 2.0
#define FXAA_QUALITY__P10 4.0
#define FXAA_QUALITY__P11 8.00
#else
#define FXAA_QUALITY__PS 5
#define FXAA_QUALITY__P0 1.0
#define FXAA_QUALITY__P1 1.5
#define FXAA_QUALITY__P2 2.0
#define FXAA_QUALITY__P3 4.0
#define FXAA_QUALITY__P4 12.0
#endif
#define FxaaBool bool
#define FxaaDiscard clip(-1)
#define FxaaFloat float
#define FxaaFloat2 float2
#define FxaaFloat3 float3
#define FxaaFloat4 float4
#define FxaaHalf half
#define FxaaHalf2 half2
#define FxaaHalf3 half3
#define FxaaHalf4 half4
#define FxaaSat(x)saturate(x)
#define FxaaInt2 float2
#define FxaaTex sampler2D
#define FxaaTexTop(t,p)tex2Dlod(t,float4(p,0.0,0.0))
#define FxaaTexOff(t,p,o,r)tex2Dlod(t,float4(p+(o*r),0,0))
FxaaFloat FxaaLuma(FxaaFloat4 rgba){return dot(rgba.rgb, float3(0.2126f, 0.7152f, 0.0722f));}FxaaFloat4 FxaaPixelShader(FxaaFloat2 pos,FxaaFloat4 fxaaConsolePosPos,FxaaTex tex,FxaaTex fxaaConsole360TexExpBiasNegOne,FxaaTex fxaaConsole360TexExpBiasNegTwo,FxaaFloat2 fxaaQualityRcpFrame,FxaaFloat4 fxaaConsoleRcpFrameOpt,FxaaFloat4 fxaaConsoleRcpFrameOpt2,FxaaFloat4 fxaaConsole360RcpFrameOpt2,FxaaFloat fxaaQualitySubpix,FxaaFloat fxaaQualityEdgeThreshold,FxaaFloat fxaaQualityEdgeThresholdMin,FxaaFloat fxaaConsoleEdgeSharpness,FxaaFloat fxaaConsoleEdgeThreshold,FxaaFloat fxaaConsoleEdgeThresholdMin,FxaaFloat4 fxaaConsole360ConstDir){FxaaFloat2 posM;posM.x=pos.x;posM.y=pos.y;FxaaFloat4 rgbyM=FxaaTexTop(tex,posM);FxaaFloat lumaM=FxaaLuma(rgbyM),lumaS=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(0,1),fxaaQualityRcpFrame.xy)),lumaE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,0),fxaaQualityRcpFrame.xy)),lumaN=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(0,-1),fxaaQualityRcpFrame.xy)),lumaW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,0),fxaaQualityRcpFrame.xy)),maxSM=max(lumaS,lumaM),minSM=min(lumaS,lumaM),maxESM=max(lumaE,maxSM),minESM=min(lumaE,minSM),maxWN=max(lumaN,lumaW),minWN=min(lumaN,lumaW),rangeMax=max(maxWN,maxESM),rangeMin=min(minWN,minESM),rangeMaxScaled=rangeMax*fxaaQualityEdgeThreshold,range=rangeMax-rangeMin,rangeMaxClamped=max(fxaaQualityEdgeThresholdMin,rangeMaxScaled);FxaaBool earlyExit=range<rangeMaxClamped;if(earlyExit){return rgbyM;}else{FxaaFloat lumaNW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,-1),fxaaQualityRcpFrame.xy)),lumaSE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,1),fxaaQualityRcpFrame.xy)),lumaNE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,-1),fxaaQualityRcpFrame.xy)),lumaSW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,1),fxaaQualityRcpFrame.xy)),lumaNS=lumaN+lumaS,lumaWE=lumaW+lumaE,subpixRcpRange=1./range,subpixNSWE=lumaNS+lumaWE,edgeHorz1=-2.*lumaM+lumaNS,edgeVert1=-2.*lumaM+lumaWE,lumaNESE=lumaNE+lumaSE,lumaNWNE=lumaNW+lumaNE,edgeHorz2=-2.*lumaE+lumaNESE,edgeVert2=-2.*lumaN+lumaNWNE,lumaNWSW=lumaNW+lumaSW,lumaSWSE=lumaSW+lumaSE,edgeHorz4=abs(edgeHorz1)*2.+abs(edgeHorz2),edgeVert4=abs(edgeVert1)*2.+abs(edgeVert2),edgeHorz3=-2.*lumaW+lumaNWSW,edgeVert3=-2.*lumaS+lumaSWSE,edgeHorz=abs(edgeHorz3)+edgeHorz4,edgeVert=abs(edgeVert3)+edgeVert4,subpixNWSWNESE=lumaNWSW+lumaNESE,lengthSign=fxaaQualityRcpFrame.x;FxaaBool horzSpan=edgeHorz>=edgeVert;FxaaFloat subpixA=subpixNSWE*2.+subpixNWSWNESE;if(!horzSpan)lumaN=lumaW;if(!horzSpan)lumaS=lumaE;if(horzSpan)lengthSign=fxaaQualityRcpFrame.y;FxaaFloat subpixB=subpixA*(1./12.)-lumaM,gradientN=lumaN-lumaM,gradientS=lumaS-lumaM,lumaNN=lumaN+lumaM,lumaSS=lumaS+lumaM;FxaaBool pairN=abs(gradientN)>=abs(gradientS);FxaaFloat gradient=max(abs(gradientN),abs(gradientS));if(pairN)lengthSign=-lengthSign;FxaaFloat subpixC=FxaaSat(abs(subpixB)*subpixRcpRange);FxaaFloat2 posB;posB.x=posM.x;posB.y=posM.y;FxaaFloat2 offNP;offNP.x=!horzSpan?0.:fxaaQualityRcpFrame.x;offNP.y=horzSpan?0.:fxaaQualityRcpFrame.y;if(!horzSpan)posB.x+=lengthSign*.5;if(horzSpan)posB.y+=lengthSign*.5;FxaaFloat2 posN;posN.x=posB.x-offNP.x*FXAA_QUALITY__P0;posN.y=posB.y-offNP.y*FXAA_QUALITY__P0;FxaaFloat2 posP;posP.x=posB.x+offNP.x*FXAA_QUALITY__P0;posP.y=posB.y+offNP.y*FXAA_QUALITY__P0;FxaaFloat subpixD=-2.*subpixC+3.,lumaEndN=FxaaLuma(FxaaTexTop(tex,posN)),subpixE=subpixC*subpixC,lumaEndP=FxaaLuma(FxaaTexTop(tex,posP));if(!pairN)lumaNN=lumaSS;FxaaFloat gradientScaled=gradient/4.,lumaMM=lumaM-lumaNN*.5,subpixF=subpixD*subpixE;FxaaBool lumaMLTZero=lumaMM<0.;lumaEndN-=lumaNN*.5;lumaEndP-=lumaNN*.5;FxaaBool doneN=abs(lumaEndN)>=gradientScaled,doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P1;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P1;FxaaBool doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P1;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P1;if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P2;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P2;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P2;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P2;
#if (FXAA_QUALITY__PS>3)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P3;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P3;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P3;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P3;
#if (FXAA_QUALITY__PS>4)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P4;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P4;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P4;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P4;
#if (FXAA_QUALITY__PS>5)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P5;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P5;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P5;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P5;
#if (FXAA_QUALITY__PS>6)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P6;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P6;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P6;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P6;
#if (FXAA_QUALITY__PS>7)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P7;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P7;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P7;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P7;
#if (FXAA_QUALITY__PS>8)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P8;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P8;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P8;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P8;
#if (FXAA_QUALITY__PS>9)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P9;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P9;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P9;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P9;
#if (FXAA_QUALITY__PS>10)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P10;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P10;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P10;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P10;
#if (FXAA_QUALITY__PS>11)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P11;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P11;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P11;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P11;
#if (FXAA_QUALITY__PS>12)
if(doneNP){if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));if(!doneN)lumaEndN=lumaEndN-lumaNN*.5;if(!doneP)lumaEndP=lumaEndP-lumaNN*.5;doneN=abs(lumaEndN)>=gradientScaled;doneP=abs(lumaEndP)>=gradientScaled;if(!doneN)posN.x-=offNP.x*FXAA_QUALITY__P12;if(!doneN)posN.y-=offNP.y*FXAA_QUALITY__P12;doneNP=!doneN||!doneP;if(!doneP)posP.x+=offNP.x*FXAA_QUALITY__P12;if(!doneP)posP.y+=offNP.y*FXAA_QUALITY__P12;}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}FxaaFloat dstN=posM.x-posN.x,dstP=posP.x-posM.x;if(!horzSpan)dstN=posM.y-posN.y;if(!horzSpan)dstP=posP.y-posM.y;FxaaBool goodSpanN=lumaEndN<0.!=lumaMLTZero;FxaaFloat spanLength=dstP+dstN;FxaaBool goodSpanP=lumaEndP<0.!=lumaMLTZero;FxaaFloat spanLengthRcp=1./spanLength;FxaaBool directionN=dstN<dstP;FxaaFloat dst=min(dstN,dstP);FxaaBool goodSpan=directionN?goodSpanN:goodSpanP;FxaaFloat subpixG=subpixF*subpixF,pixelOffset=dst*-spanLengthRcp+.5,subpixH=subpixG*fxaaQualitySubpix,pixelOffsetGood=goodSpan?pixelOffset:0.,pixelOffsetSubpix=max(pixelOffsetGood,subpixH);if(!horzSpan)posM.x+=pixelOffsetSubpix*lengthSign;if(horzSpan)posM.y+=pixelOffsetSubpix*lengthSign;return FxaaFloat4(FxaaTexTop(tex,posM).xyz,lumaM);}}

texture ScnMap : RENDERCOLORTARGET <
	float2 ViewPortRatio = {1.0,1.0};
	bool AntiAlias = false;
	string Format = "X8R8G8B8";
>;
sampler ScnSamp = sampler_state {
	texture = <ScnMap>;
	MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = NONE;
	AddressU = CLAMP; AddressV = CLAMP;
};
texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET<
	float2 ViewportRatio = {1.0,1.0};
	string Format = "D24S8";
>;

float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset  = (float2(0.5,0.5) / ViewportSize);
static float2 ViewportOffset2 = (float2(1.0,1.0) / ViewportSize);

void FXAA3VS(
	in float4 Position : POSITION,
	in float4 Texcoord : TEXCOORD0,
	out float4 oTexcoord  : TEXCOORD0,
	out float4 oPosition  : POSITION)
{
	oTexcoord = Texcoord + ViewportOffset.xyxy;
	oPosition = Position;
}

float4 FXAA3PS(in float4 coord : TEXCOORD0) : COLOR
{
	float4 color = FxaaPixelShader(coord.xy,
				FxaaFloat4(0.0f, 0.0f, 0.0f, 0.0f),
				ScnSamp,
				ScnSamp,
				ScnSamp,
				ViewportOffset2,
				FxaaFloat4(0.0f, 0.0f, 0.0f, 0.0f),
				FxaaFloat4(0.0f, 0.0f, 0.0f, 0.0f),
				FxaaFloat4(0.0f, 0.0f, 0.0f, 0.0f),
				0.5,
				0.166,
				0.0833,
				0.0f,
				0.0f,
				0.0f,
				FxaaFloat4(0.0f, 0.0f, 0.0f, 0.0f)
			);
	return float4(color.rgb, 1);
}

float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass  = "scene";
	string ScriptOrder  = "postprocess";
> = 0.8;

const float4 ClearColor  = float4(0,0,0,0);
const float ClearDepth  = 1.0;

technique FXAA <
	string Script = 
	"RenderColorTarget=ScnMap;"
	"RenderDepthStencilTarget=DepthBuffer;"
	"ClearSetColor=ClearColor;"
	"ClearSetDepth=ClearDepth;"
	"Clear=Color;"
	"Clear=Depth;"
	"ScriptExternal=Color;"
	
	"RenderColorTarget=;"
	"RenderDepthStencilTarget=DepthBuffer;"
	"Clear=Color;"
	"Pass=FXAA;"
	;
> {
	pass FXAA < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		ZEnable = false; ZWriteEnable = false;
		VertexShader = compile vs_3_0 FXAA3VS();
		PixelShader  = compile ps_3_0 FXAA3PS();
	}
}