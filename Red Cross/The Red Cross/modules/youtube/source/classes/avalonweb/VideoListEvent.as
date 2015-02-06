class VideoListEvent
{
	//Type of the event
	public var type:String;
	
	//VideoData object
	public var videoData:VideoData;
	
	//Event types
	public static var VIDEO_SELECTED:String = "videoSelected";
	public static var READY:String = "videoListReady";
	
	public function VideoListEvent(type:String, videoData:VideoData) 
	{
		this.type = type;
		this.videoData = videoData;
	}
}