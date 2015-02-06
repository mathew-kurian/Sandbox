import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import caurina.transitions.properties.FilterShortcuts;
import SWFAddress;

class oxylus.template.portfolio.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	
	private var settings:Object;
	private var idx:Number = -1;
	private var currentPos:Number = 0;
	
	private var first:MovieClip;
	private var firstMask:MovieClip;
	private var listing:MovieClip;
	private var listingMask:MovieClip;
	
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
	
	/**
	 * customizable variables
	 * 
	 */
	private var blurAmountX:Number = 20;
	private var blurAmountY:Number = 20;
	private var animTime:Number = 0.3;
	private var animType:String = "easeOutCubic"
	
	private var sliderIdent:Number;
	
	private var mnt:Number;
	
	public function main() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		
		FilterShortcuts.init();
		
		first = this["first"];
		listing = this["listing"];
		
		navigation = first["sl"]["navigation"];
		prev = navigation["prev"]; prev["over"]._alpha = 0;
		next = navigation["next"]; next["over"]._alpha = 0;
		
		holder = first["sl"].createEmptyMovieClip("holder", first["sl"].getNextHighestDepth());
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
		
		
		content = first["content"];
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		contentHt = content["ht"];
		contentHt._y = 40;
		
		chTxt = contentHt["txt"];
		
		chTxt["txt"].autoSize 			= true;
		chTxt["txt"].condenseWhite 		= true;
		chTxt["txt"].html					= true;
		chTxt["txt"].multiline 			= true;
		chTxt["txt"].wordWrap 			= true;
		chTxt["txt"].mouseWheelEnabled 	= false;
		

		first.setMask(firstMask);
		listing.setMask(listingMask);
		
		loadMyXml();
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
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
			xmlOb.load("portfolio.xml");
		}
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		var pIndex:Object = new Object();
		pIndex = Utils.parseSettingsNode(node.firstChild);
		
		var pListing:Object = new Object();
		pListing = Utils.parseSettingsNode(node.firstChild.nextSibling);
		
		var pDetails:Object = new Object();
		pDetails = Utils.parseSettingsNode(node.firstChild.nextSibling.nextSibling);
		
		var pPopup:Object = new Object();
		pPopup = Utils.parseSettingsNode(node.firstChild.nextSibling.nextSibling.nextSibling);
		
		var pGeneral:Object = new Object();
		pGeneral = Utils.parseSettingsNode(node.firstChild.nextSibling.nextSibling.nextSibling.nextSibling);
		
		
		
		settings = new Object();
		
		for (var prop in pIndex) {
			settings[prop] = pIndex[prop];
		}
		
		for (var prop in pListing) {
			settings[prop] = pListing[prop];
		}
		
		for (var prop in pPopup) {
			settings[prop] = pPopup[prop];
		}
		
		for (var prop in pDetails) {
			settings[prop] = pDetails[prop];
		}
		
		for (var prop in pGeneral) {
			settings[prop] = pGeneral[prop];
		}
		
		
		blurAmountX = settings.blurXAmount;
		blurAmountY = settings.blurYAmount;
		animType = settings.animationType;
		animTime = settings.animationTime;
		
		
		
		drawOval(mask, settings.thumbsOnSlider * (settings.thumbWidth + 14) + settings.distanceBetweenThumbs * (settings.thumbsOnSlider - 1), settings.thumbHeight + 58, 0, 0xffffff, 100);
		mask._y = -6;
		lst.setMask(mask);
		prev._x = -10 - prev._width;
		next._x = mask._width + 10;
		
		contentTitle["txt"].text = node.nextSibling.attributes.title;
		chTxt["txt"]._width = settings.maxTextWidth;
		chTxt["txt"].htmlText = node.nextSibling.firstChild.nodeValue;
		
		node = node.nextSibling.nextSibling.firstChild;
		
		listing.parentUrl = String(node.parentNode.parentNode.firstChild.nextSibling.attributes.url);
		listing.parentUrlTitle = String(node.parentNode.parentNode.firstChild.nextSibling.attributes.urlTitle);
		
		first["sl"]._y = Math.round(contentTitle._height + chTxt._height + 10) ;
		
		var nd:XMLNode = node;
		var i:Number = -1;
		var currentP:Number = 0;
		
		for (; nd != null; nd = nd.nextSibling) {
			i++;
			var currentThumb:MovieClip = lst.attachMovie("IDthumb", "thumb" + i, lst.getNextHighestDepth());
			currentThumb.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentThumb.addEventListener("thumbClicked", Proxy.create(this, thumbClicked));
			currentThumb.setNode(nd, settings);
			currentThumb._x = currentPos;
			currentPos += settings.thumbWidth + settings.distanceBetweenThumbs + 14;
		}
		
		total = i;
		
		if (total <= (settings.thumbsOnSlider-1)) {
			next._visible = prev._visible = false;
		}
		
		continueLoad();
		
		listing.addEventListener("listingCreated", Proxy.create(this, listingCreated));
		
		this._alpha = 100;
		
		mnt = setInterval(this, "mmm", 1500);
	}
	
	private function mmm() {
		clearInterval(mnt);
		treatAddress();
	}
	
	/**
	 * actions for clicking one thumb
	 * @param	o
	 */
	private function thumbClicked(o:Object) {
		listing.setNode(o.thumb.node.firstChild, settings);
		slide(1);
	}
	
	private function listingCreated(o:Object) {
		slide(1);
	}
	
	
	private function slide(ident:Number) {
		first._visible = true;
		Tweener.addTween(first, { _x: -970 * ident, _Blur_blurX:ident * blurAmountX, _Blur_blurY:ident * blurAmountY, time: animTime, transition: animType, onComplete:Proxy.create(this, invisSlider, ident) } );
	}
	

	/**
	 * this will treat the swf address
	 * @param	s
	 */
	public function treatAddress(s:String) {
		var str:Array = _global.theAddress.split("/");
		var themain:String = str[1];
		var project:String = str[2];
		var details:String = str[3];
		var pop:String = str[4];
		
		if (project) {
			for (var iii:Number = 0; iii<= total; iii++) {
				if (parseTheStr(lst["thumb" + iii].node.attributes.url) == ("/" + project+ "/")) {
					lst["thumb" + iii].dispatchThisMC();
					break;
				}
			}
		}
		else{
			
			listing.cancelOthers();
			slide(0);
		}
	}
	
	
	
	private function invisSlider(ident:Number) {
		if (ident == 1) {
			first._visible = false;
		}
	}
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
	
	/**
	 * actions for pressing the next button on the slider
	 */
	private function nextOnRelease() {
		var ch:Number = (total) / settings.thumbsOnSlider;
		var cr:Number = Math.round((total) / settings.thumbsOnSlider);
		var vari:Number = 0;
		if (cr > ch) {
			vari = cr - 1;
		}
		else {
			vari = cr;
		}
		if (counter < vari) {
			counter++;
		}
		else {
			counter = 0;
		}
		
		blur()
		
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*settings.distanceBetweenThumbs, time: .5, transition: "easeInQuad", onComplete:Proxy.create(this, unBlur) } );
		
	}
	
	/**
	 * actions for pressing the prev button on the slider
	 */
	private function prevOnRelease() {
		var ch:Number = (total) / settings.thumbsOnSlider;
		var cr:Number = Math.round((total) / settings.thumbsOnSlider);
		var vari:Number = 0;
		
		if (cr > ch) {
			vari = cr - 1;
		}
		else {
			vari = cr;
		}
		
		if (counter > 0) {
			counter--;
		}
		else {
			counter = vari;
		}
		
		blur()
		
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*settings.distanceBetweenThumbs, time: .5, transition: "easeInQuad", onComplete:Proxy.create(this, unBlur) } );
	}
	
	/**
	 * this will blur the slider
	 */
	private function blur() {
		var ii:Number = 0;
		while(lst["thumb" + ii]){
			Utils.setMcBlur(lst["thumb" + ii], settings.scrollingBlurX, 0, 2);
			ii++;
			
		}
	}
	
	/**
	 * this will unblur the slider
	 */
	private function unBlur() {
		var ii:Number = 0;
		while(lst["thumb" + ii]){
			lst["thumb" + ii].filters = [];
			ii++;
		}
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