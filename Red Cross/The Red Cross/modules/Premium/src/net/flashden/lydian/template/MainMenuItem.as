package net.flashden.lydian.template {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	
	import net.flashden.lydian.news.NewsPage;
	import net.flashden.lydian.photogallery.PhotoGallery;
		
	public class MainMenuItem extends MovieClip {
		
		// Indicates whether this menu item is selected or not
		private var _selected:Boolean = false;
		
		// Name of the menu item
		private var _name:String;
		
		// Type of the menu item
		private var _type:String;		
		
		// XML file location
		private var _xml:String;
		
		// A reference to the content
		private var _content:MovieClip;
		
		// Indicates whether the menu item will be displayed in the main menu or not
		private var _showInMainMenu:Boolean;
		
		// The link associated with this menu item
		private var _link:String;
		
		// Holds the target browser window to open the given url
		private var _target:String;
		
		// A glow filter
		private var glow:GlowFilter = new GlowFilter(ConfigManager.MM_SELECTED_MENU_BACKGROUND, 1, 40, 40, .35, BitmapFilterQuality.HIGH);
	
		public function MainMenuItem(name:String, type:String, xml:String = null, link:String = null, showInMainMenu:Boolean = false, target:String = null) {
						
			value.text = name;
			this._name = name.replace(/ /g, "_").toLowerCase();
			this._type = type;
			this._xml = xml;
			this._link = link;
			this._showInMainMenu = showInMainMenu;
			this._target = target;
			
			// Initialize menu item
			init();
			
		}
		
		/**
		 * Initializes the menu item.
		 */
		private function init():void {

			// Set as a button
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			
			// Add necessary event listeners
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
		}
		
		/**
		 * This method is called when the mouse is over the menu item. 
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			if (!_selected) {
				playMouseOverTween();
			}
					
		}
		
		/**
		 * This method is called when the mouse leaves the menu item.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			if (!_selected) {
				playMouseOutTween();
			}
			
		}
		
		/**
		 * Plays mouse over animations.
		 */
		private function playMouseOverTween():void {
			
			Tweener.addTween(background, {scaleX:1.2, scaleY:1.2, time:1, transition:Equations.easeOutQuint});
			Tweener.addTween(background, {_color:ConfigManager.MM_MOUSE_OVER_COLOR, time:.8, transition:Equations.easeNone});
			parent.setChildIndex(this, parent.numChildren - 1);
			hideTextShadow();
			
		}
		
		/**
		 * Plays mouse out animations.
		 */
		private function playMouseOutTween():void {
			
			Tweener.addTween(background, {_color:null, scaleX:1, scaleY:1, time:1.5, transition:Equations.easeOutQuint});
			displayTextShadow();
			
		}
		
		
		/**
		 * Hides text shadow.
		 */
		private function hideTextShadow():void {
			
			var shadow:DropShadowFilter = value.filters[0] as DropShadowFilter;
			shadow.alpha = 0;
			value.filters = [shadow];
			
		}
		
		/**
		 * Displays text shadow.
		 */
		private function displayTextShadow():void {
			
			var shadow:DropShadowFilter = value.filters[0] as DropShadowFilter;
			shadow.alpha = 1;
			value.filters = [shadow];
			
		}
		
		/**
		 * Indicates whether this menu item is selected or not.
		 */
		public function get selected():Boolean {
			
			return _selected;
			
		}
		
		/**
		 * Selects or deselects this menu item.
		 */
		public function set selected(selected:Boolean):void {
						
			this._selected = selected;
			
			if (_selected) {
				Tweener.addTween(background, {_color:ConfigManager.MM_SELECTED_MENU_BACKGROUND, time:1});
				Tweener.addTween(value, {_color:ConfigManager.MM_SELECTED_MENU_TEXT_COLOR, time:0, transition:"linear"});
				background.filters = [glow];
				Tweener.addTween(background, {scaleX:1, scaleY:1, time:.4, transition:Equations.easeInQuint});
				hideTextShadow();
			} else {
				Tweener.addTween(background, {_color:null, time:1});
				Tweener.addTween(value, {_color:null, time:0, transition:"linear"});
				background.filters = [];
				displayTextShadow();
			}	
			
		}
		
		/**
		 * Returns the actual width of the menu item. 
		 */
		public override function get width():Number {
			
			return background.width;
			
		}
		
		/**
		 * Returns the name of the menu item.
		 */
		public override function get name():String {
			
			return _name;
			
		}
		
		/**
		 * Returns the type of the menu item.
		 */	
		public function get type():String {
			
			return _type;
			
		}
		
		/**
		 * Returns the location of the xml file.
		 */
		public function get xml():String {
		
			return _xml;
			
		}
		
		/**
		 * Returns true if the menu will be displayed in the main menu.
		 */
		public function get showInMainMenu():Boolean {
			
			return _showInMainMenu;			
			
		}		
		
		/**
		 * Returns the content related with the menu item.
		 */
		public function get content():MovieClip {
			
			// Get the type of the content and create the appropriate object.
			if (_content == null) {
				if (type == "BannerPage") {
					_content = new BannerPage(xml);
				} else if (type == "PhotoGallery") {
					_content = new PhotoGallery(name, xml);
				} else if (type == "NewsPage") {
					_content = new NewsPage(_name, xml);
				} else if (type == "PortfolioPage") {
					_content = new PortfolioPage(name, xml);
				} else if (type == "StandartPage") {
					_content = new StandartPage(xml);					
				} else if (type == "ContactPage") {
					_content = new ContactPage(xml);
				} else if (type == "SWF") {
					// Create a holder for the swf file
					var request:URLRequest = new URLRequest(_link);
					var loader:Loader = new Loader();
					loader.load(request);
					var contentHolder = new MovieClip();
					contentHolder.addChild(loader);
					_content = contentHolder;
				}
			}
			
			// Add event listeners for the photo gallery
			if (_content is PhotoGallery) {
				var photoGallery:PhotoGallery = _content as PhotoGallery;
				
				if (photoGallery.loaded) {
					photoGallery.addEventListeners();
				}
			}
						
			return _content;
			
		}
		
		/**
		 * Returns the link of the menu item.
		 */
		public function get link():String {
			
			return _link;
			
		}
		
		/**
		 * Returns the target browser window to open the url.
		 */
		public function get target():String {
			
			return _target;
			
		}
		
	}
	
}