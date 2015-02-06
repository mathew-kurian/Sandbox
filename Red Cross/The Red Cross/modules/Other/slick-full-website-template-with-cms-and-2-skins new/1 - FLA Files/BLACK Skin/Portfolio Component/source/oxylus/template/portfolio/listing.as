import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import mx.events.EventDispatcher;
import caurina.transitions.properties.FilterShortcuts;


class oxylus.template.portfolio.listing extends MovieClip 
{
	private var node:XMLNode;
	
	private var settings:Object;
	
	private var first:MovieClip;
	private var title:MovieClip;
	private var ht:MovieClip;
	private var back:MovieClip;
	private var holder:MovieClip;
		private var mask:MovieClip;
		private var lst:MovieClip;
		private var scroller:MovieClip;
			private var bar:MovieClip;
			private var stick:MovieClip;
	
	private var projectHolder:MovieClip;
	private var ph:Number = 0;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	/**
	 * customizable variables
	 * 
	 */
	private var blurAmountX:Number = 20;
	private var blurAmountY:Number = 20;
	private var animTime:Number = 0.3;
	private var animType:String = "easeOutCubic"
	
	private var idx:Number = -1;
	private var px:Number = 0;
	private var py:Number = 0;
	private	var maxw:Number = 900;
	private	var tw:Number = 199 + 14;
	private	var th:Number = 111 + 31 + 7;
	private	var vSpace:Number = 13;
	private	var hSpace:Number = 13;
	
	
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	
	private var myInterval:Number;
	private var init:Number = 1;
	
	private var iii:Number = -1;
	private var ndd:XMLNode;
	
	private var prevNode:XMLNode;
	
	private var currentProject:MovieClip;
	
	public var parentUrl:String;
	
	public var parentUrlTitle:String;
	
	private var currentDetailsNode:MovieClip;
	
	public function listing() {
		FilterShortcuts.init();
		EventDispatcher.initialize(this);
		
		ht = first["ht"];
		title = first["title"];
		back = first["back"];
		holder = first["holder"];
		
		Utils.initMhtf(ht["txt"], false);
		title["txt"].autoSize = true;
		title["txt"].selectable = false;
		
		ht["txt"]._width = maxw;
		
		
		mask = holder["mask"];
		lst = holder["lst"];
		lst.setMask(mask);
		
		scroller = holder["scroller"];
			bar = scroller["bar"];
			stick = scroller["stick"];
			
		back.onRollOver = Proxy.create(this, backOnRollOver);
		back.onRollOut = Proxy.create(this, backOnRollOut);
		back.onRelease = back.onReleaseOutside = Proxy.create(this, backOnRelease);
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object) {
		if (n != prevNode) {
			node = prevNode = n;
			settings = settings_;
			
			hSpace = settings.horizontalSpace;
			vSpace = settings.verticalSpace;
			
			blurAmountX = settings.blurXAmount;
			blurAmountY = settings.blurYAmount;
			animType = settings.animationType;
			animTime = settings.animationTime;
			
			ht["txt"]._width = settings.projectsListingTextWidth;
			mask._width = settings.projectsListingMaskWidth;
			mask._height = settings.projectsListingMaskHeight;
			maxw = mask._width;
			scroller["stick"]._height = mask._height;
			scroller._x = Math.round(mask._width + 4);
			
			back._x = Math.round(settings.backXPos);
			
			title["txt"].text = node.attributes.title;
			ht["txt"].htmlText = node.firstChild.firstChild.nodeValue;
			holder._y = Math.round(title._height + ht._height + 14);
			
			tw = settings.thumbWidthProjectTypeListing + 14;
			th = settings.thumbHeightProjectTypeListing + 31 + 7;
			
			idx = iii = -1;
			px = py = 0;
			
			ndd = node;
			node = node.firstChild.nextSibling.firstChild;
			
			var i:Number = 0;
			while (lst["thumb" + i]) {
				lst["thumb" + i].removeMovieClip();
				i++;
			}
			
			while (node != null) {
				initElem();
				node = node.nextSibling;
			}
			
			processLoad();
			
			ScrollBox();
			updateContentPosition();
			
			Utils.setMcBlur(first, blurAmountX, blurAmountY, 1);
		}
		
		var str:Array = _global.theAddress.split("/");
		var themain:String = str[1];
		var project:String = str[2];
		var details:String = str[3];
		var pop:String = str[4];
		
		if (!details) {
			currentProject.cancelThis2();
			currentDetailsNode = undefined;
			step(0);
			
			if (!pop) {
				currentProject.Slider.closePopup2();
			}
		}
		else {
			step( -1);
			for (var i:Number = 0; i <= idx; i++) {
				if (parseTheStr(lst["thumb" + i].node.attributes.url) == ("/" + details)) {
					lst["thumb" + i].dispatchThisMC();
					break;
				}
			}
		}
		
		dispatchEvent( { target:this, type:"listingCreated"} );
	}
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	/**
	 * this will cancel the other sections of the module
	 */
	public function cancelOthers() {
		currentProject.cancelThis2();
		step(1);
	}
	
	/**
	 * this will attach the movie clips
	 */
	private function initElem() {
			idx++;
			var currentItem:MovieClip = lst.attachMovie("IDthumbListing", "thumb" + idx, lst.getNextHighestDepth());
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentItem.addEventListener("thumbReleased", Proxy.create(this, thumbReleased));

			
			currentItem.setNode(node, settings, ndd);
	
			currentItem._x = Math.round(px);
			currentItem._y = Math.round(py);
			
			px += tw + hSpace;
			if ((px+tw) > maxw) {
				px = 0;
				py += th + vSpace;
			}
	}
	
	/**
	 * this will progressively load the mcs
	 */
	private function processLoad() {
		iii++;
		lst["thumb"+iii].loadPic();
	}
	
	
	/**
	 * function launched when pressing one thumb
	 * @param	obj
	 */
	private function thumbReleased(obj:Object) {
		if (currentDetailsNode != obj.thumb.node) {
			projectHolder["proj" + ph].removeMovieClip();
			ph++;
			var myp:MovieClip = projectHolder.attachMovie("IDproject", "proj" + ph, projectHolder.getNextHighestDepth());
			myp.addEventListener("projectLoaded", Proxy.create(this, projectLoaded));
			
			myp.parentUrl = obj.thumb.parentUrl;
			myp.parentUrlTitle = obj.thumb.parentUrlTitle;
			currentDetailsNode = obj.thumb.node;
			myp.setNode(obj.thumb.node, settings);
			currentProject = myp;
		}
		else {
			currentProject.checkAddress();
		}
	}
	
	private function projectLoaded() {
		step(-1);
	}
	
	private function thumbLoaded() {
		processLoad();
	}
	
	/**
	 * executing the slide
	 * @param	ident
	 */
	private function step(ident:Number) {
		Tweener.addTween(this, { _x:970 * ident, time: animTime, transition: animType } );
		Tweener.addTween(first, { _Blur_blurX:Math.abs(ident*blurAmountX), _Blur_blurY:Math.abs(ident*blurAmountY), time: animTime, transition: "linear" } );
	}
	

	/**
	 * function launched when pressing the back button
	 */
	private function backOnRelease() {
		SWFAddress.setValue(parentUrl);
		SWFAddress.setTitle(parentUrlTitle);
		
		backOnRollOut();
	}
	
	
	
	
	
	private function backOnRollOver() {
		Tweener.addTween(back, { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function backOnRollOut() {
		Tweener.addTween(back, { _alpha:50, time: .2, transition: "linear" } );
	}
	
	/**
	 * function for handling the scroller
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
			scroller._visible = true;
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
}