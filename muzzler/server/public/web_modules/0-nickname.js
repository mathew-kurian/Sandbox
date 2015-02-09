
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

    ctx.attach = function(nickname, model){
        libs[nickname] = model;
    };

    ctx.include = function(nickname){
        if(typeof libs[nickname] === 'undefined')
           throw new RangeError(nickname + " - could not find submodule.");
        else return libs[nickname];
    };

    ctx.Nickname = exports;

})(window);

