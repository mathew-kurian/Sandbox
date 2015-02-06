/**
 * TFade
 * Fade Transition implementation...
 *
 * @version		1.5
 */
package _project.classes {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	//
	import _project.classes.ITransition;
	import _project.classes.TransitionStatus;
	//
	public class TFade extends EventDispatcher implements ITransition {
		//constants...
		private const __KFADE_PARAMS:Object = { intro: { duration: 1, transition: Strong.easeIn }, outro: { duration: 1, transition: Strong.easeOut }, useseconds: true };
		//private vars...
		private var __status:int = TransitionStatus.IDDLE;
		private var __target:DisplayObject;
		private var __tween:Tween;
		//
		//constructor...
		public function TFade(floatIntroDuration:Number = undefined, floatOutroDuration:Number = undefined) {
			if (!isNaN(floatIntroDuration)) {
				if (floatIntroDuration > 0) this.__KFADE_PARAMS.intro.duration = floatIntroDuration;
			};
			if (!isNaN(floatOutroDuration)) {
				if (floatOutroDuration > 0) this.__KFADE_PARAMS.outro.duration = floatOutroDuration;
			};
		};
		//
		//private methods...
		private function __finalize():Boolean {
			if (!(this.__target is DisplayObject)) return false;
			if (this.__tween) {
				this.__tween.stop();
				try {
					this.__tween.removeEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
				}
				catch (_error:Error) {
					//...
				};
			};
			this.__tween = undefined;
			if (this.__status != TransitionStatus.IDDLE) {
				this.__target.visible = (this.__status == TransitionStatus.INTRO);
				this.__status = TransitionStatus.IDDLE;
			};
			//
			return this.__target.visible;
		};
		private function __onFxFinish(event:Event):void {
			if (!(this.__target is DisplayObject)) return;
			(this.__finalize()) ? this.dispatchEvent(new Event(Event.OPEN)) : this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __process(boolIntro:Boolean, objTarget:DisplayObject, floatDuration:Number):Boolean {
			floatDuration = undefined;
			if (!(objTarget is DisplayObject)) return false;
			this.finalize();
			this.__target = objTarget;
			var _alpha:Number = (this.__target.visible) ? this.__target.alpha : 0;
			this.__target.visible = true;
			if (boolIntro) {
				this.__status = TransitionStatus.INTRO;
				if (isNaN(floatDuration)) floatDuration = this.__KFADE_PARAMS.intro.duration
				else if (floatDuration <= 0) floatDuration = this.__KFADE_PARAMS.intro.duration;
				this.__tween = new Tween(this.__target, "alpha", this.__KFADE_PARAMS.intro.transition, _alpha, 1, floatDuration, this.__KFADE_PARAMS.useseconds);
			}
			else {
				this.__status = TransitionStatus.OUTRO;
				if (isNaN(floatDuration)) floatDuration = this.__KFADE_PARAMS.outro.duration
				else if (floatDuration <= 0) floatDuration = this.__KFADE_PARAMS.outro.duration;
				this.__tween = new Tween(this.__target, "alpha", this.__KFADE_PARAMS.outro.transition, _alpha, 0, floatDuration, this.__KFADE_PARAMS.useseconds);
			};
			this.__tween.addEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
			//
			return true;
		};
		//
		//properties...
		public function get durationIntro():Number {
			if (this.__tween) return ((this.__status == TransitionStatus.INTRO) ? this.__tween.duration : this.__KFADE_PARAMS.intro.duration)
			else return this.__KFADE_PARAMS.intro.duration;
		};
		public function get durationOutro():Number {
			if (this.__tween) return ((this.__status == TransitionStatus.OUTRO) ? this.__tween.duration : this.__KFADE_PARAMS.outro.duration)
			else return this.__KFADE_PARAMS.outro.duration;
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
			//
			return this.__finalize();
		};
		public function inTransition(objTarget:DisplayObject):int {
			if (!(this.__target is DisplayObject)) return TransitionStatus.IDDLE;
			if (objTarget != this.__target) return TransitionStatus.IDDLE;
			return this.__status;
		};
		public function intro(objTarget:DisplayObject, ... rest):Boolean {
			return this.__process(true, objTarget, rest[0]);
		};
		public function outro(objTarget:DisplayObject, ... rest):Boolean {
			return this.__process(false, objTarget, rest[0]);
		};
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
		};
		public function resize():void {
			//blind...
		};
	};
};