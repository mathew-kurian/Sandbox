/*
VERSION: 1.01
DATE: 1/8/2009
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Normally, all transformations (scale, rotation, and position) are based on the MovieClip's registration
	point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
	transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
	want to scale from its center or rotate around a particular point on the stage. 
	
	If you define an _x or _y value in the transformAroundPoint object, it will correspond to the custom registration
	point which makes it easy to position (as opposed to having to figure out where the original registration point 
	should tween to). If you prefer to define the _x/_y in relation to the original registration point, do so outside 
	the transformAroundPoint object, like :
	TweenLite.to(mc, 3, {_x:50, _y:40, transformAroundPoint:{point:new Point(200, 300), scale:50, _rotation:30}});
	
	TransformAroundPointPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
	without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([TransformAroundPointPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(mc, 1, {transformAroundPoint:{point:new Point(100, 300), _xscale:200, _yscale:150, _rotation:60}});

	
BYTES ADDED TO SWF: 814 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

import flash.geom.Point;

import gs.*;
import gs.plugins.*;
import gs.utils.tween.*;

class gs.plugins.TransformAroundPointPlugin extends TweenPlugin {
		public static var VERSION:Number = 1.01;
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		private var _target:MovieClip;
		private var _local:Point;
		private var _point:Point;
		private var _temp:Point; //speeds things up when doing localToGlobal and globalToLocal.
		private var _shortRotation:ShortRotationPlugin;
		
		public function TransformAroundPointPlugin() {
			super();
			this.propName = "transformAroundPoint";
			this.overwriteProps = [];
		}
		
		public function onInitTween($target:Object, $value:Object, $tween:TweenLite):Boolean {
			if (!($value.point instanceof Point)) {
				return false;
			}
			_target = MovieClip($target);
			_point = $value.point.clone();
			_local = _point.clone();
			_target._parent.localToGlobal(_local);
			_target.globalToLocal(_local);
			_temp = _local.clone();
			
			var p:String, short:ShortRotationPlugin, sp:String, pp:String;
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
				} else if (p == "_x" || p == "_y") {
					pp = (p == "_x") ? "x" : "y"; //point property (x instead of _x and y instead of _y)
					addTween(_point, pp, _point[pp], $value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				} else if (p == "scale") {
					addTween(_target, "_xscale", _target._xscale, $value.scale, "_xscale");
					addTween(_target, "_yscale", _target._yscale, $value.scale, "_yscale");
					this.overwriteProps[this.overwriteProps.length] = "_xscale";
					this.overwriteProps[this.overwriteProps.length] = "_yscale";
				} else {
					addTween(_target, p, _target[p], $value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				}
			}
			
			if ($tween.vars._x != undefined || $tween.vars._y != undefined) { //if the tween is supposed to affect _x and _y based on the original registration point, we need to make special adjustments here...
				var endX:Number, endY:Number;
				if ($tween.vars._x != undefined) {
					endX = (typeof($tween.vars._x) == "number") ? $tween.vars._x : _target._x + Number($tween.vars._x);
				}
				if ($tween.vars._y != undefined) {
					endY = (typeof($tween.vars._y) == "number") ? $tween.vars._y : _target._y + Number($tween.vars._y);
				}
				$tween.killVars({_x:true, _y:true}); //we're taking over.
				this.changeFactor = 1;
				if (!isNaN(endX)) {
					addTween(_point, "x", _point.x, _point.x + (endX - _target._x), "_x");
					this.overwriteProps[this.overwriteProps.length] = "_x";
				}
				if (!isNaN(endY)) {
					addTween(_point, "y", _point.y, _point.y + (endY - _target._y), "_y");
					this.overwriteProps[this.overwriteProps.length] = "_y";
				}
				this.changeFactor = 0;
			}
			
			return true;
		}
		
		public function killProps($lookup:Object):Void {
			if (_shortRotation != undefined) {
				_shortRotation.killProps($lookup);
				if (_shortRotation.overwriteProps.length == 0) {
					$lookup.shortRotation = true;
				}
			}
			super.killProps($lookup);
		}
		
		public function set changeFactor($n:Number):Void {
			_temp.x = _local.x;
			_temp.y = _local.y;
			var i:Number, ti:TweenInfo;
			if (this.round) {
				for (i = _tweens.length - 1; i > -1; i--) {
					ti = _tweens[i];
					ti.target[ti.property] = Math.round(ti.start + (ti.change * $n));
				}
				_target.localToGlobal(_temp);
				_target._parent.globalToLocal(_temp);
				_target._x = Math.round(_target._x + _point.x - _temp.x);
				_target._y = Math.round(_target._y + _point.y - _temp.y);
			} else {
				for (i = _tweens.length - 1; i > -1; i--) {
					ti = _tweens[i];
					ti.target[ti.property] = ti.start + (ti.change * $n);
				}
				_target.localToGlobal(_temp);
				_target._parent.globalToLocal(_temp);
				_target._x += _point.x - _temp.x;
				_target._y += _point.y - _temp.y;
			}
		}

}