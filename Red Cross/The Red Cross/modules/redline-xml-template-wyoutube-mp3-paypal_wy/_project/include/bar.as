/**
 * PlayerControl's seekbar & volumebar core
 * Players Controller's seekbar & volumebar core
 *
 * @version		1.0
 */
const __functions:Array = [ "getHeight", "getWidth", "setHeight", "setWidth" ];
//
var _timer:Timer = new Timer(10);
_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
_timer.start();
function __onTimer(event:TimerEvent):void {
	if (!(this.controls.currentbar is MovieClip)) return;
	for (var i in this.__functions) {
		if (!(this.controls.currentbar[this.__functions[i]] is Function)) return;
	};
	if (this.controls.lodedbar is MovieClip) {
		for (var j in this.__functions) {
			if (!(this.controls.loadedbar[this.__functions[j]] is Function)) return;
		};
	};
	if (this.controls.rangebar is MovieClip) {
		for (var k in this.__functions) {
			if (!(this.controls.rangebar[this.__functions[k]] is Function)) return;
		};
	};
	var _timer:Timer = Timer(event.target);
	_timer.removeEventListener(TimerEvent.TIMER, this.__onTimer);
	_timer.stop();
	//interface...
	this.getCurrent = function():Number {
		try {
			return this.controls.currentbar.getWidth() / this.controls.rangebar.getWidth();
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setCurrent = function(floatCurrent:Number):void {
		if (isNaN(floatCurrent)) return;
		if (floatCurrent < 0) return;
		if (floatCurrent > 1) floatCurrent = 1;
		try {
			this.controls.currentbar.setWidth(floatCurrent * this.controls.rangebar.getWidth());
		}
		catch (_error:Error) {
			//...
		};
		try {
			this.controls.btnrollover.setWidth(floatCurrent * this.controls.rangebar.getWidth());
		}
		catch (_error:Error) {
			//...
		};
	};
	this.setHeight = function(floatHeight:Number):void {
		if (isNaN(floatHeight)) return;
		if (floatHeight < 0) return;
		this.controls.currentbar.setHeight(floatHeight);
		try {
			this.controls.loadedbar.setHeight(floatHeight);
		}
		catch (_error:Error) {
			//...
		};
		try {
			this.controls.rangebar.setHeight(floatHeight);
		}
		catch (_error:Error) {
			//...
		};
		try {
			this.controls.btnrollover.setHeight(floatHeight);
		}
		catch (_error:Error) {
			//...
		};
	};
	this.getLoaded = function():Number {
		try {
			this.controls.loadedbar.getWidth() / this.controls.rangebar.getWidth();
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setLoaded = function(floatLoaded:Number):void {
		if (isNaN(floatLoaded)) return;
		if (floatLoaded < 0) return;
		if (floatLoaded > 1) floatLoaded = 1;
		try {
			this.controls.loadedbar.setWidth(floatLoaded * this.rangebar.getWidth());
		}
		catch (_error:Error) {
			//...
		};
	};
	this.getWidth = function():Number {
		try {
			return this.controls.rangebar.getWidth();
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setWidth = function(floatWidth:Number):void {
		if (isNaN(floatWidth)) return;
		if (floatWidth < 0) return;
		try {
			this.controls.rangebar.setWidth(floatWidth);
		}
		catch (_error:Error) {
			//...
		};
	};
};