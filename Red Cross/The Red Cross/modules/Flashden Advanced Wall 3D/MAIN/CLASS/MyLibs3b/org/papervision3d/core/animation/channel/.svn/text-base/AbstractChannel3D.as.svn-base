package org.papervision3d.core.animation.channel
{
	import org.papervision3d.core.animation.AnimationKeyFrame3D;
	import org.papervision3d.core.animation.IAnimationDataProvider;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * @author Tim Knip
	 */ 
	public class AbstractChannel3D
	{	
		/** */
		public var parent:IAnimationDataProvider;
		
		/** */
		public var name:String;
		
		/** */	
		public var keyFrames:Array;
		
		/** */
		public var minTime:Number;
		
		/** */
		public var maxTime:Number;
		
		/** */
		public var output:Array;
		
		/** Position. Use by time based animations. */
		public var position:Number;
		
		/** Tolerance. Use by time based animations. */
		public var tolerance:Number;
		
		/** */
		public function get defaultTarget():DisplayObject3D { return _defaultTarget; }
		
		/**
		 * Constructor.
		 * 
		 * @param	parent
		 * @param	defaultTarget
		 * @param	name
		 */ 
		public function AbstractChannel3D(parent:IAnimationDataProvider, defaultTarget:DisplayObject3D, name:String = null)
		{
			this.parent = parent;
			_defaultTarget = defaultTarget;
			this.name = name;
			this.minTime = this.maxTime = 0;
			this.keyFrames = new Array();
		}
		
		/**
		 * Adds a new keyframe.
		 * 
		 * @param	keyframe
		 * 
		 * @return	The added keyframe.
		 */ 
		public function addKeyFrame(keyframe:AnimationKeyFrame3D):AnimationKeyFrame3D
		{
			if(this.keyFrames.length)
			{
				this.minTime = Math.min(this.minTime, keyframe.time);
				this.maxTime = Math.max(this.maxTime, keyframe.time);
			}
			else
			{
				this.minTime = this.maxTime = keyframe.time;
			}
			
			this.keyFrames.push(keyframe);
			this.keyFrames.sortOn("time", Array.NUMERIC);
			
			return keyframe;
		}
		
		/**
		 * Updates this channel.
		 * 
		 * @param	keyframe
		 * @param	target
		 */ 
		public function updateToFrame(keyframe:uint, target:DisplayObject3D=null):void
		{
			if(!this.keyFrames.length)
			{
				this.output = new Array();
				return;
			}
				
			var kf:AnimationKeyFrame3D = keyframe < this.keyFrames.length ? this.keyFrames[keyframe] : this.keyFrames[0];
			
			this.output = kf.output;
		}
		
		/**
		 * Updates this channel by time.
		 * 
		 */ 
		public function updateToTime(time:Number, frameSnap:Number=0):void
		{	
			var cur:int = 0;
			
			if(time < this.minTime)
			{
				cur = 0;
			}
			else if(time > this.maxTime)
			{
				cur = this.keyFrames.length - 1;
			}
			else
			{
				for(var i:int = 0; i < this.keyFrames.length; i++)
				{
					if(time > this.keyFrames[i].time)
					{
						cur = i;
						break;
					}
				}
			}
			
			var curKF:AnimationKeyFrame3D = this.keyFrames[cur];

			this.output = curKF.output;
		}
		
		protected var _nextOutput:Array;
		
		private var _defaultTarget:DisplayObject3D;
	}
}