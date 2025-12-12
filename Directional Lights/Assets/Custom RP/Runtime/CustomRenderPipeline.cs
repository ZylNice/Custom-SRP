using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

public class CustomRenderPipeline : RenderPipeline{

    CameraRenderer renderer = new CameraRenderer();

    bool useDynamicBatching, useGPUInstancing;

    OITSettings OITSettings;

    public CustomRenderPipeline(
        bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher,
        OITSettings OITSettings
    ){
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        this.OITSettings = OITSettings;
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
        GraphicsSettings.lightsUseLinearIntensity = true;
    }

    protected override void Render(ScriptableRenderContext context, Camera[] cameras){
        foreach(Camera camera in cameras){
            renderer.Render(
                context, camera, useDynamicBatching, useGPUInstancing,
                OITSettings
            );
        }
    }
}