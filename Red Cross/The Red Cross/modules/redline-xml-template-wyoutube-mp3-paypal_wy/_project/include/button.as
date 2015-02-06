/**
 * button.as
 * buttons/bars event handlers: onRollOut, onRollOver
 *
 * @version		1.0
 */
//button mode...
this.buttonMode = true;
//event handlers...
this.addEventListener(MouseEvent.MOUSE_OUT, this.__onRollOut);
this.addEventListener(MouseEvent.MOUSE_OVER, this.__onRollOver);
function __onRollOut(event:MouseEvent = undefined):void {
	try {
		this.rollOut();
	}
	catch (_error:Error) {
		//...
	};
};
function __onRollOver(event:MouseEvent):void {
	try {
		this.rollOver();
	}
	catch (_error:Error) {
		//...
	};
};
//init...
this.__onRollOut();