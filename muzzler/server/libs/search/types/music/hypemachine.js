var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var fs = require('fs');
var Hypem = require("node-hypem");
var http = require('http');
var cheerio = require('cheerio');
var request = require('request');

var normal = include('normal');
var Normalizer = normal.Normalizer("music", "hypemachine");
var Progress = normal.Progress;

// type, src, title, artist, album, duration, img, extras

var self = exports;
var cacheDirectory = __search_cache_dirname;
var validExtras = ['loved_count', 'description', 'category', 'viewCount', 'likeCount', 'rating'];
var hypemLink = "http://hypem.com/track/";
var hypemServeLink = "http://hypem.com/serve/source/%s/%s";

exports.find = function (q, opts, _) {

    var maxDuration = toolkit.safely(opts.maxDuration, 600000);
    var maxResults = toolkit.safely(opts.maxResults, 10);
    var page = toolkit.safely(opts.page, 1);

    Hypem.playlist.search("West Coast Lana Rey", page, function (err, data) {

        console.log("Responsed with data. Error - " + err);

        if (!toolkit.isNaN(err))
            return _.emit('error', err);

        var results = [];
        var response = [];

        for (var i in data)
            results.push(data[i]);

        if (toolkit.isNaN(results) || toolkit.isNaN(results.length)) {
            return _.emit('error', "No matching videos.");
        }

        var resultCount = 0;

        console.log("Found " + results.length + " songs.");

        for (var i = 0; i < Math.min(results.length, maxResults); i++) {
            var result = results[i];
            var data = new Normalizer(q, hypemLink + result.mediaid,
                result.title, result.artist, undefined, undefined,
                result.thumb_url_large, normal.extractExtras(validExtras, result), resultCount++);
            response.push(data);
        }

        return _.emit('done', response);
    });
}

exports.save = function (normalizer, opts, _) {

    var output = toolkit.safely(opts.saveTo, path.join(cacheDirectory, normalizer.id)) + '.mp3';
    var prog;

    http.get(normalizer.src, function (res) {

        var siteData = "";

        res.on('data', function (chunk) {
            siteData += chunk;
        });

        res.on('end', function () {
            var $ = cheerio.load(siteData);
            var results = $('#displayList-data');
            var results = results.html().replace(/\&quot;/g, '"');
            postProcess(JSON.parse(results));
        });

        res.on('error', error);

    });

    var postProcess = function (res) {

        if (toolkit.isNaN(res.tracks) || toolkit.isNaN(res.tracks.length))
            return _.emit('error', "Could not find song.");

        var track = res.tracks[0];
        var url = String.format(hypemServeLink, track.id, track.key);

        request.get({
            url: url,
            headers: {
                'Accept': 'application/json, text/javascript, */*',
                'Accept-Charset': 'UTF-8,*;q=0.5',
                'Accept-Language': 'en-US,en;q=0.8',
                'Host': 'hypem.com',
                'Referer': normalizer.src,
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1',
                'X-Requested-With': 'XMLHttpRequest'
            },
            jar : true

        }, function (err, res, body) {

            try {
                body = JSON.parse(body);
            } catch (e) {}

            if (!toolkit.isNaN(err) || toolkit.isNaN(res) || toolkit.isNaN(body.url))
                return _.emit('error', "Error during retrieval serve JSON");

            http.get(body.url, function (res) {

                var total = parseInt(res.headers['content-length'], 10);
                var prog = new Progress(total, 1);
                var dataRead = 0;

                var trackFile = fs.createWriteStream(output);

                res.on('data', function (chunk) {
                    dataRead += chunk.length;
                    prog.read(dataRead);
                    _.emit('progress', prog);
                    return trackFile.write(chunk);
                });

                res.on('error', function (err) {
                    _.emit('error', err);
                });
                res.on('end', function () {
                    if (prog.safeFix()) {
                        _.emit('progress', prog);
                    }

                    trackFile.end();

                    if(normal.mime('audio/mpeg', output, normalizer))
                        return _.emit('error', 'Failed file saving.')

                    normalizer.filePath = output;
                    _.emit(done, output);
                });
            })

        }).on('error', err);
    }

    _.emit(start, "Started retreiving audio");

}