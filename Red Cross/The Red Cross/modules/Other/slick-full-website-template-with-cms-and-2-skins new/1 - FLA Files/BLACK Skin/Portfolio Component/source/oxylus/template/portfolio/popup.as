import flash.filters.DropShadowFilter;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import ascb.util.Proxy;
import oxylus.Utils;
import mx.events.EventDispatcher;

class oxylus.template.portfolio.popup extends MovieClip
{
	private var node:XMLNode;
	private var settings:Object;
	
	public var idx:Number;
	private var popupMode:Number;
	
	private var videoPresent:Number = 0;
	private var obj:Object;
	private var vid:MovieClip;
	
	private var a:MovieClip;
	
	private var init:Number = 0;
	
	private var navigation:MovieClip;
		private var next:MovieClip;
		private var prev:MovieClip;
	
	private var bg:MovieClip;
	
	private var holder:MovieClip;
		private var title:MovieClip;
			private var titleMask:MovieClip;
		private var line:MovieClip;
		private var picture:MovieClip;
			private var loader:MovieClip;
			private var stroke:MovieClip;
			private var img:MovieClip;
			private var loaded:Number = 0;
			private var ref:MovieClip;
			private var mcl:MovieClipLoader;
		private var close:MovieClip;
		private var ht:MovieClip;
			private var html:MovieClip;
			private var scroller:MovieClip;
				private var bar:MovieClip;
				private var stick:MovieClip;
			private var mask:MovieClip;
	
	/**
	 * for the html field
	 * 
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
	private var tw:Number = 500;
	private var th:Number = 500;
	
	private var blurAmountX:Number = 40;
	private var blurAmountY:Number = 0;
	private var animationTime:Number = .5;
	private var animationType:String = "easeOutQuart";
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var parentThumb:MovieClip;
	
	public function popup() {
		EventDispatcher.initialize(this);
		
		this._visible = false;
		
		
		holder = a["holder"];
		bg = a["bg"];
		navigation = a["navigation"];
		
		
		
		next = navigation["next"]; next["over"]._alpha = 0;
		prev = navigation["prev"]; prev["over"]._alpha = 0;
		
		title = holder["title"]; title["txt"].autoSize = true;
		titleMask = title["mask"];
		
		title.cacheAsBitmap = true;
		titleMask.cacheAsBitmap = true;
		
		title.setMask(titleMask);
		
		line = holder["line"];
		picture = holder["picture"];
			stroke = picture["stroke"];
			loader = picture["loader"];
			img = picture["img"];
			ref = picture["ref"];
			
		vid = holder["vid"];
		
		ht = holder["ht"];
			html = ht["html"]; Utils.initMhtf(html["txt"], false);
			mask = ht["mask"];
			scroller = ht["scroller"];
				bar = scroller["bar"];
				stick = scroller["stick"];
		html.setMask(mask);
		
		//mask._height -= 6;
		stick._height = mask._height;
		
		
		close = holder["close"];
		close.onPress = Proxy.create(this, closeThis);

		close.onRollOver = Proxy.create(this, closeOnRollOver);
		close.onRollOut = Proxy.create(this, closeOnRollOut);
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		buildNavigation();
		
		buildBackground();
	}
	
	/**
	 * actions for pressing the next button
	 */
	private function nextOnPress() {
		
		next.enabled = prev.enabled = false;
		
		dispatchEvent( { target:this, type:"popupNext", mc:this } );
		
		if (videoPresent == 1) {
			vid["a"].videoKill();
		}
	}
	
	/**
	 * actions for pressing the prev button
	 */
	private function prevOnPress() {
		
		next.enabled = prev.enabled = false;
		
		dispatchEvent( { target:this, type:"popupPrev", mc:this } );
		
		if (videoPresent == 1) {
			vid["a"].videoKill();
		}
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
	
	/**
	 * this will close the popup
	 */
	public function closeThis() {
		_global.popPresent = 0;
		
		if (popupMode == 1) {
			hidePrev();
		}
		else {
			hideNext();
		}
		
		if (videoPresent == 1) {
			vid["a"].videoKill();
		}
		
		SWFAddress.setValue(parentThumb.parentUrl);
		SWFAddress.setTitle(parentThumb.parentUrlTitle);
	}
	
	/**
	 * this is a second function also used for remotely closing the popup
	 */
	public function closeThisRem() {
		_global.popPresent = 0;
		
		if (popupMode == 1) {
			hidePrev();
		}
		else {
			hideNext();
		}
		
		if (videoPresent == 1) {
			vid["a"].videoKill();
		}
	}
	
	/**
	 * this will setup the node
	 * @param	n
	 * @param	pM
	 * @param	settings_
	 * @param	parThumb
	 */
	public function setNode(n:XMLNode, pM:Number, settings_:Object, parThumb:MovieClip ) {
		
		parentThumb = parThumb;
		
		_global.popPresent = 1;
		
		popupMode = pM;
		
		node = n;
		
		settings = settings_;
		
		blurAmountX = settings.popupBlurXAmount;
		
		blurAmountY = settings.popupBlurYAmount;
		
		animationTime = settings.popupAnimationTime;
		
		animationType = settings.popupAnimationType;
	
		if (popupMode == 1) {
			a._x = Stage.width;
		}
		else {
			a._x = -Stage.width;
		}
		
		title["txt"].text = node.firstChild.parentNode.attributes.title;
		
		titleMask._height = 2*title._height;
		
		var str:String = node.firstChild.firstChild.nextSibling.firstChild.nodeValue;
		html["txt"].htmlText = str;
		
		loadStageResize();
		
		this._visible = true;
		
		
		
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
	 * this will laod the picture
	 */
	private function loadPicture() {
		var str:String = node.firstChild.firstChild.attributes.src;
		
		var arr:Array = str.split(".");
		
		if ((arr[arr.length - 1] == "flv") || (arr[arr.length - 1] == "mov") || (arr[arr.length - 1] == "mp4") || (arr[arr.length - 1] == "h264")) {
			videoPresent = 1;
			
			obj = new Object();
			
			obj.width = tw - 60;
			obj.height = th - 80 - 140;
			obj.movie = node.firstChild.firstChild.attributes.src;
			obj.title = node.firstChild.firstChild.attributes.title;
			obj.videosize = 0;
			obj.buffer = 1;
			obj.volume = 10;
			obj.autoplay = false;
			obj.repeat = false;
			obj.smoothing = true;
			obj.fullscreen = false;
			
			
			vid["a"].setTheObject(obj);
			
			onResize();
			
			img._visible = false;
			
		}
		else {
			videoPresent = 0;
			mcl.loadClip(node.firstChild.firstChild.attributes.src, img);
			vid._visible = false;
		}
		
		trace("Video status: " + videoPresent);
	}
	
	/**
	 * function launched as soon as the picture has loaded
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		Utils.getImage(mc, true);
		loaded = 1;
		init = 1;
		onResize();
		Tweener.addTween(img, { _alpha:100, time: .5, transition: "linear"} );
		Tweener.addTween(stroke, { _alpha:100, time: .5, transition: "linear" } );
		loaderRemove()
	}
	
	/**
	 * this will remove the loader
	 */
	private function loaderRemove() {
		loader["spin"].stop();
		loader._visible = false;
		loader.removeMovieClip();
	}
	
	/**
	 * this will show the popup
	 */
	private function show() {
		Utils.setMcBlur(a, blurAmountX, blurAmountY, 1);
		Tweener.addTween(a, { _x:0, _Blur_blurX:0, _Blur_blurY:0, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, loadPicture) } );
	}
	
	/**
	 * hideNext and hidePrev will hide the popup the only difference consists in the direction
	 */
	public function hideNext() {
		Tweener.addTween(a, { _x:Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	public function hidePrev() {
		Tweener.addTween(a, { _x:-Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	/**
	 * this will completely remove the popup
	 */
	private function removeMe() {
		this.removeMovieClip();
	}
	
	/**
	 * this will build the background of the popup
	 */
	private function buildBackground() {
		drawOval(bg, tw, th, 6, 0x000000, 90);
	}
	
	/**
	 * this will build the navigation
	 */
	private function buildNavigation() {
		drawOval(navigation["bg"], tw + 80, 196, 6, 0x000000, 80);
		next._x = Math.round(navigation["bg"]._width - next._width - 8);
		prev._x = 8;
		next._y = prev._y = Math.round(navigation["bg"]._height / 2 - next._height / 2);
		addShadow(navigation["bg"]);
		navigation._x = Math.round(bg._width / 2 - navigation._width / 2);
		navigation._y = Math.round(bg._height / 2 - navigation._height / 2);
	}
	
	/**
	 * this will resize the components
	 * @param	w
	 * @param	h
	 */
	private function resize(w:Number, h:Number) {
		tw = w;
		th = h;
		
		var iw:Number = tw - 60;
		var ih:Number = th - 80 - 140;
		
		
		
		if (init == 0) { // before the image has fully loaded
			
			if (videoPresent == 1) {
				vid["a"].resizeEZ(iw, ih);
			}
			
			
			if (Tweener.isTweening(loader)) {
				tweensFinished();
			}
			/**
			 * image resize
			 */
			loader._x = Math.round(iw/ 2 - loader._width / 2);
			loader._y = Math.round(ih / 2 - loader._height / 2);
			
			if (loaded == 1) {
				var obj:Object = Utils.getDims("fit", img._width, img._height, iw-4, ih-4, true);
				img._width = obj.w;
				img._height = obj.h;
				img._x = 2;
				img._y = 2;
				
				obj.w += 4;
				obj.h += 4;

				stroke._width = obj.w;
				stroke._height = obj.h;
				stroke._x = 0;
				stroke._y = 0;
			}
			else {
				var obj:Object = new Object();
				obj.w = iw;
				obj.h = ih;
			}
			
			tw = obj.w + 60;
			th = obj.h + 80 + 140;
			
			titleMask._width = tw - 90;		
			
			line._width = tw - 2 * 17;
			
			close._x = 	titleMask._width;
			
			
			/**
			 * html resize
			 */
			
			 ht._y = Math.round(th - 27 - 100 - 24);
			 mask._width =  Math.round(tw - 60);
			 html["txt"]._width = Math.round(mask._width - 30);
			 scroller._x = Math.round(mask._width - scroller._width);
			
			 ScrollBox();
			 updateContentPosition();
			 
			 if (scroller._visible == false) {
				 th = th - 100 + html._height;
			 }
			 
			 buildBackground();
			 buildNavigation();
			
			 
			 this._x = Math.round(Stage.width / 2 - bg._width / 2);
			 this._y = Math.round(Stage.height / 2 - bg._height / 2);
		}
		else {
			/**
			 * image resize
			 */
			var aTime:Number = .7;
			var aType:String = "easeOutQuart";
			
			Tweener.addTween(loader,  { _x:Math.round(iw / 2 - loader._width / 2), _y:Math.round(ih / 2 - loader._height / 2),
										time: aTime, transition: aType, rounded:true } );
			
			/**loader._x = Math.round(iw/ 2 - loader._width / 2);
			loader._y = Math.round(ih / 2 - loader._height / 2);*/
			
			
			var obj:Object = Utils.getDims("fit", img._width, img._height, iw - 4, ih - 4, true);
		
										
			img._width = obj.w;
			img._height = obj.h;
			/*img._x = 2;
			img._y = 2;*/
			
			img._x = iw / 2 - obj.w / 2 + 2;
			img._y = ih / 2 - obj.h / 2 + 2;
		
			Tweener.addTween(img,  { _x:2, _y:2,
										time: aTime, transition: aType, rounded:true } );
										
			obj.w += 4;
			obj.h += 4;
			
			
			
			stroke._width = obj.w;
			stroke._height = obj.h;
			/*stroke._x = 0;
			stroke._y = 0;*/
			
			stroke._x = iw / 2 - obj.w / 2 ;
			stroke._y = ih / 2 - obj.h / 2 ;
			
			Tweener.addTween(stroke,  { _x:0, _y:0,
										time: aTime, transition: aType, rounded:true } );
										
			tw = obj.w + 60;
			th = obj.h + 80 + 140;
			
			Tweener.addTween(titleMask, { _width:tw - 90,
										time: aTime, transition: aType, rounded:true } );
			
			Tweener.addTween(line, { _width:tw - 2 * 17,
										time: aTime, transition: aType, rounded:true } );
			
			Tweener.addTween(close, { _x:tw - 90,
										time: aTime, transition: aType, rounded:true } );			
			
			
			/**
			 * html resize
			 */
			
			 Tweener.addTween(ht, { _y:Math.round(th - 27 - 100 - 24),
										time: aTime, transition: aType, rounded:true } );
										
			Tweener.addTween(mask, { _width:Math.round(tw - 60),
										time: aTime, transition: aType, rounded:true } );
			
			Tweener.addTween(html["txt"], { _width:Math.round(tw - 60 - 30),
										time: aTime, transition: aType, rounded:true, onUpdate:Proxy.create(this, updateOthersByHtml), onComplete:Proxy.create(this, tweensFinished) } );
										
										
			Tweener.addTween(scroller, { _x:Math.round(tw - 60 - scroller._width),
										time: aTime, transition: aType, rounded:true } );							
		
		}
		
	}
	
	/**
	 * this will kill all the existing tweens
	 */
	private function killTweens() {
		Tweener.removeTweens(this);
		Tweener.removeTweens(scroller);
		Tweener.removeTweens(html["txt"]);
		Tweener.removeTweens(mask);
		Tweener.removeTweens(ht);
		Tweener.removeTweens(close);
		Tweener.removeTweens(line);
		Tweener.removeTweens(titleMask);
		Tweener.removeTweens(loader);
	}
	
	private function tweensFinished() {
		init = 0;
		killTweens();
	}
	
	private function updateOthersByHtml() {
			 ScrollBox();
			 updateContentPosition();
			 
			 if (scroller._visible == false) {
				 var ttt:Number = html._height - 100;
			 }
			 else {
				 var ttt:Number = 0;
			 }
			 
			 var tww:Number = html["txt"]._width + 60 + 30;
			 var thh:Number = ht._y + 27 + 100 + 16 + ttt;
			 
			 drawOval(bg, tww, thh, 6, 0x000000, 90);
			 
			drawOval(navigation["bg"], tww + 80, 196, 6, 0x000000, 80);
			next._x = Math.round(navigation["bg"]._width - next._width - 8);
			prev._x = 8;
			next._y = prev._y = Math.round(navigation["bg"]._height / 2 - next._height / 2);
			addShadow(navigation["bg"]);
			navigation._x = Math.round(tww / 2 - navigation._width / 2);
			navigation._y = Math.round(thh / 2 - navigation._height / 2);
			
			this._x = Math.round(Stage.width / 2 - tww / 2);
			this._y = Math.round(Stage.height / 2 - thh / 2);
			
	}
	
	/**
	 * this will resize the components
	 */
	private function onResize() {
		
		if ((Stage.width - 200) > 800) {
			var myW:Number = 800;
		}
		else {
			var myW:Number = Stage.width - 200;
		}
		
		if ((Stage.height - 60) > 800) {
			var myH:Number = 800;
		}
		
		else {
			var myH:Number = Stage.height - 60;
		}
		
		if (myW < 400) {
			myW = 400;
		}
		
		if (myH < 500) {
			myH = 500;
		}
		
		resize(myW, myH);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
		mc.clear();
		mc.beginFill(fillColor, alphaAmount);
		mc.lineStyle(1, 0x252525, alphaAmount, true);
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
	
	/**
	 * This function will add the shadow to the background
	 */
	private function addShadow(mc:MovieClip) {
		var shadowDistance = 1;
		var shadowAngleInDegrees = 45;
		var shadowColor = 0x000000;
		var shadowAlpha = 0.25;
		var shadowBlurX = 6;
		var shadowBlurY = 6;
		var shadowStrength = 3;
		var shadowQuality = 3;
		var shadowInner = false;
		var shadowKnockout = false;
		var shadowHideObject = false;
		
		var filter:DropShadowFilter = new DropShadowFilter(shadowDistance, shadowAngleInDegrees, shadowColor,
									  shadowAlpha, shadowBlurX, shadowBlurY, shadowStrength, shadowQuality, shadowInner, shadowKnockout, shadowHideObject);
		var fa:Array = new Array();
		fa.push(filter);
		mc.filters = fa;
	}	
	
	/**
	 * this function will handle the scrolling
	 */
	private function ScrollBox() {
		ScrollArea = stick;
		ScrollButton = bar;
		Content = html;
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