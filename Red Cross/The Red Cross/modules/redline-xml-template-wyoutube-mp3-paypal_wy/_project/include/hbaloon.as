/**
 * hbaloon.as
 * Horizontally oriented baloon
 *
 * @version		1.0
 */
import fl.transitions.*;
import fl.transitions.easing.*;
//
const __GUTTER:Number = 2;
const __TWEENPARAMS:Object = { duration: { hide: 1, show: 1 }, final: { hide: 0, show: 1 }, property: "alpha", transition: { hide: Strong.easeOut, show: Strong.easeOut }, useseconds: true };
//
var __bitmap:Bitmap = Bitmap(this.addChild(new Bitmap()));
var __bkg:Sprite = Sprite(this.addChild(new Sprite()));
var __border:Sprite = Sprite(this.addChild(new Sprite()));
var __status:Object = { anchoroffset: 0.5 * this.metrics.anchorHeight, anchorthick: 0.67 * this.metrics.anchorHeight, content: undefined, height: undefined, istext: false, textformat: undefined, visible: undefined, width: 200 };
var __tween:Tween;
var __txtduplicate:Bitmap;
//
this.__status.istext = (this.txt is TextField);
if (this.__status.istext) {
	this.swapChildren(this.txt, this.__bkg);
	this.__txtduplicate = Bitmap(this.addChild(new Bitmap()));
	this.txt.x = this.txt.y = this.metrics.cornerRadius;
	this.__txtduplicate.x = this.__txtduplicate.y = this.metrics.cornerRadius + this.__GUTTER;
	this.__status.textformat = this.txt.getTextFormat();
};
this.metrics.cornerRadius *= 2;
this.__border.blendMode = BlendMode.ADD;
//utilities...
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
	this.__tween = undefined;
};
function __draw():void {
	//drawing baloon...
	var _radius:Number = 0.5 * this.metrics.cornerRadius;
	var _stroke:Number = 0.5 * this.metrics.strokeBorder;
	var _width:Number = this.__status.width - _stroke;
	var _height:Number = this.__status.height - _stroke;
	this.__bkg.graphics.lineStyle(this.metrics.strokeBorder, this.metrics.colorBkg, this.metrics.alphaBkg, true);
	this.__border.graphics.lineStyle(this.metrics.strokeBorder, this.metrics.colorBorder, this.metrics.alphaBorder, true);
	this.__bkg.graphics.beginFill(this.metrics.colorBkg, this.metrics.alphaBkg);
	var _coord1:Number, _coord2:Number, _coord3:Number, _coord4:Number, _coord5:Number, _coord6:Number;
	_coord1 = _radius + _stroke;
	this.__bkg.graphics.moveTo(_stroke, _coord1);
	this.__border.graphics.moveTo(_stroke, _coord1);
	this.__bkg.graphics.curveTo(_stroke, _stroke, _coord1, _stroke);
	this.__border.graphics.curveTo(_stroke, _stroke, _coord1, _stroke);
	this.__bkg.graphics.lineTo(_width, _stroke);
	this.__border.graphics.lineTo(_width, _stroke);
	_coord2 = _width - _radius;
	_coord3 = _height - this.metrics.anchorHeight - _radius;
	this.__bkg.graphics.lineTo(_width, _coord3);
	this.__border.graphics.lineTo(_width, _coord3);
	_coord4 = _height - this.metrics.anchorHeight;
	this.__bkg.graphics.curveTo(_width, _coord4, _coord2, _coord4);
	this.__border.graphics.curveTo(_width, _coord4, _coord2, _coord4);
	_coord5 = this.metrics.anchorHeight + _stroke;
	this.__bkg.graphics.lineTo(_coord5, _coord4);
	this.__border.graphics.lineTo(_coord5, _coord4);
	_coord6 = _height - this.metrics.anchorHeight - _stroke;
	this.__bkg.graphics.curveTo(_stroke, _coord6, _stroke, _height);
	this.__border.graphics.curveTo(_stroke, _coord6, _stroke, _height);
	this.__bkg.graphics.lineTo(_stroke, _radius - _stroke);
	this.__border.graphics.lineTo(_stroke, _radius - _stroke);
	this.__bkg.graphics.endFill();
	//show...
	this.visible = true;
	this.__tween = new Tween(this, this.__TWEENPARAMS.property, this.__TWEENPARAMS.transition.show, this[this.__TWEENPARAMS.property], this.__TWEENPARAMS.final.show, this.__TWEENPARAMS.duration.show, this.__TWEENPARAMS.useseconds);
	this.__tween.addEventListener(TweenEvent.MOTION_FINISH, this.__onShow);
};
function __onHide(event:TweenEvent = undefined):void {
	this[this.__TWEENPARAMS.property] = this.__TWEENPARAMS.final.hide;
	this.visible = false;
	this.__destroytween();
	//content...
	this.__bkg.graphics.clear();
	this.__border.graphics.clear();
	if (this.__status.content is BitmapData) {
		this.txt.text = "";
		this.txt.visible = false;
		this.__txtduplicate.bitmapData = undefined;
		this.__bitmap.mask = this.__bkg;
		this.__bitmap.bitmapData = this.__status.content;
		this.__status.height = this.__bitmap.bitmapData.height;
	}
	else if (this.__status.content is String) {
		this.__bitmap.mask = null;
		this.__bitmap.bitmapData = undefined;
		this.txt.width = this.__status.width - this.metrics.cornerRadius;
		this.txt.text = this.__status.content;
		this.txt.setTextFormat(this.__status.textformat);
		this.txt.autoSize = TextFieldAutoSize.LEFT;
		this.__txtduplicate.bitmapData = new BitmapData(this.txt.width, this.txt.height, true, 0x00000000);
		this.__txtduplicate.bitmapData.draw(this.txt);
		this.txt.visible = false;
		this.__txtduplicate.visible = true;
		this.__status.height = this.txt.height + this.metrics.cornerRadius + this.metrics.anchorHeight;
	}
	else {
		this.__bitmap.mask = null;
		if (this.__status.istext) {
			this.txt.text = "";
			this.txt.autoSize = TextFieldAutoSize.LEFT;
			this.__txtduplicate.bitmapData = undefined;
			this.__status.height = this.txt.height + 0.5 * this.metrics.cornerRadius;
		}
		else this.__status.height = 0;
		return;
	};
	//drawing bkg...
	this.__draw();
};
function __onShow(event:TweenEvent):void {
	this[this.__TWEENPARAMS.property] = this.__TWEENPARAMS.final.show;
	this.__destroytween();
	//content...
	if (this.__status.content is String) {
		this.txt.visible = true;
		this.__txtduplicate.visible = false;
	};
};
//interface...
this.getContent = function():* {
	return this.__status.content;
};
this.setContent = function(newContent:* = undefined, floatWidth:Number = undefined):void {
	this.__destroytween();
	if (!(newContent is BitmapData)) {
		if (!this.__status.istext) newContent = undefined
		else if (!(newContent is String)) newContent = undefined;
	}
	else floatWidth = newContent.width;
	if (isNaN(floatWidth)) floatWidth = this.__status.width
	else if (floatWidth <= this.metrics.cornerRadius + 2 * this.__status.anchoroffset + this.__status.anchorthick) floatWidth = this.__status.width;
	this.__status.width = floatWidth;
	//hide...
	if (this.__status.content) {
		this.__status.content = newContent;
		if (this.__status.content is String) {
			this.txt.visible = true;
			this.__txtduplicate.visible = false;
		};
		this.__tween = new Tween(this, this.__TWEENPARAMS.property, this.__TWEENPARAMS.transition.hide, this[this.__TWEENPARAMS.property], this.__TWEENPARAMS.final.hide, this.__TWEENPARAMS.duration.hide, this.__TWEENPARAMS.useseconds);
		this.__tween.addEventListener(TweenEvent.MOTION_FINISH, this.__onHide);
	}
	else {
		this.__status.content = newContent;
		this.__onHide();
	};
};
this.setWidth = function(floatWidth:Number):void {
	if (isNaN(floatWidth)) return;
	if (floatWidth <= this.metrics.cornerRadius + 2 * this.__status.anchoroffset + this.__status.anchorthick) return;
	this.__draw();
};