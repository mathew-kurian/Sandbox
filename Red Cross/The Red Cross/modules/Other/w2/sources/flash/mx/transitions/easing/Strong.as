class mx.transitions.easing.Strong
{
	function Strong () {
	}
	static function easeIn(t, b, c, d) {
		t = t / d;
		return((((((c * t) * t) * t) * t) * t) + b);
	}
	static function easeOut(t, b, c, d) {
		t = (t / d) - 1;
		return((c * (((((t * t) * t) * t) * t) + 1)) + b);
	}
	static function easeInOut(t, b, c, d) {
		t = t / (d / 2);
		if (t < 1) {
			return(((((((c / 2) * t) * t) * t) * t) * t) + b);
		}
		t = t - 2;
		return(((c / 2) * (((((t * t) * t) * t) * t) + 2)) + b);
	}
	static var version = "1.1.0.52";
}
