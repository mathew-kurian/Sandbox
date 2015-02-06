class com.oop.loaders.ContentLoader
{
    var mcl_Listener, mcl;
    function ContentLoader()
    {
    } // End of the function
    function load(file, place, bar, info, tag)
    {
        bar._loaded = false;
        info._loaded = false;
        place._loaded = false;
        place._parent._loaded = false;
        place.mcl = new MovieClipLoader();
        place.mcl_Listener = new Object();
        place.mcl_Listener.onLoadProgress = function (target, bytesLoaded, bytesTotal)
        {
            if (bar != undefined)
            {
                bar.loading._xscale = bytesLoaded / bytesTotal * 100;
            } // end if
            if (info != undefined)
            {
                info.write.htmlText = "<" + (tag || "percent") + ">" + (Math.ceil(bytesLoaded / bytesTotal * 100) || 0) + "%</" + (tag || "percent") + ">";
            } // end if
        };
        place.mcl.addListener(place.mcl_Listener);
        place.mcl.loadClip(file, place);
        place.mcl_Listener.mcl = place.mcl;
        place.mcl_Listener.mcl_listener = place.mcl_Listener;
        place.mcl_Listener.owner = this;
        place.mcl_Listener.onLoadInit = function ()
        {
            place._loaded = true;
            bar._loaded = true;
            place._parent._loaded = true;
            info._loaded = true;
            mcl.removeListener(mcl_Listener);
            delete mcl_Listener.onLoadInit;
            delete mcl_Listener.onLoadProgress;
            delete this.mcl;
            delete this.mcl_Listener;
            mcl_Listener = new Object();
        };
    } // End of the function
} // End of Class
