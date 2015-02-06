package org.papervision3d.core.animation.channel
{
	import org.papervision3d.core.animation.IAnimationDataProvider;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author Tim Knip
	 */ 
	public class MatrixChannel3D extends AbstractChannel3D
	{
		public var member:String;
		
		/**
		 * Constructor.
		 * 
		 * @param	parent
		 * @param	defaultTarget
		 * @param	name
		 */ 
		public function MatrixChannel3D(parent:IAnimationDataProvider, defaultTarget:DisplayObject3D, name:String=null)
		{
			super(parent, defaultTarget, name);
			this.member = null;
		}
		
		/**
		 * Updates this channel.
		 * 
		 * @param	keyframe
		 * @param	target
		 */ 
		public override function updateToFrame(keyframe:uint, target:DisplayObject3D=null):void
		{
			super.updateToFrame(keyframe, target);	
			
			target = target || this.defaultTarget;
			
			target.copyTransform(this.output[0]);
		}
	}
}