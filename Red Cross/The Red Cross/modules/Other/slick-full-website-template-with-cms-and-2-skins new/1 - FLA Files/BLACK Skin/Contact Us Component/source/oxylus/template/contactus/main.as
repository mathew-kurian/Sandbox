import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import TextField.StyleSheet;
import caurina.transitions.properties.TextShortcuts;
import flash.net.FileReference;

class oxylus.template.contactus.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var nd:XMLNode;
	
	public var settings:Object;
	
	
	private var title:MovieClip;
	private var holder:MovieClip;
		private var des:MovieClip;
			private var data:MovieClip;
		private var form:MovieClip;
			private var name:MovieClip;	
			private var email:MovieClip;	
			private var subject:MovieClip;	
			private var mes:MovieClip;	
			private var submit:MovieClip;	
			private var upload:MovieClip;
			private var apply:MovieClip;
			
	private var fr:FileReference;	
	private var lv:LoadVars;
	private var $cript:String;
	private var $cript2:String;
	
	public function main() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		TextShortcuts.init();
		
		settings = new Object();
		
		title["txt"].autoSize = true;
		
		des = holder["des"];
		
		Utils.initMhtf(des["txt"], false);
		
		des["txt"]._width = 280;
		
		
		
		data = des["d"];
		
		form = holder["form"];
		name = form["name"];
		email = form["email"];
		subject = form["subject"];
		mes = form["mes"];
		submit = form["submit"];
		upload = form["upload"]; upload["txt"].autoSize = true; upload["txt"]._width = 150; upload["txt"].wordWrap = true;
		apply = form["apply"];
		
		
		submit.onPress = Proxy.create(this, sOnPress);
		submit.onRollOver = Proxy.create(this, sOnRollOver);
		submit.onRollOut = Proxy.create(this, sOnRollOut);
		submit.onRelease = submit.onReleaseOutside = Proxy.create(this, sOnRelease);
		
		upload.onPress = Proxy.create(this, uOnPress);
		upload.onRollOver = Proxy.create(this, uOnRollOver);
		upload.onRollOut = Proxy.create(this, uOnRollOut);
		upload.onRelease = submit.onReleaseOutside = Proxy.create(this, uOnRelease);
		
		
		fr = new FileReference();
		fr.addListener(this);

		lv = new LoadVars();
		lv.onLoad = Proxy.create(this, lvll);
		
		
		
		TextField.prototype.setText2 = function(s:String) {
			Tweener.addTween(this, {_text:s, time:.5, transition:"easeoutquad"});
		};
		
		TextField.prototype.getText2 = function() {
			return this.text;
		};
		
		TextField.prototype.addProperty("text2", TextField.prototype.getText2, TextField.prototype.setText2);
		
		
		loadMyXml();
	}
	

	private function sOnPress() {
		if (!validFields()) {
			return;
		}
		
		disableAll();

		if(fr.name != null){
			sendFile();
		}
		else{
			sendText();
		}
	}
	
	private function uOnPress() {
		fr.browse();
	}
	
	
	/**
	 * this function will load the .xml file
	 * the template will first load the corresponding .xml file and in case of failure the default one will be loaded
	 */	
	
	public function loadMyXml() {
		if (_global.myXml) {
			theXml = _global.myXml;
			continueAfterXmlLoaded();
		}
		else {
			var xmlOb:XML = new XML();
			theXml = xmlOb;
			xmlOb.ignoreWhite = true;
			xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoaded);
			xmlOb.load("contact.xml");
		}
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settings = Utils.parseSettingsNode(node);
		
		$cript = settings.text;
		$cript2 = settings.upload;
		
		if ($cript2.length == 0) {
			upload._visible = false;
		}
		
		title["txt"].text = node.nextSibling.attributes.title;
		
		
		des["txt"].htmlText = node.nextSibling.firstChild.nodeValue;
		
		data._y = Math.round(des["txt"]._height + 14);
		
		nd = node.nextSibling.firstChild.nextSibling;
		
		data["e"]["e"].autoSize = data["w"]["w"].autoSize = data["y"]["y"].autoSize = data["m"]["m"].autoSize = data["s"]["s"].autoSize = true;
		data["e"]["e"].wordWrap = data["w"]["w"].wordWrap = data["y"]["y"].wordWrap = data["m"]["m"].wordWrap = data["s"]["s"].wordWrap = false;
		data["e"]["e"].text = nd.attributes.email;
		data["w"]["w"].text = nd.attributes.web;
		
		data["y"]["y"].text = nd.attributes.ym;
		data["m"]["m"].text = nd.attributes.msn;
		data["s"]["s"].text = nd.attributes.skype;
		
		if (nd.attributes.toggleEmail == 0) {
			data["ee"]._visible = data["e"]._visible = false;
		}
		
		if (nd.attributes.toggleWeb == 0) {
			data["ww"]._visible = data["w"]._visible =false;
		}
		
		if (nd.attributes.toggleYm == 0) {
			data["yy"]._visible = data["y"]._visible =false;
		}
		
		if (nd.attributes.toggleMsn == 0) {
			data["mm"]._visible = data["m"]._visible =false;
		}
		
		if (nd.attributes.toggleSkype == 0) {
			data["ss"]._visible = data["s"]._visible =false;
		}
		
		
		name["txt"].tabIndex = 0;
		email["txt"].tabIndex = 1;
		subject["txt"].tabIndex = 2;
		mes["txt"].tabIndex = 3;
		
		name["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		email["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		subject["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		mes["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		this._alpha = 100;
	
	}

	private function lvll(s:Boolean)
	{
		if (!s) {
			apply["status_txt"].text2 = "Could not send the message !";
		}
		else {
			clearAll();
			apply["status_txt"].text2 = "Message sent successfully !";
			upload["txt"].text = " ";
		}
		
		enableAll();
	}
	
	private function onSelect() {
		upload["txt"].text = fr.name + " ( "+String(Math.round(fr.size/102.4)/10)+" KB ) ";
	}
	
	private function onHTTPError() {
		upload["txt"].text2 = "( onHTTPError ) Could not upload file. Please, try again later";
		enableAll();
	}
		
	private function onIOError() {
		upload["txt"].text2 = "( onIOError ) Could not upload file. Please, try again later";
		enableAll();
	}
	
	
	private function onProgress(xxx, bl, bt) {
		var per = "";
		if (!isNaN(bl) && !isNaN(bt) && bt>0) {
			per = String(Math.floor(100*bl/bt))+"%";
		}
		Tweener.removeTweens(apply["status_txt"]);
		apply["status_txt"].text = "Uploading. Please wait . . . " + per;
	}
	
	private function sendFile() {
		fr.upload($cript2);
		apply["status_txt"].text2 = "Uploading, please wait...";
	}
	
	/**
	 * when uploading the file has completed the text will be sent
	 */
	private function onComplete() {
		sendText();
	}
	
	/**
	 * this fucntion will send the text
	 */
	private function sendText() {
		apply["status_txt"].text2 = "Sending mes, please wait...";
		lv["name"] = name["txt"].text;
		lv["e-mail"] = email["txt"].text;
		lv["subject"] = subject["txt"].text;
		lv["mes"] = mes["txt"].text;
		lv["file"] = fr.name == null ? "nofile" : fr.name;
		
		lv.sendAndLoad($cript, lv, "POST");
	}
	
	
	/**
	 * this will validate the fields
	 */
	private function validFields() {
		var str:String;
		str = name["txt"].text;
		
		if (Utils.remExtraSpace(str).length == 0) {
			apply["status_txt"].text2 = "Please enter name";
			Selection.setFocus(name["txt"]);
			return false;
		}
		
		if (!Utils.isValidEmail(email["txt"].text)) {
			apply["status_txt"].text2 = "Please enter a valid e-mail address";
			Selection.setFocus(email["txt"]);
			return false;
		}
		
		str = subject["txt"].text;
		if (Utils.remExtraSpace(str).length == 0) {
			apply["status_txt"].text2 = "Please enter a subject";
			Selection.setFocus(subject["txt"]);
			return false;
		}
		
		
		if (Utils.remExtraSpace(str).length == 0) {
			apply["status_txt"].text2 = "Please enter a mes";
			Selection.setFocus(mes["txt"]);
			return false;
		}
		

		return true;
	}
	
	private function disableAll() {
		
		name["txt"].type = "dynamic";
		email["txt"].type = "dynamic";
		subject["txt"].type = "dynamic";
		mes["txt"].type = "dynamic";
		
		submit.enabled = false;
	}
	
	private function enableAll() {
		
		name["txt"].type = "input";
		email["txt"].type = "input";
		subject["txt"].type = "input";
		mes["txt"].type = "input";
		
		submit.enabled = true;
	}
	
	
	/**
	 * this will clear all of the input fields
	 */
	public function clearAll() {
		
		name["txt"].text = "";
		email["txt"].text = "";
		subject["txt"].text = "";
		mes["txt"].text = "";
		
	}
	
	
	
	private function sOnRollOver() {
		Tweener.addTween(submit["over"], { _alpha:100, time:0.1, transition:"linear" } );
	}
	
	private function sOnRollOut() {
		Tweener.addTween(submit["over"], { _alpha:0, time:0.1, transition:"linear" } );
	}
	
	private function sOnRelease() {
		sOnRollOut();
	}
	
	private function uOnRollOver() {
		Tweener.addTween(upload, { _alpha:100, time:0.1, transition:"linear" } );
	}
	
	private function uOnRollOut() {
		Tweener.addTween(upload, { _alpha:75, time:0.1, transition:"linear" } );
	}
	
	private function uOnRelease() {
		sOnRollOut();
	}

	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
		//this function draws an ovel or a sqare if the radius will be 0
		mc.clear();
		mc.beginFill(fillColor,alphaAmount);
		mc.moveTo(r,0);
		mc.lineTo(mw-r,0);
		mc.curveTo(mw,0,mw,r);
		mc.lineTo(mw,mh-r);
		mc.curveTo(mw,mh,mw-r,mh);
		mc.lineTo(r,mh);
		mc.curveTo(0,mh,0,mh-r)
		mc.lineTo(0,r);
		mc.curveTo(0,0,r,0);
		mc.endFill();
	}
}