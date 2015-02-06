class tm.utils.Utils
{
	function Utils () {
	}
	static function searchAndReplace(haystack, needle, replacement) {
		var _local1 = haystack.split(needle);
		return(_local1.join(replacement));
	}
	static function inArray(target, array) {
		var _local1 = 0;
		while (_local1 < array.length) {
			if (array[_local1] == target) {
				return(true);
			}
			_local1++;
		}
		return(false);
	}
	static function getFullObjectPath(holder, objectPath) {
		return((String(holder) + ".") + objectPath);
	}
	static function traceObject(object, name, dec) {
		var _local3 = "";
		var _local5 = "  ";
		var _local2 = 0;
		while (_local2 < dec) {
			_local3 = _local3 + (_local5 + "|");
			_local2++;
		}
		if (name == undefined) {
			trace(_local3 + "[Object]");
		} else {
			trace(((_local3 + "[") + name) + "]");
		}
		_local3 = _local3 + (_local5 + "+");
		for (var _local7 in object) {
			if (typeof(object[_local7]) != "object") {
				trace(((((((_local3 + "[") + typeof(object[_local7])) + "|") + _local7) + "]") + " = ") + object[_local7]);
			}
		}
		for (var _local6 in object) {
			if (typeof(object[_local6]) == "object") {
				traceObject(object[_local6], _local6, dec + 1);
			}
		}
	}
	static function getObjectByPath(objectPath) {
		var lastDotIndex = objectPath.lastIndexOf(".");
		var holderObject = eval (objectPath.substr(0, lastDotIndex));
		if (holderObject) {
			return(holderObject[objectPath.substr(lastDotIndex + 1, objectPath.length - 1)]);
		}
		return(null);
	}
}
