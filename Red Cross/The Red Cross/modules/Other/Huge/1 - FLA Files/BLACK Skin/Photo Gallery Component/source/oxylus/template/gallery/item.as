import oxylus.Utils;
import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import flash.filters.BlurFilter;

class oxylus.template.gallery.item extends MovieClip 
{
	private var node:XMLNode;
	
	private var lst:MovieClip;
	
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
	
	/**
	 * customizable values
	 */
	private var blurXAmount:Number = 60;
	private var blurYAmount:Number = 0;
	
	
	private var idx:Number = 0;
	private var posX:Number = 0;
	private var posY:Number = 0;
	private var settings:Object;
	
	private var popupId:Number = -1;
	private var popupActive:Number = 0;
	private var popupHolder:MovieClip;
	private var thePopup:MovieClip;
	private var popupMode:Number = 1;
	
	private var totals:Number = 0;
	
	private var loading:Number = 1;
	private var treatingAddress:String ="";
	
	private var nd:XMLNode;
	
	
	private var lstWidth:Number = 0;
	
	private var speed:Number = 8;
	private var tol:Number = 30;
	private var xpos:Number;
	
	public function item() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		FilterShortcuts.init();
		
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		lst.setMask(mask);
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object) {
		node = n.firstChild;
		nd = node;
		settings = settings_;
		
		
		
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
		
		if (settings.scrollerBehavior == 0) {
			mask._height = settings.thumbHeight + 20;
			mask._y = -5;
		}
		
		loadNext();
		
		if (settings.scrollerBehavior == 0) {
			setInterval(this, "movemouse", 30);
		}
		
		
		Utils.setMcBlur(this, blurXAmount, blurYAmount, 1);
	}
	
	/**
	 * this will treat the address
	 * @param	str_
	 */
	public function treatAddress(str_:String) {
		treatingAddress = str_;
		if (loading == 0) {
			if (treatingAddress != "") {
				for (var i:Number = 0; i <= totals; i++) {
					if (parseTheStr(lst["thumb" + i].node.attributes.url) == ("/" + treatingAddress + "/")) {
						thePopup.hidePrev();
						lst["thumb" + i].dispatchThisMC();
						break;
					}
				}
			}
		}
	}
	
	private function thumbLoaded(obj:Object) {
		loadNext();
		ScrollBox();
	}
	
	/**
	 * this will keep loading the thumbs
	 */
	private function loadNext() {
		if (node != null) {
			idx++;
			var theThumb:MovieClip = lst.attachMovie("IDthumb", "thumb" + idx, lst.getNextHighestDepth());
			theThumb.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			theThumb.addEventListener("thumbReleased", Proxy.create(this, thumbReleased));
			theThumb.idx = idx;
			theThumb._x = Math.round(posX);
			
			if (settings.scrollerBehavior == 1) {
				theThumb._y = Math.round(posY);
			}
			else {
				theThumb._y = Math.round(0);
			}
			
			
			var ww:Number = settings.thumbWidth + 10;
			
			posX += ww + settings.horizontalThumbSpace;
			
			if (settings.scrollerBehavior == 1) {
				if ((posX + ww + settings.horizontalThumbSpace) > mask._width) {
					posX = 0;
					posY += settings.thumbHeight + 10 + settings.verticalThumbSpace;
				}
			}
			
			
			
			theThumb.setNode(node, settings);
			
			node = node.nextSibling;
			
			if (settings.scrollerBehavior == 0) {
				lstWidth = posX + ww + settings.horizontalThumbSpace;
			}
			
		}
		else {
			totals = idx;
			loading = 0;
			var str:Array = _global.theAddress.split("/");
			var last:String = str[3];
			if (last) {
				for (var i:Number = 0; i <= totals; i++) {
					if (parseTheStr(lst["thumb" + i].node.attributes.url) == ("/" + last + "/")) {
						thePopup.hidePrev();
						lst["thumb" + i].dispatchThisMC();
						break;
					}
				}
			}
			
			if (settings.scrollerBehavior == 1) {
				if (totals == 0) {
					scroller._visible = false;
				}
			}
			
			
		}
	}
	
	public function movemouse() // this mouse executes on an interval and it will verify if the mouse is on the scroller, in order to make it "move"
	{
		
		if ((_xmouse>0) && (_xmouse<mask._width) && (_ymouse<(mask._height - 5)) && (_ymouse>-5)) {
			var xm:Number = _xmouse - tol;
			if (xm<0) {
				xm = -3;
				
			}
			
			if (xm>(mask._width-2*tol)) {
				xm = mask._width -2*tol;
			}
			
			xpos = Math.round((xm*(mask._width-lstWidth))/(mask._width-2*tol));
			trace(xpos)
			lst.onEnterFrame = Proxy.create(this, enterFrameFunction, xpos, lstWidth);
			
		}
	}
	
	private function enterFrameFunction(xpos:Number, lstWidth:Number) {
				if (Math.abs(lst._x-xpos)<1) {
					delete lst.onEnterFrame;
					blur(0,lst);
					lst._x = xpos;
					return;
				} else {
					if (Math.abs(xpos-lst._x)>50) {
							blur(Math.abs((xpos - lst._x) / 12), lst);
						
						} else {
							blur(0, lst);
						}
						
					lst._x += Math.round((xpos - lst._x) / speed);
				}
		trace(xpos + " " + lst._x + " " + lst._width + " " + lstWidth + " " + speed)
	}
	
	public static function blur(blurX:Number, mc:MovieClip) //function used for blurring the image
	{
		var blurY:Number = 0;
		var quality:Number = 2;
		var filter:BlurFilter = new BlurFilter(blurX, blurY, quality);
		if (blurX == 0) {
			mc.filters = [];
		}
		else {
			mc.filters = [filter];
		}
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	/**
	 * actions for pressing one thumb
	 * @param	obj
	 */
	private function thumbReleased(obj:Object) {
		if (popupActive == 0) {
			popupMode = 1;
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopupGallery", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("closePopup", Proxy.create(this, closePopup));
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode, settings);
			showPopup();
			popupActive = 1;
			onResize();
		}
		else {
			popupId++;
			thePopup = popupHolder.attachMovie("IDpopupGallery", "popup" + popupId, popupHolder.getNextHighestDepth());
			thePopup.addEventListener("closePopup", Proxy.create(this, closePopup));
			thePopup.addEventListener("popupNext", Proxy.create(this, popupNext));
			thePopup.addEventListener("popupPrev", Proxy.create(this, popupPrev));
			thePopup.idx = obj.mc.idx;
			thePopup.setNode(obj.mc.node, popupMode, settings);
			onResize();
		}
	}
	
	/**
	 * this will call the next popup
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
	 * this will cal the previous popup
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
	 *  this will close the popup
	 * @param	obj
	 */
	private function closePopup(obj:Object) {
		_global.popPresent = 0;
		Tweener.removeTweens(popupHolder);
		Tweener.addTween(popupHolder, { _alpha:0, time: .2, transition: "linear", onComplete:Proxy.create(this, disablePopup) } );

		SWFAddress.setValue(nd.parentNode.parentNode.attributes.url + nd.parentNode.attributes.url);
		SWFAddress.setTitle(nd.parentNode.parentNode.attributes.urlTitle + " - " + nd.parentNode.attributes.urlTitle);
	}
	
	/**
	 * this will disable the popup
	 */
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
	
	/**
	 * this will handle the scroller
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
		ScrollArea.onRelease = ScrollArea.onReleaseOutside = Proxy.create(this, stopScroll);
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
			scroller._visible = true;
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