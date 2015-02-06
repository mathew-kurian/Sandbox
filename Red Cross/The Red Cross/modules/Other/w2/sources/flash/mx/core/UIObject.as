class mx.core.UIObject extends MovieClip
{
	var _width, _height, _x, _y, _parent, _minHeight, _minWidth, _visible, dispatchEvent, _xscale, _yscale, methodTable, onEnterFrame, tfList, __width, __height, moveTo, lineTo, createTextField, attachMovie, buildDepthTable, findNextAvailableDepth, idNames, childrenCreated, _name, createAccessibilityImplementation, _endInit, validateNow, hasOwnProperty, initProperties, stylecache, className, ignoreClassStyleDeclaration, _tf, fontFamily, fontSize, color, marginLeft, marginRight, fontStyle, fontWeight, textAlign, textIndent, textDecoration, embedFonts, styleName, enabled;
	function UIObject () {
		super();
		constructObject();
	}
	function get width() {
		return(_width);
	}
	function get height() {
		return(_height);
	}
	function get left() {
		return(_x);
	}
	function get x() {
		return(_x);
	}
	function get top() {
		return(_y);
	}
	function get y() {
		return(_y);
	}
	function get right() {
		return(_parent.width - (_x + width));
	}
	function get bottom() {
		return(_parent.height - (_y + height));
	}
	function getMinHeight(Void) {
		return(_minHeight);
	}
	function setMinHeight(h) {
		_minHeight = h;
	}
	function get minHeight() {
		return(getMinHeight());
	}
	function set minHeight(h) {
		setMinHeight(h);
		//return(minHeight);
	}
	function getMinWidth(Void) {
		return(_minWidth);
	}
	function setMinWidth(w) {
		_minWidth = w;
	}
	function get minWidth() {
		return(getMinWidth());
	}
	function set minWidth(w) {
		setMinWidth(w);
		//return(minWidth);
	}
	function setVisible(x, noEvent) {
		if (x != _visible) {
			_visible = x;
			if (noEvent != true) {
				dispatchEvent({type:(x ? "reveal" : "hide")});
			}
		}
	}
	function get visible() {
		return(_visible);
	}
	function set visible(x) {
		setVisible(x, false);
		//return(visible);
	}
	function get scaleX() {
		return(_xscale);
	}
	function set scaleX(x) {
		_xscale = x;
		//return(scaleX);
	}
	function get scaleY() {
		return(_yscale);
	}
	function set scaleY(y) {
		_yscale = y;
		//return(scaleY);
	}
	function doLater(obj, fn) {
		if (methodTable == undefined) {
			methodTable = new Array();
		}
		methodTable.push({obj:obj, fn:fn});
		onEnterFrame = doLaterDispatcher;
	}
	function doLaterDispatcher(Void) {
		delete onEnterFrame;
		if (invalidateFlag) {
			redraw();
		}
		var _local3 = methodTable;
		methodTable = new Array();
		if (_local3.length > 0) {
			var _local2;
			while (_local2 = _local3.shift() , _local2 != undefined) {
				_local2.obj[_local2.fn]();
			}
		}
	}
	function cancelAllDoLaters(Void) {
		delete onEnterFrame;
		methodTable = new Array();
	}
	function invalidate(Void) {
		invalidateFlag = true;
		onEnterFrame = doLaterDispatcher;
	}
	function invalidateStyle(Void) {
		invalidate();
	}
	function redraw(bAlways) {
		if (invalidateFlag || (bAlways)) {
			invalidateFlag = false;
			var _local2;
			for (_local2 in tfList) {
				tfList[_local2].draw();
			}
			draw();
			dispatchEvent({type:"draw"});
		}
	}
	function draw(Void) {
	}
	function move(x, y, noEvent) {
		var _local3 = _x;
		var _local2 = _y;
		_x = x;
		_y = y;
		if (noEvent != true) {
			dispatchEvent({type:"move", oldX:_local3, oldY:_local2});
		}
	}
	function setSize(w, h, noEvent) {
		var _local3 = __width;
		var _local2 = __height;
		__width = w;
		__height = h;
		this.size();
		if (noEvent != true) {
			dispatchEvent({type:"resize", oldWidth:_local3, oldHeight:_local2});
		}
	}
	function size(Void) {
		_width = __width;
		_height = __height;
	}
	function drawRect(x1, y1, x2, y2) {
		this.moveTo(x1, y1);
		this.lineTo(x2, y1);
		this.lineTo(x2, y2);
		this.lineTo(x1, y2);
		this.lineTo(x1, y1);
	}
	function createLabel(name, depth, text) {
		this.createTextField(name, depth, 0, 0, 0, 0);
		var _local2 = this[name];
		_local2._color = textColorList;
		_local2._visible = false;
		_local2.__text = text;
		if (tfList == undefined) {
			tfList = new Object();
		}
		tfList[name] = _local2;
		_local2.invalidateStyle();
		invalidate();
		_local2.styleName = this;
		return(_local2);
	}
	function createObject(linkageName, id, depth, initobj) {
		return(this.attachMovie(linkageName, id, depth, initobj));
	}
	function createClassObject(className, id, depth, initobj) {
		var _local3 = className.symbolName == undefined;
		if (_local3) {
			Object.registerClass(className.symbolOwner.symbolName, className);
		}
		var _local4 = mx.core.UIObject(createObject(className.symbolOwner.symbolName, id, depth, initobj));
		if (_local3) {
			Object.registerClass(className.symbolOwner.symbolName, className.symbolOwner);
		}
		return(_local4);
	}
	function createEmptyObject(id, depth) {
		return(createClassObject(mx.core.UIObject, id, depth));
	}
	function destroyObject(id) {
		var _local2 = this[id];
		if (_local2.getDepth() < 0) {
			var _local4 = buildDepthTable();
			var _local5 = findNextAvailableDepth(0, _local4, "up");
			var _local3 = _local5;
			_local2.swapDepths(_local3);
		}
		_local2.removeMovieClip();
		delete this[id];
	}
	function getSkinIDName(tag) {
		return(idNames[tag]);
	}
	function setSkin(tag, linkageName, initObj) {
		if (_global.skinRegistry[linkageName] == undefined) {
			mx.skins.SkinElement.registerElement(linkageName, mx.skins.SkinElement);
		}
		return(createObject(linkageName, getSkinIDName(tag), tag, initObj));
	}
	function createSkin(tag) {
		var _local2 = getSkinIDName(tag);
		createEmptyObject(_local2, tag);
		return(this[_local2]);
	}
	function createChildren(Void) {
	}
	function _createChildren(Void) {
		createChildren();
		childrenCreated = true;
	}
	function constructObject(Void) {
		if (_name == undefined) {
			return(undefined);
		}
		init();
		_createChildren();
		createAccessibilityImplementation();
		_endInit();
		if (validateNow) {
			redraw(true);
		} else {
			invalidate();
		}
	}
	function initFromClipParameters(Void) {
		var _local4 = false;
		var _local2;
		for (_local2 in clipParameters) {
			if (hasOwnProperty(_local2)) {
				_local4 = true;
				this["def_" + _local2] = this[_local2];
				delete this[_local2];
			}
		}
		if (_local4) {
			for (_local2 in clipParameters) {
				var _local3 = this["def_" + _local2];
				if (_local3 != undefined) {
					this[_local2] = _local3;
				}
			}
		}
	}
	function init(Void) {
		__width = _width;
		__height = _height;
		if (initProperties == undefined) {
			initFromClipParameters();
		} else {
			initProperties();
		}
		if (_global.cascadingStyles == true) {
			stylecache = new Object();
		}
	}
	function getClassStyleDeclaration(Void) {
		var _local4 = this;
		var _local3 = className;
		while (_local3 != undefined) {
			if (ignoreClassStyleDeclaration[_local3] == undefined) {
				if (_global.styles[_local3] != undefined) {
					return(_global.styles[_local3]);
				}
			}
			_local4 = _local4.__proto__;
			_local3 = _local4.className;
		}
	}
	function setColor(color) {
	}
	function __getTextFormat(tf, bAll) {
		var _local8 = stylecache.tf;
		if (_local8 != undefined) {
			var _local3;
			for (_local3 in mx.styles.StyleManager.TextFormatStyleProps) {
				if (bAll || (mx.styles.StyleManager.TextFormatStyleProps[_local3])) {
					if (tf[_local3] == undefined) {
						tf[_local3] = _local8[_local3];
					}
				}
			}
			return(false);
		}
		var _local6 = false;
		for (var _local3 in mx.styles.StyleManager.TextFormatStyleProps) {
			if (bAll || (mx.styles.StyleManager.TextFormatStyleProps[_local3])) {
				if (tf[_local3] == undefined) {
					var _local5 = _tf[_local3];
					if (_local5 != undefined) {
						tf[_local3] = _local5;
					} else if ((_local3 == "font") && (fontFamily != undefined)) {
						tf[_local3] = fontFamily;
					} else if ((_local3 == "size") && (fontSize != undefined)) {
						tf[_local3] = fontSize;
					} else if ((_local3 == "color") && (color != undefined)) {
						tf[_local3] = color;
					} else if ((_local3 == "leftMargin") && (marginLeft != undefined)) {
						tf[_local3] = marginLeft;
					} else if ((_local3 == "rightMargin") && (marginRight != undefined)) {
						tf[_local3] = marginRight;
					} else if ((_local3 == "italic") && (fontStyle != undefined)) {
						tf[_local3] = fontStyle == _local3;
					} else if ((_local3 == "bold") && (fontWeight != undefined)) {
						tf[_local3] = fontWeight == _local3;
					} else if ((_local3 == "align") && (textAlign != undefined)) {
						tf[_local3] = textAlign;
					} else if ((_local3 == "indent") && (textIndent != undefined)) {
						tf[_local3] = textIndent;
					} else if ((_local3 == "underline") && (textDecoration != undefined)) {
						tf[_local3] = textDecoration == _local3;
					} else if ((_local3 == "embedFonts") && (embedFonts != undefined)) {
						tf[_local3] = embedFonts;
					} else {
						_local6 = true;
					}
				}
			}
		}
		if (_local6) {
			var _local9 = styleName;
			if (_local9 != undefined) {
				if (typeof(_local9) != "string") {
					_local6 = _local9.__getTextFormat(tf, true, this);
				} else if (_global.styles[_local9] != undefined) {
					_local6 = _global.styles[_local9].__getTextFormat(tf, true, this);
				}
			}
		}
		if (_local6) {
			var _local10 = getClassStyleDeclaration();
			if (_local10 != undefined) {
				_local6 = _local10.__getTextFormat(tf, true, this);
			}
		}
		if (_local6) {
			if (_global.cascadingStyles) {
				if (_parent != undefined) {
					_local6 = _parent.__getTextFormat(tf, false);
				}
			}
		}
		if (_local6) {
			_local6 = _global.style.__getTextFormat(tf, true, this);
		}
		return(_local6);
	}
	function _getTextFormat(Void) {
		var _local2 = stylecache.tf;
		if (_local2 != undefined) {
			return(_local2);
		}
		_local2 = new TextFormat();
		__getTextFormat(_local2, true);
		stylecache.tf = _local2;
		if (enabled == false) {
			var _local3 = getStyle("disabledColor");
			_local2["color"] = _local3;
		}
		return(_local2);
	}
	function getStyleName(Void) {
		var _local2 = styleName;
		if (_local2 != undefined) {
			if (typeof(_local2) != "string") {
				return(_local2.getStyleName());
			}
			return(_local2);
		}
		if (_parent != undefined) {
			return(_parent.getStyleName());
		}
		return(undefined);
	}
	function getStyle(styleProp) {
		var _local3;
		_global.getStyleCounter++;
		if (this[styleProp] != undefined) {
			return(this[styleProp]);
		}
		var _local6 = styleName;
		if (_local6 != undefined) {
			if (typeof(_local6) != "string") {
				_local3 = _local6.getStyle(styleProp);
			} else {
				var _local7 = _global.styles[_local6];
				_local3 = _local7.getStyle(styleProp);
			}
		}
		if (_local3 != undefined) {
			return(_local3);
		}
		var _local7 = getClassStyleDeclaration();
		if (_local7 != undefined) {
			_local3 = _local7[styleProp];
		}
		if (_local3 != undefined) {
			return(_local3);
		}
		if (_global.cascadingStyles) {
			if (mx.styles.StyleManager.isInheritingStyle(styleProp) || (mx.styles.StyleManager.isColorStyle(styleProp))) {
				var _local5 = stylecache;
				if (_local5 != undefined) {
					if (_local5[styleProp] != undefined) {
						return(_local5[styleProp]);
					}
				}
				if (_parent != undefined) {
					_local3 = _parent.getStyle(styleProp);
				} else {
					_local3 = _global.style[styleProp];
				}
				if (_local5 != undefined) {
					_local5[styleProp] = _local3;
				}
				return(_local3);
			}
		}
		if (_local3 == undefined) {
			_local3 = _global.style[styleProp];
		}
		return(_local3);
	}
	static function mergeClipParameters(o, p) {
		for (var _local3 in p) {
			o[_local3] = p[_local3];
		}
		return(true);
	}
	static var symbolName = "UIObject";
	static var symbolOwner = mx.core.UIObject;
	static var version = "2.0.2.127";
	static var textColorList = {color:1, disabledColor:1};
	var invalidateFlag = false;
	var lineWidth = 1;
	var lineColor = 0;
	var tabEnabled = false;
	var clipParameters = {visible:1, minHeight:1, minWidth:1, maxHeight:1, maxWidth:1, preferredHeight:1, preferredWidth:1};
}
