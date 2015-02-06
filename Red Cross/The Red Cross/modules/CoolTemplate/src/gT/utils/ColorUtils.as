package gT.utils {
	
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	import flash.display.DisplayObject;
	
	public class ColorUtils {
		
		public static function tint(target:Object, color:Number):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			target.transform.colorTransform = colorTransform;
		}
		
		public static function exposure (target:DisplayObject, exposure:Number):void {
			var colorTransform:ColorTransform = new ColorTransform;
			colorTransform.redOffset = exposure; 
			colorTransform.greenOffset = exposure; 
			colorTransform.blueOffset = exposure;
			
			target.transform.colorTransform = colorTransform;
		}
		
		public static function hexStringToNumber(hexStr:String):Number{
			if(hexStr.length != 7){
				return -1;
			}
			if(hexStr.charAt(0) != "#"){
				return -1;
			}
			var newStr:String = hexStr.substr(1,6);
			var numStr:String = "0x"+newStr;
			var num:Number = Number(numStr);
			return num;
		}
		
		public static function numberToHexString(number:Number):String
		{
			var hexStr:String = number.toString(16);
			
			while(hexStr.length < 6){
				hexStr = "0"+hexStr;
			}
			
			hexStr = "#"+hexStr;
			
			return hexStr;
		}
		
		public static function desaturation(target:DisplayObject):void{
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter([
																   .5, .5, .5, 0, 0,
																   .5, .5, .5, 0, 0,
																   .5, .5, .5, 0, 0,
																   0, 0, 0, 1, 0
																   ]);
			target.filters=[my_filter];
		}
	}
}