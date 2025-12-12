Shader "Custom RP/OITComposite"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode"="CustomOITComposite" }
            Cull Off
            ZWrite Off
            ZTest Always
            Blend OneMinusSrcAlpha SrcAlpha

            HLSLPROGRAM
            #pragma vertex OITCompositeVertex
            #pragma fragment OITCompositeFragment
            #include "OITCompositePass.hlsl"
            ENDHLSL
        }
    }
}
