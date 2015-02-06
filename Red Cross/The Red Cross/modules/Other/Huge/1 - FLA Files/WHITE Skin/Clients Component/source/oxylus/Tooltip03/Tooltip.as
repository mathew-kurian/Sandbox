import caurina.transitions.*;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;
import ascb.util.Proxy;

class oxylus.Tooltip03.Tooltip extends MovieClip
{
	private var Text:MovieClip;
	private var bg:MovieClip;
	private var stroke:MovieClip;
	private var pic:MovieClip;
	private var obj:Object;
	private var currentPos:Number;
	private var maxTextWidth:Number;
	private var mcl:MovieClipLoader;
	private var ImageHolder:MovieClip;
	private var myImage:MovieClip;
	private var myImageBg:MovieClip;
	private var myInt:Number;
	private var actualBgWidth:Number;
	private var actualBgHeight:Number;
	
	private var refMc:MovieClip;
	
	public function Tooltip()
	{
		this._alpha = 0;
		this._x = Stage.width;
		this._y = Stage.height;
		Text = this.createEmptyMovieClip("Text", this.getNextHighestDepth());
		stroke = this["stroke"];
		bg = this["bg"];
		
		defaultValues();
	}
	
	/**
	 * In this function you can setup your own default values in oder to shorten out your
	 * code !
	 * When calling this function from another app the default values will be overwritten with
	 * the values you provide but if you will not provide a certain value, the default one will remain
	 * Ex: If the whole app has 30 values in total (already defined by you) and you will send 10 values, 
	 * those 10 values will be overwritten and the other ones kept.
	 */
	private function defaultValues()
	{
		obj = new Object();
		obj.strokeColor = 0x000000;
		obj.strokeAlpha = 100;
		obj.strokeWidth = 0;
		
		
		obj.backgroundColor = new Array();
		obj.backgroundAlpha = 100;
		obj.backgroundRadius = 0;
		obj.backgroundWidth = 0;
		obj.backgroundHeight = 0;
		obj.tipOrientation = "bottom";
		obj.tipWidth = 0;
		obj.tipHeight = 0;
		obj.tipInclination = 0;
		obj.tipX = 0;
		obj.tipAutoMove = "false";
		
		obj.myTexts = new Array();
		obj.myTexts[0] = "Text unavailable, please execute setCustomVars({ }) !";
		obj.myFonts = new Array();
		obj.myFonts[0] = "my_font1";
		obj.myColors = new Array();
		obj.mySizes = new Array();
		obj.myUnderlines = new Array();
		obj.myLengths = new Array();
		obj.myVerticalSpaces = new Array();
		obj.textXPos = 0;
		obj.image = "";
		obj.imageWidth = obj.imageHeight = 30;
		obj.imageBackgroundColor = 0xffffff;
		obj.imageBackgroundAlpha = 100;
		obj.imageBackgroundWidth = 0;
		obj.imageX = 0;
		obj.imageY = 0;
		obj.farX = 4;
		obj.delay = 0.1;
		obj.animationTime = 0.5;
		obj.animationType = "linear";
		obj.stay = 0;
		
		obj.XDistanceFromCursor = 0;
		obj.YDistanceFromCursor = 0;
		obj.alignHoriz = "center";
		obj.alignVerti = "top"
		obj.stageToleranceX = 0;
		obj.stageToleranceY = 0;
		
		
		obj.addShadow = "false";
		obj.shadowDistance = 1;
		obj.shadowAngleInDegrees = 45;
		obj.shadowColor = 0x000000;
		obj.shadowAlpha = 0.25;
		obj.shadowBlurX = 1.5;
		obj.shadowBlurY = 1.5;
		obj.shadowStrength = 1;
		obj.shadowQuality = 3;
		obj.shadowInner = false;
		obj.shadowKnockout = false;
		obj.shadowHideObject = false;
	
		
	}
	
	
	/**
	 * This function will be called from outside and it will show the tooltip
	 * @param	myObj
	 */
	public function show(myObj:Object)
	{
		clearInterval(myInt);
		Tweener.removeTweens(this);
		shortParse(myObj);
		Tweener.addTween(this, {_alpha:100, delay:obj.delay, time:obj.animationTime, transition:obj.animationType, onStart:Proxy.create(this,startInterval)});
	}
	
	/**
	 * This function will execute the interval used for moving the tooltip after the mouse
	 * This will also detect either the stay value of the tooltip has been initiated
	 */
	public function startInterval()
	{
		
		move(1);
		if (obj.stay != 0)
		{
			Tweener.addTween(this, {_alpha:0, delay:obj.stay, time:obj.animationTime, transition:obj.animationType,onStart:Proxy.create(this,endInterval)});
		}
		clearInterval(myInt);
		myInt = setInterval(this, "move", 10);
	}
	
	/**
	 * This function will execute every 10 miliseconds and this will handle the tooltip's movement
	 * and the tip's movement, it will take into consideration all the cases.
	 * Note that some of the tooltip's methods may not work ok when the tip is set to move according to
	 * the mouse position relevant to the scene.
	 * @param	aux
	 */
	public function move(aux)
	{
		switch(obj.alignHoriz)
		{
			case "center":
				if (((refMc._xmouse + actualBgWidth / 2 + obj.stageToleranceX) < Stage.width)&&((refMc._xmouse - actualBgWidth / 2)>obj.stageToleranceX))
				{
					this._x = Math.round(refMc._xmouse - actualBgWidth / 2);
					
					if (obj.tipAutoMove == "true")
					{
						obj.tipX = actualBgWidth/2 + obj.tipWidth/2;
						buildBackground();
					}
				}
				else
				{
					if ((refMc._xmouse - actualBgWidth / 2 - obj.stageToleranceX) < 0)
					{
						this._x = obj.stageToleranceX;
						
						if ((aux == 1)&&(obj.tipAutoMove == "true"))
						{
							obj.tipX = obj.tipWidth + obj.backgroundRadius;
							buildBackground();
						}
						
						if ((obj.tipAutoMove == "true")&&((refMc._xmouse-obj.stageToleranceX-obj.backgroundRadius)>obj.tipWidth/2))
						{
							obj.tipX = refMc._xmouse - obj.stageToleranceX + obj.tipWidth/2;
							buildBackground();
						}
					}
					else
					{
						
						if (aux == 1)
						{
							if (obj.tipAutoMove == "true")
							{
								this._x = Math.round(Stage.width - actualBgWidth - obj.stageToleranceX);
								obj.tipX = actualBgWidth- obj.strokeWidth-obj.backgroundRadius;
								buildBackground();
							}
							else
							{
								this._x = Math.round(Stage.width - actualBgWidth - obj.stageToleranceX);
							}
						}
						
						
						
						if ((obj.tipAutoMove == "true")&&((refMc._xmouse - Math.round(Stage.width - actualBgWidth - obj.stageToleranceX) + obj.strokeWidth +obj.tipWidth+obj.backgroundRadius)<actualBgWidth))
						{
							obj.tipX = refMc._xmouse - Math.round(Stage.width - actualBgWidth - obj.stageToleranceX - obj.tipWidth - obj.strokeWidth);
							buildBackground();
						}
						
						
					}
				}
				break;
				
			case "left":
				
				if (((refMc._xmouse +  obj.tipWidth / 2 +obj.backgroundRadius + obj.stageToleranceX) < Stage.width) && ((refMc._xmouse - actualBgWidth + obj.tipWidth + obj.backgroundRadius)>obj.stageToleranceX))
				{
					this._x = Math.round(refMc._xmouse - actualBgWidth + obj.tipWidth + obj.backgroundRadius+obj.XDistanceFromCursor);
					obj.tipX = actualBgWidth - obj.strokeWidth - obj.backgroundRadius;
					buildBackground();
					
				}
				else
				{
					if ((refMc._xmouse - actualBgWidth - obj.stageToleranceX ) < 0)
					{
						if (this._x != obj.stageToleranceX)
						{
							this._x = obj.stageToleranceX;
						}
						
						
						if ((aux == 1)&&(obj.tipAutoMove == "true"))
						{
							this._x = obj.stageToleranceX;
							obj.tipX = obj.tipWidth + obj.strokeWidth + obj.backgroundRadius;
							buildBackground();
						}
						
						if ((obj.tipAutoMove == "true")&&((refMc._xmouse - obj.stageToleranceX + obj.tipWidth/2 - obj.strokeWidth-obj.backgroundRadius)>obj.tipWidth))
						{
							obj.tipX = (refMc._xmouse - obj.stageToleranceX + obj.tipWidth/2 - obj.strokeWidth);
							buildBackground();
						}
					}
					else
					{
						if ((aux == 1)&&(obj.tipAutoMove == "true"))
						{
							this._x = Math.round(refMc._xmouse - actualBgWidth + obj.tipWidth/2 - obj.stageToleranceX);
							obj.tipX = actualBgWidth - obj.strokeWidth - obj.backgroundRadius;
							buildBackground();
						}
					}
				}
				break;
			case "right":
			if (((refMc._xmouse + actualBgWidth + obj.stageToleranceX) < Stage.width)&&((refMc._xmouse - obj.stageToleranceX)>0))
				{
					this._x = Math.round(refMc._xmouse-obj.tipWidth + obj.XDistanceFromCursor);
					obj.tipX =obj.tipWidth+obj.tipWidth;
					buildBackground();
					
				}
				else
				{
					if ((refMc._xmouse + actualBgWidth + obj.stageToleranceX + obj.tipWidth/2-obj.backgroundRadius) > Stage.width)
					{
						this._x = Math.round(Stage.width - obj.stageToleranceX - actualBgWidth);
						
						if ((aux == 1)&&(obj.tipAutoMove == "true"))
						{
							obj.tipX = actualBgWidth - obj.strokeWidth -obj.backgroundRadius ;
							buildBackground();
						}
						
						if ((obj.tipAutoMove == "true")&&((refMc._xmouse - this._x + obj.tipWidth/2+obj.backgroundRadius)<actualBgWidth))
						{
							obj.tipX = refMc._xmouse - this._x + obj.tipWidth/2;
							buildBackground();
						}
					}
					
					
				}
				
				break;
			
		}
		
		switch(obj.alignVerti)
		{
			case "top":
				var yP:Number = Math.round(refMc._ymouse - this._height + obj.YDistanceFromCursor);
				if (yP > obj.stageToleranceY)
				{
					this._y = yP;

				}
				else
				{
					this._y = obj.stageToleranceY;
				}
				
				break;
			case "middle":
				var yP:Number = Math.round(refMc._ymouse - this._height/2 + obj.YDistanceFromCursor);
				if (yP > obj.stageToleranceY)
				{
					if (yP + actualBgHeight > Stage.height-obj.stageToleranceY)
						yP = Stage.height - actualBgHeight - obj.stageToleranceY;
					this._y = yP;
				}
				else
				{
					yP = obj.stageToleranceY;
					this._y = yP;
				}
				
				break;
			case "bottom":
				var yP:Number = Math.round(refMc._ymouse + obj.YDistanceFromCursor);
				if (yP > 0)
				{
					if ((yP+actualBgHeight) > Stage.height-obj.stageToleranceY)
					{
						yP = Stage.height - actualBgHeight - obj.stageToleranceY;
					}
					
					this._y = yP;
				}
				break;
		}
		
		updateAfterEvent();
	}

	/**
	 * This function will hide the tooltip.
	 * This must be called from an outside app
	 * @param	myObj
	 */
	public function hide(myObj:Object)
	{
		//clearInterval(myInt);
		Tweener.removeTweens(this);
		shortParse(myObj);
		Tweener.addTween(this, {_alpha:0, time:obj.animationTime, transition:obj.animationType});
	}
	
	/**
	 * This function will end the interval used for moving the tooltip
	 * taking into consideration the mouse coordinates
	 */
	public function endInterval()
	{
		//clearInterval(myInt);
	}

	
	/**
	 * This function will be executed when the image finished loading, the image will be repositioned
	 * taking into consideration the image background width
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip)
	{
		var bd:BitmapData = new BitmapData(mc._width, mc._height);
		bd.draw(mc);
		mc.attachBitmap(bd, mc.getNextHighestDepth(), "always", true);
		mc._width = obj.imageWidth;
		mc._height = obj.imageHeight;
	}
	
	/**
	 * This function will execute for each line of text and it will parse the text
	 * and apply the text attributes
	 * @param	mc
	 * @param	idx
	 */
	private function formatMyText(mc,idx)
	{
		mc.text = obj.myTexts[idx];
		mc.autoSize = true;
		mc.wordWrap = true;
		mc.selectable = false;
	
		mc.antiAliasType = "advanced";
		mc.embedFonts = true;
		var tempTF = new TextFormat();
		tempTF.font = obj.myFonts[idx];
		
		tempTF.size = Number(obj.mySizes[idx]);
		tempTF.color = obj.myColors[idx];
		
		if (obj.myUnderlines[idx] == "true")
		{
			tempTF.underline = true;
		}
		
		mc.setTextFormat(tempTF);
		
		if (obj.myLengths[idx] > 0)
		{
			mc.wordWrap = true;
			mc._width = obj.myLengths[idx];
		}
		
		if (obj.myLengths[idx] == 0)
		{
			mc.wordWrap = false;
		}
		
		currentPos += Math.round(obj.myVerticalSpaces[idx]);
		mc._y = currentPos;
		currentPos += Math.round(mc._height);
		
		if (maxTextWidth < mc._width)
		{
			maxTextWidth = Math.round(mc._width);
		}
		
		
	}
	
	/**
	 * This function will build the background.
	 * If you have set the tooltip's tip to move this function will be executed every 10 miliseconds
	 */
	private function buildBackground()
	{
		var alphas:Array = new Array();
		var colors:Array = new Array();
		var ratios:Array = new Array();
		alphas = [obj.backgroundAlpha, obj.backgroundAlpha, obj.backgroundAlpha];
		colors = [obj.backgroundColor[0], obj.backgroundColor[1], obj.backgroundColor[2]];
		ratios = [0, 127.5, 255];
		if (obj.image.length != 0)
		{
			drawGradient(bg, obj.backgroundWidth + obj.imageX + obj.imageWidth, obj.backgroundHeight, obj.backgroundRadius, colors, alphas, ratios, 90);
		}
		else
		{
			drawGradient(bg, obj.backgroundWidth, obj.backgroundHeight, obj.backgroundRadius, colors, alphas, ratios, 90);
		}
		
		if(obj.addShadow == "true")
			addShadow();
	}
	
	/**
	 * This function will attach the tooltip.
	 * It will create a random instance name and it will attach the tooltip on the stage
	 * at the highest free depth found
	 * @return
	 */
	public static function attach(mc:MovieClip):MovieClip {
		
		var myTooltip:MovieClip = mc.attachMovie("IDTooltip", (String("myTooltip_" + random(50000))), mc.getNextHighestDepth());
		return myTooltip;
	}
	
	/**
	 * This function will add the shadow to the background
	 */
	private function addShadow() {

		var filter:DropShadowFilter = new DropShadowFilter(obj.shadowDistance, obj.shadowAngleInDegrees, obj.shadowColor,
									  obj.shadowAlpha, obj.shadowBlurX, obj.shadowBlurY, obj.shadowStrength, obj.shadowQuality, obj.shadowInner, obj.shadowKnockout, obj.shadowHideObject);
		var fa:Array = new Array();
		fa.push(filter);
		this.filters = fa;
	
	}
	
	/**
	 * This function will parse the object and it will replace the default values
	 * if existent with new ones
	 * @param	myObj
	 */
	public function shortParse(myObj:Object)
	{
		
		
		with (this) {
			for (var i in myObj) {
				switch(i)
				{
					case "delay":
						obj.delay = Number(myObj[i]);
						break;
					
					case "animationTime":
						obj.animationTime = Number(myObj[i]);
						break;
						
					case "animationType":
						obj.animationType = String(myObj[i]);
						break;
					
					case "stay":
						obj.stay = String(myObj[i]);
						break;
				}
			}
		}
	}
	
	/**
	 * This function will be called in the main app and it will receive
	 * the object, with all the customization parameters.
	 * If some of the customization parameters are not present, the default ones will be kept and
	 * if necessary new ones will be created.
	 * If an array of colors / sizes will not math the text's number of lines,
	 * the array will be completed with the last read value
	 * @param	myObj
	 */
	public function setCustomVars(myObj:Object, mc:MovieClip)
	{
		refMc = mc;
		parseObject(myObj);
		
		if (obj.myTexts.length != obj.myFonts.length)
		{
			var idx2:Number;
			var initIdx = obj.myFonts.length-1;
			for (idx2 = obj.myFonts.length; idx2 <= obj.myTexts.length; idx2++)
			{ 
				obj.myFonts[idx2] = obj.myFonts[initIdx];
			}
		}
		
		if (obj.myTexts.length != obj.myColors.length)
		{
			if (obj.myColors.length == 0)
			{
				var idx2:Number;
				for (idx2 = 0; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myColors[idx2] = 0x000000;
				}
			}
			else
			{
				var idx2:Number;
				var initIdx = obj.myColors.length-1;
				for (idx2 = obj.myColors.length; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myColors[idx2] = obj.myColors[initIdx];
				}
			}
			
		}
		
		if (obj.myTexts.length != obj.mySizes.length)
		{
			if (obj.mySizes.length == 0)
			{
				var idx2:Number;
				for (idx2 = 0; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.mySizes[idx2] = 12;
				}
			}
			else
			{
				var idx2:Number;
				var initIdx = obj.mySizes.length-1;
				for (idx2 = obj.mySizes.length; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.mySizes[idx2] = obj.mySizes[initIdx];
				}
			}
			
		}
		
		if (obj.myTexts.length != obj.myUnderlines.length)
		{
			if (obj.myUnderlines.length == 0)
			{
				var idx2:Number;
				for (idx2 = 0; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myUnderlines[idx2] = "false";
				}
			}
			else
			{
				var idx2:Number;
				var initIdx = obj.myUnderlines.length-1;
				for (idx2 = obj.myUnderlines.length; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myUnderlines[idx2] = obj.myUnderlines[initIdx];
				}
			}
			
		}
		
		if (obj.myTexts.length != obj.myLengths.length)
		{
			if (obj.myLengths.length == 0)
			{
				var idx2:Number;
				for (idx2 = 0; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myLengths[idx2] = 0;
				}
			}
			else
			{
				var idx2:Number;
				var initIdx = obj.myLengths.length-1;
				for (idx2 = obj.myLengths.length; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myLengths[idx2] = obj.myLengths[initIdx];
				}
			}
			
		}
		
		if (obj.myTexts.length != obj.myVerticalSpaces.length)
		{
			if (obj.myVerticalSpaces.length == 0)
			{
				var idx2:Number;
				for (idx2 = 0; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myVerticalSpaces[idx2] = 0;
				}
			}
			else
			{
				var idx2:Number;
				var initIdx = obj.myVerticalSpaces.length-1;
				for (idx2 = obj.myVerticalSpaces.length; idx2 <= obj.myTexts.length; idx2++)
				{ 
					obj.myVerticalSpaces[idx2] = obj.myVerticalSpaces[initIdx];
				}
			}
			
		}
		
		if (obj.backgroundColor.length < 3)
		{
			if (obj.backgroundColor.length == 1)
			{
				obj.backgroundColor[1] = obj.backgroundColor[2] = obj.backgroundColor[0];
			}
			else
			{
				if (obj.backgroundColor.length == 2)
				{
					obj.backgroundColor[2] = obj.backgroundColor[1];
				}
				else
				{
					if (obj.backgroundColor.length == 0)
					{
						obj.backgroundColor[0] = obj.backgroundColor[1] = obj.backgroundColor[2] = 0xffffff;
					}
				}
			}
		}
		
		
		
		maxTextWidth = 0;
		if (obj.myTexts.length >= 1)
		{
			var idx:Number = 0;
			currentPos = 0;
			Text.createTextField("txt"+idx, Text.getNextHighestDepth(), 0, 0, 0, 25);
			formatMyText(Text["txt"+idx], idx);
			Text["txt"]._y = Math.round(obj.myVerticalSpaces[idx]);
			for (idx = 1; idx < obj.myTexts.length; idx++)
			{
				Text.createTextField("txt"+idx, Text.getNextHighestDepth(), 0, 0, 0, 25);
				formatMyText(Text["txt"+idx], idx);
			}
		}
		
		obj.backgroundWidth += maxTextWidth;
		obj.backgroundHeight += currentPos;
		
		if (obj.image.length != 0)
		{
			if (obj.textXPos != 0)
			{
				
				Text._x = Math.round(obj.textXPos + obj.imageX + obj.imageWidth + obj.imageBackgroundWidth);
			
				obj.backgroundWidth += obj.textXPos + obj.farX;
			}
			else
			{
				
				Text._x = Math.round(obj.backgroundWidth/2 - Text._width/2 + obj.imageWidth + obj.imageBackgroundWidth);
			
			}
			
		}
		else
		{
			if (obj.textXPos != 0)
			{
				Text._x = obj.textXPos;
				obj.backgroundWidth += obj.textXPos + obj.farX;
			}
			else
			{
				Text._x = Math.round(obj.backgroundWidth/2 - Text._width/2);
			}
			
			
		}
		
		
		if (obj.image.length != 0)
		{
			mcl = new MovieClipLoader();
			mcl.addListener(this);
			ImageHolder = this.createEmptyMovieClip("imageHolder", this.getNextHighestDepth());
			
			myImageBg = ImageHolder.createEmptyMovieClip("myImageBg", ImageHolder.getNextHighestDepth());
			myImage = ImageHolder.createEmptyMovieClip("myImage", ImageHolder.getNextHighestDepth());
			
			if (obj.imageBackgroundWidth != 0)
			{
				drawOval(myImageBg, obj.imageWidth + obj.imageBackgroundWidth, obj.imageHeight + obj.imageBackgroundWidth, 0, obj.imageBackgroundColor, obj.imageBackgroundAlpha);
				myImage._x = myImage._y = obj.imageBackgroundWidth / 2;
			}
			
			ImageHolder._x = obj.imageX;
			ImageHolder._y = obj.imageY;
			
			mcl.loadClip(obj.image, myImage);
		}
		
		buildBackground();
		actualBgWidth = bg._width;
		actualBgHeight = bg._height;
		
	}
	
	/**
	 * This function parses the whole object
	 * If the value is available the default one will be overwritten
	 * @param	myObj
	 */
	private function parseObject(myObj:Object)
	{
			with (this) {
			for (var i in myObj) {
				switch(i)
				{
					case "myTexts":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("<new_line>");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myTexts[idx] = fontArr[idx];
						}
						break;
						
					case "myFonts":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myFonts[idx] = String(fontArr[idx]);
						}
						break;
					
					case "myColors":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myColors[idx] = Number(fontArr[idx]);
						}
						break;
					
					case "mySizes":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.mySizes[idx] = Number(fontArr[idx]);
						}
						break;
						
					case "myLengths":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myLengths[idx] = String(fontArr[idx]);
						}
						break;	
					
					case "myUnderlines":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myUnderlines[idx] = String(fontArr[idx]);
						}
						break;	
						
					case "myVerticalSpaces":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < fontArr.length; idx++){
							obj.myVerticalSpaces[idx] = Number(fontArr[idx]);
						}
						break;	
						
						
					case "strokeColor":						
						obj.strokeColor =  Number(myObj[i]);
						break;
						
					case "strokeAlpha":
						obj.strokeAlpha = Number(myObj[i]);
						break;
						
					case "strokeWidth":
						obj.strokeWidth = Number(myObj[i]);
						break;
					
						
					case "backgroundColor":
						var fontStr = myObj[i];
						var fontArr = fontStr.split("|");
						var idx:Number;
						for (idx = 0; idx < 3; idx++){
							obj.backgroundColor[idx] = Number(fontArr[idx]);
						}
						break;
						
					case "backgroundAlpha":
						obj.backgroundAlpha = Number(myObj[i]);
						break;
						
					case "backgroundRadius":
						obj.backgroundRadius = Number(myObj[i]);
						break;
						
					case "backgroundWidth":
						obj.backgroundWidth = Number(myObj[i]);
						break;
						
					case "backgroundHeight":
						obj.backgroundHeight = Number(myObj[i]);
						break;
					
					case "tipWidth":
						obj.tipWidth = Number(myObj[i]);
						break;
						
					case "tipHeight":
						obj.tipHeight = Number(myObj[i]);
						break;
						
					case "tipInclination":
						obj.tipInclination = Number(myObj[i]);
						break;
					
					case "tipX":
						obj.tipX = Number(myObj[i]);
						break;
					
					case "tipOrientation":
						obj.tipOrientation = String(myObj[i]);
						break;
						
					case "tipAutoMove":
						obj.tipAutoMove = String(myObj[i]);
						break;
					
					case "image":
						obj.image = String(myObj[i]);
						break;
					
					case "imageWidth":
						obj.imageWidth = Number(myObj[i]);
						break;
						
					case "imageHeight":
						obj.imageHeight = Number(myObj[i]);
						break;
					
					
					case "imageBackgroundColor":
						obj.imageBackgroundColor = Number(myObj[i]);
						break;
					
					case "imageBackgroundAlpha":
						obj.imageBackgroundAlpha = Number(myObj[i]);
						break;
						
					case "imageBackgroundWidth":
						obj.imageBackgroundWidth = Number(myObj[i]);
						break;
					
					case "imageX":
						obj.imageX = Number(myObj[i]);
						break;
						
					case "imageY":
						obj.imageY = Number(myObj[i]);
						break;
						
						
					case "delay":
						obj.delay = Number(myObj[i]);
						break;
					
					case "animationTime":
						obj.animationTime = Number(myObj[i]);
						break;
						
					case "animationType":
						obj.animationType = String(myObj[i]);
						break;
					
					case "stay":
						obj.stay = String(myObj[i]);
						break;
						
					
					case "XDistanceFromCursor":
						obj.XDistanceFromCursor = Number(myObj[i]);
						break;
					
					case "YDistanceFromCursor":
						obj.YDistanceFromCursor = Number(myObj[i]);
						break;
					
					case "alignHoriz":
						obj.alignHoriz = String(myObj[i]);
						break;
					
					case "alignVerti":
						obj.alignVerti = String(myObj[i]);
						break;
					
					
					case "stageToleranceX":
						obj.stageToleranceX = Number(myObj[i]);
						break;
					
					case "stageToleranceY":
						obj.stageToleranceY = Number(myObj[i]);
						break;
						
						
						
					case "addShadow":
						obj.addShadow = String(myObj[i]);
						break;
					
					case "shadowDistance":
						obj.shadowDistance = Number(myObj[i]);
						break;
						
					case "shadowColor":
						obj.shadowColor = Number(myObj[i]);
						break;
					case "shadowAlpha":
						obj.shadowAlpha = Number(myObj[i]);
						break;
					
					case "shadowBlurX":
						obj.shadowBlurX = Number(myObj[i]);
						break;
						
					case "shadowBlurY":
						obj.shadowBlurY = Number(myObj[i]);
						break;
					case "shadowStrength":
						obj.shadowStrength = Number(myObj[i]);
						break;
					
					case "shadowQuality":
						obj.shadowQuality = Number(myObj[i]);
						break;
						
					case "shadowInner":
						if(String(myObj[i])=="true")
							obj.shadowInner = true;
						break;
						
					case "shadowKnockout":
						if(String(myObj[i])=="true")
							obj.shadowKnockout = true;
						break;
					
					case "shadowHideObject":
						if(String(myObj[i])=="true")
							obj.shadowHideObject = true;
						break;
					
					case "shadowAngleInDegrees":
						obj.shadowAngleInDegrees = Number(myObj[i]);
						break;
					
					case "textXPos":
						obj.textXPos = Number(myObj[i]);
						break;
					
					case "farX":
						obj.farX = Number(myObj[i]);
						break;
					
				}
			}
		}
		
		if ((obj.tipAutoMove == "true")&&(obj.tipOrientation=="bottom"))
		{
			obj.tipInclination = -obj.tipWidth / 2;
		}
		
		if ((obj.tipAutoMove == "true")&&(obj.tipOrientation=="top"))
		{
			obj.tipInclination = -obj.tipWidth / 2;
		}
	}
	
	/**
	 * 	This function draws an gradient oval or square if r=0, radius takes values from 0--360 and it's the gradient's orientation
	 *  Example:
	 *  colors = [0x00ff00, 0xff0000, 0x0000ff];
	 *  alphas = [100, 100, 100];
	 *	ratios = [0, 127.5, 255];
	 * @param	mc
	 * @param	mw
	 * @param	mh
	 * @param	r
	 * @param	colors
	 * @param	alphas
	 * @param	ratios
	 * @param	radius
	 */
	private function drawGradient(mc:MovieClip, mw:Number, mh:Number, r:Number, colors:Array, alphas:Array, ratios:Array, radius:Number) {
		var matrix:Object = { matrixType:"box", x:0, y:0, w:mw, h:mh, r:(radius * Math.PI / 180) };
		mc.clear();
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
		if(obj.strokeWidth!=0)
			mc.lineStyle(obj.strokeWidth, obj.strokeColor, obj.strokeAlpha, true);
		mc.moveTo(r, 0);
		if ((obj.tipWidth != 0)&&(obj.tipOrientation=="top"))
		{
			mc.lineTo(obj.tipX-obj.tipWidth, 0);
			mc.lineTo(obj.tipX-obj.tipWidth - obj.tipInclination, -obj.tipHeight);
			mc.lineTo(obj.tipX, 0);
		}
		mc.lineTo(mw-r,0);
		mc.curveTo(mw,0,mw,r);
		mc.lineTo(mw,mh-r);
		mc.curveTo(mw, mh, mw - r, mh);
		if ((obj.tipWidth != 0)&&(obj.tipOrientation=="bottom"))
		{
			mc.lineTo(obj.tipX, mh);
			mc.lineTo(obj.tipX+obj.tipInclination, mh+obj.tipHeight);
			mc.lineTo(obj.tipX-obj.tipWidth, mh);
		}
		
		mc.lineTo(r,mh);
		mc.curveTo(0,mh,0,mh-r)
		mc.lineTo(0,r);
		mc.curveTo(0,0,r,0);
		mc.endFill();
	}
	
	/**
	 * This function draws an oval or square if r=0
	 * @param	mc
	 * @param	mw
	 * @param	mh
	 * @param	r
	 * @param	fillColor
	 * @param	alphaAmount
	 */
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
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