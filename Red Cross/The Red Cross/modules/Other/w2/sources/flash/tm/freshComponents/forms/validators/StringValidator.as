class tm.freshComponents.forms.validators.StringValidator implements tm.freshComponents.forms.validators.IFormValidator
{
	var regExp, _validationErrorMessage;
	function StringValidator () {
	}
	function updateProperties(data) {
		if (data.minChars.value && (Number(data.minChars.value) > 0)) {
			minChars = data.minChars.value;
		}
		if (data.reqExp.value && (String(data.reqExp.value).length > 0)) {
			pattern = data.reqExp.value;
			if (data.reqExpFlags.value && (String(data.reqExpFlags.value).length > 0)) {
				flags = data.reqExpFlags.value;
			}
			regExp = new tm.utils.RegExp(pattern, flags);
		}
	}
	function validate(value) {
		var _local2 = String(value);
		if (_local2.length < minChars) {
			_validationErrorMessage = minCharsLimitError;
			return(false);
		}
		if ((pattern && (pattern.length > 0)) && (regExp)) {
			var _local3 = regExp.test(_local2);
			if (!_local3) {
				_validationErrorMessage = reqExpError;
				return(false);
			}
		}
		return(true);
	}
	function error() {
		return(_validationErrorMessage);
	}
	var minChars = 0;
	var pattern = "";
	var flags = "";
	var minCharsLimitError = "minCharsLimitError";
	var reqExpError = "reqExpError";
}
