import caurina.transitions.Tweener;
import oxylus.Utils;
class oxylus.ezplayer.TimeBar extends MovieClip {
	// stage mc instances
	private var Bg:MovieClip;
	private var LoadInd:MovieClip;
	private var TimeInd:MovieClip;
	private var TipMc:MovieClip;
	private var TipTxt:TextField;
	// vars
	private var w:Number;
	private var lw:Number;
	private var tw:Number;
	private var tp:Number = 0;
	private var lp:Number = 0;
	private var $drag:Boolean = false;
	// on change event
	public var onChange:Function;
	public function TimeBar() {
		// get instances
		Bg = this["mc0"];
		LoadInd = this["mc1"];
		TimeInd = this["mc2"];
		TipMc = this["mc3"];
		TipTxt = TipMc["mc0"];
		// setup instances
		LoadInd._width = 0;
		TimeInd._width = 0;
		this.hitArea = LoadInd;
		TipMc._alpha = 0;
		TipTxt.autoSize = "center";
	}
	// set bar width
	public function set width(nw:Number) {
		Tweener.isTweening(LoadInd) ? Tweener.removeTweens(LoadInd) : null;
		Tweener.isTweening(TimeInd) ? Tweener.removeTweens(TimeInd) : null;
		w = nw;
		lw = Math.round(w*lp);
		tw = Math.round(w*tp);
		Bg._width = w;
		LoadInd._width = lw;
		TimeInd._width = tw;
	}
	// events
	private function onRollOver() {
		Tweener.addTween(TipMc, {_alpha:100, time:.3, transition:"easeoutquad"});
		this.onMouseMove = moveTip;
		moveTip();
	}
	private function onRollOut() {
		Tweener.addTween(TipMc, {_alpha:0, time:.3, transition:"easeoutquad"});
		delete this.onMouseMove;
	}
	private function onPress() {
		$drag = true;
		Tweener.isTweening(TimeInd) ? Tweener.removeTweens(TimeInd) : null;
		this.onMouseMove = moveTimeInd;
		moveTimeInd();
	}
	private function onRelease() {
		$drag = false;
		this.onMouseMove = moveTip;
	}
	private function onReleaseOutside() {
		$drag = false;
		onRollOut();
	}
	// move tooltip
	private function moveTip() {
		var xm:Number = _xmouse<0 ? 0 : (_xmouse>lw ? lw : _xmouse);
		TipMc._x = xm;
		var vpo = _parent.$vpo;
		TipTxt.text = vpo.formatTime(vpo.totalTime*xm/w);
	}
	// move time bar
	private function moveTimeInd() {
		moveTip();
		tw = TipMc._x;
		tp = Math.round((tw/w)*100)/100;
		if (TimeInd._width != tw) {
			TimeInd._width = tw;
			onChange.call(this, tp);
		}
	}
	// set time bar value
	public function set timep(ntp:Number) {
		if (!$drag) {
			tp = ntp;
			tw = Math.round(w*tp);
			Tweener.addTween(TimeInd, {_width:tw, time:.3, transition:"easeoutquad"});
		}
	}
	// set load bar value
	public function set loadp(nlp:Number) {
		lp = nlp;
		Tweener.addTween(LoadInd, {_width:Math.round(w*lp), time:.3, transition:"easeoutquad", onUpdate:updateOthers, onUpdateScope:this});
		this.onMouseMove();
	}
	private function updateOthers() {
		lw = LoadInd._width;
		this.onMouseMove();
	}
}
