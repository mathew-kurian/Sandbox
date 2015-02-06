import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import oxylus.Utils;
import SWFAddress;

class oxylus.template.gallery.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	
	private var content:MovieClip;
	private var contentTitle:MovieClip;
	
	private var menuu:MovieClip;
		private var menuHolder:MovieClip;
		private var menuBg:MovieClip;
		
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		
		private var lstIdx:Number = 0;
		
	private var currentButton:MovieClip;
	
	
	
	/**
	 * customizable values
	 */
	
	private var settings:Object;
	
	private var animationTime:Number = 0.5;
	private var animationType:String = "easeOutQuart";
	private var blurXAmount:Number = 60;
	private var blurYAmount:Number = 0;
	
	private var totals:Number = 0;
	
	public function main() {
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		FilterShortcuts.init();
		
		settings = new Object();
		
		contentTitle = content["title"];
		contentTitle["txt"].autoSize = true;
		contentTitle["txt"].selectable = false;
		contentTitle["txt"]._x = -3;
		
		menuu = content["menu"];
		menuBg = menuu.createEmptyMovieClip("menuBg", menuu.getNextHighestDepth());
		menuBg.createEmptyMovieClip("a", menuBg.getNextHighestDepth());
		drawOval(menuBg["a"], 10, 10, 0, 0x000000, 0);
		menuBg.createEmptyMovieClip("b", menuBg.getNextHighestDepth());
		menuHolder = menuu.createEmptyMovieClip("menuHolder", menuu.getNextHighestDepth());
		
		
		holder = content["holder"];
			lst = holder["lst"];
			mask = holder["mask"];
			
			lst.setMask(mask);
			
		
		
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
			xmlOb.load("gallery.xml");
		}
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	
	/**
	 * this function gets executed after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settings.distanceBetweenMenuButtons = Number(node.attributes.distanceBetweenMenuButtons);
		settings.thumbWidth = Number(node.attributes.thumbWidth);
		settings.thumbHeight = Number(node.attributes.thumbHeight);
		settings.horizontalThumbSpace = Number(node.attributes.horizontalThumbSpace);
		settings.verticalThumbSpace = Number(node.attributes.verticalThumbSpace);
		settings.scrollerBehavior = Number(node.attributes.scrollerBehavior);
		
		node = node.nextSibling.firstChild;
		var currentPos:Number = 0;
		var idx:Number = 0;
		for (; node != null; node = node.nextSibling) {
			var but:MovieClip = menuHolder.attachMovie("IDbuttong", "button" + idx, menuHolder.getNextHighestDepth());
			but.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			but._x = but.posX = currentPos;
			but.setNode(node);
			currentPos += Math.round(but.totalWidth + settings.distanceBetweenMenuButtons);
			idx++;
		}
		
		totals = idx;
		
		menuBg["a"]._height = but._height + 6;
		menuBg._y = -4;
		
		menuu._x = Math.round(890 - menuu._width);
		menuu._y = 10;
		
		var str:Array = _global.theAddress.split("/");
		var last:String = str[2];
		
		if (last) {
			for (var i:Number = 0; i < totals; i++) {
				if (parseTheStr(menuHolder["button" + i].node.attributes.url) == ("/" + last + "/")) {
					menuHolder["button" + i].dispatchThisMC();
					break;
				}
			}
		}
		else {
			menuHolder["button" + 0].onRelease();
		}
		
		
		this._alpha = 100;
	}
	
	
	/**
	 * this function will treat the address
	 * @param	str_
	 */
	public function treatAddress(str_:String) {
		var str:Array = str_.split("/");
		var second:String = str[2];
		var third:String = str[3];
		
		if (second) {
			for (var i:Number = 0; i < totals; i++) {
				if (parseTheStr(menuHolder["button" + i].node.attributes.url) == ("/" + second + "/")) {
					menuHolder["button" + i].dispatchThisMC();
					break;
				}
			}
		}
		else {
			menuHolder["button" + 0].onRelease();
		}
		
		
		if (third) {
			lst["item" + lstIdx].treatAddress(third);
		}
	
	}
	
	/**
	 * actions for pressing one button
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		if (obj.mc != currentButton) {
			currentButton.off();
			currentButton = obj.mc;
			currentButton.onn();
			Tweener.removeTweens(menuBg["a"]);
			Tweener.removeTweens(menuBg);
			Tweener.addTween(menuBg["a"], { _width:obj.mc.totalWidth, time:0.5, transition:"easeOutQuart",onUpdate:Proxy.create(this, drawTheMovingBg) } );
			Tweener.addTween(menuBg, { _x:obj.mc.posX, time:0.5, transition:"easeOutQuart" } );
			Tweener.addTween(contentTitle, { _Blur_blurX:40, _Blur_blurY:40, _alpha:0, time:0.3, transition:"linear", onComplete:Proxy.create(this, showText, obj.mc.node)  } );
			
			Tweener.addTween(lst["item" + lstIdx], { _x: -mask._width - 60, _Blur_blurX: blurXAmount, _Blur_blurY: blurYAmount, _Blur_quality:1,  time: animationTime, transition:animationType,
														onComplete:Proxy.create(this, removeItem, lst["item"+lstIdx]) } );
			
			lstIdx++;
			var currentItem:MovieClip = lst.attachMovie("IDitem", "item" + lstIdx, lst.getNextHighestDepth());
			currentItem._x = mask._width;
			currentItem.setNode(obj.mc.node, settings);
			Tweener.addTween(lst["item" + lstIdx], { _x:0, _Blur_blurX: 0, _Blur_blurY: 0, _Blur_quality:1, time: animationTime, transition:animationType } );
		}
	}
	
	private function removeItem(mc:MovieClip) {
		mc.removeMovieClip();
	}
	private function showText(nd:XMLNode) {
		contentTitle["txt"].text = nd.attributes.title;
		Tweener.addTween(contentTitle, { _Blur_blurX:0, _Blur_blurY:0, _alpha:100, time:0.3, transition:"linear" } );
	}
	
	private function drawTheMovingBg() {
		drawOval(menuBg["b"], menuBg["a"]._width, menuBg["a"]._height, 4, 0x000000, 30,1);
	}
	
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number, line:Number) {
		
		//this function draws an ovel or a sqare if the radius will be 0
		mc.clear();
		mc.beginFill(fillColor, alphaAmount);
		if(line==1)
			mc.lineStyle(1, 0x4e4e4e, alphaAmount, true);
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