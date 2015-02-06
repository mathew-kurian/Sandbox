import mx.core.UIComponent;
import mx.utils.Delegate;
import ascb.util.Proxy;

class VideoGallery extends UIComponent
{
	private var debug:TextField;
	
	//Container for the chromeless player
	private var player:MovieClip;
	
	//XML data
	private var xml:XML;
	
	//Array holding Playlist objects
	private var playlists:Array
	
	//VideoList showing the videos
	private var videoList:VideoList;
	
	//Videocontrols
	private var controls:VideoControls;
	
	//Interval ID used for loading the chromeless player
	private var loadCheckInt:Number;
	
	//Share window
	private var shareWindow:ShareWindow;
	
	//Container clip the play is loaded in
	private var playerContainer:MovieClip;
	
	//Stage listener
	private var stageListener:Object = { };
	
	//Highlight color
	public static var HIGHLIGHT_COLOR:Number;
	
	//Gallery width
	public static var GALLERY_WIDTH:Number;
	
	//Gallery height
	public static var GALLERY_HEIGHT:Number;
	
	public static var WIDESCREEN:Boolean;
	
	//Error message textfield
	private var errorMessageTxt:TextField;
	
	private var getQuality:Boolean = true;
	
	
	public function VideoGallery() 
	{
		//Allow scriptaccess from youtube.com
		System.security.allowDomain("http://www.youtube.com/");
		
		//Load policy file
		System.security.loadPolicyFile("http://www.youtube.com/crossdomain.xml");
		
		//Set stage scalemode
		Stage.scaleMode = "noScale";
		
		//Set stage alignment
		Stage.align = "TL";
		
		//Load the chromeless player
		doLater(this, "loadPlayer");
		
		//Hide gallery initially
		_visible = false;
		
		//Add stage listener
		Stage.addListener(stageListener);
	}

	/**
	 * Load the youtube chromeless player
	 */
	private function loadPlayer(Void):Void
	{
		//Create container movieclip
		player = playerContainer.createEmptyMovieClip("player", 1);
		
		//Create listener for loader
		var loaderListener:Object = new Object();
		
		//Set onLoadInit eventhandler
		loaderListener.onLoadInit = Proxy.create(this, playerLoaded);

		//Create loader
		var loader:MovieClipLoader = new MovieClipLoader();
		loader.addListener(loaderListener);

		//Load the chromeless player
		loader.loadClip("http://www.youtube.com/apiplayer", player);
	}
	
	/**
	 * Fired after chromeless player has been loaded into its container
	 */
	private function playerLoaded(Void):Void
	{
		loadCheckInt = setInterval(this, "checkPlayerLoaded", 100);
	}

	/**
	 * Checks if the chromeless player finished loading
	 */
	private function checkPlayerLoaded(Void):Void
	{
		if(player.isPlayerLoaded()){
			//Clear the interval
			clearInterval(loadCheckInt);
			
			//Add set listeners
			player.addEventListener("onStateChange", Delegate.create(this, onPlayerStateChange));
			player.addEventListener("onError", Delegate.create(this, onPlayerError));
			
			//Set the size of the player
			player.setSize(480, 360);
			
			//Load the xml file
			loadXML();
		}
	}
	
	/**
	 * Loads the playlists xml file
	 */
	private function loadXML():Void
	{
		//Create new XML
		xml = new XML();
		
		//Ignore whitespace
		xml.ignoreWhite = true;
		
		//Set onLoad eventhandler
		xml.onLoad = Delegate.create(this, XMLloaded);
		
		//Load the xml file
		xml.load(_root.xmlPath || "videogallery.xml");
	}
	
	
	/**
	 * xml onLoad eventhandler
	 */
	private function XMLloaded(success:Boolean):Void 
	{
		if(success)parseXML();
	}
	
	/**
	 * Parses the xml file
	 */
	private function parseXML():Void
	{
		//Set listeners
		setListeners();
		
		playlists = [];
		
		var playlistNodes:Array = xml.firstChild.childNodes;
		var playlistNode:XML;
		var videoNodes:Array;
		var videoNode:XML;
		var i:Number = 0;
		var l:Number = playlistNodes.length;
		var playlist:Playlist;
	
		for (i = 0; i < l; i++) 
		{
			playlistNode = playlistNodes[i];
			
			playlist = new Playlist();
			
			if (playlistNode.attributes.youtube_id.length > 0) {
				playlist.type = Playlist.TYPE_EXPORTED;
				playlist.youtubeId = playlistNode.attributes.youtube_id;
				playlist.title = playlistNode.attributes.title;
			}else {
				playlist.type = Playlist.TYPE_CUSTOM;
				playlist.title = playlistNode.attributes.title;
				
				videoNodes = playlistNode.childNodes;
				
				var j:Number = 0;
				var m:Number = videoNodes.length;
				var videoData:VideoData;
				var videos:Array = [];
				
				for (j = 0; j < m; j++) {
					videoNode = videoNodes[j];
					videoData = new VideoData();
					videoData.id = videoNode.attributes.youtube_id;
					videoData.title = videoNode.attributes.title;
					videoData.description = videoNode.firstChild.firstChild.nodeValue;
					videoData.thumbnail = "http://img.youtube.com/vi/" + videoData.id + "/2.jpg";
					
					videos.push(videoData);
				}
				
				playlist.videos = videos;
			}
			
			playlists.push(playlist);
		}
		
		videoList.playlists = playlists;
		
		//Get settings from the XML file
		HIGHLIGHT_COLOR = xml.firstChild.attributes.highlight_color || 0x008CDC;
		GALLERY_WIDTH = xml.firstChild.attributes.width;
		GALLERY_HEIGHT = xml.firstChild.attributes.height;
		WIDESCREEN = Boolean(Number(xml.firstChild.attributes.widescreen));
		
		//Set controls colors
		controls.setColors();
		
		//Size controls
		controls.onResize();
		
		//Position objects
		controls._y = GALLERY_HEIGHT - controls._height;
		videoList._x = GALLERY_WIDTH - 370;
		
		//Size videolist
		videoList.onResize();
		
		//Fit player to stage
		fitPlayer(GALLERY_WIDTH - 380, GALLERY_HEIGHT - controls._height);
		
		//Position share window
		
		shareWindow._x = Math.round(player._width / 2 - shareWindow._width / 2);
		shareWindow._y = Math.round(player._height / 2 - 210 / 2);
		
		//Show the gallery
		_visible = true;
	}
	
	/**
	 * Set listeners
	 */
	private function setListeners():Void
	{
		//Set videoList eventlisteners
		videoList.addEventListener(VideoListEvent.VIDEO_SELECTED, Proxy.create(this, videoSelected));
		videoList.addEventListener(VideoListEvent.READY, Proxy.create(this, videoListReady));
	
		//Set controls eventlisteners
		controls.addEventListener(VideoControlsEvent.SCRUB_STARTED, Proxy.create(this, scrubStartedHandler));
		controls.addEventListener(VideoControlsEvent.SCRUB_COMPLETED, Proxy.create(this, scrubCompletedHandler));
		controls.addEventListener(VideoControlsEvent.VOLUME_CHANGED, Proxy.create(this, volumeChangedHandler));
		controls.addEventListener(VideoControlsEvent.PLAYSTATE_CHANGED, Proxy.create(this, playStateChangedHandler));
		controls.addEventListener(VideoControlsEvent.SHARE_BUTTON_CLICKED, Proxy.create(this, shareButtonClicked));
		controls.addEventListener(VideoControlsEvent.FULLSCREEN_BUTTON_CLICKED, Proxy.create(this, fullScreenButtonClicked));
		controls.addEventListener(VideoControlsEvent.VIDEO_QUALITY_CHANGED, Proxy.create(this, videoQualityChanged));
	}
	
	private function videoQualityChanged(eventObject:VideoControlsEvent):Void 
	{
		player.setPlaybackQuality(eventObject.quality);
	}
	
	/**
	 * FULLSCREEN_BUTTON_CLICKED eventhandler
	 */
	private function fullScreenButtonClicked(Void):Void 
	{
		toggleFullScreen();
	}
	
	/**
	 * Toggle display state
	 */
	private function toggleFullScreen(Void):Void 
	{
		if (Stage["displayState"] == "normal") {
			//Set displayState to fullScreen
			Stage["displayState"] = "fullScreen";
			
			//Size controls
			controls.onResize();
			
			//Hide videolist
			videoList.visible = false;
			
			//Fit player to stage 
			cropPlayer(Stage.width, Stage.height - controls._height);
			
			//Set onResize eventhandler
			stageListener.onResize = Proxy.create(this, onResize);
			
			//Position share window
			shareWindow._x = Math.round(Stage.width / 2 - shareWindow._width / 2);
			shareWindow._y = Math.round(Stage.height / 2 - shareWindow._height / 2);
		}else {
			//Set displayState to normal
			Stage["displayState"] = "normal";
			
			//Size controls
			controls.onResize();
			
			//Show videolist
			videoList.visible = true;
			
			//Delete onResize eventhandler
			delete stageListener.onResize;
			
			//Fit player to stage 
			fitPlayer(GALLERY_WIDTH - 380, GALLERY_HEIGHT - controls._height);
			
			//Position share window
			shareWindow._x = Math.round(player._width / 2 - shareWindow._width / 2);
			shareWindow._y = Math.round(player._height / 2 - shareWindow._height / 2);
		}
	}
	
	/**
	 * onResize eventhandler
	 */
	private function onResize(Void):Void 
	{
		var newWidth:Number = GALLERY_WIDTH - 380;
		var newHeight:Number = GALLERY_HEIGHT - controls._height;

		//Fit player to stage 
		fitPlayer(newWidth, newHeight);
		
		//Size controls
		controls.onResize();
		
		//Show videolist
		videoList.visible = true;
	}

	/**
	 *  videoList READY eventhandler
	 */
	private function videoListReady(eventObject:VideoListEvent):Void 
	{
		shareWindow.videoURL = "http://www.youtube.com/watch?v=" + eventObject.videoData.id + "&feature=player_embedded";
		
		//Cue first video
		player.cueVideoById(eventObject.videoData.id, 0, VideoQuality.HD);
		
		//Disable scrubber
		controls.scrubEnabled = false;
	}
	
	/**
	 *  controls SHARE_BUTTON_CLICKED eventhandler
	 */
	private function shareButtonClicked(eventObject:VideoControlsEvent):Void 
	{
		//Show shareWindow
		shareWindow.show();
	}

	/**
	 * controls PLAYSTATE_CHANGED eventhandler
	 */
	private function playStateChangedHandler(eventObject:VideoControlsEvent):Void 
	{
		//Pause or play the video
		if (eventObject.isPlaying) player.playVideo();
		else player.pauseVideo();
	}
	
	/**
	 * controls SCRUB_COMPLETED eventhandler
	 */
	private function scrubCompletedHandler(eventObject:VideoControlsEvent):Void 
	{
		//Seek to video position
		player.seekTo(eventObject.time, true);
	}
	
	/**
	 * controls SCRUB_STARTED eventhandler
	 */
	private function scrubStartedHandler():Void 
	{
		//Pause the video
		pauseVideo();
	}
	
	/**
	 * controls VOLUME_CHANGED eventhandler
	 */
	private function volumeChangedHandler(eventObject:VideoControlsEvent):Void 
	{
		//Set volume
		player.setVolume(eventObject.volume);
	}
	
	/**
	 * videoList VIDEO_SELECTED eventhandler
	 */
	private function videoSelected(eventObject:VideoListEvent):Void 
	{
		//Set controls isPlaying
		controls.isPlaying = false;
		
		controls.availableQuality = VideoQuality.UNDEFINED;
		
		//Play video with the specific id
		playVideo(eventObject.videoData.id);
		
		//Set videoURL in shareWindow
		shareWindow.videoURL = player.getVideoUrl();
	}

	/**
	 * Plays video with the specific id
	 */
	private function playVideo(id:String):Void
	{
		controls.scrubEnabled = false;
		
		controls.currentTime = 0;
		
		getQuality = true;
		
		controls.resetQuality();
		
		//Load video
		player.loadVideoById(id, 0, "hd720");
	}
	
	/**
	 * Pause the video
	 */
	private function pauseVideo(Void):Void
	{
		//Pause player
		player.pauseVideo();
		
		controls.isPlaying = false;
	}
	 
	/**
	 * player onStateChange eventhandler
	 */
	private function onPlayerStateChange(newState:Number):Void
	{
		if (newState == 1) 
		{
			//Video is playing
			controls.isPlaying = true;
			controls.videoDuration = player.getDuration();
		
			controls.scrubEnabled = true;
			
			setAvailabelQualityLevels();
			
			//Clear all errors
			clearErrors();
		} else if (newState == 0) {
			//Video ended
			player.stop();
			controls.isPlaying = false;
		}
	}
	
	private function setAvailabelQualityLevels():Void
	{
		if (getQuality) {
			var quality:String = player.getPlaybackQuality();
			if (quality == VideoQuality.HD) {
				player.setPlaybackQuality(VideoQuality.MEDIUM);
				controls.availableQuality = VideoQuality.HD;
			}else if (quality == VideoQuality.LARGE) {
				player.setPlaybackQuality(VideoQuality.MEDIUM);
				controls.availableQuality = VideoQuality.LARGE;
			}else {
				controls.availableQuality = VideoQuality.MEDIUM;
			}
			
			getQuality = false;
		}
	}
	
	/**
	 * player onError eventhandler
	 */
	private function onPlayerError(errorCode:Number):Void
	{
		errorMessageTxt.text = "";
		
		//Set errorMessage depending on errorCode
		var errorMessage:String = "";
		if (errorCode == 100) {
			errorMessage = "The Video requested is not found."
		}else if (errorCode == 150 || errorCode == 101) {
			errorMessage = "The video requested does not allow playback in the embedded player.";
		}
		
		errorMessageTxt.text += errorMessage;
	}
	
	/**
	 * Clear errorMessage
	 */
	private function clearErrors(Void):Void
	{
		errorMessageTxt.text = "";
	}
	
	/**
	 * Fit player to stage
	 */
	private function fitPlayer(width:Number, height:Number):Void
	{
		var availableWidth:Number = width;
		var availableHeight:Number = height;
		var availableSizeRatio:Number = availableWidth / availableHeight;

		var playerSizeRatio:Number = WIDESCREEN ? VideoResolution.WIDESCREEN : VideoResolution.NORMAL;
		
		var playerWidth:Number;
		var playerHeight:Number;
		
		if (availableSizeRatio > playerSizeRatio)
		{
			playerHeight = availableHeight;
			playerWidth = Math.round(playerHeight * playerSizeRatio);
		}else{
			playerWidth = availableWidth;
			playerHeight = Math.round(playerWidth / playerSizeRatio);
		}
		
		player.setSize(playerWidth, playerHeight);
		
		player._x = (availableWidth  - playerWidth) / 2;
		player._y = (availableHeight - playerHeight) / 2;
		
		//_root.debug.text = "fitPlayer - player._y : " + player._y + " availableHeight: " + availableHeight +  "player._height: " +  player._height;
	}
	
	/**
	 * Crop player to stage
	 */
	private function cropPlayer(width:Number, height:Number):Void
	{
		var availableWidth:Number = width;
		var availableHeight:Number = height;
		var availableSizeRatio:Number = availableWidth / availableHeight;

		var playerSizeRatio:Number = WIDESCREEN ? VideoResolution.WIDESCREEN : VideoResolution.NORMAL;
		
		var playerWidth:Number;
		var playerHeight:Number;
		
		if (availableSizeRatio > playerSizeRatio)
        {
            playerWidth = availableWidth;
            playerHeight = Math.round(playerWidth / availableSizeRatio);
        }else
        {
            playerHeight = availableHeight;
            playerWidth = Math.round(playerHeight * availableSizeRatio);
        }
		
		player.setSize(playerWidth, playerHeight);
		
		player._x = (availableWidth - player._width) / 2;
		player._y = (availableHeight - player._height) / 2;
	}
	
	public function destroy(Void):Void
	{
		player.destroy();
	}
}