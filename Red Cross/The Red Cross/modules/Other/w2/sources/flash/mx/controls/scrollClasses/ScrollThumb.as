class mx.controls.scrollClasses.ScrollThumb extends mx.skins.CustomBorder
{
	var useHandCursor, ymin, ymax, datamin, datamax, scrollMove, lastY, _ymouse, _y, _parent, onMouseMove, grip_mc, setSkin, gripSkin, __get__width, __get__height;
	function ScrollThumb () {
		super();
	}
	function createChildren(Void) {
		super.createChildren();
		useHandCursor = false;
	}
	function setRange(_ymin, _ymax, _datamin, _datamax) {
		ymin = _ymin;
		ymax = _ymax;
		datamin = _datamin;
		datamax = _datamax;
	}
	function dragThumb(Void) {
		scrollMove = _ymouse - lastY;
		scrollMove = scrollMove + _y;
		if (scrollMove < ymin) {
			scrollMove = ymin;
		} else if (scrollMove > ymax) {
			scrollMove = ymax;
		}
		_parent.isScrolling = true;
		_y = scrollMove;
		var _local2 = Math.round(((datamax - datamin) * (_y - ymin)) / (ymax - ymin)) + datamin;
		_parent.scrollPosition = _local2;
		_parent.dispatchScrollEvent("ThumbTrack");
		updateAfterEvent();
	}
	function stopDragThumb(Void) {
		_parent.isScrolling = false;
		_parent.dispatchScrollEvent("ThumbPosition");
		_parent.dispatchScrollChangedEvent();
		delete onMouseMove;
	}
	function onPress(Void) {
		_parent.pressFocus();
		lastY = _ymouse;
		onMouseMove = dragThumb;
		super.onPress();
	}
	function onRelease(Void) {
		_parent.releaseFocus();
		stopDragThumb();
		super.onRelease();
	}
	function onReleaseOutside(Void) {
		_parent.releaseFocus();
		stopDragThumb();
		super.onReleaseOutside();
	}
	function draw() {
		super.draw();
		if (grip_mc == undefined) {
			setSkin(3, gripSkin);
		}
	}
	function size() {
		super.size();
		grip_mc.move((__get__width() - grip_mc.width) / 2, (__get__height() - grip_mc.height) / 2);
	}
	static var symbolOwner = mx.skins.CustomBorder.symbolOwner;
	var className = "ScrollThumb";
	var btnOffset = 0;
	var horizontal = false;
	var idNames = new Array("l_mc", "m_mc", "r_mc", "grip_mc");
}
