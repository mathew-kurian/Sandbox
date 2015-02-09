var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var request = include('request');
var fs = require('fs');
var gshark = require('grooveshark-streaming');
var http = require('http');
var url = require('url');
var util = require('util');

var normal = include('normal');
var Normalizer = normal.Normalizer("music", "grooveshark");
var Progress = normal.Progress;

// type, src, title, artist, album, duration, img, extras

var self = exports;
var validExtras = [];
var cacheDirectory = __search_cache_dirname;

exports.find = function (q, opts, _) {

    var maxDuration = toolkit.safely(opts.maxDuration, 600000);
    var maxResults = toolkit.safely(opts.maxResults, 10);
    var artist = toolkit.safely(opts.artist, '*');
    var responses = [];

    gshark.Tinysong.getSongInfoArray(q, function (err, results) {

        console.log("Responsed with data. Error - " + err);

        if (!toolkit.isNaN(err))
            return _.emit('error', err);

        var resultCount = 0;
        var response = [];

        console.log("Found " + results.length + " songs.");

        for (var i = 0; i < Math.min(results.length, maxResults); i++) {
            var result = results[i];
            var data = new Normalizer(q, result.SongID,
                result.SongName, result.ArtistName, result.AlbumName, result.Duration,
                result.Artwork, normal.extractExtras(validExtras, result), resultCount++);
            response.push(data);
        }

        return _.emit('done', response);

    });
}

var retSong = function (streamUrl, normalizer, opts, _) {

    var saveTo = opts.saveTo;

    http.get(streamUrl, function (res) {

        var total = parseInt(res.headers['content-length'], 10);
        var dataRead = 0;
        var prog = new Progress(total, 1);

        trackFile = fs.createWriteStream(saveTo);

        res.on('data', function (chunk) {
            dataRead += chunk.length;
            prog.read(dataRead);
            _.emit('progress', prog);
            trackFile.write(chunk);
        });

        res.on('error', function(err){
            _.emit('error', err);
        });

        res.on('end', function () {

            if (prog.safeFix())
                _.emit('progress', prog)

            trackFile.end();

            if(normal.mime('audio/mpeg', saveTo, normalizer))
                return _.emit('error', 'Failed file saving.')

            normalizer.filePath = saveTo;
            _.emit('done', saveTo);
        });

    }).on('error', function(err){
        _.emit('error', err);
    });
}

exports.save = function (normalizer, opts, _) {

    gshark.Grooveshark.getStreamingUrl(normalizer.src, function (err, streamUrl) {
        var output = toolkit.safely(opts.saveTo, path.join(cacheDirectory, normalizer.id)) + '.mp3';
        retSong(streamUrl, normalizer, {
            'saveTo': output
        }, _)
    });

    _.emit('start', "Started retreiving audio");
}