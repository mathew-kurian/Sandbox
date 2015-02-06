import flash.display.BitmapData;
import oxylus.Utils;
import caurina.transitions.*;
import ascb.util.Proxy;
import mx.events.EventDispatcher;

class oxylus.bannerRotator.slide extends MovieClip 
{
	private var node:XMLNode;
	private var settingsObj:Object;
	public var idx:Number = 0;
	private var loaded:Number = 0;
	
	private var desHeight:Number = 0;
	
	private var swfPresent:Number = 0;
	
	private var loader:MovieClip;
	private var des:MovieClip;
		private var ht:MovieClip;
		private var over:MovieClip;
		
	private var blurMcMask:MovieClip;
	private var blurImg:MovieClip;
	private var img:MovieClip;
	private var mask:MovieClip;
		
	
		
	private var mcl:MovieClipLoader;
	private var bmp:BitmapData;
	
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;

	public function slide() {
		EventDispatcher.initialize(this);
		
		settingsObj = new Object();
		
		img.setMask(mask);
		
		des._visible = false;
		
		ht = des["ht"];
		blurImg.setMask(blurMcMask);
		
		over = des["over"];
		over._alpha = 0;
		
		Utils.initMhtf(ht["txt"], false);
		
		blurImg["white"]._visible = false;
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	/**
	 * this will set the slide's node
	 * @param	n
	 * @param	settingsObj_
	 */
	public function setNode(n:XMLNode, settingsObj_:Object) {
		node = n;
		settingsObj = settingsObj_;
		
		mask._width = settingsObj.totalWidth;
		mask._height = settingsObj.totalHeight;
		
		loader._x = Math.round(settingsObj.totalWidth / 2);
		loader._y = Math.round(settingsObj.totalHeight / 2);
		
		ht["txt"].htmlText = node.firstChild.nodeValue;
		
		var str:String = node.attributes.src;
		var arr:Array = str.split(".");
		if (arr[arr.length - 1] == "swf") {
			swfPresent = 1;
		}
		
			
		ht["txt"]._width = settingsObj.totalWidth - 20;
		
		desHeight = ht._height + 24;
		
		blurImg["white"]._width = mask._width;
		blurImg["white"]._height = desHeight;
		
		blurMcMask._width = over._width = settingsObj.totalWidth;
		blurMcMask._height = over._height = desHeight;
		
		des._y = blurMcMask._y = blurImg["white"]._y = mask._height + 4;

		img.createEmptyMovieClip("a", img.getNextHighestDepth());
		mcl.loadClip(node.attributes.src, img["a"]);
	}
	
	/**
	 * this will execute right after the image / swf has loaded
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		
		if (swfPresent == 0) {
			getImage(mc, true);
			mc._width = settingsObj.totalWidth;
			mc._height = settingsObj.totalHeight;
		}
		else {
		}
		
		Tweener.addTween(img, { _alpha:100, delay:.5, time:0.5, transition:"easeInQuart", onComplete:Proxy.create(this, slideDone) } );
		loader.stop();
		Tweener.addTween(loader, { _xscale: 0, _yscale:0, _alpha:0, delay:.5, time:0.2, transition:"linear", onComplete:Proxy.create(this, invisLoader) } );

		if (swfPresent == 0) {
			blurImg["a"].attachBitmap(bmp, blurImg.getNextHighestDepth(), "auto", true);
			blurImg["a"]._width = settingsObj.totalWidth;
			blurImg["a"]._height = settingsObj.totalHeight;
		}
		else {
			var mcl2:MovieClipLoader = new MovieClipLoader();
			mcl2.loadClip(node.attributes.src, blurImg["a"]);
		}
		
//		Utils.setMcBlur(blurImg, settingsObj.descriptionBlurX, settingsObj.descriptionBlurY, settingsObj.descriptionBlurQuality);
		Utils.setMcBlur(blurImg.a, settingsObj.descriptionBlurX, settingsObj.descriptionBlurY, settingsObj.descriptionBlurQuality);
		
		if (settingsObj.toggleDescription == 1) {
			des._visible = true;
			blurImg._visible = true;
		}
		else {
			des._visible = false;
			blurImg._visible = false;
		}
		
		
		loaded = 1;
		
	}
	
	private function slideDone() {
		dispatchEvent( { target:this, type:"slideDoneAndLoaded", mc:this } );
	
		if (idx == 0) {
			openDes();
		}

	}
	
	/**
	 * this will close the description
	 */
	public function closeDes() {
		if (loaded == 1) {
			Tweener.addTween(blurImg["white"], { _y: mask._height+6, delay:.2, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
			Tweener.addTween(blurMcMask, { _y: mask._height+6, delay:.2, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
			Tweener.addTween(des, { _y: mask._height+6, delay:.2, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
		}
	}
	
	/**
	 * this will show the description
	 */
	public function openDes() {
		if (loaded == 1) {
			Tweener.addTween(blurImg["white"], { _y:mask._height - desHeight + 10, delay:.5, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
			Tweener.addTween(blurMcMask, { _y:mask._height - desHeight + 10, delay:.5, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
			Tweener.addTween(des, { _y:mask._height - desHeight + 10, delay:.5, time:settingsObj.slideAnimationTime, transition:settingsObj.slideAnimationType } );
		}
	}
	
	private function onRollOver() {
		if (loaded == 1) {
			dispatchEvent( { target:this, type:"slideOver", mc:this } );
			Tweener.addTween(over, { _alpha:100, time:0.3, transition:"linear" } );
		}
	}
	
	private function onRollOut() {
		if (loaded == 1) {
			dispatchEvent( { target:this, type:"slideOut", mc:this } );
			Tweener.addTween(over, { _alpha:0, time:0.3, transition:"linear" } );
		}
	}
	
	/**
	 * actions for pressing one image
	 */
	private function onPress() {
		
		// replaced getURL with your instructions like gotoAndStop, gotoAndPlay -- to play a certain frame or label
		getURL(node.attributes.url, node.attributes.target);
		
		if (loaded == 1) {
			onRollOut();
		}
	}
	
	private function getImage(mc:MovieClip, smooth:Boolean) {
		smooth == undefined ? smooth = true : null;
		
		var mcDepth:Number 		= mc.getDepth();
		var mcName:String 		= mc._name;
		var mcParent:MovieClip 	= mc._parent;
		var mcAlpha:Number 		= mc._alpha;
		var mcVisible:Boolean 	= mc._visible;
		
		mc._xscale = 100;
		mc._yscale = 100;
		
		bmp = new BitmapData(mc._width, mc._height, true, 0);
		bmp.draw(mc);
		
		mc.removeMovieClip();
		
		var newMc:MovieClip = mcParent.createEmptyMovieClip(mcName, mcDepth);
		newMc.attachBitmap(bmp, newMc.getNextHighestDepth(), "auto", smooth);
		
		newMc._alpha 	= mcAlpha;
		newMc._visible 	= mcVisible;
		
		return newMc;
	}
	
	private function invisLoader() {
		Tweener.removeTweens(loader);
		loader._visible = false;
		loader.removeMovieClip();
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