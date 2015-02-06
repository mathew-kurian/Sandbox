package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	
	public class RightButton extends MovieClip {
	
		public function RightButton() {
			
			// Initialize the button
			init();
			
		}
		
		/**
		 * Initializes the button.
		 */
		private function init():void {
			
			// Use as a button
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		
			// Add necessary event listeners
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
		}
		
		/**
		 * This method is called when the mouse is over the button.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			Tweener.addTween(this, {_color:ConfigManager.HIGHLIGHT_COLOR,
							scaleX:1.2, scaleY:1.2, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the button.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			Tweener.addTween(this, {_color:null, scaleX:1, scaleY:1, time:0.5});
			
		}
		
	}
	
}