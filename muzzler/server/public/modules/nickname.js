
/*
 * 
 * Nickname.js
 * @author Mathew Kurian
 * 
 * From Nickname.js v1.0
 *
 * Please report any issues
 * https://github.com/bluejamesbond/Nickname.js/issues
 * 
 * Date: 4/19/2014
 * Protected under Apache V2 License
 * 
 */

(function(ctx){
    
    var exports = {};
    var libs = {};

    exports.attach = function(nickname, model){
        libs[nickname] = model;
    };

    ctx.require = function(nickname){
        if(typeof libs[nickname] === 'undefined')
           throw new RangeError(nickname + " - could not find submodule.");
        else if (typeof libs[nickname] === 'function')
            return libs[nickname]();
        else return libs[nickname];
    };

    ctx.Nickname = exports;

})(window);

