
var toolkit = include('toolkit');
var codes = include('codes');
var id3 = require('id3js');
var probe = require('node-ffprobe');
var safely = include('safely');
var ffmetadata = require("ffmetadata");
var fs = require("fs");

var normal = include('normal');
var Progress = normal.Progress;
var self = exports;

self.find = function(q, opts, _){
    
    if(!normal.validate(q)){
        console.error("Expecting normalizer in `q`");
        return _.emit("Expecting normalizer in `q`");
    }

    var normalizer = q;

    if(toolkit.isNaN(normalizer.filePath)){
        console.error("No valid filepath");
        return _.emit("No valid filepath not valid")
    }

    probe(normalizer.filePath, function(err, data) {
        if(!toolkit.isNaN(err) || !safely.attach(data)) {
            console.error(err);
            return _.emit('done', [normalizer]);
        }

        normalizer.set('title', data.safely('metadata>title'), '-s');
        normalizer.set('album', data.safely('metadata>album'), '-s');
        normalizer.set('artist', data.safely('metadata>album_artist') || data.safely('metadata>artist'), '-s');
        normalizer.set('duration', Math.floor(data.safely('streams[0]>duration') * 1000) || normalizer.safely('duration'), '-s');
        normalizer.set('extras>year', data.safely('metadata>year') || data.safely('metadata>date'), '-s');    
        normalizer.set('extras>track', data.safely('metadata>track'), '-s');    
        normalizer.set('extras>description', data.safely('metadata>description'), '-s');   
        normalizer.set('extras>genre', data.safely('metadata>genre'), '-s');   
        normalizer.set('extras>bitrate', '%skbps'.format(Math.floor((data.safely('format>bit_rate') || data.safely('streams[0]>bit_rate', 128000)) / 1000)), '-s');
        normalizer.set('extras>longname', data.safely('format>"format_long_name"'), '-s');
        normalizer.set('extras>size', data.safely('format>size'), '-s');
        normalizer.set('extras>samplerate', data.safely('streams[0]>sample_rate'), '-s');
        normalizer.set('extras>channels', data.safely('streams[0]>channels'), '-s');
        normalizer.set('extras>comment', data.safely('comment'), '-s');

        id3({ file: normalizer.filePath, type: id3.OPEN_LOCAL }, function(err, tags) {
            if(!toolkit.isNaN(err)) {
                console.error(err);
                return _.emit('done', [normalizer]);
            }

            if(!toolkit.isNaN(tags.v1)){
                toolkit.extend(tags, tags.v1, '-safe');
                delete tags.v1;
            }

            if(!toolkit.isNaN(tags.v2)){
                toolkit.extend(tags, tags.v2, '-safe');
                delete tags.v2;
            }

            if(!toolkit.isNaN(tags.image)){
                normalizer.extend('id3>image', tags.image, '-s');
            }

            _.emit('done', [normalizer]);
        });

    });
}

self.save = function(normalizer, opts, _){

    console.log(normalizer);

    if(toolkit.isNaN(normalizer.filePath) && toolkit.isNaN(opts.filePath)){
        return _.emit('error', "No filepath defined");
    }

    _.emit('start', "Starting saving ID3");

    var keys = toolkit.safely(opts.keys, "");
    var filePath = normalizer.filePath || opts.filePath;

    if(toolkit.isNaN(keys.reverse)) 
        return _.emit('error', "No keys defined");

    var prog = new Progress(100, 1);
    var id3 = {};

    prog.read(0);

    _.emit('progress', prog);

    if(keys.length == 0){
        prog.read(100);
        _.emit('progress', prog);
        _.emit('done', "ID3 data written");
    }

    for(var i = 0; i < keys.length; i++){
        var key = keys[i]['key'];
        var data = normalizer.safely(keys[i]['safely']);
        if(!toolkit.isNaN(data) && !toolkit.isNaN(key))
            id3[key] = data;
    }

    ffmetadata.write(filePath, id3, function(err) {
        if(!toolkit.isNaN(err)) 
            return _.emit('error', err);
        prog.read(100);
        _.emit('progress', prog);
        _.emit('done', id3);
    });
} 