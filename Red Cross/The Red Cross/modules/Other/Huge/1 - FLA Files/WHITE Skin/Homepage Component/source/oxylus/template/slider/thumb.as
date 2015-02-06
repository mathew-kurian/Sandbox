import oxylus.Utils;
import mx.events.EventDispatcher;
import caurina.transitions.*;
import flash.filters.GlowFilter;
import ascb.util.Proxy;

class oxylus.template.slider.thumb extends MovieClip
{
	public var node:XMLNode;
	private var settings:Object;
	private var mcl:MovieClipLoader;
	
	private var loader:MovieClip;
	
	private var title:MovieClip;
	private var holder:MovieClip;
	private var img:MovieClip;
	private var first:MovieClip;
	private var second:MovieClip;
	private var third:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	
	public var idx:Number;
	private var mainU:String;
	private var mainT:String;
	
	public function thumb() {
		EventDispatcher.initialize(this);
	
		title = this["title"];
		title["normal"]["txt"].autoSize = true;
		title["normal"]["txt"].wordWrap = false;
		title["normal"]["txt"].selctable = false;
		title["normal"]["txt"]._x = -3;
		
		title["over"]["txt"].autoSize = true;
		title["over"]["txt"].wordWrap = false;
		title["over"]["txt"].selctable = false;
		title["over"]["txt"]._x = -3;
		title["over"]._alpha = 0;
		
		holder = this["holder"];
		
		first = holder.createEmptyMovieClip("first", holder.getNextHighestDepth());
		
		first.createEmptyMovieClip("normal", first.getNextHighestDepth());
		first["normal"].createEmptyMovieClip("a", first["normal"].getNextHighestDepth());
		first["normal"].createEmptyMovieClip("b", first["normal"].getNextHighestDepth());
		first["normal"].createEmptyMovieClip("c", first["normal"].getNextHighestDepth());
		first["normal"].createEmptyMovieClip("d", first["normal"].getNextHighestDepth());
		
		first.createEmptyMovieClip("over", first.getNextHighestDepth()); first["over"]._alpha = 0;
		first["over"].createEmptyMovieClip("a", first["over"].getNextHighestDepth());
		first["over"].createEmptyMovieClip("b", first["over"].getNextHighestDepth());
		first["over"].createEmptyMovieClip("c", first["over"].getNextHighestDepth());
		first["over"].createEmptyMovieClip("d", first["over"].getNextHighestDepth());
		
		
		second = holder.createEmptyMovieClip("second", holder.getNextHighestDepth());
		
		second.createEmptyMovieClip("normal", second.getNextHighestDepth());
		second["normal"].createEmptyMovieClip("a", second["normal"].getNextHighestDepth());
		second["normal"].createEmptyMovieClip("b", second["normal"].getNextHighestDepth());
		second["normal"].createEmptyMovieClip("c", second["normal"].getNextHighestDepth());
		second["normal"].createEmptyMovieClip("d", second["normal"].getNextHighestDepth());
		
		second.createEmptyMovieClip("over", second.getNextHighestDepth()); second["over"]._alpha = 0;
		second["over"].createEmptyMovieClip("a", second["over"].getNextHighestDepth());
		second["over"].createEmptyMovieClip("b", second["over"].getNextHighestDepth());
		second["over"].createEmptyMovieClip("c", second["over"].getNextHighestDepth());
		second["over"].createEmptyMovieClip("d", second["over"].getNextHighestDepth());
		
		
		third = holder.createEmptyMovieClip("third", holder.getNextHighestDepth());
		
		third.createEmptyMovieClip("normal", third.getNextHighestDepth());
		third["normal"].createEmptyMovieClip("a", third["normal"].getNextHighestDepth());
		third["normal"].createEmptyMovieClip("b", third["normal"].getNextHighestDepth());
		third["normal"].createEmptyMovieClip("c", third["normal"].getNextHighestDepth());
		third["normal"].createEmptyMovieClip("d", third["normal"].getNextHighestDepth());
		
		
		img = holder.createEmptyMovieClip("img", holder.getNextHighestDepth());
		img._alpha = 0;
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	/**
	 * this will be remotely called to load the image
	 */
	public function loadPic() {
		mcl.loadClip(node.attributes.src, img);
	}
	
	/**
	 * this will setup the xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object, pMainU:String, pMainT:String ) {
		settings = new Object();
		node = n;
		settings = settings_;
		
		mainU = pMainU;
		mainT = pMainT;
		
		
		drawOval(first["normal"]["a"], settings.thumbWidth + 2, 1, 0, 0x989898, 100);
		drawOval(first["normal"]["b"], settings.thumbWidth + 2, 1, 0, 0x989898, 100);
		drawOval(first["normal"]["c"], 1, settings.thumbHeight, 0, 0x989898, 100);
		drawOval(first["normal"]["d"], 1, settings.thumbHeight, 0, 0x989898, 100);
		first["normal"]["c"]._y = first["normal"]["d"]._y = 1;
		first["normal"]["d"]._x = settings.thumbWidth + 1;
		first["normal"]["b"]._y = first["normal"]["c"]._height+1;
		first["normal"]["b"]._x = 0;
		
		
		drawOval(first["over"]["a"], settings.thumbWidth + 2, 1, 0, 0xcacaca, 100);
		drawOval(first["over"]["b"], settings.thumbWidth + 2, 1, 0, 0xcacaca, 100);
		drawOval(first["over"]["c"], 1, settings.thumbHeight, 0, 0xcacaca, 100);
		drawOval(first["over"]["d"], 1, settings.thumbHeight, 0, 0xcacaca, 100);
		first["over"]["c"]._y = first["over"]["d"]._y = 1;
		first["over"]["d"]._x = settings.thumbWidth + 1;
		first["over"]["b"]._y = first["over"]["c"]._height+1;
		first["over"]["b"]._x = 0;
		
		
		drawOval(second["normal"]["a"], settings.thumbWidth + 2 + 10, 5, 0, 0xffffff, 70);
		drawOval(second["normal"]["b"], settings.thumbWidth + 2 + 10, 29, 0, 0xffffff, 70);
		drawOval(second["normal"]["c"], 5, settings.thumbHeight + 2, 0, 0xffffff, 70);
		drawOval(second["normal"]["d"], 5, settings.thumbHeight + 2, 0, 0xffffff, 70);
		second["normal"]["b"]._y = settings.thumbHeight + 2 + 5;
		second["normal"]["c"]._y = 5;
		second["normal"]["d"]._y = 5;
		second["normal"]["d"]._x = second["normal"]["b"]._width - second["normal"]["d"]._width;
		
		drawOval(second["over"]["a"], settings.thumbWidth + 2 + 10, 5, 0, 0x000000, 100);
		drawOval(second["over"]["b"], settings.thumbWidth + 2 + 10, 29, 0, 0x000000, 100);
		drawOval(second["over"]["c"], 5, settings.thumbHeight + 2, 0, 0x000000, 100);
		drawOval(second["over"]["d"], 5, settings.thumbHeight + 2, 0, 0x000000, 100);
		second["over"]["b"]._y = settings.thumbHeight + 2 + 5;
		second["over"]["c"]._y = 5;
		second["over"]["d"]._y = 5;
		second["over"]["d"]._x = second["over"]["b"]._width - second["over"]["d"]._width;
		
		
		
		drawOval(third["normal"]["a"], second["normal"]["a"]._width + 2, 1, 0, 0xdfdfdf, 70);
		drawOval(third["normal"]["b"], second["normal"]["a"]._width + 2, 1, 0, 0xdfdfdf, 70);
		drawOval(third["normal"]["c"], 1, settings.thumbHeight + 2 + 5 + 29, 0, 0xdfdfdf, 70);
		drawOval(third["normal"]["d"], 1, settings.thumbHeight + 2 + 5 + 29, 0, 0xdfdfdf, 70);
		third["normal"]["c"]._y = third["normal"]["d"]._y = 1;
		third["normal"]["d"]._x = third["normal"]["a"]._width - third["normal"]["d"]._width;
		third["normal"]["b"]._y = third["normal"]["c"]._height+1;
	
		
		first._x = first._y = 6;
		second._x = second._y = 1;
		third._x = third._y = 0;
		
		title["normal"]["txt"].text = title["over"]["txt"].text = node.attributes.title;
		title._y = Math.round(settings.thumbHeight + 10 + 2);
		title._x = 7;
		
		loader["bg"]._width = settings.thumbWidth;
		loader["bg"]._height = settings.thumbHeight;
		
		loader["spin"]._x = Math.round(settings.thumbWidth / 2);
		loader["spin"]._y = Math.round(settings.thumbHeight / 2);
		
		Tweener.addTween(this, { _alpha:100, time: .3, transition: "easeOutQuad" } );
	}
	
	/**
	 * this will execute after the image finished loading
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		Utils.getImage(mc, true);
		
		mc._width = settings.thumbWidth;
		mc._height = settings.thumbHeight;
	
		mc._x = mc._y = 7;
		Tweener.addTween(img, { _alpha:100, time: 1, transition: "linear" } );
		Tweener.addTween(loader, { _alpha:0, time: .5, transition: "easeOutQuad", onComplete: Proxy.create(this, stopSpin)} );
		
		dispatchEvent( { target:this, type:"thumbLoaded" } );
	}
	
	/**
	 * this will stop the spinning on the loaded
	 */
	private function stopSpin() {
		loader["spin"].stop();
		loader.removeMovieClip();
	}
	
	/**
	 * actions for rolling over one thumb
	 */
	private function onRollOver() {
		//Tweener.addTween(img, { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(first["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(second["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(third, { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(title["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } )
	}
	
	/**
	 * actions for rolling out of one thumb
	 */
	private function onRollOut() {
		//Tweener.addTween(img, { _alpha:50, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(first["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(second["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(third, { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(title["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } )
	}
	
	public function dispatchThisMC() {
		dispatchEvent( { target:this, type:"thumbPressed", mc:this } );
		SWFAddress.setTitle(mainT + " - " + node.attributes.urlTitle);
	}
	/**
	 * actions for pressing one thumb
	 */
	public function onPress() {
		onRollOut();
		
		if (node.attributes.toggleLaunchPopup != 1) {
			getURL(node.attributes.url, node.attributes.target);	
		}
		else {
			SWFAddress.setValue(mainU + node.attributes.url);
		}
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