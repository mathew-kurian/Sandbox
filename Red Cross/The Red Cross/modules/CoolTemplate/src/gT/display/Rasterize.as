package gT.display
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;

	public class Rasterize extends Bitmap 
	{	
		
		public static function snapShot (target:DisplayObject, w:Number = NaN, h:Number = NaN, offsetX:Number = 0, offsetY:Number = 0, smoothing:Boolean = true, transparent:Boolean = true):Bitmap 
		{			
			
			var sx = target.scaleX;
			var sy = target.scaleY;
			
			var box = new Object();
			if (w) { box.width = w} else { box.width = target.width };
			if (h) { box.height = h} else { box.height = target.height };
			
			var clon = new BitmapData(box.width / sx, box.height / sy, true, 0xffffff);
			clon.draw(target, new Matrix(1, 0, 0, 1, offsetX / sx, offsetY / sy));
			
			var bmpClon:Bitmap = new Bitmap(clon);
			bmpClon.width = box.width;
			bmpClon.height = box.height;
			
			var holderTemp = new Sprite();
			holderTemp.addChild(bmpClon);	
			
			var bmpData = new BitmapData(box.width, box.height, transparent, 0xffffff);
			bmpData.draw(holderTemp);
			
			clon = null;
			bmpClon = null;
			holderTemp = null;
			target = null;
			
			return new Bitmap(bmpData, "auto", smoothing);
		}
		
		public static function displayObject(target:DisplayObject, w:Number = NaN, h:Number = NaN, offsetX:Number = 0, offsetY:Number = 0, smoothing:Boolean = true, transparent:Boolean = true):Bitmap
		{
			var tempHolder:Sprite = new Sprite;
			tempHolder.addChild(target);

			var clon = new BitmapData(tempHolder.width, tempHolder.height, transparent, 0xff0000);
			clon.draw(tempHolder, new Matrix(1, 0, 0, 1, offsetX, offsetY));
			
			return new Bitmap(clon, "never", smoothing);
		}
		
		public static function text (target:TextField, resolution:Number = 1):Bitmap 
		{
			target.x = target.y = 0;
			var holder:Sprite = new Sprite;
			holder.addChild(target);
			holder.scaleX = holder.scaleY = resolution;
			
			var snap = displayObject(holder);
			
			snap.scaleX = snap.scaleY = 1 / resolution;
			return snap;
		}
	}
}