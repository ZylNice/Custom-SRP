#ifndef CUSTOM_SURFACE_INCLUDED
#define CUSTOM_SURFACE_INCLUDED

struct Surface{
    float3 normal;
    float3 viewDirection;
    float3 color;
    float alpha;
    float3 specular;
    float smoothness;
};

#endif