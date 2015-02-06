//status messages...
const MESSAGES:Object = { invalidemail: "INVALID EMAIL ADDRESS", 
						  emptyfield: "FILL ALL REQUIRED FIELDS", 
						  ioerror: "SEND ERROR", 
						  sent: "MESSAGE SENT" };
//status messages display time...
var __timer:Timer = new Timer(5000);
this.__timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
//init...
for (var i in this.fields) this.__writetext(this.fields[i].textfield, "");
this.__writetext(this.txtemail, "");
this.btnsubmit.addEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseDown);
//
function __validemail(strEmail:String):Boolean {
	if (strEmail != null && strEmail != " " && strEmail != ""  && strEmail.indexOf("@") != -1) {
		var _domain:Array = strEmail.split("@");
		if (_domain[1] != "" && _domain[1] != " " && _domain[1] != null && _domain[1].indexOf(".") != -1) {
			var _periods:Array = _domain[1].split(".");
			if (_domain.length != 2) return false;
			if (_periods[1].length < 2 || _periods[1].length > 3) return false;
		}
		else return false;
	}
	else return false;
	//
	return true;
};
function __validform():Boolean {
	//filled fields?...
	for (var i in this.fields) {
		if (this.fields[i].textfield.text == "" && this.fields[i].required) {
			//empty required field...
			this.__writetext(this.txtstatus, this.MESSAGES.emptyfield);
			this.__timer.start();
			return false;
		};
	};
	//email field valid?...
	if (!this.__validemail(this.txtemail.text)) {
		this.__writetext(this.txtstatus, this.MESSAGES.invalidemail);
		this.__timer.start();
		return false;
	};
	return true;
};
function __writetext(txtTarget:TextField, strText:String):void {
	var _textformat:TextFormat = txtTarget.getTextFormat();
	txtTarget.text = strText;
	txtTarget.setTextFormat(_textformat);
};
//event handlers...
function __onComplete(event:Event):void {
	event.target.removeEventListener(Event.COMPLETE, this.__onComplete);
	this.__writetext(this.txtstatus, this.MESSAGES.sent);
	for (var i in this.fields) this.__writetext(this.fields[i].textfield, "");
	this.__writetext(this.txtemail, "");
	this.__timer.start();
};
function __onIOError(event:IOErrorEvent):void {
	event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.__onIOError);
	this.__writetext(this.txtstatus, this.MESSAGES.ioerror);
	this.__timer.start();
};
function __onMouseDown(event:MouseEvent):void {
	if (this.__validform()) {
		var _loader:URLLoader = new URLLoader();
		var _urlrequest:URLRequest = new URLRequest(this.scriptURL + "?ck=" + new Date().getTime());
		var _urlvariables:URLVariables = new URLVariables();
		//
		_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		_loader.addEventListener(Event.COMPLETE, this.__onComplete);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, this.__onIOError);
		//
		for (var i in this.fields) _urlvariables[this.fields[i].textfield.name] = this.fields[i].textfield.text;
		_urlrequest.method = URLRequestMethod.POST;
		_urlrequest.data = _urlvariables;
		//
		_loader.load(_urlrequest);
	};
};
function __onTimer(event:TimerEvent):void {
	this.__timer.stop();
	this.txtstatus.text = "";
};