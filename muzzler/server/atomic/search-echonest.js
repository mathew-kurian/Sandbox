
var search = include('search');
var worker = include('queue').of('worker');
var toolkit = include('toolkit');

var normalized = {
    "type": "music",
    "strategy": "youtube",
    "src": "http://www.youtube.com/watch?v=uelHwf8o7_U",
    "title": "Eminem - Love The Way You Lie ft. Rihanna",
    "duration": 267,
    "img": "http://i.ytimg.com/vi/uelHwf8o7_U/hqdefault.jpg",
    "__status": "valid Normalizer",
    "extras": {
        "uploader": "eminemvevo",
        "description": "Music video by Eminem performing Love The Way You Lie. © 2010 Aftermath Records #VEVOCertified on September 13, 2011. \nhttp://www.vevo.com/certified\nhttp://www.youtube.com/vevocertified.",
        "category": "Music",
        "viewCount": 697580717,
        "likeCount": "1810783",
        "rating": 4.860321
    },
    "id": "a73a2980-4a9e-30fe-abfc-fb8df3668ce0",
    "resultCount": 0,
    "filePath": "/home/ec2-user/Dropbox/muzzler/server/libs/search/cache/a73a2980-4a9e-30fe-abfc-fb8df3668ce0.mp3",
    "ext": "mp3"
}

var self = normalized;

self.set = function(t, a, f){
    f = !toolkit.isNaN(f); 
    if((toolkit.undef(self[t]) || f) && !toolkit.undef(a)){
        try { if((a = a.trim()) === '') return; } catch(e){}
        self[t] = a;
    }
}

self.complete = function(){
    for(var key in self){
        if(typeof self[key] === 'undefined') 
            return false;
    }

    return true;
}

self.safely = function(t, i){
    if(toolkit.undef(self[t])) return i;
    try { if(self[t].length === 0) return i; } catch(e){}
    return self[t];
}

self.override = function(a, b){
    self.type =a;
    self.strategy = b;
}

normalized.publicPath = "http://mus.ec/converted/-838235816.mp3";
normalized.type = "metadata";
normalized.strategy = "echonest";

exports.run = function(){
    worker.exec(function(thread){
        search.process(normalized,{            
        }).on('done', function(msg){
            console.log(msg);
            thread.exit();
        }).on('start', function(msg){
            console.log(msg);
        }).on('progress', function(prog){
            if(prog.atleast(10))
                console.log(progress.format())
        }).on('error', function(err){
            console.error(err);
            thread.exit();
        });
    });
}