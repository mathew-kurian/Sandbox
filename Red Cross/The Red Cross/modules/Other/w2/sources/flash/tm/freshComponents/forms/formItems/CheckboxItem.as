class tm.freshComponents.forms.formItems.CheckboxItem extends tm.freshComponents.forms.formItems.FormItem
{
	var _type, updateGroups, _required, validationError, fieldRequiredError, _target;
	function CheckboxItem (formManager, id, label, required) {
		super(formManager, id, label, required);
		_type = tm.freshComponents.forms.formItems.FormItemType.CHECKBOX;
	}
	function updateParameters(data) {
		selected = ((data.selected.value && (data.selected.value == "true")) ? true : false);
		updateGroups(data);
	}
	function validate() {
		if (_required && (getValue() == "false")) {
			validationError = fieldRequiredError;
			return(false);
		}
		return(true);
	}
	function getValue() {
		return(String(mx.controls.CheckBox(_target).selected));
	}
	function init() {
		reset();
	}
	function reset() {
		mx.controls.CheckBox(_target).selected = selected;
	}
	var selected = false;
}
