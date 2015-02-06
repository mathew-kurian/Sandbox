/*
DiscCover.as
CoolTemplate

Created by Alexander Ruiz Ponce on 8/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.coolFrame
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class DiscCover extends CoolFrame {
		
		public function DiscCover (bitmap:Bitmap) 
		{
			super(bitmap,								// Image
				  new BDiscCover(0,0),					// Main Frame
				  new BDiscCoverMask(0,0),				// Mask
				  new Rectangle(21, 4, 215, 214),		// Bounds Area
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