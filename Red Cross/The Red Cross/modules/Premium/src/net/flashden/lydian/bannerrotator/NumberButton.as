package net.flashden.lydian.bannerrotator {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.flashden.lydian.template.ConfigManager;
		
	public class NumberButton extends MovieClip {
		
		// The index number of the button
		private var _index:int;
		
		// Indicates whether the button is selected or not
		private var _selected:Boolean = false;
		
		// An array to hold filters
		private var _numberFilters:Array;
		
		public function NumberButton(index:int = 0) {
			
			this._index = index;
			
			// Initialize the button
			init();
			
		}
		
		/**
		 * Initializes the button.
		 */
		private function init():void {
			
			// Use as a button
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			
			// Set the text on the button
			value.text = "" + (_index + 1);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
		}
		
		/**
		 * This method is called when the mouse is over the button.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			if (!_selected) {
				playMouseOverTweens();
			}
			
		}
		
		/**
		 * This method is called when the mouse leaves the button.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			if (!_selected) {
				playMouseOutTweens();
			}
			
		}
		
		/**
		 * Plays mouse over tweens.
		 */
		private function playMouseOverTweens():void {
			
			Tweener.addTween(this, {scaleX:1.45, scaleY:1.45, time:.4, transition:Equations.easeOutQuint});					
			
		}
		
		/**
		 * Plays mouse out tweens.
		 */
		private function playMouseOutTweens():void {
			
			Tweener.addTween(this, {scaleX:1, scaleY:1, time:1.4, transition:Equations.easeOutQuint});
			Tweener.addTween(background, {_color:null, time:1.4});
			Tweener.addTween(value, {_color:null, time:1.4});
			
			if (_numberFilters != null) {
				value.filters = _numberFilters;
			}
			
		}
		
		/**
		 * Selects the button.
		 */
		public function select():void {
			
			if (!_selected) {
				Tweener.addTween(this, {scaleX:1.45, scaleY:1.45, time:.55, transition:Equations.easeOutQuart});
				Tweener.addTween(background, {_color:ConfigManager.BR_SELECTED_BUTTON_COLOR, time:1});
				Tweener.addTween(value, {_color:ConfigManager.BR_SELECTED_BUTTON_TEXT_COLOR, time:1});
				_numberFilters = value.filters;
				value.filters = null;
			}
			
			_selected = true;
			
		}
		
		/**
		 * Deselects the button.
		 */
		public function deselect():void {
		
			if (_selected) {
				playMouseOutTweens();
			}
			
			_selected = false;
			
		}			
		
		/**
		 * Returns the index number of the button.
		 */
		public function get index():int {
			
			return _index;
			
		}

	}	
	
}