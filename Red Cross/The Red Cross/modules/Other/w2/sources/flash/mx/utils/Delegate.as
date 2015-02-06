class mx.utils.Delegate extends Object
{
	var func;
	function Delegate (f) {
		super();
		func = f;
	}
	static function create(obj, func) {
		var _local2 = function () {
			var _local2 = arguments.callee.target;
			var _local3 = arguments.callee.func;
			return(_local3.apply(_local2, arguments));
		};
		_local2.target = obj;
		_local2.func = func;
		return(_local2);
	}
	function createDelegate(obj) {
		return(create(obj, func));
	}
}
