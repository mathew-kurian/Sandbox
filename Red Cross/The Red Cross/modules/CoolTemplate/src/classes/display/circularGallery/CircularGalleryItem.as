/*
 CircularGalleryItem.as
 CoolTemplate
 
 Created by Alexander Ruiz Ponce on 29/10/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.display.circularGallery
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.motion.easing.Back;
		
	import gs.plugins.TweenPlugin;
	import gs.plugins.TransformAroundCenterPlugin;
	import gs.TweenMax;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.display.ImageView;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.ObjectUtils;
	
	import classes.display.coolFrame.*;
	import classes.display.Expander;
	import classes.Global;
	import classes.CustomEvent;
	
	public class CircularGalleryItem extends GenericComponent {
		
		private var __loader:Loader;
		private var __src:String;
		private var __id:uint; 
		private var __angle:Number;
		private var __currentAngle:Number;
		private var __rot:Number;
		private var __contentType:String;
		private var __holder:Sprite;
		
		private var __cover:Bitmap;
		private var __clonCover:Bitmap;
		private var __realCover:*;
		private var __ghost:Bitmap;
		private var __data:Object;
		private var __expander:Expander;
		private var __imageView:ImageView;
		private var __dropHolder:Sprite = new Sprite;
		
		private var __initPoint:Point = new Point;
		private var __endPoint:Point = new Point;
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public function CircularGalleryItem (data:Object) {
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			
			__data = data;
			__src = data.src;
			__contentType = data.contentType;
			
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init():void
		{
			//setSize(200, 200);
			super.init();
			
		}
		
		override protected function onComponentReady():void
		{
			//TweenMax.from(__ghost, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut});
		}
		
		override protected function addChildren():void
		{
			//mainHolder
			__holder = new Sprite;
			addChild(__holder);
			
			// rect
			// __holder.addChild(Draw.rectangle(230, 230, 0xff0000, .5));
			
			// Ghost
			var ghostCover = new GhostCover();
			__ghost = ghostCover.snapShot;
			__holder.addChild(__ghost);
			
			__ghost.width = 230;
			__ghost.scaleY = __ghost.scaleX;
			__ghost.y = Math.round((230 - __ghost.height) / 2);
			TweenMax.from(__ghost, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw():void
		{
			__width = 230;
			__height = 230;
			
			__ghost.width = __width;
			__ghost.scaleY = __ghost.scaleX;
			__ghost.y = Math.round((__height - __ghost.height) / 2);
			
			if (__cover) {
				__cover.width = __width;
				__cover.scaleY = __cover.scaleX;
				__cover.y = Math.round((__height - __cover.height) / 2);
				
				if (__expander) {
					__expander.x = (__width - __expander.width) / 2;
					__expander.y = (__height - __expander.height) / 2;
				}
			}
			
			__holder.x = -Math.round(__width / 2);
			__holder.y = -__height;
		}
		
		public function load(){
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler, false, 0, true);
			__loader.load(new URLRequest(__src));
		}
		
		public function off ():void
		{
			closeLoader();
			
			TweenMax.killTweensOf(__ghost);
			TweenMax.killTweensOf(__cover);
			
			if (__ghost) {
				TweenMax.to(__ghost, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut, onComplete:onComplete});
			}
		
			if (__cover) {
				TweenMax.to(__cover, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut, onComplete:onComplete});
			}
			
			var success:Boolean;
			function onComplete ()
			{
				if (!success) {
					success = true;
					dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_ITEM_OFF));
				}	
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Event Handler
		//
		//////////////////////////////////////////////////////////
		
		private function loaderHandler(e:Event) {
			
			__realCover = getCover(e.target.content);
			__cover = __realCover.snapShot;
			__holder.addChild(__cover);
			
			__expander = new Expander;
			__holder.addChild(__expander);
			addEventListener(MouseEvent.ROLL_OVER, expanderMouseHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, expanderMouseHandler, false, 0, true);
			
			switch (__data.contentType) {
				case "video":
					__expander.showIcon("play");
					__expander.addEventListener(MouseEvent.CLICK, expanderMouseHandler, false, 0, true);
					break;
				
				case "image":
					__expander.showIcon("maximize");
					__expander.addEventListener(MouseEvent.CLICK, expanderMouseHandler, false, 0, true);	
					break;
					
				case "music":
					__expander.showIcon("music");
					if (Global.settings.jukeBox) {
						__expander.addEventListener(MouseEvent.MOUSE_DOWN, beginStarDrag, false, 0, true);
					}
					break;
				
				case "externalLink":
					addEventListener(MouseEvent.MOUSE_DOWN, savePoint, false, 0, true);
					addEventListener(MouseEvent.CLICK, openLink, false, 0, true);
					__expander.showIcon("link");
					break;
					
				default :
					__expander.showIcon("expand");
					break;
			}
			
						
			draw();
			
			TweenMax.to(__ghost, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut, onComplete:onGhostComplete});
			TweenMax.from(__cover, Global.settings.time, {alpha:0, transformAroundCenter:{scale:0}, ease:Global.settings.easeInOut});
		
			function onGhostComplete () 
			{
				__holder.removeChild(__ghost);
				__ghost = null;
			}
			
			dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_ITEM_LOAD_COMPLETE));
		}
		
		private function expanderMouseHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					__expander.show();
					break;
				case MouseEvent.ROLL_OUT:
					__expander.hide();
					break;
				case MouseEvent.CLICK:
					e.stopImmediatePropagation();
					Global.expanderClicked = true;
					
					// Destroy ImageView
					if (__imageView) {
						
						if (__holder.contains(__imageView)) {
							__holder.removeChild(__imageView);
						}
						__imageView.removeEventListener(ImageView.LOAD_COMPLETE, onImageViewComplete);
						__imageView = null;
					}
					
					// Create ImageView
					__imageView = new ImageView(false);
					__imageView.addEventListener(ImageView.LOAD_COMPLETE, onImageViewComplete, false, 0, true);
					__imageView.source = __data.lgSource;
					__expander.showIcon("spinner");
					
					dispatchEvent(new CustomEvent(CustomEvent.EXPANDER_CLICKED, null, true));
					break;
			}
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
						ObjectUtils.traceObject(__data.playList);
						Global.dispatchEvent(new CustomEvent(CustomEvent.DROP_DISC, {playList:__data.playList}));
					} else {
						
						var endPos = __cover.globalToLocal(new Point(0,0));
						
						TweenMax.to(__dropHolder, Global.settings.time / 2, {alpha:0, ease:Global.settings.easeOut, onComplete:onDropTweenComplete});
						ObjectUtils.traceObject(__data.playList);
						Global.dispatchEvent(new CustomEvent(CustomEvent.DROP_DISC, {playList:null}));
					}
					
					
					break;
			}
		}
		
		private function onDropTweenComplete () {
			__dropHolder.removeChild(__clonCover);
			stage.removeChild(__dropHolder);
			__clonCover = null;
		}
		
		private function render (e:CustomEvent):void
		{
			__dropHolder.x = stage.mouseX;
			__dropHolder.y = stage.mouseY;
		}
		
		private function toogleExpandIcon (e:MouseEvent):void
		{
			if (__expander.actualIcon == "expand") {
				__expander.showIcon("unexpand");
			} else {
				__expander.showIcon("expand");
			}
		}
		
		private function closeLoader ():void
		{
			if (__loader) {
				try {
					__loader.close();
				} catch (e) {}
				
				__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderHandler);
				__loader = null;
			}
		}
		
		private function openLink (e:MouseEvent):void
		{
			__endPoint.x = stage.mouseX;
			__endPoint.y = stage.mouseY;
			
			if (__endPoint.equals(__initPoint)) 
			{
				navigateToURL(new URLRequest(__data.link.href), __data.link.target);
			}
		}
		
		private function savePoint (e:MouseEvent):void
		{
			__initPoint.x = stage.mouseX;
			__initPoint.y = stage.mouseY;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function getCover (bmp:Bitmap):*
		{
			var cover:*;
			
			switch (__data.cover.type) {
				case "menuCover":
					cover = new MenuCover(bmp, __data.cover.label, Global.settings.globalColor1, Global.settings.globalColor2);
					break;
				case "CDCover":
					cover = new CDCover(bmp);
					break;
				case "discCover":
					cover = new DiscCover(bmp);
					break;
				default:
					cover = new Cover(bmp);
					break;
			}
			
			return cover;
		}
		
		private function onImageViewComplete (e:Event):void
		{
			if(__data.contentType != "video"){
				__expander.showIcon("maximize");
			}else{
				__expander.showIcon("play");
			}
			
			__imageView.width = __realCover.bounds.width * __cover.scaleX;
			__imageView.height = __realCover.bounds.height * __cover.scaleY;
			__imageView.rotation = rotation;
			
			DisplayObjectUtils.centerToObject(__imageView, this);
			__imageView.y -= 1;
			
			__holder.addChild(__imageView);
			
			dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_ITEM_BIG_SOURCE_LOAD_COMPLETE, {image:__imageView, index:__data.sourceIndex}, true));
		}
		
		private function cloneCover ():Bitmap
		{
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
		
		public function set id(value:uint)
		{
			__id = value;
		}
		
		public function get id():uint
		{
			return __id;
		}
		
		public function set angle(value:Number)
		{
			__angle = value;
		}
		
		public function get angle():Number
		{
			return __angle;
		}
		
		public function set currentAngle(value:Number)
		{
			__currentAngle = value;
		}
		
		public function get currentAngle():Number
		{
			return __currentAngle;
		}
		
		public function set rot(value:Number)
		{
			__rot = value;
		}
		
		public function get rot():Number
		{
			return __rot;
		}
		
		public function get contentType():String
		{
			return __contentType;
		}
		
		public function get expander ():Expander
		{
			return __expander;
		}
		
		public function get data ():Object
		{
			return __data;
		}
	}
}