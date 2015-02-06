class AnimTween {
	var Value_array:Array;
	var Name_array:Array;
	var Begin_array:Array;
	var Change_array:Array;
	var myString:String;
	
	//----TWEENS--------------------------------------------------------------------------------------
	//LINEAR
	function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	//ELASTIC
	function easeInElastic (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	}
	function easeOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
	}
	function easeInOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	}
	//CUBIC
	function easeInCubic (t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t*t + b;
	}
	function easeOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
		return c*((t=t/d-1)*t*t + 1) + b;
	}
	function easeInOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	}
	//QUINT
	function easeInQuint (t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t*t*t*t + b;
	}
	function easeOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	}
	function easeInOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	}
	//EXPO
	function easeInExpo (t:Number, b:Number, c:Number, d:Number):Number {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	}
	function easeOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	}
	function easeInOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	}
	//CIRCLE
	function easeInCircle (t:Number, b:Number, c:Number, d:Number):Number {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}
	function easeOutCircle (t:Number, b:Number, c:Number, d:Number):Number {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}
	function easeInOutCircle (t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}
	//BACK
	function easeInBack (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	}
	function easeOutBack (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}
	function easeInOutBack (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158; 
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	}
	
	//QUAD
	function easeInQuad(t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t + b;
	}
	
	function easeOutQuad(t:Number, b:Number, c:Number, d:Number):Number {
		return -c *(t/=d)*(t-2) + b;
	}
	
	function easeInOutQuad(t:Number, b:Number, c:Number, d:Number):Number{
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
		}
	//QUART
	function easeInQuart (t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t*t*t + b;
	}
	function easeOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	}
	function easeInOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	}
	//SINE
	function easeInSine (t:Number, b:Number, c:Number, d:Number):Number {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	}
	function easeOutSine (t:Number, b:Number, c:Number, d:Number):Number {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	}
	function easeInOutSine (t:Number, b:Number, c:Number, d:Number):Number {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	}
	//------------------------------------------------------------------------------------------------
	function tween(MCname:String, NArray:String, VArray:String, Duration:String, tweenType:String, floatAction:String, args:String){
		var refName = eval(MCname);
		refName.Name_array = NArray.split(",");
		refName.Value_array = VArray.split(",");
		
		var myLength:Number = refName.Value_array.length;
		
		myString = "";
		for(var i=0;i<myLength;i++){
			myString += refName[refName.Name_array[i]]+",";
			}
		refName.Begin_array = myString.split(",");
		refName.Begin_array.pop();
		
		myString = "";
		for(var i=0;i<myLength;i++){
			//myString += refName.Begin_array[i] - refName[refName.Value_array[i]]
			myString += String(refName.Value_array[i] - refName[refName.Name_array[i]])+",";
			}
		refName.Change_array = myString.split(",");
		refName.Change_array.pop();
		
		var t= 0;
		var d= Duration;
		var b = 0;
		var c = 500;
		refName.onEnterFrame = function(){
			t++;
			for(var i=0;i<myLength;i++){
				this[Name_array[i]] = _level0.Tween[tweenType](t, Number(Begin_array[i]), Number(Change_array[i]), d);
				}
			if (t > d){
				delete this.onEnterFrame;
				//make sure MC is acurately finished
				for(var i=0;i<myLength;i++){
					this[Name_array[i]] = Value_array[i];
				}
				delete Name_array;
				delete Value_array;
				delete Begin_array;
				delete Change_array;
				if (floatAction != undefined){
						eval([floatAction](args)); 
					}
			}
			}
		
		}
}
