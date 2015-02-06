import oxylus.Utils;
import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;


class oxylus.template.services.item extends MovieClip 
{
	private var node:XMLNode;
	
	private var html:MovieClip;
	
	private var mask:MovieClip;
	
	private var scroller:MovieClip;
		private var bar:MovieClip;
		private var stick:MovieClip;
	
	private var image:MovieClip;
		private var a:MovieClip;
		private var stroke:MovieClip;
		private var loader:MovieClip;
	
	private var mcl:MovieClipLoader;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	
	private var settings:Object;
	private var images:Array;
	private var myInterval:Number;
	private var currentIdx:Number = -1;
	private var idx:Number = 0;
	private var prevImage:MovieClip;
	/**
	 * customizable values
	 */
	private var blurXAmount:Number = 60;
	private var blurYAmount:Number = 0;
	
	public function item() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		
		FilterShortcuts.init();
		
		settings = new Object();
		
		Utils.initMhtf(html["txt"], false);
		html["txt"]._width = mask._width;
		
	
		
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		html.setMask(mask);
		
		a = image["a"];
		stroke = image["stroke"];
		loader = image["loader"];
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 * @param	sett
	 */
	public function setNode(n:XMLNode, sett:Object) {
		node = n;
		settings = sett;
		
		mask._height = stick._height = settings.textHeight;
		
		html["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		
		stroke._width = settings.imageWidth + 12;
		stroke._height = settings.imageHeight + 12;
		
		loader._x = Math.round(stroke._width / 2);
		loader._y = Math.round(stroke._height / 2);
		
		node = node.firstChild.nextSibling.firstChild;
		
		images = new Array();
		
		var i:Number = 0;
		
		for (; node != null; node = node.nextSibling) {
			images.push(node.attributes.src);
	
	
			i++;
		}
		if (i == 0) {
			image._visible = false;
			html["txt"]._width += settings.imageWidth + 20;
			mask._width = html["txt"]._width + 4
			scroller._x = Math.round(html["txt"]._width + 10)
		}
		
		currentIdx = -1
		
		
		
		ScrollBox();
		
		startSlide();
		
		Utils.setMcBlur(this, blurXAmount, blurYAmount, 1);
	}
	
	/**
	 * this will load the image
	 */
	private function startSlide() {
		clearInterval(myInterval);
		prevImage = a["hol" + idx];
		idx++;
		var currentImg:MovieClip = a.createEmptyMovieClip("hol" + idx, a.getNextHighestDepth());
		currentImg._alpha = 0;
		currentIdx++;
		if (!images[currentIdx]) {
			currentIdx = 0;
		}
		
		mcl.loadClip(images[currentIdx], currentImg);
	}
	
	private function onLoadStart() {
		loader._visible = true;
		Tweener.addTween(loader, { _alpha:100, time:.3, transition:settings.fadeInAnimationTime} );
	}
	
	/**
	 * function launched when the image finished loading
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		Utils.getImage(mc, true);
		
		mc._width = settings.imageWidth;
		mc._height = settings.imageHeight;
		
		Tweener.addTween(mc, { _alpha:100, delay:.1, time:settings.fadeInAnimationTime, transition:"easeInQuart", onComplete:Proxy.create(this, remPrevImage) } );
	
		Tweener.addTween(loader, { _alpha:0, delay:.3, time:.3, transition:settings.fadeInAnimationTime, onComplete:Proxy.create(this, invisLoader) } );
	}
	
	private function invisLoader() {
		clearInterval(myInterval);
		myInterval = setInterval(this, "startSlide", settings.slideshowInterval * 1000);
		loader._visible = false;
	}
	
	/**
	 * this will remove the previous image
	 */
	private function remPrevImage() {
		prevImage.removeMovieClip();
	}
	private function roll() {
		Tweener.addTween(loader, {  _rotation:360, time:1, transition:"linear", onComplete:Proxy.create(this, roll)} );
	}
	
	private function onLoadError(pMc:MovieClip, errorCode:String, httpStatus:Number) {
		trace(">> errorCode: " + errorCode);
		trace(">> httpStatus: " + httpStatus);
		image._visible = false;
	}
	
	/**
	 * this will handle the scroller
	 */
	private function ScrollBox() {
		ScrollArea = scroller["stick"];
		ScrollButton = scroller["bar"];
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