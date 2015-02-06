class VolumeSliderEvent
{ 
	//Type of the event
	public var type:String;
	
	//Volume
	public var volume:Number;
	
	//Event types
	public static var VOLUME_CHANGED:String = "volumeChanged";
	
	public function VolumeSliderEvent(type:String, volume:Number) 
	{
		this.type = type;
		this.volume = volume;
	}
}