/*
NewsDisplayer.as
CoolTemplate

Created by Carlos Vergara on 23/11/09.
Copyright 2009 goTo! Multimedia All rights reserved.
*/
package classes.display{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gT.display.components.GenericComponent;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.display.Block;
	import classes.controls.ScrollPane;
	
	public class NewsDisplayer extends GenericComponent {
		
		private var __data:Object;
		private var __scrollPane:ScrollPane;
		private var __holderButton:Sprite;
		private var __texts:Block;
		
		
		public function NewsDisplayer (data:Object) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function addChildren ():void		
		{
			//back Button
			__holderButton = new Sprite;
			__holderButton.buttonMode = true;
			__holderButton.mouseChildren = false;
			__holderButton.y = -45;
			
			addChild(__holderButton);
			var font = new Font_24;
			var tf:TextField = font.tf;
			
			tf.text = Global.getString("BACK");
			tf.textColor = Global.settings.globalColor1;
			__holderButton.addChild(tf);
			
			
			
			// Texts
			__texts = new Block("TextBlockAsset", __data.textBlocks, null);
			__texts.spaceAfterTitle = 16;
			__texts.spaceAfterSubtitle = 15;
			__texts.spaceAfterParagraph = 30;
			__texts.loadImages();
			
			__scrollPane = new ScrollPane;
			__scrollPane.content = __texts;
			//__scrollPane.resizeThumb = false;
			
			addChild(__scrollPane);
			backButtonEvents();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__scrollPane.width = __width;
			__scrollPane.height = __height;
			
			__holderButton.x = __width - __holderButton.width;
		}
		
		public function destroy ():void
		{
			__texts.destroy();
		}
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function buttonHandler(e:MouseEvent):void{
			if(e.type == MouseEvent.CLICK){
				dispatchEvent(new CustomEvent(CustomEvent.BACK_BUTTON_CLICKED));
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function backButtonEvents():void{
			__holderButton.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			__holderButton.addEventListener(MouseEvent.MOUSE_OVER, buttonHandler, false, 0, true);
			__holderButton.addEventListener(MouseEvent.MOUSE_OUT, buttonHandler, false, 0, true);
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}