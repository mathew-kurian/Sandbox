
var path = require('path');
var toolkit = include('toolkit');
var mkdirp = include('mkdirp');
var path = include('path');
var fs = require('fs');

var cacheDirectory = global.__atomic_cache_dirname = path.join(__dirname, "cache");

exports.run = function(a, opts){
    
    opts = toolkit.safely(opts, {});
    
    toolkit.extend(opts, {
        'saveTo' : path.join(cacheDirectory, toolkit.guid()) 
    });

    toolkit.fire(require(path.join(__dirname, a)).run, opts);
}

var init = function(){
    mkdirp.sync(cacheDirectory, 0777 & (~process.umask()));
}

init();
