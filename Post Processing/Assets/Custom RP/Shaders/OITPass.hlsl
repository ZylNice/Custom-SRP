#ifndef CUSTOM_OIT_PASS_INCLUDED
#define CUSTOM_OIT_PASS_INCLUDED

#include "../ShaderLibrary/Common.hlsl"
#include "../ShaderLibrary/Surface.hlsl"
#include "../ShaderLibrary/Light.hlsl"
#include "../ShaderLibrary/Lighting.hlsl"

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

CBUFFER_START(UnityPerMaterial)
    float4 _BaseColor;
    float4 _Specular;
    float _Smoothness;
CBUFFER_END

struct Attributes{
    float3 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float2 baseUV : TEXCOORD0;
};

struct Varyings{
    float4 positionCS : SV_POSITION;
    float3 positionWS : TEXCOORD0;
    float3 normalWS : TEXCOORD1;
    float2 baseUV : TEXCOORD2;
};

struct OITFragmentOutput{
    float4 accum : SV_TARGET0;
    float reveal : SV_TARGET1
}

Varyings OITPassVertex(Attributes input){
    Varyings output;
    output.positionWS = TransformObjectToWorld(input.positionOS);
    output.positionCS = TransformWorldToHClip(output.positionWS);
    output.normalWS = TransformObjectToWorldNormal(input.normalOS);
    output.baseUV = input.baseUV;
    return output;
}

float4 OITPassFragment(Varyings input) : SV_TARGET{
    float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
    float4 baseColor = _BaseColor;
    float4 base = baseMap * baseColor;

    Surface surface;
    surface.normal = normalize(input.normalWS);
    surface.viewDirection = normalize(_WorldSpaceCameraPos - input.positionWS);
    surface.color = base.rgb;
    surface.alpha = base.a;
    surface.specular = _Specular.rgb;
    surface.smoothness = _Smoothness;
    float3 color = GetLighting(surface);
    return float4(color, surface.alpha);

}

#endif