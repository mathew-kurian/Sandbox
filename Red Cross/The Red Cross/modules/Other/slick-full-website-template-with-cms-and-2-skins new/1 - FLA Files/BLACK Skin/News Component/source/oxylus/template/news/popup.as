import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import ascb.util.Proxy;
import oxylus.Utils;
import mx.events.EventDispatcher;
import TextField.StyleSheet;


class oxylus.template.news.popup extends MovieClip 
{
	public var node:XMLNode;
	public var idx:Number;

	
	private var bg:MovieClip;
	private var navigation:MovieClip;
		private var next:MovieClip;
		private var prev:MovieClip;
		private var navigationBg:MovieClip;
	private var content:MovieClip;
		private var title:MovieClip;
		private var holder:MovieClip;
			private var lst:MovieClip;
				private var subTitle:MovieClip;
				private var date:MovieClip;
				private var ht:MovieClip;
			private var mask:MovieClip;
			private var scroller:MovieClip;
				private var bar:MovieClip;
				private var stick:MovieClip;
		private var close:MovieClip;
	
	/**
	 * Exclusively for the scroller
	 */
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
	 * Customizable variables
	 */
	private var blurAmountX:Number = 40;
	private var blurAmountY:Number = 0;
	private var animationTime:Number = .5;
	private var animationType:String = "easeOutQuart";
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function popup() {
		FilterShortcuts.init();
		EventDispatcher.initialize(this);
		
		holder = content["holder"];
		title = content["title"];
		lst = holder["lst"];
		subTitle = lst["subTitle"];
			subTitle["txt"].selectable = false; 
			subTitle["txt"].autoSize = true;
			subTitle["txt"].wordWrap = true;
			subTitle["txt"]._width = 430;
		date = lst["date"];
			date["txt"].selectable = false; 
			date["txt"].autoSize = true;
		ht = lst["html"];
		mask = holder["mask"];
		scroller = holder["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		Utils.initMhtf(ht["txt"], false);
		ht["txt"]._width = mask._width;
		var ss:StyleSheet = new StyleSheet();
		ss.setStyle("a", { leading:"6" } ); 
		
		ht["txt"].styleSheet = ss;
		
		close = content["close"];
		
		next = navigation["next"];
		prev = navigation["prev"];
		navigationBg = navigation["bg"];
		next._y = prev._y = Math.round(navigationBg._height / 2 - next._height / 2);
		next._x = Math.round(navigationBg._width - next._width - 8);
		
		navigation._x = Math.round(bg._width / 2 - navigation["bg"]._width / 2);
		navigation._y = Math.round(bg._height / 2 - navigation["bg"]._height / 2);
		
		close.onRollOver = Proxy.create(this, closeOnRollOver);
		close.onRollOut = Proxy.create(this, closeOnRollOut);
		close.onPress = Proxy.create(this, closeOnPress);
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
	}
	
	
	private function nextOnPress() {
		next.enabled = prev.enabled = false;
		dispatchEvent( { target:this, type:"popupNext", mc:this } );
	}
	
	private function prevOnPress() {
		next.enabled = prev.enabled = false;
		dispatchEvent( { target:this, type:"popupPrev", mc:this } );
	}
	
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"] , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"] , { _alpha:0, time: .2, transition: "linear" } );
		

	}
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"] , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"] , { _alpha:0, time: .2, transition: "linear" } );
	}
	
	
	
	private function closeOnRollOver() {
		Tweener.addTween(close["over"] , { _alpha:100, time: .2, transition: "linear" } );
		Tweener.addTween(close["over"]["a"] , { _rotation:180, time: .2, transition: "linear" } );
		Tweener.addTween(close["normal"]["a"] , { _rotation:180, time: .2, transition: "linear" } );
	}
	
	private function closeOnRollOut() {
		Tweener.addTween(close["over"] , { _alpha:0, time: .2, transition: "linear" } );
		Tweener.addTween(close["over"]["a"] , { _rotation:0, time: .2, transition: "linear" } );
		Tweener.addTween(close["normal"]["a"] , { _rotation:0, time: .2, transition: "linear" } );
	}
	
	private function closeOnPress() {
		dispatchEvent( { target:this, type:"closePopup", mc:this } );
	}
	
	/**
	 * this will setup the xml node
	 * @param	n
	 * @param	sett_
	 */
	public function setNode(n:XMLNode, sett_:Object) {
		node = n;
		
		blurAmountX = sett_.blurXAmount;
		blurAmountY = sett_.blurYAmount;
		animationTime = sett_.animationTime;
		animationType = sett_.animationType;
		
		title["txt"].autoSize = true;
		title["txt"].text = node.attributes.mainTitle;
		subTitle["txt"].text = node.attributes.title;
		date["txt"].text = node.attributes.date;
		date._y = Math.round(subTitle._y + subTitle._height);
		ht._y = Math.round(date._y + date._height + 6);
		ht["txt"].htmlText = node.firstChild.nodeValue;
		ScrollBox();
		
		
		if (!node.nextSibling) {
			next.enabled = false;
			next._alpha = 50;
		}
		
		if (!node.previousSibling) {
			prev.enabled = false;
			prev._alpha = 50;
		}
		
		
		show();
	}
	
	/**
	 * this will show the popup
	 */
	private function show() {
		Utils.setMcBlur(this, 90, 0, 1);
		Tweener.addTween(this, { _x:0, _Blur_blurX:0, _Blur_blurY:0, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, showDone) } );
	}
	
	public function hideNext() {
		Tweener.addTween(this, { _x:Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	public function hidePrev() {
		Tweener.addTween(this, { _x:-Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	private function removeMe() {
		this.removeMovieClip();
	}
	
	private function showDone(){
		dispatchEvent( { target:this, type:"showDone", mc:this } );
	}
	
	/**
	 * actions for handling the scroller
	 */
	private function ScrollBox() {
		ScrollArea = stick;
		ScrollButton = bar;
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
			mask._width += 24;
			ht["txt"]._width = mask._width;
		
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
	
}