
// -----------------------------------------------------------------------------
// Include
// -----------------------------------------------------------------------------

var models = {};
var callsite = require('callsite');
var path = require('path');

global.attach = function(nickname, model) {
    models[nickname] = path.normalize(path.join(path.dirname(callsite()[1].getFileName()), model));
    console.info("Attached `" + nickname + "` to " + models[nickname]);
};

global.include = function(nickname) {

    console.info("Including `" + nickname + "`");

    try { if(nickname.substring(0, 2) === "./")
            nickname = nickname.substring(2);
    } catch(e){}

    var directPath = path.normalize(path.join(path.dirname(callsite()[1].getFileName()), nickname));

    if (typeof models[nickname] === 'undefined') 
        try { return require(nickname);
                } catch(e) {
                    try { return require(directPath);
                    } catch(e){ throw new RangeError(nickname + " - could not find submodule. More details: /n" + arguments.callee.caller.toString());
                    }
                }

    return require(models[nickname]);
};
