import ascb.util.Proxy;
import mx.core.UIComponent;
import mx.events.EventDispatcher;

class VolumeSlider extends UIComponent
{
	//Slider bar
	private var bar:MovieClip;
	
	//Last volume value
	private var oldValue:Number;
	
	//Current volume value
	private var _value:Number;
	
	//Background of the slider
	private var background:MovieClip;
	
	public function VolumeSlider() 
	{
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Setter for value variable
	 */
	public function set value(value:Number):Void
	{
		_value = value;
		
		//Set the bar width
		bar._width = (background._width - 2) / 100 * value;
	}
	
	/**
	 * Getter for the value variable
	 */
	public function get value():Number { return _value; }
	
	/**
	 * onPress eventhandler
	 */
	private function onPress(Void):Void
	{
		//Set value from mouse position
		value = getValueFromX(_xmouse);
		
		//Set onMouseMove eventhandler
		onMouseMove = Proxy.create(this, mouseMoveHandler);
		
		//Dispatch change event
		dispatchChangeEvent();
	}
	
	/**
	 * onRelease eventhandler
	 */
	private function onRelease(Void):Void
	{
		//Set value from mouse position
		value = getValueFromX(_xmouse);
		
		//Dispatch change event
		dispatchChangeEvent();
		
		//Delete onMouseMove
		delete onMouseMove;
	}
	
	/**
	 * onReleaseOutside eventhandler
	 */
	private function onReleaseOutside(Void):Void
	{
		delete onMouseMove;
	}
	
	/**
	 * onMouseMove eventhandler
	 */
	private function mouseMoveHandler():Void 
	{
		//Set value from mouse position
		value = getValueFromX(_xmouse);
		
		//If value changed dispatch change event
		if (value != oldValue) dispatchChangeEvent();
		
		oldValue = value;
	}
	
	/**
	 * Dispatches change event
	 */
	private function dispatchChangeEvent():Void
	{
		dispatchEvent(new VolumeSliderEvent(VolumeSliderEvent.VOLUME_CHANGED, value));
	}
	
	/**
	 * Get value from x position
	 */
	private function getValueFromX(x:Number):Number
	{
		return Math.max(0, Math.min(100, 100 / background._width * x));
	}
	
	/**
	 * Set colors
	 */
	public function setColors(Void):Void
	{
		var color:Color = new Color(bar.fill);
		color.setRGB(VideoGallery.HIGHLIGHT_COLOR);
	}
	
}