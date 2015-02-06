class com.oop.data.XmlDatum
{
    var datum, items, owner, firstChild, _xscale, onEnterFrame;
    function XmlDatum()
    {
        datum = new XML();
        datum.ignoreWhite = true;
    } // End of the function
    function itemFinder(n)
    {
        for (var _loc3 in items)
        {
            if (items[_loc3].nodeName == n)
            {
                return (items[_loc3]);
            } // end if
        } // end of for...in
    } // End of the function
    function loadDatum(file, bar, info)
    {
        datum.owner = this;
        datum.onLoad = function (success)
        {
            if (success)
            {
                owner.items = firstChild.childNodes;
                owner.title = firstChild.attributes.title;
                owner.description = firstChild.attributes.description;
                owner.img = firstChild.attributes.img;
                owner.reference = firstChild.nodeName;
                owner._loaded = true;
                bar._loaded = true;
                info._loaded = true;
                _root.interfaz.displayDatum(firstChild.nodeName, firstChild.attributes.title);
            }
            else
            {
                trace ("error");
            } // end else if
        };
        datum.load(file);
        if (bar)
        {
            bar.loading.datum = datum;
            bar.loading.onEnterFrame = function ()
            {
                updateAfterEvent();
                var _loc2 = datum;
                _xscale = _loc2.getBytesLoaded() / _loc2.getBytesTotal() * 100;
                if (_loc2.getBytesLoaded() == _loc2.getBytesTotal())
                {
                    delete this.onEnterFrame;
                } // end if
            };
        } // end if
        if (info)
        {
            info.datum = datum;
            info.onEnterFrame = function ()
            {
                updateAfterEvent();
                var _loc2 = datum;
                info.write.htmlText = "<percent>" + (Number(Math.ceil(_loc2.getBytesLoaded() / _loc2.getBytesTotal() * 100)) || 0) + "%</percent>";
                if (_loc2.getBytesLoaded() == _loc2.getBytesTotal())
                {
                    delete this.onEnterFrame;
                } // end if
            };
        } // end if
    } // End of the function
    var _loaded = false;
} // End of Class
