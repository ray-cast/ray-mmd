#define USE_CUSTOM_PARAMS 0

static float2 size = 1.0;      // 0 ~ 1
static float2 translate = 0.0; // 0 ~ 1

static float waveHeight = 1;  // 1 ~ 2
static float waveFade = 0.0;  // 0 ~ inf
static float waveBlockSizeX = 100; // 0 ~ inf
static float waveBlockSizeY = 100; // 0 ~ inf

static float3 waveColorLow  = float3(0.0, 1.0, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf
static float3 waveColorHigh = float3(0.6, 0.9, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf
static float3 waveBlockColorBg  = float3(0.8, 1.0, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf

// ignore USE_CUSTOM_PARAMS
#define USE_RGB_SPACE 0

#define FFT_MAP_FILE "fft.png"

#include "WaveTiles.fxsub"