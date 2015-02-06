import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import SWFAddress;

class oxylus.template.jobs.main extends MovieClip 
{
	private var settings:Object;
	private var theXml:XML;	
	private var node:XMLNode;
	private var totals:Number;
	private var mode:Number = 1;
	
	private var idx:Number = 0;
	private var py:Number = 0;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	
	private var ht:MovieClip;
	private var mask:MovieClip;
	private var blocker:MovieClip;
	private var scroller:MovieClip;
	private var bar:MovieClip;
	private var stick:MovieClip;
	private var lst:MovieClip;

	private var popupHolder:MovieClip;
		private var ident:Number = 0;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	private var ignoreAddress:Number = 0;
	
	public function main() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		ht = content["ht"];
		ht._y = 40;
		
		
		mask = ht["mask"];
		mask._width = 960;
		mask._height = 350;
		mask._x = -34;
		
		blocker = ht["blocker"];
		blocker._width = mask._width + 20;
		blocker._height = mask._height + 10;
		blocker._x = mask._x;
		
		blocker.onPress = null;
		blocker.useHandCursor = false;
		blocker._visible = false;
		
		scroller = ht["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		stick._height = mask._height;
		
		scroller._x = 920;
		
		lst = ht["lst"];
		lst.setMask(mask);
		
		popupHolder._x = 180;
		
		
		
		loadMyXml();
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
			xmlOb.load("jobs.xml");
		}
	}
	
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		_global.jobStatus = 0;
		
		node = theXml.firstChild.firstChild.nextSibling;
		
		settings = Utils.parseSettingsNode(theXml.firstChild.firstChild);
		
		contentTitle["txt"].text = node.attributes.title;
		
		node = node.firstChild;
		
		if (node) {
			var currentButton:MovieClip = lst.attachMovie("IDbutton", "button" + idx, lst.getNextHighestDepth());
			currentButton.addEventListener("readPressed", Proxy.create(this, readPressed));
			currentButton.addEventListener("applyPressed", Proxy.create(this, applyPressed));
			currentButton.addEventListener("proressiveLoading", Proxy.create(this, proressiveLoading));
			currentButton.idx = idx;
			idx++;
			currentButton.setNode(node);
		}
		
		
		ScrollBox();
		
		loadStageResize();
		
		this._alpha = 100;
		
		
	}
	
	/**
	 * functions used for loading the buttons one after another
	 * @param	o
	 */
	private function proressiveLoading(o:Object) {
		if (node.nextSibling != null) {
			node = node.nextSibling;
			
			var currentButton:MovieClip = lst.attachMovie("IDbutton", "button" + idx, lst.getNextHighestDepth());
			currentButton.addEventListener("readPressed", Proxy.create(this, readPressed));
			currentButton.addEventListener("applyPressed", Proxy.create(this, applyPressed));
			currentButton.addEventListener("proressiveLoading", Proxy.create(this, proressiveLoading));
			py += o.mc.totalHeight;
			currentButton._y = py;
			currentButton.idx = idx;
			idx++;
			currentButton.setNode(node);
		}
		else {
			totals = idx;
			
			var str:Array = _global.theAddress.split("/");
			var last:String = str[2];
			if (last) {
				for (var i:Number = 0; i < totals; i++) {
					if (parseTheStr(lst["button" + i].node.attributes.url) == ("/" + last)) {
						lst["button" + i].dispatchThisMC();
						break;
					}
				}
			}
			else {
				var obj:Object = new Object();
				obj.mc = lst["button" + 0];
				closePopup(obj);
			}
		}
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	/**
	 * function used for treating the swf address
	 * @param	str
	 */
	public function treatAddress(str:String) {
		if (ignoreAddress == 0) {
			var str:Array = str.split("/");
			var last:String = str[2];
			
			if (last) {
				for (var i:Number = 0; i < totals; i++) {
					if (parseTheStr(lst["button" + i].node.attributes.url) == ("/" + last)) {
						lst["button" + i].dispatchThisMC();
						break;
					}
				}
			}
			else {
				var obj:Object = new Object();
				obj.mc = lst["button" + 0];
				closePopup(obj);
			}
		}
		
	}
	
	
	/**
	 * function launched when the read button gets pressed
	 * @param	o
	 */
	private function readPressed(o:Object) {
		Mouse.removeListener(this);
		blocker._visible = true;
		
		if (popupHolder["pop" + ident]) {
			popupHolder["pop" + ident].hidePrev();
		}
		ident++;
		var currentPop:MovieClip = popupHolder.attachMovie("IDpopup", "pop" + ident, popupHolder.getNextHighestDepth());
		currentPop.addEventListener("popupNext", Proxy.create(this, popupNext));
		currentPop.addEventListener("popupPrev", Proxy.create(this, popupPrev));
		currentPop.addEventListener("closePopup", Proxy.create(this, closePopup));
		currentPop.addEventListener("showDone", Proxy.create(this, showDone));
		currentPop.idx = o.mc.idx;
		currentPop.settings = settings;
		currentPop._x = Stage.width;
		currentPop.setNode(o.mc.node);
		
		mode = 1;
	}
	
	
	/**
	 * function launched when the apply button gets pressed
	 * @param	o
	 */
	private function applyPressed(o:Object) {
		Mouse.removeListener(this);
		blocker._visible = true;
		
		if (popupHolder["pop" + ident]) {
			popupHolder["pop" + ident].hidePrev();
		}
		ident++;
		var currentPop:MovieClip = popupHolder.attachMovie("IDpopup", "pop" + ident, popupHolder.getNextHighestDepth());
		currentPop.addEventListener("popupNext", Proxy.create(this, popupNext));
		currentPop.addEventListener("popupPrev", Proxy.create(this, popupPrev));
		currentPop.addEventListener("closePopup", Proxy.create(this, closePopup));
		currentPop.addEventListener("showDone", Proxy.create(this, showDone));
		currentPop.idx = o.mc.idx;
		currentPop.settings = settings;
		currentPop._x = Stage.width;
		currentPop.setNode(o.mc.node, 1);
		
		mode = 1;
	}
	
	
	/**
	 * function used for pressing the next button on the popup
	 * @param	o
	 */
	private function popupNext(o:Object) {
		if (o.mc.idx < totals - 1) {
			if (popupHolder["pop" + ident]) {
				popupHolder["pop" + ident].hidePrev();
			}
			ident++;
			var currentPop:MovieClip = popupHolder.attachMovie("IDpopup", "pop" + ident, popupHolder.getNextHighestDepth());
			currentPop.addEventListener("popupNext", Proxy.create(this, popupNext));
			currentPop.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			currentPop.addEventListener("closePopup", Proxy.create(this, closePopup));
			currentPop.addEventListener("showDone", Proxy.create(this, showDone));
			currentPop.idx = o.mc.idx+1;
			currentPop.settings = settings;
			currentPop._x = Stage.width;
			currentPop.setNode(o.mc.node.nextSibling);
			
			mode = 1;
			
			ignoreAddress = 1;
			
			SWFAddress.setValue(o.mc.node.parentNode.attributes.url + o.mc.node.nextSibling.attributes.url);
			SWFAddress.setTitle(o.mc.node.parentNode.attributes.urlTitle + " - " + o.mc.node.nextSibling.attributes.urlTitle);
		}
	}
	
	
	/**
	 * function used for pressing the prev button on the popup
	 * @param	o
	 */
	private function popupPrev(o:Object) {
		if (o.mc.idx > 0) {
			if (popupHolder["pop" + ident]) {
				popupHolder["pop" + ident].hideNext();
			}
			ident++;
			var currentPop:MovieClip = popupHolder.attachMovie("IDpopup", "pop" + ident, popupHolder.getNextHighestDepth());
			currentPop.addEventListener("popupNext", Proxy.create(this, popupNext));
			currentPop.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			currentPop.addEventListener("closePopup", Proxy.create(this, closePopup));
			currentPop.addEventListener("showDone", Proxy.create(this, showDone));
			currentPop.idx = o.mc.idx-1;
			currentPop.settings = settings;
			currentPop._x = -Stage.width;
			currentPop.setNode(o.mc.node.previousSibling);
			
			mode = 2;
			
			ignoreAddress = 1;
			
			SWFAddress.setValue(o.mc.node.parentNode.attributes.url + o.mc.node.previousSibling.attributes.url);
			SWFAddress.setTitle(o.mc.node.parentNode.attributes.urlTitle + " - " + o.mc.node.previousSibling.attributes.urlTitle);
		}
	}
	
	
	/**
	 * function used for closing the popup
	 * @param	o
	 */
	private function closePopup(o:Object) {
		
		_global.jobStatus = 0;
		
		if (popupHolder["pop" + ident]) {
			if (mode == 1) {
				popupHolder["pop" + ident].hidePrev();
			}
			else {
				popupHolder["pop" + ident].hideNext();
			}
			
		}
		
		blocker._visible = false;
		Mouse.addListener(this);
		
		ignoreAddress = 0;
		
		SWFAddress.setValue(o.mc.node.parentNode.attributes.url+"/");
		SWFAddress.setTitle(o.mc.node.parentNode.attributes.urlTitle);
	}
	
	private function showDone(o:Object) {
		ignoreAddress = 0;
	}
	
	
	/**
	 * function used for resize
	 * @param	w
	 * @param	h
	 */
	public function resize(w:Number, h:Number) {
		popupHolder._y = Math.round(h / 2 - 476 / 2 - _global.refY);
	}
	
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	private function onResize() {
		resize(Math.round(Stage.width), Math.round(Stage.height));
	}
	
	
	/**
	 * function used for the scroller
	 */
	private function ScrollBox() {
		ScrollArea = scroller["stick"];
		ScrollButton = scroller["bar"];
		Content = lst;
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
		} else {
			scrollable = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollButton._y = 0;
			scroller._alpha = 100
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(ScrollButton._height>(ScrollArea._height)){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				ScrollButton._y = 0;
				Content._y = 0;
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