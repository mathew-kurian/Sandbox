import caurina.transitions.Tweener;
import oxylus.Utils;
class oxylus.ezplayer.VolumeBar extends MovieClip {
	// stage instances
	private var Shp:MovieClip;
	private var Bg:MovieClip;
	private var Ind:MovieClip;
	private var Hit:MovieClip;
	// vars
	private var w:Number;
	private var iw:Number;
	private var p:Number;
	// onChange event
	public var onChange:Function;
	public function VolumeBar() {
		// get instances
		Shp = this["mc0"];
		Bg = this["mc1"];
		Ind = this["mc2"];
		Hit = Bg.duplicateMovieClip("_hit_", this.getNextHighestDepth());
		// setup
		Hit._alpha = 0;
		Hit.enabled = true;
		Bg.setMask(Shp);
		Ind.setMask(Shp.duplicateMovieClip("_shp2_", this.getNextHighestDepth()));
		Hit.onPress = Utils.delegate(this, startInd);
		Hit.onRelease = Hit.onReleaseOutside=Utils.delegate(this, stopInd);
		// init
		w = Bg._width;
		iw = Ind._width;
	}
	// start draging indicator
	private function startInd() {
		this.onMouseMove = updateInd;
		updateInd();
	}
	// stop draging indicator
	private function stopInd() {
		delete this.onMouseMove;
	}
	// update indicator position
	private function updateInd() {
		iw = _xmouse<0 ? 0 : (_xmouse>w ? w : _xmouse);
		if (Ind._width != iw) {
			Ind._width = iw;
			p = Math.round(iw*100/w)/100;
			onChange.call(this, p);
		}
	}
	// enable / disable
	public function enable(b:Boolean) {
		Hit.enabled = b;
		var to:Number = b ? iw : 0;
		Tweener.addTween(Ind, {_width:to, time:.25, transition:"easeoutquad"});
	}
	// get / set percentage
	public function set percent(np:Number) {
		p = np<0 ? 0 : (np>1 ? 1 : np);
		Ind._width = iw=w*p;
		onChange.call(this, p);
	}
	public function get percent():Number {
		return p;
	}
	// nudge
	private function nudge() {
		iw = w*p;
		onChange.call(this, p);
		Tweener.addTween(Ind, {_width:iw, time:.25, transition:"easeoutquad"});
	}
	public function nudgeUp() {
		if (Hit.enabled) {
			p += .1;
			p>1 ? p=1 : null;
			nudge();
		}
	}
	public function nudgeDn() {
		if (Hit.enabled) {
			p -= .1;
			p<0 ? p=0 : null;
			nudge();
		}
	}
}
