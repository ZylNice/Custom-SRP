#ifndef CUSTOM_LIGHT_INCLUDED
#define CUSTOM_LIGHT_INCLUDED

#include "Common.hlsl"

#define MAX_DIRECTION_LIGHT_COUNT 4

CBUFFER_START(_CustomLight)
    int _DirectionalLightCount;
    float4 _DirectionalLightColors[MAX_DIRECTION_LIGHT_COUNT];
    float4 _DirectionalLightDirections[MAX_DIRECTION_LIGHT_COUNT];
CBUFFER_END

struct Light{
    float3 color;
    float3 direction;
};

int GetDirectionalLightCount(){
    return _DirectionalLightCount;
}

Light GetDirectionalLight(int index){
    Light light;
    light.color = _DirectionalLightColors[index].rgb;
    light.direction = _DirectionalLightDirections[index].xyz;
    return light;
}

#endif