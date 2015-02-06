class com.oop.utils.MusicBars extends MovieClip
{
    var _on, animator;
    function MusicBars()
    {
        super();
        _on = false;
        animator = new com.oop.animation.Animator();
        for (var _loc3 in this)
        {
            if (this[_loc3] instanceof MovieClip)
            {
                this[_loc3].hDefault = this[_loc3]._height;
            } // end if
        } // end of for...in
    } // End of the function
    function setTime(val)
    {
        time = val;
    } // End of the function
    function setHeight(val)
    {
        h = val;
    } // End of the function
    function play()
    {
        _on = true;
        for (var _loc2 in this)
        {
            if (this[_loc2] instanceof MovieClip)
            {
                this.run(this[_loc2]);
            } // end if
        } // end of for...in
    } // End of the function
    function stop()
    {
        _on = false;
        for (var _loc3 in this)
        {
            if (this[_loc3] instanceof MovieClip)
            {
                _global.clearTimeout(this[_loc3].intRun);
                this.tween(this[_loc3], 200, 2);
            } // end if
        } // end of for...in
    } // End of the function
    function reset()
    {
        _on = false;
        for (var _loc3 in this)
        {
            if (this[_loc3] instanceof MovieClip)
            {
                _global.clearTimeout(this[_loc3].intRun);
                animator.stopTweenClip(this[_loc3]);
                this[_loc3]._height = this[_loc3].hDefault;
            } // end if
        } // end of for...in
    } // End of the function
    function run(clip)
    {
        _global.clearTimeout(clip.intRun);
        var _loc4 = 50 + Math.random() * time;
        var _loc5 = 2 + Math.random() * h;
        this.tween(clip, _loc4, _loc5);
        clip.intRun = _global.setTimeout(this, "run", _loc4 * 1.400000E+000, clip);
    } // End of the function
    function tween(clip, tt, hh)
    {
        animator.tween(clip, "_height", clip._height, hh, tt, "Linear", "easeNone");
    } // End of the function
    function onUnload()
    {
        for (var _loc3 in this)
        {
            if (this[_loc3] instanceof MovieClip)
            {
                _global.clearTimeout(this[_loc3].intRun);
            } // end if
        } // end of for...in
        animator.stopAllTweens(this);
    } // End of the function
    var h = 25;
    var time = 250;
} // End of Class
