/*
PlayListHeader.as
JukeBox

Created by Alexander Ruiz Ponce on 23/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;
	import gT.display.components.GenericComponent;
	import gT.display.InteractiveBitmap;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.EventUtils;
	
	import classes.Global;
	
	public class PlayListHeader extends GenericComponent {
		
		private var __shuffleButton:InteractiveBitmap;
		private var __repeatButton:InteractiveBitmap;
		private var __title:TextField;
		private var __ticket:Ticket;
		private var __hr:Sprite;
		private var __repeatEnabled:Boolean;
		private var __shuffleEnabled:Boolean;
		//private var __shuffleCount:uint;
		
		public function PlayListHeader () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		
		override protected function init ():void
		{
			super.init();
			EventUtils.add([__repeatButton, __shuffleButton], MouseEvent.CLICK, buttonHandler, false, 0, true);
		}
		
		/*
		override protected function onStage():void
		{
		}*/
		
		override protected function addChildren():void
		{
			// Title
			var titleFont = new PF_Tempesta_Seven_Bold;
			__title = titleFont.tf;
			DisplayObjectUtils.addProperties(__title, {autoSize:"left", text:"NOW PLAYING", x:8, y:3, textColor:0x646a72});
			addChild(__title);
			
			// Ticket
			__ticket = new Ticket(false, ". . .");
			DisplayObjectUtils.addProperties(__ticket, {x:8, y:15, textField:"PF_Tempesta_Seven_Regular_white", speed:10});
			addChild(__ticket);
			
			// Buttons
			__repeatButton = new InteractiveBitmap(new JukeBoxPlayListRepeatButton(0,0));
			DisplayObjectUtils.addProperties(__repeatButton, {y:8, alpha:.2, buttonMode:true});
			//addChild(__repeatButton); // Disable for now
			
			__shuffleButton = new InteractiveBitmap(new JukeBoxPlayListShuffleButton(0,0));
			DisplayObjectUtils.addProperties(__shuffleButton, {y:21, alpha:.2, buttonMode:true});
			addChild(__shuffleButton);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__ticket.width = __width - 35;
			__repeatButton.x = __width - 20;
			__shuffleButton.x = __repeatButton.x + 1;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function buttonHandler (e:MouseEvent):void
		{
			switch (e.currentTarget) {
				case __repeatButton:
					toggleRepeat();
					dispatchEvent(new JukeBoxEvent(JukeBoxEvent.JUKE_BOX_REPEAT, {repeat:__repeatEnabled}));
					break;
				default:
					toggleShuffle();
					Global.shuffle = __shuffleEnabled;
					dispatchEvent(new JukeBoxEvent(JukeBoxEvent.JUKE_BOX_SHUFFLE, {shuffle:__shuffleEnabled}));
			}
		}
		
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function toggleRepeat ():void
		{
			__repeatEnabled = !__repeatEnabled;
			TweenMax.to(__repeatButton, .5, {alpha:(__repeatEnabled) ? 1 : .2});
		}
		private function toggleShuffle ():void
		{
			__shuffleEnabled = !__shuffleEnabled;
			TweenMax.to(__shuffleButton, .5, {alpha:(__shuffleEnabled) ? 1 : .2});
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get ticket ():Ticket
		{
			return __ticket;
		}
	}
}