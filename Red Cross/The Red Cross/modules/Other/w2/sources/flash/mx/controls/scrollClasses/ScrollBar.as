class mx.controls.scrollClasses.ScrollBar extends mx.core.UIComponent
{
	var isScrolling, scrollTrack_mc, scrollThumb_mc, __height, tabEnabled, focusEnabled, boundingBox_mc, setSkin, upArrow_mc, _minHeight, _minWidth, downArrow_mc, createObject, createClassObject, enabled, _height, dispatchEvent, minMode, maxMode, plusMode, minusMode, _parent, getStyle, scrolling, _ymouse;
	function ScrollBar () {
		super();
	}
	function get scrollPosition() {
		return(_scrollPosition);
	}
	function set scrollPosition(pos) {
		_scrollPosition = pos;
		if (isScrolling != true) {
			pos = Math.min(pos, maxPos);
			pos = Math.max(pos, minPos);
			var _local3 = (((pos - minPos) * (scrollTrack_mc.height - scrollThumb_mc._height)) / (maxPos - minPos)) + scrollTrack_mc.top;
			scrollThumb_mc.move(0, _local3);
		}
		//return(scrollPosition);
	}
	function get pageScrollSize() {
		return(largeScroll);
	}
	function set pageScrollSize(lScroll) {
		largeScroll = lScroll;
		//return(pageScrollSize);
	}
	function set lineScrollSize(sScroll) {
		smallScroll = sScroll;
		//return(lineScrollSize);
	}
	function get lineScrollSize() {
		return(smallScroll);
	}
	function get virtualHeight() {
		return(__height);
	}
	function init(Void) {
		super.init();
		_scrollPosition = 0;
		tabEnabled = false;
		focusEnabled = false;
		boundingBox_mc._visible = false;
		boundingBox_mc._width = (boundingBox_mc._height = 0);
	}
	function createChildren(Void) {
		if (scrollTrack_mc == undefined) {
			setSkin(skinIDTrack, scrollTrackName);
		}
		scrollTrack_mc.visible = false;
		var _local3 = new Object();
		_local3.enabled = false;
		_local3.preset = mx.controls.SimpleButton.falseDisabled;
		_local3.initProperties = 0;
		_local3.autoRepeat = true;
		_local3.tabEnabled = false;
		var _local2;
		if (upArrow_mc == undefined) {
			_local2 = createButton(upArrowName, "upArrow_mc", skinIDUpArrow, _local3);
		}
		_local2.buttonDownHandler = onUpArrow;
		_local2.clickHandler = onScrollChanged;
		_minHeight = _local2.height;
		_minWidth = _local2.width;
		if (downArrow_mc == undefined) {
			_local2 = createButton(downArrowName, "downArrow_mc", skinIDDownArrow, _local3);
		}
		_local2.buttonDownHandler = onDownArrow;
		_local2.clickHandler = onScrollChanged;
		_minHeight = _minHeight + _local2.height;
	}
	function createButton(linkageName, id, skinID, o) {
		if (skinID == skinIDUpArrow) {
			o.falseUpSkin = upArrowUpName;
			o.falseDownSkin = upArrowDownName;
			o.falseOverSkin = upArrowOverName;
		} else {
			o.falseUpSkin = downArrowUpName;
			o.falseDownSkin = downArrowDownName;
			o.falseOverSkin = downArrowOverName;
		}
		var _local3 = createObject(linkageName, id, skinID, o);
		this[id].visible = false;
		this[id].useHandCursor = false;
		return(_local3);
	}
	function createThumb(Void) {
		var _local2 = new Object();
		_local2.validateNow = true;
		_local2.tabEnabled = false;
		_local2.leftSkin = thumbTopName;
		_local2.middleSkin = thumbMiddleName;
		_local2.rightSkin = thumbBottomName;
		_local2.gripSkin = thumbGripName;
		createClassObject(mx.controls.scrollClasses.ScrollThumb, "scrollThumb_mc", skinIDThumb, _local2);
	}
	function setScrollProperties(pSize, mnPos, mxPos, ls) {
		var _local4;
		var _local2 = scrollTrack_mc;
		pageSize = pSize;
		largeScroll = (((ls != undefined) && (ls > 0)) ? (ls) : (pSize));
		minPos = Math.max(mnPos, 0);
		maxPos = Math.max(mxPos, 0);
		_scrollPosition = Math.max(minPos, _scrollPosition);
		_scrollPosition = Math.min(maxPos, _scrollPosition);
		if (((maxPos - minPos) > 0) && (enabled)) {
			var _local5 = _scrollPosition;
			if (!initializing) {
				upArrow_mc.enabled = true;
				downArrow_mc.enabled = true;
			}
			_local2.onPress = (_local2.onDragOver = startTrackScroller);
			_local2.onRelease = releaseScrolling;
			_local2.onDragOut = (_local2.stopScrolling = stopScrolling);
			_local2.onReleaseOutside = releaseScrolling;
			_local2.useHandCursor = false;
			if (scrollThumb_mc == undefined) {
				createThumb();
			}
			var _local3 = scrollThumb_mc;
			if (scrollTrackOverName.length > 0) {
				_local2.onRollOver = trackOver;
				_local2.onRollOut = trackOut;
			}
			_local4 = (pageSize / ((maxPos - minPos) + pageSize)) * _local2.height;
			if (_local4 < _local3.minHeight) {
				if (_local2.height < _local3.minHeight) {
					_local3.__set__visible(false);
				} else {
					_local4 = _local3.minHeight;
					_local3.__set__visible(true);
					_local3.setSize(_minWidth, _local3.minHeight + 0);
				}
			} else {
				_local3.__set__visible(true);
				_local3.setSize(_minWidth, _local4);
			}
			_local3.setRange(upArrow_mc.__get__height() + 0, (virtualHeight - downArrow_mc.__get__height()) - _local3.__get__height(), minPos, maxPos);
			_local5 = Math.min(_local5, maxPos);
			scrollPosition = (Math.max(_local5, minPos));
		} else {
			scrollThumb_mc.__set__visible(false);
			if (!initializing) {
				upArrow_mc.enabled = false;
				downArrow_mc.enabled = false;
			}
			delete _local2.onPress;
			delete _local2.onDragOver;
			delete _local2.onRelease;
			delete _local2.onDragOut;
			delete _local2.onRollOver;
			delete _local2.onRollOut;
			delete _local2.onReleaseOutside;
		}
		if (initializing) {
			scrollThumb_mc.__set__visible(false);
		}
	}
	function setEnabled(enabledFlag) {
		super.setEnabled(enabledFlag);
		setScrollProperties(pageSize, minPos, maxPos, largeScroll);
	}
	function draw(Void) {
		if (initializing) {
			initializing = false;
			scrollTrack_mc.visible = true;
			upArrow_mc.__set__visible(true);
			downArrow_mc.__set__visible(true);
		}
		this.size();
	}
	function size(Void) {
		if (_height == 1) {
			return(undefined);
		}
		if (upArrow_mc == undefined) {
			return(undefined);
		}
		var _local3 = upArrow_mc.__get__height();
		var _local2 = downArrow_mc.__get__height();
		upArrow_mc.move(0, 0);
		var _local4 = scrollTrack_mc;
		_local4._y = _local3;
		_local4._height = (virtualHeight - _local3) - _local2;
		downArrow_mc.move(0, virtualHeight - _local2);
		setScrollProperties(pageSize, minPos, maxPos, largeScroll);
	}
	function dispatchScrollEvent(detail) {
		dispatchEvent({type:"scroll", detail:detail});
	}
	function isScrollBarKey(k) {
		if (k == 36) {
			if (scrollPosition != 0) {
				scrollPosition = (0);
				dispatchScrollEvent(minMode);
			}
			return(true);
		}
		if (k == 35) {
			if (scrollPosition < maxPos) {
				scrollPosition = (maxPos);
				dispatchScrollEvent(maxMode);
			}
			return(true);
		}
		return(false);
	}
	function scrollIt(inc, mode) {
		var _local3 = smallScroll;
		if (inc != "Line") {
			_local3 = ((largeScroll == 0) ? (pageSize) : (largeScroll));
		}
		var _local2 = _scrollPosition + (mode * _local3);
		if (_local2 > maxPos) {
			_local2 = maxPos;
		} else if (_local2 < minPos) {
			_local2 = minPos;
		}
		if (scrollPosition != _local2) {
			scrollPosition = (_local2);
			var _local4 = ((mode < 0) ? (minusMode) : (plusMode));
			dispatchScrollEvent(inc + _local4);
		}
	}
	function startTrackScroller(Void) {
		_parent.pressFocus();
		if (_parent.scrollTrackDownName.length > 0) {
			if (_parent.scrollTrackDown_mc == undefined) {
				_parent.setSkin(skinIDTrackDown, scrollTrackDownName);
			} else {
				_parent.scrollTrackDown_mc.visible = true;
			}
		}
		_parent.trackScroller();
		_parent.scrolling = setInterval(_parent, "scrollInterval", getStyle("repeatDelay"), "Page", -1);
	}
	function scrollInterval(inc, mode) {
		clearInterval(scrolling);
		if (inc == "Page") {
			trackScroller();
		} else {
			scrollIt(inc, mode);
		}
		scrolling = setInterval(this, "scrollInterval", getStyle("repeatInterval"), inc, mode);
	}
	function trackScroller(Void) {
		if ((scrollThumb_mc._y + scrollThumb_mc.__get__height()) < _ymouse) {
			scrollIt("Page", 1);
		} else if (scrollThumb_mc._y > _ymouse) {
			scrollIt("Page", -1);
		}
	}
	function dispatchScrollChangedEvent(Void) {
		dispatchEvent({type:"scrollChanged"});
	}
	function stopScrolling(Void) {
		clearInterval(_parent.scrolling);
		_parent.scrollTrackDown_mc.visible = false;
	}
	function releaseScrolling(Void) {
		_parent.releaseFocus();
		stopScrolling();
		_parent.dispatchScrollChangedEvent();
	}
	function trackOver(Void) {
		if (_parent.scrollTrackOverName.length > 0) {
			if (_parent.scrollTrackOver_mc == undefined) {
				_parent.setSkin(skinIDTrackOver, scrollTrackOverName);
			} else {
				_parent.scrollTrackOver_mc.visible = true;
			}
		}
	}
	function trackOut(Void) {
		_parent.scrollTrackOver_mc.visible = false;
	}
	function onUpArrow(Void) {
		_parent.scrollIt("Line", -1);
	}
	function onDownArrow(Void) {
		_parent.scrollIt("Line", 1);
	}
	function onScrollChanged(Void) {
		_parent.dispatchScrollChangedEvent();
	}
	static var symbolOwner = mx.core.UIComponent;
	var className = "ScrollBar";
	var minPos = 0;
	var maxPos = 0;
	var pageSize = 0;
	var largeScroll = 0;
	var smallScroll = 1;
	var _scrollPosition = 0;
	var scrollTrackName = "ScrollTrack";
	var scrollTrackOverName = "";
	var scrollTrackDownName = "";
	var upArrowName = "BtnUpArrow";
	var upArrowUpName = "ScrollUpArrowUp";
	var upArrowOverName = "ScrollUpArrowOver";
	var upArrowDownName = "ScrollUpArrowDown";
	var downArrowName = "BtnDownArrow";
	var downArrowUpName = "ScrollDownArrowUp";
	var downArrowOverName = "ScrollDownArrowOver";
	var downArrowDownName = "ScrollDownArrowDown";
	var thumbTopName = "ScrollThumbTopUp";
	var thumbMiddleName = "ScrollThumbMiddleUp";
	var thumbBottomName = "ScrollThumbBottomUp";
	var thumbGripName = "ScrollThumbGripUp";
	static var skinIDTrack = 0;
	static var skinIDTrackOver = 1;
	static var skinIDTrackDown = 2;
	static var skinIDUpArrow = 3;
	static var skinIDDownArrow = 4;
	static var skinIDThumb = 5;
	var idNames = new Array("scrollTrack_mc", "scrollTrackOver_mc", "scrollTrackDown_mc", "upArrow_mc", "downArrow_mc");
	var clipParameters = {minPos:1, maxPos:1, pageSize:1, scrollPosition:1, lineScrollSize:1, pageScrollSize:1, visible:1, enabled:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.scrollClasses.ScrollBar.prototype.clipParameters, mx.core.UIComponent.prototype.clipParameters);
	var initializing = true;
}
