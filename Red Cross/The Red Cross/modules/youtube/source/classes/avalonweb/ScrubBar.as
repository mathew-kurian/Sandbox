import ascb.util.Proxy;
import mx.core.UIComponent;
import mx.events.EventDispatcher;

class ScrubBar extends UIComponent
{
	//Duraion of the video
	private var _duration:Number = 0;
	
	//Current time of the video
	private var _currentTime:Number = 0;
	
	//Background
	private var background:MovieClip;
	
	//Time bar
	private var timeBar:MovieClip;
	
	public function ScrubBar() 
	{
		EventDispatcher.initialize(this);
		
		timeBar._width = 0;
	}
	
	/**
	 * Setter for currentTime variable
	 */
	public function set currentTime(value:Number):Void
	{
		_currentTime = value;
		
		//Set width of the time bar
		timeBar._width = background._width / duration * value;
	}
	
	/**
	 * onPress eventhandler
	 */
	private function onPress(Void):Void
	{
		//Set onMouseMove eventhandler
		onMouseMove = Proxy.create(this, mouseMoveHandler);
		
		//Set current time
		currentTime = getTimeFromX(_xmouse, false);
		
		//Dispatch SCRUBBER_PRESSED event
		dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SCRUBBER_PRESSED, currentTime));
	}

	/**
	 * Setter for duration variable
	 */
	public function set duration(value:Number):Void 
	{
		_duration = value;
	}
	
	/**
	 * Getter for duration variable
	 */
	public function get duration():Number { return _duration; }
	
	/**
	 * Getter for currentTime variable
	 */
	public function get currentTime():Number { return _currentTime; }
	
	/**
	 * onMouseDown eventhandler
	 */
	private function onMouseDownHandler(Void):Void
	{
		//Set onMouseMove eventhandler
		onMouseMove = Proxy.create(this, mouseMoveHandler);
	}
	
	/**
	 * onRelease eventhandler
	 */
	private function onRelease(Void):Void
	{
		//Set current time
		currentTime = getTimeFromX(_xmouse);
		
		//Dispatch SCRUBBER_RELEASED event
		dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SCRUBBER_RELEASED, currentTime));
		
		
		//Delete onMouseMove
		delete onMouseMove;
	}
	
	/**
	 * onReleaseOutside eventhandler
	 */
	private function onReleaseOutside(Void):Void
	{
		onRelease();
	}
	
	/**
	 * onMouseMove eventhandler
	 */
	private function mouseMoveHandler():Void 
	{
		//Set current time
		currentTime = getTimeFromX(_xmouse);
		
		
		//Dispatch SCRUBBER_MOVED event
		dispatchEvent( new ScrubBarEvent(ScrubBarEvent.SCRUBBER_MOVED, currentTime));
	}
	
	/**
	 * Get time from x value
	 */
	private function getTimeFromX(x:Number):Number
	{
		return Math.max(0, Math.min(duration, duration / background._width * x));
	}
	
	/**
	 * Set width
	 */
	public function setWidth(value:Number):Void
	{
		background._width = value;
		
		currentTime = currentTime;
	}
	
	/**
	 * Set colors
	 */
	public function setColors(Void):Void
	{
		var color:Color = new Color(timeBar.fill);
		color.setRGB(VideoGallery.HIGHLIGHT_COLOR);
	}
}