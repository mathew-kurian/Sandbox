class tm.freshComponents.forms.formItems.TextItem extends tm.freshComponents.forms.formItems.FormItem
{
	var _type, validator, restrict, maxChars, updateGroups, _required, validationError, fieldRequiredError, _target;
	function TextItem (formManager, id, label, required) {
		super(formManager, id, label, required);
		_type = tm.freshComponents.forms.formItems.FormItemType.TEXT;
	}
	function updateParameters(data) {
		if (data.defaultValue.value && (data.defaultValue.value.length > 0)) {
			defaultValue = data.defaultValue.value;
		}
		if (data.textToShow.value && (data.textToShow.value.length > 0)) {
			textToShow = data.textToShow.value;
		}
		if (data.validator.value && (data.validator.value.length > 0)) {
			validator = tm.freshComponents.forms.validators.FormValidatorsFactory.create(data.validator.value);
			validator.updateProperties(data);
		}
		if (data.restrict.value && (data.restrict.value.length > 0)) {
			restrict = data.restrict.value;
		}
		if (data.maxChars.value && (data.maxChars.value.length > 0)) {
			maxChars = data.maxChars.value;
		}
		if (data.password.value && (data.password.value == "true")) {
			password = true;
		}
		updateGroups(data);
	}
	function validate() {
		var _local2 = getValue();
		if (_required) {
			if (((!_local2) || (_local2.length <= 0)) || (_local2 == textToShow)) {
				validationError = fieldRequiredError;
				return(false);
			}
		}
		if (validator && (!validator.validate(_local2))) {
			validationError = validator.error();
			return(false);
		}
		return(true);
	}
	function getValue() {
		return(TextField(_target).text);
	}
	function init() {
		var _local3 = TextField(_target);
		_local3.textToShow = textToShow;
		_local3.onSetFocus = function () {
			var _local2 = this;
			if (_local2.text == _local2.textToShow) {
				_local2.text = "";
			}
		};
		_local3.onKillFocus = function () {
			var _local2 = this;
			if (_local2.text == "") {
				_local2.text = _local2.textToShow;
			}
		};
		reset();
	}
	function reset() {
		var _local2 = TextField(_target);
		_local2.text = textToShow;
		_local2.hscroll = 0;
		_local2.scroll = 0;
	}
	function get target() {
		return(_target);
	}
	function set target(targetObject) {
		_target = targetObject;
		TextField(_target).restrict = restrict;
		TextField(_target).maxChars = maxChars;
		TextField(_target).password = password;
		//return(target);
	}
	var defaultValue = "";
	var textToShow = "";
	var password = false;
}
