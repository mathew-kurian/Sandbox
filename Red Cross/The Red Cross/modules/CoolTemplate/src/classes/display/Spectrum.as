/*
 Spectrum.as
 JukeBox
 
 Created by Alexander Ruiz Ponce on 27/10/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.display
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter
	
	import gT.display.components.GenericComponent;
	import classes.Global;
	import classes.CustomEvent;
	
	public class Spectrum extends GenericComponent {
		
		private	var __mainHolder:Sprite;
		private var __right:Sprite;
		private var __left:Sprite;
		private var __holderBitmap:Sprite;
		private var __sound:Sound;
		private var __channel:SoundChannel;
		
		private var __bWidth:Number = 1;
		private var __bSepatation:uint = 1;
		private var __bHeight:uint = 200;
		private var __bArray:ByteArray = new ByteArray;
		private var __f:Number;
		private var __total:uint = 256;
		
		private var __bitmapData:BitmapData;
		private var __bitmap:Bitmap;
		private var __blur:BlurFilter;
		private var __blurRect:Rectangle;
		private var __blurPoint:Point;
		private var __colorMatrix:ColorMatrixFilter;
		private var __matrixBar:Matrix = new Matrix();
		
		private const CHANNEL_LENGTH:int = 128;
		private const BUFFER_LENGTH:int = 512;
		
		public function Spectrum () {
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init ():void
		{
			setMinSize(768, 30);
			
			__blur = new BlurFilter(Global.settings.jukeBoxSpectrumXBlurSize, 10, Global.settings.jukeBoxSpectrumBlurQuality);
			__blurPoint = new Point(0, 0);
			
			var r:Number = 1;
			var a:Number = Global.settings.jukeBoxSpectrumAlpha; // Color Matrix alpha
			__colorMatrix = new ColorMatrixFilter([
												   r, 0, 0, 0, 0,
												   0, r, 0, 0, 0,
												   0, 0, r, 0, 0,
												   0, 0, 0, .7, 0
												   ]);
			
			super.init();
			
			// Detects ENTER_FRAME Event from main to refresh the display list
			Global.addEventListener(CustomEvent.GLOBAL_RENDER, render, false, 0, true);
		}
		
		
		override protected function onStage():void
		{
			if (Global.settings.jukeBoxSpectrumBlur) createBitmapData();
		}
		
		override protected function addChildren():void
		{
			// main holder
			__mainHolder = new Sprite;
			addChild(__mainHolder);
						
			// holder for bitmaps
			__holderBitmap = new Sprite;
			__holderBitmap.blendMode = "screen";
			addChild(__holderBitmap);
			
			// LeftHolder
			__left = new Sprite;
			__left.blendMode = "screen";
			__mainHolder.addChild(__left);
			
			__right = new Sprite;
			__right.blendMode = "screen";
			__mainHolder.addChild(__right);
			//__right.addChild(new Cruz);
			__right.scaleX = -1;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (Global.settings.jukeBoxSpectrumBlur) createBitmapData();
		
			__bHeight = __height - 100;
			
			__left.y = Math.round(__height / 2);
			__right.y = __left.y;
			__right.x = __width; 
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function destroy (e):void
		{
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, render);
		}
		
		private function generateSpectrum ():void
		{
			try {
				__f = 0;
				__left.graphics.clear();
				__right.graphics.clear();
				
				SoundMixer.computeSpectrum(__bArray, true, 1);
				
				var i:uint;
				var barH:uint;

				i = CHANNEL_LENGTH;
				while (i--)
				{
					__f = __bArray.readFloat();
					barH = __bHeight * __f;
					createBar(__left, __bWidth, barH, (__bWidth + __bSepatation) * (CHANNEL_LENGTH - i), - barH / 2);
					createBar(__right, __bWidth, barH, (__bWidth + __bSepatation) * (CHANNEL_LENGTH - i), - barH / 2);
				}
				
				if (Global.settings.jukeBoxSpectrumBlur) {
					// Glow effect
					__bitmapData.draw(__mainHolder);
					__bitmapData.applyFilter(__bitmapData, __blurRect, __blurPoint, __blur);
					__bitmapData.applyFilter(__bitmapData, __blurRect, __blurPoint, __colorMatrix);
					__bitmap = new Bitmap(__bitmapData);
					//__bitmap.blendMode = "overlay";
					__holderBitmap.addChild(__bitmap);
					
					if(__holderBitmap.numChildren > 1) {
						__holderBitmap.removeChildAt(0);
					}
				}
				
			} catch (e) {
				trace("GT", e);
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createBitmapData ():void
		{
			__bitmapData = new BitmapData(__width || 5, __height || 5, true, 0xff0000);			
			__blurRect = new Rectangle(0, 0, __bitmapData.width, __bitmapData.height);
		}
		
		private function createBar (t, w, h, x, y):void
		{
			__matrixBar.createGradientBox(w, h, Math.PI/2, 0, y);
			
			if (Global.settings.jukeBoxSpectrumGradientMode == "linear")
			{
				// Linear
				t.graphics.beginGradientFill("linear", [Global.settings.jukeBoxSpectrumColor1, Global.settings.jukeBoxSpectrumColor2], [1, 1], [0, 255], __matrixBar, "pad");
			} else {
				// From Center
				t.graphics.beginGradientFill("linear", [Global.settings.jukeBoxSpectrumColor1, Global.settings.jukeBoxSpectrumColor2, Global.settings.jukeBoxSpectrumColor3], [1, 1, 1], [0, 127, 255], __matrixBar, "pad");
			}
			
			t.graphics.drawRect(x, y, w, h);
			t.graphics.endFill();
			
			/*
			if (h > 0) {
				t.graphics.beginFill(0xffffff, 1);
				t.graphics.drawRect(x, y-2, w, 1);
				t.graphics.endFill();
			}
			 */
		}
		
		private function render (e:CustomEvent):void
		{
			generateSpectrum();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}