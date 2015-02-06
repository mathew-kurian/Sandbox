package org.papervision3d.core.animation.channel
{
	import org.papervision3d.core.animation.IAnimationDataProvider;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author Tim Knip
	 */ 
	public class SinglePropertyChannel3D extends AbstractChannel3D
	{
		public var targetProperty:String;
		
		/**
		 * Constructor.
		 * 
		 * @param	parent
		 * @param	defaultTarget
		 * @param	targetProperty
		 * @param	name
		 */ 
		public function SinglePropertyChannel3D(parent:IAnimationDataProvider, defaultTarget:DisplayObject3D, targetProperty:String, name:String=null)
		{
			super(parent, defaultTarget, name);
			this.targetProperty = targetProperty;
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
			
			if(!target[this.targetProperty])
				return;
				
			target[this.targetProperty] = this.output[0];
		}	
	}
}