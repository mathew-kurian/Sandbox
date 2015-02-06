import caurina.transitions.Tweener;
import caurina.transitions.properties.DisplayShortcuts;
import oxylus.Utils;
import oxylus.VideoPlaybackLight;
class oxylus.ezplayer.EZPlayer extends MovieClip {
	// mc reference vars
	private var Brd:MovieClip;
	private var Bg:MovieClip;
	private var VidMc:MovieClip;
	private var Vid:Video;
	private var CBar:MovieClip;
	private var PBrd:MovieClip;
	private var BufTip:MovieClip;
	private var PBar:MovieClip;
	private var LPlayBtn:MovieClip;
	// nested mc references
	private var CBarBg:MovieClip;
	private var RSide:MovieClip;
	private var PlayBtn:MovieClip;
	private var PauseBtn:MovieClip;
	private var RewindBtn:MovieClip;
	private var Title:TextField;
	private var FullSBtn:MovieClip;
	private var VolBar:MovieClip;
	private var MuteBtn:MovieClip;
	private var UnmuteBtn:MovieClip;
	private var Time:TextField;
	private var VidMsk:MovieClip;
	// video playback object
	private var vpo:Object;
	// double click handle
	private var doubleClickInterval:Number;
	// other vars
	private var fvVideoSize:Number;
	private var alphaShow:Object;
	private var alphaHide:Object;
	private var w:Number;
	private var h:Number;
	private var bw:Number = 2;
	private var cBarHeight:Number;
	private var pBarHeight:Number;
	// xml settings
	private var xml:XML;
	private var o:Object;
	
	private var ox:Number;
	private var oy:Number;
	// event
	public var onComplete:Function;
	// constructor
	
	
	private var maxW:Number;
	private var maxH:Number;
	
	public function EZPlayer() {
		ox = Math.round(this._x);
		oy = Math.round(this._y);
		//
		DisplayShortcuts.init();
		alphaShow = {_autoAlpha:100, time:.35, transition:"easeoutquad"};
		alphaHide = {_autoAlpha:0, time:.35, transition:"easeoutquad"};
		// get instances
		Brd = this["mc0"];
		Bg = this["mc1"];
		VidMc = this["mcvid"];
		Vid = VidMc["mc0"];
		CBar = this["mc2"];
		PBrd = this["mc3"];
		BufTip = this["mc4"];
		PBar = this["mc5"];
		LPlayBtn = this["mc6"];
		CBarBg = CBar["mc0"];
		RSide = CBar["mc1"];
		PlayBtn = CBar["mc2"];
		PauseBtn = CBar["mc3"];
		RewindBtn = CBar["mc4"];
		Title = CBar["mc5"];
		FullSBtn = RSide["mc0"];
		VolBar = RSide["mc1"];
		MuteBtn = RSide["mc2"];
		UnmuteBtn = RSide["mc3"];
		Time = RSide["mc4"];
		VidMsk = Bg.duplicateMovieClip("_vidMsk_", this.getNextHighestDepth());
		// video playback object
		vpo = new VideoPlaybackLight(Vid);
		vpo.onInit = Utils.delegate(this, vpoOnInit);
		vpo.onBuffering = Utils.delegate(this, vpoOnBuffering);
		vpo.onBufferFull = Utils.delegate(this, vpoOnBufferFull);
		vpo.onPlaybackResume = Utils.delegate(this, vpoOnPlaybackResume);
		vpo.onPlaybackPause = Utils.delegate(this, vpoOnPlaybackPause);
		vpo.onPlaybackTimeUpdate = Utils.delegate(this, vpoOnPlaybackTimeUpdate);
		vpo.onPlaybackComplete = Utils.delegate(this, vpoOnPlaybackComplete);
		vpo.onPlaybackError = Utils.delegate(this, vpoOnPlaybackError);
		vpo.onLoadProgress = Utils.delegate(this, vpoOnLoadProgress);
		// init instances
		Bg.useHandCursor = false;
		VidMc._alpha = 0;
		VidMc.setMask(VidMsk);
		VidMc._x = bw;
		VidMc._y = bw;
		VidMsk._x = bw;
		VidMsk._y = bw;
		BufTip._alpha = 0;
		Title.autoSize = "left";
		PauseBtn._visible = false;
		PauseBtn._alpha = 0;
		PauseBtn.enabled = false;
		UnmuteBtn._visible = false;
		UnmuteBtn._alpha = 0;
		UnmuteBtn.enabled = false;
		Time.autoSize = "center";
		// setup instances
		PlayBtn.onRelease = Utils.delegate(this, playBtnAction);
		PauseBtn.onRelease = Utils.delegate(this, pauseBtnAction);
		RewindBtn.onRelease = Utils.delegate(this, rewindBtnAction);
		MuteBtn.onRelease = Utils.delegate(this, muteBtnAction);
		UnmuteBtn.onRelease = Utils.delegate(this, unmuteBtnAction);
		FullSBtn.onRelease = Utils.delegate(this, toggleFullscreen);
		LPlayBtn.onRelease = Utils.delegate(this, playBtnAction);
		Bg.onRelease = Utils.delegate(this, checkDC);
		VolBar.onChange = Utils.delegate(this, updateVolume);
		PBar.onChange = Utils.delegate(this, pbarOnChange);
		// init vars
		cBarHeight = CBarBg._height;
		pBarHeight = PBrd._height-2;
		// init this
		this._visible = false;
		this._x = this._y = 0;
		this.hitArea = Brd;
		
		//Stage.addListener(this);
		
		// load settings
		/*xml = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = Utils.delegate(this, onXMLLoad);
		xml.load("player_settings.xml");*/
		// 
		this.onPress = null;
		this.useHandCursor = false;
	}
	
	public function setTheObject(obj:Object) {
		o = new Object();
		o = obj;
		maxW = obj.width;
		maxH = obj.height;
		gogo();
	}
	
	public function resizeEZ(a:Number, b:Number) {
		maxW = a;
		maxH = b;
		onResize();
	}
	
	private function gogo() {
		
		// init
		// autoplay
		vpo.autoPlay = o.autoplay;
		vpo.repeat = o.repeat;
		// smoothing
		Vid.smoothing = o.smoothing;
		// volume
		var fvVolume:Number = o.volume / 100;
		VolBar.percent = fvVolume;
		// buffer size
		var fvBuffer:Number = o.buffer;
		vpo.bufferTime = fvBuffer;
		// vide scale
		fvVideoSize = o.videosize;
		fvVideoSize>4 || fvVideoSize<0 ? fvVideoSize=0 : null;
		// video title
		var fvTitle:String = o.title;
		fvTitle == undefined ? fvTitle="" : null;
		Title.text = fvTitle;
		trace(o.title)
		FullSBtn.enabled = o.fullscreen;
		!o.fullscreen ? FullSBtn._alpha = 35 : null;
		// other 
		this.onResize();
		this._visible = true;
		Mouse.addListener(this);
		// add right click menu
		addRightClickMenu();
		// load video
		if (o.movie.length > 0) {
			loadVideo(o.movie);
		}
	}
	
	/*private function onXMLLoad(s:Boolean) {
		if (!s) return;
		
		o = Utils.parseSettingsNode(xml.firstChild);
		
		// init
		// autoplay
		vpo.autoPlay = o.autoplay;
		vpo.repeat = o.repeat;
		// smoothing
		Vid.smoothing = o.smoothing;
		// volume
		var fvVolume:Number = o.volume / 100;
		VolBar.percent = fvVolume;
		// buffer size
		var fvBuffer:Number = o.buffer;
		vpo.bufferTime = fvBuffer;
		// vide scale
		fvVideoSize = o.videosize;
		fvVideoSize>4 || fvVideoSize<0 ? fvVideoSize=0 : null;
		// video title
		var fvTitle:String = o.title;
		fvTitle == undefined ? fvTitle="" : null;
		Title.text = fvTitle;
		
		FullSBtn.enabled = o.fullscreen;
		!o.fullscreen ? FullSBtn._alpha = 35 : null;
		// other 
		this.onResize();
		this._visible = true;
		Mouse.addListener(this);
		// add right click menu
		addRightClickMenu();
		// load video
		if(o.movie.length > 0)
			loadVideo(o.movie);
	}*/
	
	public function loadVideo(movieUrl:String, movieTitle:String, ap:Boolean) {
		if (ap != undefined) vpo.autoPlay = ap;
		
		vpo.load(movieUrl);
		if (movieTitle != undefined) Title.text = movieTitle;
		delete this.onPress;
	}
	public function videoResume() {
		playBtnAction();
	}
	public function videoPause() {
		pauseBtnAction();
	}
	public function videoKill() {
		vpo.reset();
	}
	
	// handle double click
	private function checkDC() {
		Bg.onRelease = Utils.delegate(this, toggleFullscreen);
		doubleClickInterval = setInterval(this, "resetDC", 400);
	}
	private function resetDC() {
		Bg.onRelease = Utils.delegate(this, checkDC);
		clearInterval(doubleClickInterval);
	}
	// resize handler
	private function onResize() {
		var b:Boolean = Stage["displayState"] == "fullScreen";
		
		this._x = b ? 0 : ox;
		this._y = b ? 0 : oy;
		
		w =maxW - 2 * ox;
		h = maxH - 2 * oy;
		
		Brd._width = w;
		Brd._height = h;
		Bg._width = w-2*bw;
		Bg._height = h-2*bw-cBarHeight-pBarHeight;
		CBar._x = bw;
		CBar._y = h-bw-cBarHeight;
		PBrd._x = bw;
		PBrd._y = CBar._y-pBarHeight;
		PBrd._width = w-2*bw;
		BufTip._x = bw+5;
		BufTip._y = PBrd._y-BufTip._height-1;
		PBar._x = PBrd._x+1;
		PBar._y = PBrd._y+1;
		PBar.width = PBrd._width-2;
		LPlayBtn._x = Math.round(w/2);
		LPlayBtn._y = bw+Math.round((Bg._height-1)/2);
		CBarBg._width = w-2*bw;
		RSide._x = CBarBg._width;
		VidMsk._width = w-2*bw;
		VidMsk._height = Bg._height-1;
		scaleVideo();
	}
	// Toggle fullscreen
	private function toggleFullscreen() {
		if (!o.fullscreen) return;
		
		resetDC();
		var b:Boolean = Stage["displayState"] == "normal";
		Stage["displayState"] = b ? "fullScreen" : "normal";
	}
	// play / pause /rewind buttons
	private function playSwapAni() {
		PlayBtn.getDepth()>PauseBtn.getDepth() ? PlayBtn.swapDepths(PauseBtn) : null;
		PlayBtn.enabled = false;
		LPlayBtn.enabled = false;
		PlayBtn.onRollOut();
		LPlayBtn.onRollOut();
		PauseBtn.enabled = true;
		Tweener.addTween(PlayBtn, {base:alphaHide});
		Tweener.addTween(LPlayBtn, {base:alphaHide});
		Tweener.addTween(PauseBtn, {base:alphaShow});
	}
	private function pauseSwapAni() {
		PlayBtn.getDepth()<PauseBtn.getDepth() ? PlayBtn.swapDepths(PauseBtn) : null;
		PlayBtn.enabled = true;
		LPlayBtn.enabled = true;
		PauseBtn.enabled = false;
		PauseBtn.onRollOut();
		Tweener.addTween(PlayBtn, {base:alphaShow});
		Tweener.addTween(LPlayBtn, {base:alphaShow});
		Tweener.addTween(PauseBtn, {base:alphaHide});
	}
	private function playBtnAction() {
		vpo.resume();
	}
	private function pauseBtnAction() {
		vpo.pause();
	}
	private function rewindBtnAction() {
		playSwapAni();
		vpo.rewind();
	}
	// mute / unmute buttons
	private function muteSwapAni() {
		MuteBtn.getDepth()>UnmuteBtn.getDepth() ? MuteBtn.swapDepths(UnmuteBtn) : null;
		MuteBtn.enabled = false;
		UnmuteBtn.enabled = true;
		Tweener.addTween(MuteBtn, {base:alphaHide});
		Tweener.addTween(UnmuteBtn, {base:alphaShow});
		VolBar.enable(false);
	}
	private function unmuteSwapAni() {
		MuteBtn.getDepth()<UnmuteBtn.getDepth() ? MuteBtn.swapDepths(UnmuteBtn) : null;
		MuteBtn.enabled = true;
		UnmuteBtn.enabled = false;
		Tweener.addTween(MuteBtn, {base:alphaShow});
		Tweener.addTween(UnmuteBtn, {base:alphaHide});
		VolBar.enable(true);
	}
	private function muteBtnAction() {
		muteSwapAni();
		vpo.mute();
	}
	private function unmuteBtnAction() {
		unmuteSwapAni();
		vpo.mute(false);
	}
	// time bar seek
	private function pbarOnChange(per:Number) {
		vpo.seek(per, true);
	}
	// update volume
	private function updateVolume(p:Number) {
		vpo.setVolume(p);
	}
	// playback events
	private function vpoOnInit() {
		scaleVideo();
		Tweener.addTween(VidMc, {base:alphaShow, time:1});
	}
	private function vpoOnBuffering() {
		Tweener.addTween(BufTip, {base:alphaShow, time:1, transition:"easeinquart"});
	}
	private function vpoOnBufferFull() {
		Tweener.addTween(BufTip, {base:alphaHide});
	}
	private function vpoOnPlaybackResume() {
		playSwapAni();
	}
	private function vpoOnPlaybackPause() {
		pauseSwapAni();
	}
	private function vpoOnPlaybackTimeUpdate(tt:Number, ct:Number, tts:String, cts:String) {
		Time.text = tts+"/"+cts;
		PBar.timep = ct/tt;
	}
	private function vpoOnLoadProgress(tb:Number, lb:Number) {
		PBar.loadp = lb/tb;
	}
	private function vpoOnPlaybackError() {
		vpo.reset();
		this.onPress = null;
		this.useHandCursor = false;
	}
	private function vpoOnPlaybackComplete() {
		onComplete.call(this);
	}
	// get video playback object
	public function get $vpo() {
		return vpo;
	}
	// scale video
	// 0 - fit, 1 - crop, 2 - original, 3 - half size, 4 - stretch
	private function scaleVideo(ani:Boolean) {
		if (!vpo.isReady) {
			return;
		}
		ani = (ani == undefined ? false : true);
		var mw:Number = VidMsk._width;
		var mh:Number = VidMsk._height;
		var ow:Number = vpo.width;
		var oh:Number = vpo.height;
		var cw:Number, ch:Number;
		switch (fvVideoSize) {
		case 1 :
			cw = mw;
			ch = mw*oh/ow;
			ch<mh ? (ch=mh, cw=mh*ow/oh) : null;
			break;
		case 2 :
			cw = ow;
			ch = oh;
			break;
		case 3 :
			cw = ow/2;
			ch = oh/2;
			break;
		case 4 :
			cw = mw;
			ch = mh;
			break;
		default :
			cw = mw;
			ch = mw*oh/ow;
			ch>mh ? (ch=mh, cw=mh*ow/oh) : null;
			break;
		}
		Tweener.addTween(Vid, {time:ani ? .3 : 0, _width:Math.round(cw), _height:Math.round(ch), _x:Math.round(mw/2-cw/2), _y:Math.round(mh/2-ch/2), transition:"easeoutquad"});
	}
	// Add right click menu
	private function addRightClickMenu() {
		/*var cm:ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems.push(new ContextMenuItem("Toggle fullscreen", Utils.delegate(this, toggleFullscreen)));
		cm.customItems.push(new ContextMenuItem("Fit", Utils.delegate(this, changeVidScale, 0), true, fvVideoSize != 0));
		cm.customItems.push(new ContextMenuItem("Crop", Utils.delegate(this, changeVidScale, 1), false, fvVideoSize != 1));
		cm.customItems.push(new ContextMenuItem("Stretch", Utils.delegate(this, changeVidScale, 4), false, fvVideoSize != 4));
		cm.customItems.push(new ContextMenuItem("Original size ", Utils.delegate(this, changeVidScale, 2), false, fvVideoSize != 2));
		cm.customItems.push(new ContextMenuItem("Half size", Utils.delegate(this, changeVidScale, 3), false, fvVideoSize != 3));
		cm.customItems.push(new ContextMenuItem("Toggle smoothing", Utils.delegate(this, toggleSmoothing), true));
		this.menu = cm;*/
	}
	// runtime vide scalling
	private function changeVidScale($s:Number) {
		fvVideoSize = $s;
		scaleVideo(true);
		delete this.menu;
		addRightClickMenu();
	}
	// runtime smoothing toggle
	private function toggleSmoothing() {
		Vid.smoothing = !Vid.smoothing;
	}
	// mouse wheel volume
	private function onMouseWheel(dlt:Number) {
		if (!Brd.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		dlt>0 ? VolBar.nudgeUp() : VolBar.nudgeDn();
	}
}
