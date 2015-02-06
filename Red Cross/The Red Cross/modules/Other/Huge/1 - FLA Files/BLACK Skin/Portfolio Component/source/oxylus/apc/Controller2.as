import oxylus.Utils;
import caurina.transitions.Tweener;
class oxylus.apc.Controller2 extends MovieClip {
	// reference variables
	private var Bg:MovieClip;
	private var Up:MovieClip;
	private var Dn:MovieClip;
	private var Lft:MovieClip;
	private var Rgt:MovieClip;
	private var Pls:MovieClip;
	private var Mns:MovieClip;
	private var Sldr:MovieClip;
	private var STrk:MovieClip;
	private var SBtn:MovieClip;
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
	public function Controller2() {
		// assign instances
		Bg = this["mc0"];
		Up = this["mc1"];
		Dn = this["mc2"];
		Rgt = this["mc3"];
		Lft = this["mc4"];
		Pls = this["mc5"];
		Mns = this["mc6"];
		Sldr = this["mc7"];
		STrk = Sldr["mc0"];
		SBtn = Sldr["mc1"];
		// setup movie clips
		// bg
		Bg.useHandCursor = false;
		Bg.onPress = null;
		// drag / drop
		STrk.onPress = Utils.delegate(this, dragSBtn);
		STrk.onRelease = Utils.delegate(this, dropSBtn);
		STrk.onReleaseOutside = STrk.onRelease;
		// up down buttons
		Pls.onPress = Utils.delegate(this, slideUp);
		Mns.onPress = Utils.delegate(this, slideDn);
		Pls.onRelease = Pls["_onReleaseOutside"]=Utils.delegate(this, stopSlide);
		Mns.onRelease = Mns["_onReleaseOutside"]=Utils.delegate(this, stopSlide);
		//nudge
		Up.onPress = Utils.delegate(_parent, _parent["nudgeUp"]);
		Dn.onPress = Utils.delegate(_parent, _parent["nudgeDown"]);
		Lft.onPress = Utils.delegate(_parent, _parent["nudgeLeft"]);
		Rgt.onPress = Utils.delegate(_parent, _parent["nudgeRight"]);
		Up.onRelease = Up.onReleaseOutside=Utils.delegate(_parent, _parent["stopNudge"]);
		Dn.onRelease = Dn.onReleaseOutside=Utils.delegate(_parent, _parent["stopNudge"]);
		Lft.onRelease = Lft.onReleaseOutside=Utils.delegate(_parent, _parent["stopNudge"]);
		Rgt.onRelease = Rgt.onReleaseOutside=Utils.delegate(_parent, _parent["stopNudge"]);
		// init vars
		sh = STrk._height;
	}
	public function bgToRight(){
		Bg._xscale = -100;
		Bg._x = Bg._width;
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
			_parent.zoomTo(p, true, true);
		}
	}
	// set percent
	public function set percent(np:Number) {
		p = Utils.truncNr((np-minz)/(maxz-minz));
		if (!mouseDrag) {
			// update button position
			var sy:Number = Math.round(sh*(1-p));
			Tweener.addTween(SBtn, {_y:sy, time:.3, transition:"easeoutquad"});
		}
	}
	//
	public function get width() {
		return Bg._width;
	}
	public function get height() {
		return Bg._height;
	}
}
