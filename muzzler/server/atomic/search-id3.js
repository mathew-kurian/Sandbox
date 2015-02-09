
var search = include('search');
var worker = include('queue').of('worker');
var toolkit = include('toolkit');
var safely = include('safely');

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
    "filePath": "/home/ec2-user/Dropbox/muzzler/server/atomic/assets/01_-_Mylo_Xyloto.mp3",
    "ext": "mp3",
    "override" : function(a, b){
        this.type =a;
        this.strategy = b;
    }
}

var self = safely.attach(normalized);

exports.run = function(opts){

    normalized.override('metadata', 'id3');

    worker.exec(function(thread){
        search.find('metadata', 'id3', normalized, {
        }).on('done', function(res){
            console.log(res[0]);        
            search.save(res[0], {
                "keys" : [{ 
                    "key" : "Title",
                    "safely" : "extras>uploader" 
                } , { 
                    "key" : "Bit rate",
                    "safely" : "extras>bitrate" 
                } , { 
                    "key" : "Sample rate",
                    "safely" : "extras>samplerate" 
                }]
            }).on('done', function(msg){
                console.log(msg);
                thread.exit();
            }).on('start', function(msg){
                console.log(msg);
            }).on('progress', function(prog){
                if(prog.atleast(10))
                    console.log(prog.format());
            }).on('error', function(err){
                console.error(err);
                thread.exit();
            });
        }).on('error', function(err){
            console.error(err);
            thread.exit();
        });
    });
}