package org.papervision3d.core.render.data
{
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import flash.display.Sprite;
	
	import org.papervision3d.core.culling.IParticleCuller;
	import org.papervision3d.core.culling.ITriangleCuller;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.core.render.IRenderEngine;
	import org.papervision3d.view.Viewport3D;
	
	
	public class RenderSessionData
	{
		//Replacement for camera.sorted.
		public var sorted:Boolean;
		
		public var triangleCuller:ITriangleCuller;
		public var particleCuller:IParticleCuller;
		
		public var viewPort:Viewport3D;
		public var container:Sprite;
		public var scene:SceneObject3D;
		public var camera:CameraObject3D;
		public var renderer:IRenderEngine;
		public var renderStatistics:RenderStatistics;
		
		public function RenderSessionData():void
		{
			this.renderStatistics = new RenderStatistics();
		}
		
	}
}