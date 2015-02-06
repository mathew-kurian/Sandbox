/**
 * IDecoder
 * URL Decoders Interface
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.BitmapData;
	//
	public interface IDecoder {
		function get data():Object;
		function set setLogo(bdLogo:BitmapData):void;
		function set setLogoHq(bdLogoHq:BitmapData):void;
		function get mediatype():String;
		function get tag():String;
		function decode(strURL:String):Boolean;
		function iscompatible(strURL:String):Boolean;
		function logo(boolHighQuality:Boolean = false):BitmapData;
		function reset():void;
		function url(boolHighQuality:Boolean = false):String;
	};
};