#define USE_CUSTOM_PARAMS 1

static float waveLines = 8;        // 1 ~ 16
static float waveBloom = 3;        // 1 ~ inf
static float waveHeightLow = 7;    // 1 ~ inf
static float waveHeightHigh = 7;   // 1 ~ inf
static float waveFade = 0.5;       // 0 ~ inf
static float waveSin = 10;         // 1 ~ inf
static float waveCos = 2;          // 1 ~ inf
static float waveWheel = 1;        // 1 ~ inf
static float waveOffset = 0.0;     //-1 ~ 1

static float3 waveColorLow  = float3(0.63, 1.0, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf
static float3 waveColorHigh = float3(0.0 , 1.0, 1.7); // hsv, h & s 0 ~ 1, v 0 ~ inf

static float2 size = 1.0;          // 0 ~ 1
static float2 translate = 0.0;     // 0 ~ 1

// ignore USE_CUSTOM_PARAMS
#define USE_RGB_SPACE 0

#define FFT_MAP_FILE "../../Media/Experiment by IQ/Experiment by IQ.wav.fft.png"

#include "wavelines.fxsub"