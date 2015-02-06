class tm.freshComponents.forms.formItems.RadiobuttonItem extends tm.freshComponents.forms.formItems.FormItem
{
	var _type, selected, updateGroups, _target, _group;
	function RadiobuttonItem (formManager, id, label, required) {
		super(formManager, id, label, required);
		_type = tm.freshComponents.forms.formItems.FormItemType.RADIOBUTTON;
	}
	function updateParameters(data) {
		selected = ((data.selected.value && (data.selected.value == "true")) ? true : false);
		updateGroups(data);
	}
	function validate() {
		return(true);
	}
	function getValue() {
		return(String(mx.controls.RadioButton(_target).selected));
	}
	function init() {
		reset();
	}
	function reset() {
		mx.controls.RadioButton(_target).selected = selected;
	}
	function get target() {
		return(_target);
	}
	function set target(targetObject) {
		_target = targetObject;
		(mx.controls.RadioButton)(_target).__set__groupName(_group.name);
		//return(target);
	}
}
