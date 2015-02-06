/*
VERSION: 2.8
DATE: 8/13/2007
DESCRIPTION:
	Provides an easy way to invisibly preload an individual SWF, FLV, or image and optionally trigger a callback function
	when preloading has finished. It also provides _width and _height information (for an SWF or image) or duration information 
	(for FLVs, assuming they were encoded with software like Sorenson Squeeze and have MetaData). 

ARGUMENTS:
	1) url_str: The url of the SWF or image to load (like "myFile.swf" or "myImage.jpg")
	2) onComplete_func: [optional] A reference to a function to call when the preloading is complete.
	3) onCompleteArguments_func: [optional] An array of argument values to pass to the onComplete_func.
								 Note: A reference to this PreloadAsset will be passed as the last argument
								 just in case you need it in the function.

EXAMPLE: 
	To preload an SWF at the url "myFile1.swf" and then call a function named onFinish(), do:
	
	import gs.dataTransfer.PreloadAsset;
	var preload_obj = new PreloadAsset("myFile1.swf", onFinish);
	function onFinish(asset_obj:PreloadAsset):Void {
		trace("Finished preloading: "+asset_obj.url_str+" and its width is: "+asset_obj._width+" and its _height is: "+asset_obj._height);
	}
	
NOTES: 
	- To preload multiple SWFs or images, it's probably easier to use the PreloadAssetManager class.
	- To prioritize an asset in the preloading queue, just call the prioritize() method.
	- After an SWF or image is preloaded, the _width and _height properties are set. This is useful on occasions 
	  when we need to center something on the screen or do some other calculations based on the dimensions of the preloaded asset.
	  For FLVs with MetaData (typically ones encoded with Sorenson Squeeze), the duration property is set when it finishes loading.
	  Keep in mind that some FLVs do not have MetaData in which case the duration property will remain undefined.
	- This class requires the gs.dataTransfer.PreloadAssetManager class.

CODED BY: Jack Doyle, jack@greensock.com
*/

import gs.dataTransfer.PreloadAssetManager;

class gs.dataTransfer.PreloadAsset {
	var _width:Number; //After the SWF or image preloads, this property gets set. It's useful on occasions when we need to center something on the screen or do some other calculations based on the dimensions of the preloaded asset.
	var _height:Number; //After the SWF or image preloads, this property gets set. It's useful on occasions when we need to center something on the screen or do some other calculations based on the dimensions of the preloaded asset.
	var duration:Number; //For FLVs
	var width:Number; //For FLVs
	var height:Number; //For FLVs
	var framerate:Number; //For FLVs
	var videodatarate:Number; //For FLVs
	var audiodatarate:Number; //For FLVs
	var videocodecid:Number; //For FLVs
	var audiocodecid:Number; //For FLVs
	var creationdate:Number; //For FLVs
	var canSeekToEnd:Boolean; //For FLVs
	var hasAudio_boolean:Boolean; //For FLVs
	var fileType_str:String; //Basically the suffix of the file url, like "flv", "swf", "jpg", "png", "gif", etc.
	var bytesTotal:Number; 
	var pause:Function; //Just references the _manager_obj.pause() function. We make it available here in case the user instantiates a PreloadAsset directly (not through a PreloadAssetManager).
	var resume:Function; //Just references the _manager_obj.resume() function. We make it available here in case the user instantiates a PreloadAsset directly (not through a PreloadAssetManager).
	var start:Function; //Just references the _manager_obj.start() function. We make it available here in case the user instantiates a PreloadAsset directly (not through a PreloadAssetManager).
	private var _url_str:String;
	private var _onComplete_func:Function;
	private var _onCompleteArguments_array:Array;
	private var _preloaded_boolean:Boolean;
	private var _manager_obj:PreloadAssetManager;
	private var _standalone_boolean:Boolean; //If we're triggered on our own, and not as a part of an existing PreloadAssetManager, we should kill the temporary one we create as soon as we're preloaded.
	
	function PreloadAsset(url_str:String, onComplete_func:Function, onCompleteArguments_array:Array, manager_obj:PreloadAssetManager) {
		_preloaded_boolean = false;
		_onComplete_func = onComplete_func;
		_onCompleteArguments_array = onCompleteArguments_array;
		_url_str = url_str;
		fileType_str = url_str.substr(url_str.length - 3, 3).toLowerCase();
		bytesTotal = 0;
		if (manager_obj == undefined) {
			manager_obj = new PreloadAssetManager();
			manager_obj.assets_array.push(this);
			_standalone_boolean = true;
			manager_obj.start();
		} else {
			_standalone_boolean = false;
		}
		_manager_obj = manager_obj;
		this.pause = _manager_obj.pause;
		this.resume = _manager_obj.resume;
		this.start = _manager_obj.start; 
	}
	
	function prioritize():Void {
		_manager_obj.prioritizeAsset(this);
	}
	
//---- GETTERS / SETTERS --------------------------------------------------------------------------
	
	function set preloaded_boolean(b:Boolean):Void {
		if (!_preloaded_boolean && b) {
			_preloaded_boolean = true;
			if (_onComplete_func != undefined) {
				if (_onCompleteArguments_array.length == undefined || _onCompleteArguments_array.length == 0) { //Just make sure we add an argument to the end that references this just in case we need it!
					_onCompleteArguments_array = [this];
				} else {
					_onCompleteArguments_array.push(this);
				}
				_onComplete_func.apply(null, _onCompleteArguments_array);
			}
			if (_standalone_boolean) {
				_manager_obj.destroy();
				delete _manager_obj; //Clean it up since we don't need it anymore.
			}
		}
		//We purposely don't allow for setting this variable back to false because once it's preloaded, it's preloaded!
	}
	
	function get preloaded_boolean():Boolean {
		return _preloaded_boolean;
	}
	
	function get url_str():String {
		return _url_str;
	}
	
	function get manager_obj():PreloadAssetManager {
		return _manager_obj;
	}
	
	function get bytesLoaded():Number {
		return _manager_obj.getAssetBytesLoaded(this);
	}
	
	function getBytesLoaded():Number {
		return _manager_obj.getAssetBytesLoaded(this);
	}
	
	function getBytesTotal():Number {
		return bytesTotal;
	}
	
}