/**
 * IPlayer
 * Players Interface
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.DisplayObject;
	import flash.media.SoundChannel;
	//
	public interface IPlayer {
		function get align():String;
		function set align(strAlign:String):void;
		function get alignlogo():String;
		function set alignlogo(strAlign:String):void;
		function get alpha():Number;
		function set alpha(floatAlpha:Number):void;
		function get aspectRatio():Boolean;
		function set aspectRatio(boolAspectratio:Boolean):void;
		function get autoStart():Boolean;
		function set autoStart(boolAutostart:Boolean):void;
		function get buffering():Object;
		function get bufferTime():Number;
		function set bufferTime(floatBuffer:Number):void;
		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap(boolCacheAsBitmap:Boolean):void;
		function get context():*;
		function set context(loaderContext:*):void;
		function get controls():Object;
		function get current():Number;
		function set current(floatCurrent:Number):void;
		function get duration():Number;
		function get height():Number;
		function set height(floatHeight:Number):void;
		function get loaded():Number;
		function get mask():DisplayObject;
		function set mask(objMask:DisplayObject):void;
		function get mediaEnd():Boolean;
		function get mediaInfo():Object;
		function get mediaMetrics():Object;
		function get mediaType():String;
		function get playing():Boolean;
		function get plugin():IPlayer;
		function set plugin(objPlugin:IPlayer):void;
		function get ready():Boolean;
		function get repeat():Boolean;
		function set repeat(boolRepeat:Boolean):void;
		function get rotation():Number;
		function set rotation(floatRotation:Number):void;
		function get scaleX():Number;
		function set scaleX(floatScaleX:Number):void;
		function get scaleY():Number;
		function set scaleY(floatScaleY:Number):void;
		function get smoothing():Boolean;
		function set smoothing(boolSmoothing:Boolean):void;
		function get snapshot():Object;
		function get time():Number;
		function set time(floatTime:Number):void;
		function get ttl():Number;
		function set ttl(floatTTL:Number):void;
		function get visible():Boolean;
		function set visible(boolVisible:Boolean):void;
		function get volume():Number;
		function set volume(floatVolume:Number):void;
		function get wallpaper():Boolean;
		function set wallpaper(boolWallpaper:Boolean):void;
		function get width():Number;
		function set width(floatWidth:Number):void;
		function get x():Number;
		function set x(floatX:Number):void;
		function get y():Number;
		function set y(floatY:Number):void;
		function iscompatible(strURL:String):Boolean;
		function load(strPath:String, boolHighQuality:Boolean = false):Boolean;
		function pause():void;
		function play(soundChannel:SoundChannel = undefined):void;
		function reset():void;
		function resize(floatHeight:Number, floatWidth:Number):void;
	};
};