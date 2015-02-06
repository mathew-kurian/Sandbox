class com.oop.utils.Scroll
{
    var bar, view, mask, animator, off, hScroll, yScroll, _parent, _height, startDrag, stopDrag, owner;
    function Scroll(b, v, m)
    {
        bar = b;
        view = v;
        mask = m;
        animator = new com.oop.animation.Animator();
        off = true;
    } // End of the function
    function init()
    {
        hScroll = view._height;
        yScroll = bar.slider._y = 0;
        animator = new com.oop.animation.Animator();
        bar.slider._visible = true;
        bar.slider._y = 0;
        bar.owner = this;
        bar.onEnterFrame = _onEnterFrame;
        bar.slider.onPress = function ()
        {
            this.startDrag(false, 0, 0, 0, _parent.bg._height - _height);
        };
        bar.slider.onMouseUp = function ()
        {
            this.stopDrag();
        };
        bar.bg.onPress = function ()
        {
            var _loc2 = _parent.slider;
            if (_parent._ymouse < _loc2._height)
            {
                _loc2._y = 0;
            }
            else if (_parent._ymouse > _height - _loc2._height)
            {
                _loc2._y = _parent._ymouse - _loc2._height;
            }
            else
            {
                _loc2._y = _parent._ymouse - _loc2._height / 2;
            } // end else if
        };
        this.testScrollView();
        off = false;
    } // End of the function
    function _onEnterFrame()
    {
        with (this.owner)
        {
            if (hScroll != view._height)
            {
                testScrollView();
            } // end if
            if (yScroll != bar.slider._y)
            {
                scrollView();
            } // end if
        } // End of with
    } // End of the function
    function stop()
    {
        delete bar.onEnterFrame;
        bar.slider._visible = false;
        bar.slider._y = 0;
        off = true;
    } // End of the function
    function setTo(y)
    {
        if (!off)
        {
            bar.slider.onMouseUp();
            delete bar.onEnterFrame;
            animator.stopTweenClip(bar);
            if (y != undefined)
            {
                yScroll = bar.slider._y = y;
            } // end if
            view._y = mask._y - this.getY();
            bar.onEnterFrame = _onEnterFrame;
        } // end if
    } // End of the function
    function getY()
    {
        return (bar.slider._y * (view._height - mask._height) / (bar.bg._height - bar.slider._height));
    } // End of the function
    function scrollView()
    {
        var _loc2 = this.getY();
        animator.tween(view, "_y", view._y, mask._y - _loc2, 500, "Quad", "easeOut");
        yScroll = bar.slider._y;
    } // End of the function
    function testScrollView()
    {
        if (mask._height < view._height)
        {
            bar.slider._y = 0;
            bar.slider._visible = true;
            bar.slider._height = bar._height / 5;
            bar.bg.enabled = true;
            hScroll = view._height;
        }
        else
        {
            bar.slider._visible = false;
            bar.bg.enabled = false;
            bar.slider._y = 0;
        } // end else if
    } // End of the function
} // End of Class
