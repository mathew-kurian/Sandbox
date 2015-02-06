/*
GhostCover.as
MusicTemplate

Created by Alexander Ruiz Ponce on 4/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display.coolFrame
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class GhostCover extends CoolFrame {
		
		public function GhostCover () 
		{
			super(null,								// Image
				  new BGhostCover(0,0),					// Main Frame
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