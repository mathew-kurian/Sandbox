import oxylus.Utils;
import caurina.transitions.Tweener;
class oxylus.apc.Controller1 extends MovieClip {
	// reference variables
	private var Bg:MovieClip;
	private var Sldr:MovieClip;
	private var Up:MovieClip;
	private var Dn:MovieClip;
	private var Lft:MovieClip;
	private var Rgt:MovieClip;
	private var Txt:TextField;
	private var Pls:MovieClip;
	private var Mns:MovieClip;
	private var SHit:MovieClip;
	private var SBg:MovieClip;
	private var SInd:MovieClip;
	private var SMsk:MovieClip;
	private var SArw:MovieClip;
	private var ZRes:MovieClip;
	// other vars
	// slider width
	private var sw:Number;
	// relative percent
	private var p:Number;
	// min/max zoom
	private var minz:Number;
	private var maxz:Number;
	// set to true if button is dragged
	private var mouseDrag:Boolean = false;
	public function Controller1() {
		// assign instances
		Bg = this["mc0"];
		Sldr = this["mc1"];
		Up = this["mc2"];
		Rgt = this["mc3"];
		Dn = this["mc4"];
		Lft = this["mc5"];
		Txt = this["mc6"];
		Mns = this["mc7"];
		Pls = this["mc8"];
		ZRes = this["mc9"];
		SHit = Sldr["mc0"];
		SBg = Sldr["mc1"];
		SInd = Sldr["mc2"];
		SMsk = Sldr["mc3"];
		SArw = Sldr["mc4"];
		// setup movie clips
		// set bg
		Bg.onPress = null;
		Bg.useHandCursor = false;
		// drag 
		Sldr.onRollOver = Utils.delegate(this, SldrOvr);
		Sldr.onRollOut = Utils.delegate(this, SldrOut);
		Sldr.onPress = Utils.delegate(this, startProg);
		Sldr.onRelease = Utils.delegate(this, stopProg);
		Sldr.onReleaseOutside = Utils.delegate(this, SldrOutside);
		// up down buttons
		Pls.onPress = Utils.delegate(this, sPlus);
		Mns.onPress = Utils.delegate(this, sMinus);
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
		// zoom reset
		ZRes.onRelease = Utils.delegate(_parent, _parent["resetZoom"]);
		// slider
		Sldr.setMask(SMsk);
		Sldr.hitArea = SHit;
		SHit._alpha = 0;
		SInd.stop();
		// init vars
		sw = SHit._width;
	}
	// set zoom limits (min/max zoom)
	public function setLimits(lower:Number, higher:Number) {
		minz = lower;
		maxz = higher;
	}
	// Indicator states
	private function SldrOvr() {
		Utils.mcPlay(SInd, 0);
	}
	private function SldrOut() {
		Utils.mcPlay(SInd, 1);
	}
	private function SldrOutside() {
		SldrOut();
		stopProg();
	}
	// start button drag
	private function startProg() {
		mouseDrag = true;
		updateProg();
		onMouseMove = updateProg;
	}
	// stop drag
	private function stopProg() {
		delete onMouseMove;
		mouseDrag = false;
	}
	// move button
	private function updateProg() {
		var pw:Number = Sldr._xmouse;
		pw<0 ? pw=0 : (pw>sw ? pw=sw : null);
		var np:Number = Utils.truncNr(pw/sw);
		// update percent
		if (np != p) {
			p = np;
			SInd._width = pw;
			SArw._x = pw;
			// zoom parent
			updateTxt();
			_parent.zoomTo(p, true, true);
		}
	}
	// slide buttons
	private function stopSlide() {
		delete onEnterFrame;
	}
	private function sMinus() {
		onEnterFrame = Utils.delegate(this, moveBy, -1);
	}
	private function sPlus() {
		onEnterFrame = Utils.delegate(this, moveBy, 1);
	}
	private function moveBy(step:Number) {
		var pw:Number = SInd._width+step;
		if (pw<0 || pw>sw) {
			stopSlide();
		} else {
			p = Utils.truncNr(pw/sw);
			SInd._width = pw;
			SArw._x = pw;
			updateTxt();
			_parent.zoomTo(p, true, true);
		}
	}
	// set percent
	public function set percent(np:Number) {
		p = Utils.truncNr((np-minz)/(maxz-minz));
		if (!mouseDrag) {
			// update button position
			var pw:Number = Math.round(sw*p);
			Tweener.addTween(SInd, {_width:pw, time:.3, transition:"easeoutquad"});
			Tweener.addTween(SArw, {_x:pw, time:.3, transition:"easeoutquad"});
			updateTxt();
		}
	}
	//
	public function get width() {
		return Bg._width;
	}
	public function get height() {
		return Bg._height;
	}
	private function updateTxt() {
		var ap:Number = minz+(maxz-minz)*p;
		Txt.text = String(Math.round(ap*100))+"%";
	}
}
