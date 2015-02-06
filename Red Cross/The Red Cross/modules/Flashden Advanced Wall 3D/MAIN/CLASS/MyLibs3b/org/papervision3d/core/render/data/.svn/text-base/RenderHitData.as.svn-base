package org.papervision3d.core.render.data
{
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import org.papervision3d.core.geom.renderables.IRenderable;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class RenderHitData
	{
		public var startTime:int = 0;
		public var endTime:int = 0;
		public var hasHit:Boolean = false;
		
		public var displayObject3D:DisplayObject3D;
		public var material:MaterialObject3D;
		
		public var renderable:IRenderable;
		
		public var u:Number;
		public var v:Number;
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function toString():String
		{
			return displayObject3D +" "+renderable;
		}
	}
}