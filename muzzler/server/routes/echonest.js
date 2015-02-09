var request = require('request');
var toolkit = include('toolkit');
var codes = include('codes');

var self = exports;
var ECHONEST_SECRET_API_KEY = "6RGE1KCQ2W5STF8GI";

var passes = [
    {
        url : function(data){
            return "http://developer.echonest.com/api/v4/track/profile?api_key=%s&format=json&id=%s&bucket=audio_summary";
        },
        extract : function(data, body){

        }
    },
    {
        url : function(data){
            return "http://developer.echonest.com/api/v4/track/profile?api_key=%s&format=json&id=%s&bucket=audio_summary";
        },
        extract : function(data, body){

        }
    }
];

// TODO . Title from youtube goes can be used as name + artist

self.find = function(q, normal, callback){

}

self.getAlbumArtFromSongMultiPass = function(songurl, callback) {

    var timedout = false;

     var data = {
            title : undefined,
            artist : undefined,
            duration : undefined,
            album : undefined,
            release_image : undefined,
            images : undefined,
            set : function(t, a){
                if(typeof this[t] === 'undefined' && typeof a !== 'undefined'){
                    try { if((a = a.trim()) === '') return; } catch(e){}
                    this[t] = a;
                }
            },
            complete : function(){
                for(var key in this){
                    if(typeof this[key] === 'undefined') 
                        return false;
                }

                return true;
            },
            safely : function(t, i){
                if(typeof this[t] === 'undefined' || this[t] == null) return i;
                try { if(this[t].length === 0) return i; } catch(e){}
                return this[t];
            }
        };

    var timeout = setTimeout(function(){
        timedout = true;
        toolkit.fire(callback, codes.status.FAILED, "Timed out.", data);
    }, 140000);

    var __context = "[Echonest][GetAlbumArtFromSong] ";
    var bodystr = "api_key=" + ECHONEST_SECRET_API_KEY + "&url=" + songurl;
    var localurl = "http://developer.echonest.com/api/v4/track/upload?api_key=" + ECHONEST_SECRET_API_KEY + "&filetype=mp3";

    console.log(__context + "Started getAlbumArtFromSongMultiPass");

    var req = request.post({
        headers: { 'content-type': 'application/x-www-form-urlencoded' },
        url: 'http://developer.echonest.com/api/v4/track/upload',
        body: bodystr
    }, function(err, res, body) {

        console.log(__context + "Response from getAlbumArtFromSongMultiPass");

        if(timedout) {
            return console.log("Response received but timed out.");
        } 

        clearTimeout(timeout);

        if (err) return toolkit.fire(callback, codes.status.FAILED, __context + err.message, data); // Call if failed
        try {  body = JSON.parse(body); } catch (e) {} // parse
        body = typeof body === 'undefined' ? {} : body; // assign

        try {

            console.log(body);

            var id = body.response.track.id;

            if (typeof id !== 'undefined'){

                console.log(__context + "Invoke pass1");

                return setTimeout(function(){
                    pass1(id, data, function(err, msg, d) {
                        if (err) return toolkit.fire(callback, codes.status.FAILED, __context + err.message, d);
                        toolkit.fire(callback, codes.status.OK, msg, d);
                    });
                }, 90000);
            }
            
            throw new Error('Parse error'); // will be caught by parent throw/catch

        } catch(e){
            toolkit.fire(callback, codes.status.FAILED, __context + "Read error.", data);
        }
    });
}       

var pass1 = function(songid, data, callback) {

    var timedout = false;

    var timeout = setTimeout(function(){
        timedout = true;
        toolkit.fire(callback, codes.status.OK, "Timed out.", data);
    }, 140000);

    var __context = "[Echonest][pass1]";
    var tempurl = "http://developer.echonest.com/api/v4/track/profile?" + "api_key=" + ECHONEST_SECRET_API_KEY + "&format=json&id=" + songid + "&bucket=audio_summary";

    console.log(__context + "Started pass1");

    request.get(tempurl, {}, function(err, res, body){

        console.log(__context + "Response from pass1.");

         if(timedout) {
            return console.log("Response received but timed out.");
        } 

        clearTimeout(timeout);

        if (err) {
            return toolkit.fire(callback, codes.status.FAILED, err, data);
        }

        try {  body = JSON.parse(body);  } catch (e) {}
        body = typeof body === 'undefined' ? {} : body;

        try { data.set('title', body.response.track.title); } catch(e){}
        try { data.set('artist', body.response.track.artist); } catch(e){}
        try { data.set('duration', body.response.track.audio_summary.duration); } catch(e){}
        try { data.set('album', body.response.track.release); } catch(e){}
        try { data.set('release_image', body.response.track.release_image); } catch(e){}

        // if (data.complete()) {
        //     return toolkit.fire(callback, codes.status.OK, __context + 'Found all song data.', data);
        // }
           
        try {

            var artist = body.response.track.artist;
            var title = body.response.track.title;
            
            if(typeof artist !== 'undefined' && typeof title !== 'undefined'){

                console.log(__context + "Invoke pass2");

                return pass2(artist, title, data, function(err, msg, d) {
                    if(err) return toolkit.fire(callback, codes.status.FAILED, d);
                    toolkit.fire(callback, codes.status.OK, msg, d);
                });
            }

            throw Error('Parse error.');

        } catch(e){
            toolkit.fire(callback, codes.status.FAILED, __context + 'Internal error at pass1.' + e.message, data);
        }
    });
}
 
var pass2 = function(singer, songname, data, callback) {

    var timedout = false;

    var timeout = setTimeout(function(){
        timedout = true;
        toolkit.fire(callback, codes.status.OK, "Timed out.", data);
    }, 140000);

    var __context = "[Echonest][pass2]";
    var tempurl = "http://developer.echonest.com/api/v4/song/search?api_key=6RGE1KCQ2W5STF8GI&format=json&results=1&artist=" + singer + "&title=" + songname + "&bucket=id:7digital-US&bucket=tracks&bucket=audio_summary";
    
    console.log(__context + "Started pass2");

    request.get(tempurl, {}, function(err, res, body) {

        console.log(__context + "Response from pass2."); 

        if(timedout) {
            return console.log("Response received but timed out.");
        } 

        clearTimeout(timeout);

        try { body = JSON.parse(body); } catch (e) {}
        body = typeof body === 'undefined' ? {} : body;        
    
        console.log(JSON.stringify(body));
        
        try { data.set('title', body.response.songs[0].title); } catch(e){}
        try { data.set('artist_name', body.response.songs[0].artist_name); } catch(e){}
        try { data.set('duration', body.response.songs[0].audio_summary.duration); } catch(e){}
        try { data.set('release_image', body.response.songs[0].tracks[0].release_image); } catch(e){}
        try { data.set('album', body.response.songs[0].tracks[0].album); } catch(e){}

        console.log(__context + "Invoke pass3");

        return pass3(singer, data, function(err, msg, d){
            toolkit.fire(callback, codes.status.OK, msg, d);                
        });
    });
}

var pass3 = function(singer, data, callback) {

    var timedout = false;

    var timeout = setTimeout(function(){
        timedout = true;
        toolkit.fire(callback, codes.status.OK, "Timed out.", data);
    }, 140000);

    var __context = "[Echonest][pass3]";
    var tempurl = "http://developer.echonest.com/api/v4/artist/search?api_key=6RGE1KCQ2W5STF8GI&format=json&results=1&name=" + singer + "&bucket=id:7digital-US&bucket=images&bucket=songs";

    console.log(__context + "Started pass3");

    request.get(tempurl, {}, function(err, res, body) {

        console.log(__context + "Response from pass3."); 

        if(timedout) {
            return console.log("Response received but timed out.");
        } 

        clearTimeout(timeout);

        try {  body = JSON.parse(body);  } catch (e) {}
        body = typeof body === 'undefined' ? {} : body;

        console.log(JSON.stringify(body));

        var images = [];

        try {

            var rimgs = body.response.artists[0].images;

            for(var i = 0; i < rimgs.length; i++){
                var obj = rimgs[i]
                var url = obj.url;

                try {

                    if(typeof url === 'undefined'){
                        var _url = obj.license.url;

                        if(typeof _url !== 'undefined'){
                            images.push(_url);
                            continue;
                        }
                    } else {
                        images.push(url);
                    }

                } catch(e){}
            }

        } catch(e){}

        try { data.set('title', body.response.songs[0].title); } catch(e){}
        try { data.set('artist_name', body.response.songs[0].artist_name); } catch(e){}
        try { data.set('duration', body.response.songs[0].audio_summary.duration); } catch(e){}
        try { data.set('release_image', body.response.songs[0].tracks[0].release_image); } catch(e){}
        try { data.set('album', body.response.songs[0].tracks[0].album); } catch(e){}
        try { data.set('images', images); } catch(e){}
        
        return toolkit.fire(callback, codes.status.OK, __context + 'All the information we can find.', data);

    });
}

var getReleaseImage = function(reqid, callback) {

    var __context = "[Echonest][GetReleaseImage] ";

    request.get("http://developer.echonest.com/api/v4/track/profile", {
        api_key: ECHONEST_SECRET_API_KEY,
        id: songid,
        bucket: "audio_summary"
    }, function(err, res, body) {
        if (err) return toolkit.fire(callback, codes.status.FAILED, err);
        try {
            body = JSON.parse(body);
        } catch (e) {}
        body = typeof body === 'undefined' ? {} : body;
        if (typeof body.release_image !== 'undefined')
            return toolkit.fire(callback, codes.status.OK, __context + 'Found album art.', body.release_image);
        toolkit.fire(callback, codes.status.FAILED, __context + 'Internal error.');
    });
}