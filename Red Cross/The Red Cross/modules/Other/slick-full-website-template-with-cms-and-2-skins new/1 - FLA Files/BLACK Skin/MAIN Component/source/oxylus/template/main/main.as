import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import oxylus.Utils;
import SWFAddress;
import oxylus.mp3Player.Tooltip03.Tooltip;

class oxylus.template.main.main extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	
	private var loader:MovieClip;

	private var graphics:MovieClip
		private var bottom:MovieClip;
		private var logo:MovieClip;
		
	private var down:MovieClip
		private var title:MovieClip;
		private var full:MovieClip;
		
		
	private var up:MovieClip;
		private var menuu:MovieClip;
	
		
	private var holder:MovieClip;
	/**
	 * generic variables
	 */
	private var currentButton:MovieClip;
	private var prevButton:MovieClip;
	private var myInterval:Number;
	private var startInterval:Number;
	private var permitXmlLoad:Number = 0;
	private var permit:Number = 1;
	private var currentXml:String;
	/**
	 * handling swf load
	 */
	private var mcl:MovieClipLoader;
	private var swfIdx:Number = 0;
	private var swfArray:Array;
	
	/**
	 * handling the buttons
	 */
	private var totals:Number;
	
	/**
	 * customizable variables
	 */
	
	private var blurAmountX:Number = 70;
	private var blurAmountY:Number = 0;
	private var animationTime:Number = .5;
	private var animationType:String = "easeOutQuart";
	
	private var tool:MovieClip;
	
	private var mp3X:Number = 0;
	private var mp3Y:Number = 0;
	
	private var menuPosition:String = "left";
	private var maxWidth:Number = 980;
	private var maxHeight:Number = 600;	
	
	public function main() {
		_global.myMAIN = this;
	
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		FilterShortcuts.init();
		
		full = down["full"];
		full._alpha = 0;
		full["normal"]["b"]._alpha = 0;
		
		full["off"]._visible = false;
		full["off"]["b"]._alpha = 0;
		
		tool = Tooltip.attach(this);
		tool.setTheMc(this);
		
		
		loader._alpha = 0;
		
		bottom = graphics["bottom"];
		title = down["title"];
		title["txt"].autoSize = true;
		
		menuu = up["menu"];
		up["mask"].setMask(up["title"]);
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		logo = graphics["top"]["logo"]["title"];
		
		swfArray = new Array();
		
		_global.refY = holder._y;
		_global.popPresent = 0;
		_global.myXml = undefined;
		_global.treatAddress = true;
		_global.mp3PlayerXml = undefined;
		loadStageResize();
		loadMyXml();
	}
	
	private function parseTheStr(str:String) {
		var myStr:String = str;
		myStr = Utils.strPartReplace(myStr, ")", "-");
		myStr = Utils.strPartReplace(myStr, "(", "-");
		return myStr;
	}
	/**
	 * this will load the main .xml file
	 */
	public function loadMyXml() {
		var xmlOb:XML = new XML();
		theXml = xmlOb;
		xmlOb.ignoreWhite = true;
		xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoaded);
		xmlOb.load(_level0.xml == undefined ? "main.xml" : _level0.xml);
	}
	
	
	/**
	 * this gets executed right after the .xml file completed loading
	 */
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild;
		var objj:Object = Utils.parseSettingsNode(node);
		
		menuPosition = objj.menuPosition;
		maxWidth = objj.maxWidth;
		maxHeight = objj.maxHeight;
		
		node = node.firstChild
		title["txt"].text = node.nextSibling.attributes.title;
		
		var logoAddress = node.nextSibling.nextSibling.firstChild;
		var mp3PlayerAddress = node.nextSibling.nextSibling.nextSibling.attributes.mp3PlayerSwf;
		mp3X =  node.nextSibling.nextSibling.nextSibling.attributes.xPos;
		mp3Y =  down["mp3Player"]._y = node.nextSibling.nextSibling.nextSibling.attributes.yPos;
		
		_global.mp3PlayerXml = node.nextSibling.nextSibling.nextSibling.attributes.mp3PlayerXml;
		
		var mcl2:MovieClipLoader;
		mcl2 = new MovieClipLoader();
		mcl2.loadClip(mp3PlayerAddress, down["mp3Player"]);
		
		var i:Number = 0;
		var currentPos:Number = 0;
		var distB:Number = 1;
		node = node.firstChild;
		
		for (; node != null; node = node.nextSibling) {
			var currentButton:MovieClip = menuu.attachMovie("IDbutton", "button" + i, menuu.getNextHighestDepth());
			currentButton.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			currentButton.setNode(node);
			if (currentButton.node.attributes.hiddenModule != 1) {
				currentButton._x = currentPos;
				currentPos += Math.round(currentButton._width + distB);
			}
			else {
				currentButton._visible = false;
			}
			i++;
		}
		
		totals = i;
		
		if (objj.toggleFixedMenu == 1) {
			Tweener.addTween(up , { _y:0, time: .4, transition: "easeOutCubic", rounded:true } );
			up["bg"]._visible = false;
			up["title"]._visible = false;
			up["mask"]._visible = false;
		}
		else {
			up["bg2"]._visible = false;
			myInterval = setInterval(this, "checkMenuHit", 200);
		}
		
		
		Tweener.addTween(full, { _alpha:100, time: .5, delay:.2, transition: "linear", rounded:true } );
		
		full["normal"].onRelease = Proxy.create(this, fullOn);
		full["normal"].onRollOver = Proxy.create(this, fullOver);
		full["normal"].onRollOut = full["off"].onRollOut = Proxy.create(this, OUT);
		full["off"].onRelease = Proxy.create(this, fullOff);
		full["off"].onRollOver = Proxy.create(this, normalOn);
		
		full["normal"].onReleaseOutside = full["off"].onReleaseOutside = Proxy.create(this, OUT);
		
		logo.loadMovie(logoAddress);
		
		initSwfAddressHandler();
		
		
		onResize();
		
	}
	
	private function fullOver() {
		full["normal"]["a"]._alpha = 0;
		full["normal"]["b"]._alpha = 100;
		
		tool.setCustomVars({myTexts:"Enter Fullscreen",
			    myFonts:"my_font2",
			    myColors:"0x000000|0x787878",
				mySizes:"12|8",
				myVerticalSpaces:"2|-2",
				backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
				tipX:50,
				XDistanceFromCursor:-50,
				YDistanceFromCursor:-15
			});
			
		tool.show({ animationTime: .2 });
		
	}
	
	private function OUT() {
		full["normal"]["a"]._alpha = 100;
		full["normal"]["b"]._alpha = 0;
		full["off"]["a"]._alpha = 100;
		full["off"]["b"]._alpha = 0;
		tool.hide( { animationTime: .2 } );
	}
	
	
	private function normalOn() {
		full["off"]["a"]._alpha = 0;
		full["off"]["b"]._alpha = 100;
		
		tool.setCustomVars({myTexts:"Exit Fullscreen",
			    myFonts:"my_font2",
			    myColors:"0x000000|0x787878",
				mySizes:"12|8",
				myVerticalSpaces:"2|-2",
				backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
				tipX:50,
				XDistanceFromCursor:-50,
				YDistanceFromCursor:-15
			});
			
		tool.show({ animationTime: .2 });
	}
	
	private function fullOn() {
		Stage["displayState"] = "fullScreen";
		full["normal"]._visible = false;
		full["off"]._visible = true;
		
		OUT();
	}

	public function killFullScreen() {
		if (Stage["displayState"] == "fullScreen") {
			normalOn();
			fullOff();
		}
	}
	private function fullOff() {
		Stage["displayState"] = "normal";
		full["normal"]._visible = true;
		full["normal"]["a"]._alpha = 100;
		full["normal"]["b"]._alpha = 0;
		
		full["off"]._visible = false;
		
		
		OUT();
	}
	
	public function initSwfAddressHandler() {
		SWFAddress.setHistory(true);
		SWFAddress.setStrict(true);
		
		SWFAddress.onChange = Proxy.create(this, swfAddressOnChangeEvent);
	}
	
	private function swfAddressOnChangeEvent() {
			var str:String;
			_global.theAddress = SWFAddress.getValue();
			str = SWFAddress.getValue();
		
			var my_str_array:Array = str.split("/");

			if (str.length > 1) {
				for (var i:Number = 0; i < totals; i++) {
					if (parseTheStr(menuu["button" + i].node.attributes.url) == "/" + parseTheStr(my_str_array[1]) + "/"){
						if (currentButton != menuu["button" + i]) {
							menuu["button" + i].dispatchThisMC();
							break;
						}
						else {
							if (currentXml == menuu["button" + i].node.attributes.xml) {
								holder["ident" + swfIdx]["module"].treatAddress(SWFAddress.getValue());
							}
						}
					}
				}
			}
			else {
				goLoad();
			}
	}
	
	
	private function goLoad() {
		for (var i:Number = 0; i < totals; i++) {
			var currentTestedButton:MovieClip = menuu["button" + i];
			if ((currentTestedButton.hiddenModule == 0) &&(currentTestedButton.externalLink == 0)) {
				currentTestedButton.onRollOver();
				currentTestedButton.onRelease();
				break;
			}
		}
		
	}
	
	
	/**
	 * function executed when the button gets pressed
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		if (permit == 1) {
			permitXmlLoad = 0;
			
			if (currentButton != obj.mc) {
				_global.popPresent = 0;

				permit = 0;
				
				currentButton.reset();
				currentButton = obj.mc;
				currentButton.act();
				
				Tweener.addTween(holder["ident" + swfIdx], { _alpha:50, time: .3, transition: "easeOutQuart"} );
				
				if (swfArray[swfIdx] == 1) {
					swfIdx++;
				}
				else {
					mcl.unloadClip(holder["ident" + swfIdx]);
					if (holder["ident" + swfIdx]) {
						holder["ident" + swfIdx].removeMovieClip();
					}
				}
					
				var currentIdent:MovieClip = holder.createEmptyMovieClip("ident" + swfIdx, holder.getNextHighestDepth());
				
				swfArray[swfIdx] = 0;
				currentIdent._x = Math.round(Stage.width + 40);
				Utils.setMcBlur(currentIdent, blurAmountX, blurAmountY, 1);
				
				if (obj.mc.node.attributes.xml) {
					permitXmlLoad = 1;
					
					Tweener.addTween(loader, { _alpha:100, time: .5, delay:.2, transition: "linear", rounded:true } );
					loader["text"]["n"].text = "";
					
					var xmlOb:XML = new XML();
					_global.myXml = xmlOb;
					xmlOb.ignoreWhite = true;
					xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoadedOnModule);
					currentXml = obj.mc.node.attributes.xml;
					
// if you use it online use this instead of the line below to avoid caching of xml					
//					xmlOb.load(currentXml +"?nocache="+ String((new Date()).getTime()));
					xmlOb.load(currentXml);
					
				}
				else {
					mcl.loadClip(obj.mc.node.attributes.swf, currentIdent);
				}
			}
		}
		
	}
	
	
	/**
	 * after the .xml file has loaded the swf will be loaded
	 * @param	status
	 */
	private function continueAfterXmlLoadedOnModule(status:Boolean) {
		if (status == true) {
			if (permitXmlLoad == 1) {
				mcl.loadClip(currentButton.node.attributes.swf, holder["ident" + swfIdx]);
			}
		}
		else {
			trace("XML load error ! ");
			
			currentButton = undefined;
			permit = 1;
			
			for (var i:Number = 0; i < totals; i++) {
				if (menuu["button" + i] != prevButton) {
					menuu["button" + i].reset();
				}
				else {
					prevButton.onRollOver();
					prevButton.onRelease();
				}
			}
		}
	}
	
	private function onLoadStart(mc:MovieClip) {
		Tweener.addTween(loader, { _alpha:100, time: .5, delay:.2, transition: "linear", rounded:true } );
	}
	
	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number) {
		var per:Number = Math.round(bytesLoaded/bytesTotal*100)
		if (per < 99) {
			loader["text"]["n"].text = per;
		}
	}

	private function onLoadComplete(mc:MovieClip, httpStatus:Number) {
		loader["text"]["n"].text = "99";
		Tweener.addTween(loader, { _alpha:0, time: .5, delay:.2, transition: "linear", rounded:true } );
	}
	
	/**
	 * function executed when the .swf file completed loading
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		
		Tweener.removeTweens(holder["ident" + swfIdx]);
		holder["ident" + swfIdx]._alpha = 100;
		
		Tweener.addTween(holder["ident" + swfIdx], { delay:.5, _x:0, _Blur_blurX:0, 
						 		_Blur_blurY:0, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, actPermit) } );
		Tweener.addTween(holder["ident" + (swfIdx - 1)], {   delay:.5, _x: Math.round(-Stage.width), _Blur_blurX:blurAmountX, 
								_Blur_blurY:blurAmountY, time: animationTime, transition: animationType,
								onComplete:Proxy.create(this, removeModule, holder["ident" + (swfIdx - 1)]), rounded:true} );
		swfArray[swfIdx] = 1;
		
	}
	
	private function actPermit() {
		permit = 1 ;
		
		prevButton = currentButton;
	}
	
	public function getThePermitValue() {
		return permit;
	}
	
	private function removeModule(mc:MovieClip) {
		mc.removeMovieClip();
	}
	
	/**
	 * function executed when the swf file failed loading
	 * @param	target_mc
	 * @param	errorCode
	 * @param	httpStatus
	 */
	private function onLoadError(target_mc:MovieClip, errorCode:String, httpStatus:Number) {
		trace(">> onLoadError()");
		trace(">> ==========================");
		trace(">> errorCode: " + errorCode);
		trace(">> httpStatus: " + httpStatus);
		
		currentButton = undefined;
		permit = 1;
		
		for (var i:Number = 0; i < totals; i++) {
			if (menuu["button" + i] != prevButton) {
				menuu["button" + i].reset();
			}
			else {
				prevButton.onRollOver();
				prevButton.onRelease();
			}
		}
	}

	/**
	 * function called when resizing the browser
	 * modify the 980 and 600 values if you want to setup a smaller limit for the resize
	 * @param	w
	 * @param	h
	 */
	private function resize(w:Number, h:Number) {
		if (w < maxWidth) {
			w = maxWidth;
		}
		
		if (h < maxHeight) {
			h = maxHeight;
		}
				
		/**
		 * loader positioning
		 */
		
		loader._x = Math.round(w / 2 - loader._width / 2);
		loader._y = Math.round(h / 2 - loader._height / 2);
		
		var defX:Number = Math.round((w - 890) / 2);
		
		
		/**
		 * graphics resize
		 */
		bottom._y = Math.round(h - bottom._height);
		graphics._x = Math.round(w / 2 - graphics._width / 2);
		
		/**
		 * down resize
		 */
		
		down._y = Math.round(h - down["bg"]._height);
		down["bg"]._width = w+2;
		title._x = defX;
		
		down["mp3Player"]._x = Math.round(defX + 920 - mp3X);
		
		full._x = Math.round(defX + 920 - full._width - 16 - mp3X);
		/**
		 * up resize
		 */
		up["bg"]._width = up["bg2"]._width = w + 6;
		up["title"]._x = up["mask"]._x = Math.round(w - up["title"]._width - 137);
		
		/**
		 * menu [ up ] resize
		 */
		 
		switch (menuPosition){
			case "right":
				menuu._x = Math.round(w - menuu._width - 70);
			break;
			
			case "left":
				menuu._x = defX;
			break;
			
			case "center":
				menuu._x = Math.round(w/2 - menuu._width/2);
			break;
		}
		
		/**
		 * holder positioning
		 */
		holder._y = _global.refY = Math.round(h / 2 - 420 / 2 + up._height);
		holder._x = _global.refX = defX;
		
		if (Stage["displayState"] == "normal") {
			full["normal"]._visible = true;
			full["normal"]["a"]._alpha = 100;
			full["normal"]["b"]._alpha = 0;
			full["off"]._visible = false;
			full["off"]["a"]._alpha = 100;
			full["off"]["b"]._alpha = 0;
		}
		
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	private function checkMenuHit() {
		if (_ymouse < 50) {
			if (_global.popPresent == 0) {
				showMenu();
			}
		}
		else {
			hideMenu();
		}
	}
	
	private function showMenu() {
		if (up._y != 0) {
			clearInterval(myInterval);
			Tweener.addTween(up , { _y:0, time: .4, transition: "easeOutCubic", rounded:true, onComplete:Proxy.create(this, checkMenuAgain) } );
		}
	}
	
	private function hideMenu() {
		if (up._y != -41) {
			clearInterval(myInterval);
			Tweener.addTween(up , { _y: -41, time: .4, transition: "easeOutCubic", rounded:true, onComplete:Proxy.create(this, checkMenuAgain) } );
		}
	}
	
	private function checkMenuAgain() {
		clearInterval(myInterval);
		myInterval = setInterval(this, "checkMenuHit", 100);
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