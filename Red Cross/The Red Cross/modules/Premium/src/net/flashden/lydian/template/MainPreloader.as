package net.flashden.lydian.template {
	
	import flash.display.MovieClip;
		
	public class MainPreloader extends MovieClip {
		
		// The loaded percentage
		private var _percent:Number = 0;
		
		/**
		 * Returns the loaded percentage.
		 */
		public function get percent():Number {

			return _percent;
			
		}
		
		/**
		 * Sets the loaded percentage.		 
		 */
		public function set percent(percent:Number):void {
			
			this._percent = percent;
			percentage.text = _percent + "%";
			frontLine.width = (width * _percent) / 100;
						
		}
		
		/**
		 * Resets the preloader.		 
		 */
		public function reset():void {
		
			_percent = 0;
			frontLine.width = 0;
			
		}
		
		
	}
	
}
