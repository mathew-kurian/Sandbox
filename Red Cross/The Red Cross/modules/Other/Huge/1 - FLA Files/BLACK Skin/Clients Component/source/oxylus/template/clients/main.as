import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;
import oxylus.template.clients.lightImage;


class oxylus.template.clients.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	
	private var ht:MovieClip;
	private var html:MovieClip;
	
	private var lst:MovieClip;
	private var holder:MovieClip;
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
	
	
	private var idx:Number = -1;
	private var px:Number = 0;
	private var py:Number = 0;
	private	var maxw:Number = 870;
	private	var tw:Number = 198 + 6;
	private	var th:Number = 93 + 6;
	
	private	var vSpace:Number = 15;
	private	var hSpace:Number = 16;
	
	private var settings:Object;
	
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
		
		html = ht["html"];
		html["txt"]._x  = -3;
		Utils.initMhtf(html["txt"], false);
		html["txt"]._width = 890;
		
		
		lst = content["lst"];
		holder = lst["holder"];
		mask = lst["mask"];
		mask._width = 870;
		mask._height = 330;
		scroller = lst["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		stick._height = mask._height;
		scroller._x = 896 - scroller._width;
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
			xmlOb.load("clients.xml");
		}
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild;
		
		settings = Utils.parseSettingsNode(node.firstChild);
		
		hSpace = settings.horizontalSpace;
		vSpace = settings.verticalSpace;
		
		tw = settings.imageWidth + 6;
		th = settings.imageHeight + 6;
		
		node = node.firstChild.nextSibling;
		
		contentTitle["txt"].text = node.attributes.title;
		html["txt"].htmlText = node.firstChild.nodeValue;
		lst._y = Math.round(40 + html._height + 20);
		
		node = node.nextSibling.firstChild;
		
		continueLoad();
		
		this._alpha = 100;
	}
	
	/**
	 * this function will continue loading the thumbnails
	 */
	public function continueLoad() {
		ScrollBox();
		if (node != null) {
			
			idx++;
			var currentItem:MovieClip = holder.attachMovie("IDitem", "item" + idx, holder.getNextHighestDepth());
			currentItem.addEventListener("itemLoaded", Proxy.create(this, itemLoaded));
			currentItem.setNode(node, settings);
			currentItem._x = Math.round(px);
			currentItem._y = Math.round(py);
			
			px += tw + hSpace;
			if (px > maxw) {
				px = 0;
				py += th + vSpace;
			}
			node = node.nextSibling;
		}
	}
	
	/**
	 * function executed once the thumbnail has loaded
	 */
	private function itemLoaded() {
		continueLoad();
	}

	
	/**
	 * function for handling the scroller
	 */
	private function ScrollBox() {
		ScrollArea = scroller["stick"];
		ScrollButton = scroller["bar"];
		Content = holder;
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
			//ScrollButton._height = ScrollArea._height * prop;
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