package net.flashden.lydian.news {
	
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.XMLLoader;
		
	public class NewsLine extends MovieClip {
				
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;
		
		// The xml data
		private var xml:XML;
		
		// An array of news line items
		private var _items:Array = new Array();
		
		// A timer to be used to switch between news
		private var timer:Timer = new Timer(5000);
		
		// Current news item index
		private var currentIndex:int = 1;
		
		// A reference to the current date field
		private var currentDateField:TextField;
		
		// A reference to the current title field
		private var currentTitleField:TextField;
		
		// A reference to the next date field
		private var nextDateField:TextField;
		
		// A reference to the next title field
		private var nextTitleField:TextField;
	
		public function NewsLine() {
			
			init();
			
		}
		
		/**
		 * Initializes news line.
		 */
		private function init():void {
			
			// Use as a button
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
	
			// Start reading the data.			
			dataXMLLoader = new XMLLoader(ConfigManager.NEWS_LINE_URL);
			dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
			dataXMLLoader.load();
			
			currentDateField = firstDateField;
			currentTitleField = firstTitleField;
			nextDateField = secondDateField;
			nextTitleField = secondTitleField;
			
			// Add necessary event listeners
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			
		}
		
		/**
		 * This method is called whenever a new timer event is received.
		 */
		private function onTimer(evt:TimerEvent):void {
						
			Tweener.addTween(currentDateField, {alpha:0, time:.6});
			Tweener.addTween(currentTitleField, {y:currentTitleField.y - 10, alpha:0, delay:.5, time:.6, onComplete:update});
			Tweener.addTween(nextDateField, {y:0, alpha:1, time:1.5});						
			Tweener.addTween(nextTitleField, {y:0, alpha:1, delay:.6, time:1.5});			
			
		}
		
		/**
		 * Updates the component.
		 */
		private function update():void {

			// Increase current index
			++currentIndex;
			
			if (currentIndex == _items.length) {
				currentIndex = 0;
			}
			
			// Change textfields
			var currDateFieldBuff:TextField = currentDateField;
			var currTitleFieldBuff:TextField = currentTitleField;
			currentDateField = nextDateField;
			currentTitleField = nextTitleField;
			nextDateField = currDateFieldBuff;
			nextTitleField = currTitleFieldBuff;
			nextTitleField.y = nextDateField.y = 22;
			nextDateField.text = _items[currentIndex].date;
			nextTitleField.text = _items[currentIndex].title;
			
		}
		
		/**
		 * Plays mouse over tweens.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			Tweener.addTween(currentDateField, {_color:0xFF0000, time:1});
			Tweener.addTween(currentTitleField, {_color:0xFF0000, time:1});
			Tweener.addTween(nextDateField, {_color:0xFF0000, time:1});
			Tweener.addTween(nextTitleField, {_color:0xFF0000, time:1});
			
		}
		
		/**
		 * Plays mouse out tweens.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			Tweener.addTween(currentDateField, {_color:null, time:1});
			Tweener.addTween(currentTitleField, {_color:null, time:1});
			Tweener.addTween(nextDateField, {_color:null, time:1});
			Tweener.addTween(nextTitleField, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the mouse is clicked on a news item.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			// Calculate item index
			var itemIndex = currentIndex - 1;
			
			if (currentIndex == 0) {
				itemIndex = _items.length - 1;
				
			}
			
			// Navigate to address
			var newsLineItem:NewsLineItem = _items[itemIndex] as NewsLineItem;
			SWFAddress.setValue(ConfigManager.NEWS_LINE_NAME.replace(/ /g, "_").toLowerCase() + "/" + newsLineItem.title.replace(/ /g, "_").toLowerCase());
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {						
			
			// Get the xml data
			xml = dataXMLLoader.getXML();			
			
			for each (var item:XML in xml.item) {				
				var date:String = item.@date;
				var title:String = item.title;
				
				var newsLineItem:NewsLineItem = new NewsLineItem(date, title);
				_items.push(newsLineItem);
			}
			
			timer.start();
			
			currentDateField.text = _items[0].date;
			currentTitleField.text = _items[0].title;
			nextDateField.text = _items[1].date;
			nextTitleField.text = _items[1].title;

		}
		
	}
	
}