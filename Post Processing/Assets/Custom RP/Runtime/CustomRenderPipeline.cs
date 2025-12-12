using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

public class CustomRenderPipeline : RenderPipeline{
    CameraRenderer renderer = new CameraRenderer();

    public CustomRenderPipeline(){

    }

    protected override void Render(ScriptableRenderContext context, Camera[] cameras){
        foreach(Camera camera in cameras){
            renderer.Render(context, camera);
        }
    }
}