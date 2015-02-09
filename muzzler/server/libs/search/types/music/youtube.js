var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var ffmpeg = include('fluent-ffmpeg');
var youtube = include('youtube-feeds');
var ytdl = require('ytdl')
var fs = require('fs');

var normal = include('normal');
var Normalizer = normal.Normalizer("music", "youtube");
var Progress = normal.Progress;

// type, src, title, artist, album, duration, img, extras

var self = exports;
var cacheDirectory = __search_cache_dirname;
var validExtras = ['uploader', 'description', 'category', 'viewCount', 'likeCount', 'rating'];
var ytbLink = "http://www.youtube.com/watch?v=";

exports.find = function (q, opts, _) {

    var maxDuration = toolkit.safely(opts.maxDuration, 600000);
    var maxResults = toolkit.safely(opts.maxResults, 10);
    var orderBy = toolkit.safely(opts.orderBy, 'relevance');

    youtube.feeds.videos({
        'q': q,
        'max-results': maxResults,
        'orderby': orderBy
    }, function (err, data) {

        console.log("Responsed with data. Error - " + err);

        if (!toolkit.isNaN(err))
            return _.emit('error', err);

        var results = data.items;
        var response = [];

        if (toolkit.isNaN(results) || toolkit.isNaN(results.length)) {
            return _.emit('error', "No matching videos.");
        }

        var resultCount = 0;

        console.log("Found " + results.length + " songs.");

        for (var i = 0; i < results.length; i++) {
            var result = results[i];
            if (result.duration > maxDuration) continue;
            var data = new Normalizer(q, ytbLink + result.id,
                result.title, undefined, undefined, typeof result.duration === 'number' ? result.duration * 1000 : 0,
                result.thumbnail.hqDefault, normal.extractExtras(validExtras, result), resultCount++);
            response.push(data);
        }

        if (response.length == 0)
            return _.emit('error', "Videos are too long.");

        return _.emit('done', response);

    });
}

var vidfilter = function (format) {
    return format.container === 'mp4';
}

var ytdlOpts = {
    "filter": vidfilter,
    "quality": "highest"
}

exports.save = function (normalizer, opts, _) {

    var output = toolkit.safely(opts.saveTo, path.join(cacheDirectory, normalizer.id)) + '.mp3';
    var outputVid = path.join(cacheDirectory, normalizer.id) + '.mp4';
    var writing = fs.createWriteStream(outputVid);
    var stream = ytdl(normalizer.src, ytdlOpts);
    var prog;

    // Convert video
    // ----------------------------- 

    var deleteCache = function(vid){
        fs.unlink(vid, function (err) {
            if (!toolkit.isNaN(err)) return console.error(err);
            console.log("Deleted - original video!");
        });
    }

    var video2mp3 = function () {

        prog.next();
        prog.total(toolkit.safely(normalizer.duration, 50000));

        var proc = new ffmpeg({
                source: outputVid
            })
            .withAudioCodec('libmp3lame')
            .withAudioBitrate('320k')
            .withAudioChannels(2)
            .withAudioQuality(10)
            .toFormat('mp3')
            .on('progress', function (p) {
                var h = parseInt(p.timemark.substring(0, 2)) * 3600;
                var m = parseInt(p.timemark.substring(3, 5)) * 60;
                var s = parseInt(p.timemark.substring(6, 8));
                prog.read((h + m + s) * 1000);
                _.emit('progress', prog);
            })
            .on('error', function(err){
                deleteCache(outputVid);
                _.emit('error', err);
            })
            .on('end', function () {

                if (prog.safeFix()) {
                    _.emit('progress', prog)
                }
                
                deleteCache(outputVid);

                if(normal.mime('audio/mpeg', output, normalizer))
                    return _.emit('error', 'Failed file saving.')

                normalizer.filePath = output;
                _.emit('done', output);
            })
            .saveToFile(output);
    }

    // Download video
    // ----------------------------- 

    var dataRead = 0;

    stream.on('data', function (data) {
        dataRead += data.length;
        prog.read(dataRead);

        _.emit('progress', prog);
    });

    stream.on('end', video2mp3);

    stream.on('error', function(err){
        deleteCache(outputVid);
        _.emit('error', err);
    });

    stream.on('info', function (info, format) {
        prog = new Progress(format.size, 2);
    });

    stream.pipe(writing);

    _.emit('start', 'Started video retrieval and conversion');

}