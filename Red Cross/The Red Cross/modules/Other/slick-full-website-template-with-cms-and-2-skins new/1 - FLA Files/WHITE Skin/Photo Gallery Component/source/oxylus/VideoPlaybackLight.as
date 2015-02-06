import oxylus.Utils;

class oxylus.VideoPlaybackLight {
	
	// playback control objects
	private var netStr:NetStream;
	private var netCon:NetConnection;
	private var vidOb:Video;
	private var sndOb:Sound;
	private var sndMc:MovieClip;
	
	// events
	public var onInit:Function;
	public var onBuffering:Function;
	public var onBufferFull:Function;
	public var onPlaybackResume:Function;
	public var onPlaybackPause:Function;
	public var onPlaybackTimeUpdate:Function;
	public var onPlaybackComplete:Function;
	public var onPlaybackError:Function;
	public var onLoadProgress:Function;
	
	// vars
	private var $isPlaying:Boolean = false;
	private var $isBuffering:Boolean = false;
	private var $autoPlay:Boolean = false;
	private var $repeat:Boolean = false;
	private var $volume:Number = 75;
	private var $eCheck:Number;
	private var $sizeCheck:Number;
	private var $bufferTime:Number = 3;
	private var $isReady:Boolean = false;
	private var $checkFuncs:Array;
	private var $mute:Boolean = false;
	
	// video width / height
	private var w:Number;
	private var h:Number;
	
	// total / current time
	private var $totalTime:Number;
	private var $currentTime:Number;
	
	// total / loaded bytes
	private var $totalBytes:Number;
	private var $loadedBytes:Number;
	
	// constructor (var v = new VideoPlaybackLight(video_instance_name);)
	public function VideoPlaybackLight(v:Video) {
		netCon = new NetConnection();
		vidOb  = v;
		
		var d:Number = _level0.getNextHighestDepth();
		sndMc = _level0.createEmptyMovieClip("$_videoPlaybackSoundObjectTargetId" + d, d);
		sndOb = new Sound(sndMc);
		
		// initial volume
		this.setVolume();
	}
	private function $init() {
		w 				= 0;
		h 				= 0;
		$totalTime 		= 0;
		$currentTime 	= 0;
		$totalBytes 	= 0;
		$loadedBytes 	= 0;
		$isPlaying 		= false;
		$isReady 		= false;
		$isBuffering	= false;
		
		onPlaybackPause.call(this);
		onPlaybackTimeUpdate.call(this, $totalTime, $currentTime, formatTime($totalTime), formatTime($currentTime));
		onLoadProgress.call(this, $totalBytes, $loadedBytes);
		onBufferFull.call(this);
	}
	
	// reset everything
	public function reset() {
		vidOb._visible = false;
		
		netStr.close();
		delete netStr;
		netStr = undefined;
		
		sndOb.stop();
		
		clearInterval($eCheck);
		clearInterval($sizeCheck);
		
		delete $checkFuncs;
		
		$sizeCheck = undefined;
		
		$init();
	}
	
	// load video
	public function load(url:String) {
		reset();
		
		var host:String = null;
		var file:String = url;
		
		// check if rtmp and get host and file name
		if (url.toLowerCase().indexOf("rtmp://") == 0) {
			var parts:Array = url.split("/");
			file = String(parts.pop());
			host = parts.join("/");
		}
		
		// connect                                      
		netCon.connect(host);
		
		// create & setup net stream object
		netStr = new NetStream(netCon);
		netStr.setBufferTime($bufferTime);
		
		netStr.onMetaData 	= Utils.delegate(this, $onMetaData);
		netStr.onStatus 	= Utils.delegate(this, $onStatus);
		
		// setup video/audio objects
		vidOb.attachVideo(netStr);
		sndMc.attachAudio(netStr);
		this.setVolume();
		
		// this will grab & display the first frame
		netStr.play(file);
		
		// buffer
		$isBuffering = true;
		onBuffering.call(this);
	}
	
	// playback
	public function pause() {
		$isPlaying = false;
		netStr.pause(true);
		onPlaybackPause.call(this);
	}
	public function resume() {
		$isPlaying = true;
		netStr.pause(false);
		onPlaybackResume.call(this);
	}
	public function stop() {
		this.seek(0);
		this.pause();
	}
	public function rewind() {
		this.seek(0);
		this.resume();
	}
	public function seek(to:Number, usePercentage:Boolean) {
		var $to:Number = usePercentage ? (to * $totalTime) : to;
		
		
		netStr.seek($to);
	}
	
	// volume
	public function setVolume(p:Number) {
		p != undefined ? $volume = Math.round(100 * p) : null;
		sndOb.setVolume($mute ? 0 : $volume);
	}
	public function getVolume() {
		return sndOb.getVolume()/100;
	}
	public function mute(b:Boolean) {
		$mute = (b == undefined) ? true : Boolean(b);
		this.setVolume();
	}
	
	// properties
	/// read-only
	public function get width() {
		return w;
	}
	public function get height() {
		return h;
	}
	
	public function isReady():Boolean {
		return $isReady;
	}
	public function isMuted():Boolean {
		return $mute;
	}
	public function get isPlaying() {
		return $isPlaying;
	}
	public function get isBuffering() {
		return $isBuffering;
	}
	
	public function get totalTime() {
		return $totalTime;
	}
	public function get currentTime() {
		return $currentTime;
	}
	
	public function get totalBytes() {
		return $totalBytes;
	}
	public function get loadedBytes() {
		return $loadedBytes;
	}
	
	/// get/set
	public function set autoPlay(b:Boolean) {
		$autoPlay = Boolean(b);
	}
	public function get autoPlay() {
		return $autoPlay;
	}
	
	public function set repeat(b:Boolean) {
		$repeat = Boolean(b);
	}
	public function get repeat() {
		return $repeat;
	}
	
	public function get bufferTime():Number {
		return $bufferTime;
	}
	public function set bufferTime(nbt:Number) {
		$bufferTime = nbt;
	}
	
	// on meta data
	private function $onMetaData(o:Object) {
		delete netStr.onMetaData;
		
		for (var p in o) {
			var val:Number = Number(o[p]);
			isNaN(val) ? val = 0 : null;
			
			switch (p) {
			case "width" :
				w = val;
				break;
			case "height" :
				h = val;
				break;
			case "duration" :
				$totalTime = val;
				break;
			}
		}
		
		(w > 0 && h > 0) ? $initCall() : $checkSize();
		
		$checkFuncs = [$checkLoadProgress, $checkTimeProgress, $checkBufferStatus];
		$eCheck     = setInterval(this, "$checkAll", 33);
	}
	
	// check for video width and height if metadata is missing
	private function $checkSize() {
		if (vidOb.width > 0 && vidOb.height > 0) {
			clearInterval($sizeCheck);
			$sizeCheck = undefined;
			
			w = vidOb.width;
			h = vidOb.height;
			
			$initCall();
		} else if ($sizeCheck == undefined) {
			$sizeCheck = setInterval(this, "$checkSize", 33);
		}
	}
	private function $initCall() {
		// show video
		vidOb._visible = true;
		
		// resume or play
		$autoPlay ? this.rewind() : this.stop();
		
		// call event
		$isReady = true;
		onInit.call(this);
	}
	// on status
	private function $onStatus(o:Object) {
		switch (o.code) {
			
		case "NetStream.Play.Stop" :
			onPlaybackComplete.call(this);
			$repeat ? this.rewind() : this.stop();
			break;
			
		case "NetStream.Play.StreamNotFound" :
			onPlaybackError.call(this);
			break;
			
		case "NetStream.Seek.InvalidTime" :
			seek(Number(o.details));
			break;
		}
	}
	
	// periodically check time, buffering and loading
	private function $checkAll() {
		for (var i in $checkFuncs) {
			$checkFuncs[i].call(this);
		}
	}
	
	// check loading
	private function $checkLoadProgress() {
		var tb:Number = netStr.bytesTotal;
		var lb:Number = netStr.bytesLoaded;
		
		isNaN(tb) ? tb=$totalBytes : null;
		isNaN(lb) ? lb = $loadedBytes : null;
		
		if ($totalBytes != tb || $loadedBytes != lb) {
			
			$totalBytes  = tb;
			$loadedBytes = lb;
			
			onLoadProgress.call(this, $totalBytes, $loadedBytes);
		}
		
		// if fully loaded , remove load and buffering checking       
		if ($totalBytes == $loadedBytes && $totalBytes > 0) {
			$checkFuncs = [$checkTimeProgress];
			$isBuffering ? ($isBuffering=false, onBufferFull.call(this)) : null;
		}
	}
	
	// check buffer status
	private function $checkBufferStatus() {
		if (netStr.bufferLength<netStr.bufferTime) {
			!$isBuffering ? ($isBuffering=true, onBuffering.call(this)) : null;
		} else {
			$isBuffering ? ($isBuffering=false, onBufferFull.call(this)) : null;
		}
	}
	
	// check time 
	private function $checkTimeProgress() {
		var ct:Number = netStr.time;
		isNaN(ct) ? ct = $currentTime : null;
		
		if ($currentTime != ct) {
			$currentTime = ct;
			$currentTime > $totalTime ? $totalTime = $currentTime : null;
			
			onPlaybackTimeUpdate.call(this, $totalTime, $currentTime, formatTime($totalTime), formatTime($currentTime));
		}
	}
	
	// time formatted string like (hh:mm:ss), hours only displayed if needed
	public function formatTime(t:Number) {
		var hours:Number 	= Math.floor(t/3600);
		var minutes:Number 	= Math.floor((t %= 3600)/60);
		var seconds:Number 	= Math.round(t % 60);
		
		var $hours:String 	= String(hours);
		var $minutes:String = String(minutes);
		var $seconds:String = String(seconds);
		
		hours	< 10 ? $hours	= "0" + $hours 	 : null;
		minutes	< 10 ? $minutes	= "0" + $minutes : null;
		seconds < 10 ? $seconds = "0" + $seconds : null;
		
		var $time:String = $minutes + ":" + $seconds;
		
		hours > 0 ? $time = $hours + ":" + $time : null;
		
		return $time;
	}
}
