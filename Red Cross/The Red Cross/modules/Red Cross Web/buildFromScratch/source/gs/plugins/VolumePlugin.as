/*
VERSION: 1.0
DATE: 1/8/2009
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Tweens the volume of a MovieClip or Sound
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([VolumePlugin]); //only do this once in your SWF to activate the plugin (it is already activated in TweenLite and TweenMax by default)
	
	TweenLite.to(mc, 1, {volume:0});
	
	
BYTES ADDED TO SWF: 287 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/
import gs.*;
import gs.plugins.*;

class gs.plugins.VolumePlugin extends TweenPlugin {
		public static var VERSION:Number = 1.0;
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		public var volume:Number;
		
		private var _sound:Sound;
		
		public function VolumePlugin() {
			super();
			this.propName = "volume";
			this.overwriteProps = ["volume"];
		}
		
		public function onInitTween($target:Object, $value:Object, $tween:TweenLite):Boolean {
			if (isNaN($value) || (typeof($target) != "movieclip" && !($target instanceof Sound))) {
				return false;
			}
			_sound = (typeof($target) == "movieclip") ? new Sound($target) : Sound($target);
			addTween(this, "volume", _sound.getVolume(), $value, "volume");
			return Boolean(_tweens.length != 0);
		}
		
		public function set changeFactor($n:Number):Void {
			updateTweens($n);
			_sound.setVolume(this.volume);
		}
	
}