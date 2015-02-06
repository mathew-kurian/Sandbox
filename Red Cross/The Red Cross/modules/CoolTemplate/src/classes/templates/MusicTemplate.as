/*
TextTemplate.as
CoolTemplate

Created by Alexander Ruiz Ponce on 20/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.templates
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import fl.motion.easing.Back;
	
	import gT.display.components.GenericComponent;
	import gT.display.ImageView;
	import gT.display.InteractiveBitmap;
	
	import gs.plugins.TweenPlugin;
	import gs.plugins.TransformAroundCenterPlugin;
	import gs.TweenMax;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.display.Block;
	import classes.controls.ScrollPane;
	import classes.display.coolFrame.CDCover;
	import classes.display.coolFrame.DiscCover;
	import classes.display.LittleButton;
	
	public class MusicTemplate extends Template {
		
		private var __data:Object;
		private var __scrollPane:ScrollPane;
		private var __imageView:ImageView;
		private var __cover:InteractiveBitmap;
		private var __ghost:Bitmap;
		private var __playButton:LittleButton;
		private var __clonCover:Bitmap;
		private var __dropHolder:Sprite = new Sprite;
		private var __realCover:*;
		
		private const COLUMN_WIDTH:uint = 170;
		
		public function MusicTemplate (data:Object) {
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
			// Title
			__title.text = __data.title;
			
			// Texts
			var texts:Block = new Block("TextBlockAsset", __data.textBlocks, null);
			texts.spaceAfterTitle = 16;
			texts.spaceAfterSubtitle = 15;
			texts.spaceAfterParagraph = 30;
			
			__scrollPane = new ScrollPane;
			__scrollPane.x = COLUMN_WIDTH;
			__scrollPane.content = texts;
			//__scrollPane.resizeThumb = false;
			__holder.addChild(__scrollPane);
			
			__ghost = new CDCover(null).snapShot;
			__ghost.width = COLUMN_WIDTH - 30;
			__ghost.scaleY = __ghost.scaleX;
			__holder.addChild(__ghost);
			
			if (Global.settings.jukeBox) {
				__playButton = new LittleButton(new Font_8, {label:Global.getString("PLAY_NOW").toUpperCase(), handler:playHandler});
				__playButton.x = 5;
				__playButton.y = __ghost.y + __ghost.height + 10;
				__holder.addChild(__playButton);
			}
		}
		
		override protected function onTemplateOn ():void
		{
			__imageView = new ImageView(false);
			__imageView.addEventListener(ImageView.LOAD_COMPLETE, onImageViewComplete, false, 0, true);
			__imageView.source = __data.cover;
		}
		
		override protected function destroy ():void
		{
			if (__imageView) {
				__imageView.destroy();
				__imageView = null;
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			
			__scrollPane.width = __contentWidth - COLUMN_WIDTH;
			__scrollPane.height = __contentHeight;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function onImageViewComplete (e:Event):void
		{
			__realCover = new CDCover(__imageView.image);
			__cover = new InteractiveBitmap(__realCover.snapShot.bitmapData);
			__cover.width = COLUMN_WIDTH - 30;
			__cover.scaleY = __ghost.scaleX;
			__holder.addChild(__cover);
			
			if (Global.settings.jukeBox) {
				__cover.buttonMode = true;
				__cover.addEventListener(MouseEvent.MOUSE_DOWN, beginStarDrag, false, 0, true);
			}
			
			TweenMax.to(__ghost, Global.settings.time, {alpha:0});
			TweenMax.from(__cover, Global.settings.time, {alpha:0});
		}
		
		private function playHandler ():void
		{
			Global.dispatchEvent(new CustomEvent(CustomEvent.CHANGE_PLAY_LIST, {playList:__data.playList}));
		}
		
		private function beginStarDrag (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					
					__clonCover = cloneCover();
					__clonCover.x = - __clonCover.width / 2;
					__clonCover.y = - __clonCover.height / 2;
					
					__dropHolder.addChild(__clonCover);
					stage.addChild(__dropHolder);
					
					__dropHolder.scaleX = __dropHolder.scaleY = 0;
					TweenMax.to(__dropHolder, Global.settings.time / 2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
					
					Global.addEventListener(CustomEvent.GLOBAL_RENDER, render, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_UP, beginStarDrag, false, 0, true);
					
					Global.dispatchEvent(new CustomEvent(CustomEvent.DRAG_DISC));
					break;
					
				case MouseEvent.MOUSE_UP:
					
					Global.removeEventListener(CustomEvent.GLOBAL_RENDER, render);
					stage.removeEventListener(MouseEvent.MOUSE_UP, beginStarDrag);
					
					
					var object:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
					var rightDropTarget:Boolean = false;
					
					for (var i in object) {
						if (object[i].name == "CDBinHit")
						{
							rightDropTarget = true;
							break;
						}
					}
					
					if (rightDropTarget) {
						TweenMax.to(__dropHolder, Global.settings.time / 2, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn, onComplete:onDropTweenComplete});
						Global.dispatchEvent(new CustomEvent(CustomEvent.DROP_DISC, {playList:__data.playList}));
					} else {
						
						var endPos = __cover.globalToLocal(new Point(0,0));
						
						TweenMax.to(__dropHolder, Global.settings.time / 2, {alpha:0, ease:Global.settings.easeOut, onComplete:onDropTweenComplete});
						Global.dispatchEvent(new CustomEvent(CustomEvent.DROP_DISC, {playList:null}));
					}
					
					
					break;
			}
		}
		
		private function render (e:CustomEvent):void
		{
			__dropHolder.x = stage.mouseX;
			__dropHolder.y = stage.mouseY;
		}
		
		private function onDropTweenComplete () {
			__dropHolder.removeChild(__clonCover);
			stage.removeChild(__dropHolder);
			__clonCover = null;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function cloneCover ():Bitmap
		{
			
			//var clon:Bitmap = new Bitmap(__cover.bitmapData);
			var clon:Bitmap = new DiscCover(__realCover.image).snapShot;
			clon.smoothing = true;
			clon.scaleX = .4;
			clon.scaleY = .4;
			
			return clon;
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}