#ifndef _H_GBUFFER_SAMPLER_H_
#define _H_GBUFFER_SAMPLER_H_

shared texture MaterialMap: OFFSCREENRENDERTARGET;
shared texture Gbuffer2RT: RENDERCOLORTARGET;
shared texture Gbuffer3RT: RENDERCOLORTARGET;

sampler Gbuffer1Map = sampler_state {
    texture = <MaterialMap>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

sampler Gbuffer2Map = sampler_state {
    texture = <Gbuffer2RT>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

sampler Gbuffer3Map = sampler_state {
    texture = <Gbuffer3RT>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

#endif