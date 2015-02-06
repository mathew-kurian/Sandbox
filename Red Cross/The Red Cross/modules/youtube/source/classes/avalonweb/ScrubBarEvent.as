class ScrubBarEvent
{
	//Type of the event
	public var type:String;
	
	//Time
	public var time:Number;
	
	//Event types
	public static var SCRUBBER_PRESSED:String = "scrubberPressed";
	public static var SCRUBBER_RELEASED:String = "scrubberRelease";
	public static var SCRUBBER_MOVED:String = "scrubberMoved";
	
	public function ScrubBarEvent(type:String, time:Number) 
	{
		this.type = type;
		this.time = time;
	}
}