class com.oop.data.Music
{
    var _on, _loaded, bar, music, _xscale, owner, _parent, onEnterFrame, file, title, intervalPos, seconds, minutes, miliseconds, position;
    function Music()
    {
        _on = false;
        _loaded = false;
    } // End of the function
    function setBar(clip)
    {
        this.unsetBar();
        bar = clip;
        bar.loading.music = music;
        bar.loading.owner = this;
        bar._loaded = false;
        bar.loading.onEnterFrame = function ()
        {
            _xscale = music.getBytesLoaded() / music.getBytesTotal() * 100;
            if (music.getBytesLoaded() == music.getBytesTotal())
            {
                owner._loaded = true;
                _parent._loaded = true;
                delete this.onEnterFrame;
            } // end if
        };
    } // End of the function
    function unsetBar()
    {
        delete bar.loading.onEnterFrame;
        bar = undefined;
    } // End of the function
    function loadTrack(f, t, volume)
    {
        music = new Sound();
        _loaded = false;
        file = f;
        title = t;
        this.setPosition(0);
        if (_on)
        {
            music.stop();
        } // end if
        music.owner = this;
        music.onSoundComplete = function ()
        {
            owner.stop();
            owner.play();
        };
        clearInterval(intervalPos);
        music.loadSound(file, true);
        _on = true;
    } // End of the function
    function setIntervalPos()
    {
        intervalPos = setInterval(this, "setPosition", 100);
    } // End of the function
    function setPosition(newPos)
    {
        if (newPos == undefined)
        {
            newPos = music.position;
        } // end if
        var _loc5 = Math.floor(newPos / 1000 / 60);
        var _loc4 = Math.floor(newPos / 1000 % 60);
        var _loc3 = newPos.toString().substring(2, 4);
        seconds = _loc4 < 10 ? ("0" + _loc4) : (_loc4);
        minutes = _loc5 < 10 ? ("0" + _loc5) : (_loc5);
        miliseconds = Number(_loc3) < 10 ? (_loc3 = "0" + Number(_loc3), "0" + Number(_loc3)) : (_loc3);
        bar.loading._xscale = newPos / music.duration * 100;
        position = newPos;
    } // End of the function
    function stop()
    {
        clearInterval(intervalPos);
        this.setPosition(1);
        music.stop();
        _on = false;
    } // End of the function
    function play()
    {
        clearInterval(intervalPos);
        music.start(position / 1000);
        _on = true;
    } // End of the function
    function pause()
    {
        clearInterval(intervalPos);
        position = music.position;
        music.stop();
        _on = false;
    } // End of the function
} // End of Class
