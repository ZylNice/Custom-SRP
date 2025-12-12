#ifndef CUSTOM_OIT_COMPOSITE_INCLUDED
#define CUSTOM_OIT_COMPOSITE_INCLUDED

#include "../ShaderLibrary/Common.hlsl"
#include "../ShaderLibrary/Surface.hlsl"
#include "../ShaderLibrary/Light.hlsl"
#include "../ShaderLibrary/Lighting.hlsl"

TEXTURE2D(_AccumTexture);
TEXTURE2D(_RevealTexture);
SAMPLER(sampler_AccumTexture);
SAMPLER(sampler_RevealTexture);

float4 _ProjectionParams;

struct Varyings{
    float4 positionCS : SV_POSITION;
    float2 uv : TEXCOORD2;
};

struct OITFragmentOutput{
    float4 accum : SV_TARGET0;
    float reveal : SV_TARGET1;
};

Varyings OITCompositeVertex(uint vertexID : SV_VertexID)
{
    Varyings output;
    float x = (vertexID != 1) ? -1.0 : 3.0;
    float y = (vertexID == 2) ? 3.0 : -1.0;
    output.positionCS = float4(x, y, 0.0, 1.0);
    output.uv = float2((x + 1.0) * 0.5, (1.0 - y) * 0.5);
    return output;
}

float4 OITCompositeFragment(Varyings input) : SV_TARGET{
    float4 accum = SAMPLE_TEXTURE2D(_AccumTexture, sampler_AccumTexture, input.uv);
    float reveal = SAMPLE_TEXTURE2D(_RevealTexture, sampler_RevealTexture, input.uv).r;
    float4 averageColor = float4(accum.rgb / max(accum.a, 0.00001), 1.0);
    return float4(averageColor.rgb, reveal);    
}

#endif