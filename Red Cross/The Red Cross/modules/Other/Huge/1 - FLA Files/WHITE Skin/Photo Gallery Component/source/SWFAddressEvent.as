/**
 * SWFAddress 2.1: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

import SWFAddress;

class SWFAddressEvent {

    public static var INIT:String = 'init';
    public static var CHANGE:String = 'change';
        
    private var _type:String;
    private var _value:String;
    private var _path:String;
    private var _pathNames:Array;
    private var _parameters:Object;
    private var _parametersNames:Array;
    
    public function SWFAddressEvent(type:String) {
        _type = type;
        _value = SWFAddress.getValue();
        _path = SWFAddress.getPath();
        _pathNames = SWFAddress.getPathNames();
        _parameters = new Array();
        _parametersNames = SWFAddress.getParameterNames();
        for (var i:Number = 0; i < _parametersNames.length; i++) {
            _parameters[_parametersNames[i]] = SWFAddress.getParameter(_parametersNames[i]);
        }        
    }

    public function get type():String {
        return _type;
    }

    public function get target():Object {
        return SWFAddress;
    }

    public function get value():String {
        return _value;
    }

    public function get path():String {
        return _path;
    }

    public function get pathNames():Array {
        return _pathNames;
    }

    public function get parameters():Object {
        return _parameters;
    }

    public function get parametersNames():Array {
        return _parametersNames;
    }    
}