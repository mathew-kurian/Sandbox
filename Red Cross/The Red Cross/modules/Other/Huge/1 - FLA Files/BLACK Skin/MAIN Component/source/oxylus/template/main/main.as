import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import oxylus.Utils;
import SWFAddress;
import oxylus.mp3Player.Tooltip03.Tooltip;
import flash.filters.GlowFilter;


class oxylus.template.main.main extends MovieClip 
{
	private var menuWidthTotal:Number;
	
	private var settingsObj:Object;
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
	private var currentButton2:MovieClip;
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
	
	
	private var firstLevelArray:Array;
	private var secondLevelArray:Array;
	
	private var currentActiveSubMenu:MovieClip;
	private var myIntervalMenu:Number = 0;
	
	
	private var buttonToLoad:MovieClip;
	
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
		Utils.initMhtf(title["txt"], false);
		title["txt"].autoSize = true;
		title["txt"].wordWrap = false;
		
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
		node = node.firstChild;
	
		settingsObj = objj;
		
		title["txt"].htmlText = node.nextSibling.firstChild.nodeValue;
		
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
		
		firstLevelArray = new Array();
		
		for (; node != null; node = node.nextSibling) {
			var currentButton:MovieClip = menuu.attachMovie("IDbutton", "button" + i, menuu.getNextHighestDepth());
			currentButton.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			currentButton.addEventListener("buttonRollOver", Proxy.create(this, buttonRollOver));
			currentButton.addEventListener("buttonRollOut", Proxy.create(this, buttonRollOut));
			currentButton.setNode(node);
			currentButton.idx = i;
			if (currentButton.node.attributes.hiddenModule != 1) {
				currentButton._x = currentPos + 2;
				currentPos += Math.round(currentButton.totalWidth + distB);
			}
			else {
				currentButton._visible = false;
			}
			
			firstLevelArray.push(currentButton);
			
			i++;
		}
		
		menuWidthTotal = currentPos;
		
		totals = i;
		
		
		var iii:Number = 0;
		var testButton:MovieClip = firstLevelArray[iii];

		secondLevelArray = new Array();
		
		while (testButton) {
			
			testButton.subMenuPresent = 0;
			
			if ((testButton.node.firstChild) && (testButton.node.firstChild.attributes.toggleSubMenu == 1)) {
				testButton.subMenuPresent = 1;
				var currentSubMenu:MovieClip = menuu.createEmptyMovieClip("subMenu" + iii, menuu.getNextHighestDepth());
				currentSubMenu.swapDepths( menuu["button" + iii])
				currentSubMenu.createEmptyMovieClip("bg", currentSubMenu.getNextHighestDepth());
				currentSubMenu._visible = false;
				currentSubMenu._alpha = 0;
				
				
				var menuYC:Number = 4
				
				
				
				currentSubMenu._y = Math.round(menuu["button" + iii]._height + menuYC);
				
				var nd:XMLNode = testButton.node.firstChild.firstChild;
				
				var currentPos:Number = 0;
				var distB:Number = 1;
				var butIdx:Number = 0;
				for (; nd != null; nd = nd.nextSibling) {
					var currentSubButton:MovieClip = currentSubMenu.attachMovie("IDsecondButton", "IDsecondButton" + butIdx, currentSubMenu.getNextHighestDepth());
					currentSubButton.addEventListener("buttonPressed2", Proxy.create(this, buttonPressed2));
					currentSubButton.firstLevel = testButton;
					currentSubButton.setNode(nd);
					secondLevelArray.push(currentSubButton);
					
					if (currentSubButton.node.attributes.hiddenModule != 1) {
						currentSubButton._x = currentPos;
						currentPos += Math.round(currentSubButton._width + distB);
					}
					else {
						currentSubButton._visible = false;
					}
					
					butIdx++;
				}
				
				
				currentSubMenu._x = Math.round(menuu["button" + iii]._x - currentPos / 2 + menuu["button" + iii]._width / 2);
				
				var ali:String = "center";
				
				if (iii == 0) {
					ali = "left"
					currentSubMenu._x = 0
				}
				
				if (!menuu["button" + (iii + 1)]) {
					ali = "right"
					currentSubMenu._x = Math.round(menuu["button" + iii]._x - currentPos + menuu["button" + iii]._width + 1);
				}
				
				var adj:Number = 0;
				if (ali == "center") {
					currentSubMenu._x = Math.round((menuWidthTotal - currentPos) / 2);
					adj = Math.round(menuu["button" + iii]._x - Math.round((menuWidthTotal - currentPos) / 2));
					
					if (currentSubMenu._x > menuu["button" + iii]._x) {
						currentSubMenu._x = 0;
						adj = Math.round(menuu["button" + iii]._x);
					}
					else {
						if ((currentSubMenu._x + currentPos) < (menuu["button" + iii]._x + menuu["button" + iii]._width)) {
							currentSubMenu._x = Math.round(menuWidthTotal - currentPos)
							adj = Math.round(menuu["button" + iii]._x - currentSubMenu._x);
						}
						var aa:Number = (menuu["button" + iii]._x + menuu["button" + iii]._width) - currentSubMenu._x;
						var bb:Number = currentPos - aa;
						if (aa < bb) {
							currentSubMenu._x -= (bb - aa) - menuu["button" + iii]._width / 2;
							adj = Math.round(menuu["button" + iii]._x - currentSubMenu._x);
						}
					}
				}
				
				currentSubMenu._x = Math.round(currentSubMenu._x);
				
				drawOvalHeavilyModified(currentSubMenu["bg"], Math.round(currentPos), Math.round(currentSubButton._height), 6, 0x333333, 100, Math.round(menuu["button" + iii].totalWidth - 1.5), Math.round(menuu["button" + iii]._height + 4), ali, 0x333333, 100, adj);
				
				var filter:GlowFilter = new GlowFilter(0x303030, 0.2, 16, 16, 1, 3, false, false);
				var filterArray:Array = new Array();
				filterArray.push(filter);
				currentSubMenu["bg"].filters = filterArray;

			}
		

			iii++;
			testButton = firstLevelArray[iii];
		}
		
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
	
	private function buttonRollOver(obj:Object) {
		var iii:Number = 0;
		var testButton:MovieClip = firstLevelArray[iii];
		clearInterval(myIntervalMenu);
		
		while (testButton) {
			var tI:Number = testButton.idx;
			
			if (testButton != obj.mc) {
				if ((menuu["subMenu" + tI]._visible == true) || (menuu["subMenu" + tI]._alpha != 0)) {
					Tweener.addTween(menuu["subMenu" + tI], { _alpha:0, time: .3, transition: "linear", onComplete:Proxy.create(this, cancelSub, menuu["subMenu" + tI]) } );
				}
			}
			else {
				
				currentActiveSubMenu = menuu["subMenu" + tI];
				if (currentActiveSubMenu) {
					currentActiveSubMenu._visible = true;
					Tweener.addTween(currentActiveSubMenu, { _alpha:100, time: .3, transition: "linear" } );
					
					myIntervalMenu = setInterval(this, "checkSubMenu", 30);
					
					Tweener.addTween(up["bg2"] , { _height:80, time: .3, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["bg"] , { _height:94, time: .3, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["title"] , { _y:75, time: .3, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["mask"] , { _y:75, time: .3, transition: "easeOutCubic", rounded:true } );
				}
				else {
					Tweener.addTween(up["bg2"] , { _height:50, time: .5, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["bg"] , { _height:63, time: .5, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["title"] , { _y:45, time: .5, transition: "easeOutCubic", rounded:true } );
					Tweener.addTween(up["mask"] , { _y:45, time: .5, transition: "easeOutCubic", rounded:true } );
				}
			}
			
			iii++;
			testButton = firstLevelArray[iii];
		}
	}
	
	private function cancelSub(pSub:MovieClip) {
		pSub._visible = false;
	}
	
	
	private function checkSubMenu() {
		if (!(currentActiveSubMenu.hitTest(this._xmouse, this._ymouse, true))) {
			clearInterval(myIntervalMenu);
			Tweener.addTween(currentActiveSubMenu, { _alpha:0, time: .3, transition: "linear", onComplete:Proxy.create(this, cancelSub, currentActiveSubMenu) } );
			
			Tweener.addTween(up["bg2"] , { _height:50, time: .5, transition: "easeOutCubic", rounded:true } );
			Tweener.addTween(up["bg"] , { _height:63, time: .5, transition: "easeOutCubic", rounded:true } );
			Tweener.addTween(up["title"] , { _y:45, time: .5, transition: "easeOutCubic", rounded:true } );
			Tweener.addTween(up["mask"] , { _y:45, time: .5, transition: "easeOutCubic", rounded:true } );
		}
	}
	
	private function buttonRollOut(obj:Object) {
		
	}
	
	private function drawOvalHeavilyModified(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number, 
				  topw:Number, toph:Number, position:String, topColor:Number, topAlpha:Number, padj:Number) {

		// this function will only work with drawTopSemiOval() and alignX()
			mc.clear();
			mc.beginFill(fillColor,alphaAmount);
			mc.moveTo(r,0);
			
			if (padj == 0) {
				if(position=="center"){
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw-r,mh);
					mc.lineTo(r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
				}
				
				if(position =="left"){
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw-r,mh);
					mc.lineTo(r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,0);
					mc.curveTo(0,0,r,0);
				}
				
				if(position=="right"){
					mc.lineTo(mw,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw-r,mh);
					mc.lineTo(r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
				}
			}
			else {
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw-r,mh);
					mc.lineTo(r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
			}
			
			
			mc.endFill();
			
			
			var mc2:MovieClip = mc.createEmptyMovieClip("top", mc.getNextHighestDepth());
			
			drawTopSemiOval(mc2, topw, toph, r, position, topColor, topAlpha, padj);
			
			alignX(mc2,topw, mw ,position, padj);
			
			mc2._y = -toph;
		}


	private	function drawTopSemiOval(mc:MovieClip, mw:Number, mh:Number, r:Number, position:String, fillColor:Number, alphaAmount:Number, padj:Number) {
			//rounded corners at the top, and rounded outer corners at the bottom
			// if the radius will be equal with 1, no rounded corners will exist
			mc.clear();
			mc.beginFill(fillColor,alphaAmount);
			mc.moveTo(r,0);
			
			if (padj == 0) {
				if(position == "center"){
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw+r,mh);
					mc.lineTo(-r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
				}
				
				if(position=="left"){
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw+r,mh);
					mc.lineTo(0,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
				}
				
				if(position=="right"){
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw,mh);
					mc.lineTo(-r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
				}
			}
			else {
					mc.lineTo(mw-r,0);
					mc.curveTo(mw,0,mw,r);
					mc.lineTo(mw,mh-r);
					mc.curveTo(mw,mh,mw+r,mh);
					mc.lineTo(-r,mh);
					mc.curveTo(0,mh,0,mh-r)
					mc.lineTo(0,r);
					mc.curveTo(0,0,r,0);
			}
			
			
			mc.endFill();
		}

		private function alignX(mc:MovieClip, mcWidth:Number, relatedWidth:Number, position:String, padj:Number){
			if (padj == 0) {
				if(position == "center");
					mc._x = Math.round(relatedWidth/2 - mcWidth/2);
					
				if(position == "left")
					mc._x = 0;
					
				if(position == "right")
					mc._x = Math.round(relatedWidth - mcWidth);
			}
			else {
				mc._x = padj;
			}
			
			
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
				var iii:Number = 0;
				var testButton:MovieClip = firstLevelArray[iii];
				var firstTest:Boolean = false;
				
				while (testButton) {
				
					if (parseTheStr(testButton.node.attributes.url) == "/" + parseTheStr(my_str_array[1]) + "/") {
						if (buttonToLoad != testButton) {
							testButton.dispatchThisMC();
							firstTest = true;
							break;
						}
						else {
							if (currentXml == testButton.buttonXml) {
								firstTest = true;
								holder["ident" + swfIdx]["module"].treatAddress(SWFAddress.getValue());
							}
						}
					}
					iii++;
					testButton = firstLevelArray[iii];
				}
				
				if (!firstTest) {
					var iii:Number = 0;
					var testButton:MovieClip = secondLevelArray[iii];
				
					while (testButton) {
						if (parseTheStr(testButton.node.attributes.url) == "/" + parseTheStr(my_str_array[1]) + "/") {
							if (buttonToLoad != testButton) {
								testButton.dispatchThisMC();
								break;
							}
							else {
								if (currentXml == testButton.buttonXml) {
									holder["ident" + swfIdx]["module"].treatAddress(SWFAddress.getValue());
								}
							}
						}
						iii++;
						testButton = secondLevelArray[iii];
					}
				}
			}
			else {
				goLoad();
			}
	}
	
	
	private function goLoad() {
		var iii:Number = 0;
		var testButton:MovieClip = firstLevelArray[iii];
		var firstTest:Boolean = false;

		while (testButton) {
			if ((testButton.hiddenModule == 0) && (testButton.externalLink == 0)) {
				if ((!testButton.node.firstChild) || (testButton.node.firstChild.attributes.toggleSubMenu == 0)) {
					testButton.onRollOver();
					testButton.onRelease();
					firstTest = true;
					break;
				}
			}
					
			iii++;
			testButton = firstLevelArray[iii];
		}
				
		
		if (!firstTest) {
			var iii:Number = 0;
			var testButton:MovieClip = secondLevelArray[iii];
				
			while (testButton) {
				if ((testButton.hiddenModule == 0) && (testButton.externalLink == 0)) {
					testButton.onRollOver();
					testButton.onRelease();
					firstTest = true;
					break;
				}
				
				iii++;
				testButton = secondLevelArray[iii];
			}
		}
	}
	
	private function buttonPressed2(obj:Object) {
		if (permit == 1) {
			permitXmlLoad = 0;
			
			if (currentButton != obj.mc) {
				_global.popPresent = 0;

				permit = 0;
				
				currentButton.reset();
				currentButton = obj.mc.firstLevel;
				currentButton.act();
				
				currentButton2.reset();
				currentButton2 = buttonToLoad = obj.mc;
				currentButton2.act();
				
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
				
				if (obj.mc.buttonXml) {
					permitXmlLoad = 1;
					
					Tweener.addTween(loader, { _alpha:100, time: .5, delay:.2, transition: "linear", rounded:true } );
					loader["text"]["n"].text = "";
					
					var xmlOb:XML = new XML();
					_global.myXml = xmlOb;
					xmlOb.ignoreWhite = true;
					xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoadedOnModule);
					currentXml = obj.mc.buttonXml;
					
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
	 * function executed when the button gets pressed
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		if (permit == 1) {
			permitXmlLoad = 0;
			
			if (currentButton != obj.mc) {
				_global.popPresent = 0;

				permit = 0;
				currentButton2.reset();
				currentButton2 = undefined;
				
				currentButton.reset();
				currentButton = obj.mc;
				currentButton.act();
				
				buttonToLoad = currentButton;
				
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
				
				if (obj.mc.buttonXml) {
					permitXmlLoad = 1;
					
					Tweener.addTween(loader, { _alpha:100, time: .5, delay:.2, transition: "linear", rounded:true } );
					loader["text"]["n"].text = "";
					
					var xmlOb:XML = new XML();
					_global.myXml = xmlOb;
					xmlOb.ignoreWhite = true;
					xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoadedOnModule);
					currentXml = obj.mc.buttonXml;
					
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
				mcl.loadClip(buttonToLoad.node.attributes.swf, holder["ident" + swfIdx]);
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
		
		
		permit = 1;
		
	}

	/**
	 * function called when resizing the browser
	 * modify the 980 and 600 values if you want to setup a smaller limit for the resize
	 * @param	w
	 * @param	h
	 */
	private function resize(w:Number, h:Number) {
		if (w < settingsObj.maxWidth) {
			w = settingsObj.maxWidth;
		}
		
		if (h < settingsObj.maxHeight) {
			h = settingsObj.maxHeight;
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
		
		switch(settingsObj.menuPosition) {
			case "left":
				menuu._x = Math.round(settingsObj.alignXCorrection + defX);
				break;
			case "center":
				menuu._x = Math.round(w / 2 - menuWidthTotal / 2 + settingsObj.alignXCorrection);
				break;
			case "right":
				menuu._x = Math.round(w - menuWidthTotal + settingsObj.alignXCorrection);
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
		if (_ymouse < 100) {
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