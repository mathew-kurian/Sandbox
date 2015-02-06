package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.utils.Timer;
		
	public class ContactPageContent extends MovieClip {
		
		// Location of the data xml file
		private var dataXML:String;
		
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;
		
		// A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
	
		public function ContactPageContent(dataXML:String) {
			
			this.dataXML = dataXML;
			
			// Initialize the content
			init();
			
		}
		
		/**
		 * Initializes the page content
		 */
		private function init():void {
			
			// Clear text fields
			bodyText.text = "";
			addressValue.text = "";
			telephoneValue.text = "";
			faxValue.text = "";
			emailValue.text = "";
			
			// Prepare text fields
			nameField.value.text = "Name";
			emailField.value.text = "E-mail";
			messageField.value.text = "Message";
			nameField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			nameField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			emailField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			emailField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			messageField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			messageField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			
			// Set text on buttons
			clearButton.value.text = "CLEAR";
			sendButton.value.text = "SEND";
			clearButton.useHandCursor = clearButton.buttonMode = true;
			sendButton.useHandCursor = sendButton.buttonMode = true;
			clearButton.mouseChildren = sendButton.mouseChildren = false;
			clearButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			clearButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			clearButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			sendButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			sendButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			sendButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
						
			// Start reading the data.			
			dataXMLLoader = new XMLLoader(dataXML);
			dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
			dataXMLLoader.load();
			
		}
		
		/**
		 * This method is called when the focus is gained.
		 */
		private function onFocusIn(evt:FocusEvent):void {
			
			var value:String = "";
			
			if (evt.target.parent == nameField) {
				value = nameField.value.text;
			
				if (value == "Name") {
					nameField.value.text = "";
				}
			} else if (evt.target.parent == emailField) {
				value = emailField.value.text;
			
				if (value == "E-mail") {
					emailField.value.text = "";
				}
			} else if (evt.target.parent == messageField) {
				value = messageField.value.text;
			
				if (value == "Message") {
					messageField.value.text = "";
				}
			}
			
			Tweener.addTween(evt.target.parent.border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the focus is lost.
		 */
		private function onFocusOut(evt:FocusEvent):void {
			
			var value:String = "";
			
			if (evt.target.parent == nameField) {
				value = nameField.value.text;
			
				if (value == "") {
					nameField.value.text = "Name";
				}
			} else if (evt.target.parent == emailField) {
				value = emailField.value.text;
			
				if (value == "") {
					emailField.value.text = "E-mail";
				}
			} else if (evt.target.parent == messageField) {
				value = messageField.value.text;
			
				if (value == "") {
					messageField.value.text = "Message";
				}
			}
			
			Tweener.addTween(evt.target.parent.border, {_color:0x313131, time:1});
			
		}
		
		/**
		 * Validates the contact form and returns true if no errors are found.
		 */
		private function validateForm():Boolean {
			
			var name:String = nameField.value.text;
			var email:String = emailField.value.text;
			var message:String = messageField.value.text;
			var result:Boolean = true;
			
			if (name == "" || name == "Name") {
				Tweener.addTween(nameField.border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
				result = false;				
			}
			
			if (email == "" || email == "E-mail") {
				Tweener.addTween(emailField.border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
				result = false;
			}
			
			if (message == "" || message == "Message") {
				Tweener.addTween(messageField.border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
				result = false;
			}
			
			return result;
			
		}
		
		/**
		 * This method is called if mouse is clicked on one of the buttons.
		 */
		private function mouseDown(evt:Event):void {
			
			var button:ContactPageButton = evt.target as ContactPageButton;
			
			// Clear the form if it's the clear button
			if (button == clearButton) {
				nameField.value.text = "Name";
				emailField.value.text = "E-mail";
				messageField.value.text = "Message";
			} else if (button == sendButton) {
				// Send the message if the form data is valid
				if (validateForm()) {
					// Get form data
					var name:String = nameField.value.text;
					var email:String = emailField.value.text;
					var message:String = messageField.value.text;
					var variables:URLVariables = new URLVariables();
					variables.name = name;
					variables.email = email;
					variables.message = message;
					
					// Create a request
					var request:URLRequest = new URLRequest("send.php?cacheKiller=" + (new Date()).getTime());
					request.data = variables;
					request.method = URLRequestMethod.POST;
					
					// Send the request
					var loader:URLLoader = new URLLoader();
					loader.dataFormat = URLLoaderDataFormat.VARIABLES;
					loader.addEventListener(IOErrorEvent.IO_ERROR, onSendFailed, false, 0, true);
					loader.addEventListener(Event.COMPLETE, onSendComplete, false, 0, true);
					loader.load(request);
				} else {
					// Form contains errors
					result.text = "Please fix the errors.";
					var timer:Timer = new Timer(3000, 1);
					timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
					timer.start();
				}
			}
			
		}
		
		/**
		 * Checks the response from the server and sets an appropriate message.
		 */
		private function onSendComplete(evt:Event):void {
			
			var loader:URLLoader = URLLoader(evt.target);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			var timer:Timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
			
			if (loader.data.result == "sent") {
				nameField.value.text = "";
				emailField.value.text = "";
				messageField.value.text = "";				
				result.text = "Your e-mail has been sent.";
			} else {
				result.text = "Your e-mail cannot be sent.";
			}
			
		}
		
		/**
		 * Clears the result field.
		 */
		private function onTimer(evt:TimerEvent):void {
			
			result.text = "";
			
		}
		
		/**
		 * This method is called if an io error occurs during sending the e-mail.
		 */
		private function onSendFailed(evt:Event):void {
			
			result.text = "Your e-mail cannot be sent.";
			var timer:Timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
			
		}
		
		/**
		 * This method is called when the mouse is over the buttons.
		 */
		private function onMouseOver(evt:Event):void {
			
			var button:ContactPageButton = evt.target as ContactPageButton;
			Tweener.addTween(button.border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			Tweener.addTween(button.value, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the buttons.
		 */
		private function onMouseOut(evt:Event):void {
			
			var button:ContactPageButton = evt.target as ContactPageButton;
			Tweener.addTween(button.border, {_color:null, time:1});
			Tweener.addTween(button.value, {_color:null, time:1});
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
			
			// Get the xml data
			var xml:XML = dataXMLLoader.getXML();
			
			bodyText.text = xml.body;
			addressValue.text = xml.address;
			telephoneValue.text = xml.telephone;
			faxValue.text = xml.fax;
			emailValue.text = xml.email;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 5;
			bodyText.setTextFormat(textFormat);
			dispatchEvent(evt);

		}
	
	}
	
}