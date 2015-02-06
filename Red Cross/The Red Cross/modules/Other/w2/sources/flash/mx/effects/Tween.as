class mx.effects.Tween extends Object
{
	static var IntervalToken;
	var arrayMode, listener, initVal, endVal, startTime, updateFunc, endFunc, ID;
	function Tween (listenerObj, init, end, dur) {
		super();
		if (listenerObj == undefined) {
			return;
		}
		if (typeof(init) != "number") {
			arrayMode = true;
		}
		listener = listenerObj;
		initVal = init;
		endVal = end;
		if (dur != undefined) {
			duration = dur;
		}
		startTime = getTimer();
		if (duration == 0) {
			endTween();
		} else {
			AddTween(this);
		}
	}
	static function AddTween(tween) {
		tween.ID = ActiveTweens.length;
		ActiveTweens.push(tween);
		if (IntervalToken == undefined) {
			Dispatcher.DispatchTweens = DispatchTweens;
			IntervalToken = setInterval(Dispatcher, "DispatchTweens", Interval);
		}
	}
	static function RemoveTweenAt(index) {
		var _local2 = ActiveTweens;
		if (((index >= _local2.length) || (index < 0)) || (index == undefined)) {
			return(undefined);
		}
		_local2.splice(index, 1);
		var _local4 = _local2.length;
		var _local1 = index;
		while (_local1 < _local4) {
			_local2[_local1].ID--;
			_local1++;
		}
		if (_local4 == 0) {
			clearInterval(IntervalToken);
			delete IntervalToken;
		}
	}
	static function DispatchTweens(Void) {
		var _local2 = ActiveTweens;
		var _local3 = _local2.length;
		var _local1 = 0;
		while (_local1 < _local3) {
			_local2[_local1].doInterval();
			_local1++;
		}
		updateAfterEvent();
	}
	function doInterval() {
		var _local2 = getTimer() - startTime;
		var _local3 = getCurVal(_local2);
		if (_local2 >= duration) {
			endTween();
		} else if (updateFunc != undefined) {
			listener[updateFunc](_local3);
		} else {
			listener.onTweenUpdate(_local3);
		}
	}
	function getCurVal(curTime) {
		if (arrayMode) {
			var _local3 = new Array();
			var _local2 = 0;
			while (_local2 < initVal.length) {
				_local3[_local2] = easingEquation(curTime, initVal[_local2], endVal[_local2] - initVal[_local2], duration);
				_local2++;
			}
			return(_local3);
		}
		return(easingEquation(curTime, initVal, endVal - initVal, duration));
	}
	function endTween() {
		if (endFunc != undefined) {
			listener[endFunc](endVal);
		} else {
			listener.onTweenEnd(endVal);
		}
		RemoveTweenAt(ID);
	}
	function setTweenHandlers(update, end) {
		updateFunc = update;
		endFunc = end;
	}
	function easingEquation(t, b, c, d) {
		return(((c / 2) * (Math.sin(Math.PI * ((t / d) - 0.5)) + 1)) + b);
	}
	static var ActiveTweens = new Array();
	static var Interval = 10;
	static var Dispatcher = new Object();
	var duration = 3000;
}
