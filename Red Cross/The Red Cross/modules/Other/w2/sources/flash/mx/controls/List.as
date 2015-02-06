class mx.controls.List extends mx.controls.listclasses.ScrollSelectList
{
	var border_mc, __labels, setDataProvider, roundUp, __get__rowCount, __dataProvider, __maxHPosition, invScrollProps, invalidate, __vPosition, getViewMetrics, setSize, __width, __rowHeight, totalWidth, totalHeight, displayWidth, __hScrollPolicy, vScroller, __hPosition, listContent, data, mask_mc, __height, __rowCount, invRowHeight, invLayoutContent, setScrollProperties, oldVWidth;
	function List () {
		super();
	}
	function setEnabled(v) {
		super.setEnabled(v);
		border_mc.backgroundColorName = (v ? "backgroundColor" : "backgroundDisabledColor");
		border_mc.invalidate();
	}
	function get labels() {
		return(__labels);
	}
	function set labels(lbls) {
		__labels = lbls;
		setDataProvider(lbls);
		//return(labels);
	}
	function setVPosition(pos) {
		pos = Math.min((__dataProvider.length - __get__rowCount()) + roundUp, pos);
		pos = Math.max(0, pos);
		super.setVPosition(pos);
	}
	function setHPosition(pos) {
		pos = Math.max(Math.min(__maxHPosition, pos), 0);
		super.setHPosition(pos);
		this.hScroll(pos);
	}
	function setMaxHPosition(pos) {
		__maxHPosition = pos;
		invScrollProps = true;
		invalidate();
	}
	function setHScrollPolicy(policy) {
		if ((policy.toLowerCase() == "auto") && (!autoHScrollAble)) {
			return(undefined);
		}
		super.setHScrollPolicy(policy);
		if (policy == "off") {
			setHPosition(0);
			setVPosition(Math.min((__dataProvider.length - __get__rowCount()) + roundUp, __vPosition));
		}
	}
	function setRowCount(rC) {
		if (isNaN(rC)) {
			return(undefined);
		}
		var _local2 = getViewMetrics();
		setSize(__width, ((__rowHeight * rC) + _local2.top) + _local2.bottom);
	}
	function layoutContent(x, y, tW, tH, dW, dH) {
		totalWidth = tW;
		totalHeight = tH;
		displayWidth = dW;
		var _local4 = (((__hScrollPolicy == "on") || (__hScrollPolicy == "auto")) ? (Math.max(tW, dW)) : (dW));
		super.layoutContent(x, y, _local4, dH);
	}
	function modelChanged(eventObj) {
		super.modelChanged(eventObj);
		var _local3 = eventObj.eventName;
		if ((((_local3 == "addItems") || (_local3 == "removeItems")) || (_local3 == "updateAll")) || (_local3 == "filterModel")) {
			invScrollProps = true;
			invalidate("invScrollProps");
		}
	}
	function onScroll(eventObj) {
		var _local3 = eventObj.target;
		if (_local3 == vScroller) {
			setVPosition(_local3.scrollPosition);
		} else {
			this.hScroll(_local3.scrollPosition);
		}
		super.onScroll(eventObj);
	}
	function hScroll(pos) {
		__hPosition = pos;
		listContent._x = -pos;
	}
	function init(Void) {
		super.init();
		if (labels.length > 0) {
			var _local6 = new Array();
			var _local3 = 0;
			while (_local3 < labels.length) {
				_local6.addItem({label:labels[_local3], data:data[_local3]});
				_local3++;
			}
			setDataProvider(_local6);
		}
		__maxHPosition = 0;
	}
	function createChildren(Void) {
		super.createChildren();
		listContent.setMask(MovieClip(mask_mc));
		border_mc.move(0, 0);
		border_mc.setSize(__width, __height);
	}
	function getRowCount(Void) {
		var _local2 = getViewMetrics();
		return(((__rowCount == 0) ? (Math.ceil(((__height - _local2.top) - _local2.bottom) / __rowHeight)) : (__rowCount)));
	}
	function size(Void) {
		super.size();
		configureScrolling();
		var _local3 = getViewMetrics();
		layoutContent(_local3.left, _local3.top, __width + __maxHPosition, totalHeight, (__width - _local3.left) - _local3.right, (__height - _local3.top) - _local3.bottom);
	}
	function draw(Void) {
		if (invRowHeight) {
			invScrollProps = true;
			super.draw();
			listContent.setMask(MovieClip(mask_mc));
			invLayoutContent = true;
		}
		if (invScrollProps) {
			configureScrolling();
			delete invScrollProps;
		}
		if (invLayoutContent) {
			var _local3 = getViewMetrics();
			layoutContent(_local3.left, _local3.top, __width + __maxHPosition, totalHeight, (__width - _local3.left) - _local3.right, (__height - _local3.top) - _local3.bottom);
		}
		super.draw();
	}
	function configureScrolling(Void) {
		var _local2 = __dataProvider.length;
		if (__vPosition > Math.max(0, (_local2 - getRowCount()) + roundUp)) {
			setVPosition(Math.max(0, Math.min((_local2 - getRowCount()) + roundUp, __vPosition)));
		}
		var _local3 = getViewMetrics();
		var _local4 = ((__hScrollPolicy != "off") ? (((__maxHPosition + __width) - _local3.left) - _local3.right) : ((__width - _local3.left) - _local3.right));
		if (_local2 == undefined) {
			_local2 = 0;
		}
		setScrollProperties(_local4, 1, _local2, __rowHeight);
		if (oldVWidth != _local4) {
			invLayoutContent = true;
		}
		oldVWidth = _local4;
	}
	static var symbolOwner = mx.controls.List;
	static var symbolName = "List";
	var className = "List";
	static var version = "2.0.2.127";
	var clipParameters = {rowHeight:1, enabled:1, visible:1, labels:1};
	var scrollDepth = 1;
	var __vScrollPolicy = "on";
	var autoHScrollAble = false;
}
