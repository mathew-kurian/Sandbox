/*
VERSION: 1.0
DATE: 1/8/2009
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Normally, all transformations (scale, rotation, and position) are based on the MovieClip's registration
	point (most often its upper left corner), but TransformAroundCenter allows you to have all transformations
	occur around the MovieClip's center. For example, you may have a dynamically-loaded image that you 
	want to scale from its center or rotate around a particular point on the stage. 
	
	If you define an _x or _y value in the transformAroundCenter object, it will correspond to the center 
	which makes it easy to position (as opposed to having to figure out where the original registration point 
	should tween to). If you prefer to define the _x/_y in relation to the original registration point, do so outside 
	the transformAroundCenter object, like :
	TweenLite.to(mc, 3, {_x:50, _y:40, transformAroundPoint:{point:new Point(200, 300), scale:50, _rotation:30}});
	
	TransformAroundPointPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
	without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([TransformAroundCenterPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(mc, 1, {transformAroundCenter:{scale:150, _rotation:60}});

	
BYTES ADDED TO SWF: 151 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/
import flash.geom.*;
import gs.*;
import gs.plugins.*;

class gs.plugins.TransformAroundCenterPlugin extends TransformAroundPointPlugin {
		public static var VERSION:Number = 1.0;
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		public function TransformAroundCenterPlugin() {
			super();
			this.propName = "transformAroundCenter";
		}
		
		public function onInitTween($target:Object, $value:Object, $tween:TweenLite):Boolean {
			var b:Object = $target.getBounds($target._parent);
			$value.point = new Point((b.xMin + b.xMax) / 2, (b.yMin + b.yMax) / 2);
			return super.onInitTween($target, $value, $tween);
		}
		
}