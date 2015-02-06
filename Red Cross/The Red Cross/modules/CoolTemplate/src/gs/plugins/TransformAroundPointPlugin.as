/*
VERSION: 1.02
DATE: 1/29/2009
ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
	point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
	transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
	want to scale from its center or rotate around a particular point on the stage. 
	
	If you define an x or y value in the transformAroundPoint object, it will correspond to the custom registration
	point which makes it easy to position (as opposed to having to figure out where the original registration point 
	should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
	the transformAroundPoint object, like :
	TweenLite.to(mc, 3, {x:50, y:40, transformAroundPoint:{point:new Point(200, 300), scale:0.5, rotation:30}});
	
	TransformAroundPointPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
	without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([TransformAroundPointPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(mc, 1, {transformAroundPoint:{point:new Point(100, 300), scaleX:2, scaleY:1.5, rotation:150}});

	
BYTES ADDED TO SWF: 745 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

package gs.plugins {
	import flash.display.*;
	import flash.geom.Point;
	
	import gs.*;
	import gs.utils.tween.TweenInfo;
	
	public class TransformAroundPointPlugin extends TweenPlugin {
		public static const VERSION:Number = 1.02;
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		protected var _target:DisplayObject;
		protected var _local:Point;
		protected var _point:Point;
		protected var _shortRotation:ShortRotationPlugin;
		
		public function TransformAroundPointPlugin() {
			super();
			this.propName = "transformAroundPoint";
			this.overwriteProps = [];
		}
		
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			if (!($value.point is Point)) {
				return false;
			}
			_target = $target as DisplayObject;
			_point = $value.point.clone();
			_local = _target.globalToLocal(_target.parent.localToGlobal(_point));
			if ($value.isTV == true) {
				$value = $value.exposedVars; //for compatibility with TweenLiteVars and TweenMaxVars
			}
			var p:String, short:ShortRotationPlugin, sp:String;
			for (p in $value) {
				if (p == "point") {
					//ignore - we already set it above
				} else if (p == "shortRotation") {
					_shortRotation = new ShortRotationPlugin();
					_shortRotation.onInitTween(_target, $value[p], $tween);
					addTween(_shortRotation, "changeFactor", 0, 1, "shortRotation");
					for (sp in $value[p]) {
						this.overwriteProps[this.overwriteProps.length] = sp;
					}
				} else if (p == "x" || p == "y") {
					addTween(_point, p, _point[p], $value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				} else if (p == "scale") {
					addTween(_target, "scaleX", _target.scaleX, $value.scale, "scaleX");
					addTween(_target, "scaleY", _target.scaleY, $value.scale, "scaleY");
					this.overwriteProps[this.overwriteProps.length] = "scaleX";
					this.overwriteProps[this.overwriteProps.length] = "scaleY";
				} else {
					addTween(_target, p, _target[p], $value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				}
			}
			
			if ($tween != null) {
				if ("x" in $tween.exposedVars || "y" in $tween.exposedVars) { //if the tween is supposed to affect x and y based on the original registration point, we need to make special adjustments here...
					var endX:Number, endY:Number;
					if ("x" in $tween.exposedVars) {
						endX = (typeof($tween.exposedVars.x) == "number") ? $tween.exposedVars.x : _target.x + Number($tween.exposedVars.x);
					}
					if ("y" in $tween.exposedVars) {
						endY = (typeof($tween.exposedVars.y) == "number") ? $tween.exposedVars.y : _target.y + Number($tween.exposedVars.y);
					}
					$tween.killVars({x:true, y:true}); //we're taking over.
					this.changeFactor = 1;
					if (!isNaN(endX)) {
						addTween(_point, "x", _point.x, _point.x + (endX - _target.x), "x");
						this.overwriteProps[this.overwriteProps.length] = "x";
					}
					if (!isNaN(endY)) {
						addTween(_point, "y", _point.y, _point.y + (endY - _target.y), "y");
						this.overwriteProps[this.overwriteProps.length] = "y";
					}
					this.changeFactor = 0;
				}
			}
			
			return true;
		}
		
		override public function killProps($lookup:Object):void {
			if (_shortRotation != null) {
				_shortRotation.killProps($lookup);
				if (_shortRotation.overwriteProps.length == 0) {
					$lookup.shortRotation = true;
				}
			}
			super.killProps($lookup);
		}
		
		override public function set changeFactor($n:Number):void {
			var p:Point, i:int, ti:TweenInfo;
			if (this.round) {
				var val:Number, neg:int, x:Number, y:Number, negX:int, negY:int;
				for (i = _tweens.length - 1; i > -1; i--) {
					ti = _tweens[i];
					val = ti.start + (ti.change * $n);
					neg = (val < 0) ? -1 : 1;
					ti.target[ti.property] = ((val % 1) * neg > 0.5) ? int(val) + neg : int(val); //twice as fast as Math.round()
				}
				p = _target.parent.globalToLocal(_target.localToGlobal(_local));
				x = _target.x + _point.x - p.x;
				y = _target.y + _point.y - p.y;
				negX = (x < 0) ? -1 : 1;
				negY = (y < 0) ? -1 : 1;
				_target.x = ((x % 1) * negX > 0.5) ? int(x) + negX : int(x); //twice as fast as Math.round()
				_target.y = ((y % 1) * negY > 0.5) ? int(y) + negY : int(y); //twice as fast as Math.round()
			} else {
				for (i = _tweens.length - 1; i > -1; i--) {
					ti = _tweens[i];
					ti.target[ti.property] = ti.start + (ti.change * $n);
				}
				p = _target.parent.globalToLocal(_target.localToGlobal(_local));
				_target.x += _point.x - p.x;
				_target.y += _point.y - p.y;
			}
			_changeFactor = $n;
		}

	}
}