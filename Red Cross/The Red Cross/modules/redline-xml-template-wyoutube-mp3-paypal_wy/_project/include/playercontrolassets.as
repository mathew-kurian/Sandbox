/**
 * PlayerControlAssets core
 * Players Controller holder
 *
 * @version		2.0
 */
import fl.transitions.TweenEvent;
import fl.transitions.Tween;
import fl.transitions.easing.*;
//
const __FX:Object = { intro: { duration: 2, finish: 1, transition: Strong.easeOut }, outro: { duration: 2, finish: 0, transition: Strong.easeOut }, prop: "alpha", useseconds: true };
var __active:Boolean = false;
var __tween:Tween;
//init...
this.control.visible = this.__active;
function __onFxFinish(event:TweenEvent):void {
	if (!(this.__tween is Tween)) return;
	this.__tween.stop();
	this.__removelistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
	if (this.control[this.__FX.prop] == this.__tween.finish) this.control.visible = false;
	this.__tween = undefined;
};
function __onInit(event:Event):void {
	if (!(this.control.isReady is Function)) return;
	if (!this.control.isReady()) return;
	//
	this.removeEventListener(Event.ENTER_FRAME, this.__onInit);
};
//external...
this.getActive = function():Boolean {
	return this.__active;
};
this.setActive = function(boolActive:Boolean):void {
	if (!(boolActive is Boolean)) return;
	if (this.__active === boolActive) return;
	this.__active = boolActive;
	if (this.__tween is Tween) {
		this.__tween.stop();
		try {
			this.__tween.removeEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
		}
		catch (_error:Error) {
			//...
		};
	};
	if (boolActive) {
		this.__tween = new Tween(this.control, this.__FX.prop, this.__FX.intro.transition, this.control[this.__FX.prop], this.__FX.intro.finish, this.__FX.intro.duration, this.__FX.useseconds);
		this.__addlistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
	}
	else {
		this.__tween = new Tween(this.control, this.__FX.prop, this.__FX.outro.transition, this.control[this.__FX.prop], this.__FX.outro.finish, this.__FX.outro.duration, this.__FX.useseconds);
		this.__addlistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
	};
};
this.getBackground = function():Boolean {
	try {
		return this.control.getBackground();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setBackground = function(boolVisible:Boolean):void {
	try {
		this.controls.setBackground(boolVisible);
	}
	catch (_error:Error) {
		//...
	};
};
this.getBuffer = function():Number {
	try {
		return this.control.getBuffer();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setBuffer = function(newBuffer:*):void {
	try {
		this.control.setBuffer(newBuffer);
	}
	catch (_error:Error) {
		//...
	};
};
this.stopBuffer = function():void {
	try {
		this.control.stopBuffer();
	}
	catch (_error:Error) {
		//...
	};
};
this.getControls = function():Object {
	try {
		return this.control.getControls();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setControls = function(objControls:Object):void {
	try {
		this.control.setControls(objControls);
	}
	catch (_error:Error) {
		//...
	};
};
this.getCurrent = function():Number {
	try {
		return this.control.getCurrent();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setCurrent = function(floatCurrent:Number):void {
	try {
		this.control.setCurrent(floatCurrent);
	}
	catch (_error:Error) {
		//...
	};
};
this.getLoaded = function():Number {
	try {
		return this.control.getLoaded();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setLoaded = function(floatLoaded:Number):void {
	try {
		this.control.setLoaded(floatLoaded);
	}
	catch (_error:Error) {
		//...
	};
};
this.getMediaInfo = function():String {
	try {
		return this.control.getMediaInfo();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setMediaInfo = function(strMediaInfo:String):void {
	try {
		this.control.setMediaInfo(strMediaInfo);
	}
	catch (_error:Error) {
		//...
	};
};
this.getMute = function():Boolean {
	try {
		return this.control.getMute();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setMute = function(boolMute:Boolean):void {
	try {
		this.control.setMute(boolMute);
	}
	catch (_error:Error) {
		//...
	};
};
this.getNext = function():MovieClip {
	return this.control.getNext();
};
this.getPrevious = function():MovieClip {
	return this.control.getPrevious();
};
this.setPlay = function(boolPlay:Boolean):void {
	try {
		this.control.setPlay(boolPlay);
	}
	catch (_error:Error) {
		//...
	};
};
this.getRepeat = function():Boolean {
	try {
		return this.control.getRepeat();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setRepeat = function(boolRepeat:Boolean):void {
	try {
		this.control.setRepeat(boolRepeat);
	}
	catch (_error:Error) {
		//...
	};
};
this.getTimeElapsed = function():Number {
	try {
		return this.controls.display.getTimeElapsed();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setTimeElapsed = function(floatTimeElapsed:Number):void {
	try {
		this.control.setTimeElapsed(floatTimeElapsed);
	}
	catch (_error:Error) {
		//...
	};
};
this.getTimeTotal = function():Number {
	try {
		return this.control.getTimeTotal();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setTimeTotal = function(floatTimeTotal:Number):void {
	try {
		this.control.setTimeTotal(floatTimeTotal);
	}
	catch (_error:Error) {
		//...
	};
};
this.getVolume = function():Number {
	try {
		return this.control.getVolume();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setVolume = function(floatVolume:Number):void {
	try {
		this.control.setVolume(floatVolume);
	}
	catch (_error:Error) {
		//...
	};
};
//get status...
this.isReady = function():Boolean {
	return this.control.isReady();
};
//event listener...
this.addEventListener(Event.ENTER_FRAME, this.__onInit);