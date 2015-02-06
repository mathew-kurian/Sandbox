package net.flashden.lydian.template {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ConfigManager extends EventDispatcher {
		
		// The name of the event to be fired when configuration is read
		public static const CONFIG_LOADED:String = "configLoaded";
		
		// Location of the config xml file
		public static const CONFIG_XML_URL:String = "xml/config.xml";
		
		// URL of the main xml file
		public static const MAIN_XML_URL:String = "xml/main.xml";
		
		// Location of the background file
		public static const BACKGROUND_URL:String = "background/background.swf";
		
		// Holds the width of the content holder (This should be changed through the fla file)
		public static const CONTENT_HOLDER_WIDTH:Number = 750;
		
		// Holds the height of the content holder (This should be changed through the fla file)
		public static const CONTENT_HOLDER_HEIGHT:Number = 375;
		
		// URL of the website logo
		public static var LOGO_URL:String = "images/logo.png";
		
		// Name of the main news menu
		public static var NEWS_LINE_NAME:String = "news";
		
		// Location of the news xml file for the newsline
		public static var NEWS_LINE_URL:String = "xml/news.xml";
		
		// Top margin of the content holder
		public static var CONTENT_HOLDER_TOP_MARGIN:Number = 34;
		
		// Left margin of the content holder
		public static var CONTENT_HOLDER_LEFT_MARGIN:Number = 42;
		
		// Spacing for the main menu
		public static var MM_SPACING:Number = 1;
		
		// Mouse over color for the main menu
		public static var MM_MOUSE_OVER_COLOR:uint = 0x6A0F15;
		
		// Selected menu background color for the main menu
		public static var MM_SELECTED_MENU_BACKGROUND:uint = 0xFF0000;
		
		// Selected menu text color for the main menu
		public static var MM_SELECTED_MENU_TEXT_COLOR:uint = 0x410000;

		// Width of the banners
		public static var BANNER_WIDTH:Number = 321;
		
		// Height of the banners
		public static var BANNER_HEIGHT:Number = 172;
		
		// Background color of the banners
		public static var BR_BACKGROUND_COLOR:uint = 0x000000;

		// The size of the border for banner rotator
		public static var BR_BORDER_SIZE:int = 1;
		
		// Color of the banner rotator border
		public static var BR_BORDER_COLOR:uint = 0x313131;
		
		// Color of the selected button
		public static var BR_SELECTED_BUTTON_COLOR:uint = 0xFF0000;
		
		// Color of the selected button text
		public static var BR_SELECTED_BUTTON_TEXT_COLOR:uint = 0x4F0000;
		
		// Space between buttons
		public static var NUMBER_BUTTON_SPACING:Number = 4;
		
		// Number of columns for photo gallery
		public static var NUM_OF_ROWS:int = 4;
		
		// Number of row for photo gallery
		public static var NUM_OF_COLUMNS:int = 6;
		
		// Path to the thumbnails
		public static var THUMBNAIL_DIR:String = "images/thumbs/";
		
		// Path to the photos
		public static var PHOTO_DIR:String = "images/"
		
		// Border size of the original photo which will be displayed on the stage
		public static var PHOTO_BORDER_SIZE:Number = 4;
		
		// Ratio to be used for resizing the thumbnails
		public static var THUMB_ZOOM_OUT_RATIO:Number = 0.7;
		
		// Width of the thumbnails
		public static var THUMB_MASK_WIDTH:Number = 88;
		
		// Height of the thumbnails
		public static var THUMB_MASK_HEIGHT:Number = 60;
		
		// Size of the thumbnail border
		public static var THUMB_BORDER_SIZE:int = 2;
		
		// Color of the thumbnail border
		public static var THUMB_BORDER_COLOR:uint = 0x313131;
		
		// Color of the thumbnail background
		public static var THUMB_BACKGROUND_COLOR:uint = 0x212121;
	
		// Spacing between the thumbnails
		public static var SPACE_BETWEEN_THUMBNAILS:Number = 5;
		
		// Number of the news items on each page
		public static var NEWS_MENU_PAGE_LIMIT:uint = 3;
		
		// Spacing for the news menu
		public static var NEWS_MENU_SPACING:Number = 25;
		
		// Width of the news items
		public static var NEWS_MENU_ITEM_WIDTH:Number = 570;
		
		// Height of the news items
		public static var NEWS_MENU_ITEM_HEIGHT:Number = 80;
		
		// Number of the items on each page
		public static var HORIZONTAL_MENU_PAGE_LIMIT:uint = 3;
		
		// Height of the horizontal menu
		public static var HORIZONTAL_MENU_HEIGHT:Number = 146;			
		
		// Spacing for the horizontal menu
		public static var HORIZONTAL_MENU_SPACING:Number = 26;
		
		// Width of the horizontal menu item
		public static var HORIZONTAL_MENU_ITEM_WIDTH:Number = 170;
		
		// Height of the horizontal menu item (Don't add the text panel height)
		public static var HORIZONTAL_MENU_ITEM_HEIGHT:Number = 90;
		
		// Border color of the horizontal menu item
		public static var HORIZONTAL_MENU_ITEM_BORDER_COLOR:uint = 0x313131;
		
		// Border size of the horizontal menu item
		public static var HORIZONTAL_MENU_ITEM_BORDER_SIZE:uint = 1;

		// The name of the mp3 file to be played in the background
		public static var MP3_FILE:String = "mp3/track.mp3";

		// General highlight color to be used for mouse over states
		public static var HIGHLIGHT_COLOR:uint = 0xFF0000;
		
		// Left margin for the top and bottom bars
		public static var LEFT_MARGIN:Number = 0;
		
		// Right margin for the top and bottom bars
		public static var RIGHT_MARGIN:Number = 0;
		
		// Top margin for the top bar
		public static var TOP_MARGIN:Number = 0;
		
		// Bottom margin for the bottom bar
		public static var BOTTOM_MARGIN:Number = 30;
		
		// An XMLLoader instance to load config xml file to the memory
		private var configXMLLoader:XMLLoader;
		
		// Xml data
		private var xml:XML;
		
		// A reference to the ConfigManager
		private static var _configManager:ConfigManager;
		
		public function ConfigManager(singletonEnforcer:SingletonEnforcer) {			
			// NOTHING HERE
		}			
		
		public function load():void {
			
			// Create a new XMLLoader object
			configXMLLoader = new XMLLoader(CONFIG_XML_URL);
			
			// Add an event listener to be dispatched when xml is parsed.
			configXMLLoader.addEventListener(XMLLoader.XML_LOADED, onConfigXMLLoaded);
			
			// Start loading the file
			configXMLLoader.load();
			
		}
		
		/**
		 * Reads all of the setting values from the configuration xml data and sets the
		 * appropriate variables.
		 */
		private function readConfig(xml:XML):void {

			LOGO_URL = xml.@logoURL;
			MP3_FILE = xml.@mp3URL;
			NEWS_LINE_NAME = xml.@newslineName;
			NEWS_LINE_URL = xml.@newslineXML;
			MM_SELECTED_MENU_BACKGROUND = xml.@mainMenuSelectedBackgroundColor;
			MM_SELECTED_MENU_TEXT_COLOR = xml.@mainMenuSelectedTextColor;
			MM_MOUSE_OVER_COLOR = xml.@mainMenuMouseOverColor;
			BANNER_WIDTH = xml.@bannerRotatorWidth;
			BANNER_HEIGHT = xml.@bannerRotatorHeight;
			BR_BORDER_SIZE = xml.@bannerRotatorBorderSize;
			BR_BORDER_COLOR = xml.@bannerRotatorBorderColor;
			BR_BACKGROUND_COLOR = xml.@bannerRotatorBackgroundColor;
			BR_SELECTED_BUTTON_COLOR = xml.@bannerRotatorSelectedButtonColor;
			BR_SELECTED_BUTTON_TEXT_COLOR = xml.@bannerRotatorSelectedButtonTextColor;
			THUMBNAIL_DIR = xml.@thumbnailDir;
			PHOTO_DIR = xml.@photoDir;
			PHOTO_BORDER_SIZE = xml.@photoBorderSize;
			THUMB_BORDER_COLOR = xml.@thumbBorderColor;
			THUMB_BACKGROUND_COLOR = xml.@thumbBackgroundColor;
			HORIZONTAL_MENU_ITEM_BORDER_COLOR = xml.@portfolioPageItemBorderColor;
			HORIZONTAL_MENU_ITEM_BORDER_SIZE = xml.@portfolioPageItemBorderSize;
			HIGHLIGHT_COLOR = xml.@highlightColor;
			CONTENT_HOLDER_TOP_MARGIN = xml.@contentHolderTopMargin;
			CONTENT_HOLDER_LEFT_MARGIN = xml.@contentHolderLeftMargin;
			
		}
		
		/**
		 * This method is called when the configuration file is loaded.		 
		 */
		private function onConfigXMLLoaded(evt:Event):void {
			
			// Read the setting values from the configuration file 
			readConfig(configXMLLoader.getXML());
			dispatchEvent(new Event(ConfigManager.CONFIG_LOADED));

		}
		
		/**
		 * Returns the configuration manager.
		 */
		public static function getInstance():ConfigManager {
			
			if (_configManager == null) {
				_configManager = new ConfigManager(new SingletonEnforcer());
			}
			
			return _configManager;
			
		}
		
	}
	
}