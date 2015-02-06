import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.Utils;

class oxylus.bannerRotator.mainbanner extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	
	private var pp:MovieClip;
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		
	private var bg:MovieClip;	
	
	private var buttons:MovieClip;	
	
	private var myInterval:Number;
	private var ident:Number = 0;
	
	private var idx:Number = 0;
	private var totals:Number;
	private var currentButton:MovieClip;
	private var permit:Number = 1;
	
	public function mainbanner() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		settingsObj = new Object();
		
		lst = holder["lst"];
		mask = holder["mask"];
		
		lst.setMask(mask);
		
		defaultSettings();
		
		loadMyXml();
	}
	

	
	/**
	 * this function will load the .xml file
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
			xmlOb.load("banner.xml");
		}
	}
	
	/**
	 * this function executes after the .xml file has loaded
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml;
		node = node.firstChild.firstChild;
		
		settingsObj = Utils.parseSettingsNode(node);
		
		
		mask._width = settingsObj.totalWidth;
		mask._height = settingsObj.totalHeight;
		
		bg["black"]._width = settingsObj.totalWidth + 10;
		bg["black"]._height = settingsObj.totalHeight + 10;
		
		bg["white"]._width = bg["black"]._width + 2;
		bg["white"]._height = bg["black"]._height + 2;
		
		node = node.nextSibling;
		
		
		var posX:Number = 0;
		
		var posXB:Number = 0;
		
		for (node = node.firstChild; node != null; node = node.nextSibling) {
			var currentSlide:MovieClip = lst.attachMovie("IDslide", "slide_" + idx, lst.getNextHighestDepth());
			currentSlide.addEventListener("slideDoneAndLoaded", Proxy.create(this, slideDoneAndLoaded));
			currentSlide.addEventListener("slideOver", Proxy.create(this, slideOver));
			currentSlide.addEventListener("slideOut", Proxy.create(this, slideOut));
			currentSlide._x = posX;
			posX += Math.round(mask._width);
			currentSlide.idx = idx;
			currentSlide.setNode(node, settingsObj);
			
			currentButton = buttons.attachMovie("IDbutton", "button_" + idx, buttons.getNextHighestDepth());
			currentButton.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			currentButton.addEventListener("buttonOver", Proxy.create(this, buttonOver));
			currentButton.addEventListener("buttonOut", Proxy.create(this, buttonOut));
			currentButton._x = posXB;
			posXB += Math.round(currentButton._width + 6);
			currentButton.idx = idx;
			currentButton.setNode(node);
			
			
			idx++;
		}
		
		if (settingsObj.toggleButtons == 0) {
			buttons._visible = false;
		}
		
		if (settingsObj.toggleGraphicPauseButton == 0) {
			pp._visible = false;
		}
		
		buttons._y = 16;
		buttons._x = Math.round(settingsObj.totalWidth - buttons._width - 20);
		
		totals = idx;
		
		currentButton = buttons["button_" + 0];
		currentButton.activate();
		
		this._x = Math.round(900 / 2 - (settingsObj.totalWidth + 12) / 2);
		this._y = Math.round(420 / 2 - (settingsObj.totalHeight + 12) / 2 );
		
		this._alpha = 100;
	}
	
	private function slideOver(obj:Object) {
		b();
	}
	
	private function slideOut(obj:Object) {
		a();
	}
	
	private function buttonOver(obj:Object) {
		b();
	}
	
	private function buttonOut(obj:Object) {
		a();
	}
	
	private function a() {
				permit = 1;
				Tweener.removeTweens(pp);
				Tweener.removeTweens(pp["pa"]);
				Tweener.removeTweens(pp["pl"]);
				Tweener.removeTweens(buttons);

				Tweener.addTween(pp["pa"], { _alpha:0, time:0.2, transition:"linear" } );
				Tweener.addTween(pp["pl"], { _alpha:100, time:0.2, transition:"linear" } );
				
				Tweener.addTween(pp, { _alpha:0, delay:0, time:0.3, transition:"linear" } );
				Tweener.addTween(buttons, { _alpha:0, delay:0, time:0.3, transition:"linear" } );
				startSlideShow(currentButton.node.attributes.stay);
	}
	
	private function b() {
				permit = 0;
				Tweener.removeTweens(pp);
				Tweener.removeTweens(pp["pa"]);
				Tweener.removeTweens(pp["pl"]);
				Tweener.removeTweens(buttons);
				
				Tweener.addTween(pp["pa"], { _alpha:100, time:0.2, transition:"linear" } );
				Tweener.addTween(pp["pl"], { _alpha:0, time:0.2, transition:"linear" } );
				
				Tweener.addTween(pp, { _alpha:100, time:0.5, transition:"linear" } );
				Tweener.addTween(buttons, { _alpha:100, time:0.5, transition:"linear" } );
				clearInterval(myInterval);
	}
	
	private function slideDoneAndLoaded(obj:Object) {
		if (obj.mc.idx == 0) {
			startInitialSlide();
		}
	}
	
	private function startInitialSlide() {
		if (permit == 1) {
			startSlideShow(buttons["button_" + 0].node.attributes.stay);
		}
	}
	
	/**
	 * this function executed when the button was pressed
	 * you can make it public instead of private so you can access it from any app
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		currentButton.deactivate();
		currentButton = obj.mc;
		ident = obj.mc.idx - 1;
		b();
		slideshow();
	}
	
	private function startSlideShow(time:Number) {
		clearInterval(myInterval);
		myInterval = setInterval(this, "slideshow", time*1000);
	}
	
	private function slideshow() {
		
		var lastIdent:Number = ident;
		
		ident++;
		
		if (ident == totals) {
			ident = 0;
		}
		
		lst["slide_" + lastIdent].closeDes();
		lst["slide_" + ident].openDes();
		
		currentButton.deactivate();
		currentButton = buttons["button_" + ident];
		currentButton.activate();
		
		blur();
		
		Tweener.addTween(lst, { _x: -ident * mask._width, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType, onComplete:Proxy.create(this, unBlur) } );
		
		if (permit == 1) {
			startSlideShow(currentButton.node.attributes.stay);
		}
	}
	
	
	/**
	 * this will blur the images
	 */
	private function blur() {
		for (idx = 0; idx < totals; idx++) {
			Utils.setMcBlur(lst["slide_" + idx], settingsObj.blurX, settingsObj.blurY, settingsObj.blurQuality);
		}
	}
	
	/**
	 * this will unblur the images
	 */
	private function unBlur() {
		for (idx = 0; idx < totals; idx++) {
			lst["slide_" + idx].filters = [];
		}
	}
	
	private function defaultSettings() {
		// these settings are the default ones so the project will look nice on the screen
		// if you remove these the functionality will not be afected but it will no longer be fixed size
		// at some php/html applications you should remove these
				
		Stage.scaleMode = "noScale";
		Stage.align = "LT";
		_lockroot = true;
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