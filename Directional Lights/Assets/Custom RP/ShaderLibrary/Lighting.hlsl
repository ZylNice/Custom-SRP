#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

float3 IncomingLight(Surface surface, Light light){
    float3 H = normalize(light.direction + surface.viewDirection);
    float NdotH = saturate(dot(surface.normal, H));
    float specularPower = exp2(10 * surface.smoothness + 1.0);
    // 高光颜色
    float3 specular = pow(NdotH, specularPower) * saturate(light.color);
    // 漫反射颜色
    float NdotL = saturate(dot(surface.normal, light.direction));
    float3 diffuse = NdotL * surface.color;

    return (diffuse + specular) * light.color;
}

float3 GetLighting(Surface surface, Light light){
    return IncomingLight(surface, light);
}

float3 GetLighting(Surface surface){
    float3 color = 0.0;
    for(int i = 0; i < GetDirectionalLightCount(); i++){
        color += GetLighting(surface, GetDirectionalLight(i));
    }
    return color;
}

#endif