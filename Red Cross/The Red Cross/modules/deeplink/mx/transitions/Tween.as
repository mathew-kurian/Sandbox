class mx.transitions.Tween
{
    var obj, prop, begin, __set__position, __set__duration, useSeconds, __set__finish, _listeners, addListener, _time, prevTime, __get__duration, looping, _duration, broadcastMessage, __get__time, isPlaying, _fps, __get__FPS, __get__position, _pos, prevPos, change, __get__finish, _intervalID, __set__time, _startTime, __set__FPS;
    function Tween(obj, prop, func, begin, finish, duration, useSeconds)
    {
        mx.transitions.OnEnterFrameBeacon.init();
        if (!arguments.length)
        {
            return;
        } // end if
        this.obj = obj;
        this.prop = prop;
        this.begin = begin;
        this.__set__position(begin);
        this.__set__duration(duration);
        this.useSeconds = useSeconds;
        if (func)
        {
            this.func = func;
        } // end if
        this.__set__finish(finish);
        _listeners = [];
        this.addListener(this);
        this.start();
    } // End of the function
    function set time(t)
    {
        prevTime = _time;
        if (t > this.__get__duration())
        {
            if (looping)
            {
                this.rewind(t - _duration);
                this.update();
                this.broadcastMessage("onMotionLooped", this);
            }
            else
            {
                if (useSeconds)
                {
                    _time = _duration;
                    this.update();
                } // end if
                this.stop();
                this.broadcastMessage("onMotionFinished", this);
            } // end else if
        }
        else if (t < 0)
        {
            this.rewind();
            this.update();
        }
        else
        {
            _time = t;
            this.update();
        } // end else if
        //return (this.time());
        null;
    } // End of the function
    function get time()
    {
        return (_time);
    } // End of the function
    function set duration(d)
    {
        _duration = d == null || d <= 0 ? (_global.Infinity) : (d);
        //return (this.duration());
        null;
    } // End of the function
    function get duration()
    {
        return (_duration);
    } // End of the function
    function set FPS(fps)
    {
        var _loc2 = isPlaying;
        this.stopEnterFrame();
        _fps = fps;
        if (_loc2)
        {
            this.startEnterFrame();
        } // end if
        //return (this.FPS());
        null;
    } // End of the function
    function get FPS()
    {
        return (_fps);
    } // End of the function
    function set position(p)
    {
        this.setPosition(p);
        //return (this.position());
        null;
    } // End of the function
    function setPosition(p)
    {
        prevPos = _pos;
        obj[prop] = _pos = p;
        this.broadcastMessage("onMotionChanged", this, _pos);
        updateAfterEvent();
    } // End of the function
    function get position()
    {
        return (this.getPosition());
    } // End of the function
    function getPosition(t)
    {
        if (t == undefined)
        {
            t = _time;
        } // end if
        return (this.func(t, begin, change, _duration));
    } // End of the function
    function set finish(f)
    {
        change = f - begin;
        //return (this.finish());
        null;
    } // End of the function
    function get finish()
    {
        return (begin + change);
    } // End of the function
    function continueTo(finish, duration)
    {
        begin = position;
        this.__set__finish(finish);
        if (duration != undefined)
        {
            this.__set__duration(duration);
        } // end if
        this.start();
    } // End of the function
    function yoyo()
    {
        this.continueTo(begin, this.__get__time());
    } // End of the function
    function startEnterFrame()
    {
        if (_fps == undefined)
        {
            _global.MovieClip.addListener(this);
        }
        else
        {
            _intervalID = setInterval(this, "onEnterFrame", 1000 / _fps);
        } // end else if
        isPlaying = true;
    } // End of the function
    function stopEnterFrame()
    {
        if (_fps == undefined)
        {
            _global.MovieClip.removeListener(this);
        }
        else
        {
            clearInterval(_intervalID);
        } // end else if
        isPlaying = false;
    } // End of the function
    function start()
    {
        this.rewind();
        this.startEnterFrame();
        this.broadcastMessage("onMotionStarted", this);
    } // End of the function
    function stop()
    {
        this.stopEnterFrame();
        this.broadcastMessage("onMotionStopped", this);
    } // End of the function
    function resume()
    {
        this.fixTime();
        this.startEnterFrame();
        this.broadcastMessage("onMotionResumed", this);
    } // End of the function
    function rewind(t)
    {
        _time = t == undefined ? (0) : (t);
        this.fixTime();
        this.update();
    } // End of the function
    function fforward()
    {
        this.__set__time(_duration);
        this.fixTime();
    } // End of the function
    function nextFrame()
    {
        if (useSeconds)
        {
            this.__set__time((getTimer() - _startTime) / 1000);
        }
        else
        {
            this.__set__time(_time + 1);
        } // end else if
    } // End of the function
    function onEnterFrame()
    {
        this.nextFrame();
    } // End of the function
    function prevFrame()
    {
        if (!useSeconds)
        {
            this.__set__time(_time - 1);
        } // end if
    } // End of the function
    function toString()
    {
        return ("[Tween]");
    } // End of the function
    function fixTime()
    {
        if (useSeconds)
        {
            _startTime = getTimer() - _time * 1000;
        } // end if
    } // End of the function
    function update()
    {
        this.__set__position(this.getPosition(_time));
    } // End of the function
    static var version = "1.1.0.52";
    static var __initBeacon = mx.transitions.OnEnterFrameBeacon.init();
    static var __initBroadcaster = mx.transitions.BroadcasterMX.initialize(mx.transitions.Tween.prototype, true);
    function func(t, b, c, d)
    {
        return (c * t / d + b);
    } // End of the function
} // End of Class
