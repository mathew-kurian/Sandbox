import caurina.transitions.*;
import mx.events.EventDispatcher;
import ascb.util.Proxy;
import oxylus.Utils;

class oxylus.template.gallery.thumb extends MovieClip 
{
	public var node:XMLNode;
	private var settings:Object;
	public var idx:Number;
	
	private var ref:MovieClip;
	
	private var loaded:Number = 0;
	private var icon:MovieClip;
	private var image:MovieClip;
	private var stroke:MovieClip;
	private var over:MovieClip;
	private var loader:MovieClip;
	
	private var mcl:MovieClipLoader;
	
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function thumb() {
		EventDispatcher.initialize(this);
		
		this.enabled = false;
		
		icon._visible = false;
		
		settings = new Object();
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object) {
		node = n;
		settings = settings_;
		
		ref._width = settings.thumbWidth + 10;
		ref._height = settings.thumbHeight + 10;
		
		loader._x = Math.round(ref._width / 2);
		loader._y = Math.round(ref._height / 2);
		
		mcl.loadClip(node.attributes.thumb, image);
	}
	
	private function onLoadStart(mc:MovieClip){
		Tweener.addTween(loader, { _alpha:100, time:0.2, transition:"linear"} );
	}
	
	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
		
	}
	
	private function onLoadComplete(mc:MovieClip){
		
	}
	
	/**
	 * actions launched when the image finished loading
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		Utils.getImage(mc, true);
		
		mc._width = loader._width - 2;
		mc._height = loader._height - 2;
		mc._x = loader._x + 1;
		mc._y = loader._y + 1;
		
		Tweener.addTween(mc, { _alpha:100, _height:settings.thumbHeight, _width:settings.thumbWidth, _x:5, _y:5, time:0.5, transition:"easeOutQuart", 
						onUpdate:Proxy.create(this, updateStroke, mc), onComplete:Proxy.create(this, thisLoaded) } );
		Tweener.addTween(loader, { _alpha:0, delay:.3, time: .5, transition: "easeOutQuad", onComplete: Proxy.create(this, stopSpin)} );
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
	}
	
	/**
	 * this will cancel the loader
	 */
	private function stopSpin() {
		loader["spin"].stop();
		loader.removeMovieClip();
		
		var str:String = node.attributes.image;
		
		var arr:Array = str.split(".");
		
		if (arr[arr.length - 1] == "flv") {
			icon._x = Math.round(settings.thumbWidth / 2 - icon._width / 2);
			icon._y = Math.round(settings.thumbHeight / 2 - icon._height / 2);
			
			icon._x += 5;
			icon._y += 5;
			
			icon._visible = true;
		}
		
	}
	
	private function thisLoaded() {
		loaded = 1;
		this.enabled = true;
	}
	
	private function updateStroke(mc:MovieClip) {
		stroke._x = mc._x - 5;
		stroke._y = mc._y - 5;
		
		stroke._width = mc._width + 10;
		stroke._height = mc._height + 10;
		
		stroke._alpha = mc._alpha;
		
		over._width = mc._width + 8;
		over._height = mc._height + 8;
	}
	
	private function onLoadError(pMc:MovieClip, errorCode:String, httpStatus:Number) {
		trace(">> errorCode: " + errorCode);
		trace(">> httpStatus: " + httpStatus);
		this._visible = false;
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
	}
		
	private function onRollOver() {
		if (loaded == 1) {
			Tweener.addTween(over, { _alpha:100, time:0.3, transition:"easeOutQuad" } );
			Tweener.addTween(stroke["nWhite"], { _alpha:0, time:0.3, transition:"easeOutQuad" } );
		}
	}
	
	private function onRollOut() {
		if (loaded == 1) {
			Tweener.addTween(over, { _alpha:0, time:0.3, transition:"easeOutQuad" } );
			Tweener.addTween(stroke["nWhite"], { _alpha:100, time:0.3, transition:"easeOutQuad" } );
		}
	}
	
	public function onRelease() {
		onRollOut();
		SWFAddress.setValue(node.parentNode.parentNode.attributes.url + node.parentNode.attributes.url + node.attributes.url);
	}
	
	public function dispatchThisMC() {
		SWFAddress.setTitle(node.parentNode.parentNode.attributes.urlTitle + " - " + node.parentNode.attributes.urlTitle + " - " + node.attributes.urlTitle);
		dispatchEvent( { target:this, type:"thumbReleased", mc:this } );
	}
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number, line:Number) {
		
		//this function draws an ovel or a sqare if the radius will be 0
		mc.clear();
		mc.beginFill(fillColor, alphaAmount);
		if(line==1)
			mc.lineStyle(1, 0xffffff, alphaAmount, true);
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