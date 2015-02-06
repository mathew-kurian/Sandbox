/**
 * display.as
 * Display interface
 *
 * @version		1.0
 */
const zero:String = "0:00'00''";
var felapsedtime:TextFormat = this.elapsedtime.getTextFormat();
var ftotaltime:TextFormat = this.totaltime.getTextFormat();
var elapsedt:Number = 0;
var totalt:Number = 0;
//
function __formattime(floatTime:Number):String {
	var _m:Number = Math.floor(floatTime / 60);
	var _s:Number = Math.floor(floatTime) - 60 * _m;
	var _h:Number = Math.floor(_m / 60);
	_m -= _h * 60;
	//
	var _time:String = ((_h > 0) ? _h : "0") + ":";
	_time = _time + ((_m > 9) ? _m : "0" + _m) + "'";
	_time = _time + ((_s > 9) ? _s : "0" + _s) + "''";
	//
	return _time;
};
//
this.getTimeElapsed = function():Number {
	return this.elapsedt;
};
this.setTimeElapsed = function(floatTime:Number):void {
	if (isNaN(floatTime)) return;
	if (floatTime < 0) return;
	if (floatTime > this.totalt) floatTime = this.totalt;
	//
	this.elapsedt = floatTime;
	this.elapsedtime.text = this.__formattime(floatTime);
	this.elapsedtime.setTextFormat(this.felapsedtime);
};
this.getTimeTotal = function():Number {
	return this.totalt;
};
this.setTimeTotal = function(floatTime:Number):void {
	if (isNaN(floatTime)) return;
	if (floatTime < 0) return;
	//
	this.totalt = floatTime;
	this.totaltime.text = this.__formattime(floatTime);
	this.totaltime.setTextFormat(this.ftotaltime);
};