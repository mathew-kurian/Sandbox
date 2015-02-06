/*
 Global.as
 CoolTemplate
 
 Created by Carlos Andres Viloria Mendoza on 2/11/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.templates
{
	import flash.text.TextField;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.display.Form;
	import classes.display.SocialIcons;
	
	public class ContactTemplate extends Template {
		
		private var __data:Object;
		private var __form:Form;
		private var __address:TextField;
		private var __socialText:TextField;
		private var __socialIcons:SocialIcons;
		
		public function ContactTemplate (data:Object) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////

		override protected function addChildren():void
		{
			super.addChildren();
			__title.text = __data.title;
			
			// address
			var font = new Font_11;
			__address = font.tf;
			__address.autoSize = "left";
			__address.width = 230;
			__address.wordWrap = true;
			__address.multiline = true;
			__address.htmlText = __data.address;
			__holder.addChild(__address);
			
			// Social label
			var font2 = new Font_11;
			__socialText = font2.tf;
			__socialText.autoSize = "left";
			__socialText.width = 230;
			__socialText.htmlText = __data.socialText;
			__holder.addChild(__socialText);
			
			// form
			__form = new Form(__data.formInfo);
			__holder.addChild(__form);
		}
		
		override protected function onTemplateOn ():void
		{
			// social
			__socialIcons = new SocialIcons(__data.social);
			__holder.addChild(__socialIcons);
			draw();
		}
		
		override protected function destroy ():void
		{
			try {
				__socialIcons.destroy();
			} catch (e) {};
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			__address.x = __form.width + 40;
			__socialText.x = __address.x;
			__socialText.y = __address.y + __address.height + 30;
			
			if (__socialIcons) {
				__socialIcons.x = __address.x;
				__socialIcons.y = __socialText.y + __socialText.height + 10;
			}
		}
	}
}