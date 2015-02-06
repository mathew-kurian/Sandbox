import ascb.util.Proxy;
import mx.core.UIComponent;
import mx.events.EventDispatcher;

class VideoControls extends UIComponent
{
	//Scrubbar
	private var scrubBar:ScrubBar;
	
	//Play/pause toggle button
	private var playPauseButton:MovieClip;
	
	//Share button
	private var shareButton:MovieClip;
	
	//Fullscreen toggle button
	private var fullScreenButton:MovieClip;
	
	//Flag indicating if video is playing or not
	private var _isPlaying:Boolean = false;
	
	//Current time of the video
	private var _currentTime:Number;
	
	//Duration of teh video
	private var _videoDuration:Number;
	
	//Time textfield
	private var timeTxt:TextField;
	
	//Volume of the video
	private var volume:Number = 100;
	
	//Flag indicating if sound is muted or not
	private var _isMuted:Boolean = false;
	
	//Background clip
	private var background:MovieClip;
	
	private var _availableQuality:String;
	
	private var hdButton:MovieClip;
	
	private var hqButton:MovieClip;
	
	private var disabledQualityButton:MovieClip;
	
	private var audioControls:MovieClip;
	
	private var highestQualitySelected:Boolean = false;
	
	public function VideoControls() 
	{
		doLater(this, "initialize");
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Initialize controls
	 */
	private function initialize(Void):Void
	{
		//Add scrubBar listeners
		scrubBar.addEventListener(ScrubBarEvent.SCRUBBER_MOVED, Proxy.create(this, scrubberMoved));
		scrubBar.addEventListener(ScrubBarEvent.SCRUBBER_PRESSED, Proxy.create(this, scrubberPressed));
		scrubBar.addEventListener(ScrubBarEvent.SCRUBBER_RELEASED, Proxy.create(this, scrubberReleased));
		scrubBar.currentTime = 0;

		//Add volumeSlider listener
		audioControls.volumeSlider.addEventListener(VolumeSliderEvent.VOLUME_CHANGED, Proxy.create(this, volumeSliderChanged));
		audioControls.volumeSlider.value = 100;
		
		//Set muteButton eventhandler
		audioControls.muteButton.onRelease = Proxy.create(this, muteButtonClicked);
		
		//Set playPauseButton eventhandler
		playPauseButton.onRelease = Proxy.create(this, playPauseButtonClicked);
		
		//Set shareButton eventhandler
		shareButton.onRelease = Proxy.create(this, shareButtonClickHandler);
		
		//Set fullScreenButton eventhandler
		fullScreenButton.onRelease = Proxy.create(this, fullScreenButtonClickHandler);
		
		//Set onEnterFrame eventhandler
		onEnterFrame = Proxy.create(this, updateTime);
		
		hdButton.onRelease = Proxy.create(this, hdButtonClicked);
		hdButton._visible = false;
		
		hqButton.onRelease = Proxy.create(this, hqButtonClicked);
		hqButton._visible = false;
		
		var keyListener:Object = new Object();
		keyListener.onKeyDown = Proxy.create(this, keyPressed);
		Key.addListener(keyListener);
	}
	
	private function keyPressed(Void):Void 
	{
		if (Key.getCode() == 32) 
		{
			isPlaying = !isPlaying;
			
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.PLAYSTATE_CHANGED, null, null, isPlaying));
		}
	}
	
	private function hqButtonClicked(Void):Void 
	{
		if (!highestQualitySelected) {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VIDEO_QUALITY_CHANGED, null, null, null, VideoQuality.LARGE));
			hqButton.selected = true;
			highestQualitySelected = true;
		}else {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VIDEO_QUALITY_CHANGED, null, null, null, VideoQuality.MEDIUM));
			hqButton.selected = false;
			highestQualitySelected = false;
		}
	}
	
	private function hdButtonClicked():Void 
	{
		if (!highestQualitySelected) {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VIDEO_QUALITY_CHANGED, null, null, null, VideoQuality.HD));
			hdButton.selected = true;
			highestQualitySelected = true;
		}else {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VIDEO_QUALITY_CHANGED, null, null, null, VideoQuality.MEDIUM));
			hdButton.selected = false;
			highestQualitySelected = false;
		}
	}
	
	/**
	 * onResize eventhandler
	 */
	public function onResize(Void):Void
	{
		var newWidth:Number;
	
		//Set new width depending on display state
		if(Stage["displayState"] == "fullScreen"){
			newWidth = Math.round(Stage.width);
			this._y = Stage.height - this._height;
		}else{
			newWidth = VideoGallery.GALLERY_WIDTH - 380;
			this._y = VideoGallery.GALLERY_HEIGHT - this._height;
		}
		
		setWidth(newWidth);
	}
	
	/**
	 * Set width and position elements
	 */
	public function setWidth(width:Number):Void
	{
		background._width = width;
		hdButton._x = hqButton._x = disabledQualityButton._x = background._width - 31;
		fullScreenButton._x = hdButton._x - 31;
		shareButton._x = fullScreenButton._x - 31;
		
		audioControls._x = shareButton._x - 81;
		timeTxt._x = audioControls._x - 83;
		timeTxt._visible = timeTxt._x > 43;
		
		var scrubBarWidth:Number = timeTxt._visible ? timeTxt._x - scrubBar._x - 10 : audioControls._x - scrubBar._x - 10;
		trace("scrubBarWidth: " + scrubBarWidth);
		scrubBar._visible = scrubBarWidth > 10;
		scrubBar.setWidth(Math.max(0, scrubBarWidth));
	}
	
	/**
	 * fullScreenButton onRelease eventhandler
	 */
	private function fullScreenButtonClickHandler():Void 
	{
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.FULLSCREEN_BUTTON_CLICKED));
	}
	/**
	 * shareButton onRelease eventhandler
	 */
	
	private function shareButtonClickHandler(Void):Void 
	{
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.SHARE_BUTTON_CLICKED));
	}
	
	/**
	 * muteButton onRelease eventhandler
	 */
	private function muteButtonClicked(Void):Void 
	{
		isMuted = !isMuted;
	}
	
	/**
	 * Getter for isMuted variable
	 */
	public function set isMuted(value:Boolean):Void
	{
		_isMuted = value;
	
		//Check if sound is muted/unmuted, dispatch VOLUME_CHANGED event and set the mute button and the volume slider
		if (_isMuted) {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VOLUME_CHANGED, null, 0));
			audioControls.volumeSlider.value = 0;
			audioControls.muteButton.icon.gotoAndStop(2);
		}else if (!_isMuted) {
			dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VOLUME_CHANGED, null, volume));
			audioControls.volumeSlider.value = volume;
			audioControls.muteButton.icon.gotoAndStop(1);
		}
	}
	
	/**
	 * Update displayed time
	 */
	private function updateTime(Void):Void 
	{
		var time:Number = _parent.player.getCurrentTime();
		var duration:Number = _parent.player.getDuration();
		
		//Updated currentTime if video is playing
		if (isPlaying) {
			currentTime = time;
		}
	}
	
	/**
	 * playPauseButton onRelease eventhandler
	 */
	private function playPauseButtonClicked(Void):Void 
	{
		isPlaying = !isPlaying;
		
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.PLAYSTATE_CHANGED, null, null, isPlaying));
	}
	
	/**
	 * scrubBar SCRUBBER_RELEASED eventhandler
	 */
	private function scrubberReleased(eventObject:Object):Void 
	{
		//Dispatch SCRUB_COMPLETED event
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.SCRUB_COMPLETED, eventObject.time));
	}
	
	/**
	 * scrubBar SCRUBBER_PRESSED eventhandler
	 */
	private function scrubberPressed(eventObject:Object):Void 
	{
		//Dispatch SCRUB_STARTED event
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.SCRUB_STARTED));
	}
	
	/**
	 * scrubBar SCRUBBER_MOVED eventhandler
	 */
	private function scrubberMoved(eventObject:ScrubBarEvent):Void 
	{
		//Dispatch TIME_CHANGED event
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.TIME_CHANGED, eventObject.time));
	}
	
	/**
	 * volumeSlider VOLUME_CHANGED eventhandler
	 */
	private function volumeSliderChanged(eventObject:VolumeSliderEvent):Void 
	{
		//Set current volume
		volume = eventObject.volume;
		
		//Set _isMuted flasg to false
		_isMuted = false;
		
		//Set muteButton
		audioControls.muteButton.icon.gotoAndStop(1);
		
		//Dispatch VOLUME_CHANGED event
		dispatchEvent(new VideoControlsEvent(VideoControlsEvent.VOLUME_CHANGED, null, eventObject.volume));
	}
	
	/**
	 * Getter for videoDuration
	 */
	public function get videoDuration():Number { return _videoDuration; }
	
	/**
	 * Setter for videoDuration
	 */
	public function set videoDuration(value:Number):Void 
	{
		_videoDuration = value;
		
		scrubBar.duration = value;
	}
	
	/**
	 * Getter for isPlaying
	 */
	public function get isPlaying():Boolean { return _isPlaying; }
	
	/**
	 * setter for isPlaying
	 */
	public function set isPlaying(value:Boolean):Void 
	{
		_isPlaying = value;
		
		//Set playPauseButton
		if(value)playPauseButton.icon.gotoAndStop(2);
		else playPauseButton.icon.gotoAndStop(1);
	}
	
	/**
	 * Getter for currentTime
	 */
	public function get currentTime():Number { return _currentTime; }
	
	/**
	 * Setter for currentTime
	 */
	public function set currentTime(value:Number):Void 
	{
		_currentTime = value;
		
		scrubBar.currentTime = value
		
		timeTxt.text = getFormattedTime(currentTime) + "/" + getFormattedTime(videoDuration);
	}
	
	/**
	 * Getter for isMuted variable
	 */
	public function get isMuted():Boolean { return _isMuted; }
	
	/**
	 * Returns a formatted time string
	 */
	private function getFormattedTime(time:Number):String
	{
		time = Math.floor(time);
		
		var minutes:Number = Math.max(0, Math.floor(time / 60));
		if (isNaN(minutes)) minutes = 0;
		var minutesString:String = "";
		if (minutes < 10) minutesString += "0";
		minutesString += String(minutes);
		
		var seconds:Number = Math.max(0, time % 60);
		if (isNaN(seconds)) seconds = 0;
		var secondsString:String = "";
		if (seconds < 10) secondsString += "0";
		secondsString += String(seconds);
		
		return minutesString + ":" + secondsString;
	}
	
	/**
	 * Set colors
	 */
	public function setColors(Void):Void
	{
		scrubBar.setColors();
		audioControls.volumeSlider.setColors();
	}
	
	/**
	 * Enabled/Disabled scrubber
	 */
	public function set scrubEnabled(value:Boolean):Void
	{
		scrubBar.enabled = value;
	}
	
	public function set availableQuality(value:String):Void 
	{
		_availableQuality = value;
		
		hdButton._visible = value == VideoQuality.HD;
		hqButton._visible = value == VideoQuality.LARGE;
	}
	
	public function get availableQuality():String { return _availableQuality; }
	
	public function resetQuality(Void):Void
	{
		hdButton.selected = false;
		hqButton.selected = false;
		
		highestQualitySelected = false;
		highestQualitySelected = false;
	}
}