package net.flashden.lydian.photogallery {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.flashden.lydian.template.ConfigManager;
		
	public class ButtonPanel extends MovieClip {
				
	
		public function ButtonPanel() {
			
			// Initialize the panel
			init();
			
		}
		
		/**
		 * Initializes the panel.
		 */
		private function init():void {
			
			// Use movie clips as buttons
			nextButton.buttonMode = prevButton.buttonMode = true;
			nextButton.useHandCursor = prevButton.useHandCursor = true;
			infoButton.buttonMode = closeButton.buttonMode = true;
			infoButton.useHandCursor = closeButton.useHandCursor = true;
			
			// Add necessary event listeners
			nextButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverNextButton, false, 0, true);
			prevButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverPrevButton, false, 0, true);
			infoButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverInfoButton, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverCloseButton, false, 0, true);
			nextButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutNextButton, false, 0, true);
			prevButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutPrevButton, false, 0, true);
			infoButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutInfoButton, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutCloseButton, false, 0, true);
			
		}
		
		/**
		 * This method is called when the mouse is over the next button.
		 */
		private function mouseOverNextButton(evt:MouseEvent):void {
			
			Tweener.addTween(nextButton, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse is over the prev button.
		 */
		private function mouseOverPrevButton(evt:MouseEvent):void {
			
			Tweener.addTween(prevButton, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse is over the info button.
		 */
		private function mouseOverInfoButton(evt:MouseEvent):void {
			
			Tweener.addTween(infoButton, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse is over the close button.
		 */
		private function mouseOverCloseButton(evt:MouseEvent):void {
			
			Tweener.addTween(closeButton, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the next button.
		 */
		private function mouseOutNextButton(evt:MouseEvent):void {
			
			Tweener.addTween(nextButton, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the prev button.
		 */
		private function mouseOutPrevButton(evt:MouseEvent):void {
			
			Tweener.addTween(prevButton, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the info button.
		 */
		private function mouseOutInfoButton(evt:MouseEvent):void {
			
			Tweener.addTween(infoButton, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the close button.
		 */
		private function mouseOutCloseButton(evt:MouseEvent):void {
			
			Tweener.addTween(closeButton, {_color:null, time:1});
			
		}
		
	}
	
}