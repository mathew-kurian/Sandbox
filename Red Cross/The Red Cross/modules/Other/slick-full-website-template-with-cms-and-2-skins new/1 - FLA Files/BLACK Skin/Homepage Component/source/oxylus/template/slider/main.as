import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import TextField.StyleSheet;

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
		chTxt["txt"]._width = 880;
		chTxt["txt"].htmlText = node.nextSibling.firstChild.nodeValue
		title["txt"].text = node.nextSibling.nextSibling.attributes.title;
		node = node.nextSibling.nextSibling.firstChild;
		
		this["sl"]._y = Math.round(title._height + chTxt._height + 12);
		
		var nd:XMLNode = node;
		var i:Number = -1;
		var currentP:Number = 0;
		
		for (; nd != null; nd = nd.nextSibling) {
			i++;
			var currentThumb:MovieClip = lst.attachMovie("IDthumb", "thumb" + i, lst.getNextHighestDepth());
			currentThumb.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentThumb.setNode(nd, settings);
			currentThumb._x = currentPos;
			currentPos += settings.thumbWidth + settings.distanceBetweenThumbs + 14;
		}
		total = i+1;
		if (total == 0) {
			this["sl"]._visible = false;
		}
		continueLoad();
		Tweener.addTween(this, { _alpha:100, time: .3, transition: "easeOutQuad" } );
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