/**
 * ITransition
 * Transitions Interface
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	//
	public interface ITransition {
		function get durationIntro():Number;
		function get durationOutro():Number;
		function get target():DisplayObject;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;	
		function finalize():Boolean;
		function inTransition(objTarget:DisplayObject):int;
		function intro(objTarget:DisplayObject, ... rest):Boolean;
		function outro(objTarget:DisplayObject, ... rest):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		function resize():void;
	};
};