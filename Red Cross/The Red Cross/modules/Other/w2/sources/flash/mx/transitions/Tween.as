class mx.transitions.Tween
{
	var obj, prop, begin, useSeconds, _listeners, addListener, prevTime, _time, looping, _duration, broadcastMessage, isPlaying, _fps, prevPos, _pos, change, _intervalID, _startTime;
	function Tween (obj, prop, func, begin, finish, duration, useSeconds) {
		mx.transitions.OnEnterFrameBeacon.init();
		if (!arguments.length) {
			return;
		}
		this.obj = obj;
		this.prop = prop;
		this.begin = begin;
		position = (begin);
		this.duration = (duration);
		this.useSeconds = useSeconds;
		if (func) {
			this.func = func;
		}
		this.finish = (finish);
		_listeners = [];
		this.addListener(this);
		this.start();
	}
	function set time(t) {
		prevTime = _time;
		if (t > duration) {
			if (looping) {
				rewind(t - _duration);
				update();
				this.broadcastMessage("onMotionLooped", this);
			} else {
				if (useSeconds) {
					_time = _duration;
					update();
				}
				this.stop();
				this.broadcastMessage("onMotionFinished", this);
			}
		} else if (t < 0) {
			rewind();
			update();
		} else {
			_time = t;
			update();
		}
		//return(time);
	}
	function get time() {
		return(_time);
	}
	function set duration(d) {
		_duration = (((d == null) || (d <= 0)) ? (_global.Infinity) : (d));
		//return(duration);
	}
	function get duration() {
		return(_duration);
	}
	function set FPS(fps) {
		var _local2 = isPlaying;
		stopEnterFrame();
		_fps = fps;
		if (_local2) {
			startEnterFrame();
		}
		//return(FPS);
	}
	function get FPS() {
		return(_fps);
	}
	function set position(p) {
		setPosition(p);
		//return(position);
	}
	function setPosition(p) {
		prevPos = _pos;
		obj[prop] = (_pos = p);
		this.broadcastMessage("onMotionChanged", this, _pos);
		updateAfterEvent();
	}
	function get position() {
		return(getPosition());
	}
	function getPosition(t) {
		if (t == undefined) {
			t = _time;
		}
		return(func(t, begin, change, _duration));
	}
	function set finish(f) {
		change = f - begin;
		//return(finish);
	}
	function get finish() {
		return(begin + change);
	}
	function continueTo(finish, duration) {
		begin = position;
		this.finish = (finish);
		if (duration != undefined) {
			this.duration = (duration);
		}
		this.start();
	}
	function yoyo() {
		continueTo(begin, time);
	}
	function startEnterFrame() {
		if (_fps == undefined) {
			_global["MovieClip"].addListener(this);
		} else {
			_intervalID = setInterval(this, "onEnterFrame", 1000 / _fps);
		}
		isPlaying = true;
	}
	function stopEnterFrame() {
		if (_fps == undefined) {
			_global["MovieClip"].removeListener(this);
		} else {
			clearInterval(_intervalID);
		}
		isPlaying = false;
	}
	function start() {
		rewind();
		startEnterFrame();
		this.broadcastMessage("onMotionStarted", this);
	}
	function stop() {
		stopEnterFrame();
		this.broadcastMessage("onMotionStopped", this);
	}
	function resume() {
		fixTime();
		startEnterFrame();
		this.broadcastMessage("onMotionResumed", this);
	}
	function rewind(t) {
		_time = ((t == undefined) ? 0 : (t));
		fixTime();
		update();
	}
	function fforward() {
		time = (_duration);
		fixTime();
	}
	function nextFrame() {
		if (useSeconds) {
			time = ((getTimer() - _startTime) / 1000);
		} else {
			time = (_time + 1);
		}
	}
	function onEnterFrame() {
		this.nextFrame();
	}
	function prevFrame() {
		if (!useSeconds) {
			time = (_time - 1);
		}
	}
	function toString() {
		return("[Tween]");
	}
	function fixTime() {
		if (useSeconds) {
			_startTime = getTimer() - (_time * 1000);
		}
	}
	function update() {
		position = (getPosition(_time));
	}
	static var version = "1.1.0.52";
	static var __initBeacon = mx.transitions.OnEnterFrameBeacon.init();
	static var __initBroadcaster = mx.transitions.BroadcasterMX.initialize(mx.transitions.Tween.prototype, true);
	function func(t, b, c, d) {
		return(((c * t) / d) + b);
	}
}
