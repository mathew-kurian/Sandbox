class tm.freshComponents.forms.validators.EmailValidator implements tm.freshComponents.forms.validators.IFormValidator
{
	var _validationErrorMessage;
	function EmailValidator () {
	}
	function updateProperties(data) {
		if (data.minLettersAfterLastPoint.value && (Number(data.minLettersAfterLastPoint.value) > 0)) {
			minLettersAfterLastPoint = data.minLettersAfterLastPoint.value;
		}
		if (data.maxLettersAfterLastPoint.value && (Number(data.maxLettersAfterLastPoint.value) > 0)) {
			maxLettersAfterLastPoint = data.maxLettersAfterLastPoint.value;
		}
		if (data.minLettersBeforeAt.value && (Number(data.minLettersBeforeAt.value) > 0)) {
			minLettersBeforeAt = data.minLettersBeforeAt.value;
		}
		if (data.maxLettersBeforeAt.value && (Number(data.maxLettersBeforeAt.value) > 0)) {
			maxLettersBeforeAt = data.maxLettersBeforeAt.value;
		}
	}
	function validate(value) {
		var _local2 = String(value);
		if (_local2.length > 0) {
			var _local5 = _local2.substring(0, 1);
			if ((((!isNaN(_local5)) || (_local5 == ".")) || (_local5 == "-")) || (_local5 == "_")) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local4 = _local2.substring(_local2.length, -1);
			if ((((!isNaN(_local4)) || (_local4 == ".")) || (_local4 == "-")) || (_local4 == "_")) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local17 = maxLettersAfterLastPoint;
			var _local3 = _local2.indexOf("@", 0);
			var _local20 = _local2.lastIndexOf("@", _local2.length);
			if ((((_local3 == -1) || (_local3 >= (_local2.length - _local17))) || (_local3 == 0)) || (!(_local3 === _local20))) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local23 = _local2.indexOf(".", 0);
			var _local6 = _local2.lastIndexOf(".", _local2.length);
			if ((_local23 == 0) || (_local6 == -1)) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local13 = (_local2.length - _local6) - 1;
			if ((_local13 < minLettersAfterLastPoint) || (_local13 > maxLettersAfterLastPoint)) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local7 = _local2.charAt(_local3 - 1);
			var _local11 = _local2.charAt(_local3 + 1);
			if ((((((_local7 == ".") || (_local7 == "_")) || (_local7 == "-")) || (_local11 == ".")) || (_local11 == "_")) || (_local11 == "-")) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local14 = _local2.indexOf("-", 0);
			var _local8 = _local2.charAt(_local14 - 1);
			var _local12 = _local2.charAt(_local14 + 1);
			var _local15 = _local2.indexOf("_", 0);
			var _local9 = _local2.charAt(_local15 - 1);
			var _local10 = _local2.charAt(_local15 + 1);
			if ((((((((((((_local8 == ".") || (_local8 == "_")) || (_local8 == "@")) || (_local12 == ".")) || (_local12 == "_")) || (_local12 == "@")) || (_local9 == ".")) || (_local9 == "-")) || (_local9 == "@")) || (_local10 == ".")) || (_local10 == "-")) || (_local10 == "@")) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
			var _local16 = _local2.substring(0, _local3);
			var _local18 = _local2.indexOf("..", 0);
			var _local19 = _local2.indexOf("--", 0);
			var _local21 = _local2.indexOf("-", _local6);
			var _local22 = _local2.indexOf("_", _local6);
			if ((((((!(_local18 === -1)) || (!(_local19 === -1))) || (!(_local21 === -1))) || (!(_local22 === -1))) || (_local16.length < minLettersBeforeAt)) || (_local16.length > maxLettersBeforeAt)) {
				_validationErrorMessage = emailNotValidError;
				return(false);
			}
		}
		return(true);
	}
	function error() {
		return(_validationErrorMessage);
	}
	var minLettersAfterLastPoint = 2;
	var maxLettersAfterLastPoint = 4;
	var minLettersBeforeAt = 2;
	var maxLettersBeforeAt = 20;
	static var emailNotValidError = "emailNotValid";
}
