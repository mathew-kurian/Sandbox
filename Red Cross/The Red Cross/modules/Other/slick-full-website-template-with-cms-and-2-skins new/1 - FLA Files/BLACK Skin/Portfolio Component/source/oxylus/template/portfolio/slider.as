import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;

class oxylus.template.portfolio.slider extends MovieClip
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var settings:Object;
	
	private var idx:Number = -1;
	private var currentPos:Number = 0;
	
	private var navigation:MovieClip;
	private var prev:MovieClip;
	private var next:MovieClip;
	private var holder:MovieClip;
	private var mask:MovieClip;
	private var lst:MovieClip;
	private var total:Number = 0;
	private var counter:Number = 0;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	private var contentHt:MovieClip;
	private var chTxt:MovieClip;
	
	private var popupId:Number = -1;
	private var popupActive:Number = 0;
	private var popupHolder:MovieClip;
	private var thePopup:MovieClip;
	private var popupMode:Number = 1;
	
	private var tw:Number = 409;
	private var th:Number = 365;
	private var no:Number = 1;
	private var sp:Number = 0;
	
	private var lastIdx:Number = 0;
	
	public function slider() {
		navigation = this["sl"]["navigation"];
		prev = navigation["prev"]; prev["over"]._alpha = 0;
		next = navigation["next"]; next["over"]._alpha = 0;
		
		holder = this["sl"].createEmptyMovieClip("holder", this["sl"].getNextHighestDepth());
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
		
		this["sl"]._y = 0;
	}
	
	/**
	 * function for pressing the next button
	 */
	private function nextOnRelease() {
		if (counter <= Math.ceil(total / no)-1) {
			counter++;
		}
		else {
			counter = 0;
		}
		
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*sp, time: .5, transition: "easeInQuad" } );
		
	}
	
	/**
	 * function for pressing the prev button
	 */
	private function prevOnRelease() {
		if (counter > 0) {
			counter--;
		}
		else {
			counter = Math.ceil(total / no)-1;
		}
		
		Tweener.addTween(lst, { _x:-mask._width*counter-counter*sp, time: .5, transition: "easeInQuad" } );
	}
	
	/**
	 * function for setting the .xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object)
	{
		node = n;
		settings = settings_;
		
		tw = settings.thumbWidthProjectDetails;
		th = settings.thumbHeightProjectDetails;
		
		drawOval(mask, no * (tw + 14) + sp * (no - 1), th + 6 + 6 + 14, 0, 0xffffff, 100);
		mask._y = -6;
		lst.setMask(mask);
		prev._x = -10 - prev._width;
		next._x = mask._width + 10;
		next._y = prev._y = Math.round((th+38) / 2 - next._height / 2);
		
		var nd:XMLNode = node;
		var i:Number = -1;
		var currentP:Number = 0;
		
		
		for (; nd != null; nd = nd.nextSibling) {
			i++;
			var currentThumb:MovieClip = lst.attachMovie("IDthumbSlider", "thumb" + i, lst.getNextHighestDepth());
			currentThumb.addEventListener("thumbLoadedSlider", Proxy.create(this, thumbLoadedSlider));
			currentThumb.addEventListener("thumbSliderReleased", Proxy.create(this, thumbSliderReleased));
			currentThumb.idx = i;
			currentThumb.setNode(nd, settings);
			currentThumb._x = currentPos;
			currentPos += tw + sp + 14;
		}
		
		if (i == 0) {
			next._visible = prev._visible = false;
		}
		
		total = i;
		
		continueLoad();
		
		loadStageResize();
		
		var parentMC:MovieClip = this._parent._parent._parent._parent;

		
		if (parentMC["popupHolder"]) {
			parentMC["popupHolder"].removeMovieClip();
		}
		
		popupHolder = parentMC.createEmptyMovieClip("popupHolder", parentMC.getNextHighestDepth());
		popupHolder._alpha = 0;
		popupHolder.createEmptyMovieClip("bg", popupHolder.getNextHighestDepth());
		popupHolder["bg"].useHandCursor = false;
		popupHolder["bg"].onPress = null;
		popupHolder._visible = false;

		this._alpha = 100;
	}
	
	/**
	 * this will launch the popup
	 */
	public function launchPop() {
		var str:Array = _global.theAddress.split("/");
		
		var themain:String = str[1];
		var project:String = str[2];
		var details:String = str[3];
		var pop:String = str[4];
		
		if (pop) { 
			for (var ii:Number = 0; ii <= total; ii++) {
					if (parseTheStr(lst["thumb" + ii].node.attributes.url) == ("/" + pop)) {
						if (ii > lastIdx) {
							thePopup.hidePrev();
						}
						else {
							thePopup.hideNext();
						}
						
						lst["thumb" + ii].dispatchThisMC();
						break;
					}
				}
		}
	}
	
	/**
	 * function launched when pressing one thumb
	 * @param	obj
	 */
	private function thumbSliderReleased(obj:Object) {
		if (popupActive == 0) {
			popupMode = 1;
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopup", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode, settings, obj.mc);
			showPopup();
			popupActive = 1;
			onResize();
		}
		else {
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopup", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode, settings, obj.mc);
			onResize();
		}

		lastIdx = obj.mc.idx;
	}
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	/**
	 * function used for pressing the next button on the popup
	 * @param	obj
	 */
	private function popupNext(obj:Object) {
		if (lst["thumb" + (obj.mc.idx+1)]) {
			thePopup.hidePrev();
			popupMode = 1;
			lst["thumb" + (obj.mc.idx+1)].onRelease();
		}
	}
	
	/**
	 * function used for pressing the prev button on the popup
	 * @param	obj
	 */
	private function popupPrev(obj:Object) {
		if (lst["thumb" + (obj.mc.idx-1)]) {
			thePopup.hideNext();
			popupMode = 2;
			lst["thumb" + (obj.mc.idx-1)].onRelease();
		}
	}
	
	/**
	 * this will show the popup
	 */
	private function showPopup() {
		popupHolder._visible = true;
		Tweener.removeTweens(popupHolder);
		Tweener.addTween(popupHolder, { _alpha:100, time: .2, transition: "linear" } );
	}
	
	/**
	 * this will close the popup
	 */
	public function closePopup() {
		thePopup.closeThis();
		_global.popPresent = 0;
		Tweener.removeTweens(popupHolder);
		Tweener.addTween(popupHolder, { _alpha:0, time: .2, transition: "linear", onComplete:Proxy.create(this, disablePopup) } );
	}
	
	public function closePopup2() {
		thePopup.closeThisRem();
		_global.popPresent = 0;
		Tweener.removeTweens(popupHolder);
		Tweener.addTween(popupHolder, { _alpha:0, time: .2, transition: "linear", onComplete:Proxy.create(this, disablePopup) } );
	}
	
	private function disablePopup() {
		popupHolder._visible = false;
		popupActive = 0;
	}
	
	private function resize(w:Number, h:Number) {
		drawOval(popupHolder["bg"], w, h, 0, 0x000000, 75);
		
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
	
	private function continueLoad() {
		if (node != null) {
			idx++;
			lst["thumb" + idx].loadPic();
			node = node.nextSibling;
		}
	}
	
	private function thumbLoadedSlider() {
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