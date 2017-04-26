#define USE_CUTSOM_PARAMS 1

const float3 colorContrastAll   = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorSaturationAll = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGammaAll      = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGainAll       = float3(1.0, 1.0, 1.1); // 0.0 ~ inf
const float3 colorOffsetAll     = float3(0.1, 0.1, 0.15); // 0.0 ~ inf

const float3 colorContrastLow   = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorSaturationLow = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGammaLow      = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGainLow       = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorOffsetLow     = float3(0.0, 0.0, 0.0); // 0.0 ~ inf

const float3 colorContrastMid   = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorSaturationMid = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGammaMid      = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGainMid       = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorOffsetMid     = float3(0.0, 0.0, 0.0); // 0.0 ~ inf

const float3 colorContrastHigh   = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorSaturationHigh = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGammaHigh      = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorGainHigh       = float3(1.0, 1.0, 1.0); // 0.0 ~ inf
const float3 colorOffsetHigh     = float3(0.0, 0.0, 0.0); // 0.0 ~ inf

const float colorVisualizationLUT = 0.0;        // 0.0 ~ 1.0
const float colorCorrectionLowThreshold  = 0.5; // 0.0 ~ 1.0
const float colorCorrectionHighThreshold = 0.5; // 0.0 ~ 1.0

#include "ColorGrading.fxsub"