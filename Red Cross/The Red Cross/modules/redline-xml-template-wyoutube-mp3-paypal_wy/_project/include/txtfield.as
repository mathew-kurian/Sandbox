/**
 * TxtField scrollbar core
 * Custom text field scrollbar core
 *
 * @version		1.0
 */
var __cursor:Object = { height: 1, offset: 0, position: 0 };
//
var __timer:Timer = new Timer(10);
this.__timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
this.__timer.start();
function __onTimer(event:TimerEvent):void {
	if (!(this.controls.bar.setHeight is Function)) return;
	if (!(this.controls.cursor.setHeight is Function)) return;
	this.__timer.removeEventListener(TimerEvent.TIMER, this.__onTimer);
	this.__timer.stop();
	//interface...
	this.getHeight = function():Number {
		//output: pixels...
		try {
			return this.controls.bar.height;
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setHeight = function(floatHeight:Number):void {
		//input: pixels...
		if (isNaN(floatHeight)) return;
		if (floatHeight < 0) floatHeight = 0;
		//
		try {
			if (this.controls.bar.setHeight is Function) this.controls.bar.setHeight(floatHeight)
			else this.controls.bar.height = floatHeight;
		}
		catch (_error:Error) {
			//...
		};
		try {
			this.controls.hitarea.height = floatHeight;
		}
		catch (_error:Error) {
			//...
		};
		this.setCursorHeight(this.__cursor.height);
		this.setCursorPosition(this.__cursor.position);
	};
	this.getCursorHeight = function():Number {
		//output: fraction...
		try {
			return this.controls.cursor.height / this.controls.bar.height;
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setCursorHeight = function(floatHeight:Number):void {
		//input: fraction...
		if (isNaN(floatHeight)) return;
		if (floatHeight < 0) floatHeight = 0
		else if (floatHeight > 1) floatHeight = 1;
		//
		this.__onMouseUp();
		//
		try {
			(this.controls.cursor.setHeight is Function) ? this.controls.cursor.setHeight(floatHeight * this.controls.bar.height) : this.controls.cursor.height = floatHeight * this.controls.bar.height;
		}
		catch (_error:Error) {
			//...
		};
	};
	this.getCursorPosition = function():Number {
		//output: fraction...
		try {
			return this.controls.cursor.y / (this.controls.bar.height - this.controls.cursor.height);
		}
		catch (_error:Error) {
			//...
		};
		return undefined;
	};
	this.setCursorPosition = function(floatPosition:Number):void {
		//input: fraction...
		if (isNaN(floatPosition)) return;
		if (floatPosition < 0) floatPosition = 0
		else if (floatPosition > 1) floatPosition = 1;
		//
		try {
			this.controls.cursor.y = floatPosition * (this.controls.bar.height - this.controls.cursor.height);
		}
		catch (_error:Error) {
			//...
		};
	};
};
//
this.addEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseDown);
//
function __addlistener(target:EventDispatcher, event:*, listener:Function):void {
	try {
		target.removeEventListener(event, listener);
	}
	catch (_error:Error) {
		//...
	};
	target.addEventListener(event, listener);
};
function __onMouseDown(event:MouseEvent):void {
	this.__cursor.offset = (this.controls.cursor.mouseY < 0 || this.controls.cursor.mouseY > this.controls.cursor.height) ? 0.5 * this.controls.cursor.height : this.controls.cursor.mouseY;
	this.__addlistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
	this.__addlistener(this, MouseEvent.MOUSE_UP, this.__onMouseUp);
	this.__addlistener(this, MouseEvent.ROLL_OUT, this.__onMouseUp);
};
function __onMouseMove(event:MouseEvent):void {
	var _scroll:Number = (this.controls.bar.mouseY - this.__cursor.offset) / (this.controls.bar.height - this.controls.cursor.height);
	if (_scroll < 0) _scroll = 0
	else if (_scroll > 1) _scroll = 1;
	try {
		this.onScroll(_scroll);
	}
	catch (_error:Error) {
		//...
	};
};
function __onMouseUp(event:MouseEvent = undefined):void {
	try {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onMouseMove);
	}
	catch (_error:Error) {
		//...
	};
	try {
		this.removeEventListener(MouseEvent.MOUSE_UP, this.__onMouseUp);
	}
	catch (_error:Error) {
		//...
	};
	try {
		this.removeEventListener(MouseEvent.ROLL_OUT, this.__onMouseUp);
	}
	catch (_error:Error) {
		//...
	};
	//
	if (event is MouseEvent) this.__onMouseMove(event);
};