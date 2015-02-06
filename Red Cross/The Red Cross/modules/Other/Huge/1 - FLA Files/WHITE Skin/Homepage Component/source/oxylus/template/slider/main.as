import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import TextField.StyleSheet;
import SWFAddress;

class oxylus.template.slider.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	
	private var settings:Object;
	private var idx:Number = -1;
	private var currentPos:Number = 0;
	
	private var title:MovieClip;
	private var navigation:MovieClip;
	private var prev:MovieClip;
	private var next:MovieClip;
	
	private var holder:MovieClip;
	private var lst:MovieClip;
	private var mask:MovieClip;
	
	private var total:Number = 0;
	
	private var counter:Number = 0;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	private var contentHt:MovieClip;
	private var chTxt:MovieClip;
	
	
	
	
	private var thumbArray:Array;
	
	private var popupId:Number = -1;
	private var popupActive:Number = 0;
	private var popupHolder:MovieClip;
	private var thePopup:MovieClip;
	private var popupMode:Number = 1;
	
	
	private var mainU:String;
	private var mainT:String;
	
	public function main() {
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		title = this["sl"]["title"];
		title["txt"].autoSize = true;
		title["txt"].wordWrap = false;
		title["txt"].selectable = false;
		title["txt"]._x = -3;
		
		navigation = this["sl"]["navigation"];
		prev = navigation["prev"]; prev["over"]._alpha = 0;
		next = navigation["next"]; next["over"]._alpha = 0;
		
		holder = this["sl"].createEmptyMovieClip("holder", this["sl"].getNextHighestDepth());
		holder._y = navigation._y = 50;
		lst = holder.createEmptyMovieClip("lst", holder.getNextHighestDepth());
		mask = holder.createEmptyMovieClip("mask", holder.getNextHighestDepth());
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		this["sl"]._y = 220;
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		contentHt = content["ht"];
		contentHt._y = 40;
		
		chTxt = contentHt["txt"];
		
		chTxt["txt"].autoSize 			= true;
		chTxt["txt"].multiline 			= true;
		chTxt["txt"].wordWrap 			= true;
		chTxt["txt"].condenseWhite 		= true;
		chTxt["txt"].mouseWheelEnabled 	= false;
		chTxt["txt"].html					= true;
		
		var ss:StyleSheet = new StyleSheet();
		ss.setStyle("a", { leading:"6" } ); 
		
		chTxt["txt"].styleSheet = ss;
		
		
		var parentMC:MovieClip = this;
		
		if (parentMC["popupHolder"]) {
			parentMC["popupHolder"].removeMovieClip();
		}
		
		popupHolder = parentMC.createEmptyMovieClip("popupHolder", parentMC.getNextHighestDepth());
		popupHolder._alpha = 0;
		popupHolder.createEmptyMovieClip("bg", popupHolder.getNextHighestDepth());
		popupHolder["bg"].useHandCursor = false;
		popupHolder["bg"].onPress = null;
		popupHolder._visible = false;
		
		
		loadMyXml();
	}
	
	/**
	 * actions for pressing the next button
	 */
	private function nextOnRelease() {
		if (counter < Math.ceil(total / settings.thumbsOnSlider)-1) {
			counter++;
		}
		else {
			counter = 0;
		}
		blur();
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*settings.distanceBetweenThumbs, time: .5, transition: "easeInQuad", onComplete:Proxy.create(this, unBlur) } );
	}
	
	/**
	 * actions for pressing the prev button
	 */
	private function prevOnRelease() {
		if (counter > 0) {
			counter--;
		}
		else {
			counter = Math.ceil(total / settings.thumbsOnSlider) - 1;
		}
		blur();
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*settings.distanceBetweenThumbs, time: .5, transition: "easeInQuad", onComplete:Proxy.create(this, unBlur) } );
	}
	
	/**
	 * this will blur the list
	 */
	private function blur() {
		var idxx:Number = 0;
		for (idxx = 0; idxx < total; idxx++) {
			Utils.setMcBlur(lst["thumb" + idxx], settings.scrollingBlurX, 0, 2);
			
		}
	}
	
	/**
	 * this will unblur the list
	 */
	private function unBlur() {
		var idxx:Number = 0;
		for (idxx = 0; idxx < total; idxx++) {
			lst["thumb" + idxx].filters = [];
		}
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
			xmlOb.load("homepage.xml");
		}
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settings = new Object();
		settings = Utils.parseSettingsNode(node);
		
		
		drawOval(mask, settings.thumbsOnSlider * (settings.thumbWidth + 14) + settings.distanceBetweenThumbs * (settings.thumbsOnSlider - 1), settings.thumbHeight + 13 + 37, 0, 0xffffff, 100);
		mask._y = -6;
		lst.setMask(mask);
		prev._x = -10 - prev._width;
		next._x = mask._width + 10;
		contentTitle["txt"].text = node.nextSibling.attributes.title;
		
		mainU = node.nextSibling.attributes.url;
		mainT = node.nextSibling.attributes.urlTitle;
		
		chTxt["txt"]._width = 880;
		chTxt["txt"].htmlText = node.nextSibling.firstChild.nodeValue
		title["txt"].text = node.nextSibling.nextSibling.attributes.title;
		node = node.nextSibling.nextSibling.firstChild;
		
		
		
		this["sl"]._y = Math.round(title._height + chTxt._height + 12);
		
		var nd:XMLNode = node;
		var i:Number = -1;
		var currentP:Number = 0;
		thumbArray = new Array();
		
		for (; nd != null; nd = nd.nextSibling) {
			i++;
			var currentThumb:MovieClip = lst.attachMovie("IDthumb", "thumb" + i, lst.getNextHighestDepth());
			currentThumb.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentThumb.addEventListener("thumbPressed", Proxy.create(this, thumbPressed));
			currentThumb.setNode(nd, settings, mainU, mainT);
			if (nd.attributes.toggleLaunchPopup == 1) {
				thumbArray.push(currentThumb);
				currentThumb.idx = thumbArray.length - 1;
			}
			
			currentThumb._x = currentPos;
			currentPos += settings.thumbWidth + settings.distanceBetweenThumbs + 14;
		}
		total = i+1;
		if (total == 0) {
			this["sl"]._visible = false;
		}
		continueLoad();
		
		loadStageResize();
		treatAddress(SWFAddress.getValue());
		Tweener.addTween(this, { _alpha:100, time: .3, transition: "easeOutQuad" } );
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	
	public function treatAddress(pstr:String) {
			var str:Array = pstr.split("/");
			var last:String = str[2];
			
			if (last) {
				var ii:Number = 0;
				while (thumbArray[ii]) {
					if (parseTheStr(thumbArray[ii].node.attributes.url) == ("/" + last)) {
						thumbArray[ii].dispatchThisMC();
						break;
					}
					ii++;
				}
			}
			else {
				closePopup();
			}
	}
	
	private function thumbPressed(obj:Object) {
		if (popupActive == 0) {
			popupMode = 1;
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopupGallery", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("closePopup", Proxy.create(this, closePopup));
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode);
			showPopup();
			popupActive = 1;
			onResize();
		}
		else {
			thePopup.hideDec();
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopupGallery", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("closePopup", Proxy.create(this, closePopup));
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode);
			onResize();
		}
		
	}
	
	private function popupNext(obj:Object) {
		if (thumbArray[obj.mc.idx + 1]) {
			thePopup.hidePrev();
			popupMode = 1;
			thumbArray[obj.mc.idx + 1].onPress();
		}
	}
	
	private function popupPrev(obj:Object) {
		if (thumbArray[obj.mc.idx - 1]) {
			thePopup.hideNext();
			popupMode = 2;
			thumbArray[obj.mc.idx - 1].onPress();
		}
	}
	
	private function showPopup() {
		popupHolder._visible = true;
		Tweener.removeTweens(popupHolder);
		Tweener.addTween(popupHolder, { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function closePopup(obj:Object) {
		if (popupActive == 1) {
			popupActive = 0;
			_global.popPresent = 0;
			Tweener.removeTweens(popupHolder);
			Tweener.addTween(popupHolder, { _alpha:0, time: .2, transition: "linear", onComplete:Proxy.create(this, disablePopup) } );

			SWFAddress.setValue(mainU);
			SWFAddress.setTitle(mainT);
		}
		
	}
	
	private function disablePopup() {
		popupHolder._visible = false;
		popupActive = 0;
	}
	
	private function resize(w:Number, h:Number) {
		drawOval(popupHolder["bg"], w, h, 0, 0xffffff, 75);
		
		popupHolder._x = -_global.refX;
		popupHolder._y = -_global.refY;
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	/**
	 * this will continue loading the images progressively
	 */
	private function continueLoad() {
		if (node != null) {
			idx++;
			lst["thumb" + idx].loadPic();
			node = node.nextSibling;
		}
	}
	
	private function thumbLoaded() {
		continueLoad()
	}
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
	}
	
	private function prevOnReleaseOutside() {
		prevOnRollOut();
	}
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
	}
	
	private function nextOnReleaseOutside() {
		nextOnRollOut();
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