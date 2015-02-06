class mx.core.ScrollView extends mx.core.View
{
	var __width, hScroller, vScroller, __maxHPosition, propsInited, scrollAreaChanged, specialHScrollCase, createObject, viewableColumns, __height, oldRndUp, viewableRows, __viewMetrics, owner, enabled, border_mc, __get__width, __get__height, invLayout, mask_mc, _parent, dispatchEvent;
	function ScrollView () {
		super();
	}
	function getHScrollPolicy(Void) {
		return(__hScrollPolicy);
	}
	function setHScrollPolicy(policy) {
		__hScrollPolicy = policy.toLowerCase();
		if (__width == undefined) {
			return(undefined);
		}
		setScrollProperties(numberOfCols, columnWidth, rowC, rowH, heightPadding, widthPadding);
	}
	function get hScrollPolicy() {
		return(getHScrollPolicy());
	}
	function set hScrollPolicy(policy) {
		setHScrollPolicy(policy);
		//return(hScrollPolicy);
	}
	function getVScrollPolicy(Void) {
		return(__vScrollPolicy);
	}
	function setVScrollPolicy(policy) {
		__vScrollPolicy = policy.toLowerCase();
		if (__width == undefined) {
			return(undefined);
		}
		setScrollProperties(numberOfCols, columnWidth, rowC, rowH, heightPadding, widthPadding);
	}
	function get vScrollPolicy() {
		return(getVScrollPolicy());
	}
	function set vScrollPolicy(policy) {
		setVScrollPolicy(policy);
		//return(vScrollPolicy);
	}
	function get hPosition() {
		return(getHPosition());
	}
	function set hPosition(pos) {
		setHPosition(pos);
		//return(hPosition);
	}
	function getHPosition(Void) {
		return(__hPosition);
	}
	function setHPosition(pos) {
		hScroller.__set__scrollPosition(pos);
		__hPosition = pos;
	}
	function get vPosition() {
		return(getVPosition());
	}
	function set vPosition(pos) {
		setVPosition(pos);
		//return(vPosition);
	}
	function getVPosition(Void) {
		return(__vPosition);
	}
	function setVPosition(pos) {
		vScroller.__set__scrollPosition(pos);
		__vPosition = pos;
	}
	function get maxVPosition() {
		var _local2 = vScroller.maxPos;
		return(((_local2 == undefined) ? 0 : (_local2)));
	}
	function get maxHPosition() {
		return(getMaxHPosition());
	}
	function set maxHPosition(pos) {
		setMaxHPosition(pos);
		//return(maxHPosition);
	}
	function getMaxHPosition(Void) {
		if (__maxHPosition != undefined) {
			return(__maxHPosition);
		}
		var _local2 = hScroller.maxPos;
		return(((_local2 == undefined) ? 0 : (_local2)));
	}
	function setMaxHPosition(pos) {
		__maxHPosition = pos;
	}
	function setScrollProperties(colCount, colWidth, rwCount, rwHeight, hPadding, wPadding) {
		var _local3 = getViewMetrics();
		if (hPadding == undefined) {
			hPadding = 0;
		}
		if (wPadding == undefined) {
			wPadding = 0;
		}
		propsInited = true;
		delete scrollAreaChanged;
		heightPadding = hPadding;
		widthPadding = wPadding;
		if (colWidth == 0) {
			colWidth = 1;
		}
		if (rwHeight == 0) {
			rwHeight = 1;
		}
		var _local4 = Math.ceil((((__width - _local3.left) - _local3.right) - widthPadding) / colWidth);
		if ((__hScrollPolicy == "on") || ((_local4 < colCount) && (__hScrollPolicy == "auto"))) {
			if ((hScroller == undefined) || (specialHScrollCase)) {
				delete specialHScrollCase;
				hScroller = mx.controls.scrollClasses.ScrollBar(createObject("HScrollBar", "hSB", 1001));
				hScroller.__set__lineScrollSize(20);
				hScroller.scrollHandler = scrollProxy;
				hScroller.__set__scrollPosition(__hPosition);
				scrollAreaChanged = true;
			}
			if ((((numberOfCols != colCount) || (columnWidth != colWidth)) || (viewableColumns != _local4)) || (scrollAreaChanged)) {
				hScroller.setScrollProperties(_local4, 0, colCount - _local4);
				viewableColumns = _local4;
				numberOfCols = colCount;
				columnWidth = colWidth;
			}
		} else if (((__hScrollPolicy == "auto") || (__hScrollPolicy == "off")) && (hScroller != undefined)) {
			hScroller.removeMovieClip();
			delete hScroller;
			scrollAreaChanged = true;
		}
		if (heightPadding == undefined) {
			heightPadding = 0;
		}
		var _local5 = Math.ceil((((__height - _local3.top) - _local3.bottom) - heightPadding) / rwHeight);
		var _local8 = (((__height - _local3.top) - _local3.bottom) % rwHeight) != 0;
		if ((__vScrollPolicy == "on") || ((_local5 < (rwCount + _local8)) && (__vScrollPolicy == "auto"))) {
			if (vScroller == undefined) {
				vScroller = mx.controls.scrollClasses.ScrollBar(createObject("VScrollBar", "vSB", 1002));
				vScroller.scrollHandler = scrollProxy;
				vScroller.__set__scrollPosition(__vPosition);
				scrollAreaChanged = true;
				rowH = 0;
			}
			if ((((rowC != rwCount) || (rowH != rwHeight)) || ((viewableRows + _local8) != (_local5 + oldRndUp))) || (scrollAreaChanged)) {
				vScroller.setScrollProperties(_local5, 0, (rwCount - _local5) + _local8);
				viewableRows = _local5;
				rowC = rwCount;
				rowH = rwHeight;
				oldRndUp = _local8;
			}
		} else if (((__vScrollPolicy == "auto") || (__vScrollPolicy == "off")) && (vScroller != undefined)) {
			vScroller.removeMovieClip();
			delete vScroller;
			scrollAreaChanged = true;
		}
		numberOfCols = colCount;
		columnWidth = colWidth;
		if (scrollAreaChanged) {
			doLayout();
			var _local2 = __viewMetrics;
			var _local12 = ((owner != undefined) ? (owner) : this);
			_local12.layoutContent(_local2.left, _local2.top, ((columnWidth * numberOfCols) - _local2.left) - _local2.right, rowC * rowH, (__width - _local2.left) - _local2.right, (__height - _local2.top) - _local2.bottom);
		}
		if (!enabled) {
			setEnabled(false);
		}
	}
	function getViewMetrics(Void) {
		var _local2 = __viewMetrics;
		var _local3 = border_mc.__get__borderMetrics();
		_local2.left = _local3.left;
		_local2.right = _local3.right;
		if (vScroller != undefined) {
			_local2.right = _local2.right + vScroller.minWidth;
		}
		_local2.top = _local3.top;
		if ((hScroller == undefined) && ((__hScrollPolicy == "on") || (__hScrollPolicy == true))) {
			hScroller = mx.controls.scrollClasses.ScrollBar(createObject("FHScrollBar", "hSB", 1001));
			specialHScrollCase = true;
		}
		_local2.bottom = _local3.bottom;
		if (hScroller != undefined) {
			_local2.bottom = _local2.bottom + hScroller.minHeight;
		}
		return(_local2);
	}
	function doLayout(Void) {
		var _local10 = __get__width();
		var _local8 = __get__height();
		delete invLayout;
		var _local3 = (__viewMetrics = getViewMetrics());
		var _local2 = _local3.left;
		var _local9 = _local3.right;
		var _local5 = _local3.top;
		var _local11 = _local3.bottom;
		var _local7 = hScroller;
		var _local6 = vScroller;
		_local7.setSize((_local10 - _local2) - _local9, _local7.minHeight + 0);
		_local7.move(_local2, _local8 - _local11);
		_local6.setSize(_local6.minWidth + 0, (_local8 - _local5) - _local11);
		_local6.move(_local10 - _local9, _local5);
		var _local4 = mask_mc;
		_local4._width = (_local10 - _local2) - _local9;
		_local4._height = (_local8 - _local5) - _local11;
		_local4._x = _local2;
		_local4._y = _local5;
	}
	function createChild(id, name, props) {
		var _local2 = super.createChild(id, name, props);
		return(_local2);
	}
	function init(Void) {
		super.init();
		__viewMetrics = new Object();
		if (_global.__SVMouseWheelManager == undefined) {
			var _local4 = (_global.__SVMouseWheelManager = new Object());
			_local4.onMouseWheel = __onMouseWheel;
			Mouse.addListener(_local4);
		}
	}
	function __onMouseWheel(delta, scrollTarget) {
		var _local4 = scrollTarget;
		var _local1;
		while (_local4 != undefined) {
			if (_local4 instanceof mx.core.ScrollView) {
				_local1 = _local4;
			}
			_local4 = _local4._parent;
		}
		if (_local1 != undefined) {
			_local4 = ((delta <= 0) ? 1 : -1);
			var _local2 = _local1.vScroller.lineScrollSize;
			if (_local2 == undefined) {
				_local2 = 0;
			}
			_local2 = Math.max(Math.abs(delta), _local2);
			var _local3 = _local1.vPosition + (_local2 * _local4);
			_local1.vPosition = Math.max(0, Math.min(_local3, _local1.maxVPosition));
			_local1.dispatchEvent({type:"scroll", direction:"vertical", position:_local1.vPosition});
		}
	}
	function createChildren(Void) {
		super.createChildren();
		if (mask_mc == undefined) {
			mask_mc = createObject("BoundingBox", "mask_mc", MASK_DEPTH);
		}
		mask_mc._visible = false;
	}
	function invalidate(Void) {
		super.invalidate();
	}
	function draw(Void) {
		this.size();
	}
	function size(Void) {
		super.size();
	}
	function scrollProxy(docObj) {
		_parent.onScroll(docObj);
	}
	function onScroll(docObj) {
		var _local3 = docObj.target;
		var _local2 = _local3.scrollPosition;
		if (_local3 == vScroller) {
			var _local4 = "vertical";
			var _local5 = "__vPosition";
		} else {
			var _local4 = "horizontal";
			var _local5 = "__hPosition";
		}
		this[_local5] = _local2;
		dispatchEvent({type:"scroll", direction:_local4, position:_local2});
	}
	function setEnabled(v) {
		vScroller.enabled = (hScroller.enabled = v);
	}
	function childLoaded(obj) {
		super.childLoaded(obj);
		obj.setMask(mask_mc);
	}
	static var symbolName = "ScrollView";
	static var symbolOwner = mx.core.ScrollView;
	static var version = "2.0.2.127";
	var className = "ScrollView";
	var __vScrollPolicy = "auto";
	var __hScrollPolicy = "off";
	var __vPosition = 0;
	var __hPosition = 0;
	var numberOfCols = 0;
	var rowC = 0;
	var columnWidth = 1;
	var rowH = 0;
	var heightPadding = 0;
	var widthPadding = 0;
	var MASK_DEPTH = 10000;
}
