class Playlist
{
	//Array holding VideoData objects
	public var videos:Array;
	
	//Title of the playlist
	public var title:String;
	
	//YouTube id of the playlist
	public var youtubeId:String;
	
	//Type of the playlist
	public var type:String;
	
	//Flag indicating if the playlist already has been loaded
	public var loaded:Boolean = false;
	
	public static var TYPE_EXPORTED:String = "exported";
	public static var TYPE_CUSTOM:String = "custom";
	
	public function Playlist() 
	{
		//
	}
}