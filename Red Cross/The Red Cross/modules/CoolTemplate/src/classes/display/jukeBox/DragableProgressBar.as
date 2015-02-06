/*
DragableProgressBar.as
JukeBox

Created by Alexander Ruiz Ponce on 17/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gT.utils.EventUtils;
	import gT.display.Draw;
	
	import classes.CustomEvent;
	import classes.Global;
	
	public class DragableProgressBar extends ProgressBar 
	{
		private var __hit:Sprite;
		
		public function DragableProgressBar () 
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, false, 0, true);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		override protected function init ():void
		{
			super.init();
		}
		 */
		
		 /*
		override protected function onStage():void
		{
		}
		*/
		override protected function addChildren():void
		{			
			super.addChildren();
			
			__hit = Draw.rectangle(__minWidth, __minHeight, 0xff0000, 0);
			addChild(__hit);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		
		override public function draw ():void
		{
			super.draw();
			
			__hit.width = __width;
			__hit.height = __height;
		}
		
		private function mouseHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					//addEventListener(Event.ENTER_FRAME, update, false, 0, true);
					Global.addEventListener(CustomEvent.GLOBAL_RENDER, update, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
					break;
				case MouseEvent.MOUSE_UP:
					//removeEventListener(Event.ENTER_FRAME, update);
					Global.removeEventListener(CustomEvent.GLOBAL_RENDER, update);
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					
					percent = ((Math.round(__fill.width)) * 100) / (__width - 2);
					dispatchEvent(new JukeBoxEvent(JukeBoxEvent.CHANGE, {percent:percent}));
					break;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function update (e:CustomEvent = null):void
		{
			var p = Math.min((mouseX * 100) / __width, 100);
			
			if (p < 0) {
				__percent = 0 
			} else {
				__percent = p;
			}
			
			var w = Math.ceil(((__width - 2) * __percent) / 100);
			__fill.width += (w - __fill.width) / 5;
			
			dispatchEvent(new JukeBoxEvent(JukeBoxEvent.CHANGE, {percent:percent}));
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function render (e:CustomEvent):void
		{
			// update();
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}