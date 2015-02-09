var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var request = include('request');
var fs = require('fs');

var normal = include('normal');
var Normalizer = normal.Normalizer("music", "soundcloud");
var Progress = normal.Progress;

// type, src, title, artist, album, duration, img, extras

var self = exports;
var cacheDirectory = __search_cache_dirname;
var validExtras = ['user_id', 'description', 'playback_count', 'favoritings_count', 'license'];
var clientId = 'nH8p0jYOkoVEZgJukRlG6w';

exports.find = function (q, opts, _) {

    var maxDuration = toolkit.safely(opts.maxDuration, 600000);
    var maxResults = toolkit.safely(opts.maxResults, 10);
    var t = q.replace('https', 'http');

    if (!toolkit.isNaN(t.match(/^https?:\/\/(?:[^\/]+\.)?soundcloud\.com/g))) {
        return SoundRain.retrieve(t, function (err, msg, result) {
            if (!toolkit.isNaN(err)) return _.emit("error", err);
            if (result.duration > maxDuration)
                return _.emit("error", "Videos are too long.");
            if (typeof result.duration !== 'number')
                return _.emit("error", "Invalid track url.");
            var data = new Normalizer(q, t, result.title, undefined, undefined, result.duration,
                result.artwork_url, normal.extractExtras(validExtras, result), 0);
            return _.emit("done", [data]);
        });
    }

    request.get('http://api.soundcloud.com/search?q=%s&consumer_key=%s'.f(encodeURIComponent(q), clientId), {}, function (err, res, body) {

        console.log("Responsed with data. Error - " + err);

        if (toolkit.isNaN(body) || !toolkit.isNaN(err) && res.statusCode !== 200)
            return _.emit("error", err);

        try {
            body = JSON.parse(body);
        } catch (e) {}

        var results = body.collection;
        var response = [];

        if (toolkit.isNaN(results) || toolkit.isNaN(results.length)) {
            return _.emit("error", "No matching videos.");
        }

        var resultCount = 0;

        console.log("Found " + results.length + " songs.");

        for (var i = 0; i < Math.min(results.length, maxResults); i++) {
            var result = results[i];
            if (result.duration > maxDuration || result.kind !== 'track') continue;
            var data = new Normalizer(q, result.permalink_url, result.title, undefined,
                undefined, result.duration, result.artwork_url, normal.extractExtras(validExtras, result),
                resultCount++);
            response.push(data);
        }

        if (response.length == 0)
            return _.emit("error", "Videos are too long.");

        return _.emit("done", response);

    });
}

exports.save = function (normalizer, opts, _) {

    var output = toolkit.safely(opts.saveTo, path.join(cacheDirectory, normalizer.id)) + '.mp3';
    var song = new SoundRain(normalizer, output);

    song.on('error', function(err){
        _.emit('error', err);
    }).on('done', function (saveTo) {
        if (normal.mime('audio/mpeg', saveTo, self.normalizer))
            return _.emit('error', 'Failed file saving.')
        normalizer.filePath = saveTo;
        _.emit('done', saveTo);
    }).on('progress', function(progress){
        _.emit('progress', progress)
    });

    _.emit('start', "Started retreiving audio");

}

// -----------------------------------------------------------------------------
// SoundRain - Modified for progress/error events
// -----------------------------------------------------------------------------
var http = require('http');
var url = require('url');
var util = require('util');
var EventEmitter = require('events').EventEmitter;

var SoundRain = function (normalizer, output) {
    EventEmitter.call(this);

    var soundCloudURL = normalizer.src;
    // Error detection
    // First replace HTTPS with HTTP.
    soundCloudURL = soundCloudURL.replace('https', 'http');
    // Secondly ensure it's actually SoundCloud we're downloading from.
    if (!soundCloudURL.match(/http:\/\/soundcloud.com/gi)) {
        this.emit('error', Error('The URL provided must be from SoundCloud.com'));
        return false;
    }

    this.url = soundCloudURL;
    this.output = output;
    this.tracks;
    this.outfile;
    this.normalizer = normalizer;

    var self = this;

    self.find();

    return this;
};

util.inherits(SoundRain, EventEmitter);

SoundRain.retrieve = function (url, callback) {

    var self = {},
        trackData = '';

    (normal.secure(url) ? https : http).get(url, function (res) {

        var dataRead = 0;

        res.on('data', function (chunk) {
            trackData += chunk;
        });
        res.on('end', function () {
            self.tracks = trackData.match(/(window\.SC\.bufferTracks\.push\().+(?=\);)/gi);
            return toolkit.fire(callback, codes.status.OK, "No matching videos.",
                SoundRain._parse(self.tracks[0], callback));
        });
        res.on('error', function (err) {
            return toolkit.fire(callback, codes.status.FAILED, err);
        });
    }).on('error', function () {
        return toolkit.fire(callback, codes.status.FAILED, err);
    });

    return this;
};

SoundRain._parse = function (raw, callback) {

    var rawChaff;
    rawChaff = raw.indexOf('{');

    if (rawChaff === -1) return false;

    try {
        return JSON.parse(raw.substr(rawChaff));
    } catch (e) {
        return toolkit.fire(callback, codes.status.FAILED, Error('Couldn\'t parse URL.'));
    }

    return this;
};

SoundRain.prototype.find = function () {
    var self = this,
        trackData = '';

    http.get(this.url, function (res) {

        var total = parseInt(res.headers['content-length'], 10);
        var dataRead = 0;
        var prog = self.prog = new Progress(total, 2);

        res.on('data', function (chunk) {
            dataRead += chunk.length;
            prog.read(dataRead);
            self.emit('progress', prog);
            trackData += chunk;
        });

        res.on('end', function () {
            if (prog.safeFix())
                self.emit('progress', prog);
            self.tracks = trackData.match(/(window\.SC\.bufferTracks\.push\().+(?=\);)/gi);
            self.download(self.parse(self.tracks[0]));
        });

        res.on('error', function (err) {
            self.emit('error', err);
        });

    }).on('error', function (err) {
        self.emit('error', err);
    });

    return this;
};

SoundRain.prototype.parse = function (raw) {
    EventEmitter.call(this);

    var self = this;
    var rawChaff = raw.indexOf('{');

    if (rawChaff === -1) return false;

    try {
        return JSON.parse(raw.substr(rawChaff));
    } catch (e) {
        self.emit('error', Error('Couldn\'t parse URL.'));
    }

    return this;
};

SoundRain.prototype.download = function (obj) {

    EventEmitter.call(this);

    var self = this;
    var trackPattern, trackArtist, trackTitle, trackFile;

    trackPattern = /&\w+;|[^\w|\s]/g;
    trackArtist = obj.user.username.replace(trackPattern, '');
    trackTitle = obj.title.replace(trackPattern, '');

    this.outfile = path.join(this.output);

    var downloadUrl = String.format('http://api.soundcloud.com/tracks/%s/download?consumer_key=%s', obj.id, clientId);
    var playurl = String.format('http://api.soundcloud.com/tracks/%s/plays?consumer_key=%s', obj.id, clientId);

    var processUrls = function (urls, errors) {

        errors = toolkit.safely(errors, []);

        if(urls.length === 0)
            return self.emit("error", errors.join("\n"));

        var url = urls.shift();

        console.warn("Finding stream --url: %s --quality: %s".f(url.link, url.quality));

        http.get(url.link, function (res) {

            if (toolkit.isNaN(res.headers.location)){
                errors.push("Unable to find stream in --url: %s --quality: %s".f(url.link, url.quality))
                return processUrls(urls, errors);
            }

            http.get(res.headers.location, function (res) {

                var total = parseInt(res.headers['content-length'], 10);
                var dataRead = 0;
                var prog = self.prog;

                prog.next();
                prog.total(total);

                trackFile = fs.createWriteStream(self.outfile);

                res.on('data', function (chunk) {
                    dataRead += chunk.length;
                    prog.read(dataRead);
                    self.emit('progress', prog);
                    trackFile.write(chunk);
                });

                res.on('error', function (err) {
                    errors.push(err);
                    processUrls(urls, errors);
                });

                res.on('end', function () {

                    if (prog.safeFix())
                        self.emit('progress', prog);

                    trackFile.end();

                    self.emit('done', self.outfile);
                });

            }).on('error', function (err) {
                errors.push(err)
                processUrls(urls, errors);
            });

        }).on('error', function (err) {
            errors.push(err)
            processUrls(urls, errors);
        });
    }

    var URLObject = function (link, quality){
        return {
            "link" : link,
            "quality" : quality
        }
    }

    var streams = [ URLObject(downloadUrl, "high"), 
                    URLObject(playurl, "medium"), 
                    URLObject(obj.streamUrl, "low") ];
    
    processUrls(streams);

    return this;
};