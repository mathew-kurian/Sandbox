/**
 * buffer.as
 * Buffer indicator interface
 *
 * @version		1.0
 */
var fbuffer:TextFormat;
var buffervalue:* = 0;
var isplaying:Boolean = false;
//
try {
	this.fbuffer = this.controls.txt.buffer.getTextFormat();
}
catch (_error:Error) {
	//...
};
try {
	this.controls.icon.gotoAndStop(this.controls.icon.totalFrames);
}
catch (_error:Error) {
	//...
};
//
this.getBuffer = function():Number {
	return ((!isNaN(this.buffervalue)) ? this.buffervalue : 0);
};
this.setBuffer = function(newBuffer:*):void {
	if (isNaN(newBuffer)) {
		if (!(newBuffer is String)) return;
	}
	else {
		newBuffer = Math.round(newBuffer);
		if (newBuffer < 0) newBuffer = 0;
		if (newBuffer > 100) newBuffer = 100;
		newBuffer += "%";
	};
	//
	this.buffervalue = newBuffer;
	try {
		this.controls.txt.buffer.text = newBuffer;
		this.controls.txt.buffer.setTextFormat(this.fbuffer);
	}
	catch (_error:Error) {
		//...
	};
	if (!this.isplaying) {
		this.isplaying = true;
		try {
			this.controls.icon.gotoAndPlay(1);
		}
		catch (_error) {
			//...
		};
	};
	this.visible = true;
};
this.stopBuffer = function():void {
	this.isplaying = false;
	this.buffervalue = 0;
	try {
		this.controls.txt.buffer.text = "";
		this.controls.txt.buffer.setTextFormat(this.fbuffer);
	}
	catch (_error:Error) {
		//...
	};
	try {
		this.controls.icon.gotoAndStop(this.controls.icon.totalFrames);
	}
	catch (_error:Error) {
		//...
	};
	this.visible = false;
};
this.stopBuffer();