using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Unity.Collections;

public class OIT 
{
    const string bufferName = "OIT";

    const bool useOIT = false;

    static ShaderTagId oitShaderTagId = new ShaderTagId("CustomOIT");

    static int accumId = Shader.PropertyToID("_AccumTexture");
    static int revealId = Shader.PropertyToID("_RevealTexture");

    CommandBuffer buffer = new CommandBuffer{ name = bufferName };

    ScriptableRenderContext context;

    CullingResults cullingResults;

    Camera camera;

    OITSettings OITSettings;

    Material oitCompositeMaterial;

    public void Setup(ScriptableRenderContext context, CullingResults cullingResults, Camera camera, OITSettings OITSettings){
        this.context = context;
        this.cullingResults = cullingResults;
        this.camera = camera;
        this.OITSettings = OITSettings;
        this.oitCompositeMaterial = OITSettings.oitCompositeMaterial;
        buffer.BeginSample(bufferName);
        SetupOIT();
        buffer.EndSample(bufferName);
        ExecuteBuffer();
    }

    void SetupOIT(){

    }

    void ExecuteBuffer(){
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    public void Render(){
        if(OITSettings.useOIT){
            DrawOIT();
            CompositeOIT();
        }
    }

    public void DrawOIT(){
        buffer.GetTemporaryRT(accumId, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.ARGBHalf);
        buffer.GetTemporaryRT(revealId, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.R8);
    
        buffer.SetRenderTarget(accumId);
        buffer.ClearRenderTarget(false, true, Color.clear);

        buffer.SetRenderTarget(revealId);
        buffer.ClearRenderTarget(false, true, Color.white);

        RenderTargetIdentifier[] attachments = {accumId, revealId};
        buffer.SetRenderTarget(attachments, BuiltinRenderTextureType.CameraTarget);
        ExecuteBuffer();

        var sortingSettings = new SortingSettings(camera){
            criteria = SortingCriteria.CommonTransparent
        };
        var drawingSettings = new DrawingSettings(oitShaderTagId, sortingSettings);
        var filteringSettings = new FilteringSettings(RenderQueueRange.transparent);

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings); 

    }

    void CompositeOIT(){
        buffer.SetRenderTarget(BuiltinRenderTextureType.CameraTarget);

        buffer.SetGlobalTexture(accumId, accumId);
        buffer.SetGlobalTexture(revealId, revealId);

        buffer.DrawProcedural(Matrix4x4.identity, oitCompositeMaterial, 0, MeshTopology.Triangles, 3);

        buffer.ReleaseTemporaryRT(accumId);
        buffer.ReleaseTemporaryRT(revealId);
        ExecuteBuffer();
    }
}
