class mx.core.ExternalContent
{
	var createObject, numChildren, prepList, doLater, loadList, dispatchEvent, loadedList, childLoaded;
	function ExternalContent () {
	}
	function loadExternal(url, placeholderClassName, instanceName, depth, initProps) {
		var _local2;
		_local2 = createObject(placeholderClassName, instanceName, depth, initProps);
		this[mx.core.View.childNameBase + numChildren] = _local2;
		if (prepList == undefined) {
			prepList = new Object();
		}
		prepList[instanceName] = {obj:_local2, url:url, complete:false, initProps:initProps};
		prepareToLoadMovie(_local2);
		return(_local2);
	}
	function prepareToLoadMovie(obj) {
		obj.unloadMovie();
		doLater(this, "waitForUnload");
	}
	function waitForUnload() {
		var _local3;
		for (_local3 in prepList) {
			var _local2 = prepList[_local3];
			if (_local2.obj.getBytesTotal() == 0) {
				if (loadList == undefined) {
					loadList = new Object();
				}
				loadList[_local3] = _local2;
				_local2.obj.loadMovie(_local2.url);
				delete prepList[_local3];
				doLater(this, "checkLoadProgress");
			} else {
				doLater(this, "waitForUnload");
			}
		}
	}
	function checkLoadProgress() {
		var _local8 = false;
		var _local3;
		for (_local3 in loadList) {
			var _local2 = loadList[_local3];
			_local2.loaded = _local2.obj.getBytesLoaded();
			_local2.total = _local2.obj.getBytesTotal();
			if (_local2.total > 0) {
				_local2.obj._visible = false;
				dispatchEvent({type:"progress", target:_local2.obj, current:_local2.loaded, total:_local2.total});
				if (_local2.loaded == _local2.total) {
					if (loadedList == undefined) {
						loadedList = new Object();
					}
					loadedList[_local3] = _local2;
					delete loadList[_local3];
					doLater(this, "contentLoaded");
				}
			} else if (_local2.total == -1) {
				if (_local2.failedOnce != undefined) {
					_local2.failedOnce++;
					if (_local2.failedOnce > 3) {
						dispatchEvent({type:"complete", target:_local2.obj, current:_local2.loaded, total:_local2.total});
						delete loadList[_local3];
					}
				} else {
					_local2.failedOnce = 0;
				}
			}
			_local8 = true;
		}
		if (_local8) {
			doLater(this, "checkLoadProgress");
		}
	}
	function contentLoaded() {
		var _local4;
		for (_local4 in loadedList) {
			var _local2 = loadedList[_local4];
			_local2.obj._visible = true;
			_local2.obj._complete = true;
			var _local3;
			for (_local3 in _local2.initProps) {
				_local2.obj[_local3] = _local2.initProps[_local3];
			}
			childLoaded(_local2.obj);
			dispatchEvent({type:"complete", target:_local2.obj, current:_local2.loaded, total:_local2.total});
			delete loadedList[_local4];
		}
	}
	function convertToUIObject(obj) {
		if (obj.setSize == undefined) {
			var _local2 = mx.core.UIObject.prototype;
			obj.addProperty("width", _local2.__get__width, null);
			obj.addProperty("height", _local2.__get__height, null);
			obj.addProperty("left", _local2.__get__left, null);
			obj.addProperty("x", _local2.__get__x, null);
			obj.addProperty("top", _local2.__get__top, null);
			obj.addProperty("y", _local2.__get__y, null);
			obj.addProperty("right", _local2.__get__right, null);
			obj.addProperty("bottom", _local2.__get__bottom, null);
			obj.addProperty("visible", _local2.__get__visible, _local2.__set__visible);
			obj.move = mx.core.UIObject.prototype.move;
			obj.setSize = mx.core.UIObject.prototype.setSize;
			obj.size = mx.core.UIObject.prototype.size;
			mx.events.UIEventDispatcher.initialize(obj);
		}
	}
	static function enableExternalContent() {
	}
	static function classConstruct() {
		var _local1 = mx.core.View.prototype;
		var _local2 = mx.core.ExternalContent.prototype;
		_local1.loadExternal = _local2.loadExternal;
		_local1.prepareToLoadMovie = _local2.prepareToLoadMovie;
		_local1.waitForUnload = _local2.waitForUnload;
		_local1.checkLoadProgress = _local2.checkLoadProgress;
		_local1.contentLoaded = _local2.contentLoaded;
		_local1.convertToUIObject = _local2.convertToUIObject;
		return(true);
	}
	static var classConstructed = classConstruct();
	static var ViewDependency = mx.core.View;
}
