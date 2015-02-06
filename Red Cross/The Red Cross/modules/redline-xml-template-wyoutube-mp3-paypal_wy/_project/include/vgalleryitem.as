/**
 * vgalleryitem.as
 * Vertically oriented gallery item core
 *
 * @version		1.0
 */
//constants...
//roll out visual update delay [ms]...
/* DO NOT REMOVE THIS LINE OF CODE */ const __ROLLOUT_DELAY:Number = 50;
//
var __locked:Boolean = false;
var __mouseover:Boolean = false;
var __selected:Boolean = false;
//delayed roll out update...
var __timerrollout:Timer = new Timer(this.__ROLLOUT_DELAY);
//info text format...
var __txtFormat:TextFormat = this.controls.info.getTextFormat();
//
this.buttonMode = true;
this.__timerrollout.addEventListener(TimerEvent.TIMER, this.__onTimerRollOut);
//
function __onMouseOut(event:MouseEvent):void {
	this.__mouseover = false;
	this.__timerrollout.start();
};
function __onMouseOver(event:MouseEvent):void {
	this.__mouseover = true;
	//updating visual state...
	if (!this.__selected) {
		try {
			this.rollOver();
		}
		catch (_error:Error) {
			//...
		};
	};
	//external...
	try {
		this.isMouseOver(this);
	}
	catch (_error:Error) {
		//...
	};
};
function __onTimerRollOut(event:TimerEvent):void {
	//timer stops...
	this.__timerrollout.stop();
	//updating visual state...
	if (!this.__selected) {
		try {
			this.rollOut();
		}
		catch (_error:Error) {
			//...
		};
	};
	//external...
	try {
		this.isMouseOut(this);
	}
	catch (_error:Error) {
		//...
	};
};
//event handlers...
this.addEventListener(MouseEvent.MOUSE_OUT, this.__onMouseOut);
this.addEventListener(MouseEvent.MOUSE_OVER, this.__onMouseOver);
//interface...
this.getInfo = function():String {
	try {
		return this.controls.info.text;
	}
	catch (_error:Error) {
		//...
	};
	return undefined;
};
this.setInfo = function(strInfo:String):void {
	if (!(strInfo is String)) return;
	try {
		this.controls.info.htmlText = strInfo;
		this.controls.info.setTextFormat(this.__txtFormat);
		this.controls.info.width = this.controls.info.width;
		this.controls.info.autoSize = TextFieldAutoSize.LEFT;
	}
	catch (_error:Error) {
		//...
	};
	try {
		this.onItemResize();
	}
	catch (_error:Error) {
		//...
	};
};
this.getLocked = function():Boolean {
	return this.__locked;
};
this.setLocked = function(boolLocked:Boolean):void {
	if (!(boolLocked is Boolean)) return;
	if (this.__locked == boolLocked) return;
	//timer stops...
	this.__timerrollout.stop();
	//updating status...
	this.__locked = boolLocked;
	//updating visuals...
	try {
		if (!this.__selected) {
			if (boolLocked || this.__mouseover) this.rollOver()
			else this.rollOut();
		};
	}
	catch (_error:Error) {
		//...
	};
};
this.getSelected = function():Boolean {
	return this.__selected;
};
this.setSelected = function(boolSelected:Boolean):void {
	if (!(boolSelected is Boolean)) return;
	if (boolSelected === this.__selected) return;
	//updating...
	this.__selected = boolSelected;
	try {
		this.rollOut();
	}
	catch (_error:Error) {
		//...
	};
	try {
		(boolSelected) ? this.selectedOn() : this.selectedOff();
	}
	catch (_error:Error) {
		//...
	};
};
//init...
try {
	this.rollOut();
}
catch (_error:Error) {
	//...
};
try {
	this.selectedOff();
}
catch (_error:Error) {
	//...
};