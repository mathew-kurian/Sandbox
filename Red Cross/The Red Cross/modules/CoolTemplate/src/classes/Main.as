/*
Main
CoolTemplate

Created by Alexander Ruiz on 02/11/09.
Copyright 2009 goTo! Multiemdia. All rights reserved.
*/
package classes {
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLRequestHeader;
	import flash.net.navigateToURL;
	
	import classes.display.*;
	import classes.controls.*;
	import classes.display.jukeBox.JukeBoxEvent;
	import classes.display.circularGallery.*;
	import classes.templates.*;
	
	import gT.display.components.GenericComponent;
	import gT.display.MenuItem;
	import gs.TweenMax;
	
	//import net.hires.debug.Stats;
	
	public class Main extends MovieClip {

		private var __launcher:*;
		private var __logo:Bitmap;
		private var __background:Background;
		private var __menu:MainMenu;
		private var __jukeBox:JukeBoxSpectrum;
		private var __circularGalleryManager:CircularGalleryManager;
		private var __circularGallery:CircularGallery;
		private var __fullView:FullView;
		private var __info:GenericComponent;
		private var __templateManager:TemplateManager;
		private var __disclaimer:MovieClip;
		private var __toolBar:ToolBar;
		
		public function Main () {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Settings Stage
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
			stage.addEventListener(Event.RESIZE, resize, false, 0, true);
			
			if(Global.PROTECTED){
				if(!checkLegalAccess()){
					showDisclaimer();
					return;
				}
			}
			
			loadContent();
		}
		
		private function checkLegalAccess():Boolean
		{
			var url:String = loaderInfo.url;
			var pattern:RegExp = new RegExp(Global.SECURITY_DOMAINS, "g");			
			return (url.match(pattern).length > 0);
		}
		
		private function showDisclaimer()
		{
			__disclaimer = new Disclaimer;
			addChild(__disclaimer);
			
			TweenMax.from(__disclaimer, Global.settings.time, {alpha:0});
			resize();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		private function parseXML (e:Event):void
		{
			Global.setData(XML(e.currentTarget.data));
			contentReady();
		}
		
		private function createInterfaz (e:Event):void
		{
			// Main render to update display List for each object
			addEventListener(Event.ENTER_FRAME, render);
			
			
			// Logo
			__logo = e.currentTarget.content;
			__logo.y = 50;
			
			// Clear preload objects
			launcherOff();
			
			// Create background
			
			__background = new Background;
			addChild(__background);
			addChild(__logo);
						
			resize();
			
			TweenMax.from(__logo, Global.settings.time, {x:String(-(__logo.width + __logo.x)), ease:Global.settings.easeOut, delay:Global.settings.time, onStart:onLogoStar});
			
			// 
			function onLogoStar () {
				// CreateMenu
				createMainMenu();
				
				// Create tool bar
				createToolBar();
				
				// Stats
				// addChild(new Stats);
				
				// JukeBox
				if (Global.settings.jukeBox) {
					TweenMax.delayedCall(1, createJukeBox);
				}
				
				// CircularGallery
				if (Global.settings.showCircularGallery) {
					createCircularGallery();
				}
				
				// info
				createInfo();
				
				// Resize all elements
				resize();
			}
		}
		
		private function jukeBoxHandler (e:JukeBoxEvent):void
		{
			e.stopImmediatePropagation();
			var pos;
			
			if (stage.stageHeight <= Global.MIN_STAGE_HEIGHT)
			{
				
				if (Global.playListEnabled) {
					pos = (stage.stageHeight / 2+ __circularGallery.radius) + Global.MAX_OFFSET_Y_CIRCULAR_GALLERY;
				} else {
					pos = (stage.stageHeight / 2+ __circularGallery.radius) + Global.OFFSET_Y_CIRCULAR_GALLERY;
				}
				
				TweenMax.to(__circularGallery, Global.settings.time, {y:pos, ease:Global.settings.easeInOut});
			}
			__circularGalleryManager.closeContent();
		}
		
		private function changePlayList (e:CustomEvent):void
		{
			if (e.params.playList) {
				__jukeBox.autoPlay = true;
				__jukeBox.data = e.params.playList;
			}
		}
		
		private function circularGalleryManagerHandler (e:CustomEvent):void
		{
			if (e.params.target.contentType != "externalLink")
			{
				switch (e.type) {
					case CustomEvent.CIRCULAR_GALLERY_ITEM_CLICKED:
						Global.currentSection = e.params.index;
						Global.currentSubSection = NaN;
						__menu.click(Global.currentSection, false);
						break;
					case CustomEvent.CIRCULAR_GALLERY_SUB_ITEM_CLICKED:
						//keep this in mind
						Global.currentSubSection = e.params.index - (Global.currentSection + 1);
						break;
				}
			}
		}
		
		private function circularGalleryHandler (e:CustomEvent):void
		{
			switch (e.type) 
			{
				case CustomEvent.CIRCULAR_GALLERY_SLIDE_START:
					stage.mouseChildren = false;
					break;
					
				case CustomEvent.CIRCULAR_GALLERY_OPEN_COMPLETE:
					stage.mouseChildren = true;
					break;
					
				case CustomEvent.CIRCULAR_GALLERY_OPEN_START:
					__circularGalleryManager.addSubItems(Global.circularGallerySubItems);
					break;
	
				case CustomEvent.CIRCULAR_GALLERY_OPEN_CONTENT_START:
					__templateManager.createTemplate();
					
					if (__jukeBox && Global.playListEnabled) {
						__jukeBox.jukeBox.togglePlayList();
						TweenMax.to(__circularGallery, Global.settings.time, {y:(stage.stageHeight / 2+ __circularGallery.radius) + Global.OFFSET_Y_CIRCULAR_GALLERY, ease:Global.settings.easeInOut});
					}
					
					break;
					
				case CustomEvent.CIRCULAR_GALLERY_CLOSE_START:
					__templateManager.off();
					break;
					
				case CustomEvent.CIRCULAR_GALLERY_ITEM_CLOSED:
					Global.currentSubSection = NaN;
					if (!e.params.isSubItem) {
						__menu.unClick();
					}
					break;
			}
		}
		
		private function menuHandler (e:Event):void
		{
			// Check
			var targetIndex = e.target.index;
			var item = __circularGallery.mainItems[targetIndex];
			
			if (item.contentType == "externalLink") 
			{
				if(__circularGallery.open){
					__circularGalleryManager.click(Global.currentSection);
				}
				navigateToURL(new URLRequest(item.data.link.href), item.data.link.target);
				__menu.unClick();
				return;
			}
			
			Global.currentSection = targetIndex;
			Global.currentSubSection = NaN;
			__circularGalleryManager.click(Global.currentSection);
			stage.mouseChildren = false;
		}
		
		private function createFullView (e:CustomEvent):void
		{
			e.stopImmediatePropagation();
			__fullView = new FullView(e.params.image, e.params.index, Global.fullViewContent);
			__fullView.addEventListener(CustomEvent.FULL_VIEW_CLOSE, removeFullView, false, 0, true);
			
			if (Global.settings.jukeBox) {
				__fullView.addEventListener(CustomEvent.FULL_VIEW_SHOW_VIDEO, stopJukeBox, false, 0, true);
				__fullView.addEventListener(CustomEvent.FULL_VIEW_HIDE_VIDEO, playJukeBox, false, 0, true);
			}
			
			stage.addChild(__fullView);
		}
		
		private function removeFullView (e:CustomEvent):void
		{
			__fullView.destroy();
			stage.removeChild(__fullView);
			__fullView = null;
			//__circularGallery.mouseChildren = true;
		}
		
		private function expanderHandler (e:CustomEvent):void
		{
			//__circularGallery.mouseChildren = false;
		}
		
		private function stopJukeBox (e:CustomEvent):void
		{
			__jukeBox.jukeBox.player.pauseFade();
		}
		
		private function playJukeBox (e:CustomEvent):void
		{
			__jukeBox.jukeBox.player.playFade();
		}
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function loadContent ():void
		{
			// Load content file without cache
			var loader:URLLoader = new URLLoader();
			var request = new URLRequest("data/content.xml");
			var header:URLRequestHeader = new URLRequestHeader("no-cache");
			request.requestHeaders.push(header);
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, parseXML, false, 0, true);
		}
		
		private function contentReady ():void
		{
			var loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, createInterfaz);
			loader.load(new URLRequest(Global.settings.logo));
		}
		
		private function launcherOff ():void
		{
			try {
				__launcher.off();
			} catch (e:Error) {}
		}
		
		private function createMainMenu ():void
		{
			__menu = new MainMenu();
			__menu.source = Global.mainMenu;
			__menu.addEventListener(MenuItem.MENU_ITEM_CLICKED, menuHandler);
			__menu.y = 50;
			addChild(__menu);
		}
		
		private function createToolBar ():void
		{
			__toolBar = new ToolBar;
			__toolBar.y = 20;
			addChild(__toolBar);
		}
		
		private function createJukeBox ():void
		{
			Global.addEventListener(CustomEvent.DROP_DISC, changePlayList, false, 0, true);
			Global.addEventListener(CustomEvent.CHANGE_PLAY_LIST, changePlayList, false, 0, true);
			
			__jukeBox = new JukeBoxSpectrum;
			__jukeBox.addEventListener(JukeBoxEvent.PLAYER_BUTTON_CLICKED, jukeBoxHandler, false, 0, true);
			__jukeBox.autoPlay = Global.settings.jukeBoxAutoPlay;
			__jukeBox.data = Global.defaultPlayList;
			
			addChild(__jukeBox);
			
			resize();
			
			TweenMax.from(__jukeBox, Global.settings.time, {y:stage.stageHeight + 300, ease:Global.settings.easeOut});
			
			// Swap circular gallery
			addChild(__circularGallery);
			addChild(__info);
		}
		
		private function createCircularGallery ():void
		{
			__circularGalleryManager = new CircularGalleryManager;
			__circularGalleryManager.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_CLICKED, circularGalleryManagerHandler, false, 0, true);
			__circularGalleryManager.addEventListener(CustomEvent.CIRCULAR_GALLERY_SUB_ITEM_CLICKED, circularGalleryManagerHandler, false, 0, true);

			__circularGalleryManager.addMainItems(Global.circularGalleryMainItems);
			__circularGallery = __circularGalleryManager.gallery;
			
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_BIG_SOURCE_LOAD_COMPLETE, createFullView, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_OPEN_CONTENT_START, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_OPEN_START, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_OPEN_COMPLETE, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_CLOSE_START, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_CLOSED, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_SLIDE_START, circularGalleryHandler, false, 0, true);
			__circularGallery.addEventListener(CustomEvent.EXPANDER_CLICKED, expanderHandler, false, 0, true);
			
			addChild(__circularGallery);
		}
		
		private function createInfo ():void
		{
			__info = new GenericComponent;
			__info.width = Global.CONTENT_WIDTH;
			/*
			__info.height = Global.CONTENT_HEIGHT;
			 */
			addChild(__info);
			
			__templateManager = new TemplateManager(__info);
		}
		
		private function resize (e:Event = null):void
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			
			if (__background)
			{
				__background.width = w;
				__background.height = h;
			}
			
			if(__logo){
				__logo.x = 50;
			}
			
			if (__menu) {
				__menu.x = w - __menu.width - 50;
			}
			
			if (__toolBar) {
				__toolBar.x = w - __toolBar.width - 55;
			}
			
			if (__jukeBox) {
				__jukeBox.y = h;
				__jukeBox.width = w;
			}
			
			if (__circularGallery) {
				var pos:Number;
				
				// If there is jukeBox
				if (Global.settings.jukeBox) {
					
					if (stage.stageHeight <= Global.MIN_STAGE_HEIGHT)
					{
						if (Global.playListEnabled) {
							pos = (h / 2+ __circularGallery.radius) + Global.MAX_OFFSET_Y_CIRCULAR_GALLERY;
						} else {
							pos = (h / 2+ __circularGallery.radius) + Global.OFFSET_Y_CIRCULAR_GALLERY;
						}
					} else {
						pos = (h / 2+ __circularGallery.radius) + Global.OFFSET_Y_CIRCULAR_GALLERY;
					}
					
				} else {

					pos = (h / 2+ __circularGallery.radius) + 130;
				}
				
				__circularGallery.x = w/2;
				__circularGallery.y = pos;
			}
			
			if (__info) {
				
				if (stage.stageHeight <= Global.MIN_STAGE_HEIGHT)
				{
					__info.height = Global.CONTENT_HEIGHT - 90;
				} else {
					__info.height = Global.CONTENT_HEIGHT;
				}
				
				__info.x = (w - __info.width) / 2;
				__info.y = (h - __info.height) / 2;
			}
			
			if(__disclaimer){
				__disclaimer.x = Math.round((w - __disclaimer.width) / 2);
				__disclaimer.y = Math.round((h - __disclaimer.height) / 2);
			}
		}
		
		public function set launcher (value:*):void
		{
			__launcher = value;
		}
		
		private function render (e:Event):void
		{
			Global.render();
		}
	}
}