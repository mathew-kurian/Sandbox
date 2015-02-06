package net.flashden.lydian.news {
	
	import flash.display.MovieClip;
		
	public class NewsLineItem extends MovieClip {
		
		// Date added
		private var _date:String;
		
		// Item title
		private var _title:String;
	
		public function NewsLineItem(date:String, title:String) {
			
			this._date = date;
			this._title = title;					
			
		}
		
		/**
		 * Returns the date added.
		 */
		public function get date():String {
			
			return _date;
			
		}
		
		/**
		 * Returns the title of the item.
		 */
		public function get title():String {
			
			return _title;
			
		}
		
	}
	
}