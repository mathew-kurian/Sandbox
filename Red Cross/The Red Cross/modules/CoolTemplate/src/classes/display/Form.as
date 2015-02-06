/*
Form.as
CoolTemplate

Created by Carlos Andres Viloria Mendoza on 29/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.controls.FormValidator;
	import gT.utils.ColorUtils;
	
	import gT.display.components.GenericComponent;
	
	import gs.TweenMax;
	
	public class Form extends Sprite {
		
		private var __formvalidator:FormValidator;
		private var __textFields:Array;
		private var __messages:Object;
		
		private var __textFields2:Array;
		private var __backgrounds:Array;
		private var __labels:Array;
		private var __info:Object;
		
		public function Form(info:Object) {
			__info = info;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		private function init (e:Event = null):void
		 {
			 removeEventListener(Event.ADDED_TO_STAGE, init);
			 
			 
			 __textFields = [
							 {label:txt_name, field:"name_input", error:__info.requiredMessage, required:true},
							 {label:txt_email, field:"email_input", error:__info.requiredMessage, required:true, email:true},
							 {label:txt_message, field:"message_input", error:__info.requiredMessage, required:true}
							 ];
			 
			 __messages = {
				 emailError:__info.invalidEmail, 
				 init:__info.sending, 
				 success:__info.succesMessage, 
				 error:__info.errorMessage
			 };		 
			 name_input.text = email_input.text = message_input.text = "";
			 name_input.textColor = email_input.textColor = message_input.textColor = Global.settings.globalColor1;
			
			 // Info
			 txt_info.multiline = true;
			 txt_info.autoSize = "left";
			 txt_info.wordWrap = true;
			 txt_info.htmlText = __info.infoForm;
			 
			 txt_name.text = __info.name;
			 txt_name.textColor = Global.settings.globalColor1;
			 txt_email.text = __info.email;
			 txt_email.textColor = Global.settings.globalColor1;
			 txt_message.text = __info.message;
			 txt_message.textColor = Global.settings.globalColor1;
			 button.tf.text = __info.send;
			 
			 button.mouseChildren = false;
			 button.buttonMode = true;
			 
			 name_input.tabIndex = 0;
			 email_input.tabIndex = 1;
			 message_input.tabIndex = 2;
			 button.tabIndex = 3;
			 
			 txt_name.tabEnabled = false;
			 txt_email.tabEnabled = false;
			 txt_message.tabEnabled = false;
			 
			 __formvalidator = new FormValidator(__textFields, Global.FORM_FILE, __messages);
			 __formvalidator.addEventListener(FormValidator.ON_ERROR, handlerValidator);
			 __formvalidator.addEventListener(FormValidator.ON_SEND, handlerValidator);
			 __formvalidator.addEventListener(FormValidator.ON_SUBMIT, handlerValidator);
			 __formvalidator.addEventListener(FormValidator.ON_SUCCESS, handlerValidator);
			 __formvalidator.mc = this;
			 
			 // button
			 ColorUtils.tint(button.bg, Global.settings.globalColor3)
			 ColorUtils.tint(button.tf, Global.settings.globalColor1)
			 button.bg.alpha = .3;
			 
			 buttonEvents(true);
			 inputEvents();
			 
			 for (var i in __backgrounds) {
				 ColorUtils.tint(__backgrounds[i], Global.settings.globalColor3);
				 __backgrounds[i].alpha = .3;
			 }
		 }
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		public function handlerValidator(e:Event){
			switch(e.type){
				case FormValidator.ON_ERROR:
					showError();				
					buttonEvents(true);
					break;
				case FormValidator.ON_SUBMIT:
					buttonEvents(false);
					break;
				case FormValidator.ON_SEND:
					showError();
					break;
				case FormValidator.ON_SUCCESS:
					buttonEvents(true);
					break;
			}
			
		}
		
		private function forceFocus(e:MouseEvent){
			var nameInput = e.currentTarget.name.substr(2, e.currentTarget.name.length-1);
			stage.focus = this[nameInput];
		}
		
		private function focusChange(e:FocusEvent):void {
			var index = e.currentTarget.tabIndex;
			switch(e.type){
				case "focusIn":
					TweenMax.to(__labels[index], .3, {tint:Global.settings.globalColor2});
					__textFields2[index].textColor = Global.settings.globalColor3;
					TweenMax.to(__backgrounds[index], .3, {alpha:1, tint:Global.settings.globalColor1});
					break;
				case "focusOut":
					TweenMax.to(__labels[index], .3, {tint:Global.settings.globalColor1});
					__textFields2[index].textColor = Global.settings.globalColor1;
					TweenMax.to(__backgrounds[index], .3, {alpha:.3, tint:Global.settings.globalColor3});
					break;
			}
			
        }
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function buttonEvents(sw:Boolean){
			if(sw){
				button.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
				button.addEventListener(MouseEvent.MOUSE_OVER, buttonHandler, false, 0, true);
				button.addEventListener(MouseEvent.MOUSE_OUT, buttonHandler, false, 0, true);
				button.addEventListener(FocusEvent.FOCUS_IN, buttonHandler, false, 0, true);
				button.addEventListener(FocusEvent.FOCUS_OUT, buttonHandler, false, 0, true);
				button.addEventListener(KeyboardEvent.KEY_DOWN, buttonHandler, false, 0, true);
			}else{
				button.removeEventListener(MouseEvent.CLICK, buttonHandler);
				button.removeEventListener(MouseEvent.MOUSE_OVER, buttonHandler);
				button.removeEventListener(MouseEvent.MOUSE_OUT, buttonHandler);
				button.removeEventListener(FocusEvent.FOCUS_IN, buttonHandler);
				button.removeEventListener(FocusEvent.FOCUS_OUT, buttonHandler);
				button.removeEventListener(KeyboardEvent.KEY_DOWN, buttonHandler);
			}
		}
		
		private function showError(){
			error.x = 130;
			error.filters = null;
			TweenMax.to(this.error, Global.settings.time/2, {x:96, ease:Global.settings.easeInOut});
			this.error.htmlText = __formvalidator.outPut;
		}
		
		private function buttonHandler(e){
			switch(e.type){
				case "click":
					__formvalidator.sendMessage();
					break;
				case "mouseOver":
					TweenMax.to(button.tf, .3, {tint:Global.settings.globalColor2});
					TweenMax.to(button.bg, .3, {alpha:1, tint:Global.settings.globalColor1});
					break;
				case "mouseOut":
					TweenMax.to(button.tf, .3, {tint:Global.settings.globalColor1});
					TweenMax.to(button.bg, .3, {alpha:.3, tint:Global.settings.globalColor3});
					break;
				case "focusOut" :
					TweenMax.to(button.tf, .3, {tint:Global.settings.globalColor1});
					TweenMax.to(button.bg, .3, {alpha:.3, tint:Global.settings.globalColor3});
					break;
				case "focusIn":
					TweenMax.to(button.tf, .3, {tint:Global.settings.globalColor2});
					TweenMax.to(button.bg, .3, {alpha:1, tint:Global.settings.globalColor1});
					break;
				case "keyDown" :
					if (e.keyCode == Keyboard.ENTER) {
						__formvalidator.sendMessage();
					}
					break;
			}
		}
	
		
		private function inputEvents(){
			__textFields2 = [name_input, email_input, message_input];
			__backgrounds = [f_name_input, f_email_input, f_message_input];
			__labels = [txt_name, txt_email, txt_message];
			
			for(var j:int=0; j<__textFields2.length; j++){
				__textFields2[j].addEventListener(FocusEvent.FOCUS_IN, focusChange);
				__textFields2[j].addEventListener(FocusEvent.FOCUS_OUT, focusChange);
				__backgrounds[j].addEventListener(MouseEvent.CLICK, forceFocus);
				__backgrounds[j].mouseChildren = false;
				__backgrounds[j].tf = __textFields[j];
				
				__labels[j].mouseEnabled = false;
			}
		}
		
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}