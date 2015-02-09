var request = require('request');
var toolkit = include('toolkit');
var codes = include('codes');
var request = require('request');
var safely = include('safely');

var normal = include('normal');
var Progress = normal.Progress;

var self = exports;
var ECHONEST_SECRET_API_KEY = "6RGE1KCQ2W5STF8GI";

var passes = function() {
    return [
        {        
            "request" : function(data){
                return {
                    headers: { 
                        'content-type': 'application/x-www-form-urlencoded' 
                    },
                    url: 'http://developer.echonest.com/api/v4/track/upload',
                    body: String.format("api_key=%s&url=%s", ECHONEST_SECRET_API_KEY, data.publicPath)
                }
            },
            "retry" : function(data, body){
                return !toolkit.isNaN(body.response.status.code);
            },
            "desc" : "Sending song to server.",
            "method" : 'post',
            "statusCode" : 200,
            "attempts" : 5,
            "timeout" : 20,
            "extract" : function(data, body){          
                data.set('fingerprint-id', body.safely('response>track>id'), '-s');
            },
            'done' : function(data, body){
                return false;
            }
        },
        {        
            "request" : function(data){

                if(toolkit.isNaN(data['fingerprint-id']))
                    return;

                return {
                    url: String.format('http://developer.echonest.com/api/v4/track/profile?api_key=%s&format=json&id=%s&bucket=audio_summary', ECHONEST_SECRET_API_KEY,
                        data['fingerprint-id'])
                }
            },
            "retry" : function(data, body){
                return body.safely('response>track>status', 'pending') === 'pending' ||
                            !toolkit.isNaN(body.safely('response>status>code', 'failed'));
            },
            "desc" : "Waiting on server to fingerprint",
            "method" : 'get',
            "statusCode" : 200,
            "attempts" : 15,
            "timeout" : 5000,
            "extract" : function(data, body){
                data.set('title', body.safely('response>track>title'), '-s');
                data.set('artist', body.safely('response>track>artist'), '-s');
                data.set('album ', body.safely('response>track>release'), '-s');
                data.set('fingerprint-artist-id', body.safely('response>track>artist_id'), '-s');
                data.set('fingerprint-song-id', body.safely('response>track>song_id'), '-s');
                data.set('fingerprint-raw', body.safely('response>track'), '-s');
            },
            'done' : function(data, body){
                return false;
            }
        }
    ];
}

var totalPasses = passes().length;

// TODO . Title from youtube goes can be used as name + artist

self.save = function(normalizer, opts, _){
    normalizer.set('fingerprint-messages', []);
    _.emit('start', "Started fingerprinting audio");

    if(toolkit.isNaN(normalizer.publicPath))
        return _.emit('error', "Requires `publicPath` parameter");

    processPass(passes(), normalizer, opts, _);
}

var processPass = function(passes, normalizer, opts, _){

    if(passes.length === 0)
        return _.emit('done', normalizer);

    var pass = passes.shift();
    var passIndex = totalPasses - 1 - passes.length;
    var obj = pass.request(normalizer);

    var next = function(){
        processPass(passes, normalizer, opts, _);
    }  

    var retry = function(){
        passes.unshift(pass);
        return setTimeout(function(){
            next();
        }, pass.timeout);
    }

    var postMessage = function(msg, server){
        normalizer['fingerprint-messages'].push({
            "pass-index" : passIndex,
            "messsage" : msg,
            "server" : server
        });
    }

    if(toolkit.isNaN(obj))
        return next();
    
    console.low(String.format("Started Pass#%s - %s to %s", passIndex, pass.method, obj.url));

    request[pass.method](obj, function(err, res, body){

        var message;

        console.low("Response on Pass#" + passIndex);

        try {  
            body = JSON.parse(body);  
            message = body.response.status.message;
        } catch (e) {
            message = "Not a valid JSON from server"; 
            res.statusCode = 500; // Force server error
        } finally {
            body = typeof body === 'undefined' ? {} : body;
        }
        
        body = safely.attach(body);      

        if(--pass.attempts === 0 && (!toolkit.isNaN(err) || res.statusCode !== pass.statusCode)){
            postMessage("Failed on %s to Echonest - %s".f(pass.method, pass.desc),
                body.response.status.message);
            return next();
        }

        if((!toolkit.isNaN(err) || res.statusCode !== pass.statusCode) || pass.retry(normalizer, body)){
            console.low("Pass#%s failed. Retrying in %sms".f(passIndex, pass.timeout));
            postMessage("Failed validation", "Server responded with %s - %s".f(res.statusCode, message));
            return retry();
        }
        
        console.low("Pass#%s extracting data".f(passIndex));

        if(!toolkit.isNaN(pass.extract(normalizer, body))){
            console.low("Pass#%s extraction failed. Retrying in %sms".f(passIndex, pass.timeout));
            postMessage("Pass extraction error", "Response error");
            return retry();
        }

        postMessage("Pass#%s extraction passed.".f(passIndex), "Server responded with %s - %s".f(res.statusCode, message));

        if(pass.done(normalizer, body)){
            console.low("Pass#%s detected completion".f(passIndex));
            return _.emit('done', normalizer)
        }
        
        next();

    });

}