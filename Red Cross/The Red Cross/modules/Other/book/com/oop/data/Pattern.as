class com.oop.data.Pattern extends com.oop.loaders.ContentLoader
{
    var __patterns, mcl_listener, mcl, mcl_Listener, owner;
    function Pattern()
    {
        super();
        __patterns = new Object();
    } // End of the function
    function load(file, place, w, h, bar, info)
    {
        var _loc3 = place.createEmptyMovieClip("_holder", place.getNextHighestDepth());
        super.load(file, _loc3, bar, info);
        _loc3.mcl_Listener.onLoadInit = function (target)
        {
            bar._loaded = true;
            info._loaded = true;
            mcl.removeListener(mcl_listener);
            delete mcl_Listener.onLoadInit;
            delete mcl_Listener.onLoadProgress;
            delete this.mcl;
            delete this.mcl_Listener;
            owner.apply(target, place, w, h);
        };
    } // End of the function
    function attach(attachment, place, w, h)
    {
        var _loc2 = place.attachMovie(attachment, "_holder", place.getNextHighestDepth());
        _loc2.mcl_Listener.owner = this;
        _loc2.mcl_Listener.onLoadInit = function (target)
        {
            owner.apply(target, place, w, h);
        };
    } // End of the function
    function apply(clipToDraw, clip, w, h)
    {
        clip.pattern = new flash.display.BitmapData(clipToDraw._width, clipToDraw._height, true);
        clip.pattern.draw(clipToDraw);
        clipToDraw.removeMovieClip();
        this.resize(clip, w, h);
    } // End of the function
    function resize(clip, w, h)
    {
        clip.clear();
        clip.beginBitmapFill(clip.pattern);
        clip.moveTo(0, 0);
        clip.lineTo(w, 0);
        clip.lineTo(w, h);
        clip.lineTo(0, h);
        clip.lineTo(0, 0);
        clip.endFill();
    } // End of the function
    function remove(clip)
    {
        clip.pattern.dispose();
    } // End of the function
} // End of Class
