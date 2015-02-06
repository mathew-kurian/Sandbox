import ascb.util.Proxy;
import caurina.transitions.Tweener;
import mx.containers.ScrollPane;
import mx.core.UIComponent;
import mx.events.EventDispatcher;

class ShareWindow extends UIComponent
{
	//Close button
	private var closeButton:MovieClip;
	
	//Send button
	private var sendButton:MovieClip;
	
	//Email input field
	private var emailTxt:TextField;
	
	//Current video URL
	private var _videoURL:String;
	
	//Email field error highlight
	private var emailFieldHighlight:MovieClip;
	private var scrollPane:ScrollPane;
	
	public function ShareWindow() 
	{
		doLater(this, "initialize");
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Initialize window
	 */
	private function initialize(Void):Void
	{
		//Hide window initially
		_visible = false;
		
		//Set button eventhandlers
		closeButton.onRelease = Proxy.create(this, closeButtonClicked);
		sendButton.onRelease = Proxy.create(this, sendButtonClicked);
		
		//Hide email field highlight
		emailFieldHighlight._alpha = 0;
		
		//Set scrollpane styles
		scrollPane.setStyle("borderStyle", "solid");
		scrollPane.setStyle("borderColor", 0x333333);
		scrollPane.setStyle("backgroundColor", 0x000000);
		scrollPane.hScrollPolicy = "off";
		scrollPane.vPageScrollSize = 60;
		scrollPane.vLineScrollSize = 60;
		
		var destinations:Array = AddThisDestinations.destinations;
		var l:Number = destinations.length;
		var i:Number = 0;
		var destination:AddThisDestination;
		var row:MovieClip;
		var icon:MovieClip;
		
		for (i = 0; i < l; i ++) {
			destination = destinations[i];
			
			row = scrollPane.content.attachMovie("shareRow", "row" + i, i);
			icon = row.attachMovie(destination.iconId, "icon", 1);
			row.destination = destination;
			row.onRelease = Proxy.create(this, addThis, row.destination);
			row.onRollOver = Proxy.create(this, rowOver, row);
			row.onRollOut = Proxy.create(this, rowOut, row);
			row.onReleaseOutside =  row.onRollOut;
			icon._x = icon._y = 5;
			row.rowTitle.titleTxt.text = destination.title;
			row._y = i * 20;
		}
		
		scrollPane.invalidate();
	}
	
	private function rowOut(row:MovieClip):Void 
	{
		Tweener.addTween(row.rowTitle, { _color: 0x999999, time: 1 } );
		Tweener.addTween(row.icon, { _brightness: 0, time: 1 } );
	}
	
	private function rowOver(row:MovieClip):Void 
	{
		Tweener.addTween(row.rowTitle, { _color: VideoGallery.HIGHLIGHT_COLOR, time: 1 } );
		Tweener.addTween(row.icon, { _brightness: 1, time: 1 } );
	}
	
	private function addThis(destination:AddThisDestination):Void 
	{
		getURL("http://api.addthis.com/oexchange/0.8/forward/" + destination.serviceCode + "/offer?url=" + escape(videoURL));
	}
	
	/**
	 * sendButton onRelease eventhandler
	 */
	private function sendButtonClicked(Void):Void 
	{
		var email:String = emailTxt.text;
		
		//Check if email is valid
		if (CheckMail.isEmail(email)) {
			share(email);
		}else {
			highlightEmailField();
		}
	}
	
	private function highlightEmailField():Void
	{
		var color:Color = new Color(emailFieldHighlight);
		color.setRGB(VideoGallery.HIGHLIGHT_COLOR);
		
		emailFieldHighlight._alpha = 100;
		Tweener.addTween(emailFieldHighlight, { _alpha: 0, time: 1 } );
	}
	
	/**
	 * closeButton onRelease eventhandler
	 */
	private function closeButtonClicked(Void):Void 
	{
		hide();
	}
	
	/**
	 * Show window
	 */
	public function show(Void):Void
	{
		_visible = true;
	}
	
	
	/**
	 * Hide window
	 */
	public function hide(Void):Void
	{
		_visible = false;
	}
	
	/**
	 * Send data
	 */
	private function share(email:String):Void
	{
		var loadVars:LoadVars = new LoadVars();
		var sendVars:LoadVars = new LoadVars();
		sendVars.videoURL = escape(videoURL);
		sendVars.recipientEmail = escape(email);
		sendVars.sendAndLoad("share.php", loadVars);

		emailTxt.text = "";
	}
	
	/**
	 * Getter for videoURL variable
	 */
	public function get videoURL():String { return _videoURL; }
	
	/**
	 * Setter for videoURL variable
	 */
	public function set videoURL(value:String):Void 
	{
		_videoURL = value;
	}
}