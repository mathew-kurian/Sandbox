import oxylus.Utils;
import mx.events.EventDispatcher;
import caurina.transitions.*;
import flash.filters.GlowFilter;
import ascb.util.Proxy;

class oxylus.template.portfolio.thumb extends MovieClip
{
	public var node:XMLNode;
	private var settings:Object;
	private var mcl:MovieClipLoader;
	
	private var title:MovieClip;
	private var holder:MovieClip;
	private var img:MovieClip;
	private var first:MovieClip;
	private var second:MovieClip;
	private var third:MovieClip;
	
	private var hit:MovieClip;
	
	private var loader:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var url:String;
	public var urlTitle:String;
	
	public function thumb() {
		EventDispatcher.initialize(this);
		this._alpha = 0;
		
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
	 * this will be accesed remotely and it will load the picture
	 */
	public function loadPic() {
		mcl.loadClip(node.attributes.src, img);
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 * @param	settings_
	 */
	public function setNode(n:XMLNode, settings_:Object) {
		settings = new Object();
		node = n;
		settings = settings_;
		
		url = String(node.parentNode.previousSibling.attributes.url + node.attributes.url);
		urlTitle = String(node.parentNode.previousSibling.attributes.urlTitle + " - " + node.attributes.urlTitle);
		
		
		drawOval(first["normal"]["a"], settings.thumbWidth + 2, 1, 0, 0x808080, 100);
		drawOval(first["normal"]["b"], settings.thumbWidth + 2, 1, 0, 0x808080, 100);
		drawOval(first["normal"]["c"], 1, settings.thumbHeight, 0, 0x808080, 100);
		drawOval(first["normal"]["d"], 1, settings.thumbHeight, 0, 0x808080, 100);
		first["normal"]["c"]._y = first["normal"]["d"]._y = 1;
		first["normal"]["d"]._x = settings.thumbWidth + 1;
		first["normal"]["b"]._y = first["normal"]["c"]._height+1;
		first["normal"]["b"]._x = 0;
		
		
		drawOval(first["over"]["a"], settings.thumbWidth + 2, 1, 0, 0x7f7f7f, 100);
		drawOval(first["over"]["b"], settings.thumbWidth + 2, 1, 0, 0x7f7f7f, 100);
		drawOval(first["over"]["c"], 1, settings.thumbHeight, 0, 0x7f7f7f, 100);
		drawOval(first["over"]["d"], 1, settings.thumbHeight, 0, 0x7f7f7f, 100);
		first["over"]["c"]._y = first["over"]["d"]._y = 1;
		first["over"]["d"]._x = settings.thumbWidth + 1;
		first["over"]["b"]._y = first["over"]["c"]._height+1;
		first["over"]["b"]._x = 0;
		

		drawOval(second["normal"]["a"], settings.thumbWidth + 2 + 10, 41, 0, 0x000000, 70);
		drawOval(second["normal"]["b"], settings.thumbWidth + 2 + 10, 7, 0, 0x000000, 70);
		drawOval(second["normal"]["c"], 5, settings.thumbHeight + 2, 0, 0x000000, 70);
		drawOval(second["normal"]["d"], 5, settings.thumbHeight + 2, 0, 0x000000, 70);
		second["normal"]["b"]._y = settings.thumbHeight + 2 + 41;
		second["normal"]["c"]._y = 41;
		second["normal"]["d"]._y = 41;
		second["normal"]["d"]._x = second["normal"]["b"]._width - second["normal"]["d"]._width;
		
		drawOval(second["over"]["a"], settings.thumbWidth + 2 + 10, 41, 0, 0xffffff, 100);
		drawOval(second["over"]["b"], settings.thumbWidth + 2 + 10, 7, 0, 0xffffff, 100);
		drawOval(second["over"]["c"], 5, settings.thumbHeight + 2, 0, 0xffffff, 100);
		drawOval(second["over"]["d"], 5, settings.thumbHeight + 2, 0, 0xffffff, 100);
		second["over"]["b"]._y = settings.thumbHeight + 2 + 41;
		second["over"]["c"]._y = 41;
		second["over"]["d"]._y = 41;
		second["over"]["d"]._x = second["over"]["b"]._width - second["over"]["d"]._width;
		
		
		
		drawOval(third["normal"]["a"], second["normal"]["a"]._width + 2, 1, 0, 0xffffff, 16);
		drawOval(third["normal"]["b"], second["normal"]["a"]._width + 2, 1, 0, 0xffffff, 16);
		drawOval(third["normal"]["c"], 1, settings.thumbHeight + 2 + 42 + 6, 0, 0xffffff, 16);
		drawOval(third["normal"]["d"], 1, settings.thumbHeight + 2 + 42 + 6, 0, 0xffffff, 16);
		third["normal"]["c"]._y = third["normal"]["d"]._y = 1;
		third["normal"]["d"]._x = third["normal"]["a"]._width - third["normal"]["d"]._width;
		third["normal"]["b"]._y = third["normal"]["c"]._height+1;
		
		first._x = 6
		first._y = 42;
		second._x = second._y = 1;
		third._x = third._y = 0;
		
		title["normal"]["txt"].text = title["over"]["txt"].text = node.attributes.title;
		title._y = 6;
		title._x = 7;
		
		
		loader._x = 7;
		loader._y = 43;
		
		loader["bg"]._width = settings.thumbWidth;
		loader["bg"]._height = settings.thumbHeight;
		
		loader["spin"]._x = Math.round(settings.thumbWidth / 2);
		loader["spin"]._y = Math.round(settings.thumbHeight / 2);
		
		hit = this.createEmptyMovieClip("hit", this.getNextHighestDepth());
		
		drawOval(hit, this._width, this._height, 0, 0x000000, 0);
		
		Tweener.addTween(this, { _alpha:100, time: .3, transition: "easeOutQuad" } );
	}
	
	/**
	 * launched when the image starts loading
	 * @param	mc
	 */
	private function onLoadStart(mc:MovieClip) {
		Tweener.addTween(loader, { _xscale: 100, _yscale:100, _alpha:100, time:0.2, transition:"linear" } );
	}
	
	/**
	 * launched when the image finished loading
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		Utils.getImage(mc, true);
		
		mc._width = settings.thumbWidth;
		mc._height = settings.thumbHeight;
	
		mc._x = 7
		mc._y = 43;
		img._alpha = 0;
		
		Tweener.addTween(img, { _alpha:50, time: settings.fadeInAnimationTime, transition: "linear" } );
		
		Tweener.addTween(loader, { _alpha:0, time: .5, transition: "easeOutQuad", onComplete: Proxy.create(this, stopSpin)} );
		
		dispatchEvent( { target:this, type:"thumbLoaded" } );
	}
	
	/**
	 * this will stop the spinning on the loader
	 */
	private function stopSpin() {
		loader["spin"].stop();
		loader._visible = false;
		loader.removeMovieClip();
	}

	/**
	 * actions for rolling over one thumbnail
	 */
	private function onRollOver() {
		Tweener.addTween(img, { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(first["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(second["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(third, { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(title["over"], { _alpha:100, time: .3, transition: "easeOutQuad" } )
	}
	
	/**
	 * actions for rolling out of one thumbnail
	 */
	private function onRollOut() {
		Tweener.addTween(img, { _alpha:50, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(first["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(second["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(third, { _alpha:100, time: .3, transition: "easeOutQuad" } );
		Tweener.addTween(title["over"], { _alpha:0, time: .3, transition: "easeOutQuad" } )
	}
	
	/**
	 * actions for pressing one thumbnail
	 */
	private function onRelease() {
		SWFAddress.setValue(url);
		
	}
	
	public function dispatchThisMC() {		
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"thumbClicked", thumb:this } );
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