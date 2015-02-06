class com.oop.loaders.Preloader
{
    var bitmaps, list, endPath, endFunct, loader, loadsAtTime, imgsPH, preloaded, _percent, preloading, owner;
    function Preloader(lder, listI, ln, path, funct)
    {
        bitmaps = new Object();
        list = new Array();
        list = listI;
        endPath = path;
        endFunct = funct;
        loader = lder;
        loadsAtTime = ln || 1;
        loader.info.write.htmlText = "<percent>0%</percent>";
    } // End of the function
    function init()
    {
        imgsPH = _root.createEmptyMovieClip("imgsPH", _root.getNextHighestDepth());
        imgsPH._visible = false;
        preloaded = 0;
        _percent = 0;
        this.preload();
    } // End of the function
    function percent(val)
    {
        var _loc2 = Math.ceil(100 * (val + 1) / list.length);
        if (_loc2 > _percent)
        {
            _percent = _loc2;
        } // end if
        return (_percent);
    } // End of the function
    function preload()
    {
        var _loc4 = "";
        preloading = new Array();
        if (_percent < 100)
        {
            for (var _loc2 = 0; _loc2 < loadsAtTime; ++_loc2)
            {
                var _loc3 = imgsPH.createEmptyMovieClip("img" + preloaded, imgsPH.getNextHighestDepth());
                if (preloaded < list.length)
                {
                    this.load(list[preloaded], _loc3, preloaded);
                    preloading[_loc2] = preloaded++;
                } // end if
            } // end of for
            for (var _loc5 in preloading)
            {
                _loc4 = _loc4 + ("<loader>Loading  <loader_desc>... /" + list[preloading[_loc5]].toUpperCase() + "</loader_desc></loader>");
            } // end of for...in
            loader.msg.write.htmlText = _loc4;
        }
        else
        {
            this.end();
        } // end else if
    } // End of the function
    function testloadsAtTime(val)
    {
        var _loc2 = true;
        for (var _loc4 in preloading)
        {
            if (preloading[_loc4] == val)
            {
                preloading[_loc4] = undefined;
            } // end if
        } // end of for...in
        for (var _loc4 in preloading)
        {
            if (preloading[_loc4] != undefined)
            {
                _loc2 = false;
            } // end if
        } // end of for...in
        if (_loc2)
        {
            this.preload();
        } // end if
    } // End of the function
    function addbitmap(file, val)
    {
        bitmaps[file] = new Object();
        bitmaps[file].data = new flash.display.BitmapData(imgsPH["img" + val]._width, imgsPH["img" + val]._height, true);
        bitmaps[file].data.draw(imgsPH["img" + val]);
    } // End of the function
    function end()
    {
        imgsPH.removeMovieClip();
        list = new Array();
        endPath[endFunct]();
    } // End of the function
    function load(file, place, val)
    {
        place.mcl = new MovieClipLoader();
        place.mcl_Listener = new Object();
        place.mcl.addListener(place.mcl_Listener);
        place.mcl.loadClip(file, place);
        place.mcl_Listener.owner = this;
        place.mcl_Listener.onLoadInit = function ()
        {
            with (this.owner)
            {
                addbitmap(file, val);
                if (loader.info)
                {
                    loader.info.write.htmlText = "<percent>" + percent(val) + "%</percent>";
                } // end if
                if (loader.bar)
                {
                    loader.bar.loading._xscale = percent(val);
                } // end if
                testloadsAtTime(val);
            } // End of with
        };
    } // End of the function
} // End of Class
