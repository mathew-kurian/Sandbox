/*
VERSION: 2.93
DATE: 3/31/2008
DESCRIPTION:
	Provides an easy way to invisibly preload SWFs, FLVs, or images and optionally trigger a callback function
	when preloading has finished. It also provides _width and _height information for all successfully preloaded
	SWFs or images, and duration information for FLVs (assuming they were encoded with software like Sorenson
	Squeeze and have MetaData). By default, it will initially only load enough of each asset to determine the
	size (bytes) of each download so that it can accurately report the percentLoaded_num, getBytesLoaded() and
	getBytesTotal(), then it loops back through	from the beginning and finishes all the preloading. If you're 
	not going to use a preloader status bar that polls these methods/properties, you can just set the 
	trackProgress_boolean property to false to skip that initial delay. 

ARGUMENTS:
	1) assetUrls_array: An array of urls to load (like ["myImage1.jpg","myImage2.jpg"])
	2) onComplete_func: [optional] A reference to a function to call when the preloading is complete.
	3) onCompleteArguments_func: [optional] An array of argument values to pass to the onComplete_func.
								 Note: A reference to this PreloadAssetManager will be appended to the 
								 arguments just in case you need it in the function.
	4) trackProgress_boolean: [optional] If you set this to false (it's true by default), things will 
							  load faster (an initial delay will be avoided) but you won't be able to 
							  check the progress (percentLoaded_num, getBytesLoaded(), and getBytesTotal() 
							  won't work)

EXAMPLES: 
	To preload 2 SWFs ("myFile1.swf" and "myFile2.swf") and then call a function named onFinish(), do:
	
		import gs.dataTransfer.PreloadAssetManager;
		var preloader_obj = new PreloadAssetManager(["myFile1.swf","myFile2.swf"], onFinish);
		function onFinish(pl_obj:PreloadAssetManager):Void {
			trace("Finished preloading all assets!");
			var a = pl_obj.assets_array;
			for (var i = 0; i < a.length; i++) {
				trace("Asset: "+a[i].url_str+" had a width of: "+a[i]._width+", a height of "+a[i]._height+", or if it's an FLV with MetaData, its duration is: "+a[i].duration);
			}
		}
	
	Or if you want to have more granular control, you can create add each one to the PreloadAssetManager
	and then query properties like preloaded_boolean, _width, or _height individually like:
	
		import gs.dataTransfer.PreloadAssetManager;
		import gs.dataTransfer.PreloadAsset;
		var preloader_obj = new PreloadAssetManager();
		var pl1_obj = preloader_obj.addAsset("myFile1.swf", onPreload);
		var pl2_obj = preloader_obj.addAsset("myFile2.swf", onPreload);
		preloader_obj.start();
		function onPreload(pl_obj:PreloadAsset):Void {
			trace("finished preloading the asset from: "+pl_obj.url_str+" and its _width is: "+pl_obj._width+" and its _height is: "+pl_obj._height);
		}
	
	You can query the percentLoaded_num property to find out the status at any time (very useful for building
	preloader progress bars) like so:
		
		import gs.dataTransfer.PreloadAssetManager;
		var preloader_obj = new PreloadAssetManager(["myFile1.swf","myFile2.swf"]);
		this.onEnterFrame = function() {
			myPreloader_mc.bar_mc._xscale = preloader_obj.percentLoaded_num;
			if (preloader_obj.percentLoaded_num == 100) {
				gotoAndPlay("start");
			}
		}
	
	Or you can query a specific asset's properties like this:
	
		import gs.dataTransfer.PreloadAssetManager;
		var preloader_obj = new PreloadAssetManager(["myFile1.swf","myFile2.swf"], onFinish);
		function onFinish(pl_obj:PreloadAssetManager):Void {
			trace("Finished preloading all assets! myFile1.swf has a width of: "+pl_obj.getAsset("myFile1.swf")._width);
		}
		
	You can check the properties of a specific asset at any given time using the static getAsset(url_str) function. Just
	remember that the _width, _height, and duration properties will all be undefined until the asset has finished preloading.
		
		var asset_obj = PreloadAssetManager.getAsset("myFile1.swf")
		trace("Preloaded?: "+asset_obj.preloaded_boolean);
		trace("Width: "+asset_obj._width);
		trace("Height: "+asset_obj._height);
		trace("FLV duration: "+asset_obj.duration);
		
	You can pause ALL preloading by calling:
		
		PreloadAssetManager.pauseAll();
		
	And resume by calling:
	
		PreloadAssetManager.resumeAll();

NOTES: 
	- After instantiating a PreloadAssetManager, if you want to prioritize a particular asset (for example, if a user clicked
	  on something that requires a particular asset which might not be loaded yet), you can do any of the following:
			1) Call the static PreloadAssetManager.prioritize(assetUrl_str), passing the url of the asset to get prioritized.
			2) Call the prioritizeAsset(asset_obj) method of the PreloadAssetManager, passing the PreloadAsset instance
			3) Call the prioritize() method on the PreloadAsset instance that needs to get prioritized
	- Feel free to create as many instances as you like - they'll intelligently cooperate and funnel into one
	  queue. This maximizes efficiency by preventing two or more PreloadAssetManagers from simultaneously loading
	  assets, thus cutting each one's bandwidth in half, slowing the load. The goal is to quickly get assets cached.
	- When you pause() or play() or resume() on any instance, it effects ALL instances, so you don't have to worry 
	  about keeping track of all of the PreloadAssetManagers you created in your app, looping through and calling 
	  pause() on each. You can also just call the static PreloadAssetManager.pauseAll() or 
	  PreloadAssetManager.resumeAll() functions.
	- If the trackProgress_boolean wasn't set to false, you can check the percentLoaded_num property or call the 
	  getBytesTotal() or getBytesLoaded() methods to help control preloader status bars.
		
CODED BY: Jack Doyle, jack@greensock.com
*/

import gs.dataTransfer.PreloadAsset;
import mx.utils.Delegate;

class gs.dataTransfer.PreloadAssetManager {
	var onComplete_func:Function;
	var onCompleteArguments_array:Array;
	var assets_array:Array;
	var trackProgress_boolean:Boolean; //If you set this to false (it's true by default), things will load faster (an initial delay will be avoided) but you won't be able to get the percentLoaded_num
	private var _preloaded_boolean:Boolean;
	private var _error_array:Array;
	private var _curAsset_num:Number;
	private static var _mc:MovieClip;
	private static var _interval_num:Number;
	private static var _nc:NetConnection;
	private static var _ns:NetStream;
	private static var _audio_sound:Sound;
	private static var _timeoutLoop_num:Number; //Sometimes NetStreams were completely loading BEFORE the onMetaData() fired, so we use this in a routine that acts as a timeout after 4 seconds of waiting for MetaData. Sometimes FLVs just don't have MetaData (if they weren't encoded with a program like Sorenson Squeeze)
	private static var _managers_array:Array; 
	private static var _paused_boolean:Boolean;
	private static var _preloadedAll_boolean:Boolean;
	
	function PreloadAssetManager(assetUrls_array:Array, onComplete_func:Function, onCompleteArguments_array:Array, trackProgress_boolean:Boolean) {
		if (trackProgress_boolean == undefined) {trackProgress_boolean = true;}
		assets_array = [];
		_curAsset_num = 0;
		_error_array = [];
		this.trackProgress_boolean = trackProgress_boolean;
		addManager(this);
		addAssets(assetUrls_array, onComplete_func, onCompleteArguments_array, true);
	}
	
	function addAsset(url_str:String, onComplete_func:Function, onCompleteArguments_array:Array):PreloadAsset {
		if (url_str != undefined && url_str != null && url_str != "") {
			var a = new PreloadAsset(url_str, onComplete_func, onCompleteArguments_array, this);
			assets_array.push(a);
			return a;
		} else {
			trace("CAUTION: Tried to add a PreloadAsset with a blank URL address.");
		}
	}
	
	function addAssets(assetUrls_array:Array, onComplete_func:Function, onCompleteArguments_array:Array, start_boolean:Boolean):Array {
		if (onComplete_func != undefined && onComplete_func != null) {
			this.onComplete_func = onComplete_func;
			if (onCompleteArguments_array != undefined && onCompleteArguments_array != null) {
				this.onCompleteArguments_array = onCompleteArguments_array;
			}
		}
		var a = [];
		for (var i = 0; i < assetUrls_array.length; i++) {
			a.push(addAsset(assetUrls_array[i]));
		}
		if (start_boolean && assets_array.length != 0) {
			start();
		}
		return a;
	}

	function preloadAssetNumber(asset_num:Number):Void {
		if (!_paused_boolean && !_preloaded_boolean) { 
			clearInterval(_interval_num);
			_timeoutLoop_num = 0;
			_curAsset_num = asset_num;
			var a = assets_array[asset_num];
			if (a.fileType_str == "flv") {
				initNetStream(a.url_str);
				_interval_num = setInterval(this, "checkFlvStatus", 60);
			} else {
				resetMC(); //Otherwise, the _mc still reflects the last asset that was preloading (for tracking progress). This caused a brief blip where the getAssetBytesLoaded() misreported info because the _mc was still loaded with the last asset that was preloading (it takes at least a few milliseconds after calling a loadMovie() to actually have it start populating with the new Movie/Image)
				_mc.loadMovie(a.url_str);
				var snd = new Sound(_mc);
				snd.setVolume(0);
				_interval_num = setInterval(this, "checkStatus", 60);
			}
		}
	}	
	
	function preloadNextAsset():Void {
		if (trackProgress_boolean && !bytesTotalReady_boolean) { //We always need to prioritize determining the bytesTotal for all assets so that we can accurately report to any preloader progress bars.
			for (var i = 0; i < assets_array.length; i++) {
				if (assets_array[i].bytesTotal == 0 && !getErrorStatus(assets_array[i])) {
					preloadAssetNumber(i);
					return;
				}
			}
		} else {
			for (var i = 0; i < assets_array.length; i++) {
				if (!assets_array[i].preloaded_boolean && !getErrorStatus(assets_array[i])) {
					preloadAssetNumber(i);
					return;
				}
			}
			_preloaded_boolean = true;
			_curAsset_num = undefined;
			if (onComplete_func != undefined) {
				if (onCompleteArguments_array.length == undefined || onCompleteArguments_array.length == 0) { //Just make sure we add an argument to the end that references this just in case we need it!
					onCompleteArguments_array = [this];
				} else {
					onCompleteArguments_array.push(this);
				}
				onComplete_func.apply(null, onCompleteArguments_array);
			}
			startNextManager();
		}
	}
	
	function checkStatus():Void {
		var a = assets_array[_curAsset_num];
		_timeoutLoop_num++;
		if (trackProgress_boolean && a.bytesTotal == 0 && _timeoutLoop_num <= 100) {
			if (_mc.getBytesTotal() > 5) {
				a.bytesTotal = _mc.getBytesTotal();
				clearInterval(_interval_num);
				preloadNextAsset();
			}
		} else if (_mc.getBytesLoaded() / _mc.getBytesTotal() == 1 && _mc._currentframe > 0) { //We check the _currentframe in order to determine if the MovieClip has had a chance to initialize yet. If it hasn't, we can't read the _width, _height, etc.
			//trace("preloaded " + a.url_str);
			a._width = a.width = _mc._width;
			a._height = a.height = _mc._height;
			a.preloaded_boolean = true;
			clearInterval(_interval_num);
			preloadNextAsset();
		} else if (_mc._currentframe > 1) {
			_mc.stop(); //Just in case it's an SWF that starts playing audio or something. We couldn't just call this on every frame because it was causing problems when loading JPEGs (it would prevent their _width or _height from being read.
			_mc._visible = false; //Frees up resources because Flash doesn't have to render it (even off-stage)
			var snd = new Sound(_mc);
			snd.setVolume(0);
		} else if (_timeoutLoop_num > 100 && _mc.getBytesLoaded() < 5) { //Essentially a timeout feature.
			clearInterval(_interval_num);
			_error_array.push(a);
			preloadNextAsset();
		}
	}
	
	function start():Void {
		var pp = _paused_boolean;
		_paused_boolean = false;
		if (!_preloadedAll_boolean && pp) {
			startNextManager();
		}
	}
	
	function pause():Void {
		_paused_boolean = true;
		clearInterval(_interval_num);
		flushNetStream();
		_mc.unloadMovie();
	}
	
	function resume():Void {
		start();
	}
	
	function prioritizeAsset(a:PreloadAsset):Void {
		var curAsset_obj = assets_array[_curAsset_num];
		if (!preloaded_boolean && !a.preloaded_boolean && a != curAsset_obj) { //No need to prioritize something that's already preloaded!
			for (var i = assets_array.length - 1; i > 0; i--) {
				if (assets_array[i] == a) {
					assets_array.splice(i, 1);
					assets_array.unshift(a);
					for (var m = _managers_array.length - 1; m > 0; m--) { //Make sure this is the PreloadAssetManager that's currently active (prioritized in the manager's queue)
						if (!_managers_array[m] == this) {
							_managers_array.splice(m, 1);
							_managers_array.unshift(this);
						}
					}
					if (!_paused_boolean) {
						pause();
						start();
					}
					return;
				}
			}
		}
	}
	
	function getErrorStatus(a:PreloadAsset):Boolean {
		var e = _error_array;
		for (var i = 0; i < e.length; i++) {
			if (e[i] == a) {
				return true;
			}
		}
		return false;
	}
	
	function getAssetBytesLoaded(a:PreloadAsset):Number { //We call this function from the PreloadAsset class in order to accurately report an asset's bytesLoaded (in case it's currently loading).
		if (a.preloaded_boolean) {
			return a.bytesTotal;
		} else if (a == assets_array[_curAsset_num]) {
			if (a.fileType_str == "flv" && _ns.bytesLoaded > 2) {
				return _ns.bytesLoaded;
			} else if (_mc.getBytesLoaded() > 2) {
				return _mc.getBytesLoaded();
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}
	
	function destroy():Void {
		_mc.removeMovieClip();
		flushNetStream();
		delete _nc;
		for (var i = _managers_array.length - 1; i >= 0; i--) {
			if (_managers_array[i] == this) {
				_managers_array.splice(i, 1);
			}
		}
		startNextManager(); //Just in case the manager that's currently loading gets destroyed mid-stream, this makes sure it doesn't stop everything. Just continue to the next one.
		destroyInstance(this);
	}
	
	private static function destroyInstance(i:PreloadAssetManager):Void {
		delete i;
	}
	
//---- STATIC FUNCTIONS --------------------------------------------------------
	
	static function pauseAll():Void {
		if (_managers_array.length > 0) {
			_managers_array[0].pause();
		}
	}
	
	static function resumeAll():Void {
		if (_managers_array.length > 0) {
			_managers_array[0].resume();
		}
	}
	
	private static function addManager(m:PreloadAssetManager):Void {
		if (_managers_array == undefined) {
			_managers_array = [];
			resetMC();
			_paused_boolean = true;
			_timeoutLoop_num = 0;
		}
		_managers_array.push(m);
		_preloadedAll_boolean = false;
	}
	
	private static function resetMC():Void {
		_mc.removeMovieClip();
		var l = _root.getNextHighestDepth();
		if (l == undefined) {
			l = 998;
		}
		_mc = _root.createEmptyMovieClip("preloadAssetManager"+l+"_mc", l);
		_mc._x = 3000; //Just make sure it's off the stage.
	}
	
	private static function startNextManager():Void {
		if (!_preloadedAll_boolean && !_paused_boolean) {
			for (var i = 0; i < _managers_array.length; i++) {
				if (!_managers_array[i].preloaded_boolean) {
					_managers_array[i].preloadNextAsset();
					return;
				}
			}
			_preloadedAll_boolean = true;
			_paused_boolean = true;
			_mc.unloadMovie(); //Just to free up resources/memory.
			flushNetStream();
		}
	}
	
	static function flushNetStream():Boolean {
		_ns.stop(); //Solves some compatibility issues with Flash 7
		if (_ns.bytesTotal > 5) { //If we try to close a NetStream object that couldn't find the FLV it was looking for last (and thus wasn't actually streaming anything), it crashes Flash!
			_ns.close();
			return true;
		} else {
			_ns.play(null);
			return false;
		}
	}
	
	//Allows us to get properties like preloaded_boolean, _width, _height, and duration for any asset at any time. Just pass in the URL and it'll return an object with those properties.
	static function getAsset(url_str:String):PreloadAsset {
		for (var m = 0; m < _managers_array.length; m++) {
			var a = _managers_array[m].assets_array;
			for (var i = 0; i < a.length; i++) {
				if (a[i].url_str == url_str) {
					return a[i];
				}
			}
		}
	}
	
	//Allows us to get properties like preloaded_boolean, _width, _height, and duration for any asset at any time. Just pass in the URL and it'll return an object with those properties.
	static function prioritize(url_str:String):PreloadAsset {
		var a = getAsset(url_str);
		if (!a.preloaded_boolean) {
			a.manager_obj.prioritizeAsset(a);
		}
		return a;
	}
	
	
//---- FLV FUNCTIONS -----------------------------------------------------------
	
	private function initNetStream(url_str:String):Void {
		if (_nc == undefined) {
			_nc = new NetConnection();
			_nc.connect(null);
		}
		_ns = new NetStream(_nc);
		_ns.onMetaData = Delegate.create(this, onFlvMetaData);
		_ns.onStatus = Delegate.create(this, onFlvStatus);
		_mc.attachAudio(_ns);
		_audio_sound = new Sound(_mc);
		_audio_sound.setVolume(0);
		_ns.play(url_str);
		_ns.pause(true);
	}
	
	function checkFlvStatus():Void {
		var a = assets_array[_curAsset_num];
		if (trackProgress_boolean && a.bytesTotal == 0) {
			if (_ns.bytesTotal > 5) {
				a.bytesTotal = _ns.bytesTotal;
				clearInterval(_interval_num);
				flushNetStream();
				preloadNextAsset();
			}
		} else if (_ns.bytesLoaded == _ns.bytesTotal && _ns.bytesTotal > 5) {
			_timeoutLoop_num++;
			if (a.duration != undefined || _timeoutLoop_num > 60) { //We ran into a situation where Flash was completely loading the first NetStream BEFORE the onMetaData() got fired (it eventually fired after the FLV loaded). We had to hack a timeout routine here. Sometimes FLVs won't have MetaData depending on what program encoded them.
				//trace("preloaded FLV: " + a.url_str);
				_timeoutLoop_num = 0;
				clearInterval(_interval_num);
				flushNetStream();
				a.preloaded_boolean = true;
				preloadNextAsset();
			}
		}
	}
	
	function onFlvMetaData(meta_obj:Object):Void {
		var a = assets_array[_curAsset_num];
		a.duration = meta_obj.duration;
		a.width = a._width = meta_obj.width;
		a.height = a._height = meta_obj.height;
		a.framerate = meta_obj.framerate;
		a.audiocodecid = meta_obj.audiocodecid;
		a.videocodecid = meta_obj.videocodecid;
		a.canSeekToEnd = meta_obj.canSeekToEnd;
		a.videodatarate = meta_obj.videodatarate;
		a.creationdate = meta_obj.creationdate;
		if (meta_obj.audiodatarate == undefined && meta_obj.videodatarate != undefined) {
			assets_array[_curAsset_num].hasAudio_boolean = false;
		} else if (meta_obj.audiodatarate != undefined) {
			assets_array[_curAsset_num].hasAudio_boolean = true;
		}
	}
	
	function onFlvStatus(info_obj:Object):Void {
		if (info_obj.code == "NetStream.Play.StreamNotFound") {
			var a = assets_array[_curAsset_num];
			trace("ERROR: Could not preload the FLV file: "+assets_array[_curAsset_num].url_str);
			_error_array.push(assets_array[_curAsset_num]);
			clearInterval(_interval_num);
			flushNetStream();
			preloadNextAsset();
		}
	}
	
	//---- GETTERS/SETTERS ------------------------------------------------------------------
	
	function get paused_boolean():Boolean {
		return _paused_boolean;
	}
	
	function set paused_boolean(b:Boolean):Void {
		if (b) {
			pause();
		} else {
			start();
		}
	}
	
	function get preloaded_boolean():Boolean {
		return _preloaded_boolean
	}
	
	function get bytesTotalReady_boolean():Boolean {
		for (var i = 0; i < assets_array.length; i++) {
			if (assets_array[i].bytesTotal == 0 && !getErrorStatus(assets_array[i])) {
				return false;
			}
		}
		return true;
	}
	
	function get percentLoaded_num():Number {
		if (_preloaded_boolean) {
			return 100;
		} else if (!bytesTotalReady_boolean || !trackProgress_boolean) {
			return 0;
		} else {
			var total_num = 0;
			var loaded_num = 0;
			var l = assets_array.length;
			for (var i = 0; i < l; i++) {
				total_num += assets_array[i].bytesTotal;
				loaded_num += getAssetBytesLoaded(assets_array[i]);
			}
			if (total_num == 0 || loaded_num == 0) {
				return 0;
			} else {
				return (loaded_num / total_num) * 100;
			}
		}
	}
	
	function getBytesLoaded():Number {
		if (!bytesTotalReady_boolean || !trackProgress_boolean) {
			return 0;
		} else {
			var loaded_num = 0;
			for (var i = 0; i < assets_array.length; i++) {
				loaded_num += getAssetBytesLoaded(assets_array[i]);
			}
			return loaded_num;
		}
	}
	
	function getBytesTotal():Number {
		if (!bytesTotalReady_boolean || !trackProgress_boolean) {
			return 0;
		} else {
			var total_num = 0;
			for (var i = 0; i < assets_array.length; i++) {
				total_num += assets_array[i].bytesTotal;
			}
			return total_num;
		}
	}
	
}