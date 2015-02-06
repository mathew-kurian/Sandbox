/*
ScrollPane.as
CoolTemplate

Created by Alexander Ruiz Ponce on 21/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.controls
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.controls.SimpleScrollPane;
	import gT.utils.ColorUtils;
	import flash.display.Bitmap;
	
	import classes.Global;
	public class ScrollPane extends SimpleScrollPane {
		
		public function ScrollPane () {
			super();
			resizeThumb = false;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function createThumb ():void
		{			
			__thumb = new Bitmap(new BThumb(0,0));
			ColorUtils.tint(__thumb, Global.settings.globalColor1);
			__thumbHolder.buttonMode = true;
		}
	}
}