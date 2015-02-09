
var toolkit = include('toolkit');
var codes = include('codes');
var normal = include('normal');
var Normalizer = normal.Normalizer;
var mkdirp = include('mkdirp');
var path = include('path');
var Emitter = include('emitter');
var fs = require('fs');

var self = exports;
var cacheDirectory = global.__search_cache_dirname = path.join(__dirname, "cache");
var types = {};

var ignored = ['music-hypemachine']
var _ignore = {};

exports.find = function(type, strategy, query, opts){
    return Emitter.__call__(function(_){
        require(path.join(__dirname, 'types', type, strategy)).find(query, toolkit.safely(opts, {}), _);
    });
}

exports.save = function(normalizer, opts){
    return Emitter.__call__(function(_){
        _.silence(['progress']);
        require(path.join(__dirname, 'types', normalizer.type, normalizer.strategy)).save(normalizer, toolkit.safely(opts, {}), _);
    });
}

exports.process = exports.save;

exports.strategies = function(type){
    return toolkit.safely(types[type], []);
}

var init = function(){

    mkdirp.sync(cacheDirectory, 0777 & (~process.umask()));
    
    var ignored = toolkit.safely(ignored, []);

    var typeDir = fs.readdirSync(path.join(__dirname, 'types'))

    for(var i = 0; i < typeDir.length; i++){

        var type = typeDir[i];
        var strategies = fs.readdirSync(path.join(__dirname, 'types', typeDir[i])).join(',').replace(/\.js/g, '').split(',');

        for(var x = 0; x < strategies.length; x++)
            if(ignored.indexOf(type + "-" + strategies[x]) > -1)
                strategies.splice(x--, 1);

        types[type] = strategies;
    }
}

init();
