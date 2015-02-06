import oxylus.Utils2;
import oxylus.utils.UStr;
import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.template.guest.lightImage;


class oxylus.template.guest.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	public var settings:Object;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	
	private var ht:MovieClip;
	private var mask:MovieClip;
	private var scroller:MovieClip;
	private var bar:MovieClip;
	private var stick:MovieClip;
	

	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	
	private var idx:Number = 0;
	private var myInterval:Number;
	private var images:Array;
	private var currentIdx:Number = -1;
	private var prevImage:MovieClip;
	
	
	private var holder:MovieClip;
	private var titleForm:MovieClip;
	private var form:MovieClip;
	private var smilyHolder:MovieClip;
	
	private var submit:MovieClip;
	private var apply:MovieClip;
	private var mes:MovieClip;
	private var name:MovieClip;
	
	private var oldCar:Number = 0;
	
	private var sendScript:String;
	private var lv:LoadVars;
		
	public function main() {
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		settings = new Object();
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		
		titleForm = content["titleForm"];
		titleForm["txt"].autoSize = true;
		titleForm["txt"].selectable = false;
		titleForm["txt"]._x = -3;
		
		ht = content["ht"];
		ht._y = 40;
		
		form = content["form"];
		form._y = 40;
		
		holder = ht["holder"];
		
		mask = ht["mask"];
		
		
		scroller = ht["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		
		holder.setMask(mask);
		apply = form["apply"];
		
		smilyHolder = form["smilyHolder"];
		
		mes = form["mes"];
		name = form["name"];
		
		submit = form["submit"];
		
		submit.onPress = Proxy.create(this, sOnPress);
		submit.onRollOver = Proxy.create(this, sOnRollOver);
		submit.onRollOut = Proxy.create(this, sOnRollOut);
		submit.onRelease = submit.onReleaseOutside = Proxy.create(this, sOnRelease);
		submit._alpha = 80;
		
		lv = new LoadVars();
		lv.onLoad = Proxy.create(this, lvll);
		
		loadMyXml();
	}
	
	private function lvll(s:Boolean)
	{
		if (!s) {
			apply["status_txt"].text = "Could not send the message !";
		}
		else {
			clearAll();
			apply["status_txt"].text = "Message sent successfully !";
		}
		
		enableAll();
	}
	
	private function sendText() {
		
		
		
		var originalStr:String = mes["txt"].text;
		var i:Number = 0;
		var currentSmili:MovieClip = smilyHolder["smily" + i];
		while (currentSmili) {
			var currentIdentifier:String = currentSmili.node.attributes.identifier;
			var imageTag:String = "<img src=" + String.fromCharCode(34) + currentSmili.node.attributes.src + String.fromCharCode(34) + " width=" + String.fromCharCode(34) + settings.smilyWidth + String.fromCharCode(34) + " height=" + String.fromCharCode(34) + settings.smilyHeight + String.fromCharCode(34) + ">";
			
			originalStr = UStr.replace(originalStr, currentIdentifier, imageTag, false, false, true);
			i++;
			currentSmili = smilyHolder["smily" + i];
		}
		
		trace(originalStr);
		
		lv["name"] = name["txt"].text;
		lv["mes"] = originalStr;
		lv.sendAndLoad(sendScript, lv, "POST");
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
			xmlOb.load("guestbook.xml");
		}
	}
	
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settings = Utils2.parseSettingsNode(node);
		sendScript = settings.script;
		
		mask._width = settings.contentWidth + 8;
		mask._height = settings.contentHeight;
		stick._height = mask._height + 4;
		
		scroller._x = Math.round(mask._width + 10);
		
		form._x = titleForm._x = Math.round(scroller._x + scroller._width + settings.formXPos);
		
		node = node.nextSibling;
		contentTitle["txt"].text = node.attributes.title;
		titleForm["txt"].text = node.attributes.titleForm;
		
		

		var node2:XMLNode = node.firstChild;
		
		var idx:Number = 0;
		var currentPos:Number = 0;
		for (;  node2 != null; node2 = node2.nextSibling ) {
			if (node2.attributes.approved == 1) {
				var currentEntry:MovieClip = holder.attachMovie("IDEntry", "entry" + idx, holder.getNextHighestDepth());
				currentEntry.setNode(node2, settings);
				currentEntry._y = currentPos;
				currentPos += Math.round(currentEntry._height + 6);
				idx++;
			}
		}
		
		
		smilyHolder._y = Math.round(form["mes"]._y + form["mes"]._height + 20);
		smilyHolder._x = 20;
		
		node = node.nextSibling.firstChild;
		var i:Number = 0;
		var currentPos:Number = 0;
		var currentPosY:Number = 0;
		for (; node != null; node = node.nextSibling) {
			var currentSmily:MovieClip = smilyHolder.attachMovie("IDsmily", "smily" + i, smilyHolder.getNextHighestDepth());
			currentSmily.addEventListener("smilyPressed", Proxy.create(this, smilyPressed));
			currentSmily.setNode(node, settings);
			currentSmily._x = currentPos;
			currentSmily._y = currentPosY;
			currentPos += 13 + settings.smilyWidth;
			if ((currentPos + settings.smilyWidth) > form["mes"]._width) {
				currentPosY += 12 + settings.smilyHeight;
				currentPos = 0;
			}
			i++;
		}
		if (currentPos == 0) {
			currentPosY -= 12;
		}
		else {
			currentPosY+=settings.smilyHeight
		}
		
		form["submit"]._y = Math.round(smilyHolder._y + currentPosY +  20);
		form["apply"]._y = Math.round(form["submit"]._y + 4);
		
		mes["txt"].html = true;
		mes["txt"].onChanged = Proxy.create(this, getCaretPos);
	
		name["txt"].tabIndex = 0;
		mes["txt"].tabIndex = 1;
		mes["txt"].text = "";
		
		ScrollBox();
	}
	

	private function getCaretPos() {
		oldCar = Selection.getCaretIndex()
	}
	
	private function smilyPressed(obj:Object) {
		var str:String = mes["txt"].text;
		var addedStr:String = obj.mc.node.attributes.identifier
		var newStr:String = "";
		
		var n:Number = str.length;
		var i:Number = 0;
		for (i = 0; i < oldCar; i++) {
			newStr += str.charAt(i);
		}
		
		newStr += addedStr;
		
		var totalStrLength = str.length + addedStr.length;
		
		for (i = oldCar; i < (totalStrLength); i++) {
			newStr += str.charAt(i);
		}
		
		oldCar += addedStr.length;
		
		mes["txt"].text = newStr;
	}
	
	
	private function sOnPress() {
		disableAll();
		var okk:Boolean = false;
		if ((name["txt"].text != "") && (name["txt"].text != " ") && (name["txt"].text != undefined)) {
			okk = true;
		}
		if (okk) {
			if ((mes["txt"].text != "") && (mes["txt"].text != " ") && (mes["txt"].text != undefined)) {
				okk = true;
			}
			else {
				okk = false;
			}
		}
		
		if (okk) {
			sendText();
		}
		else {
			enableAll();
			apply["status_txt"].text = "Please fill in all fields !";
		}
		
	}
	
	public function clearAll() {
		name["txt"].text = "";
		mes["txt"].text = "";
		oldCar = 0;
	}
	
	private function enableAll() {
		name["txt"].type = "input";
		mes["txt"].type = "input";
		submit.enabled = true;
	}
	
	private function disableAll() {
		name["txt"].type = "dynamic";
		mes["txt"].type = "dynamic";
		submit.enabled = false;
	}
	
	private function sOnRollOver() {
		Tweener.addTween(submit, { _alpha:100, time:0.1, transition:"linear" } );
	}
	
	private function sOnRollOut() {
		Tweener.addTween(submit, { _alpha:80, time:0.1, transition:"linear" } );
	}
	
	private function sOnRelease() {
		sOnRollOut();
	}
	
	
	/**
	 * this will handle the scroller
	 */
	private function ScrollBox() {
		ScrollArea = stick;
		ScrollButton = bar;
		Content = holder;
		ContentMask = mask;
		
		HitZone = ContentMask.duplicateMovieClip("_hitzone_", this.getNextHighestDepth());
		HitZone._alpha = 0;
		HitZone._width = ContentMask._width;
		HitZone._height = ContentMask._height;
		Content.setMask(ContentMask);
		ScrollArea.onPress = Proxy.create(this, startScroll);
		ScrollArea.onRelease = ScrollArea.onReleaseOutside=Proxy.create(this, stopScroll);
		totalHeight = Content._height;
		scrollable = false;
		updateScrollbar();
		Mouse.addListener(this);
		
		ScrollButton.onRollOver = Proxy.create(this, barOnRollOver);
		ScrollButton.onRollOut = Proxy.create(this, barOnRollOut);
		ScrollButton.onPress = Proxy.create(this, startScroll);
		ScrollButton.onRelease = ScrollButton.onReleaseOutside= Proxy.create(this, stopScroll)
	}
	
	private function updateScrollbar() {
		viewHeight = ContentMask._height;
		
		var prop:Number = viewHeight/totalHeight;
		
		if (prop >= 1) {
			scrollable = false;
			scroller._alpha = 0
			ScrollArea.enabled = false;
			ScrollButton._y = 0;
			Content._y = 0;
			scroller._visible = false;
			mask._width += 24;
			ht["txt"]._width = mask._width;
		
		} else {
			scrollable = true;
			scroller._visible = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollButton._y = 0;
			scroller._alpha = 100
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(ScrollButton._height>(ScrollArea._height)){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				//ScrollButton._y = 0;
				//Content._y = 0;
			}
			scroller._alpha = 100;
		}
	}
	
	private function startScroll() {
		var center:Boolean = !ScrollButton.hitTest(_level0._xmouse, _level0._ymouse, true);
		var sbx:Number = ScrollButton._x;
		if (center) {
			var sby:Number = ScrollButton._parent._ymouse-ScrollButton._height/2;
			sby<0 ? sby=0 : (sby>ScrollHeight ? sby=ScrollHeight : null);
			ScrollButton._y = sby;
		}

			
		ScrollButton.startDrag(false, sbx, 0, sbx, ScrollHeight);
		ScrollButton.onMouseMove = Proxy.create(this, updateContentPosition);
		updateContentPosition();
	}
	
	private function stopScroll() {
		ScrollButton.stopDrag();
		delete ScrollButton.onMouseMove;
		barOnRollOut();

	}
	
	private function updateContentPosition() {
		if (scrollable == true) {
			var contentPos:Number = (viewHeight-totalHeight)*(ScrollButton._y/ScrollHeight);
		this.onEnterFrame = function() {
			if (Math.abs(Content._y-contentPos)<1) {
				Content._y = contentPos;
				delete this.onEnterFRame;
				return;
			}
			Content._y += (contentPos - Content._y) / 4;
		};
		}
		else{
			Content._y = 0;
			delete Content.onEnterFRame;
		}
		
	}
	
	private function scrollDown() {
		var sby:Number = ScrollButton._y+ScrollButton._height/4;
		if (sby>ScrollHeight) {
			sby = ScrollHeight;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function scrollUp() {
		var sby:Number = ScrollButton._y-ScrollButton._height/4;
		if (sby<0) {
			sby = 0;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function onMouseWheel(delt:Number) {
		if (!HitZone.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		var dir:Number = delt/Math.abs(delt);
		if (dir<0) {
			scrollDown();
		} else {
			scrollUp();
		}
	}
	
	private function barOnRollOver() {
		Tweener.addTween(bar, { _alpha:60, time:0.15, transition:"linear" } );
	}
	
	private function barOnRollOut() {
		Tweener.addTween(bar, { _alpha:35, time:0.15, transition:"linear" } );
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