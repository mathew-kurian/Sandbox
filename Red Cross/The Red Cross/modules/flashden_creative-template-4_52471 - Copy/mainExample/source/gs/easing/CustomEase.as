/*
VERSION: 0.91
DATE: 8/17/2008
ACTIONSCRIPT VERSION: 2 (AS3 version is also available)
UPDATES AT: http://blog.greensock.com 
DESCRIPTION:
	Facilitates creating custom bezier eases with the GreenSock Custom Ease Builder tool. It's essentially
	a place to store the bezier segment information for each ease instead of recreating it inside each
	function call which would slow things down. Please use the interactive tool available at 
	http://blog.greensock.com/customease/ to generate the necessary code.
	
	
CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

import mx.utils.Delegate;

class gs.easing.CustomEase {
	public static var VERSION:Number = 0.91;
	private static var _all:Object = {}; //keeps track of all CustomEase instances.
	private var _segments:Array;
	private var _name:String;
	public var ease:Function;
	
	public static function create($name:String, $segments:Array):Function {
		var b:CustomEase = new CustomEase($name, $segments);
		return b.ease;
	}
	
	public static function byName($name:String):Function {
		return _all[$name].ease;
	}
	
	public function CustomEase($name:String, $segments:Array) {
		_name = $name;
		_segments = $segments;
		_all[$name] = this;
		this.ease = Delegate.create(this, easeProxy); //to ensure scope is right.
	}
	
	public function easeProxy($t:Number, $b:Number, $c:Number, $d:Number):Number {
		var factor:Number = $t / $d, qty:Number = _segments.length, t:Number, b:Object;
		var i:Number = Math.floor(qty * factor);
		t = (factor - (i * (1 / qty))) * qty;
		b = _segments[i];
		return $b + $c * (b.s + t * (2 * (1 - t) * (b.cp - b.s) + t * (b.e - b.s)));
	}
	
	public function destroy():Void {
		_segments = null;
		delete _all[_name];
	}
		
}