/**
 * TMask
 * Mask Transition implementation...
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//
	import _project.classes.ITransition;
	import _project.classes.TransitionStatus;
	//
	public class TMask extends EventDispatcher implements ITransition {
		//private vars...
		private var __maskintro:MovieClip;
		private var __maskoutro:MovieClip;
		private var __status:int = TransitionStatus.IDDLE;
		private var __target:DisplayObject;
		//
		//constructor...
		public function TMask(sMask:Sprite, mcIntroModel:MovieClip, mcOutroModel:MovieClip) {
			this.__maskintro = MovieClip(sMask.addChild(mcIntroModel));
			this.__maskintro.visible = false;
			this.__maskoutro = MovieClip(sMask.addChild(mcOutroModel));
			this.__maskoutro.visible = false;
		};
		//
		//private methods...
		private function __finalize():Boolean {
			if (!(this.__target is DisplayObject)) return false;
			MovieClip(this.__target.mask).stop();
			try {
				this.__target.mask.removeEventListener(Event.ENTER_FRAME, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			this.__target.visible = (this.__status == TransitionStatus.INTRO);
			this.__target.mask = null;
			this.__status = TransitionStatus.IDDLE;
			//
			return this.__target.visible;
		};
		private function __onFxFinish(event:Event):void {
			if (!(this.__target is DisplayObject)) return;
			if (!(this.__target.mask is MovieClip)) return;
			if (MovieClip(this.__target.mask).currentFrame != MovieClip(this.__target.mask).totalFrames) return;
			(this.__finalize()) ? this.dispatchEvent(new Event(Event.OPEN)) : this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __process(boolIntro:Boolean, objTarget:DisplayObject):Boolean {
			if (!(objTarget is DisplayObject)) return false;
			this.finalize();
			this.__status = (boolIntro) ? TransitionStatus.INTRO : TransitionStatus.OUTRO;
			this.__target = objTarget;
			this.__target.mask = (boolIntro) ? this.__maskintro : this.__maskoutro;
			this.__target.visible = true;
			this.resize();
			try {
				this.__target.mask.removeEventListener(Event.ENTER_FRAME, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__target.mask.addEventListener(Event.ENTER_FRAME, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			try {
				MovieClip(this.__target.mask).gotoAndPlay(1);
			}
			catch (_error:Error) {
				//...
			};
			//
			return true;
		};
		//
		//properties...
		public function get durationIntro():Number {
			return (((this.__maskintro is MovieClip) && (this.__maskintro.stage is Stage)) ? this.__maskintro.totalFrames / this.__maskintro.stage.frameRate : 0);
		};
		public function get durationOutro():Number {
			return (((this.__maskoutro is MovieClip) && (this.__maskintro.stage is Stage)) ? this.__maskoutro.totalFrames / this.__maskoutro.stage.frameRate : 0);
		};
		public function get target():DisplayObject {
			return this.__target;
		};
		//
		//public methods...
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		};
		public function finalize():Boolean {
			if (!(this.__target is DisplayObject)) return false;
			if (!(this.__target.mask is MovieClip)) return false;
			//
			return this.__finalize();
		};
		public function inTransition(objTarget:DisplayObject):int {
			if (!(this.__target is DisplayObject)) return TransitionStatus.IDDLE;
			if (objTarget != this.__target) return TransitionStatus.IDDLE;
			return this.__status;
		};
		public function intro(objTarget:DisplayObject, ... rest):Boolean {
			return this.__process(true, objTarget);
		};
		public function outro(objTarget:DisplayObject, ... rest):Boolean {
			return this.__process(false, objTarget);
		};
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
		};
		public function resize():void {
			try {
				var _metrics:Rectangle = this.__target.getBounds(this.__target.mask.parent);
				var _mask:DisplayObject = this.__target.mask;
				_mask.height = _metrics.height;
				_mask.width = _metrics.width;
				_mask.x = _metrics.x;
				_mask.y = _metrics.y;
			}
			catch (_error:Error) {
				//...
			};
		};
	};
};