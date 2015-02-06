/**
 * PlayerControl core
 * Players Controller core
 *
 * @version		1.0
 */
var __ready:Boolean = false;
var __enabled:Object = { };
//init...
for (var e in this.controls) this.__enabled[e] = false;
//
function __invalid(target:MovieClip, strMethod:String):Boolean {
	if (target is MovieClip) {
		if (target[strMethod] is Function) return false
		else return true;
	}
	else return true;
};
function __setup(target:*, boolVisible:Boolean):void {
	try {
		target.visible = Boolean(boolVisible);
	}
	catch (_error:Error) {
		//...
	};
	if (!boolVisible) {
		try {
			target.setCurrent(0);
		}
		catch (_error:Error) {
			//...
		};
		try {
			target.setLoaded(0);
		}
		catch (_error:Error) {
			//...
		};
	};
};
function __onInit(event:Event):void {
	var target:MovieClip;
	//display...
	try {
		target = this.controls.display;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		if (this.__invalid(target, "setTimeElapsed")) return;
		if (this.__invalid(target, "setTimeTotal")) return;
	};
	//mute button...
	target = undefined;
	try {
		target = this.controls.btnmute;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		if (this.__invalid(target, "setState")) return;
	};
	//repeat button...
	target = undefined;
	try {
		target = this.controls.btnrepeat;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		if (this.__invalid(target, "setState")) return;
	};
	//seek bar...
	target = undefined;
	try {
		target = this.controls.seekbar;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		if (this.__invalid(target, "setCurrent")) return;
		if (this.__invalid(target, "setHeight")) return;
		if (this.__invalid(target, "setLoaded")) return;
		if (this.__invalid(target, "setWidth")) return;
	};
	//volume bar...
	target = undefined;
	try {
		target = this.controls.volumebar;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		if (this.__invalid(target, "setCurrent")) return;
		if (this.__invalid(target, "setHeight")) return;
		if (this.__invalid(target, "setWidth")) return;
	};
	//
	this.removeEventListener(Event.ENTER_FRAME, this.__onInit);
	//mute button...
	target = undefined;
	try {
		target = this.controls.btnmute;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		this.controls.btnmute.setState(false);
	};
	//repeat button...
	target = undefined;
	try {
		target = this.controls.btnrepeat;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		this.controls.btnrepeat.setState(false);
	};
	//seek bar...
	target = undefined;
	try {
		target = this.controls.seekbar;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		this.controls.seekbar.setHeight(this.seekbarHeight);
		this.controls.seekbar.setWidth(this.seekbarWidth);
	};
	//volume bar...
	target = undefined;
	try {
		target = this.controls.volumebar;
	}
	catch (_error:Error) {
		//...
	};
	if (target is MovieClip) {
		this.controls.volumebar.setHeight(this.volumebarHeight);
		this.controls.volumebar.setWidth(this.volumebarWidth);
	};
	//updating status...
	this.__ready = true;
	//
	this.setControls( { display: true, 
						btnmute: true, 
						btnpause: false, 
						btnplay: true, 
						btnrepeat: true, 
						btnview: true, 
						mediainfo: true, 
						seekbar: true, 
						volumebar: true } );
	this.setBackground(false);
	this.stopBuffer();
	this.setCurrent(0);
	this.setLoaded(0);
	this.setMediaInfo("");
	this.setMute(false);
	this.setPlay(true);
	this.setRepeat(false);
	this.setTimeTotal(0);
	this.setTimeElapsed(0);
	this.setVolume(0);
};
//external...
this.getBackground = function():Boolean {
	try {
		return this.controls.backgnd.visible;
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setBackground = function(boolVisible:Boolean):void {
	if (!(boolVisible is Boolean)) return;
	try {
		this.controls.backgnd.visible = boolVisible;
	}
	catch (_error:Error) {
		//...
	};
};
this.getBuffer = function():Number {
	try {
		return this.controls.buffer.getBuffer();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setBuffer = function(newBuffer:*):void {
	if (this.__enabled.buffer) {
		try {
			this.controls.buffer.setBuffer(newBuffer);
		}
		catch (_error:Error) {
			//...
		};
	};
};
this.stopBuffer = function():void {
	try {
		this.controls.buffer.stopBuffer();
	}
	catch (_error:Error) {
		//...
	};
};
this.getControls = function():Object {
	//output: controls references...
	var _controls:Object = { };
	for (var i in this.controls) {
		try {
			_controls[i] = this.controls[i];
		}
		catch (_error:Error) {
			//...
		};
	};
	return _controls;
};
this.setControls = function(objControls:Object):void {
	//input: booleans...
	if (!objControls) {
		this.visible = false;
		return;
	};
	var isvisible:Boolean = false;
	for (var i in objControls) {
		this.isvisible = this.isvisible || (objControls[i] && this.controls[i]);
		try {
			this.__enabled[i] = objControls[i];
		}
		catch (_error:Error) {
			//...
		};
		try {
			this.__setup(this.controls[i], objControls[i]);
		}
		catch (_error:Error) {
			//...
		};
	};
	
	try {
		this.controls.buffer.stopBuffer();
	}
	catch (_error:Error) {
		//...
	};
	this.visible = this.isvisible;
};
this.getCurrent = function():Number {
	try {
		return this.controls.seekbar.getCurrent();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setCurrent = function(floatCurrent:Number):void {
	try {
		this.controls.seekbar.setCurrent(floatCurrent);
	}
	catch (_error:Error) {
		//...
	};
};
this.getLoaded = function():Number {
	try {
		return this.controls.seekbar.getLoaded();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setLoaded = function(floatLoaded:Number):void {
	try {
		this.controls.seekbar.setLoaded(floatLoaded);
	}
	catch (_error:Error) {
		//...
	};
};
this.getMediaInfo = function():String {
	try {
		return this.mediainfoText.text;
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setMediaInfo = function(strMediaInfo:String):void {
	if (this.__enabled.mediainfo) {
		try {
			var _fmediainfo:TextFormat = this.mediainfoText.getTextFormat();
			this.mediainfoText.text = strMediaInfo;
			this.mediainfoText.setTextFormat(_fmediainfo);
		}
		catch (_error:Error) {
			//...
		};
	};
};
this.getMute = function():Boolean {
	try {
		return this.controls.btnmute.getState();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setMute = function(boolMute:Boolean):void {
	try {
		this.controls.btnmute.setState(boolMute);
	}
	catch (_error:Error) {
		//...
	};
};
this.getNext = function():MovieClip {
	try {
		return this.btnNext;
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.getPrevious = function():MovieClip {
	try {
		return this.btnPrevious;
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setPlay = function(boolPlay:Boolean):void {
	if (this.__enabled.btnpause) {
		try {
			this.controls.btnpause.setActive(boolPlay);
		}
		catch (_error:Error) {
			//...
		};
	};
	if (this.__enabled.btnplay) {
		try {
			this.controls.btnplay.setActive(!boolPlay);
		}
		catch (_error:Error) {
			//...
		};
	};
};
this.getRepeat = function():Boolean {
	try {
		return this.controls.btnrepeat.getState();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setRepeat = function(boolRepeat:Boolean):void {
	try {
		this.controls.btnrepeat.setState(boolRepeat);
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
		this.controls.display.setTimeElapsed(floatTimeElapsed);
	}
	catch (_error:Error) {
		//...
	};
};
this.getTimeTotal = function():Number {
	try {
		return this.controls.display.getTimeTotal();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setTimeTotal = function(floatTimeTotal:Number):void {
	try {
		this.controls.display.setTimeTotal(floatTimeTotal);
	}
	catch (_error:Error) {
		//...
	};
};
this.getVolume = function():Number {
	try {
		return this.controls.volumebar.getCurrent();
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setVolume = function(floatVolume:Number):void {
	try {
		this.controls.volumebar.setCurrent(floatVolume);
	}
	catch (_error:Error) {
		//...
	};
};
//get status...
this.isReady = function():Boolean {
	return this.__ready;
};
//
this.addEventListener(Event.ENTER_FRAME, this.__onInit);