/*
Template.as
CoolTemplate

Created by Carlos Andres Viloria Mendoza on 10/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.templates 
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	
	import gT.display.components.GenericComponent;
	import gT.utils.DisplayObjectUtils;
	import gT.display.Rasterize;
	
	import gs.TweenMax;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class Template extends GenericComponent {
		
		protected var __background:Sprite;
		protected var __title:TextField;
		protected var __mainHolder:Sprite;
		protected var __holder:Sprite;
		protected var __contentWidth:Number;
		protected var __contentHeight:Number;
		
		protected const MARGIN_X:uint = 35;
		protected const MARGIN_Y:uint = 20;
		protected const CONTENT_Y:uint = 55;
		
		public function Template () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		override protected function init():void
		{
			super.init();
		}
		 */
		
		override protected function addChildren():void
		{
			// Background
			__background = createGradientFill(__minWidth, __minHeight, [Global.settings.contentBackgroundColor, Global.settings.contentBackgroundColor], [1, 0], [0, 255]);
			addChild(__background);
			
			// Holder
			__mainHolder = new Sprite;
			__mainHolder.x = MARGIN_X;
			__mainHolder.y = MARGIN_Y;
			// __mainHolder.alpha = 0;
			addChild(__mainHolder);
			
			// Title
			var font:Font_35 = new Font_35;
			__title = font.tf;
			__title.text = "";
			__title.autoSize  = "left";
			__title.textColor = Global.settings.globalColor1;
			__title.x = -3
			__mainHolder.addChild(__title);
			
			// Holder
			__holder = new Sprite;
			__holder.y = CONTENT_Y;
			__mainHolder.addChild(__holder);
			
		}
		
		protected function onTemplateOn ():void
		{
		}
		
		protected function onTemplateOff ():void
		{
			destroy();
		}
		
		protected function destroy ():void
		{
			
		}
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		
		override public function draw ():void
		{
			__contentWidth = __width - MARGIN_X * 2;
			__contentHeight = __height - CONTENT_Y - MARGIN_Y * 2;
			
			__background.width = __width;
			__background.height = __height;
		}
		
		public function on ():void {
			var snapShot = Rasterize.snapShot(this);
			addChild(snapShot);
			
			__background.visible = false;
			__mainHolder.visible = false;
			
			snapShot.alpha = 0;
			snapShot.scaleX = .3;
			snapShot.scaleY = .3;
			snapShot.y = Math.round((__height - snapShot.height) / 2);
			
			TweenMax.to(snapShot, Global.settings.time, {alpha:1, x:0, y:0, scaleX:1, scaleY:1, ease:Global.settings.easeInOut, onComplete:function () {
						removeChild(snapShot);
						snapShot = null;
						__background.visible = true;
						__mainHolder.visible = true;
						onTemplateOn();
						stage.mouseChildren = true;
						dispatchEvent(new CustomEvent(CustomEvent.TEMPLATE_ON));
						}});
		}
		
		public function off (_createTemplateOnFinish:Boolean = false):void {
			var snapShot = Rasterize.snapShot(this);
			addChild(snapShot);
			
			__background.visible = false;
			__mainHolder.visible = false;
			
			TweenMax.to(snapShot, Global.settings.time, {alpha:0, x:0, y:__height/2, scaleX:0, scaleY:0, ease:Global.settings.easeInOut, onComplete:function () {
						onTemplateOff();
						dispatchEvent(new CustomEvent(CustomEvent.TEMPLATE_OFF));
						}});
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
		private function createGradientFill(w:Number, h:Number, _colors:Array, _alphas:Array, _ratios:Array):Sprite{
			var r:Sprite = new Sprite;
			
			var fillType:String = GradientType.LINEAR;
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, h, Math.PI / 2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			r.graphics.beginGradientFill(fillType, _colors, _alphas, _ratios, matr, spreadMethod);  
			r.graphics.drawRect(0,0,w,h);
			
			return r;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}