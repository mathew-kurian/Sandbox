package org.papervision3d.core.animation.channel
{
	import org.papervision3d.core.animation.IAnimationDataProvider;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author Tim Knip
	 */ 
	public class MorphChannel3D extends AbstractChannel3D
	{
		/**
		 * Constructor.
		 * 
		 * @param	parent
		 * @param	defaultTarget
		 * @param	name
		 */ 
		public function MorphChannel3D(parent:IAnimationDataProvider, defaultTarget:DisplayObject3D, name:String=null)
		{
			super(parent, defaultTarget, name);
		}	
		
		/**
		 * Updates this channel.
		 * 
		 * @param	keyframe
		 * @param	target
		 */ 
		override public function updateToFrame(keyframe:uint, target:DisplayObject3D=null):void
		{
			super.updateToFrame(keyframe, target);	
			
			target = target || this.defaultTarget;
			
			if(!target.geometry || !target.geometry.vertices)
				return;
				
			if(this.output.length != target.geometry.vertices.length)
				return;
				
			for(var i:int = 0; i < target.geometry.vertices.length; i++)
			{
				var v:Vertex3D = target.geometry.vertices[i];
				var w:Vertex3D = this.output[i];
				
				v.x = w.x;
				v.y = w.y;
				v.z = w.z;
			}
		}
	}
}