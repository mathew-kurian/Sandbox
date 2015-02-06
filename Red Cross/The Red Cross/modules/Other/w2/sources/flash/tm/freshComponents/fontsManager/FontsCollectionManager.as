class tm.freshComponents.fontsManager.FontsCollectionManager
{
	static var _fontsCollectionManager;
	var _collection, availableFontsCollection, _registeredFonts;
	function FontsCollectionManager () {
		mx.events.EventDispatcher.initialize(this);
		_collection = new Array();
		availableFontsCollection = new Array();
		_registeredFonts = new Array();
	}
	static function getInstance() {
		if (_fontsCollectionManager == undefined) {
			_global.fcFontsCollectionManager = new tm.freshComponents.fontsManager.FontsCollectionManager();
			_level0.fcFontsCollectionManager = _global.fcFontsCollectionManager;
			_fontsCollectionManager = _global.fcFontsCollectionManager;
		}
		return(_fontsCollectionManager);
	}
	function getFontFormat(textFormatName) {
		return(_collection[textFormatName]);
	}
	function addNewFont(fontName, fontUrl) {
		availableFontsCollection.push({name:fontName, url:fontUrl});
	}
	function registerTextFormat(textFormatName, targetTextField) {
		_collection[textFormatName] = targetTextField.getNewTextFormat();
		_registeredFonts.push(textFormatName);
		if ((_registeredFonts.length + _failedToLoadCounter) == availableFontsCollection.length) {
			var _local2 = {target:this, type:"onAvailableFontsRegistered"};
			dispatchEvent(_local2);
		}
	}
	function loadFont(fontFilePath, loadedFontsHolder) {
		var _local5 = loadedFontsHolder.createEmptyMovieClip("font_" + loadedFontsHolder.getNextHighestDepth(), loadedFontsHolder.getNextHighestDepth());
		var _local2 = new Object();
		_local2.onLoadError = mx.utils.Delegate.create(this, onFontLoadError);
		_local2.onLoadComplete = mx.utils.Delegate.create(this, onFontLoadComplete);
		_local2.onLoadInit = mx.utils.Delegate.create(this, onFontLoadInit);
		var _local3 = new MovieClipLoader();
		_local3.addListener(_local2);
		_local3.loadClip(fontFilePath, _local5);
	}
	function onFontLoadError(target_mc, errorCode, httpStatus) {
		_failedToLoadCounter++;
		if ((_registeredFonts.length + _failedToLoadCounter) == availableFontsCollection.length) {
			var _local2 = {target:this, type:"onAvailableFontsRegistered"};
			dispatchEvent(_local2);
		}
	}
	function onFontLoadComplete(target_mc, httpStatus) {
	}
	function onFontLoadInit(target_mc) {
	}
	function loadAvailableFonts(loadedFontsHolder) {
		_registeredFonts = new Array();
		if (availableFontsCollection && (availableFontsCollection.length > 0)) {
			var _local2 = 0;
			while (_local2 < availableFontsCollection.length) {
				loadFont(availableFontsCollection[_local2].url, loadedFontsHolder);
				_local2++;
			}
		} else {
			var _local4 = {target:this, type:"onAvailableFontsRegistered"};
			dispatchEvent(_local4);
		}
	}
	function isAvailableFontsRegistered() {
		if ((((availableFontsCollection && (availableFontsCollection.length > 0)) && (_registeredFonts)) && (_registeredFonts.length > 0)) && (_registeredFonts.length == availableFontsCollection.length)) {
			return(true);
		}
		return(false);
	}
	function isFontRegistered(textFormatName) {
		if ((_registeredFonts && (_registeredFonts.length > 0)) && (tm.utils.Utils.inArray(textFormatName, _registeredFonts))) {
			return(true);
		}
		return(false);
	}
	function onAvailableFontsRegistered() {
	}
	function dispatchEvent() {
	}
	function addEventListener() {
	}
	function removeEventListener() {
	}
	var _failedToLoadCounter = 0;
}
