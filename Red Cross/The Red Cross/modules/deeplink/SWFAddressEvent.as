class SWFAddressEvent
{
    var _type, _value, _path, _pathNames, _parameters, _parametersNames, __get__parameters, __get__parametersNames, __get__path, __get__pathNames, __get__target, __get__type, __get__value;
    function SWFAddressEvent(type)
    {
        _type = type;
        _value = SWFAddress.getValue();
        _path = SWFAddress.getPath();
        _pathNames = SWFAddress.getPathNames();
        _parameters = new Array();
        _parametersNames = SWFAddress.getParameterNames();
        for (var _loc2 = 0; _loc2 < _parametersNames.length; ++_loc2)
        {
            _parameters[_parametersNames[_loc2]] = SWFAddress.getParameter(_parametersNames[_loc2]);
        } // end of for
    } // End of the function
    function get type()
    {
        return (_type);
    } // End of the function
    function get target()
    {
        return (SWFAddress);
    } // End of the function
    function get value()
    {
        return (_value);
    } // End of the function
    function get path()
    {
        return (_path);
    } // End of the function
    function get pathNames()
    {
        return (_pathNames);
    } // End of the function
    function get parameters()
    {
        return (_parameters);
    } // End of the function
    function get parametersNames()
    {
        return (_parametersNames);
    } // End of the function
    static var INIT = "init";
    static var CHANGE = "change";
} // End of Class
