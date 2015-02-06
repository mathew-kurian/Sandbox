class tm.utils.XMLParser
{
	var _data, _url, _caller, _onCompleteCallback, _xml;
	function XMLParser () {
		_data = new Object();
	}
	function load(url, caller, callback, killCache) {
		_url = url;
		_caller = caller;
		_onCompleteCallback = callback;
		_xml = new XML();
		_xml.ignoreWhite = true;
		_xml.onLoad = tm.utils.Delegate.create(this, xmlLoadHandler);
		var _local2 = ((killCache == true) ? ("?cacheKiller=" + String(new Date().getTime())) : "");
		_xml.load(_url + _local2);
	}
	function xmlLoadHandler(success) {
		if (success) {
			var _local2 = _xml.firstChild.firstChild;
			var _local7 = _xml.firstChild.lastChild;
			_xml.firstChild.obj = _data;
			while (_local2) {
				if ((_local2.nodeName == null) && (_local2.nodeType == 3)) {
					_local2.parentNode.obj.value = tm.utils.Utils.searchAndReplace(_local2.nodeValue, "\r\n", "");
				} else {
					var _local4 = {};
					for (var _local6 in _local2.attributes) {
						_local4[_local6] = _local2.attributes[_local6];
					}
					var _local5 = _local2.parentNode.obj;
					if (_local5[_local2.nodeName] == undefined) {
						_local5[_local2.nodeName] = [];
					}
					_local2.obj = _local4;
					_local5[_local2.nodeName].push(_local4);
				}
				if (_local2.childNodes.length > 0) {
					_local2 = _local2.childNodes[0];
				} else {
					var _local3 = _local2;
					while ((_local3.nextSibling == undefined) && (_local3.parentNode != undefined)) {
						_local3 = _local3.parentNode;
					}
					_local2 = _local3.nextSibling;
					if (_local3 == _local7) {
						_local2 = undefined;
					}
				}
			}
			_onCompleteCallback.call(_caller, true, _data);
		} else {
			_onCompleteCallback.call(_caller, false);
		}
	}
}
