/*
VERSION: 0.91
DATE: 1/31/2009
ACTIONSCRIPT VERSION: 2.0 (Requires Flash Player 8)
DESCRIPTION: 
	TweenProxy essentially "stands in" for a MovieClip, adding several tweenable properties as well as the
	ability to set a custom registration point around which all transformations (like rotation, scale, and skew) 
	occur. In addition to all the standard MovieClip properties, TweenProxy adds:
		
		- registration : Point
		- registrationX : Number
		- registrationY : Number
		- localRegistration : Point
		- localRegistrationX : Number
		- localRegistrationY : Number
		- skewX : Number
		- skewY : Number
		- skewX2 : Number
		- skewY2 : Number
		- scale : Number
	
	Tween the skewX and/or skewY for normal skews (which visually adjust scale to compensate), or skewX2 and/or skewY2 
	in order to skew without visually adjusting scale.
	
	The "registration" point is based on the MovieClip's parent's coordinate space whereas the "localRegistration" corresponds 
	to the MovieClip's inner coordinates, so it's very simple to define the registration point whichever way you prefer.
	
	Once you create a TweenProxy, it is best to always control your MovieClip's properties through the 
	TweenProxy so that the values don't become out of sync. You can set ANY MovieClip property through the TweenProxy, 
	and you can call MovieClip methods as well. If you directly change the properties of the target (without going through the proxy), 
	you'll need to call the	calibrate() method on the proxy. It's usually best to create only ONE proxy for each target, but if 
	you create more than one, they will communicate with each other to keep the transformations and registration position in sync
	(unless you set ignoreSiblingUpdates to true).
	
	
EXAMPLE:

	To set a custom registration piont of x:100, y:100, and tween the skew of a MovieClip named "my_mc" 30 degrees 
	on the x-axis and scale to half-size over the course of 3 seconds using an Elastic ease, do:
	
	import gs.*;
	import gs.utils.*;
	import gs.easing.*;
	
	var myProxy:TweenProxy = new TweenProxy(my_mc);
	myProxy.registration = new Point(100, 100);
	TweenLite.to(myProxy, 3, {skewX:30, scale:0.5, ease:Elastic.easeOut});
	

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/


import flash.geom.*;

import mx.utils.*;
	
dynamic class gs.utils.TweenProxy {
		public static var VERSION:Number = 0.91;
		private static var _DEG2RAD:Number = Math.PI / 180; //precompute for speed
		private static var _RAD2DEG:Number = 180 / Math.PI; //precompute for speed
		private static var _dict:Object = new Object();
		private static var _classInitted:Boolean;
		private var _target:MovieClip;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _angle:Number;
		private var _proxies:Array; //populated with all TweenProxy instances with the same _target (basically a faster way to access _dict[_target])
		private var _localRegistration:Point; //according to the local coordinates of _target (not _target._parent)
		private var _registration:Point; //according to _target._parent coordinates
		private var _regAt0:Boolean; //If the localRegistration point is at 0, 0, this is true. We just use it to speed up processing in getters/setters.
		
		public var ignoreSiblingUpdates:Boolean = false;
		public var isTweenProxy:Boolean = true; //potentially checked by TweenLite
		
		public function TweenProxy($target:MovieClip, $ignoreSiblingUpdates:Boolean) {
			_target = $target;
			if (_dict[_target] == undefined) {
				_dict[_target] = [];
			}
			if (!_classInitted) {
				var properties:Array = ["blendMode","cacheAsBitmap","_currentframe","_droptarget","enabled","filters","focusEnabled","_focusrect","forceSmoothing","_framesloaded","_highquality","hitArea","_lockroot","menu","_name","opaqueBackground","_parent","_quality","scale9Grid","scrollRect","_soundbuftime","tabChildren","tabEnabled","tabIndex","_totalframes","trackAsMenu","transform","_url","useHandCursor","_visible","_xmouse","_ymouse"];
				var i:Number;
				for (i = 0; i < properties.length; i++) {
					TweenProxy.prototype.addProperty(properties[i], createIndexGetter(properties[i]), createIndexSetter(properties[i])); 
				}
				var functions:Array = ["attachAudio","attachBitmap","attachMovie","beginBitmapFill","beginFill","beginGradientFill","clear","createEmptyMovieClip","createTextField","curveTo","duplicateMovieClip","endFill","getBounds","getBytesLoaded","getBytesTotal","getDepth","getInstanceAtDepth","getNextHighestDepth","getRect","getSWFVersion","getTextSnapshot","getURL","globalToLocal","gotoAndPlay","gotoAndStop","hitTest","lineGradientStyle","lineStyle","lineTo","loadMovie","loadVariables","localToGlobal","moveTo","nextFrame","play","prevFrame","removeMovieClip","setMask","startDrag","stop","stopDrag","swapDepths","unloadMovie"];
				for (i = 0; i < functions.length; i++) {
					this[functions[i]]();
				}
				_classInitted = true;
			}
			_proxies = _dict[_target];
			_proxies.push(this);
			_localRegistration = new Point(0, 0);
			this.ignoreSiblingUpdates = ($ignoreSiblingUpdates == undefined) ? false : $ignoreSiblingUpdates;
			calibrateRegistration();
			calibrate();
		}
		
		public static function create($target:MovieClip, $allowRecycle:Boolean):TweenProxy {
			if (_dict[$target] != undefined && $allowRecycle != false) {
				return _dict[$target][0];
			} else {
				return new TweenProxy($target);
			}
		}
		
		public function getCenter():Point {
			var b:Object = _target.getBounds(_target._parent);
			return new Point((b.xMin + b.xMax) / 2, (b.yMin + b.yMax) / 2);
		}
		
		public function get target():MovieClip {
			return _target;
		}
		
		public function calibrate():Void {
			_scaleX = _target._xscale / 100;
			_scaleY = _target._yscale / 100;
			_angle = _target._rotation * _DEG2RAD;
		}
		
		public function destroy():Void {
			var a:Array = _dict[_target], i:Number;
			for (i = a.length - 1; i > -1; i--) {
				if (a[i] == this) {
					a.splice(i, 1);
				}
			}
			if (a.length == 0) {
				delete _dict[_target];
			}
		}
		
		
//---- PROXY FUNCTIONS ------------------------------------------------------------------------------------------
		
		private static function createIndexGetter($property:String):Function {
			return function():Object {return _target[$property]};
		}
		private static function createIndexSetter($property:String):Function {
			return function($value:Object):Void {this.onSetProperty($property, $value);};
		}
		
		public function __resolve($name:String):Object {
			if (_target[$name] instanceof Function) {
				var f:Function = function():Object {
			        arguments.unshift($name);
					return this.onCallProperty.apply(this, arguments); 
			    };
			    TweenProxy.prototype[$name] = f;
			    return f(arguments);
			} else {
				return _target[$name];
			}
		}
		
		private function onCallProperty($name:String):Object {
			arguments.shift();
			return _target[$name].apply(_target, arguments);;
		}
		
		private function onSetProperty($prop:Object, $value:Object):Void {
			_target[$prop] = $value;
		}
		

//---- GENERAL REGISTRATION -----------------------------------------------------------------------
		
		public function moveRegX($n:Number):Void {
			_registration.x += $n;
		}
		
		public function moveRegY($n:Number):Void {
			_registration.y += $n;
		}
		
		private function reposition():Void {
			var p:Point = _localRegistration.clone();
			_target.localToGlobal(p);
			_target._parent.globalToLocal(p);
			_target._x += _registration.x - p.x;
			_target._y += _registration.y - p.y;
		}
		
		private function updateSiblingProxies():Void {
			for (var i:Number = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] != this) {
					_proxies[i].onSiblingUpdate(_scaleX, _scaleY, _angle);
				}
			}
		}
		
		private function calibrateLocal():Void {
			_localRegistration = _registration.clone();
			_target._parent.localToGlobal(_localRegistration);
			_target.globalToLocal(_localRegistration);
			_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0);
		}
		
		private function calibrateRegistration():Void {
			_registration = _localRegistration.clone();
			_target.localToGlobal(_registration);
			_target._parent.globalToLocal(_registration);
			_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0);
		}
		
		public function onSiblingUpdate($scaleX:Number, $scaleY:Number, $angle:Number):Void {
			_scaleX = $scaleX;
			_scaleY = $scaleY;
			_angle = $angle;
			if (this.ignoreSiblingUpdates) {
				calibrateLocal();
			} else {
				calibrateRegistration();
			}
		}
		
		
//---- LOCAL REGISTRATION ---------------------------------------------------------------------------
		
		public function get localRegistration():Point {
			return _localRegistration;
		}
		public function set localRegistration($p:Point):Void {
			_localRegistration = $p;
			calibrateRegistration();
		}
		
		public function get localRegistrationX():Number {
			return _localRegistration.x;
		}
		public function set localRegistrationX($n:Number):Void {
			_localRegistration.x = $n;
			calibrateRegistration();
		}
		
		public function get localRegistrationY():Number {
			return _localRegistration.y;
		}
		public function set localRegistrationY($n:Number):Void {
			_localRegistration.y = $n;
			calibrateRegistration();
		}
		
		
//---- REGISTRATION (OUTER) ----------------------------------------------------------------------
		
		public function get registration():Point {
			return _registration
		}
		public function set registration($p:Point):Void {
			_registration = $p;
			calibrateLocal();
		}
		
		public function get registrationX():Number {
			return _registration.x;
		}
		public function set registrationX($n:Number):Void {
			_registration.x = $n;
			calibrateLocal();
		}
		
		public function get registrationY():Number {
			return _registration.y;
		}
		public function set registrationY($n:Number):Void {
			_registration.y = $n;
			calibrateLocal();
		}
		
		
//---- X/Y MOVEMENT ---------------------------------------------------------------------------------
		
		public function get x():Number {
			return _registration.x;
		}
		public function set x($n:Number):Void {
			var tx:Number = ($n - _registration.x);
			_target.x += tx;
			for (var i:Number = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegX(tx);
				}
			}
		}
		
		public function get y():Number {
			return _registration.y;
		}
		public function set y($n:Number):Void {
			var ty:Number = ($n - _registration.y);
			_target.y += ty;
			for (var i:Number = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegY(ty);
				}
			}
		}
		
	
//---- ROTATION ----------------------------------------------------------------------------
		
		public function get rotation():Number {
			return _angle * _RAD2DEG;
		}
		public function set rotation($n:Number):Void {
			var radians:Number = $n * _DEG2RAD;
			var m:Matrix = _target.transform.matrix;
			m.rotate(radians - _angle);
			_target.transform.matrix = m;
			//_target._rotation = $n; //a bug in the Flash Player prevents the transform.matrix edit from updating the actual _rotation value, so this explicitly sets it.
			_angle = radians;
			reposition();
			
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
//---- SKEW -------------------------------------------------------------------------------
		
		public function get skewX():Number {
			var m:Matrix = _target.transform.matrix;
			return (Math.atan2(-m.c, m.d) - _angle) * _RAD2DEG;
		}
		public function set skewX($n:Number):Void {
			var radians:Number = $n * _DEG2RAD;
			var m:Matrix = _target.transform.matrix;
			var sy:Number = (_scaleY < 0) ? -_scaleY : _scaleY;
			m.c = -sy * Math.sin(radians + _angle);
			m.d =  sy * Math.cos(radians + _angle);
			_target.transform.matrix = m;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get skewY():Number {
			var m:Matrix = _target.transform.matrix;
			return (Math.atan2(m.b, m.a) - _angle) * _RAD2DEG;
		}
		public function set skewY($n:Number):Void {
			var radians:Number = $n * _DEG2RAD;
			var m:Matrix = _target.transform.matrix;
			var sx:Number = (_scaleX < 0) ? -_scaleX : _scaleX;
			m.a = sx * Math.cos(radians + _angle);
			m.b = sx * Math.sin(radians + _angle);
			_target.transform.matrix = m;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
		
//---- SKEW2 ----------------------------------------------------------------------------------
		
		public function get skewX2():Number {
			return (-Math.atan(_target.transform.matrix.c) - _angle) * _RAD2DEG;
		}
		public function set skewX2($n:Number):Void {
			var m:Matrix = _target.transform.matrix;
			m.c = Math.tan((-$n * _DEG2RAD) + _angle);
			_target.transform.matrix = m;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get skewY2():Number {
			return (Math.atan(_target.transform.matrix.b) - _angle) * _RAD2DEG;
		}
		public function set skewY2($n:Number):Void {
			var m:Matrix = _target.transform.matrix;
			m.b = Math.tan(($n * _DEG2RAD) + _angle);
			_target.transform.matrix = m;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
//---- SCALE --------------------------------------------------------------------------------------
		
		public function get scaleX():Number {
			return _scaleX;
		}
		public function set scaleX($n:Number):Void {
			var m:Matrix = _target.transform.matrix;
			var ratio:Number = $n / _scaleX;
			m.a *= ratio;
			m.b *= ratio;
			_target.transform.matrix = m;
			//_target._xscale = $n * 100; //a bug in the Flash Player prevents the transform.matrix edit from updating the actual _xscale value, so this explicitly sets it.
			_scaleX = $n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get scaleY():Number {
			return _scaleY;
		}
		public function set scaleY($n:Number):Void {
			var m:Matrix = _target.transform.matrix;
			var ratio:Number = $n / _scaleY;
			m.c *= ratio;
			m.d *= ratio;
			_target.transform.matrix = m;
			//_target._yscale = $n * 100; //a bug in the Flash Player prevents the transform.matrix edit from updating the actual _yscale value, so this explicitly sets it.
			_scaleY = $n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		public function get scale():Number {
			return (_scaleX + _scaleY) / 2;
		}
		public function set scale($n:Number):Void {
			var m:Matrix = _target.transform.matrix;
			var ratioX:Number = $n / _scaleX;
			var ratioY:Number = $n / _scaleY;
			m.a *= ratioX;
			m.b *= ratioX;
			m.c *= ratioY;
			m.d *= ratioY;
			_target.transform.matrix = m;
			_scaleX = _scaleY = $n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
			
		}
		
		
//---- OTHER PROPERTIES ---------------------------------------------------------------------------------
		
		public function get _x():Number {
			return this.x;
		}
		public function set _x($n:Number):Void {
			this.x = $n;
		}
		public function get _y():Number {
			return this.y;
		}
		public function set _y($n:Number):Void {
			this.y = $n;
		}
		public function get _alpha():Number {
			return _target._alpha;
		}
		public function set _alpha($n:Number):Void {
			_target._alpha = $n;
		}
		public function get _xscale():Number {
			return _scaleX * 100;
		}
		public function set _xscale($n:Number):Void {
			this.scaleX = $n / 100;
		}
		public function get _yscale():Number {
			return _scaleY * 100;
		}
		public function set _yscale($n:Number):Void {
			this.scaleY = $n / 100;
		}
		public function get _width():Number {
			return _target._width;
		}
		public function set _width($n:Number):Void {
			_target._width = $n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get _height():Number {
			return _target._height;
		}
		public function set _height($n:Number):Void {
			_target._height = $n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get _rotation():Number {
			return _angle * _RAD2DEG;
		}
		public function set _rotation($n:Number):Void {
			this.rotation = $n;
		}
}