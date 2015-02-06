class tm.freshComponents.fontsManager.FontsManager extends MovieClip
{
	var _visible, _libraryData, createEmptyMovieClip, getNextHighestDepth, fontsHolder;
	function FontsManager () {
		super();
		mx.events.EventDispatcher.initialize(this);
		_visible = false;
		loadLibrary();
	}
	function loadLibrary() {
		var _local2 = new tm.utils.XMLParser();
		_local2.load(fontsLibraryPath, this, onLibraryLoaded, killCache);
	}
	function onLibraryLoaded(success, data) {
		if (success) {
			_libraryData = data;
			var _local4 = _libraryData.fonts[0].font;
			var _local2 = 0;
			while (_local2 < _local4.length) {
				var _local3 = _local4[_local2].url;
				_local3 = ((fontsPath && (fontsPath.length > 0)) ? (fontsPath + "/") : "") + _local3;
				tm.freshComponents.fontsManager.FontsCollectionManager.getInstance().addNewFont(_local4[_local2].name, _local3);
				_local2++;
			}
			var _local5 = this.createEmptyMovieClip("fontsHolder", getNextHighestDepth());
			tm.freshComponents.fontsManager.FontsCollectionManager.getInstance().addEventListener("onAvailableFontsRegistered", tm.utils.Delegate.create(this, onLibraryFontsLoad));
			tm.freshComponents.fontsManager.FontsCollectionManager.getInstance().loadAvailableFonts(_local5);
		} else {
			_libraryLoadingError = true;
			onLibraryFontsLoadError("Couldn't load fonts library XML.");
		}
	}
	function onLibraryFontsLoad() {
		var _local2 = {target:this, type:"onLibraryFontsLoad"};
		dispatchEvent(_local2);
		destroy();
	}
	function onLibraryFontsLoadError(error) {
		var _local2 = {target:this, type:"onLibraryFontsLoadError", error:error};
		dispatchEvent(_local2);
		destroy();
	}
	function setFont(targetTextField, name, embed) {
		var _local2 = tm.freshComponents.fontsManager.FontsCollectionManager.getInstance().getFontFormat(name);
		if ((name && (name.length > 0)) && (_local2)) {
			var _local1 = targetTextField.getTextFormat();
			for (var _local3 in _local1) {
				if (((_local3 != "bold") && (_local3 != "italic")) && (_local3 != "font")) {
					_local2[_local3] = _local1[_local3];
				}
			}
			if (embed) {
				targetTextField.embedFonts = true;
			} else {
				targetTextField.embedFonts = false;
			}
			_local2.bold = _local1.bold;
			_local2.italic = _local1.italic;
			targetTextField.setTextFormat(_local2);
		}
	}
	function destroy() {
		var _local2 = fontsHolder;
		_local2.unloadMovie();
		_local2.removeMovieClip();
	}
	function isFontRegistered(fontName) {
		return(tm.freshComponents.fontsManager.FontsCollectionManager.getInstance().isFontRegistered(fontName));
	}
	function get libraryLoadingError() {
		return(_libraryLoadingError);
	}
	function dispatchEvent() {
	}
	function addEventListener() {
	}
	function removeEventListener() {
	}
	var fontsLibraryPath = "fonts/fontsLibrary.xml";
	var fontsPath = "fonts";
	var killCache = false;
	var _libraryLoadingError = false;
}
