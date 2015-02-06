package net.flashden.lydian.photogallery {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
		
	public class InfoPanel extends MovieClip {
					
		public function InfoPanel() {
			
			// Initialize the panel
			init();
			
		}
		
		/**
		 * Initializes the panel
		 */
		private function init():void {
			
			index.mouseEnabled = mouseEnabled = false;
			background.mouseEnabled = title.mouseEnabled = subtitle.mouseEnabled = false;
			background.alpha = 0.7;
			
		}
		
		/**
		 * Updates the components on the panel.
		 */
		public function update(width:Number) {
						
			background.width = width;
			index.x = width - index.width - 14;
			title.width = width - index.width - 21;
			subtitle.width = width - 22;
			
		}
		
	}
	
}