import oxylus.Utils;
import caurina.transitions.Tweener;
class oxylus.apc.Controller3 extends MovieClip {
	// reference variables
	private var Bg:MovieClip;
	private var Sldr:MovieClip;
	private var Up:MovieClip;
	private var Dn:MovieClip;
	private var STrk:MovieClip;
	private var SBtn:MovieClip;
	private var STip:MovieClip;
	private var TipTxt:TextField;
	// other vars
	// slider height
	private var sh:Number;
	// relative percent
	private var p:Number;
	// min/max zoom
	private var minz:Number;
	private var maxz:Number;
	// set to true if button is dragged
	private var mouseDrag:Boolean = false;
	public function Controller3() {
		// assign instances
		Bg = this["mc0"];
		Sldr = this["mc1"];
		Up = this["mc2"];
		Dn = this["mc3"];
		STrk = Sldr["mc0"];
		SBtn = Sldr["mc1"];
		STip = Sldr["mc2"];
		TipTxt = STip["mc0"];
		// setup movie clips
		// drag / drop
		Bg.stop();
		Bg.onPress = Utils.delegate(this, dragSBtn);
		Bg.onRelease = Utils.delegate(this, dropSBtn);
		Bg.onRollOver = Utils.delegate(this, showTip);
		Bg.onRollOut = Utils.delegate(this, hideTip);
		Bg.onReleaseOutside = Utils.delegate(this, BgReleaseOutside);
		// up down buttons
		Up.onPress = Utils.delegate(this, slideUp);
		Dn.onPress = Utils.delegate(this, slideDn);
		Up.onRelease = Up.onReleaseOutside=Utils.delegate(this, stopSlide);
		Dn.onRelease = Dn.onReleaseOutside=Utils.delegate(this, stopSlide);
		// tip
		STip._alpha = 0;
		TipTxt.autoSize = "center";
		STip.stop();
		// init vars
		sh = STrk._height;
	}
	// set zoom limits (min/max zoom)
	public function setLimits(lower:Number, higher:Number) {
		minz = lower;
		maxz = higher;
	}
	// start button drag
	private function dragSBtn() {
		mouseDrag = true;
		moveSBtn();
		onMouseMove = moveSBtn;
	}
	// stop drag
	private function dropSBtn() {
		delete onMouseMove;
		mouseDrag = false;
	}
	// move button
	private function moveSBtn() {
		var sy:Number = Sldr._ymouse;
		sy<0 ? sy=0 : (sy>sh ? sy=sh : null);
		var np:Number = Utils.truncNr(1-sy/sh);
		// update percent
		if (np != p) {
			p = np;
			SBtn._y = sy;
			updateTipPos();
			// zoom parent
			_parent.zoomTo(p, true, true);
		}
	}
	// slide buttons
	private function stopSlide() {
		delete onEnterFrame;
	}
	private function slideUp() {
		onEnterFrame = Utils.delegate(this, moveBy, -1);
	}
	private function slideDn() {
		onEnterFrame = Utils.delegate(this, moveBy, 1);
	}
	private function moveBy(step:Number) {
		var sy:Number = SBtn._y+step;
		if (sy<0 || sy>sh) {
			stopSlide();
		} else {
			p = Utils.truncNr(1-sy/sh);
			SBtn._y = sy;
			updateTipPos();
			_parent.zoomTo(p, true, true);
		}
	}
	// show tip
	private function tipToRight() {
		if (STip._currentframe == 2) {
			return;
		}
		STip.gotoAndStop(2);
		STip._x = width+1+STip._width;
	}
	private function showTip() {
		Utils.mcPlay(Bg, 0);
		Tweener.addTween(STip, {_alpha:100, time:.3, transition:"easeoutquad"});
	}
	// hide tip
	private function hideTip() {
		Utils.mcPlay(Bg, 1);
		Tweener.addTween(STip, {_alpha:0, time:.3, transition:"easeoutquad"});
	}
	// Bg release outside
	private function BgReleaseOutside() {
		dropSBtn();
		hideTip();
	}
	// set percent
	public function set percent(np:Number) {
		p = Utils.truncNr((np-minz)/(maxz-minz));
		if (!mouseDrag) {
			// update button position
			var sy:Number = Math.round(sh*(1-p));
			Tweener.addTween(SBtn, {_y:sy, time:.3, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateTipPos)});
		}
	}
	private function updateTipPos() {
		STip._y = SBtn._y;
		var ap:Number = minz+(maxz-minz)*p;
		TipTxt.text = String(Math.round(ap*100))+"%";
	}
	//
	public function get width() {
		return Bg._width;
	}
	public function get height() {
		return this._height;
	}
}
