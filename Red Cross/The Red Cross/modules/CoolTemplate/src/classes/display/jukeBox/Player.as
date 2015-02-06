/*
Player.as
JukeBox

Created by Alexander Ruiz Ponce on 16/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.errors.IOError;
    import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.motion.easing.*;
	
	import gs.TweenMax;
	import gs.plugins.TweenPlugin;
	import gs.plugins.EndArrayPlugin;
	
	import gT.display.components.GenericComponent;
	import gT.utils.DisplayObjectUtils;
	import gT.display.InteractiveBitmap;
	import gT.utils.EventUtils;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class Player extends GenericComponent {
		
		private var __lcd:LCD;
		private var __pl:LCDButton;
		private var __progressBar:ProgressBar;
		private var __loaderBar:ProgressBar;
		private var __volume:DragableProgressBar;
		private var __padding:uint = 8;
		private var __controlsHolder:Sprite;
		
		private var __playButton:InteractiveBitmap;
		private var __pauseButton:InteractiveBitmap;
		private var __FFButton:InteractiveBitmap;
		private var __BFButton:InteractiveBitmap;
		
		private var __URLSound:String;
		private var __trackInfo:Object;
		private var __sound:Sound;
		private var __channel:SoundChannel;
		private var __currentVolume:Number;
		private var __soundTransform:SoundTransform;
		private var __isPlaying:Boolean;
		private var __pausePosition:Number;
		private var __ticket:Ticket;
		private var __tweens:Array;
		private var __ticketTimer:Timer;
		private var __hasTicket:Boolean;
		private var __isOver:Boolean;

		//////////////////////////////////////////////////////////
		//
		// Constructor
		//
		//////////////////////////////////////////////////////////
		public function Player () 
		{
			TweenPlugin.activate([EndArrayPlugin]);
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		override protected function init ():void
		{
			// Creating Sound object
			
			__sound = new Sound();
			__sound.addEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler, false, 0, true);
			__sound.addEventListener(ProgressEvent.PROGRESS, soundProgressHandler, false, 0, true);
			
			
			// Creating SoundChannel Object
			__channel = new SoundChannel;
			__channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
			
			// soundTransform
			if (Global.so.data.volume == undefined) {
				__currentVolume = Global.settings.jukeBoxDefaultVolume;
			} else {
				__currentVolume = Global.so.data.volume;
			}
			
			__soundTransform = new SoundTransform(__currentVolume);
			
			// Ticket Timer Event
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
			
			super.init();
			
			// Detects ENTER_FRAME Event from main to refresh the display list
			Global.addEventListener(CustomEvent.GLOBAL_RENDER, render, false, 0, true);
		}
		
		/*
		override protected function onStage():void
		{
			startTicketTimer(true);
		}
		*/
		
		override protected function addChildren():void
		{
			// LCD
			__lcd = new LCD;
			addChild(__lcd);
			
			// ticket
			__ticket = new Ticket(false);
			__ticket.align = "center";
			__ticket.delay = 1;
			DisplayObjectUtils.addProperties(__ticket, {alpha:0, visible:false});
			__lcd.content.addChild(__ticket);
			
			// Play List Button
			__pl = new LCDButton("Play List");
			DisplayObjectUtils.addProperties(__pl, {width:55, height:11, x:__padding, y:__padding});
			__pl.addEventListener(MouseEvent.CLICK, buttonsHandler, false, 0, true);
			
			__lcd.content.addChild(__pl);
			
			// ProgressBar
			__loaderBar = new ProgressBar;
			DisplayObjectUtils.addProperties(__loaderBar, {width:__minWidth, height:7, x:__padding, y:28, alpha:.3});
			__lcd.content.addChild(__loaderBar);
			
			__progressBar = new ProgressBar;
			DisplayObjectUtils.addProperties(__progressBar, {width:__minWidth, height:7, x:__padding, y:28});
			__lcd.content.addChild(__progressBar);
			
			// Volume
			
			__volume = new DragableProgressBar;
			DisplayObjectUtils.addProperties(__volume, {width:55, height:10, y:__padding, percent:__currentVolume * 100});
			__volume.addEventListener(JukeBoxEvent.CHANGE, volumeHandler, false, 0, true);
			__lcd.content.addChild(__volume);
			
			// Controls
			__controlsHolder = new Sprite;
			__controlsHolder.y = __padding - 1;
			__lcd.content.addChild(__controlsHolder);
			
			__BFButton = new InteractiveBitmap(new BJukeBoxBFButton(0,0));
			__controlsHolder.addChild(__BFButton);
			
			__playButton = new InteractiveBitmap(new BJukeBoxPlayButton(0,0));
			//__playButton.visible = false;
			__controlsHolder.addChild(__playButton);
			__playButton.x = 27;
			
			__pauseButton = new InteractiveBitmap(new BJukeBoxPauseButton(0,0));
			__controlsHolder.addChild(__pauseButton);
			__pauseButton.x = 25;
			
			__FFButton = new InteractiveBitmap(new BJukeBoxFFButton(0,0));
			__controlsHolder.addChild(__FFButton);
			__FFButton.x = 45;
			
			EventUtils.add([__playButton, __pauseButton, __FFButton, __BFButton], [MouseEvent.CLICK, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_OUT], buttonsHandler, false, 0, true);
			DisplayObjectUtils.addProperties([__playButton, __pauseButton, __FFButton, __BFButton], {buttonMode:true});
			
			refreshPlayPauseButton();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			DisplayObjectUtils.addProperties([__lcd, __ticket], {width:__width, height:__height});
			
			__progressBar.width = __width - (LCD.MARGIN * 2) - (__padding * 2);
			__loaderBar.width = __progressBar.width;
			__volume.x = __width - __volume.width - (LCD.MARGIN * 2) - __padding;
			
			__controlsHolder.x = Math.round((__width - __controlsHolder.width) / 2);
		}
		        
		public function play (trackInfo:Object):void
		{
			__trackInfo = trackInfo;
			__isPlaying = true;
			__URLSound = __trackInfo.url;
			
			try {
				__sound.close();
			} catch (e) {
			}
			
			// Clear the channel
			__channel.stop();
			__channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			__channel = null;
			
			// Clear the sound
			__sound.removeEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler);
			__sound.removeEventListener(ProgressEvent.PROGRESS, soundProgressHandler);
			__sound = null;
			
			// Define the sound
			__sound = new Sound();
			__sound.addEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler, false, 0, true);
			__sound.addEventListener(ProgressEvent.PROGRESS, soundProgressHandler, false, 0, true);
			__sound.load(new URLRequest(__URLSound));
			
			// Define the channel
			__channel = __sound.play(0, 0, __soundTransform);
			__channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
			
			refreshPlayPauseButton();
			
			// Update the ticket text
			updateTicket();
		}
		
		public function togglePause ():void
		{
			if (__URLSound) {
				if (__isPlaying) {
					__pausePosition = __channel.position;
					__channel.stop();
					__isPlaying = false;
				} else if (!__isPlaying) {
					__channel = __sound.play(__pausePosition, 0, __soundTransform);
					__isPlaying = true;
				}
			}
			
			refreshPlayPauseButton();
		}
		
		public function pauseFade():void{
			var arrayVol:Array = [__currentVolume];
			TweenMax.to(arrayVol, 2, {endArray:[0], onUpdate:function(){
					__soundTransform.volume = arrayVol[0];
					__channel.soundTransform = __soundTransform;
						}, onComplete:function(){
						__pausePosition = __channel.position;
						__channel.stop();
					}});
		}
		
		public function playFade():void{
			var arrayVol:Array = [0];
			TweenMax.to(arrayVol, 2, {endArray:[__currentVolume], onUpdate:function(){
						__soundTransform.volume = arrayVol[0];
						__channel.soundTransform = __soundTransform;					
						}, onStart:function(){
						if(__isPlaying){
							__channel = __sound.play(__pausePosition, 0, __soundTransform);
						}
					}});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function buttonsHandler (e:MouseEvent):void
		{
			var current = e.currentTarget;
			
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					TweenMax.to(current, .5, {glowFilter:{color:0xffffff, alpha:1, blurX:7, blurY:7, strength:2}, yoyo:0});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenMax.to(current, .5, {glowFilter:{alpha:0, remove:true}});
					break;
				case MouseEvent.CLICK:
					switch (current) {
						case __FFButton:
							// Next
							dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"next"}));
							break;
						case __BFButton:
							// Previous
							dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"back"}));
							break;
						case __playButton:
							// Play
							togglePause();
							dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"play"}));
							break;
						case __pauseButton:
							// PlayPause
							togglePause();
							dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"pause"}));
							break;
						case __pl:
							// PlayList
							dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"playList"}, true));
							break;

					}
					break;

			}
		}
		
		private function volumeHandler (e:JukeBoxEvent = null):void
		{
			__currentVolume = Math.round(__volume.percent) / 100;
			__soundTransform.volume = __currentVolume;
			__channel.soundTransform = __soundTransform;
			// Save the user preference of volume
			Global.so.data.volume = __currentVolume;
		}
		
		private function soundErrorHandler (e:IOErrorEvent):void 
		{
			trace("Couldn't load the file " + e.text);
        }
		
		private function soundProgressHandler (e:ProgressEvent):void
		{
			var loadTime:Number = e.bytesLoaded / e.bytesTotal;
            var loadPercent:uint = Math.round(100 * loadTime);
			__loaderBar.percent = loadPercent;
			//TweenMax.to(__loaderBar, .5, {percent:loadPercent});
		}
		
		private function soundCompleteHandler (e:Event):void
		{
			//trace("COMPLETE");			
			dispatchEvent(new JukeBoxEvent(JukeBoxEvent.JUKE_BOX_SOUND_COMPLETE, {trackInfo:__trackInfo}));
			//dispatchEvent(new JukeBoxEvent(JukeBoxEvent.PLAYER_BUTTON_CLICKED, {id:"next"}));
		}
		
		private function progressTimerHandler ():void
		{	
			var estimatedLength:int = Math.ceil(__sound.length / (__sound.bytesLoaded / __sound.bytesTotal));
			var playbackPercent:uint = Math.round(100 * (__channel.position / estimatedLength));
			__progressBar.percent = playbackPercent;
		}
		
		private function mouseHandler (e:MouseEvent):void
		{
			switch (e.type) 
			{
				case MouseEvent.ROLL_OVER:
					__isOver = true;
					startTicketTimer(false);
					TweenMax.killTweensOf(__ticket);
					if (__hasTicket) {
						showTicket(false);
					}
					break;
					
				case MouseEvent.ROLL_OUT:
					__isOver = false;
					startTicketTimer(true);
					break;
			}
		}
		
		private function ticketTimerComplete (e:TimerEvent):void
		{
			showTicket();
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		
		private function refreshPlayPauseButton ():void
		{
			__playButton.visible = !__isPlaying;
			__pauseButton.visible = __isPlaying;
		}
		
		private function showTicket (action:Boolean = true):void
		{
			__hasTicket = action;

			var t:Number = .5;
			var e = Exponential;
			var ei:Function = e.easeIn;
			var yPos:Number = -20;
			
			if (action) {
				__tweens = new Array;
				__tweens.push(TweenMax.to(__pl,				t, {visible:false, y:yPos, x:-__pl.width, ease:ei}));
				__tweens.push(TweenMax.to(__controlsHolder,	t, {visible:false, y:yPos, ease:ei}));
				__tweens.push(TweenMax.to(__volume,			t, {visible:false, y:yPos, x:String(__volume.width), ease:ei}));
				__tweens.push(TweenMax.to(__loaderBar,		t, {visible:false, y:__height + __loaderBar.height, ease:ei}));
				__tweens.push(TweenMax.to(__progressBar,	t, {visible:false, y:__height + __loaderBar.height, ease:ei}));
				
				__ticket.text = __trackInfo.name;
				TweenMax.to(__ticket, 5, {autoAlpha:1, delay:.7, onComplete:startTicket});
			
			} else {
				TweenMax.to(__ticket, .3, {autoAlpha:0, onComplete:reverse})
			}
			
			// Reverse animation
			function reverse () 
			{
				__ticket.stop(false, true);
				
				for (var i in __tweens) 
				{
					__tweens[i].reverse();
				}
			}
			
			// start the ticket transition
			function startTicket () 
			{
				__ticket.start();
			}
		}
		
		private function startTicketTimer (action:Boolean):void
		{
			if (Global.playListEnabled == false && __trackInfo && !__isOver) 
			{
				if (action) 
				{
					startTicketTimer(false);
					__ticketTimer = new Timer(Global.settings.jukeBoxTicketDelay * 1000, 1);
					__ticketTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ticketTimerComplete, false, 0, true);
					__ticketTimer.start();
				} else if (__ticketTimer) {
					__ticketTimer.stop();
					__ticketTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, ticketTimerComplete);
					__ticketTimer = null;
				}
				
				return;
			}
			
			if (__ticketTimer) {
				__ticketTimer.stop();
				__ticketTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, ticketTimerComplete);
				__ticketTimer = null;
			}
		}
		
		private function updateTicket ():void
		{
			if (__hasTicket) {
				TweenMax.to(__ticket, Global.settings.time, {alpha:0, y:-__ticket.height, ease:Global.settings.easeIn, onComplete:changeTicketText});
			} else {
				startTicketTimer(true);
			}
			
			// Internal function for the onComplete of TweenMax
			function changeTicketText () 
			{
				__ticket.text = __trackInfo.name;
				__ticket.y = __ticket.height;
				TweenMax.to(__ticket, Global.settings.time, {alpha:1, y:0, ease:Global.settings.easeOut});
			}
		}
		
		private function render (e:CustomEvent):void
		{
			if (__sound) {
				progressTimerHandler();
			}
			//trace("HOLA");
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get FFButton ():InteractiveBitmap
		{
			return __FFButton;
		}
		
		public function get BFButton ():InteractiveBitmap
		{
			return __BFButton;
		}
		
		public function get playButton ():InteractiveBitmap
		{
			return __playButton;
		}
		
		public function get pauseButton ():InteractiveBitmap
		{
			return __pauseButton;
		}
	}
}