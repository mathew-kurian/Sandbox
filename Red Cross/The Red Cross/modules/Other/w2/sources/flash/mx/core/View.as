class mx.core.View extends mx.core.UIComponent
{
	var tabChildren, tabEnabled, boundingBox_mc, border_mc, __get__width, __get__height, __tabIndex, depth, createObject, createClassObject, loadExternal, destroyObject, createClassChildAtDepth, doLater;
	function View () {
		super();
	}
	function init() {
		super.init();
		tabChildren = true;
		tabEnabled = false;
		boundingBox_mc._visible = false;
		boundingBox_mc._width = (boundingBox_mc._height = 0);
	}
	function size() {
		border_mc.move(0, 0);
		border_mc.setSize(__get__width(), __get__height());
		doLayout();
	}
	function draw() {
		this.size();
	}
	function get numChildren() {
		var _local3 = childNameBase;
		var _local2 = 0;
		while (true) {
			if (this[_local3 + _local2] == undefined) {
				return(_local2);
			}
			_local2++;
		}
	}
	function get tabIndex() {
		return((tabEnabled ? (__tabIndex) : undefined));
	}
	function set tabIndex(n) {
		__tabIndex = n;
		//return(tabIndex);
	}
	function addLayoutObject(object) {
	}
	function createChild(className, instanceName, initProps) {
		if (depth == undefined) {
			depth = 1;
		}
		var _local2;
		if (typeof(className) == "string") {
			_local2 = createObject(className, instanceName, depth++, initProps);
		} else {
			_local2 = createClassObject(className, instanceName, depth++, initProps);
		}
		if (_local2 == undefined) {
			_local2 = loadExternal(className, _loadExternalClass, instanceName, depth++, initProps);
		} else {
			this[childNameBase + numChildren] = _local2;
			_local2._complete = true;
			childLoaded(_local2);
		}
		addLayoutObject(_local2);
		return(_local2);
	}
	function getChildAt(childIndex) {
		return(this[childNameBase + childIndex]);
	}
	function destroyChildAt(childIndex) {
		if (!((childIndex >= 0) && (childIndex < numChildren))) {
			return(undefined);
		}
		var _local4 = childNameBase + childIndex;
		var _local6 = numChildren;
		var _local3;
		for (_local3 in this) {
			if (_local3 == _local4) {
				_local4 = "";
				destroyObject(_local3);
				break;
			}
		}
		var _local2 = Number(childIndex);
		while (_local2 < (_local6 - 1)) {
			this[childNameBase + _local2] = this[childNameBase + (_local2 + 1)];
			_local2++;
		}
		delete this[childNameBase + (_local6 - 1)];
		depth--;
	}
	function initLayout() {
		if (!hasBeenLayedOut) {
			doLayout();
		}
	}
	function doLayout() {
		hasBeenLayedOut = true;
	}
	function createChildren() {
		if (border_mc == undefined) {
			border_mc = createClassChildAtDepth(_global.styles.rectBorderClass, mx.managers.DepthManager.kBottom, {styleName:this});
		}
		doLater(this, "initLayout");
	}
	function convertToUIObject(obj) {
	}
	function childLoaded(obj) {
		convertToUIObject(obj);
	}
	static function extension() {
		mx.core.ExternalContent.enableExternalContent();
	}
	static var symbolName = "View";
	static var symbolOwner = mx.core.View;
	static var version = "2.0.2.127";
	var className = "View";
	static var childNameBase = "_child";
	var hasBeenLayedOut = false;
	var _loadExternalClass = "UIComponent";
}
