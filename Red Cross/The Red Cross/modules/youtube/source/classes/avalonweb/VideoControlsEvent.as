class VideoControlsEvent
{
	//Type of the event
	public var type:String;
	
	//Time
	public var time:Number;
	
	//Volume
	public var volume:Number;
	
	//Flag indicating if video is playing or not
	public var isPlaying:Boolean;
	
	public var quality:String;
	
	//Event types
	public static var TIME_CHANGED:String = "timeChanged";
	public static var VOLUME_CHANGED:String = "currentTimeChanged";
	public static var SCRUB_STARTED:String = "scrubStarted";
	public static var SCRUB_COMPLETED:String = "scrubCompleted";
	public static var PLAYSTATE_CHANGED:String = "playStateChanged";
	public static var FULLSCREEN_BUTTON_CLICKED:String = "fullscreenButtonClicked";
	public static var SHARE_BUTTON_CLICKED:String = "shareButtonClicked";
	public static var VIDEO_QUALITY_CHANGED:String = "videoQualityChanged";
	
	public function VideoControlsEvent(type:String, time:Number, volume:Number, isPlaying:Boolean, quality:String) 
	{
		this.type = type;
		this.time = time;
		this.volume = volume;
		this.isPlaying = isPlaying;
		this.quality = quality;
	}
}