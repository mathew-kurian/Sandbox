class tm.freshComponents.forms.validators.NumberValidator implements tm.freshComponents.forms.validators.IFormValidator
{
	var minValue, maxValue, allowNegative, _validationErrorMessage;
	function NumberValidator () {
	}
	function updateProperties(data) {
		if (data.minValue.value && (Number(data.minValue.value) > 0)) {
			minValue = data.minValue.value;
		}
		if (data.maxValue.value && (Number(data.maxValue.value) > 0)) {
			maxValue = data.maxValue.value;
		}
		allowNegative = ((data.allowNegative.value && (data.allowNegative.value == "true")) ? true : false);
	}
	function validate(value) {
		if (String(value).length > 0) {
			value = Number(value);
			if ((!value) || (isNaN(value))) {
				_validationErrorMessage = notANumberError;
				return(false);
			}
			if ((!allowNegative) && (value < 0)) {
				_validationErrorMessage = negativeError;
				return(false);
			}
			if (value > maxValue) {
				_validationErrorMessage = biggerThanMaxError;
				return(false);
			}
			if (value < minValue) {
				_validationErrorMessage = lowerThanMinError;
				return(false);
			}
		}
		return(true);
	}
	function error() {
		return(_validationErrorMessage);
	}
	var biggerThanMaxError = "biggerThanMaxError";
	var lowerThanMinError = "lowerThanMinError";
	var notANumberError = "notANumberError";
	var negativeError = "negativeError";
}
