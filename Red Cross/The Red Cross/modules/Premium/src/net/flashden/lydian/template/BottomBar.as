package net.flashden.lydian.template {
	
	import flash.display.MovieClip;
		
	public class BottomBar extends MovieClip {

		/**
		 * Updates everything on the bottom bar.
		 */ 
		public function update(width:Number):void {
			
			mp3Player.x = width - mp3Player.width - 15;
			
		}
		
	}
	
}