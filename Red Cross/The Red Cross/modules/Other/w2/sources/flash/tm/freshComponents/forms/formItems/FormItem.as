class tm.freshComponents.forms.formItems.FormItem
{
	var _formManager, _id, _label, _group, _type, _target;
	function FormItem (formManager, id, label, required) {
		_formManager = formManager;
		_id = id;
		_label = label;
		_required = required;
	}
	function updateParameters(data) {
	}
	function updateGroups(data) {
		if (data.group.value && (data.group.value.length > 0)) {
			_group = _formManager.registerItemsGroup(this, data.group.value, data.group);
		}
	}
	function validate() {
		return(true);
	}
	function getValue() {
		return(null);
	}
	function init() {
	}
	function reset() {
	}
	function get id() {
		return(_id);
	}
	function get label() {
		return(_label);
	}
	function get required() {
		return(_required);
	}
	function get type() {
		return(_type);
	}
	function get target() {
		return(_target);
	}
	function set target(targetObject) {
		_target = targetObject;
		//return(target);
	}
	function get group() {
		return(_group);
	}
	var _required = false;
	var fieldRequiredError = "fieldIsRequired";
}
