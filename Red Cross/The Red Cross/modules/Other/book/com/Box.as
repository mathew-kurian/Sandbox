class com.Box extends MovieClip
{
    var myself, animator, colorT, blurT, delayF, loader, mask, view, bar, scroll, border, bg, _top, _left, _right, _bottom, _displace, shadow, _x, xDefault, _y, yDefault, _width, wDefault, _height, hDefault, _xscale, _yscale, _visible;
    function Box()
    {
        super();
        myself = this;
        animator = new com.oop.animation.Animator();
        colorT = new com.oop.animation.transitions.ColorTransition();
        blurT = new com.oop.animation.transitions.BlurTransition();
        delayF = 1 + animator.defaultIntervalTime / 100;
        loader = new com.oop.loaders.ContentLoader();
        this.defaultPropertys();
        blurT.addFormat("view", {blurX: 15, blurY: 15, quality: 3});
        blurT.addFormat("rollOver", {blurX: 7, blurY: 7, quality: 3});
        colorT.addFormat("white", {ra: 1, rb: 255, ga: 1, gb: 255, ba: 1, bb: 255, aa: 1, ab: 0});
        scroll = new com.oop.utils.Scroll(bar, view, mask);
    } // End of the function
    function defaultPropertys()
    {
        this.setMargins(10, 10, 10, 10, -2);
        this.setColors("#ffffff", "#cccccc");
        bar.slider._visible = false;
        bar._visible = false;
        this.setSize(60, 60);
    } // End of the function
    function setColors(cB, cBg, cBar)
    {
        if (cB)
        {
            colorT.applyHex(border, cB, 100);
            colorT.init(border);
        } // end if
        if (cBg)
        {
            colorT.applyHex(bg, cBg, 100);
            colorT.init(bg);
        } // end if
        if (cBar)
        {
            colorT.applyHex(bar.slider, cBar, 100);
            colorT.init(bar.slider);
        } // end if
    } // End of the function
    function setMargins(t, l, b, r, s)
    {
        _top = t;
        _left = l;
        _right = r;
        _bottom = b;
        _displace = s;
        view._x = l;
        view._y = t;
        bar._x = mask._x = l;
        bar._y = mask._y = t;
        bg._x = l;
        bg._y = t;
        shadow._x = s;
        shadow._y = -s;
        shadow._visible = s == 0 || s == undefined ? (false) : (true);
        bg._width = mask._width = border._width - _left - _right;
        bar.bg._height = bg._height = mask._height = border._height - _top - _bottom;
        bar._x = border._width - _right - bar._width;
        bar._y = bg._y;
    } // End of the function
    function setDefault(x, y, w, h)
    {
        xDefault = x ? (x) : (_x);
        yDefault = y ? (y) : (_y);
        wDefault = w ? (w) : (_width);
        hDefault = h ? (h) : (_height);
    } // End of the function
    function setScale(s)
    {
        _xscale = s;
        _yscale = s;
    } // End of the function
    function setSize(w, h)
    {
        if (w == undefined)
        {
            w = view._width + _left + _right;
        } // end if
        if (h == undefined)
        {
            h = view._height + _top + _bottom;
        } // end if
        shadow._height = border._height = h;
        bg._height = mask._height = h - (_bottom + _top);
        shadow._width = border._width = w;
        bg._width = mask._width = w - (_right + _left);
        bar.bg._height = bg._height - 6;
        bar._x = border._width - _right - bar._width - 3;
        bar._y = bg._y + 3;
    } // End of the function
    function resizeW(delay, time, _class, _function, val)
    {
        if (val == undefined)
        {
            val = view._width + _left + _right;
        } // end if
        _global.clearTimeout(mask.int_width);
        _global.clearTimeout(bg.int_width);
        _global.clearTimeout(border.int_width);
        _global.clearTimeout(shadow.int_width);
        mask.int_width = _global.setTimeout(this, "tween", delay * delayF, mask, "_width", val - _right - _left, time, _class, _function);
        bg.int_width = _global.setTimeout(this, "tween", delay * delayF, bg, "_width", val - _right - _left, time, _class, _function);
        border.int_width = _global.setTimeout(this, "tween", delay * delayF, border, "_width", val, time, _class, _function);
        shadow.int_width = _global.setTimeout(this, "tween", delay * delayF, shadow, "_width", val, time, _class, _function);
        bar.int_x = _global.setTimeout(this, "tween", delay * delayF, bar, "_x", val - _right - bar._width, time, _class, _function);
    } // End of the function
    function resizeH(delay, time, _class, _function, val)
    {
        if (val == undefined)
        {
            val = view._height + _top + _bottom;
        } // end if
        _global.clearTimeout(mask.int_height);
        _global.clearTimeout(bg.int_height);
        _global.clearTimeout(border.int_height);
        _global.clearTimeout(shadow.int_height);
        _global.clearTimeout(bar.bg.int_height);
        mask.int_height = _global.setTimeout(this, "tween", delay * delayF, mask, "_height", val - _bottom - _top, time, _class, _function);
        bg.int_height = _global.setTimeout(this, "tween", delay * delayF, bg, "_height", val - _bottom - _top, time, _class, _function);
        border.int_height = _global.setTimeout(this, "tween", delay * delayF, border, "_height", val, time, _class, _function);
        shadow.int_height = _global.setTimeout(this, "tween", delay * delayF, shadow, "_height", val, time, _class, _function);
        bar.bg.int_height = _global.setTimeout(this, "tween", delay * delayF, bar.bg, "_height", val - _bottom - _top, time, _class, _function);
    } // End of the function
    function moveX(delay, time, _class, _function, val, center)
    {
        if (val == undefined)
        {
            val = xDefault;
        } // end if
        this.tweenBox(delay, "_x", val, time, _class, _function, center);
    } // End of the function
    function moveY(delay, time, _class, _function, val, center)
    {
        if (val == undefined)
        {
            val = yDefault;
        } // end if
        this.tweenBox(delay, "_y", val, time, _class, _function, center);
    } // End of the function
    function rotate(delay, time, _class, _function, val, center)
    {
        if (val == undefined)
        {
            val = yDefault;
        } // end if
        this.tweenBox(delay, "_rotation", val, time, _class, _function, center);
    } // End of the function
    function fade(delay, time, _class, _function, val)
    {
        this.tweenBox(delay, "_alpha", val, time, _class, _function);
    } // End of the function
    function scale(delay, time, _class, _function, val)
    {
        this.tweenBox(delay, "_xscale", val, time, _class, _function);
        this.tweenBox(delay, "_yscale", val, time, _class, _function);
    } // End of the function
    function blurOut(delay, time, _class, _function, format)
    {
        _global.setTimeout(blurT, "applyF", delay * delayF, view, "_default", format || "rollOver");
        if (!view.filters[0])
        {
            _global.setTimeout(blurT, "init", delay * delayF, view);
        } // end if
        _global.setTimeout(blurT, "end", delay * delayF, view, _class, _function, time);
    } // End of the function
    function blurIn(delay, time, _class, _function, format)
    {
        _global.setTimeout(blurT, "applyF", delay * delayF, view, format || "rollOver");
        if (!view.filters[0])
        {
            _global.setTimeout(blurT, "init", delay * delayF, view);
        } // end if
        _global.setTimeout(blurT, "start", delay * delayF, view, _class, _function, time);
    } // End of the function
    function transOut(delay, time, _class, _function)
    {
        this.blurOut(delay * delayF, time, _class, _function, "view");
        this.tweenView(delay * delayF, "_alpha", 0, time, _class, _function);
        _global.setTimeout(this, "clean", (time + delay) * delayF);
        _global.setTimeout(blurT, "remove", (time + delay) * delayF, view);
    } // End of the function
    function transIn(delay, time, _class, _function)
    {
        this.blurIn(delay * delayF, time, _class, _function, "view");
        this.tweenView(delay * delayF, "_alpha", 100, time, _class, _function);
        _global.setTimeout(blurT, "remove", (time + delay) * delayF, view);
    } // End of the function
    function colorOut(delay, time, _class, _function, clip, format)
    {
        clip = clip || this;
        _global.setTimeout(colorT, "applyF", delay, clip, "_default", format || "white");
        _global.setTimeout(colorT, "end", delay * delayF, clip, _class, _function, time);
    } // End of the function
    function colorIn(delay, time, _class, _function, clip, format)
    {
        clip = clip || this;
        _global.setTimeout(colorT, "applyF", delay, clip, format || "white");
        _global.setTimeout(colorT, "start", delay * delayF, clip, _class, _function, time);
    } // End of the function
    function tween(clip, prop, val, time, _class, _function)
    {
        animator.tween(clip, prop, clip[prop], val, time, _class, _function);
    } // End of the function
    function tweenBox(delay, prop, val, time, _class, _function)
    {
        set("int" + prop, _global.setTimeout(this, "tween", delay * delayF, this, prop, val, time, _class, _function));
    } // End of the function
    function tweenView(delay, prop, val, time, _class, _function)
    {
        view["int" + prop] = _global.setTimeout(this, "tween", delay * delayF, view, prop, val, time, _class, _function);
    } // End of the function
    function tweenMask(delay, prop, val, time, _class, _function, initVal)
    {
        if (initVal == undefined)
        {
            initVal = mask[prop];
        } // end if
        mask["int" + prop] = _global.setTimeout(animator, "tween", delay * delayF, mask, prop, initVal, val, time, _class, _function);
    } // End of the function
    function visible(n)
    {
        _visible = n || false;
    } // End of the function
    function _enabled(clip, n)
    {
        clip.enabled = n || false;
    } // End of the function
    function setScroll(n)
    {
        if (n)
        {
            bar._visible = true;
            scroll.init();
        }
        else
        {
            bar._visible = false;
            scroll.stop();
        } // end else if
    } // End of the function
    function frost(clip)
    {
        if (clip)
        {
            colorT.stopTweenClip(clip);
            blurT.stopTweenClip(clip);
            animator.stopTweenClip(clip);
        }
        else
        {
            colorT.stopAllTweens(this);
            blurT.stopAllTweens(this);
            animator.stopAllTweens(this);
        } // end else if
    } // End of the function
    function clean()
    {
        blurT.remove(view);
        colorT.remove(view);
        for (var _loc2 in view)
        {
            if (view[_loc2] instanceof MovieClip)
            {
                this.frost(view[_loc2]);
                view[_loc2].removeMovieClip();
            } // end if
        } // end of for...in
    } // End of the function
    function onUnload()
    {
        this.frost();
        this.clean();
    } // End of the function
} // End of Class
