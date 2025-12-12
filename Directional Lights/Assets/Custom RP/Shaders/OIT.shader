Shader "Custom RP/OIT"
{
    Properties
    {
        _BaseMap ("Texture", 2D) = "white" {}
        _BaseColor("Color", Color) = (0.5, 0.5, 0.5, 1.0)
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode"="CustomOIT" }
            ZWrite Off
            Blend 0 One One // Accum
            Blend 1 Zero OneMinusSrcColor //Reveal

            HLSLPROGRAM
            #pragma multi_compile_instancing
            #pragma vertex OITPassVertex
            #pragma fragment OITPassFragment
            #include "OITPass.hlsl"
            ENDHLSL
        }
    }
}
