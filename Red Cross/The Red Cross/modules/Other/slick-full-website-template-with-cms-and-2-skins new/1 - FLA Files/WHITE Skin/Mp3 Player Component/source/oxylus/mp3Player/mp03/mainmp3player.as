import oxylus.mp3Player.Tooltip03.Tooltip;
import ascb.util.Proxy;
import caurina.transitions.*;
import flash.filters.GlowFilter;
class oxylus.mp3Player.mp03.mainmp3player extends MovieClip
{
	private var myXml:XMLNode; 
	private var settings:Object
	public var songs:Array;
	public var sound:Sound;
	public var titles:Array;
	public var normal:MovieClip;
	public var over:MovieClip;
	public var m:MovieClip;
	public var p:MovieClip;
	public var next:MovieClip;
	public var prev:MovieClip;
	private var ww:Number;
	private var hh:Number;
	private var title:MovieClip;
	public var titlePlay:MovieClip;
	public var titleMute:MovieClip;
	
	private var title2:MovieClip;
	
	private var alphas:Array;
	private var ratios:Array;
	private var colors:Array;
	public var myTime:Number;
	public var myAnimation:String;
	public var playing:Number;
	public var playIdx:Number;
	public var currentPos:Number;
	public var ini:Number = 0;
	
	public var int:Number;
	
	public var mod:Number;
	
	public var scrubber:MovieClip;
	
	public var myInterval:Number;
	public var myInterval2:Number;
	public var soundInterval:Number;
	private var aprxPos:Number;
	
	public var timeN:Number = 0.2; // the time in which the tooltip will appear
	
	
	public var tool:MovieClip;
	
	public var prvv:Number;
	public var nextt:Number;
	
	public function mainmp3player()
	{
		mod = 0;
		_global.mp3 = this;
		_global.play = false;
		
		this._visible = false;
		normal = this["normal"];
		over = this["over"];
		
		m = this["mute_holder"];
		p = this["play_holder"];
		
		next = this["next"];
		prev = this["prev"];
		
		//scrubber = this.attachMovie("IDscrubber", "scrubber", this.getNextHighestDepth());
		
		
		settings = new Object();
		songs = new Array();
		titles = new Array();
		var xmlOb:XML = new XML();
		myXml = xmlOb;
		xmlOb.ignoreWhite = true;
		xmlOb.onLoad = Proxy.create(this, cont, myXml, settings);
		if(_global.mp3PlayerXml != undefined){
			xmlOb.load(_global.mp3PlayerXml);
		}
		else{
			xmlOb.load("mp3player.xml");
		}
		
		
		Stage.scaleMode = "noScale";
		Stage.align = "LT";
		this._lockroot = true;
		
		tool = Tooltip.attach(this._parent._parent._parent);
		tool.setTheMc(this._parent._parent._parent);
	
	}
	public function pauseThis(){
		if(_global.play == true){
			_global.play == false;
			pOnRollOver()
			onnnPress();
			pOnRollOut();
			disableAll();
		}
	}
	
	public function disableAll(){
		next.enabled = prev.enabled = p.enabled = false;
	}
	
	public function enableAll(){
		next.enabled = prev.enabled = p.enabled = true;
	}
	private function cont()
	{
	
		var a = myXml.firstChild.firstChild;
		settings.playerX = Number(a.attributes.playerX);
		settings.playerY = Number(a.attributes.playerY);
		
		
		settings.onFirstStart = String(a.attributes.onFirstStart);
		settings.animationTime = myTime = Number(a.attributes.animationTime);
		settings.animationType = myAnimation = String(a.attributes.animationType);
		
		settings.toggleShadow = Number(a.attributes.toggleShadow);
		settings.correctTextXPos = Number(a.attributes.correctTextXPos);
		
		settings.toggleBg = Number(a.attributes.toggleBg);
		settings.bgWidth = Number(a.attributes.bgWidth);
		settings.bgHeight = Number(a.attributes.bgHeight);
		settings.bgRadius = Number(a.attributes.bgRadius);
		settings.bgColor1 = Number(a.attributes.bgColor1);
		settings.bgColor2 = Number(a.attributes.bgColor2);
		settings.bgColor3 = Number(a.attributes.bgColor3);
		settings.bgAlpha = Number(a.attributes.bgAlpha);
		settings.toggleBgStroke = Number(a.attributes.toggleBgStroke);
		settings.bgStrokeColor = Number(a.attributes.bgStrokeColor);
		
		
			
		
		settings.playGraphicWidth = Number(a.attributes.playGraphicWidth);
		settings.playGraphicHeight = Number(a.attributes.playGraphicHeight);
		settings.playGraphicAlpha = Number(a.attributes.playGraphicAlpha);
		
		settings.mouseOverGraphicColor1 = Number(a.attributes.mouseOverGraphicColor1);
		settings.mouseOverGraphicColor2 = Number(a.attributes.mouseOverGraphicColor2);
		settings.mouseOverGraphicColor3 = Number(a.attributes.mouseOverGraphicColor3);
		settings.mouseOutGraphicColor1 = Number(a.attributes.mouseOutGraphicColor1);
		settings.mouseOutGraphicColor2 = Number(a.attributes.mouseOutGraphicColor2);
		settings.mouseOutGraphicColor3 = Number(a.attributes.mouseOutGraphicColor3);
		
		settings.enabled = String(a.attributes.enabled);
		if (settings.enabled == "true") {
			
		
		p["mask"]._width = settings.playGraphicWidth;
		p["mask"]._height = settings.playGraphicHeight;
		
		resetArrays();
		alphas = [settings.playGraphicAlpha, settings.playGraphicAlpha, settings.playGraphicAlpha];
		colors = [settings.mouseOutGraphicColor1, settings.mouseOutGraphicColor2, settings.mouseOutGraphicColor3];
		drawGradient(p["bg"]["normal"], settings.playGraphicWidth, settings.playGraphicHeight, 0, colors, alphas, ratios, 90);
		
		resetArrays();
		alphas = [settings.playGraphicAlpha, settings.playGraphicAlpha, settings.playGraphicAlpha];
		colors = [settings.mouseOverGraphicColor1, settings.mouseOverGraphicColor2, settings.mouseOverGraphicColor3];
		drawGradient(p["bg"]["over"], settings.playGraphicWidth, settings.playGraphicHeight, 0, colors, alphas, ratios, 90);
		
		p["bg"].setMask(p["mask"]);
	
		
		settings.muteGraphicWidth = Number(a.attributes.muteGraphicWidth);
		settings.muteGraphicHeight = Number(a.attributes.muteGraphicHeight);
		settings.muteGraphicAlpha = Number(a.attributes.muteGraphicAlpha);
		
		settings.playingVolume = Number(a.attributes.playingVolume);
		
		
		m["mask"]._width = settings.muteGraphicWidth;
		m["mask"]._height = settings.muteGraphicHeight;
		
		resetArrays();
		alphas = [settings.muteGraphicAlpha, settings.muteGraphicAlpha, settings.muteGraphicAlpha];
		colors = [settings.mouseOutGraphicColor1, settings.mouseOutGraphicColor2, settings.mouseOutGraphicColor3];
		drawGradient(m["bg"]["normal"], settings.muteGraphicWidth, settings.muteGraphicHeight, 0, colors, alphas, ratios, 90);
		
		resetArrays();
		alphas = [settings.muteGraphicAlpha, settings.muteGraphicAlpha, settings.muteGraphicAlpha];
		colors = [settings.mouseOverGraphicColor1, settings.mouseOverGraphicColor2, settings.mouseOverGraphicColor3];
		drawGradient(m["bg"]["over"], settings.muteGraphicWidth, settings.muteGraphicHeight, 0, colors, alphas, ratios, 90);
		
		
		m["bg"].setMask(m["mask"]);
		
		
		m._x = p._x;
		m._y = p._y;
		
		
		settings.toggleNextButton = Number(a.attributes.toggleNextButton);
		settings.nextButtonNormalColor1 = Number(a.attributes.nextButtonNormalColor1);
		settings.nextButtonNormalColor2 = Number(a.attributes.nextButtonNormalColor2);
		settings.nextButtonNormalColor3 = Number(a.attributes.nextButtonNormalColor3);
		settings.nextButtonOverColor1 = Number(a.attributes.nextButtonOverColor1);
		settings.nextButtonOverColor2 = Number(a.attributes.nextButtonOverColor2);
		settings.nextButtonOverColor3 = Number(a.attributes.nextButtonOverColor3);
		settings.nextButtonAlpha = Number(a.attributes.nextButtonAlpha);
		settings.nextButtonX = Number(a.attributes.nextButtonX);
		settings.nextButtonY = Number(a.attributes.nextButtonY);
		settings.toggleNextButtonShadow = Number(a.attributes.toggleNextButtonShadow);
		
		if (settings.toggleNextButton == 1)
		{
			resetArrays();
			alphas = [settings.nextButtonAlpha, settings.nextButtonAlpha, settings.nextButtonAlpha];
			colors = [settings.nextButtonNormalColor1, settings.nextButtonNormalColor2, settings.nextButtonNormalColor3];
			drawGradient(next["bg"]["normal"], next["mask"]._width, next["mask"]._height, 0, colors, alphas, ratios, 90);
			
			resetArrays();
			alphas = [settings.nextButtonAlpha, settings.nextButtonAlpha, settings.nextButtonAlpha];
			colors = [settings.nextButtonOverColor1, settings.nextButtonOverColor2, settings.nextButtonOverColor3];
			drawGradient(next["bg"]["over"], next["mask"]._width, next["mask"]._height, 0, colors, alphas, ratios, 90);
			
			next["bg"]["over"]._alpha = 0;
			next["bg"].setMask(next["mask"]);
			
			next._x = settings.nextButtonX;
			next._y = settings.nextButtonY;
			
			if (settings.toggleNextButtonShadow == 1)
			{
							var color_:Number = 0x000000;
							var alpha_:Number = 2;
							var blurX_:Number = 6;
							var blurY_:Number = 6;
							var strength_:Number = .4;
							var quality_:Number = 2;
							var inner_:Boolean = false;
							var knockout_:Boolean = false;

							var filter_:GlowFilter = new GlowFilter(color_, 
																	alpha_, 
																	blurX_, 
																	blurY_, 
																	strength_, 
																	quality_, 
																	inner_, 
																	knockout_);
							next.filters = [filter_];
			}
			
			next._alpha = 0;
			next.createEmptyMovieClip("hit", next.getNextHighestDepth());
			drawOval(next["hit"],next._width,next._height, 0, 0x000000,0);
			
			
		}
		else
		{
			next._visible = false;
		}
		
		
		settings.togglePrevButton = Number(a.attributes.togglePrevButton);
		settings.prevButtonNormalColor1 = Number(a.attributes.prevButtonNormalColor1);
		settings.prevButtonNormalColor2 = Number(a.attributes.prevButtonNormalColor2);
		settings.prevButtonNormalColor3 = Number(a.attributes.prevButtonNormalColor3);
		settings.prevButtonOverColor1 = Number(a.attributes.prevButtonOverColor1);
		settings.prevButtonOverColor2 = Number(a.attributes.prevButtonOverColor2);
		settings.prevButtonOverColor3 = Number(a.attributes.prevButtonOverColor3);
		settings.prevButtonAlpha = Number(a.attributes.prevButtonAlpha);
		settings.prevButtonX = Number(a.attributes.prevButtonX);
		settings.prevButtonY = Number(a.attributes.prevButtonY);
		settings.togglePrevButtonShadow = Number(a.attributes.togglePrevButtonShadow);
		
		if (settings.togglePrevButton == 1)
		{
			resetArrays();
			alphas = [settings.prevButtonAlpha, settings.prevButtonAlpha, settings.prevButtonAlpha];
			colors = [settings.prevButtonNormalColor1, settings.prevButtonNormalColor2, settings.prevButtonNormalColor3];
			drawGradient(prev["bg"]["normal"], prev["mask"]._width, prev["mask"]._height, 0, colors, alphas, ratios, 90);
			
			resetArrays();
			alphas = [settings.prevButtonAlpha, settings.prevButtonAlpha, settings.prevButtonAlpha];
			colors = [settings.prevButtonOverColor1, settings.prevButtonOverColor2, settings.prevButtonOverColor3];
			drawGradient(prev["bg"]["over"], prev["mask"]._width, prev["mask"]._height, 0, colors, alphas, ratios, 90);
			
			prev["bg"]["over"]._alpha = 0;
			prev["bg"].setMask(prev["mask"]);
			
			prev._x = settings.prevButtonX;
			prev._y = settings.prevButtonY;
			
			if (settings.togglePrevButtonShadow == 1)
			{
							var color_:Number = 0x000000;
							var alpha_:Number = 2;
							var blurX_:Number = 6;
							var blurY_:Number = 6;
							var strength_:Number = .4;
							var quality_:Number = 2;
							var inner_:Boolean = false;
							var knockout_:Boolean = false;

							var filter_:GlowFilter = new GlowFilter(color_, 
																	alpha_, 
																	blurX_, 
																	blurY_, 
																	strength_, 
																	quality_, 
																	inner_, 
																	knockout_);
							prev.filters = [filter_];
			}
			
			prev._alpha = 0;
			
			prev.createEmptyMovieClip("hit", prev.getNextHighestDepth());
			drawOval(prev["hit"],prev._width,prev._height, 0, 0x000000,0);
			
			
		}
		else
		{
			prev._visible = false;
		}
		
		
		
		var b:XMLNode = a.nextSibling.firstChild;
		for (; b != null; b = b.nextSibling)
		{
			songs.push(b.attributes.src);
			titles.push(b.attributes.title);
		}
		
		playIdx = 0;
		
		if (settings.onFirstStart == "play")
		{
			m._alpha = 0;
			p["bg"]["over"]._alpha = 0;
			m["bg"]["over"]._alpha = 0;
			playing = 1;
			init();
			ini = 0;
			gg();
			_global.play = true;
			trace("initial mp3 player status play");
		}
		else {
			p._alpha = 0;
			m["bg"]["over"]._alpha = 0;
			playing = 0; 
			ini = 1;
			_global.play = false;
			trace("initial mp3 player status paused");
		}
		
		if(ww!=undefined){
			this._x += ww/2;
			this._y += hh/2;
			
		}
		else{
			this._x += prev["mask"]._width/2;
			this._y += prev["mask"]._height/2;
			
		}
		
		this._alpha = 0;
		nextt = next._x-22;
		prvv = prev._x+6 ;
		next._x = nextt;
		prev._x = prvv;
		m._y = p._y = 7;
		
		Tweener.addTween(this, { _alpha:70,  delay:.5, time:Number(a.attributes.appearAnimationTime), transition:String(a.attributes.appearAnimationType), onComplete:Proxy.create(this, compS) } );
		Tweener.addTween(next, { _alpha:70, delay:Number(a.attributes.appearAnimationTime)/2, time:Number(a.attributes.appearAnimationTime), transition:String(a.attributes.appearAnimationType) } );		
		Tweener.addTween(prev, { _alpha:70, delay:Number(a.attributes.appearAnimationTime)/2, time:Number(a.attributes.appearAnimationTime), transition:String(a.attributes.appearAnimationType)} );		
		this._visible = true;
		
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onReleaseOutside = Proxy.create(this,prevOnReleaseOutside);
		
		p.onRollOver = Proxy.create(this, pOnRollOver);
		p.onRollOut = Proxy.create(this, pOnRollOut);
		p.onPress = Proxy.create(this, pOnPress);
		p.onReleaseOutside = Proxy.create(this, pOnReleaseOutside);
		}
		else {
			this._visible = false;
		}
	}
	
	private function compS()
	{
		Tweener.addTween(this._parent.scrubber, { _alpha:100,  time:myTime, transition:myAnimation } );		
		
	}
	
	private function nextOnRollOver() {
		mod = 1;
			Tweener.addTween(next["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );	
			
			var f:Number = playIdx;
			if (f == (songs.length - 1))
			{
				f = 0;
			}
			else
			{
				f++;
			}
			
			tool.setCustomVars({myTexts:"Next:<new_line>"+ titles[f],
			    myFonts:"my_font2",
			    myColors:"0x000000|0x787878",
				mySizes:"12|8",
				myVerticalSpaces:"2|-2",
				backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
				tipX:50,
				XDistanceFromCursor:-50,
				YDistanceFromCursor:-15
			});

			tool.show({ animationTime:timeN });
	}
	
	private function nextOnRollOut() {
		tool.hide( { animationTime:timeN } );
		
		
		switchTxt3();	
		Tweener.addTween(p["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(m["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(over, { _alpha:0,  time:myTime, transition:myAnimation,onStart:Proxy.create(this,ggg) } );
		
		
		Tweener.addTween(next["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation} );
		Tweener.addTween(prev["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
	}
	
	
	private function nextOnPress() {
		onnnPress()
	}
	
	private function nextOnReleaseOutside() {
		onnReleaseOutside()
	}
	
	
	private function prevOnRollOver() {
		mod = 2;
				Tweener.addTween(prev["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				
				var f:Number = playIdx;
				
				if (f == 0)
				{
					f = (songs.length - 1);
				}
				else
				{
					f--;
				}
				
				tool.setCustomVars({myTexts:"Previous:<new_line>"+ titles[f],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});

				tool.show( { animationTime:timeN } );
	}
	
	private function prevOnRollOut() {
		tool.hide( { animationTime:timeN } );
		
		
		switchTxt3();	
		Tweener.addTween(p["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(m["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(over, { _alpha:0,  time:myTime, transition:myAnimation,onStart:Proxy.create(this,ggg) } );
		
		
		Tweener.addTween(next["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation} );
		Tweener.addTween(prev["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
	}
	
	
	private function prevOnPress() {
		onnnPress()
	}
	
	private function prevOnReleaseOutside() {
		onnReleaseOutside()
	}
	
	private function pOnRollOver() {
		mod = 0;
				over["a"]._alpha = 0;
				Tweener.addTween(p["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				Tweener.addTween(m["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				Tweener.addTween(over, { _alpha:100,  time:myTime, transition:myAnimation, onComplete:Proxy.create(this, gg) } );
				switchTxt2();
	}
	
	private function pOnRollOut() {
		tool.hide( { animationTime:timeN } );
		
		
		switchTxt3();	
		Tweener.addTween(p["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(m["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(over, { _alpha:0,  time:myTime, transition:myAnimation,onStart:Proxy.create(this,ggg) } );
		
		
		Tweener.addTween(next["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation} );
		Tweener.addTween(prev["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
	}
	
	
	private function pOnPress() {
		onnnPress()
	}
	
	private function pOnReleaseOutside() {
		onnReleaseOutside()
	}
	
	/*private function onRollOver()
	{	
		if (_xmouse > (next._x-8))
		{
			mod = 1;
			Tweener.addTween(next["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );	
			
			var f:Number = playIdx;
			if (f == (songs.length - 1))
			{
				f = 0;
			}
			else
			{
				f++;
			}
			
			tool.setCustomVars({myTexts:"Next:<new_line>"+ titles[f],
			    myFonts:"my_font2",
			    myColors:"0x000000|0x787878",
				mySizes:"12|8",
				myVerticalSpaces:"2|-2",
				backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
				tipX:50,
				XDistanceFromCursor:-50,
				YDistanceFromCursor:-15
			});

			tool.show({ animationTime:timeN });
			
		}
		else
		{
			if (this._xmouse<0)
			{
				mod = 2;
				Tweener.addTween(prev["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				
				var f:Number = playIdx;
				
				if (f == 0)
				{
					f = (songs.length - 1);
				}
				else
				{
					f--;
				}
				
				tool.setCustomVars({myTexts:"Previous:<new_line>"+ titles[f],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});

				tool.show( { animationTime:timeN } );
			
			}
			else
			{
				mod = 0;
				over["a"]._alpha = 0;
				Tweener.addTween(p["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				Tweener.addTween(m["bg"]["over"], { _alpha:100,  time:myTime, transition:myAnimation } );
				Tweener.addTween(over, { _alpha:100,  time:myTime, transition:myAnimation, onComplete:Proxy.create(this, gg) } );
				switchTxt2();
			}
		}
		
	
	}
	
	private function onRollOut()
	{
		tool.hide( { animationTime:timeN } );
		
		
		switchTxt3();	
		Tweener.addTween(p["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(m["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		Tweener.addTween(over, { _alpha:0,  time:myTime, transition:myAnimation,onStart:Proxy.create(this,ggg) } );
		
		
		Tweener.addTween(next["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation} );
		Tweener.addTween(prev["bg"]["over"], { _alpha:0,  time:myTime, transition:myAnimation } );
		
	}
	*/
	private function onnnPress()
	{
		if (mod == 0)
		{
			if (playing == 1)
			{
				playing = 0;
				currentPos = sound.position;
				sound.stop();
				_global.play = false;
			}
			else
			{
				playing = 1;
				_global.play = true;
				sound.start(currentPos / 1000);
			}
		
			switchTxt();
		
			if (ini == 1)
			{
				_global.play = true;
				init();
				ini = 2;
			}
		}
		
		else
		{
			if (mod == 1)
			{
				if (ini == 1)
				{
					_global.play = true;
					init();
					ini = 2;
					playing = 1;
					switchTxt4();
				}
				else
				{
					playing = 1;
					goFurther();
					switchTxt4();
				}
				
				var f:Number = playIdx;
				if (f == (songs.length - 1))
				{
					f = 0;
				}
				else
				{
					f++;
				}
				
				
				tool.setCustomVars({myTexts:"Next:<new_line>"+ titles[f],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});

				tool.show({ animationTime:timeN });
				
			}
			else
			{
				if (mod == 2)
				{
					if (ini == 1)
					{
						init();
						ini = 2;
						_global.play = true;
						playing = 1;
						switchTxt4();
					}
					else
					{
						_global.play = true;
						playing = 1;
						goBack();
						switchTxt4();
					}
					
					var f:Number = playIdx;
				
				if (f == 0)
				{
					f = (songs.length - 1);
				}
				else
				{
					f--;
				}
				
				tool.setCustomVars({myTexts:"Previous:<new_line>"+ titles[f],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});

				tool.show( { animationTime:timeN } );
				
				}
			}
		}
		
		
		
	}
	
	private function onnReleaseOutside() {
		tool.hide( { animationTime:timeN } );
		
	}
	
	
	private function init()
	{
		sound.stop();
		delete sound;
		sound = new Sound();
		sound.setVolume(settings.playingVolume);
		sound.onSoundComplete = Proxy.create(this, goFurther);
		sound.onLoad = Proxy.create(this,soundLoadDone);
		sound.loadSound(songs[playIdx], true);
		
		scrubHandle();
	}
	
	public function scrubHandle()
	{
		if (settings.toggleScrubber == 1)
		{
			
			clearInterval(myInterval);
			clearInterval(myInterval2);
			clearInterval(soundInterval);
		
			myInterval = setInterval(this, "checkProgress", 30);
		
			myInterval2 = setInterval(this, "checkPlayProgress", 10);	
		
			soundInterval = setInterval(this, "ct", 30);
			
			this._parent.scrubber.sound = sound;
		}
	
	}
	
	public function checkPlayProgress()
	{
		
		var aux:Number = Math.round(sound.getPosition() / aprxPos * 100);
		
		this._parent.scrubber.playProgress(aux);
	}
	
	private function resize(aux:Number)
	{
		this._parent.scrubber.loadProgress(aux);
	}
	
	private function checkProgress()
	{
		//updating the progress bar according to the made progresss
		var pct:Number = Math.round(sound.getBytesLoaded()/sound.getBytesTotal()*100);
		var pos:Number = Math.round(sound.getPosition()/sound.getDuration()*100);
	
		if (pct < 100)
		{
			resize(pct);
		}
		else
		{
			resize(100);
			clearInterval(myInterval);
		}
	
	}
	
	public function soundLoadDone()
	{
		var totalSeconds:Number = sound.duration/1000;
			
			var minutes:Number = Math.floor(totalSeconds/60);
			var seconds = Math.floor(totalSeconds) % 60;
			
			if (seconds<10) {
				seconds = "0" + seconds;
			}
			
		
		clearInterval(soundInterval);
		
		aprxPos = sound.getDuration();
		this._parent.scrubber.aprxPos = aprxPos;
	}
	
	public function ct()
	{
		//aproximating the total length after a formula based on the kbps
		var loaded = sound.getBytesLoaded();
		var duration = sound.duration;		
		var kbps = ((loaded/1000)/(duration/1000));
              
		var total = sound.getBytesTotal()/1000;	
		var timeTotal = (total/kbps)/60;
		
		aprxPos = timeTotal / 2 * 100 * 1000 + 4000;
		
		this._parent.scrubber.aprxPos = aprxPos;
		
	}
	
	private function goFurther()
	{
		if (playIdx == (songs.length - 1))
		{
			playIdx = 0;
		}
		else
		{
			playIdx++;
		}
		
		init();
	}
	
	private function goBack()
	{
		if (playIdx == 0)
		{
			playIdx = (songs.length - 1);
		}
		else
		{
			playIdx--;
		}
			
		init();
	}

	
	
	private function switchTxt3()
	{
		
	}
	private function switchTxt2()
	{
		if (playing == 1)
		{
				
			tool.setCustomVars({myTexts:"Click to mute:<new_line>Playing: "+ titles[playIdx],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});
		}
		else
		{
			
			tool.setCustomVars({myTexts:"Click to play<new_line>"+ titles[playIdx],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});
		}
		
		tool.show( { animationTime:timeN } );
	}
	
	private function switchTxt()
	{
		if (playing == 0)
		{
			Tweener.addTween(p, { _alpha:0, time:myTime, transition:myAnimation, onStart:Proxy.create(this, gm1) } );
			
			tool.setCustomVars({myTexts:"Click to play<new_line>"+ titles[playIdx],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});
			
		}
		else
		{
			Tweener.addTween(p, { _alpha:100,  time:myTime, transition:myAnimation, onComplete:Proxy.create(this, gm2) } );
			
			tool.setCustomVars({myTexts:"Click to mute:<new_line>Playing: "+ titles[playIdx],
					myFonts:"my_font2",
					myColors:"0x000000|0x787878",
					mySizes:"12|8",
					myVerticalSpaces:"2|-2",
					backgroundColor:"0xdfdfdf|0xebebeb|0xfdfdfd",
					tipX:50,
					XDistanceFromCursor:-50,
					YDistanceFromCursor:-15
				});
		}
		tool.show( { animationTime:timeN } );
		
	}
	
	private function switchTxt4()
	{
		if (playing == 0)
		{
			Tweener.addTween(p, {_alpha:0, time:myTime, transition:myAnimation,onStart:Proxy.create(this,gm1)} );
		}
		else
		{
			Tweener.addTween(p, {_alpha:100,  time:myTime, transition:myAnimation,onComplete:Proxy.create(this,gm2)} );
		}
		
	}
	
	private function gm1()
	{
		m._alpha = 100;
	}
	private function gm2()
	{
		m._alpha = 0;
	}
	
	private function gg()
	{
		Tweener.addTween(over["a"], {_alpha:100, time:.2, transition:myAnimation} );
	}
	
	private function ggg()
	{
		Tweener.addTween(over["a"], {_alpha:0, time:.2, transition:myAnimation} );
	}
	
	
	
	
	
	private function resetArrays()
	{
		alphas = new Array();
		ratios = new Array();
		ratios = [0, 127.5, 255];
		colors = new Array();
	}
	

	public function modifyText(theText:TextField, theText_:TextField, theText__:TextField)
	{//function used to change the text's poperties 
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.color = settings.playFontColor;
		my_fmt.font = settings.playFontName;
		my_fmt.size = settings.playFontSize;
		theText.setTextFormat(my_fmt);
		
		
		var my_fmt_:TextFormat = new TextFormat();
		my_fmt_.color = settings.muteFontColor;
		my_fmt_.font = settings.muteFontName;
		my_fmt_.size = settings.muteFontSize;
		theText_.setTextFormat(my_fmt_);
	}
	
	public function modifyText2(theText:TextField, theText_:TextField, theText__:TextField)
	{//function used to change the text's poperties 
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.color = settings.nextFontColor;
		my_fmt.font = settings.nextFontName;
		my_fmt.size = settings.nextFontSize;
		theText.setTextFormat(my_fmt);
		
		
		var my_fmt_:TextFormat = new TextFormat();
		my_fmt_.color = settings.prevFontColor;
		my_fmt_.font = settings.prevFontName;
		my_fmt_.size = settings.prevFontSize;
		theText_.setTextFormat(my_fmt_);
		
		
	}
	
	
	private function drawGradient(mc:MovieClip, mw:Number, mh:Number, r:Number, colors:Array, alphas:Array, ratios:Array, radius:Number) {

	//draws an gradient oval or square if r=0, radius takes values from 0--360 and it's the gradient's orientation

	//colors = [0x00ff00, 0xff0000, 0x0000ff];
	//alphas = [100, 100, 100];
	//ratios = [0, 127.5, 255];

		var matrix:Object = {matrixType:"box", x:0, y:0, w:mw, h:mh, r:(radius*Math.PI/180)};
		mc.clear();
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
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
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
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