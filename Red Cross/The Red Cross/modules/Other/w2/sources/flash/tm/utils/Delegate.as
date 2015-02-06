class tm.utils.Delegate
{
	function Delegate () {
	}
	static function create(target, handler) {
		var _local2 = function () {
			var _local2 = arguments.callee;
			var _local3 = arguments.concat(_local2.initArgs);
			return(_local2.handler.apply(_local2.target, _local3));
		};
		_local2.target = target;
		_local2.handler = handler;
		_local2.initArgs = arguments.slice(2);
		return(_local2);
	}
}
