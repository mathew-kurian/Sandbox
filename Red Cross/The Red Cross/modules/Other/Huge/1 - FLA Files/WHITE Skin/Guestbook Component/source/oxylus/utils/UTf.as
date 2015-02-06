/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/30/2009 (mm/dd/yyyy) */

class oxylus.utils.UTf {
	private function UTf() { trace("Static class. No instantiation.") }	
	
	/* Trim text field */
	public static function trim(tf:TextField, str:String, maxWidth:Number, endStr:String):Void {
		tf.autoSize = true;
		tf.text 	= str;
		
		if (tf.textWidth <= maxWidth) return;

		if(endStr == undefined) endStr = "...";
		tf.text = endStr;
		
		maxWidth -= tf.textWidth;
		tf.text = "O";
		maxWidth -= tf.textWidth;
		tf.text = "";
		
		for (var i = 0; i < str.length; i++) {
			tf.text += str.charAt(i);			
			if (tf.textWidth > maxWidth) {
				tf.text += endStr;
				break;
			}
		}
	}
	/* Initialize multiline html enabled text field */
	public static function initTextArea(tf:TextField, autoSize:Boolean):Void {
		tf.autoSize 		= autoSize;
		tf.multiline 		= true;
		tf.wordWrap 		= true;
		tf.html 			= true;
		tf.condenseWhite 	= true;
	}
	
	private static var TfSizeInfo:Object;
	private static var IdCount:Number = 0;
	/* Text Field size update handler. */
	public static function setSizeUpdateHandler(tf:TextField, handler:Function, scope:Object, checkInterval:Number):Void {
		if (TfSizeInfo == undefined) TfSizeInfo 	= new Object();
		if (isNaN(checkInterval)) checkInterval 	= 33;

		var tfId:String = "tfId" + String(IdCount++);
		if(TfSizeInfo[tfId]) clearInterval(TfSizeInfo[tfId].intId);
		
		TfSizeInfo[tfId] 		= { tf: tf, hnd: handler, scp: scope, w: tf.textWidth, h: tf.textHeight };
		TfSizeInfo[tfId].intId 	= setInterval(checkTfSize, checkInterval, tfId);
	}
	private static function checkTfSize(tfId:String):Void {
		var e:Object = TfSizeInfo[tfId];
		if (e.tf._name == undefined) {
			clearInterval(e.intId);
			delete TfSizeInfo[tfId];
		} else {
			if (e.w != e.tf.textWidth || e.h != e.tf.textHeight) {
				e.w = e.tf.textWidth;
				e.h = e.tf.textHeight;				
				e.hnd.call(e.scp);
			}
		}
	}
}