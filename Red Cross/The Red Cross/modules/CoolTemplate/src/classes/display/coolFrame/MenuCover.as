/*
MenuCover.as
CoolFrame

Created by Alexander Ruiz Ponce on 31/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.coolFrame
{
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import gT.utils.ColorUtils;
	import classes.Global;
	
	public class MenuCover extends CoolFrame {
		
		private var __labelStr:String;
		private var __color:uint;
		private var __fontColor:uint;
		private var __label:MovieClip;
		
		public function MenuCover (bitmap:Bitmap, label:String = "Menu", color:uint = 0x00C6FF, fontColor:uint = 0xffffff) 
		{
			__labelStr = label;
			__color = color;
			__fontColor = fontColor;
			
			super(bitmap,								// Image
				  new BCover(0,0),						// Main Frame
				  new BCoverMask(0,0),					// Mask
				  new Rectangle(20, 8, 216, 209),		// Bounds Area
				  null,									// Shadow Offset
				  false									// Force Image Proportion
				  );
		}
		
		//////////////////////////////////////////////////////////
		//
		// Override methods
		//
		//////////////////////////////////////////////////////////
		override protected function addChildren():void
		{
			super.addChildren();
			//
			// Label
			__label = new MenuCoverLabel;
			__label.tf.text = __labelStr;
			__label.tf.textColor = __fontColor;
			
			ColorUtils.tint(__label.hit, __color);
			addChild(__label);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			
			__label.x = __bounds.right - 1;
			__label.y = __bounds.bottom - __label.height * 2;
			
			__label.hit.width = __label.tf.textWidth + 15;
		}
		
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