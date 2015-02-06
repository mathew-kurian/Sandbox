/*
TextTemplate.as
CoolTemplate

Created by Alexander Ruiz Ponce on 20/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.templates
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;

	import classes.Global;
	import classes.CustomEvent;
	import classes.display.Block;
	import classes.controls.ScrollPane;
	
	public class TextTemplate extends Template {
		
		private var __data:Object;
		private var __texts:Block;
		private var __scrollPane:ScrollPane;
		
		public function TextTemplate (data:Object) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		override protected function init ():void
		{
		}
		
		override protected function onStage():void
		{
		}
		*/
		
		override protected function addChildren():void
		{
			super.addChildren();
			// Title
			__title.text = __data.title;
			
			// Texts
			__texts = new Block("TextBlockAsset", __data.textBlocks, null);
			__texts.spaceAfterTitle = 16;
			__texts.spaceAfterSubtitle = 15;
			__texts.spaceAfterParagraph = 30;
			
			__scrollPane = new ScrollPane;
			__scrollPane.content = __texts;
			//__scrollPane.resizeThumb = false;
			__holder.addChild(__scrollPane);
		}
		
		override protected function onTemplateOn ():void
		{
			__texts.loadImages();
		}
		
		override protected function destroy ():void
		{
			__texts.destroy();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			
			__scrollPane.width = __contentWidth;
			__scrollPane.height = __contentHeight;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}