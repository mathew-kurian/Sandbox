package net.flashden.lydian.sound {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import net.flashden.lydian.template.ConfigManager;
			
	public class MP3Player extends MovieClip {
		
		// Sound object to be played
		private var mp3:Sound = new Sound();
		
		// A sound channel to play the sound object
		private var channel:SoundChannel;
		
		// Holds the pause position
		private var pausePos:Number;
		
		// A byte array to read spectrum
		private var bytes:ByteArray = new ByteArray();
		
		// Indicates whether the mp3 player is playing or not.
		private var _isPlaying:Boolean = false;
	
		public function MP3Player() {
			
			init();
			
		}
		
		/**
		 * Initializes the player.
		 */
		private function init():void {
			
			// Use as a button
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;

			// Add necessary event listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			load();
			
		}
		
		/**
		 * Start loading the mp3 file.
		 */
		private function load():void {
			
			mp3.load(new URLRequest(ConfigManager.MP3_FILE));
			mp3.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			channel = mp3.play();
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);			
			_isPlaying = true;
			
		}
		
		/**
		 * This method is called whenever a new enter frame event occurs.
		 */
		private function onEnterFrame(evt:Event):void {
			
			try {
				SoundMixer.computeSpectrum(bytes, true, 0);
			} catch (e:Error) {
			}
			
			equalizer.update(bytes);
			
		}
		
		/**
		 * This method is called when playing the sound is finished.
		 */
		private function onSoundComplete(evt:Event):void {
			
			// Loop
			channel = mp3.play();
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			_isPlaying = true;
			
		}
		
		/**
		 * This method is called when the mouse is over the mp3 player.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			Tweener.addTween(label, {_color:0xFF0000, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the mp3 player.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			Tweener.addTween(label, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the mouse is clicked on the mp3 player.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			if (_isPlaying) {
				pausePos = channel.position;
				channel.stop();
				_isPlaying = false;
				label.text = "Music Off";				
			} else {
				channel = mp3.play(pausePos);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
				_isPlaying = true;
				label.text = "Music On";
			}
			
		}
		
		/**
		 * This method is called if an IO error occurs.
		 */
		private function onIOError(evt:IOErrorEvent):void {
		}
		
	}
		
}