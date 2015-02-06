/*
NewsReel.as
CoolTemplate

Created by Carlos Vergara on 21/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;
	import gT.utils.ObjectUtils;
	import classes.controls.ArrowNews;
	import gT.display.Draw;
	
	import classes.Global;
	import classes.CustomEvent;

	
	import gs.TweenMax;
	
	public class NewsReel extends GenericComponent {
		
		private var __data:Array;
		private var __current:NewsItems;
		private var __oldNews:NewsItems;
		private var __p:uint;
		private var __leftArrow:ArrowNews;
		private var __rightArrow:ArrowNews;
		private var __newsMask:Sprite;
		private var __holderNews:Sprite;
		
		
		public function NewsReel (data:Array) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function addChildren():void
		{
			__holderNews = new Sprite;
			addChild(__holderNews);
			createArrows();
			createNewsItems();
			
			__newsMask = Draw.rectangle();
			addChild(__newsMask);
			__holderNews.mask = __newsMask;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (__current)
			{
				__current.width = __width;
				__current.height = __height;
			}
			
			__leftArrow.x = -__leftArrow.width - 10;
			__rightArrow.x = __width + 10;
			
			__newsMask.width = __width;
			__newsMask.height = __height;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function arrowHandler(e:CustomEvent){
			
			if(e.params.id == "left"){
				if(__p > 0){
					
					
					mouseChildren = false;
					__p--;
					__oldNews = __current;
					createNewsItems();
					__current.x = -__oldNews.width;
					draw();
					
					TweenMax.to(__current, Global.settings.time/2, {x:0, ease:Global.settings.easeInOut});
					TweenMax.to(__oldNews, Global.settings.time/2, {x:__oldNews.width, ease:Global.settings.easeInOut, onComplete:function(){
								__holderNews.removeChild(__oldNews);
								__oldNews = null;
								mouseChildren = true;
								}});
					
					if((__p*2 < Math.ceil(__data.length/2)) && __rightArrow.visible == false){
						__rightArrow.visible = true;
						__rightArrow.alpha = 0;
						TweenMax.to(__rightArrow, Global.settings.time/2,{alpha:1});
					}
					
					if(__p == 0){
						TweenMax.to(__leftArrow, Global.settings.time/2,{autoAlpha:0});
					}
					
				}
			}else{
				if(__p*2 < Math.ceil(__data.length/2)){
					mouseChildren = false;
					__p++;
					
					__oldNews = __current;
					createNewsItems();
					__current.x = __oldNews.width;
					draw();
					
					TweenMax.to(__current, Global.settings.time/2, {x:0, ease:Global.settings.easeInOut});
					TweenMax.to(__oldNews, Global.settings.time/2, {x:-__oldNews.width, ease:Global.settings.easeInOut, onComplete:function(){
								__holderNews.removeChild(__oldNews);
								__oldNews = null;
								mouseChildren = true;
					}});
					
					if(__p > 0 && __leftArrow.visible == false){
						__leftArrow.visible = true;
						__leftArrow.alpha = 0;
						TweenMax.to(__leftArrow, Global.settings.time/2,{alpha:1});
					}
					
					if(__p*2 == Math.ceil(__data.length/2)){
						TweenMax.to(__rightArrow, Global.settings.time/2,{autoAlpha:0});
					}
				}
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createNewsItems ():void
		{
			// __p = 0;
			var pi:uint = __p * 2;
			var array:Array = [];
			
			array.push({textBlocks:__data[pi].textBlocks, id:pi});
			
			if (__data[pi+1]) {
				array.push({textBlocks:__data[pi+1].textBlocks, id:pi+1});
			}
			
			__current = new NewsItems(array);
			__holderNews.addChild(__current);
		}
		
		private function createArrows():void{
			__leftArrow = new ArrowNews("left");
			__leftArrow.addEventListener(CustomEvent.ARROW_CLICKED, arrowHandler, false, 0, true);
			__leftArrow.visible = false;
			__leftArrow.y = 3;
			addChild(__leftArrow);
			
			__rightArrow = new ArrowNews("right");
			__rightArrow.addEventListener(CustomEvent.ARROW_CLICKED, arrowHandler, false, 0, true);
			__rightArrow.y = 3;
			addChild(__rightArrow);
			
			if(__data.length/2 <= 1){
				__rightArrow.visible = false;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function get data():Array{
			return __data;
		}
	}
}


import flash.display.Sprite;
import classes.Global;
import classes.display.Block;
import gT.display.components.GenericComponent;
import gT.utils.ObjectUtils;
import gT.utils.ArrayUtils;

internal class NewsItems extends GenericComponent
{
	private var __data:Array;
	private var __elements:Array = [];
	
	public function NewsItems (data:Array)
	{
		__data = ArrayUtils.clone(data);

		super();
	}
	
	override protected function addChildren ():void
	{
		var maxChars = 430;
		var dots:String = " ...";
		
	//	ObjectUtils.traceObject(__data);
	//	return;
		
		for(var i in __data) 
		{
			__data[i].textBlocks[0].thumbnail = null;
			
			if (__data[i].textBlocks[0].subtitle.length > maxChars)
			{
				__data[i].textBlocks[0].subtitle = __data[i].textBlocks[0].subtitle.subString(0, maxChars)+dots;
			} else if ((__data[i].textBlocks[0].subtitle.length + __data[i].textBlocks[0].content.length) > maxChars) {
				__data[i].textBlocks[0].content = String(__data[i].textBlocks[0].content).substr(0, maxChars-__data[i].textBlocks[0].subtitle.length)+dots;
			}
			
			var texts:Block = new Block("TextBlockAsset", [__data[i].textBlocks[0]], null, true);
			texts.name = String(__data[i].id);
			texts.spaceAfterTitle = 16;
			texts.spaceAfterSubtitle = 15;
			texts.spaceAfterParagraph = 30;
			__elements.push(texts);
			addChild(texts);
		}
	}
	
	override public function draw ():void
	{
		
		for(var i in __elements) 
		{
			var texts = __elements[i];
			
			texts.width = (__width / 2) - 20;
			texts.height = __height;
			
			if (i) {
				texts.x = (__elements[i-1].x + __elements[i-1].width + 20) * i;
			}
		}
	}
}