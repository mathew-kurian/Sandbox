package org.papervision3d.core.animation.channel
{
	import org.papervision3d.core.animation.AnimationKeyFrame3D;
	import org.papervision3d.core.animation.IAnimationDataProvider;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author Tim Knip
	 */ 
	public class MatrixStackChannel3D extends AbstractChannel3D
	{
		/**
		 * Constructor.
		 * 
		 * @param	parent
		 * @param	defaultTarget
		 * @param	name
		 */ 
		public function MatrixStackChannel3D(parent:IAnimationDataProvider, defaultTarget:DisplayObject3D, name:String=null)
		{
			super(parent, defaultTarget, name);
			
			this.keyFrames = new Array();
			
			_matrixStack = new Array();
		}
		
		/**
		 * Adds a MatrixChannel3D to this channel.
		 *  
		 * @param	channel
		 */
		public function addMatrixChannel(channel:MatrixChannel3D):void
		{
			if(_matrixStack.length)
			{
				this.minTime = Math.min(this.minTime, channel.minTime);
				this.maxTime = Math.max(this.maxTime, channel.maxTime);
			}
			else
			{
				this.minTime = channel.minTime;
				this.maxTime = channel.maxTime;
				this.keyFrames = channel.keyFrames;
			}

			_matrixStack.push(channel);
		}
		
		/**
		 * Adds a new keyframe.
		 * 
		 * @param	keyframe
		 * 
		 * @return	The added keyframe.
		 */ 
		public override function addKeyFrame(keyframe:AnimationKeyFrame3D):AnimationKeyFrame3D
		{
			throw new Error("You can't add keyframes to a MatrixStackChannel3D!");
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
			
			var matrix:Matrix3D = Matrix3D.IDENTITY;
			
			for(var i:int = 0; i < _matrixStack.length; i++)
			{
				var channel:MatrixChannel3D = _matrixStack[i];
				
				channel.updateToFrame(keyframe, target);
				
				matrix = Matrix3D.multiply(matrix, channel.output[0]);
			}
			
			this.output = [matrix];
			
			target.copyTransform(this.output[0]);
		}
		
		private var _matrixStack:Array;
	}
}