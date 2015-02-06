/*
CDFrame.as
CoolFrame

Created by Alexander Ruiz Ponce on 30/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display.coolFrame
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class CDCover extends CoolFrame {
		
		public function CDCover (bitmap:Bitmap) 
		{
			super(bitmap,								// Image
				  new BCDCover(0,0),					// Main Frame
				  new BCDCoverMask(0,0),				// Mask
				  new Rectangle(31, 7, 214, 209),		// Bounds Area
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