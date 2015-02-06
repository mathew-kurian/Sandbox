class com.Background extends com.oop.loaders.ContentLoader
{
    var time, pattern, _holder, bar_temp, bg, bg_isImage, bgOwner, bgDefault, _mask, bgDefault_isImage, load;
    function Background()
    {
        super();
        time = 500;
        pattern = new com.oop.data.Pattern();
        _holder = _root.createEmptyMovieClip("bg", 0);
    } // End of the function
    function setTime(n)
    {
        time = n;
    } // End of the function
    function addBar()
    {
        bar_temp = _holder.attachMovie("bgloader_mc", "ld" + _holder.getNextHighestDepth(), _holder.getNextHighestDepth());
        bar_temp._width = Stage.width - 40;
        bar_temp._x = 10;
        bar_temp._y = 10;
    } // End of the function
    function addPattern(file, bar, info, w, h)
    {
        this.clean();
        if (bar == undefined && info == undefined)
        {
            this.addBar();
        } // end if
        bg = _holder.createEmptyMovieClip("bg" + _holder.getNextHighestDepth(), _holder.getNextHighestDepth());
        bg._alpha = 0;
        bg_isImage = false;
        pattern.load(file || fileDefault, bg, w || Stage.width, h || Stage.height, bar_temp || bar, info);
        bg._holder.mcl_Listener.bgOwner = this;
        bg._holder.mcl_Listener.onLoadComplete = function ()
        {
            bgOwner.seePattern();
        };
    } // End of the function
    function clean()
    {
        for (var _loc2 in _holder)
        {
            if (_holder[_loc2] instanceof MovieClip)
            {
                if (_holder[_loc2] != bgDefault)
                {
                    _holder[_loc2].removeMovieClip();
                } // end if
            } // end if
        } // end of for...in
    } // End of the function
    function seePattern()
    {
        this.setMask();
        bg._visible = true;
        bg._alpha = 100;
        new com.oop.core.Watcher(_mask, "end", true, this, "remove", bgDefault);
        bgDefault = bg;
        bgDefault_isImage = bg_isImage;
    } // End of the function
    function remove(clip)
    {
        pattern.remove(clip);
        clip.removeMovieClip();
        bar_temp.removeMovieClip();
        bar_temp = undefined;
        this.resize();
    } // End of the function
    function resize(w, h)
    {
        _mask._width = Stage.width;
        _mask._height = Stage.height;
        if (bg_isImage)
        {
            this.center(bg);
        }
        else
        {
            pattern.resize(bg, w || Stage.width, h || Stage.height);
        } // end else if
        if (bg != bgDefault)
        {
            if (bgDefault_isImage)
            {
                this.center(bgDefault);
            }
            else
            {
                pattern.resize(bgDefault, w || Stage.width, h || Stage.height);
            } // end if
        } // end else if
    } // End of the function
    function addImage(file, bar, info)
    {
        if (bar == undefined && info == undefined)
        {
            this.addBar();
        } // end if
        bg = _holder.createEmptyMovieClip("bg" + _holder.getNextHighestDepth(), _holder.getNextHighestDepth());
        bg._alpha = 0;
        bg_isImage = true;
        this.load(file || fileDefault, bg, bar, info);
        new com.oop.core.Watcher(_holder, "_loaded", true, this, "seeImage");
    } // End of the function
    function setMask()
    {
        _mask = _root.attachMovie("mask_bg", "mask_bg", 1);
        _mask._width = Stage.width;
        _mask._height = _mask._height * _mask._xscale / 100;
        bg.setMask(_mask);
    } // End of the function
    function seeImage()
    {
        this.setMask();
        _holder.unwatch("_loaded");
        this.center(bg);
        bg._alpha = 100;
        new com.oop.core.Watcher(_mask, "end", true, this, "remove", bgDefault);
        bgDefault = bg;
        bgDefault_isImage = bg_isImage;
    } // End of the function
    function center(clip)
    {
        clip._x = (Stage.width - clip._width) / 2;
        clip._y = (Stage.height - clip._height) / 2;
    } // End of the function
    var fileDefault = "img/pattern_default.gif";
} // End of Class
