
var toolkit = include('toolkit');
var mime = require('mime');
var safely = include('safely');

var createNormalizer = function(type, strategy){
    return function Normalizer(q, src, title, artist, album, duration, img, extras, resultCount){

        var self = this;

        self.q = q;
        self.type = type;
        self.strategy = strategy;
        self.src = src;
        self.title = title;
        self.artist = artist;
        self.album = album;
        self.duration = duration;
        self.img = img;
        self.__status = "valid Normalizer";
        self.extras = extras;
        self.id = toolkit.guid();
        self.resultCount = resultCount;
        self.filePath = "-";
        self.ext = 'mp3';
                        
        self.complete = function(){
            for(var key in self){
                if(typeof self[key] === 'undefined') 
                    return false;
            }

            return true;
        }

        safely.attach(this);

        self.override = function(a, b){
            self.type =a;
            self.strategy = b;
        }
    } 
}

exports.Normalizer = createNormalizer;

exports.extractExtras = function(keys, obj){
    var out = {};

    if(!toolkit.isNaN(obj))
        for(var i = 0; i < keys.length; i++){
            if(!toolkit.undef(obj[keys[i]])) 
                out[keys[i]] = obj[keys[i]];
        }

    return out;
} 

exports.Progress = function(total, parts){

    var self = this;

    var last = 100;
    var hit100 = false;

    self.id = toolkit.guid();

    self.next = function(){
        self.part(self.part() + 1);
        self._total = undefined;
        self._read = undefined;
        last = 100;
        hit100 = false;
    }

    self.read = function(r){
        if(arguments.length === 0 || toolkit.undef(r) || toolkit.isNaN(self.total())) 
            return self._read;
        return self._read = r;
    } 

    self.total = function(t){
        if(arguments.length === 0 || toolkit.isNaN(t) || isNaN(t)) 
            return self._total;
        return self._total = t;
    }

    self.part = function(r){
        if(arguments.length === 0 || toolkit.isNaN(r) || isNaN(r)) 
            return self._part;
        return self._part = r;
    }

    self.parts = function(){
        return self._parts;
    }

    self.valid = function(){
        return !toolkit.undef(self.read()) && !toolkit.isNaN(self.total());
    }

    self.safeFix = function(){
        if(toolkit.isNaN(self.read()) || toolkit.isNaN(self.total())){
            self.read(1);
            self.total(1);
            return true;
        } else if(self.read() != self.total()){
            self.read(Math.max(self.total(), self.read()));
            self.total(self.read());
            return true;
        }

        return false;
    }

    self.progress = function(){
        if(!self.valid()) return 0;
        return self.percent();
    }

    self.percent = function(){
        return ((self.read() / self.total())/self.parts() + ((self.part() - 1) / self.parts())) * 100;
    }

    self.format = function(a){
        a = toolkit.safely(a, 1);
        return self.progress().toFixed(a) + "%";
    }

    // Very bad implemetation but it solves the problem
    // for now.
    self.atleast = function(c){
        c = toolkit.safely(c, 1);
        p = self.percent();
        var diff = Math.abs(p - last);
        if((c <= diff && p != last || (p == 100 && !hit100)) && self.valid()){
            if(p == 100) 
                hit100 = true;
            last = p;
            return true;
        }

        return false;
    }

    self._part = 1;
    self._parts = parts;
    self._read;
    self._total;
    self.total(total);
}    

exports.validate = function(data){
    return toolkit.isNaN(data) ? false : !toolkit.isNaN(data.__status);
}

exports.mime = function(type, output, normalizer){
    try {
        var contentType = mime.lookup(output);
        if(!toolkit.isNaN(normalizer)) {
            normalizer.contentType = contentType;
            normalizer.ext = contentType === "audio/mpeg" ? 
                        "mp3" :mime.extension(contentType)
        }
        return !(contentType.indexOf(type) > -1);
    } catch(e){
        return true;
    }
}

exports.secure = function(src){
    return !toolkit.isNaN(src.match(/^https:\/\//))
}
