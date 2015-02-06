/*
VERSION: 1.02
DATE: 1/29/2009
ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
	point (most often its upper left corner), but TransformAroundCenter allows you to make the transformations
	occur around the DisplayObject's center. 
	
	If you define an x or y value in the transformAroundCenter object, it will correspond to the center which 
	makes it easy to position (as opposed to having to figure out where the original registration point 
	should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
	the transformAroundCenter object, like :
	TweenLite.to(mc, 3, {x:50, y:40, transformAroundCenter:{point:new Point(200, 300), scale:0.5, rotation:30}});
	
	TransformAroundCenterPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
	without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([TransformAroundCenterPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(mc, 1, {transformAroundCenter:{scale:1.5, rotation:150}});

	
BYTES ADDED TO SWF: 229 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

package gs.plugins {
	import flash.display.*;
	import flash.geom.*;
	
	import gs.*;
	
	public class TransformAroundCenterPlugin extends TransformAroundPointPlugin {
		public static const VERSION:Number = 1.02;
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		public function TransformAroundCenterPlugin() {
			super();
			this.propName = "transformAroundCenter";
		}
		
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			var remove:Boolean = false;
			if ($target.parent == null) {
				remove = true;
				var s:Sprite = new Sprite();
				s.addChild($target as DisplayObject);
			}
			var b:Rectangle = $target.getBounds($target.parent);
			$value.point = new Point(b.x + (b.width / 2), b.y + (b.height / 2));
			if (remove) {
				$target.parent.removeChild($target);
			}
			return super.onInitTween($target, $value, $tween);
		}
		
	}
}