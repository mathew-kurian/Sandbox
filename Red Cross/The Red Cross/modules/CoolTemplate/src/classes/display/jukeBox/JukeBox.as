/*
JukeBox.as
JukeBox

Created by Alexander Ruiz Ponce on 23/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenMax;
	import gT.display.components.GenericComponent;
	
	import classes.Global;
	
	public class JukeBox extends GenericComponent {
		
		private var __player:Player;
		private var __playList:PlayList;
		private var __cdBin:CDBin;
		private var __padding:uint = 11;
		private var __offsetY:uint = 30;
		
		public function JukeBox () 
		{
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
			
			__player.addEventListener(JukeBoxEvent.PLAYER_BUTTON_CLICKED, playerHandler, false, 0, true);
			__player.addEventListener(JukeBoxEvent.JUKE_BOX_SOUND_COMPLETE, onSoundComplete, false, 0, true);
			__playList.addEventListener(JukeBoxEvent.ITEM_LIST_CLICKED, playListHandler, false, 0, true);
			//__playList.list.next();
			
			__cdBin.addEventListener(JukeBoxEvent.CD_BIN_CLICKED, cdHandler, false, 0, true);
		}
		
		override protected function addChildren():void
		{
			// Player
			__player = new Player;
			addChild(__player);
			__player.width = 255;
			__player.height = 49;
			__player.y = - __player.height - __offsetY;
			
			// The play list
			__playList = new PlayList();
			__playList.y = __player.y + __player.height + __padding;
			__playList.width = 255;
			__playList.height = 150;
			__playList.visible = false;
			__playList.alpha = 0;
			addChild(__playList);
			
			// The CDBin
			__cdBin = new CDBin;
			__cdBin.x = 4;
			__cdBin.y = __player.y - __padding - __cdBin.height;
			addChild(__cdBin);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		public function togglePlayList ():void
		{
			Global.playListEnabled = !Global.playListEnabled;
			
			if (Global.playListEnabled) {
				TweenMax.to(__player, Global.settings.time, {y:-(__player.height + __playList.height + __padding * 2), ease:Global.settings.easeInOut, onUpdate:update});
				TweenMax.to(__playList, Global.settings.time, {autoAlpha:1});
			} else {
				TweenMax.to(__player, Global.settings.time, {y:-(__player.height + __offsetY), ease:Global.settings.easeInOut, onUpdate:update});
				TweenMax.to(__playList, Global.settings.time, {autoAlpha:0});
			}
			
			function update () 
			{
				__playList.y = __player.y + __player.height + __padding;
				__cdBin.y = __player.y - __padding - __cdBin.height;
			}
		}
		
		public function togglePause ():void
		{
			__player.togglePause();
		}
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function playListHandler (e:JukeBoxEvent):void
		{
			__player.play(e.params.trackInfo);
		}
		
		private function playerHandler (e:JukeBoxEvent):void
		{
			switch (e.params.id) 
			{
				case "playList":
					togglePlayList();
					break;
				case "next":
					__cdBin.change();
					__playList.list.next();
					break;
				case "back":
					__cdBin.change();
					__playList.list.back();
					break;
				case "play":
					if(!__playList.autoPlay){
						__playList.autoPlay = true;
						__cdBin.change();
						__playList.list.next();
					}
					
					break;
				case "pause":
					//<#statements#>
					break;

			}
		}
		
		private function cdHandler (e:JukeBoxEvent):void
		{
			// Next when cdbin was clicked
			__playList.list.next();
		}
		
		private function onSoundComplete (e:JukeBoxEvent):void
		{
			__cdBin.change();
			__playList.list.next();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set data (value:Array):void
		{
			__playList.data = value;
			__cdBin.change();
			dispatchEvent(new JukeBoxEvent(JukeBoxEvent.JUKE_BOX_PLAY_LIST_CHANGED));
		}
		
		public function set autoPlay (value:Boolean):void
		{
			__playList.autoPlay = value;
		}
		
		public function get player():Player{
			return __player;
		}
	}
}