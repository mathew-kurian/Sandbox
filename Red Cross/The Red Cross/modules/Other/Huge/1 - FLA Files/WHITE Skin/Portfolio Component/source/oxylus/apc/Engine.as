import oxylus.Utils;
import caurina.transitions.Tweener;
class oxylus.apc.Engine extends MovieClip {
	// reference variables
	private var Bg:MovieClip;
	private var Msk:MovieClip;
	private var Obj:MovieClip;
	private var Hit:MovieClip;
	private var SH:MovieClip;
	private var SV:MovieClip;
	private var Pldr:MovieClip;
	private var Ctrl:MovieClip;
	private var CDCursor:MovieClip;
	// config vars
	private var objPath:String;
	private var w:Number;
	private var h:Number;
	private var minz:Number;
	private var maxz:Number;
	private var crtz:Number;
	private var initx:Number;
	private var inity:Number;
	private var sliders:Boolean;
	private var maxStep:Number;
	private var nudgeStep:Number;
	private var mswz:Boolean;
	private var zoomStep:Number;
	private var panType:Number;
	private var edgeTol:Number;
	private var ctrlType:Number;
	private var showCtrl:Boolean;
	private var ctrlxa:Number;
	private var ctrlya:Number;
	private var smoothImg:Boolean;
	// other vars
	// movie clip loader
	private var mcl:MovieClipLoader;
	// object original width and height
	private var ow:Number;
	private var oh:Number;
	// object current width and height
	private var cw:Number;
	private var ch:Number;
	// difference from _ymouse/_xmouse
	private var dy:Number;
	private var dx:Number;
	// x,y position
	private var xp:Number;
	private var yp:Number;
	// init zoom
	private var initz:Number;
	// config xml
	private var xml:XML;
	// initial sliders position
	private var shxi:Number;
	private var svyi:Number;
	// check if mouse is down
	private var mouseIsDown:Boolean = false;
	// controller margin
	private var ctrlm:Number;
	// nudge ease out
	private var nudgeEaseOut:Boolean = false;
	private var ndgy:Number;
	private var ndgx:Number;
	// loading
	private var isLoading:Boolean = true;
	public function Engine() {
		// assign instances
		Bg = this["mc0"];
		Msk = this["mc1"];
		SH = this["mc2"];
		SV = this["mc3"];
		Pldr = this["mc4"];
		Hit = Bg.duplicateMovieClip("_hit_", this.getNextHighestDepth());
		// setup instances  
		// preloader
		Pldr._alpha = 0;
		// hit
		Hit._alpha = 0;
		Hit.useHandCursor = false;
		// sliders
		// horizontal slider
		SH.onPress = Utils.delegate(this, SHDrag);
		SH.onRelease = Utils.delegate(this, SHStopDrag);
		SH["_onReleaseOutside"] = SH.onRelease;
		// vertical slider
		SV.onPress = Utils.delegate(this, SVDrag);
		SV.onRelease = Utils.delegate(this, SVStopDrag);
		SV["_onReleaseOutside"] = SV.onRelease;
		// setup vars
		// movie clip loader
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		// get config xml
		/*xml = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = Utils.delegate(this, onConfigData);*/
		// init stuff
		
		
		Mouse.addListener(this);
		this.setMask(Msk);
		
		
		SV._visible = SH._visible = false;
	}
	// load external swf/image
	private function loadSwfImg(src:String) {
		Obj.removeMovieClip();
		Obj = this.createEmptyMovieClip("_obj_", this.getNextHighestDepth());
		Obj._alpha = 0;
		Obj._lockroot = true;
		SH.swapDepths(this.getNextHighestDepth());
		SV.swapDepths(this.getNextHighestDepth());
		showCtrl ? Ctrl.swapDepths(this.getNextHighestDepth()) : null;
		mcl.loadClip(src, Obj);
		Pldr.onEnterFrame = rotate;
		Tweener.addTween(Pldr, {_alpha:100, time:1, transition:"easeinquart"});
	}
	// rotate preloader
	private function rotate() {
		_rotation += 10;
	}
	// remove preloader
	private function onLoadComplete() {
		Tweener.removeTweens(Pldr);
		Pldr._alpha = 0;
		delete Pldr.onEnterFrame;
	}
	// when loading is done
	private function onLoadInit() {
		ow = cw=Obj._width;
		oh = ch=Obj._height;
		if (isNaN(minz)) {
			minz = w/cw;
			h>minz*ch ? minz=h/ch : null;
			minz = Utils.truncNr(minz);
			setupCtrl();
		}
		Hit._width = ow;
		Hit._height = oh;
		Obj.forceSmoothing = smoothImg;
		Tweener.addTween(Obj, {_alpha:100, time:.5, transition:"easeoutquad"});
		showCtrl ? Tweener.addTween(Ctrl, {_alpha:100, time:.5, transition:"easeoutquad", delay:.5}) : null;
		
		isNaN(crtz) ? crtz=minz : null;
		zoomTo(crtz);
		setPosPer(initx, inity);
		switch (panType) {
		case 2 :
			addMouseMoveBehavior();
			break;
		default :
			addClickDragBehavior();
			break;
		}
		isLoading = false;
	}
	// load object method
	public function loadObj(src:String) {
		isLoading = true;
		// reset things
		SV._visible = SH._visible=false;
		SV._alpha = SH._alpha=0;
		delete onEnterFrame;
		Tweener.removeAllTweens();
		removeBehaviors();
		Ctrl.removeMovieClip();
		// load
		xml.load(src);
	}
	// on config data loaded
	public function onConfigData(someObj:Object) {
		
		                                                                      
		getConfig(someObj);
	
		if (showCtrl) {
			var ctrlId:String;
			switch (ctrlType) {
			case 2 :
				ctrlm = 0;
				ctrlId = "IDController#2";
				break;
			case 3 :
				ctrlm = 10;
				ctrlId = "IDController#3";
				break;
			default :
				ctrlm = 5;
				ctrlId = "IDController#1";
				break;
			}
			Ctrl = this.attachMovie(ctrlId, "_ctrl_", this.getNextHighestDepth());
			Ctrl._alpha = 0;
			setupCtrl();
		}
		// set width and height                                                
		width = w;
		height = h;
		// load swf/img           
		loadSwfImg(objPath);
	}
	// setup controller
	private function setupCtrl() {
		if (isNaN(minz) || !showCtrl) {
			return;
		}
		Ctrl.setLimits(minz, maxz);
		Ctrl.percent = crtz;
	}
	private function updateCtrlPos() {
		switch (ctrlxa) {
		case "middle" :
			Ctrl._x = Math.round(w/2-Ctrl.width/2);
			break;
		case "right" :
			Ctrl._x = w-ctrlm-Ctrl.width;
			Ctrl["bgToRight"]();
			break;
		default :
			Ctrl._x = ctrlm;
			// only for controller 3
			Ctrl["tipToRight"]();
			break;
		}
		switch (ctrlya) {
		case "middle" :
			Ctrl._y = Math.round(h/2-Ctrl.height/2);
			break;
		case "bottom" :
			Ctrl._y = h-ctrlm-Ctrl.height;
			break;
		default :
			Ctrl._y = ctrlm;
			break;
		}
	}
	// get config parameters
	private function getConfig(someObj:Object) {
		
		objPath = someObj.objectPath;
		
		w = Number(someObj["viewportWidth"]);
		h = Number(someObj["viewportHeight"]);
		
		minz = Number(someObj["minimumZoom"]);
		maxz = Number(someObj["maximumZoom"]);
		initz = crtz=Number(someObj["initialZoom"]);
		initx = Number(someObj["initPosXPercent"]);
		inity = Number(someObj["initPosYPercent"]);
		sliders = false;
		maxStep = Number(someObj["maxSlidingStep"]);
		nudgeStep = Number(someObj["nudgeStep"]);
		mswz = true;
		zoomStep = Number(someObj["zoomStepPercent"]);
		panType = Number(someObj["panningType"]);
		edgeTol = Number(someObj["edgeTolerance"]);
		ctrlType = Number(someObj["controllerType"]);
		showCtrl = true;
		ctrlxa = someObj["ctrlXAlign"];
		ctrlya = someObj["ctrlYAlign"];
		smoothImg = true;
		
		
	}
	// get/set width
	public function get width() {
		return w;
	}
	public function get height() {
		return h;
	}
	public function set width(nw:Number) {
		w = nw;
		Bg._width = w;
		Msk._width = w;
		SV._x = w;
		shxi = Math.round((w-SH._width)/2);
		SH._x = shxi;
		validatePos();
		Hit._x = Obj._x=xp;
		Pldr._x = w/2;
		Pldr._y = h/2;
		updateCtrlPos();
	}
	public function set height(nh:Number) {
		h = nh;
		Bg._height = h;
		Msk._height = h;
		SH._y = h;
		svyi = Math.round((h-SV._height)/2);
		SV._y = svyi;
		validatePos();
		Hit._y = Obj._y=yp;
		updateCtrlPos();
	}
	// zooming
	public function zoomTo(p:Number, tweened:Boolean, relVal:Boolean, relToMousePos:Boolean) {
		relVal ? p=minz+(maxz-minz)*p : null;
		p = Utils.truncNr(p);
		var xm:Number, ym:Number;
		if (relToMousePos) {
			xm = this._xmouse;
			ym = this._ymouse;
		} else {
			xm = w/2;
			ym = h/2;
		}
		xp = xm-(xm-xp)*p/crtz;
		yp = ym-(ym-yp)*p/crtz;
		cw = Math.round(ow*p);
		ch = Math.round(oh*p);
		crtz = p;
		showCtrl ? Ctrl.percent=crtz : null;
		validatePos();
		if (tweened) {
			Tweener.addTween(Hit, {_x:xp, _y:yp, _width:cw, _height:ch, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
		} else {
			Hit._x = xp;
			Hit._y = yp;
			Hit._width = cw;
			Hit._height = ch;
			updateObj();
		}
	}
	public function resetZoom() {
		zoomTo(initz, true);
	}
	// set position percent
	public function setPosPer(perx:Number, pery:Number, tweened:Boolean) {
		perx<0 ? perx=0 : (perx>1 ? perx=1 : null);
		pery<0 ? pery=0 : (pery>1 ? pery=1 : null);
		xp = Math.round((w-cw)*perx);
		yp = Math.round((h-ch)*pery);
		validatePos();
		if (tweened) {
			Tweener.addTween(Hit, {_x:xp, _y:yp, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
		} else {
			Hit._x = Obj._x=xp;
			Hit._y = Obj._y=yp;
		}
	}
	// Sliders setup
	// begin draging horiz slider
	private function SHDrag() {
		var offset:Number = _xmouse-SH._x;
		SH.onMouseMove = Utils.delegate(this, SHMove, offset);
	}
	// move horiz slider
	private function SHMove(offset:Number) {
		var shx:Number = _xmouse-offset;
		var stw:Number = w-SH._width;
		shx<0 ? shx=0 : (shx>stw ? shx=stw : null);
		SH._x = shx;
		//Tweener.addTween(SH, {_x:shx, time:.25, transition:"easeoutquad"});
		var cv:Number = Math.round(shxi-shx);
		var tv:Number = Math.round(shxi);
		var step:Number = Math.round(maxStep*cv/tv);
		onEnterFrame = Utils.delegate(this, nudgeX, step);
	}
	// stop horiz slider draging
	private function SHStopDrag() {
		delete SH.onMouseMove;
		stopNudge();
		Tweener.addTween(SH, {_x:shxi, time:.25, transition:"easeoutelastic"});
	}
	// begin draging vert slider
	private function SVDrag() {
		var offset:Number = _ymouse-SV._y;
		SV.onMouseMove = Utils.delegate(this, SVMove, offset);
	}
	// move vert slider
	private function SVMove(offset:Number) {
		var svy:Number = _ymouse-offset;
		var sth:Number = h-SV._height;
		svy<0 ? svy=0 : (svy>sth ? svy=sth : null);
		SV._y = svy;
		//Tweener.addTween(SV, {_y:svy, time:.25, transition:"easeoutquad"});
		var cv:Number = Math.round(svyi-svy);
		var tv:Number = Math.round(svyi);
		var step:Number = Math.round(maxStep*cv/tv);
		onEnterFrame = Utils.delegate(this, nudgeY, step);
	}
	// stop vert slider draging
	private function SVStopDrag() {
		delete SV.onMouseMove;
		stopNudge();
		Tweener.addTween(SV, {_y:svyi, time:.25, transition:"easeoutelastic"});
	}
	// directional nudge
	public function nudgeLeft() {
		onEnterFrame = Utils.delegate(this, nudgeX, nudgeStep);
	}
	public function nudgeRight() {
		onEnterFrame = Utils.delegate(this, nudgeX, -nudgeStep);
	}
	public function nudgeUp() {
		onEnterFrame = Utils.delegate(this, nudgeY, nudgeStep);
	}
	public function nudgeDown() {
		onEnterFrame = Utils.delegate(this, nudgeY, -nudgeStep);
	}
	public function stopNudge() {
		delete onEnterFrame;
	}
	// nudge X / Y
	private function nudgeX(step:Number) {
		xp += step;
		validatePos();
		if (ndgx != xp) {
			ndgx = xp;
			Tweener.addTween(Hit, {_x:xp, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
		}
	}
	private function nudgeY(step:Number) {
		yp += step;
		validatePos();
		if (ndgy != yp) {
			ndgy = yp;
			Tweener.addTween(Hit, {_y:yp, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
		}
	}
	// validate current object x and y position
	private function validatePos() {
		xp>0 ? xp=0 : (xp<w-cw ? xp=w-cw : null);
		yp>0 ? yp=0 : (yp<h-ch ? yp=h-ch : null);
		w>cw ? xp=(w-cw)/2 : null;
		h>ch ? yp=(h-ch)/2 : null;
		xp = Math.round(xp);
		yp = Math.round(yp);
	}
	// update object according to hit area dimensions and position
	private function updateObj() {
		Obj._x = Hit._x;
		Obj._y = Hit._y;
		Obj._width = Hit._width;
		Obj._height = Hit._height;
	}
	// remove behaviors
	private function removeBehaviors() {
		hideCursor();
		delete Hit.onPress;
		delete Hit.onRelease;
		delete Hit.onReleaseOutside;
		delete Hit.onRollOver;
		delete Hit.onRollOut;
	}
	// cursor
	private function showCursor() {
		CDCursor = _parent.attachMovie("IDClickDragHandCursor", "_click_and_drag_hand_cursor_ascsadasdad234234", _parent.getNextHighestDepth());
	}
	private function hideCursor() {
		CDCursor.remove();
	}
	// CLICK AND DRAG panning
	private function addClickDragBehavior() {
		removeBehaviors();
		Hit.onPress = Utils.delegate(this, startCDPanning);
		Hit.onRelease = Utils.delegate(this, stopCDPanning);
		Hit.onRollOver = Utils.delegate(this, showCursor);
		Hit.onRollOut = Utils.delegate(this, hideCursor);
		Hit.onReleaseOutside = Utils.delegate(this, HitROutside);
	}
	private function HitROutside() {
		stopCDPanning();
		hideCursor();
	}
	// start click and drag panning
	private function startCDPanning() {
		dx = _xmouse-Hit._x;
		dy = _ymouse-Hit._y;
		onMouseMove = updateCDPos;
		updateCDPos();
	}
	// stop click and drag panning
	private function stopCDPanning() {
		delete onMouseMove;
	}
	// update object position
	private function updateCDPos() {
		xp = _xmouse-dx;
		yp = _ymouse-dy;
		validatePos();
		Tweener.addTween(Hit, {_x:xp, _y:yp, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
	}
	// MOUSE MOVE panning
	private function addMouseMoveBehavior() {
		removeBehaviors();
		Hit.onRollOver = Utils.delegate(this, startMMPanning);
		Hit.onRollOut = Hit.onReleaseOutside=Utils.delegate(this, stopMMPanning);
	}
	// start mouse move panning
	private function startMMPanning() {
		onMouseMove = updateMMPos;
		updateMMPos();
	}
	// stop mouse move panning
	private function stopMMPanning() {
		delete onMouseMove;
	}
	// update object position
	private function updateMMPos() {
		var xm:Number = _xmouse<edgeTol ? 0 : (_xmouse>w-edgeTol ? w-2*edgeTol : _xmouse-2*edgeTol);
		var ym:Number = _ymouse<edgeTol ? 0 : (_ymouse>h-edgeTol ? h-2*edgeTol : _ymouse-2*edgeTol);
		xp = (w-cw)*xm/(w-2*edgeTol);
		yp = (h-ch)*ym/(h-2*edgeTol);
		validatePos();
		Tweener.addTween(Hit, {_x:xp, _y:yp, time:.5, rounded:true, transition:"easeoutquad", onUpdate:Utils.delegate(this, updateObj)});
	}
	// mouse wheel zoom
	private function onMouseWheel(dlt:Number) {
		if (!Utils.overHitZone(this, w, h) || !mswz || mouseIsDown || isLoading) {
			return;
		}
		var dir:Number = dlt/Math.abs(dlt);
		var nz:Number = crtz+dir*zoomStep;
		nz>maxz ? nz=maxz : (nz<minz ? nz=minz : null);
		nz != crtz ? zoomTo(nz, true, false, true) : null;
	}
	// if mouse button is down, mouse wheel zooming is disabled
	private function onMouseDown() {
		mouseIsDown = true;
	}
	private function onMouseUp() {
		mouseIsDown = false;
	}
}
