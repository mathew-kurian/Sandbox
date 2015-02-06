package net.flashden.lydian.template {
	
	import flash.display.Shape;	
	
	/**
	 * A simple class to be used as a mask or border in this package.
	 */
	public class GenericRect extends Shape {
		
		public function GenericRect() {
			
			// Initialize the mask	
			init();
			
		}
		
		/**
		 * Draws a simple rectangle.
		 */
		private function init():void {
						
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0, 0, 10, 10);
			graphics.endFill();
			
		}
		
	}
	
}
