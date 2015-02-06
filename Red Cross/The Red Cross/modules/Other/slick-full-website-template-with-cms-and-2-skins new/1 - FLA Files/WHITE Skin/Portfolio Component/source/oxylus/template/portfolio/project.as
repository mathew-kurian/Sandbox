import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import mx.events.EventDispatcher;
import caurina.transitions.properties.FilterShortcuts;

class oxylus.template.portfolio.project extends MovieClip
{
	private var title:MovieClip;
	
	private var ht:MovieClip;
		private var h:MovieClip;
		private var scroller:MovieClip;
			private var bar:MovieClip;
			private var stick:MovieClip;
		private var mask:MovieClip;
		
	private var back:MovieClip;
	
	public var Slider:MovieClip;
	
	private var node:XMLNode;
	private var settings:Object;
	
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
	
	public var parentUrl:String;
	public var parentUrlTitle:String;
	
	public function project() {
		EventDispatcher.initialize(this);
		FilterShortcuts.init();
		
		title["txt"].autoSize = true;
		title["txt"].selectable = false;
		h = ht["h"];
		scroller = ht["scroller"];
			bar = scroller["bar"];
			stick = scroller["stick"];
		mask = ht["mask"];
		h.setMask(mask);
		Utils.initMhtf(h["txt"], false);
		h["txt"]._width = 390;
		
		
		back.onRollOver = Proxy.create(this, backOnRollOver);
		back.onRollOut = Proxy.create(this, backOnRollOut);
		back.onRelease = back.onReleaseOutside = Proxy.create(this, backOnRelease);
	}
	
	/**
	 * this will setup the .xml file node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object) {
		node = n;
		settings = settings_;
		
		blurAmountX = settings.blurXAmount;
		blurAmountY = settings.blurYAmount;
		animType = settings.animationType;
		animTime = settings.animationTime;
		
		title["txt"].text =  node.attributes.title;
		
		h["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		
		ScrollBox();
		
		Utils.setMcBlur(this, blurAmountX, blurAmountY, 1);
		Tweener.addTween(this, { _Blur_blurX:0, _Blur_blurY:0, time: animTime, transition: animType} );
		
		
		clearInterval(myInterval);
		myInterval = setInterval(this, "initSlider", animTime * 100 + 500);
		
		if (node.firstChild.nextSibling.firstChild == null) {
			clearInterval(myInterval);
			Slider._visible = false;
			h["txt"]._width += 500;
			mask._width = h["txt"]._width + 30;
			scroller._x = Math.round(h._x + h["txt"]._width + 10);
			
			ScrollBox();
		}
		
		dispatchEvent( { target:this, type:"projectLoaded" } );
		
		
	}
	
	/**
	 * this will handle the swf address change
	 */
	public function checkAddress() {
		var str:Array = _global.theAddress.split("/");
		
		var themain:String = str[1];
		var project:String = str[2];
		var details:String = str[3];
		var pop:String = str[4];
		
		if (!pop) {
			Slider.closePopup();
		}
		else{
			Slider.launchPop();
		}
		
		
	}
	
	/**
	 * this will init the slider
	 */
	private function initSlider() {

		if (node.firstChild.nextSibling.firstChild != null) {
			clearInterval(myInterval);
			Slider.setNode(node.firstChild.nextSibling.firstChild, settings);
			checkAddress();
		}
		else {
			clearInterval(myInterval);
		}
	}
	
	/**
	 * this will be launched when pressing the back button
	 */
	private function backOnRelease() {
		backOnRollOut();
		SWFAddress.setValue(parentUrl);
		SWFAddress.setTitle(parentUrlTitle);
	}
	
	public function cancelThis() {
		Slider.closePopup();
		Tweener.addTween(this, { _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animTime, transition: "linear",onComplete:Proxy.create(this, rem) } ); //,onComplete:Proxy.create(this, rem)
	}
	
	public function cancelThis2() {
		Slider.closePopup2();
		Tweener.addTween(this, { _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animTime, transition: "linear",onComplete:Proxy.create(this, rem) } ); //,onComplete:Proxy.create(this, rem)
	}
	
	private function rem() {
		this.removeMovieClip();
	}
	
	private function backOnRollOver() {
		Tweener.addTween(back, { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function backOnRollOut() {
		Tweener.addTween(back, { _alpha:50, time: .2, transition: "linear" } );
	}
	
	/**
	 * this will handle the scroller
	 */
	private function ScrollBox() {
		ScrollArea = scroller["stick"];
		ScrollButton = scroller["bar"];
		Content = h;
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
			
			if(ScrollButton._height>(ScrollArea._height - 4)){
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
		Tweener.addTween(bar, { _alpha:24, time:0.15, transition:"linear" } );
	}
}