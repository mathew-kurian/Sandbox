import ascb.util.Proxy;
import caurina.transitions.properties.ColorShortcuts;
import caurina.transitions.Tweener;
import mx.containers.ScrollPane;
import mx.controls.ComboBox;
import mx.core.UIComponent;

class VideoList extends UIComponent
{
	//Array holding playlist objects
	private var _playlists:Array;
	
	//Scrollpane
	private var scrollPane:ScrollPane;
	
	//ComboBox
	private var playlistsComboBox:ComboBox;
	
	//Current selected playlist
	private var selectedPlaylist:Playlist;
	
	//Current selected playlist index
	private var selectedPlaylistIndex:Number = 0;
	
	//LoadVars instance
	private var loadVars:LoadVars;
	
	//Flag indicating if playlist is initial
	private var isInitialPlaylist:Boolean = true;
	
	public function VideoList() 
	{
		doLater(this, "setStyles");
		
		ColorShortcuts.init();
	}
	
	/**
	 * Set styles
	 */
	private function setStyles():Void
	{
		//Set scrollpane styles
		scrollPane.setStyle("borderStyle", "solid");
		scrollPane.setStyle("borderColor", 0x333333);
		scrollPane.setStyle("backgroundColor", 0x000000);
		scrollPane.hScrollPolicy = "off";
		scrollPane.vPageScrollSize = 60;
		scrollPane.vLineScrollSize = 60;
		
		//Set combobox styles
		playlistsComboBox.text_mc.setSize(370, 23);
		playlistsComboBox.setStyle("backgroundColor", 0x000000);
		playlistsComboBox.setStyle("color", 0x999999);
		playlistsComboBox.text_mc.setStyle("borderStyle", "solid");
		playlistsComboBox.setStyle("borderStyle", "solid");
		playlistsComboBox.setStyle("borderColor", 0x333333);
		playlistsComboBox.setStyle("rollOverColor", 0x333333);
		playlistsComboBox.setStyle("selectionColor", 0x000000);
		playlistsComboBox.setStyle("textSelectedColor", 0xFFFFFF);
		playlistsComboBox.setStyle("textRollOverColor", 0xFFFFFF);
		playlistsComboBox.setStyle("fontFamily", "Verdana");
		playlistsComboBox.setStyle("fontSize", "11");
	}
	
	/**
	 * Getter for playlists variable
	 */
	public function get playlists():Array { return _playlists; }
	
	/**
	 * Setter for playlists variable
	 */
	public function set playlists(value:Array):Void 
	{
		_playlists = value;
		
		setComboBox();
		
		//Show the first playlist
		showPlaylist(selectedPlaylistIndex);
	}

	/**
	 * Set the combobox dataprovider
	 */
	private function setComboBox(Void):Void
	{
		var dataProvider:Array = [];
		var playlist:Playlist;
		var i:Number = 0;
		var l:Number = playlists.length;
		
		for (i = 0; i < l; i++) {
			playlist = playlists[i];
			dataProvider.push( { label: "  " + playlist.title, data: i } );;
		}
		
		playlistsComboBox.dataProvider = dataProvider;
		playlistsComboBox.addEventListener("change", Proxy.create(this, playlistsComboBoxChanged))
	}
	
	/**
	 * playlistsComboBox change eventhandler
	 */
	private function playlistsComboBoxChanged(eventObject:Object):Void 
	{
		var index:Number = eventObject.target.selectedItem.data;
		showPlaylist(index);
	}
	
	
	/**
	 * Build the list
	 */
	private function buildVideoList(playlist:Playlist):Void
	{
		var i:Number;
		var l:Number = playlist.videos.length;
		var videoData:VideoData;
		var listItem:MovieClip;
		var j:String;
		
		//Remove all previous listitems
		for (j in scrollPane.content) 
		{ 
			scrollPane.content[j].removeMovieClip(); 
		}
		
		//Attach and fill listitems
		for (i = 0; i < l; i++) 
		{
			videoData = playlist.videos[i];
			
			//Attach listItem
			listItem = scrollPane.content.attachMovie("listItem", "listItem" + i, i);
		
			//Position listItem
			listItem._y = i * 120;
			
			//Set title
			listItem.titleTxt.autoSize = "left";
			listItem.titleTxt.text = getTruncatedTitleText(listItem.titleTxt, videoData.title);
			
			listItem.descriptionTxt.autoSize = "left";
			listItem.descriptionTxt.multiline = true;
			listItem.descriptionTxt.htmlText = playlist.type == Playlist.TYPE_CUSTOM ? videoData.description : getTruncatedText(listItem.descriptionTxt, videoData.description);
			
			//Set item index
			listItem.index = i;
			
			//Set thumbnail alpha to 0
			listItem.thumbnailContainer._alpha = 0;
		
			//Hide play symbol
			listItem.playSymbol._alpha = 0;
			
			//Load thumbnail
			var loaderListener:Object = { };
			loaderListener.onLoadInit = Proxy.create(this, thumbnailLoaded, [i]);
			 
			var loader:MovieClipLoader = new MovieClipLoader();
			loader.addListener(loaderListener);
			loader.loadClip(videoData.thumbnail, listItem.thumbnailContainer);
		}
		
		//Redraw scrollpane
		scrollPane.invalidate();
		
		//Dispatch READY event if initial playlist is ready
		
		if (isInitialPlaylist) {
			isInitialPlaylist = false;
			
			videoData = playlist.videos[0];
			dispatchEvent(new VideoListEvent(VideoListEvent.READY, videoData));
		}
	}
	
	private function getTruncatedTitleText(textField:TextField, text:String):String
	{
		var i:Number;
		var l:Number = text.length;
		var truncationText:String = "...";
		var t:Number = getTimer();
		
		for (i = 0; i < l; i++) {
			textField.text = text.substr(0, i);
			if (textField.textWidth > 200) {
				return text.substr(0, i - 4) + "...";
			}
		}
		
		return text;
	}
	
	private function getTruncatedText(textField:TextField, text:String):String
	{
		var i:Number;
		var l:Number = text.length;
		var truncationText:String = "...";
		var t:Number = getTimer();
		
		for (i = 0; i < l; i++) {
			textField.text = text.substr(0, i);
			if (textField.textHeight > 80) {
				return text.substr(0, i - 4) + "...";
			}
		}
		
		return text;
	}
	
	/**
	 * loaderListener onLoadInit eventhandler
	 */
	private function thumbnailLoaded(target:MovieClip, index:Number):Void 
	{
		//Fade in thumbnail
		Tweener.addTween(target, { _alpha: 100, time: 1 } );
		
		//Set eventhandler
		target.onRelease = Proxy.create(this, listItemClicked, index);
		target.onRollOver = Proxy.create(this, listItemOver, target);
		target.onRollOut = Proxy.create(this, listItemOut, target);
	}
	
	/**
	 * listItem onRollOver eventhandlers
	 */
	private function listItemOver(target:MovieClip ):Void 
	{
		Tweener.addTween(target._parent.playSymbol, { _alpha: 100, time: 0.5 } );
		Tweener.addTween(target._parent.highlight, { _color: VideoGallery.HIGHLIGHT_COLOR, time: 1 } );
	}
	
	/**
	 * listItem onRollOut eventhandlers
	 */
	private function listItemOut(target:MovieClip ):Void 
	{
		Tweener.addTween(target._parent.playSymbol, { _alpha: 0, time: 0.5 } );
		Tweener.addTween(target._parent.highlight, { _color: 0x000000, time: 1 } );
	}
	
	/**
	 * listItem onRelease eventhandler
	 */
	private function listItemClicked(index:Number):Void 
	{
		var videoData:VideoData = selectedPlaylist.videos[index];
	
		//Dispatch VIDEO_SELECTED event
		dispatchEvent(new VideoListEvent(VideoListEvent.VIDEO_SELECTED, videoData));
	}
	
	/**
	 * Show playlist with specific index
	 */
	private function showPlaylist(index:Number):Void
	{
		var playlist:Playlist = playlists[index];
		
		//Set selectedPlaylist
		selectedPlaylist = playlist;
		
		//Set selectedPlaylistIndex
		selectedPlaylistIndex = index;
		
		if (playlist.type == Playlist.TYPE_EXPORTED) {
			//Playlist is an imported youtube playlist
			if (playlist.loaded) {
				//If playlist has been loaded build videoList
				buildVideoList(playlist);
			}else {
				//If playlist has not been loaded load videoList
				loadPlaylistData(playlist.youtubeId);
			}
		}else {
			//Playlist is xml defined, just show it
			buildVideoList(playlist);
		}
	}
	
	/**
	 * Load playlist with specific id from youtube
	 */
	private function loadPlaylistData(id:String):Void
	{
		loadVars = new LoadVars();
		loadVars.onLoad = Proxy.create(this, playlistDataLoaded);
		loadVars.load("http://gdata.youtube.com/feeds/api/playlists/" + id + "?v=2&alt=json&max-results=50");
	}
	
	/**
	 * loadVars onLoad eventhandler 
	 */
	private function playlistDataLoaded():Void 
	{
		//Process JSON data
		var json:JSON = new JSON();
		var data:Object = json.parse(unescape(loadVars.toString()));
		var entries:Array = data.feed.entry;
		
		var videoData:VideoData;
		var i:Number = 0;
		var l:Number = entries.length;
		var entry:Object;
		var playlist:Playlist = playlists[selectedPlaylistIndex];
		
		//Set playlist loaded flag to true
		playlist.loaded = true;
		
		//Set title of the playlist
		playlist.title = data.feed.title.$t;
		
		var videos:Array = [];
		
		for (i = 0; i < l; i++) {
			entry = entries[i];
			
			//Create new videoData 
			videoData = new VideoData();
			
			//Get video title
			videoData.title = entry.title.$t;
			
			//Get video id
			videoData.id = entry.media$group.yt$videoid.$t;
			
			videoData.duration = entry.media$group.media$content[0].duration;
			
			//Get video description
			videoData.description = entry.media$group.media$description.$t;
			
			//Get thumbnail path
			videoData.thumbnail = entry.media$group.media$thumbnail[0].url;
			
			videos.push(videoData);
		}	
		
		playlist.videos = videos;
		
		//Build videolist
		buildVideoList(playlist);
	}
	
	/**
	 * onResize eventhandler
	 */
	public function onResize(Void):Void
	{
		scrollPane.setSize(370, VideoGallery.GALLERY_HEIGHT - 30);
	}
}