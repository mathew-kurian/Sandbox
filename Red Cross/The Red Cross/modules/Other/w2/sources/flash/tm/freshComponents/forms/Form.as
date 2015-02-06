class tm.freshComponents.forms.Form extends MovieClip
{
	var _visible, _holder, _parent, _items, _formManager, messageTextField, _formStructure, _formConfiguration, handlerFilePath, _validationMessages, contactFormObject, mail;
	function Form () {
		super();
		mx.events.EventDispatcher.initialize(this);
		_visible = false;
		_holder = _parent;
		init();
	}
	function init() {
		_items = new Array();
		_formManager = new tm.freshComponents.forms.FormManager();
		_formManager.submitButton = eval ((String(_holder) + ".") + submitButtonPath);
		_formManager.resetButton = eval ((String(_holder) + ".") + resetButtonPath);
		_formManager.buttonsOverLabel = buttonsOverLabel;
		_formManager.buttonsOutLabel = buttonsOutLabel;
		messageTextField = eval ((String(_holder) + ".") + messageTextFieldPath);
		messageTextField.text = "";
		if ((xmlFilesPrefix && (xmlFilesPrefix.length > 0)) && (eval (String(xmlFilesPrefix)) != undefined)) {
			xmlFilesPrefix = eval (String(xmlFilesPrefix)) + "_";
		}
		loadConfig(formConfigurationPath, onConfigurationLoaded);
	}
	function loadConfig(configurationPath, callback) {
		var _local2 = new tm.utils.XMLParser();
		_local2.load(xmlFilesPrefix + configurationPath, this, callback);
	}
	function onStructureLoaded(success, data) {
		if (success) {
			_formStructure = data;
			var _local13 = false;
			var _local3 = _formStructure.formItems[0].item;
			var _local2 = 0;
			while (_local2 < _local3.length) {
				var _local5 = _local3[_local2].id;
				if (((_local5 && (_local5 > 0)) && (_local5 <= _local3.length)) && (_formManager.getFormItem(_local5) == undefined)) {
					var _local4 = {id:_local5, label:_local3[_local2].label, required:_local3[_local2].required, type:_local3[_local2].type};
					for (var _local8 in _local3[_local2]) {
						if (!_local4[_local8]) {
							_local4[_local8] = new Object();
							if (_local3[_local2][_local8][0].value) {
								_local4[_local8].value = _local3[_local2][_local8][0].value;
							} else if (_local3[_local2][_local8][0].item && (_local3[_local2][_local8][0].item.length > 0)) {
								_local4[_local8].value = _local3[_local2][_local8][0].item;
							}
							for (var _local7 in _local3[_local2][_local8][0]) {
								if (_local7 != "value") {
									_local4[_local8][_local7] = _local3[_local2][_local8][0][_local7];
								}
							}
						}
					}
					_formManager.addNewItem(_local4);
				} else {
					_local13 = true;
				}
				_local2++;
			}
			if (!_local13) {
				var _local6 = 1;
				while (_holder[formItemsPrefix + _local6]) {
					_items.push(_holder[formItemsPrefix + _local6]);
					_formManager.getFormItem(_local6).__set__target(_holder[formItemsPrefix + _local6]);
					_local6++;
				}
				_formManager.init();
			} else {
				trace("Structure Error. Please check you xml structure file.");
			}
		} else {
			trace("Couldn't load structure.");
		}
	}
	function onConfigurationLoaded(success, data) {
		if (success) {
			_formConfiguration = data;
			_formManager.validateRequiredOnly = ((getConfigOption("validateRequiredOnly") == "true") ? true : false);
			_formManager.submitFormOnEnter = ((getConfigOption("submitFormOnEnter") == "true") ? true : false);
			handlerFilePath = (getConfigOption("serverProcessorFileName") + ".") + getConfigOption("serverProcessorType");
			_validationMessages = new Object();
			var _local3 = _formConfiguration.validationErrorMessages[0].message;
			var _local2;
			_local2 = 0;
			while (_local2 < _local3.length) {
				_validationMessages[_local3[_local2].type] = _local3[_local2].value;
				_local2++;
			}
			_formManager.onValidationError = tm.utils.Delegate.create(this, onFormValidationError);
			_formManager.onFormGroupValidationError = tm.utils.Delegate.create(this, onFormGroupValidationError);
			_formManager.onValidFormSubmit = tm.utils.Delegate.create(this, onValidFormSubmit);
			_formManager.onFormReset = tm.utils.Delegate.create(this, onFormReset);
			loadConfig(formStructurePath, onStructureLoaded);
		} else {
			trace("Couldn't load configuration.");
		}
	}
	function onFormValidationError(formItem, validationError) {
		var _local2 = _validationMessages[validationError];
		_local2 = tm.utils.Utils.searchAndReplace(_local2, "{LABEL}", formItem.__get__label());
		messageTextField.text = _local2;
		showMessage(_local2);
	}
	function onFormGroupValidationError(group, validationError) {
		var _local2 = _validationMessages[validationError];
		_local2 = tm.utils.Utils.searchAndReplace(_local2, "{LABEL}", group.name);
		messageTextField.text = _local2;
		showMessage(_local2);
	}
	function onValidFormSubmit() {
		messageTextField.text = getConfigOption("formProcessingText");
		showMessage(getConfigOption("formProcessingText"));
		var _local4 = new LoadVars();
		var _local7 = new LoadVars();
		_local7.contactFormObject = this;
		_local7.onLoad = onServerResponse;
		var _local3 = _formManager.getFormData();
		var _local5 = Number(getConfigOption("emailFromSource"));
		if (_local5 && (_local5 > 0)) {
		} else {
			_local4.mail_from = getConfigOption("emailFromSource");
		}
		var _local6 = Number(getConfigOption("subjectSource"));
		if (_local6 && (_local6 > 0)) {
		} else {
			_local4.mail_subject = getConfigOption("subjectSource");
		}
		var _local8 = Number(getConfigOption("emailTo"));
		if (_local8 && (_local8 > 0)) {
			_local4.mail_to = _local3[_local8 - 1].value;
		} else {
			_local4.mail_to = getConfigOption("emailTo");
		}
		_local4.plain_text = getConfigOption("plainText");
		_local4.smtp_server = getConfigOption("smtpServer");
		_local4.smtp_port = getConfigOption("smtpPort");
		var _local2 = _local3.length - 1;
		while (_local2 >= 0) {
			if (((_local5 && (_local5 > 0)) && (_local5 == _local3[_local2].id)) || ((_local6 && (_local6 > 0)) && (_local6 == _local3[_local2].id))) {
				if (_local5 == _local3[_local2].id) {
					_local4.mail_from = _local3[_local2].value;
				} else {
					_local4.mail_subject = _local3[_local2].value;
				}
			} else {
				_local4[_local3[_local2]["key"]] = _local3[_local2].value;
			}
			_local2--;
		}
		_local4.sendAndLoad(handlerFilePath, _local7, "POST");
	}
	function onFormReset() {
		messageTextField.text = "";
		hideMessage();
	}
	function onServerResponse(success) {
		var _local2 = contactFormObject;
		if (success) {
			if (mail == 1) {
				_local2._formManager.resetForm();
				_local2.messageTextField.text = _local2.getConfigOption("messageSentText");
				_local2.showMessage(_local2.getConfigOption("messageSentText"));
			} else {
				_local2.messageTextField.text = _local2.getConfigOption("messageSentFailedText");
				_local2.showMessage(_local2.getConfigOption("messageSentFailedText"));
			}
		} else {
			_local2.messageTextField.text = _local2.getConfigOption("messageSentFailedText");
			_local2.showMessage(_local2.getConfigOption("messageSentFailedText"));
		}
	}
	function getConfigOption(name) {
		return(_formConfiguration[name][0].value);
	}
	function getStructureOption(name) {
		return(_formStructure[name][0].value);
	}
	function showMessage(message) {
		var _local2 = {target:this, type:"onSubmit", message:message};
		dispatchEvent(_local2);
	}
	function hideMessage() {
		var _local2 = {target:this, type:"onReset"};
		dispatchEvent(_local2);
	}
	function dispatchEvent() {
	}
	function addEventListener() {
	}
	function removeEventListener() {
	}
	var xmlFilesPrefix = "";
	var formConfigurationPath = "fcFormConfiguration.xml";
	var formStructurePath = "fcFormStructure.xml";
	var formItemsPrefix = "tf_";
	var messageTextFieldPath = "cfMessage";
	var submitButtonPath = "bSubmit";
	var resetButtonPath = "bReset";
	var buttonsOverLabel = "over";
	var buttonsOutLabel = "out";
}
