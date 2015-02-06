package net.flashden.lydian.sound {

	import flash.display.MovieClip;
	import flash.utils.ByteArray;
			
	public class Equalizer extends MovieClip {
		
		// Length of the spectrum to be read
		private static const SPECTRUM_LEN:uint = 256;
		
		// Number of equalizer bars
		private static const NUM_OF_BARS:uint = 5;
		
		// Length of the each interval
		private static const sampleLen:Number = NUM_OF_BARS / SPECTRUM_LEN;
	
		public function Equalizer() {
		}

		/**
		 * Updates the equalizer bars by reading the given byte array.
		 */
		public function update(bytes:ByteArray):void {
						
			var sampleValue:Number = 0;
		
			try {
				for (var i:int = 0; i < NUM_OF_BARS; i++) {				
					sampleValue = 0;
					
					for (var j:int = 0; j < sampleLen; j++) {
						var value:Number = Math.abs(bytes.readFloat());
						sampleValue = value > sampleValue ? value : sampleValue;
					}
					
					var equalizerBar = getChildAt(i) as EqualizerBar;
					var barHeight:Number = 1 + (sampleValue * equalizerBar.height);
					equalizerBar.barMask.height += (barHeight - equalizerBar.barMask.height) / 3;
				}
			} catch (e:Error) {
			}
					
		}
		
	}
		
}