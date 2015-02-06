class tm.freshComponents.tabFixer.TabManager
{
	static var _tabManager;
	var _targetObjects, _targetObjectsHandlers, _targetObjectsHandlersOwners, _noFocusMovieClip;
	function TabManager () {
		_targetObjects = new Array();
		_targetObjectsHandlers = new Array();
		_targetObjectsHandlersOwners = new Array();
		var _local4 = new Object();
		_local4.onKeyDown = tm.utils.Delegate.create(this, moveFocus);
		Key.addListener(_local4);
		var _local3 = new Object();
		_local3.onMouseMove = tm.utils.Delegate.create(this, mouseMoved);
		Mouse.addListener(_local3);
		_noFocusMovieClip = _root.createEmptyMovieClip("dummyTabManagerMovie", _root.getNextHighestDepth());
		_noFocusMovieClip.useHandCursor = false;
		_noFocusMovieClip.onRelease = function () {
		};
	}
	static function getInstance() {
		if (_tabManager == undefined) {
			_tabManager = new tm.freshComponents.tabFixer.TabManager();
		}
		return(_tabManager);
	}
	function mouseMoved() {
	}
	function moveFocus() {
		if (Key.getCode() == 13) {
			var selectedObject = eval (Selection.getFocus());
			var selectedObjectId = isItemPresent(Selection.getFocus(), _targetObjects);
			if (_targetObjectsHandlersOwners[selectedObjectId]) {
				var eFunction = _targetObjectsHandlersOwners[selectedObjectId][_targetObjectsHandlers[selectedObjectId]];
				eFunction.apply(_targetObjectsHandlersOwners[selectedObjectId], [selectedObject]);
			} else {
				var enterHandler = _targetObjectsHandlers[selectedObjectId];
				if (enterHandler && (enterHandler.length > 0)) {
					selectedObject[enterHandler](selectedObject);
				}
			}
		}
	}
	function registerTabFixer(items, enterHandler, enterHandlerOwner) {
		var _local2 = 0;
		while (_local2 < items.length) {
			if (isItemPresent(String(items[_local2]), _targetObjects) == -1) {
				_targetObjects.push(items[_local2]);
				_targetObjectsHandlers.push(enterHandler);
				_targetObjectsHandlersOwners.push(enterHandlerOwner);
			}
			_local2++;
		}
		updateTabIndexes();
	}
	function unregisterTabFixer(items) {
		var _local5 = new Array();
		var _local4 = new Array();
		var _local3 = new Array();
		var _local2 = 0;
		while (_local2 < _targetObjects.length) {
			if (isItemPresent(String(_targetObjects[_local2]), items) == -1) {
				_local5.push(_targetObjects[_local2]);
				_local4.push(_targetObjectsHandlers[_local2]);
				_local3.push(_targetObjectsHandlersOwners[_local2]);
			}
			_local2++;
		}
		_targetObjects = _local5.concat();
		_targetObjectsHandlers = _local4.concat();
		_targetObjectsHandlersOwners = _local3.concat();
	}
	function updateTabIndexes() {
		var _local2 = 0;
		while (_local2 < _targetObjects.length) {
			_targetObjects[_local2].tabIndex = _local2;
			_local2++;
		}
	}
	function isItemPresent(item, source) {
		var _local1 = 0;
		while (_local1 < source.length) {
			if (item == String(source[_local1])) {
				return(_local1);
			}
			_local1++;
		}
		return(-1);
	}
	function removeFocus() {
		Selection.setFocus(_noFocusMovieClip);
	}
}
