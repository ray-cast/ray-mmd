#define USE_CUSTOM_PARAMS 0

static float waveLines = 8;        // 1 ~ 8
static float waveBloom = 3;        // 1 ~ inf
static float waveHeightLow = 5;    // 1 ~ inf
static float waveHeightHigh = 7;   // 1 ~ inf
static float waveFade = 2;         // 0 ~ inf
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

#define WAVE_1_MAP_FILE "spectrum.wav1.png"
#define WAVE_2_MAP_FILE "spectrum.wav2.png"

#include "wavelines.fxsub"