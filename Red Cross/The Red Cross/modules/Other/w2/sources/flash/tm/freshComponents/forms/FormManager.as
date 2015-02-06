class tm.freshComponents.forms.FormManager
{
	var itemsCollection, itemsGroups, submitButton, buttonsOverLabel, buttonsOutLabel, resetButton, validateRequiredOnly, submitFormOnEnter;
	function FormManager () {
		itemsCollection = new Array();
		itemsGroups = new Array();
	}
	function init() {
		var tabItems = new Array();
		itemsCollection.sortOn("id", Array.NUMERIC);
		var i = 0;
		while (i < itemsCollection.length) {
			if (tm.freshComponents.forms.formItems.FormItem(itemsCollection[i]) && (tm.freshComponents.forms.formItems.FormItem(itemsCollection[i]).__get__target())) {
				var item = eval (String(tm.freshComponents.forms.formItems.FormItem(itemsCollection[i]).__get__target()));
				item._focusrect = false;
				item.tabEnabled = true;
				tabItems.push(item);
				tm.freshComponents.forms.formItems.FormItem(itemsCollection[i]).init();
			}
			i++;
		}
		if (submitButton) {
			submitButton._focusrect = false;
			submitButton.tabEnabled = true;
			tabItems.push(submitButton);
			submitButton.labelRollOver = buttonsOverLabel;
			submitButton.labelRollOut = buttonsOutLabel;
			submitButton.onRollOver = function () {
				this.gotoAndPlay(this.labelRollOver);
			};
			submitButton.onRollOut = function () {
				this.gotoAndPlay(this.labelRollOut);
			};
			submitButton.onSetFocus = function () {
				this.gotoAndPlay(this.labelRollOver);
			};
			submitButton.onKillFocus = function () {
				this.gotoAndPlay(this.labelRollOut);
			};
			submitButton.onRelease = tm.utils.Delegate.create(this, submitForm);
		}
		if (resetButton) {
			resetButton._focusrect = false;
			resetButton.tabEnabled = true;
			tabItems.push(resetButton);
			resetButton.labelRollOver = buttonsOverLabel;
			resetButton.labelRollOut = buttonsOutLabel;
			resetButton.onRollOver = function () {
				this.gotoAndPlay(this.labelRollOver);
			};
			resetButton.onRollOut = function () {
				this.gotoAndPlay(this.labelRollOut);
			};
			resetButton.onSetFocus = function () {
				this.gotoAndPlay(this.labelRollOver);
			};
			resetButton.onKillFocus = function () {
				this.gotoAndPlay(this.labelRollOut);
			};
			resetButton.onRelease = tm.utils.Delegate.create(this, resetForm);
		}
		tm.freshComponents.tabFixer.TabManager.getInstance().registerTabFixer(tabItems, "onEnterKeyPress", this);
	}
	function addNewItem(item) {
		if ((item.id && (item.label)) && (item.label.length > 0)) {
			var _local3 = tm.freshComponents.forms.formItems.FormItemsFactory.create(item.type, this, item.id, item.label, item.required);
			_local3.updateParameters(item);
			itemsCollection.push(_local3);
		}
	}
	function submitForm() {
		if (validate(validateRequiredOnly)) {
			onValidFormSubmit();
		}
		tm.freshComponents.tabFixer.TabManager.getInstance().removeFocus();
	}
	function resetForm() {
		var _local2 = 0;
		while (_local2 < itemsCollection.length) {
			tm.freshComponents.forms.formItems.FormItem(itemsCollection[_local2]).reset();
			_local2++;
		}
		onFormReset();
		tm.freshComponents.tabFixer.TabManager.getInstance().removeFocus();
	}
	function validate(requiredOnly) {
		var _local2;
		_local2 = 0;
		while (_local2 < itemsCollection.length) {
			var _local3 = tm.freshComponents.forms.formItems.FormItem(itemsCollection[_local2]);
			if ((!requiredOnly) || (requiredOnly && (_local3.__get__required()))) {
				if (!_local3.validate()) {
					onValidationError(_local3, _local3.validationError);
					return(false);
				}
			}
			_local2++;
		}
		_local2 = 0;
		while (_local2 < itemsGroups.length) {
			var _local4 = tm.freshComponents.forms.formItems.FormItemsGroup(itemsGroups[_local2]);
			if (!_local4.validate()) {
				onFormGroupValidationError(_local4, _local4.validationError);
				return(false);
			}
			_local2++;
		}
		return(true);
	}
	function getFormItem(id) {
		var _local2 = 0;
		while (_local2 < itemsCollection.length) {
			if (itemsCollection[_local2].id == id) {
				return(itemsCollection[_local2]);
			}
			_local2++;
		}
		return(undefined);
	}
	function getFormData() {
		var _local6 = new Array();
		var _local7 = new Array();
		var _local4 = 0;
		while (_local4 < itemsCollection.length) {
			var _local2 = tm.freshComponents.forms.formItems.FormItem(itemsCollection[_local4]);
			var _local3 = _local2.__get__label();
			var _local5 = _local2.getValue();
			if (_local2.__get__group() && (isValidItemsGroup(_local2.__get__group().name))) {
				if (!tm.utils.Utils.inArray(_local2.__get__group().name, _local7)) {
					_local7.push(_local2.__get__group().name);
					_local3 = _local2.__get__group().name;
					_local5 = _local2.__get__group().getData();
					_local6.push({key:_local3, value:_local5, id:_local2.__get__id()});
				}
			} else if (_local2.__get__type() != tm.freshComponents.forms.formItems.FormItemType.RADIOBUTTON) {
				if (_local2.__get__type() == tm.freshComponents.forms.formItems.FormItemType.CHECKBOX) {
					_local5 = ((_local5 == "true") ? "yes" : "no");
				}
				_local6.push({key:_local3, value:_local5, id:_local2.__get__id()});
			}
			_local4++;
		}
		return(_local6);
	}
	function registerItemsGroup(formItem, groupName, groupParameters) {
		var _local3 = isValidItemsGroup(groupName);
		if (_local3) {
			_local3.addNewItem(formItem);
			return(_local3);
		}
		var _local2 = new tm.freshComponents.forms.formItems.FormItemsGroup(groupName, groupParameters);
		_local2.addNewItem(formItem);
		itemsGroups.push(_local2);
		return(_local2);
	}
	function isValidItemsGroup(groupName) {
		var _local2 = 0;
		while (_local2 < itemsGroups.length) {
			if (tm.freshComponents.forms.formItems.FormItemsGroup(itemsGroups[_local2]).name == groupName) {
				return(tm.freshComponents.forms.formItems.FormItemsGroup(itemsGroups[_local2]));
			}
			_local2++;
		}
		return(null);
	}
	function onEnterKeyPress(target) {
		if (target == resetButton) {
			resetForm();
		} else if (submitFormOnEnter || (target == submitButton)) {
			submitForm();
		}
	}
	function onValidationError(formItem, validationError) {
	}
	function onFormGroupValidationError(group, validationError) {
	}
	function onValidFormSubmit() {
	}
	function onFormReset() {
	}
}
