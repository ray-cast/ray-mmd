#define USE_CUSTOM_PARAMS 1

static float2 size = 1.0;      // 0 ~ 1
static float2 translate = 0.0; // 0 ~ 1

static float waveLines = 8;   // 1 ~ 8
static float waveBloom = 10;  // 1 ~ inf
static float waveHeight = 1;  // 1 ~ 2
static float waveFade = 0.5;  // 0 ~ inf
static float waveBlockSize = 0.02; // 0 ~ inf

static float3 waveColorLow  = float3(0.0, 1.0, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf
static float3 waveColorHigh = float3(0.6, 0.9, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf
static float3 waveBlockColorBg  = float3(0.8, 1.0, 1.0); // hsv, h & s 0 ~ 1, v 0 ~ inf

// ignore USE_CUSTOM_PARAMS
#define USE_RGB_SPACE 0

#define WAVE_1_MAP_FILE "../../Media/Experiment by IQ.wav1.png"
#define WAVE_2_MAP_FILE "../../Media/Experiment by IQ.wav2.png"

#include "WaveLinesFighting.fxsub"