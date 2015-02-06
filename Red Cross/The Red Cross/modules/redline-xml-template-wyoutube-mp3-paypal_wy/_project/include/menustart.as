/**
 * menuitem.as
 * Menu item core
 *
 * @version		1.0
 */
import fl.transitions.*;
import fl.transitions.easing.*;
//
const __TWEENPARAMS:Object = { duration: { hide: 0.5, show: 1 }, final: { hide: 0, show: 1 }, property: "alpha", transition: { hide: Strong.easeOut, show: Strong.easeOut }, useseconds: true };
var __tween:Tween;
//
this.buttonMode = true;
//
function __destroytween(event:TweenEvent = undefined):void {
	try {
		this.__tween.stop();
	}
	catch (_error:Error) {
		//...
	};
	try {
		this.__tween.addEventListener(TweenEvent.MOTION_FINISH, this.__destroytween);
	}
	catch (_error:Error) {
		//...
	};
	try {
		this[this.__TWEENPARAMS.property] = this.__tween.finish;
	}
	catch (_error:Error) {
		//...
	};
	if (this[this.__TWEENPARAMS.property] == this.__TWEENPARAMS.final.hide) this.visible = false;
	this.__tween = undefined;
};
//
function onRollOut(event:MouseEvent):void {
	//updating visual state...
	try {
		this.onItemRollOut();
	}
	catch (_error:Error) {
		//...
	};
	//external...
	try {
		this.isRollOut(this);
	}
	catch (_error:Error) {
		//...
	};
};
function onRollOver(event:MouseEvent):void {
	//hide menu start button...
	this.setVisible(false);
	//updating visual state...
	try {
		this.onItemRollOver();
	}
	catch (_error:Error) {
		//...
	};
	//external...
	try {
		this.isRollOver(this);
	}
	catch (_error:Error) {
		//...
	};
};
//event handlers...
this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
//interface...
this.getVisible = function():Boolean {
	return (this.alpha > 0);
};
this.setVisible = function(boolVisible:Boolean):void {
	if (!(boolVisible is Boolean)) return;
	this.__destroytween();
	var _transition:Function;
	var _final:Number;
	var _duration:Number;
	if (boolVisible) {
		this.visible = true;
		if (this[this.__TWEENPARAMS.property] == this.__TWEENPARAMS.final.show) return;
		_transition = this.__TWEENPARAMS.transition.show;
		_final = this.__TWEENPARAMS.final.show;
		_duration = this.__TWEENPARAMS.duration.show;
	}
	else  {
		if (this[this.__TWEENPARAMS.property] == this.__TWEENPARAMS.final.hide) return;
		_transition = this.__TWEENPARAMS.transition.hide;
		_final = this.__TWEENPARAMS.final.hide;
		_duration = this.__TWEENPARAMS.duration.hide;
	};
	this.__tween = new Tween(this, this.__TWEENPARAMS.property, _transition, this[this.__TWEENPARAMS.property], _final, _duration, this.__TWEENPARAMS.useseconds);
	this.__tween.addEventListener(TweenEvent.MOTION_FINISH, this.__destroytween);
};