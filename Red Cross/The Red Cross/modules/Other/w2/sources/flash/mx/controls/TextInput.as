class mx.controls.TextInput extends mx.core.UIComponent
{
	var owner, enterListener, label, tabChildren, tabEnabled, focusTextField, _color, _parent, border_mc, createClassObject, dispatchValueChangedEvent, __get__width, __get__height, tfx, tfy, tfw, tfh, getStyle, bind, updateModel, _getTextFormat, enabled;
	function TextInput () {
		super();
	}
	function addEventListener(event, handler) {
		if (event == "enter") {
			addEnterEvents();
		}
		super.addEventListener(event, handler);
	}
	function enterOnKeyDown() {
		if (Key.getAscii() == 13) {
			owner.dispatchEvent({type:"enter"});
		}
	}
	function addEnterEvents() {
		if (enterListener == undefined) {
			enterListener = new Object();
			enterListener.owner = this;
			enterListener.onKeyDown = enterOnKeyDown;
		}
	}
	function init(Void) {
		super.init();
		label.styleName = this;
		tabChildren = true;
		tabEnabled = false;
		focusTextField = label;
		_color = mx.core.UIObject.textColorList;
		label.onSetFocus = function () {
			this._parent.onSetFocus();
		};
		label.onKillFocus = function (n) {
			this._parent.onKillFocus(n);
		};
		label.drawFocus = function (b) {
			this._parent.drawFocus(b);
		};
		label.onChanged = onLabelChanged;
	}
	function setFocus() {
		Selection.setFocus(label);
	}
	function onLabelChanged(Void) {
		_parent.dispatchEvent({type:"change"});
		_parent.dispatchValueChangedEvent(text);
	}
	function createChildren(Void) {
		super.createChildren();
		if (border_mc == undefined) {
			createClassObject(_global.styles.rectBorderClass, "border_mc", 0, {styleName:this});
		}
		border_mc.swapDepths(label);
		label.autoSize = "none";
	}
	function get html() {
		return(getHtml());
	}
	function set html(value) {
		setHtml(value);
		//return(html);
	}
	function getHtml() {
		return(label.html);
	}
	function setHtml(value) {
		if (value != label.html) {
			label.html = value;
		}
	}
	function get text() {
		return(getText());
	}
	function set text(t) {
		setText(t);
		//return(text);
	}
	function getText() {
		if (initializing) {
			return(initText);
		}
		if (label.html == true) {
			return(label.htmlText);
		}
		return(label.text);
	}
	function setText(t) {
		if (initializing) {
			initText = t;
		} else {
			var _local2 = label;
			if (_local2.html == true) {
				_local2.htmlText = t;
			} else {
				_local2.text = t;
			}
		}
		dispatchValueChangedEvent(t);
	}
	function size(Void) {
		border_mc.setSize(__get__width(), __get__height());
		var _local2 = border_mc.__get__borderMetrics();
		var _local6 = _local2.left + _local2.right;
		var _local3 = _local2.top + _local2.bottom;
		var _local5 = _local2.left;
		var _local4 = _local2.top;
		tfx = _local5;
		tfy = _local4;
		tfw = __get__width() - _local6;
		tfh = __get__height() - _local3;
		label.move(tfx, tfy);
		label.setSize(tfw, tfh + 1);
	}
	function setEnabled(enable) {
		label.type = (((__editable == true) || (enable == false)) ? "input" : "dynamic");
		label.selectable = enable;
		var _local2 = getStyle((enable ? "color" : "disabledColor"));
		if (_local2 == undefined) {
			_local2 = (enable ? 0 : 8947848);
		}
		setColor(_local2);
	}
	function setColor(col) {
		label.textColor = col;
	}
	function onKillFocus(newFocus) {
		if (enterListener != undefined) {
			Key.removeListener(enterListener);
		}
		if (bind != undefined) {
			updateModel(text);
		}
		super.onKillFocus(newFocus);
	}
	function onSetFocus(oldFocus) {
		var f = Selection.getFocus();
		var o = eval (f);
		if (o != label) {
			Selection.setFocus(label);
			return(undefined);
		}
		if (enterListener != undefined) {
			Key.addListener(enterListener);
		}
		super.onSetFocus(oldFocus);
	}
	function draw(Void) {
		var _local2 = label;
		var _local4 = getText();
		if (initializing) {
			initializing = false;
			delete initText;
		}
		var _local3 = _getTextFormat();
		_local2.embedFonts = _local3.embedFonts == true;
		if (_local3 != undefined) {
			_local2.setTextFormat(_local3);
			_local2.setNewTextFormat(_local3);
		}
		_local2.multiline = false;
		_local2.wordWrap = false;
		if (_local2.html == true) {
			_local2.setTextFormat(_local3);
			_local2.htmlText = _local4;
		} else {
			_local2.text = _local4;
		}
		_local2.type = (((__editable == true) || (enabled == false)) ? "input" : "dynamic");
		this.size();
	}
	function setEditable(s) {
		__editable = s;
		label.type = (s ? "input" : "dynamic");
	}
	function get maxChars() {
		return(label.maxChars);
	}
	function set maxChars(w) {
		label.maxChars = w;
		//return(maxChars);
	}
	function get length() {
		return(label.length);
	}
	function get restrict() {
		return(label.restrict);
	}
	function set restrict(w) {
		label.restrict = ((w == "") ? null : (w));
		//return(restrict);
	}
	function get hPosition() {
		return(label.hscroll);
	}
	function set hPosition(w) {
		label.hscroll = w;
		//return(hPosition);
	}
	function get maxHPosition() {
		return(label.maxhscroll);
	}
	function get editable() {
		return(__editable);
	}
	function set editable(w) {
		setEditable(w);
		//return(editable);
	}
	function get password() {
		return(label.password);
	}
	function set password(w) {
		label.password = w;
		//return(password);
	}
	function get tabIndex() {
		return(label.tabIndex);
	}
	function set tabIndex(w) {
		label.tabIndex = w;
		//return(tabIndex);
	}
	function set _accProps(val) {
		label._accProps = val;
		//return(_accProps);
	}
	function get _accProps() {
		return(label._accProps);
	}
	static var symbolName = "TextInput";
	static var symbolOwner = mx.controls.TextInput;
	static var version = "2.0.2.127";
	var className = "TextInput";
	var initializing = true;
	var clipParameters = {text:1, editable:1, password:1, maxChars:1, restrict:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.TextInput.prototype.clipParameters, mx.core.UIComponent.prototype.clipParameters);
	var _maxWidth = mx.core.UIComponent.kStretch;
	var __editable = true;
	var initText = "";
}
