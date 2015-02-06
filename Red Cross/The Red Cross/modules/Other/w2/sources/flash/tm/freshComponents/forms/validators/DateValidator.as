class tm.freshComponents.forms.validators.DateValidator implements tm.freshComponents.forms.validators.IFormValidator
{
	var minDateAllowed, maxDateAllowed, _validationErrorMessage;
	function DateValidator () {
	}
	function updateProperties(data) {
		if (data.mask.value && (String(data.mask.value).length > 0)) {
			var _local3 = String(data.mask.value);
			if (((_local3.indexOf("dd") != -1) && (_local3.indexOf("mm") != -1)) && (_local3.indexOf("yyyy") != -1)) {
				mask = _local3;
				daysIndex = _local3.indexOf("dd");
				monthsIndex = _local3.indexOf("mm");
				yearsIndex = _local3.indexOf("yyyy");
			}
		}
		if (data.minDateAllowed.value && (String(data.minDateAllowed.value).length > 0)) {
			var _local4 = String(data.minDateAllowed.value);
			if (checkDateByMask(_local4)) {
				minDateAllowed = _local4;
			}
		}
		if (data.maxDateAllowed.value && (String(data.maxDateAllowed.value).length > 0)) {
			var _local5 = String(data.maxDateAllowed.value);
			if (checkDateByMask(_local5)) {
				maxDateAllowed = _local5;
			}
		}
	}
	function checkDateByMask(dateString) {
		var _local8 = Number(dateString.substr(daysIndex, 2));
		var _local5 = Number(dateString.substr(monthsIndex, 2));
		var _local9 = Number(dateString.substr(yearsIndex, 4));
		var _local11 = 1;
		var _local15 = 31;
		var _local13 = 1;
		var _local16 = 12;
		var _local12 = 1950;
		var _local14 = 2100;
		if (minDateAllowed && (minDateAllowed.length > 0)) {
			var _local7 = Number(minDateAllowed.substr(daysIndex, 2));
			var _local6 = Number(minDateAllowed.substr(monthsIndex, 2));
			var _local10 = Number(minDateAllowed.substr(yearsIndex, 4));
			if ((_local7 && (_local7 > 1)) && (_local7 < 31)) {
				_local11 = _local7;
			}
			if ((_local6 && (_local6 > 1)) && (_local6 < 31)) {
				_local13 = _local6;
			}
			if ((_local10 && (_local10 > 1950)) && (_local10 < 2100)) {
				_local12 = _local10;
			}
		}
		if (maxDateAllowed && (maxDateAllowed.length > 0)) {
			var _local4 = Number(maxDateAllowed.substr(daysIndex, 2));
			var _local2 = Number(maxDateAllowed.substr(monthsIndex, 2));
			var _local3 = Number(maxDateAllowed.substr(yearsIndex, 4));
			if (((_local4 && (_local4 > 1)) && (_local4 < 31)) && (_local4 > _local11)) {
				_local15 = _local4;
			}
			if (((_local2 && (_local2 > 1)) && (_local2 < 31)) && (_local2 > _local13)) {
				_local16 = _local2;
			}
			if (((_local3 && (_local3 > 1950)) && (_local3 < 2100)) && (_local3 > _local12)) {
				_local14 = _local3;
			}
		}
		if ((((!_local8) || (isNaN(_local8))) || (_local8 < _local11)) || (_local8 > _local15)) {
			_validationErrorMessage = dateIsNotValidError;
			return(false);
		}
		if ((((!_local5) || (isNaN(_local5))) || (_local5 < _local13)) || (_local5 > _local16)) {
			_validationErrorMessage = dateIsNotValidError;
			return(false);
		}
		if ((((!_local9) || (isNaN(_local9))) || (_local9 < _local12)) || (_local9 > _local14)) {
			_validationErrorMessage = dateIsNotValidError;
			return(false);
		}
		return(true);
	}
	function validate(value) {
		var _local2 = String(value);
		return(checkDateByMask(_local2));
	}
	function error() {
		return(_validationErrorMessage);
	}
	var mask = "mm/dd/yyyy";
	var daysIndex = 3;
	var monthsIndex = 0;
	var yearsIndex = 6;
	var dateIsNotValidError = "dateIsNotValidError";
}
