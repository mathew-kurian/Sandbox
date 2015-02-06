import caurina.transitions.properties.ColorShortcuts;
import caurina.transitions.properties.FilterShortcuts;
import caurina.transitions.Tweener;
import flash.filters.GlowFilter;

class IconButton extends MovieClip
{
	//Icon shown on the button
	private var icon:MovieClip;
	
	private var _selected:Boolean = false;
	
	public function IconButton() 
	{
		ColorShortcuts.init();
	}
	
	/**
	 * onRollOver eventhandler
	 */
	private function onRollOver(Void):Void
	{
		if (selected) return;
		
		//Color the icon
		Tweener.addTween(icon, { _color: VideoGallery.HIGHLIGHT_COLOR, time: 1 } );
	}
	
	/**
	 * onRollOver eventhandler
	 */
	private function onRollOut(Void):Void
	{
		if (selected) return;
		
		//Color the icon
		Tweener.addTween(icon, { _color: 0x999999, time: 1 } );
	}
	
	/**
	 * onReleaseOutside eventhandler
	 */
	private function onReleaseOutside(Void):Void
	{
		onRollOut();
	}
	
	public function set selected(value:Boolean)
	{
		var color:Color = new Color(icon);
		var colorValue:Number = value ? VideoGallery.HIGHLIGHT_COLOR : 0x999999;
		color.setRGB(colorValue);
		
		_selected = value;
	}
	
	public function get selected():Boolean { return _selected; }
}