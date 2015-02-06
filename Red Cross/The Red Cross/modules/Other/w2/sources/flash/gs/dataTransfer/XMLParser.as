class gs.dataTransfer.XMLParser
{
    var parse, _results_obj, _url_str, _onComplete_func, _xml;
    static var _parsers_array, __get__active_boolean;
    function XMLParser()
    {
        parse = initLoad;
        if (gs.dataTransfer.XMLParser._parsers_array == undefined)
        {
            _parsers_array = [];
        } // end if
        gs.dataTransfer.XMLParser._parsers_array.push(this);
    } // End of the function
    static function load(url_str, onComplete_func, results_obj)
    {
        var _loc1 = new gs.dataTransfer.XMLParser();
        _loc1.initLoad(url_str, onComplete_func, results_obj);
        return (_loc1);
    } // End of the function
    static function sendAndLoad(toSend_obj, url_str, onComplete_func, results_obj)
    {
        var _loc1 = new gs.dataTransfer.XMLParser();
        _loc1.initSendAndLoad(toSend_obj, url_str, onComplete_func, results_obj);
        return (_loc1);
    } // End of the function
    function initLoad(url_str, onComplete_func, results_obj)
    {
        if (results_obj == undefined)
        {
            results_obj = {};
        } // end if
        _results_obj = results_obj;
        _url_str = url_str;
        _onComplete_func = onComplete_func;
        _xml = new XML();
        _xml.ignoreWhite = true;
        _xml.onLoad = mx.utils.Delegate.create(this, parseLoadedXML);
        _xml.load(_url_str);
    } // End of the function
    function initSendAndLoad(toSend_obj, url_str, onComplete_func, results_obj)
    {
        if (results_obj == undefined)
        {
            results_obj = {};
        } // end if
        _results_obj = results_obj;
        _url_str = url_str;
        _onComplete_func = onComplete_func;
        if (toSend_obj instanceof XML)
        {
            var _loc2 = toSend_obj;
        }
        else
        {
            _loc2 = gs.dataTransfer.XMLParser.objectToXML(toSend_obj);
        } // end else if
        _xml = new XML();
        _xml.ignoreWhite = true;
        _xml.onLoad = mx.utils.Delegate.create(this, parseLoadedXML);
        _loc2.sendAndLoad(_url_str, _xml);
    } // End of the function
    function searchAndReplace(holder, searchfor, replacement)
    {
        var _loc1 = holder.split(searchfor);
        holder = _loc1.join(replacement);
        return (holder);
    } // End of the function
    function parseLoadedXML(success_boolean)
    {
        if (success_boolean == false)
        {
            trace ("XML FAILED TO LOAD! (" + _url_str + ")");
            this._onComplete_func(false);
            return;
        } // end if
        var _loc9 = _xml;
        _root.xmlNodes = _loc9;
        var _loc3 = _loc9.firstChild.firstChild;
        var _loc8 = _loc9.firstChild.lastChild;
        _loc9.firstChild.obj = _results_obj;
        while (_loc3 != undefined)
        {
            if (_loc3.nodeName == null && _loc3.nodeType == 3)
            {
                _loc3.parentNode.obj.value = this.searchAndReplace(_loc3.nodeValue, "\r\n", "");
            }
            else
            {
                var _loc5 = {};
                for (var _loc7 in _loc3.attributes)
                {
                    _loc5[_loc7] = _loc3.attributes[_loc7];
                } // end of for...in
                var _loc6 = _loc3.parentNode.obj;
                if (_loc6[_loc3.nodeName] == undefined)
                {
                    _loc6[_loc3.nodeName] = [];
                } // end if
                _loc3.obj = _loc5;
                _loc6[_loc3.nodeName].push(_loc5);
            } // end else if
            if (_loc3.childNodes.length > 0)
            {
                _loc3 = _loc3.childNodes[0];
                continue;
            } // end if
            for (var _loc4 = _loc3; _loc4.nextSibling == undefined && _loc4.parentNode != undefined; _loc4 = _loc4.parentNode)
            {
            } // end of for
            _loc3 = _loc4.nextSibling;
            if (_loc4 == _loc8)
            {
                _loc3 = undefined;
            } // end if
        } // end while
        this._onComplete_func(true, _results_obj, _loc9);
    } // End of the function
    static function objectToXML(o, rootNodeName_str)
    {
        if (rootNodeName_str == undefined)
        {
            rootNodeName_str = "XML";
        } // end if
        var _loc7 = new XML();
        var _loc4 = _loc7.createElement(rootNodeName_str);
        var _loc5 = [];
        var _loc1;
        for (var _loc3 in o)
        {
            _loc5.push(_loc3);
        } // end of for...in
        for (var _loc3 = _loc5.length - 1; _loc3 >= 0; --_loc3)
        {
            _loc1 = _loc5[_loc3];
            if (typeof(o[_loc1]) == "object" && o[_loc1].length > 0)
            {
                gs.dataTransfer.XMLParser.arrayToNodes(o[_loc1], _loc4, _loc7, _loc1);
                continue;
            } // end if
            if (_loc1 == "value")
            {
                var _loc6 = _loc7.createTextNode(o.value);
                _loc4.appendChild(_loc6);
                continue;
            } // end if
            _loc4.attributes[_loc1] = o[_loc1];
        } // end of for
        _loc7.appendChild(_loc4);
        return (_loc7);
    } // End of the function
    static function arrayToNodes(ar, parentNode, xml, nodeName_str)
    {
        var _loc9 = [];
        var _loc5;
        var _loc1;
        var _loc4;
        var _loc2;
        for (var _loc8 = ar.length - 1; _loc8 >= 0; --_loc8)
        {
            _loc4 = xml.createElement(nodeName_str);
            _loc2 = ar[_loc8];
            _loc5 = [];
            for (var _loc3 in _loc2)
            {
                _loc5.push(_loc3);
            } // end of for...in
            for (var _loc3 = _loc5.length - 1; _loc3 >= 0; --_loc3)
            {
                _loc1 = _loc5[_loc3];
                if (typeof(_loc2[_loc1]) == "object" && _loc2[_loc1].length > 0)
                {
                    gs.dataTransfer.XMLParser.arrayToNodes(_loc2[_loc1], _loc4, xml, _loc1);
                    continue;
                } // end if
                if (_loc1 != "value")
                {
                    _loc4.attributes[_loc1] = _loc2[_loc1];
                    continue;
                } // end if
                var _loc6 = xml.createTextNode(_loc2.value);
                _loc4.appendChild(_loc6);
            } // end of for
            _loc9.push(_loc4);
        } // end of for
        for (var _loc8 = _loc9.length - 1; _loc8 >= 0; --_loc8)
        {
            parentNode.appendChild(_loc9[_loc8]);
        } // end of for
    } // End of the function
    function destroy()
    {
        delete this._xml;
        for (var _loc2 = 0; _loc2 < gs.dataTransfer.XMLParser._parsers_array.length; ++_loc2)
        {
            if (this == gs.dataTransfer.XMLParser._parsers_array[_loc2])
            {
                gs.dataTransfer.XMLParser._parsers_array.splice(_loc2, 1);
            } // end if
        } // end of for
        gs.dataTransfer.XMLParser.destroyInstance(this);
    } // End of the function
    static function destroyInstance(i)
    {
        false;
    } // End of the function
    static function get active_boolean()
    {
        if (gs.dataTransfer.XMLParser._parsers_array.length > 0)
        {
            return (true);
        }
        else
        {
            return (false);
        } // end else if
    } // End of the function
    static var CLASS_REF = gs.dataTransfer.XMLParser;
} // end if