/*
Block.as
CoolTemplate

Created by Carlos Andres Viloria Mendoza on 29/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.utils.getDefinitionByName;

	import gs.TweenMax;
	import gT.display.TextBlock;
	import gT.display.components.GenericComponent;
	import gT.display.ImageView;
	import gT.utils.NumberUtils;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.display.coolFrame.Cover;
	
	public class Block extends GenericComponent {
		
		protected var __data:Array;
		protected var __blocks:Array;
		protected var __titleSpace:uint;
		protected var __spaceAfterParagraph:int = 5;
		protected var __spaceAfterTitle:Number = 0;
		protected var __spaceAfterSubtitle:int = 5;
		protected var __textsHolder:Sprite;
		protected var __styles:StyleSheet;
		protected var __link:LittleButton;
		protected var __imageView:ImageView;
		
		protected var __assetID:String;
		protected var BlockAsset:Class;
		protected var __viewMore:Boolean;
		
		protected const COLUMN_WIDTH:uint = 170;
		protected var __rotationImage:uint;
		private var __imageViews:Array;
		/*
		private var	LittleButton:LittleButton;
		//private  var 	image:						ImageViewer;
		//private  var 	randomRotation:				Number = 0;
		*/

		public function Block(_assetID:String, _data:Array, _styles:StyleSheet = null, viewMore:Boolean = false):void{
			cacheAsBitmap = true;
			__assetID = _assetID;
			__styles = _styles;
			__data = _data;
			__blocks = [];
			__viewMore = viewMore;
			
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init():void
		{
			BlockAsset = getDefinitionByName(__assetID) as Class;
			setMinSize(100, 30);
			super.init();
		}
		
		override protected function addChildren():void
		{
			// Texts Holder
			__textsHolder = new Sprite;
			addChild(__textsHolder);
			
			for (var i:uint = 0; i < __data.length; i++) 
			{
				var block = createBlock(__data[i].title, __data[i].subtitle, __data[i].content, __data[i].thumbnail, __data[i].moreLink, i);
				__blocks.push(block);
				__textsHolder.addChild(block);
			}
		}
		
		private function createBlock (titleStr:String, subtitle:String, paragraph:String, image:String, externalLink:Object, index:uint):Object 
		{
			var block = new BlockAsset;
			// Title
			if(titleStr) {
				var title:Label = new Label();
				title.text = titleStr;
				title.name = "title";
				block.addChild(title);
			}
						
			// Subtitle
			if (subtitle) {
				block.subtitle.autoSize = "left";
				block.subtitle.styleSheet = Global.css;
				block.subtitle.htmlText = "<span class='title'>"+subtitle+"</span>";
				block.subtitle.cacheAsBitmap = true;
				block.subtitle.mouseWheelEnabled = false;
			} else {
				block.removeChild(block.subtitle);
				block.paragraph.y = 0;
				block.subtitle = null;
			}
			
			// Paragraph
			if (paragraph) {
				block.paragraph.autoSize = "left";
				block.paragraph.styleSheet = Global.css;
				block.paragraph.htmlText = "<body>"+paragraph+"</body>";
				block.paragraph.cacheAsBitmap = true;
				block.paragraph.mouseWheelEnabled = false;
			} else {
				block.removeChild(block.paragraph);
				block.paragraph = null;
			}
			
			if(externalLink){
				if(__viewMore){
					__link = new LittleButton(new Font_8);	
					__link.addEventListener(MouseEvent.CLICK, linkHandler, false, 0, true);
				}else{
					__link = new LittleButton(new Font_8, externalLink);
				}
				__link.name = "button";
				__link.x = 0;
				block.addChild(__link);	
			}
			
			if (image) {
				var ghost:Bitmap = new Cover(null).snapShot;
				ghost.width = COLUMN_WIDTH;
				ghost.scaleY = ghost.scaleX;
				ghost.name = "ghost";
				ghost.y = -3;
				if (Global.settings.contentThumbnailRandomRotation)	ghost.rotation = NumberUtils.randomInt(-4, 4);
					
				block.addChild(ghost);
				
				
			}
			
			return block;
		}
		
		public function loadImages ():void
		{
			__imageViews = [];
			for (var i in __data)
			{
				if (__data[i].thumbnail) {
					var imageView = new ImageView(false);
					imageView.addEventListener(ImageView.LOAD_COMPLETE, onImageViewComplete, false, 0, true);
					imageView.source = __data[i].thumbnail;
					imageView.name = String(i);
					__imageViews.push(imageView);
				}
			}
		}
		
		public function destroy ():void
		{
			for (var i in __imageViews)
			{
				var imageView = __imageViews[i];
				imageView.removeEventListener(ImageView.LOAD_COMPLETE, onImageViewComplete);
				imageView.destroy();
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Event Handlers
		//
		//////////////////////////////////////////////////////////
		private function linkHandler(e:MouseEvent){
			dispatchEvent(new CustomEvent(CustomEvent.VIEW_MORE, {id:uint(name)}, true));
		}
		
		private function onImageViewComplete (e:Event):void
		{
			var imageView:ImageView = e.currentTarget as ImageView;
			var index = uint(imageView.name);
			
			var cover = new Cover(imageView.image).snapShot;
			cover.width = COLUMN_WIDTH;
			cover.scaleY = cover.scaleX;
			cover.name = "cover";
			
			var b = __blocks[index];
			b.addChild(cover);
			var g = b.getChildByName("ghost");
			cover.rotation = g.rotation;

			TweenMax.to(g, Global.settings.time, {alpha:0});
			TweenMax.from(cover, Global.settings.time, {alpha:0});
			
			draw();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			var i:uint;
			var l:uint = __blocks.length;
			
			for (i ; i < l; i++) {
				var b = __blocks[i];
				var hasTitle = b.getChildByName("title");
				var hasSubtitle = b.subtitle;
				var hasParagraph = b.paragraph;
				var hasImage = b.getChildByName("ghost");
				var hasLittleButton = b.getChildByName("button");
				var hasCover = b.getChildByName("cover");
				
				if (hasSubtitle) {
					b.subtitle.width = __width;
				}
				
				if (hasParagraph) {
					b.paragraph.width = __width;
				}
				
				if (hasImage) {
					
					if (hasSubtitle) {
						b.subtitle.width = __width - COLUMN_WIDTH;
					}
					
					if (hasParagraph) {
						b.paragraph.width = __width - COLUMN_WIDTH;
					}
					
					
					hasImage.x = __width - hasImage.width;
					
					if (hasSubtitle) {
						hasImage.y = b.subtitle.y - 3;
					} else {
						hasImage.y = b.paragraph.y - 3;
					}
					
					if (hasCover) {
						hasCover.x = hasImage.x;
						hasCover.y = hasImage.y;
					}
				}
				 
				if (hasTitle && hasSubtitle && hasParagraph) {
					b.subtitle.y = hasTitle.height + __spaceAfterTitle;
					b.paragraph.y = b.subtitle.y + b.subtitle.height + __spaceAfterSubtitle;
				}
				
				if ((hasTitle && hasParagraph) && !hasSubtitle) {
					b.paragraph.y = hasTitle.height + __spaceAfterTitle;
				}
				
				if (hasSubtitle && hasParagraph && !hasTitle) {
					b.paragraph.y = b.subtitle.y + b.subtitle.height + __spaceAfterSubtitle;
				}
				
				
				if (hasLittleButton) {
					hasLittleButton.x = 0;
					hasLittleButton.y = b.paragraph.y + b.paragraph.height + __spaceAfterParagraph/2;
				}
				
				
				if (i) {
					var a = __blocks[i-1];
					b.y = a.y + a.height + __spaceAfterParagraph;
				}
			}
			
			__height = __textsHolder.height;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters and Getters
		//
		//////////////////////////////////////////////////////////
		
		public function get spaceAfterSubtitle():Number{
			return __spaceAfterSubtitle;
		}
		
		public function set spaceAfterSubtitle(value:Number):void{
			__spaceAfterSubtitle = value;
			draw();
		}
		
		public function set spaceAfterParagraph (value:int):void
		{
			__spaceAfterParagraph = value;
			draw();
		}
		
		public function set spaceAfterTitle (value:int):void
		{
			__spaceAfterTitle = value;
			draw();
		}
		
		public function get spaceAfterTitle ():int
		{
			return __spaceAfterTitle;
		}
		
		public function get blocks ():Array
		{
			return __blocks;
		}
	}
}