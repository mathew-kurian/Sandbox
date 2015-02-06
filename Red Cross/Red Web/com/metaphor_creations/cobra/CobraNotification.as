//**************************************************\\
//**************************************************\\
//** TITLE: CobraNotification.as		 	   	  **\\
//** VERSION: 1.0  								  **\\
//** LAST UPDATE: July 25, 2009    	       	      **\\
//**************************************************\\
//**************************************************\\
//** CREATED BY: Metaphor Creations               **\\
//** joe@metaphorcreations.com               	  **\\
//** www.flashden.net/user/JoeMC                  **\\
//** www.metaphorcreations.com               	  **\\
//**************************************************\\
//**************************************************\\

package com.metaphor_creations.cobra {

	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;
	import com.metaphor_creations.cobra.Singleton;
	import com.metaphor_creations.cobra.CobraButton;
	
	public class CobraNotification extends Sprite {
		
		private static var NOTIFICATION_WIDTH:int = 400;
		
		private var closeBtn:CobraButton;
		private var singleton:Singleton;
		
		private var ds_filter:Array = [new DropShadowFilter(0, 45, 0, .25, 10, 10, 1, 3)];
		
		// Setup the constructor when the class is created
		public function CobraNotification(_header:String, _txt:String):void {
			
			// Create a singleton object
			singleton = Singleton.getInstance();
			
			init(_header, _txt);	
		} 
		
		
		
		
		
		//**********************************************************************
		// Functions
		//**********************************************************************
		
		private function drawBackground():void {
			
			// Draw the background
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRoundRect(0,0,NOTIFICATION_WIDTH,closeBtn.y + closeBtn.height + singleton.edgeSpacing,20,20);
			graphics.endFill();
		}
		
		private function init(_header:String, _txt:String):void {
			
			// Set the text
			header.multiline = header.wordWrap = false;
			header.selectable = false;
			header.text = _header;
			
			txt.multiline = txt.wordWrap = true;
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.text = _txt;
			
			// Set the text position and size
			header.x = singleton.edgeSpacing;
			header.y = singleton.edgeSpacing;
			header.width = NOTIFICATION_WIDTH - singleton.edgeSpacing*2;
			
			txt.x = singleton.edgeSpacing;
			txt.y = header.y + header.height + singleton.edgeSpacing;
			txt.width = NOTIFICATION_WIDTH - singleton.edgeSpacing*2;
			
			// Create the close button
			closeBtn = new CobraButton(true);
			closeBtn.label = "CLOSE";
			closeBtn.x = NOTIFICATION_WIDTH/2 - closeBtn.width/2;
			closeBtn.y = txt.y + txt.height + singleton.edgeSpacing*2;
			addChild(closeBtn);
			
			// Draw the background
			drawBackground();
			
			// Add a dropshadow filter
			this.filters = ds_filter;
			
			// Add listener
			closeBtn.addEventListener(MouseEvent.CLICK, closeClick);
		}
		
		//**********************************************************************
		// Functions
		//**********************************************************************
		
		
		
		
		
		//**********************************************************************
		// Mouse Events
		//**********************************************************************
		
		private function closeClick(e:MouseEvent):void {
			
			// Dispatch a closed event
			dispatchEvent(new Event("notificationClosed"));
		}
		
		//**********************************************************************
		// Mouse Events
		//**********************************************************************
	}
}