class com.mosesSupposes.fuse.FuseKitCommon
{
    static var logOutput;
    function FuseKitCommon()
    {
    } // End of the function
    static function _cts()
    {
        return ("|_tint|_tintPercent|_brightness|_brightOffset|_contrast|_invertColor|_colorReset|_colorTransform|");
    } // End of the function
    static function _underscoreable()
    {
        return (com.mosesSupposes.fuse.FuseKitCommon._cts() + "_frame|_x|_y|_xscale|_yscale|_scale|_width|_height|_size|_rotation|_alpha|_visible|");
    } // End of the function
    static function _cbprops()
    {
        return ("|skipLevel|cycles|easyfunc|func|scope|args|startfunc|startscope|startargs|updfunc|updscope|updargs|extra1|extra2|");
    } // End of the function
    static function _fuseprops()
    {
        return ("|command|label|delay|event|eventparams|target|addTarget|trigger|startAt|ease|easing|seconds|duration|time|");
    } // End of the function
    static function output(s)
    {
        if (typeof(com.mosesSupposes.fuse.FuseKitCommon.logOutput) == "function")
        {
            com.mosesSupposes.fuse.FuseKitCommon.logOutput(s);
        }
        else
        {
            trace (s);
        } // end else if
    } // End of the function
    static function error(errorCode)
    {
        var _loc3 = arguments[1];
        var _loc5 = arguments[2];
        var _loc6 = arguments[3];
        if (com.mosesSupposes.fuse.FuseKitCommon.VERBOSE != true)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("[FuseKitCommon#" + errorCode + "]");
            return;
        } // end if
        var _loc2 = "";
        var _loc4 = "\n";
        switch (errorCode)
        {
            case "001":
            {
                _loc2 = _loc2 + "** ERROR: When using simpleSetup to extend prototypes, you must pass the Shortcuts class. **";
                _loc2 = _loc2 + (_loc4 + " import com.mosesSupposes.fuse.*;");
                _loc2 = _loc2 + (_loc4 + " ZigoEngine.simpleSetup(Shortcuts);" + _loc4);
                break;
            } 
            case "002":
            {
                _loc2 = _loc2 + "** ZigoEngine.doShortcut: shortcuts missing. Use the setup commands: import com.mosesSupposes.fuse.*; ZigoEngine.register(Shortcuts); **";
                break;
            } 
            case "003":
            {
                _loc2 = _loc2 + (_loc4 + "*** Error: DO NOT use #include \"lmc_tween.as\" with this version of ZigoEngine! ***" + _loc4);
                break;
            } 
            case "004":
            {
                _loc2 = _loc2 + ("** ZigoEngine.doTween - too few arguments [" + _loc3 + "]. If you are trying to use Object Syntax without Fuse, pass FuseItem in your register() or simpleSetup() call. **");
                break;
            } 
            case "005":
            {
                _loc2 = _loc2 + ("** ZigoEngine.doTween - missing targets[" + _loc3 + "] and/or props[" + _loc5 + "] **");
                break;
            } 
            case "006":
            {
                _loc2 = _loc2 + ("** Error: easing shortcut string not recognized (\"" + _loc3 + "\"). You may need to pass the in PennerEasing class during register or simpleSetup. **");
                break;
            } 
            case "007":
            {
                _loc2 = _loc2 + ("- ZigoEngine: Target locked [" + _loc3 + "], ignoring tween call [" + _loc5 + "]");
                break;
            } 
            case "008":
            {
                _loc2 = _loc2 + "** ZigoEngine: You must register the Shortcuts class in order to use easy string-type callback parsing. **";
                break;
            } 
            case "009":
            {
                _loc2 = _loc2 + ("-ZigoEngine: A callback parameter \"" + _loc3 + "\" was not recognized.");
                break;
            } 
            case "010":
            {
                _loc2 = _loc2 + ("-Engine unable to parse " + (_loc3 == 1 ? ("callback[") : (String(_loc3) + " callbacks[")) + _loc5 + "]. Try using the syntax {scope:this, func:\"myFunction\"}");
                break;
            } 
            case "011":
            {
                _loc2 = _loc2 + ("-ZigoEngine: Callbacks discarded via skipLevel 2 option [" + _loc3 + "|" + _loc5 + "].");
                break;
            } 
            case "012":
            {
                _loc2 = _loc2 + ("-Engine set props or ignored no-change tween on: " + _loc3 + ", props passed:[" + _loc5 + "], endvals passed:[" + _loc6 + "]");
                break;
            } 
            case "013":
            {
                _loc2 = _loc2 + ("-Engine added tween on:\n\ttargets:[" + _loc3 + "]\n\tprops:[" + _loc5 + "]\n\tendvals:[" + _loc6 + "]");
                break;
            } 
            case "014":
            {
                _loc2 = _loc2 + "** Error: easing function passed is not usable with this engine. Functions need to follow the Robert Penner model. **";
                break;
            } 
            case "101":
            {
                _loc2 = _loc2 + "** ERROR: Fuse simpleSetup was removed in version 2.0! **";
                _loc2 = _loc2 + (_loc4 + " You must now use the following commands:");
                _loc2 = _loc2 + (_loc4 + _loc4 + "\timport com.mosesSupposes.fuse.*;");
                _loc2 = _loc2 + (_loc4 + "\tZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);");
                _loc2 = _loc2 + (_loc4 + "Note that PennerEasing is optional, and FuseFMP is also accepted. (FuseFMP.simpleSetup is run automatically if included.)" + _loc4);
                break;
            } 
            case "102":
            {
                _loc2 = _loc2 + ("** Fuse skipTo label not found: \"" + _loc3 + "\" **");
                break;
            } 
            case "103":
            {
                _loc2 = _loc2 + ("** Fuse skipTo failed (" + _loc3 + ") **");
                break;
            } 
            case "104":
            {
                _loc2 = _loc2 + ("** Fuse command skipTo (" + _loc3 + ")  ignored - targets the current index (" + _loc5 + "). **");
                break;
            } 
            case "105":
            {
                _loc2 = _loc2 + "** An unsupported Array method was called on Fuse. **";
                break;
            } 
            case "106":
            {
                _loc2 = _loc2 + "** ERROR: You have not set up Fuse correctly. **";
                _loc2 = _loc2 + (_loc4 + "You must now use the following commands (PennerEasing is optional).");
                _loc2 = _loc2 + (_loc4 + "\timport com.mosesSupposes.fuse.*;");
                _loc2 = _loc2 + (_loc4 + "\tZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);" + _loc4);
                break;
            } 
            case "107":
            {
                _loc2 = _loc2 + "** Fuse :: id not found - Aborting open(). **";
                break;
            } 
            case "108":
            {
                _loc2 = _loc2 + "** Fuse.startRecent: No recent Fuse found to start! **";
                break;
            } 
            case "109":
            {
                _loc2 = _loc2 + ("** Commands other than \"delay\" are not allowed within groups. Command discarded (\"" + _loc3 + "\")");
                break;
            } 
            case "110":
            {
                _loc2 = _loc2 + ("** A Fuse.addCommand parameter (\"" + _loc3 + "\") is not valid and was discarded. If you are trying to add a function-call try the syntax Fuse.addCommand(this,\"myCallback\",param1,param2); **");
                break;
            } 
            case "111":
            {
                _loc2 = _loc2 + ("** A Fuse command parameter failed. (\"" + _loc3 + "\") **");
                break;
            } 
            case "112":
            {
                _loc2 = _loc2 + "** Fuse: missing com.mosesSupposes.fuse.ZigoEngine! Cannot tween. **";
                break;
            } 
            case "113":
            {
                _loc2 = _loc2 + "** FuseItem: A callback has been discarded. Actions with a command may only contain: label, delay, scope, args. **";
                break;
            } 
            case "114":
            {
                _loc2 = _loc2 + ("** FuseItem: command (\"" + _loc3 + "\") discarded. Commands may not appear within action groups (arrays). **");
                break;
            } 
            case "115":
            {
                _loc2 = _loc2 + (_loc3 + " overlapping prop discarded: " + _loc5);
                break;
            } 
            case "116":
            {
                _loc2 = _loc2 + ("** FuseItem Error: Delays within groups (arrays) and start/update callbacks are not supported when using Fuse without ZigoEngine. Although you need to restructure your Fuse, it should be possible to achieve the same results. **" + _loc4);
                break;
            } 
            case "117":
            {
                _loc2 = _loc2 + ("** " + _loc3 + ": infinite cycles are not allowed within Fuses - discarded. **");
                break;
            } 
            case "118":
            {
                _loc2 = _loc2 + ("** Fuse Error: No targets in " + _loc3 + (_loc5 == true ? ("  [Unable to set start props] **") : ("  [Skipping this action] **")));
                break;
            } 
            case "119":
            {
                _loc2 = _loc2 + ("** Fuse warning: " + _loc5 + (_loc5 == 1 ? (" target missing in ") : (" targets missing in ")) + _loc6 + (_loc3 == true ? (" during setStartProps **") : (" **")));
                break;
            } 
            case "120":
            {
                _loc2 = _loc2 + ("** " + _loc3 + ": conflict with \"" + _loc5 + "\". Property might be doubled within a grouped-action array. **");
                break;
            } 
            case "121":
            {
                _loc2 = _loc2 + "** Timecode formatting requires \"00:\" formatting (example:\"01:01:33\" yields 61.33 seconds.) **";
                break;
            } 
            case "122":
            {
                _loc2 = _loc2 + "** FuseItem: You must register the Shortcuts class in order to use easy string-type callback parsing. **";
                break;
            } 
            case "123":
            {
                _loc2 = _loc2 + "** FuseItem unable to target callback. Try using the syntax {scope:this, func:\"myFunction\"} **";
                break;
            } 
            case "124":
            {
                _loc2 = _loc2 + ("** Event \"" + _loc3 + "\" reserved by Fuse. **");
                break;
            } 
            case "125":
            {
                _loc2 = _loc2 + ("** A Fuse event parameter failed in " + _loc3 + " **");
                break;
            } 
            case "126":
            {
                _loc2 = _loc2 + ("** " + _loc3 + ": trigger:" + _loc5 + " ignored - only one trigger is allowed per action **");
                break;
            } 
            case "201":
            {
                _loc2 = _loc2 + ("**** FuseFMP cannot initialize argument " + _loc3 + " (BitmapFilters cannot be applied to this object type) ****");
                break;
            } 
            case "301":
            {
                _loc2 = _loc2 + "** The shortcuts fadeIn or fadeOut only accept 3 arguments: seconds, ease, and delay. **";
            } 
        } // End of switch
        com.mosesSupposes.fuse.FuseKitCommon.output(_loc2);
    } // End of the function
    static var VERSION = "Fuse Kit 2.0 Copyright (c) 2006 Moses Gunesch, MosesSupposes.com under MIT Open Source License";
    static var VERBOSE = true;
    static var ALL = "ALL";
    static var ALLCOLOR = "ALLCOLOR";
} // End of Class
