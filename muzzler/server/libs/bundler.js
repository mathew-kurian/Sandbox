
var fs = require('fs');
var path = require('path');
var compressor = require('node-minify');

exports.compactSync = function(folder, to){
    
    var files = fs.readdirSync(folder);
    var output = "";
    var data = {};
    var ordered = [];
    var css = to.indexOf('.css') > -1;
    var js = to.indexOf('.js') > -1;

    for(var i = 0; i < files.length; i++){
        var num = files[i].split('-')[0];
        data[num] = fs.readFileSync(path.join(folder, files[i]));
        ordered.push(parseFloat(num));
    }

    ordered.sort();

    for(var i = 0; i < ordered.length; i++)
        output += data[ordered[i].toString()]

    fs.writeFileSync(to, output, {
        'mode' : 0x0777
    });

    if(css || js){
        new compressor.minify({
            type: css ? 'yui-css' : 'uglifyjs',
            fileIn: to,
            fileOut: to.substring(0, to.lastIndexOf('.')) + '.min.' + (css ? 'css' : 'js'),
            callback: function(err, min){
                if(err) console.error(err);
            }
        });
    }
}