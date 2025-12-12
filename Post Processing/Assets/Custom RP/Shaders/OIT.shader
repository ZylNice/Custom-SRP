Shader "Custom RP/OIT"
{
    Properties
    {
        _BaseMap ("Texture", 2D) = "white" {}
        _BaseColor("Color", Color) = (0.5, 0.5, 0.5, 1.0)
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode"="CustomOIT" }
            ZWrite Off
            // Target 0 (Accum): Additive (Sum) -> Src + Dst
            // Target 1 (Reveal): Multiply (Product) -> Zero + (1-SrcAlpha) * Dst
            Blend 0 One One
            Blend 1 Zero OneMinusSrcColor

            HLSLPROGRAM
            #pragma vertex OITPassVertex
            #pragma fragment OITPassFragment
            #include "OITPass.hlsl"
            ENDHLSL
        }
    }
}
