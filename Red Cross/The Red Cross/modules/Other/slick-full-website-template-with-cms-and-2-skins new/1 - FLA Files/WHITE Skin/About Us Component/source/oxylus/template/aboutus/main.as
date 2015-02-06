import oxylus.Utils;
import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.template.aboutus.lightImage;


class oxylus.template.aboutus.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	public var settings:Object;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	
	private var ht:MovieClip;
	private var html_:MovieClip;
	private var mask:MovieClip;
	private var scroller:MovieClip;
	private var bar:MovieClip;
	private var stick:MovieClip;
	
	private var image:MovieClip;
	private var a:MovieClip;
	private var stroke:MovieClip;
	private var imageHandler:lightImage;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	
	private var idx:Number = 0;
	private var myInterval:Number;
	private var images:Array;
	private var currentIdx:Number = -1;
	private var prevImage:MovieClip;
	
	public function main() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		settings = new Object();
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		ht = content["ht"];
		ht._y = 40;
		
		html_ = ht["html"];
		html_["txt"]._x  = -3;
		Utils.initMhtf(html_["txt"], false);
		html_["txt"]._width = 420;
		
	
		
		mask = ht["mask"];
		mask._width = html_["txt"]._width+2;
		mask._height = 376;
		
		scroller = ht["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		
		stick._height = mask._height+4;
		
		scroller._x = Math.round(mask._width + 10);
		html_.setMask(mask);
		
		image = content["image"];
		a = image["a"];
		stroke = image["stroke"];
		
		image._y = ht._y;
		image._x = Math.round(scroller._x + scroller._width + 10);
		
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
			xmlOb.load("aboutus.xml");
		}
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settings = Utils.parseSettingsNode(node);

		node = node.nextSibling;
		contentTitle["txt"].text = node.attributes.title;
		html_["txt"].htmlText = node.firstChild.nodeValue;
		
		node = node.nextSibling.firstChild;
		images = new Array();
		var i:Number = 0;
		for (; node != null; node = node.nextSibling) {
			images.push(node.attributes.src);
			i++;
		}
		
		stroke._width = settings.imageWidth + 12;
		stroke._height = settings.imageHeight + 12;
		
		
		
		this._alpha = 100;
		
		if (i == 0) {
			image._visible = false;
			html_["txt"]._width += settings.imageWidth;
			mask._width = html_["txt"]._width + 2;
			scroller._x = Math.round(mask._width + 10);
		}
		else {
			
			goSlideShow();
		}
		
		
		ScrollBox();
	}
	
	/**
	 * this function will initiate the slideshow
	 * after one picture is fully loaded the slideshow starts over, after the time has ended the next picture begins 
	 * loading, after complete load the time starts again
	 */
	private function goSlideShow() {
		clearInterval(myInterval);
		prevImage = image["a"]["instance_" + idx];
		idx++;
		
		currentIdx++;
		
		if (!images[currentIdx]) {
			currentIdx = 0;
		}
		
		
		var currentImage = image["a"].createEmptyMovieClip("instance_" + idx, image["a"].getNextHighestDepth());
		currentImage._alpha = 0;
		imageHandler = new lightImage( { holder:currentImage, address:images[currentIdx], initFunction:initLoad, errorFunction:errorLoad, resize:[settings.imageWidth, settings.imageHeight, "fixed"], theParent:this } );

	}
	
	public function startInterval() {
		clearInterval(myInterval);
		myInterval = setInterval(this, "goSlideShow", settings.slideshowInterval * 1000);
	}
	
	/**
	 * this gets executed right after the picture has loaded
	 * @param	mc
	 * @param	theParent
	 */
	private function initLoad(mc:MovieClip, theParent:MovieClip) {
		Tweener.addTween(mc, { _alpha:100, delay:.2, time: theParent.settings.fadeInAnimationTime, transition: theParent.settings.dafeInAnimationType, onComplete:Proxy.create(theParent, theParent.removePrevImage) } );
		theParent.startInterval();
	}
	
	/**
	 * this will remove the previous loaded image
	 */
	public function removePrevImage() {
		prevImage.removeMovieClip();
	}
	
	/**
	 * this will make the image invisible, it gets executed if the image fails to load
	 */
	private function errorLoad() {
		image._visible = false;
	}
	
	/**
	 * this will handle the scroller
	 */
	private function ScrollBox() {
		ScrollArea = stick;
		ScrollButton = bar;
		Content = html_;
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