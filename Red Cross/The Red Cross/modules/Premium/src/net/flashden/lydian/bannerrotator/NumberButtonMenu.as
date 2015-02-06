package net.flashden.lydian.bannerrotator {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.flashden.lydian.template.ConfigManager;
	
	public class NumberButtonMenu extends Sprite {
		
		// An array to hold buttons
		private var _buttons:Array = new Array();
		
		// Number of buttons
		private var _numOfButtons:int;
		
		// Holds the selected button index
		private var _selectedIndex:int = -1;

		public function NumberButtonMenu(numOfButtons:int) {
			
			this._numOfButtons = numOfButtons;

			// Initialize the menu
			init();
			
		}
		
		/**
		 * Initializes the button menu.
		 */
		private function init():void {

			// Create all buttons
			for (var i = 0; i < _numOfButtons; i++) {
				var numberButton:NumberButton = new NumberButton(i);
				numberButton.x = i * (ConfigManager.NUMBER_BUTTON_SPACING + numberButton.width);
				numberButton.alpha = 0;
				addChild(numberButton);
				_buttons.push(numberButton);
			}
			
			// Play intro tweens
			playIntro();
			
			// Add necessary event listeners
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			
		}
		
		/**
		 * Plays intro tweens.
		 */
		private function playIntro():void {
			
			for (var i = 0; i < _numOfButtons; i++) {
				var numberButton:NumberButton = _buttons[i];
				numberButton.scaleY = numberButton.scaleX = 0;
				Tweener.addTween(numberButton, {scaleX:1, scaleY:1, alpha:1,
							time:.5, delay:i * 0.15, transition:Equations.easeOutQuint});
			}
			
		}
		
		/**
		 * This method is called when the mouse is clicked.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			// Get the button
			var button:NumberButton = evt.target as NumberButton;
			
			// Select the button
			if (button != null) {
				select(button.index);	
			}
			
		}
		
		/**
		 * Selects the button with the given index.
		 */
		public function select(index:int):void {
			
			if (index >= 0 && index < _buttons.length && index != _selectedIndex) {
				// Remove previous selection				
				if (_selectedIndex != -1) {
					_buttons[_selectedIndex].deselect();					
				}
				
				_buttons[index].select();				
				dispatchEvent(new NumberButtonEvent(NumberButtonEvent.SELECTED, false, false, index, _selectedIndex));
				_selectedIndex = index;
			}
			
		}
		
	}
	
}
