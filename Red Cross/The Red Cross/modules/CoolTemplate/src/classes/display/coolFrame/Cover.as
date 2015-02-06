/*
Cover.as
CoolFrame

Created by Alexander Ruiz Ponce on 31/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.coolFrame
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class Cover extends CoolFrame {
		
		public function Cover (bitmap:Bitmap) 
		{
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
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}