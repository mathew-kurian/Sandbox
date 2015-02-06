/*
NewsTemplate.as
CoolTemplate

Created by Carlos Vergara on 21/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.templates
{	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gT.display.MenuItem;
	import gT.display.Draw;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.controls.MonthsMenu;
	import classes.display.NewsReel;
	import classes.display.NewsDisplayer;
	import gs.TweenMax;
	
	public class NewsTemplate extends Template {
		
		private var __data:Object;
		private var __menu:MonthsMenu;
		private var __reel:NewsReel;
		private var __newsDisplay:NewsDisplayer;
		private var __mask:Sprite;
		
		public function NewsTemplate (data:Object) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		 override protected function init ():void
		 {
		 }
		 
		 override protected function onStage():void
		 {
		 }
		 */
		
		override protected function addChildren():void
		{
			super.addChildren();
			// Menu
			__menu = new MonthsMenu();
			__menu.source = __data.months;
			__menu.addEventListener(MenuItem.MENU_ITEM_CLICKED, menuHandler);
			__menu.y = -43;
			__holder.addChild(__menu);
			__menu.click(0);
			// Title
			__title.text = __data.title;
			
			__mask = Draw.rectangle();
			addChild(__mask);
			mask = __mask;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			__menu.x = __contentWidth - __menu.width;
			
			if (__reel) {
				__reel.width = __contentWidth;
				__reel.height = __contentHeight;
			}
			
			if (__newsDisplay) {
				__newsDisplay.width = __contentWidth;
				__newsDisplay.height = __contentHeight;
			}
			
			if(__mask){
				__mask.width = __width;
				__mask.height = __height;
			}
		}
		
		override protected function destroy ():void
		{
			if (__newsDisplay) {
				__newsDisplay.destroy();
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function menuHandler (e:Event):void
		{
			var index = e.target.index;
			if(!__reel){
				createReel(getNews(index));
				draw();
			}else{
				TweenMax.to(__reel, Global.settings.time/2,{alpha:0, onComplete:function(){
					__holder.removeChild(__reel);
					__reel = null;
					createReel(getNews(index),true);
					draw();
				}});
			}
			
		}
		
		private function reelHandler(e:CustomEvent):void{
			lock();
			
			__newsDisplay = new NewsDisplayer(__reel.data[e.params.id]);
			__newsDisplay.addEventListener(CustomEvent.BACK_BUTTON_CLICKED, newsDisplayHandler, false, 0, true);
			__holder.addChild(__newsDisplay);
			draw();
			
			__newsDisplay.x = __width;
			
			TweenMax.to(__menu, Global.settings.time, {x:"-100", autoAlpha:0, ease:Global.settings.easeInOut});
			TweenMax.to(__newsDisplay, Global.settings.time, {x:0, ease:Global.settings.easeInOut});
			TweenMax.to(__reel, Global.settings.time, {x:-__width, ease:Global.settings.easeInOut, onComplete:lock, onCompleteParams:[false]});		
		}
		
		private function newsDisplayHandler(e:CustomEvent):void{
			lock();
			TweenMax.to(__menu, Global.settings.time, {x:"100", autoAlpha:1, ease:Global.settings.easeInOut});
			TweenMax.to(__reel, Global.settings.time, {x:0, ease:Global.settings.easeInOut});
			TweenMax.to(__newsDisplay, Global.settings.time, {x:__width, ease:Global.settings.easeInOut, onComplete:function(){
				__holder.removeChild(__newsDisplay);
				__newsDisplay = null;
				lock(false);
			}});
		}
		
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createReel(data:Array, on:Boolean = false):void{
			__reel = new NewsReel(data);
			__reel.addEventListener(CustomEvent.VIEW_MORE, reelHandler, false, 0, true);
			__holder.addChild(__reel);
			
			if(on){
				__reel.alpha = 0;
				TweenMax.to(__reel, Global.settings.time/2, {alpha:1});
			}
		}
		
		private function lock(sw:Boolean = true):void{
			mouseEnabled = !sw;
			mouseChildren = !sw;
		}
		private function getNews (index:uint):Array
		{
			var result:Array;
			
			for each (var news in __data.news)
			{
				if (news.year == __data.date[index].year && news.month == __data.date[index].month) {
					if (!result) result = [];
					result.push(news);
				}
			};
			
			return result;
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}