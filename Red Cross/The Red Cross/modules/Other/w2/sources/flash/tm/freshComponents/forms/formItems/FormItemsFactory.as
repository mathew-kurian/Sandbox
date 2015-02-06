class tm.freshComponents.forms.formItems.FormItemsFactory
{
	function FormItemsFactory () {
	}
	static function create(type, formManager, id, label, required) {
		switch (type) {
			case tm.freshComponents.forms.formItems.FormItemType.TEXT : 
			default : 
				return(new tm.freshComponents.forms.formItems.TextItem(formManager, id, label, required));
			case tm.freshComponents.forms.formItems.FormItemType.SELECT : 
				return(new tm.freshComponents.forms.formItems.SelectItem(formManager, id, label, required));
			case tm.freshComponents.forms.formItems.FormItemType.CHECKBOX : 
				return(new tm.freshComponents.forms.formItems.CheckboxItem(formManager, id, label, required));
			case tm.freshComponents.forms.formItems.FormItemType.RADIOBUTTON : 
		}
		return(new tm.freshComponents.forms.formItems.RadiobuttonItem(formManager, id, label, required));
	}
}
