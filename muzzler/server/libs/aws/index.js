var toolkit = include('toolkit');
var codes = include('codes');
var safely = include('safely');
var path = require('path');
var fs = require('fs');
var Emitter = include('emitter');
var http = require('http');
var cloudfront = require('cloudfront-private-url-creator');
var AWS = require('aws-sdk');

AWS.config.loadFromPath(path.join(__dirname, 'config.json'));

var normal = include('normal');
var Progress = normal.Progress;

var s3 = new AWS.S3();

var distribution = {

    "E32SN85Q9N9ZKT" : {
        "domain" : "d3la0jlnzadzn2.cloudfront.net",
        "origin" : "media.musec.s3.amazonaws.com",
        "bucket" : "media.musec",
        "type" : "private"
    },
    "E349OWQWQ4GSG5" : {
        "domain" : "dk9abf2pp64q.cloudfront.net",
        "origin" : "static.musec.s3.amazonaws.com",
        "bucket" : "static.musec",
        "type" : "public"
    }
}


exports.cloudfront = {

    add : function(id, domain, bucket, type){
        distribution[id] = {
            "domain" : domain,
            "bucket" : bucket,
            "origin" : "%.s3.amazonaws.com".format(bucket),
            "type" : type
        }
    }
}

function BucketMan(bucket, s) {

    var self = this;

    var _mode = "bucket";
    var _modes = [ "bucket", "file", "folder" ]
    self.mode = function(m){
        if(arguments.length === 0) return _mode;
        _mode = (_modes.indexOf(m = toolkit.safely(m, _mode)) > 0) ?  m : _mode;
        return _mode;
    }

    var _path = "";
    self.path = function(p){
        if(arguments.length === 0) return _path;
        _path = toolkit.safely(p, _path);
        _path = _path.replace("\\", "/").replace(/\/{1,}/g, "/");
        _path = _path.replace(/^\/{0,}/g, "");
        return _path;
    }

    var _domain = "";
    self.domain = function(){
        return _domain;
    }

    var _secure = s ? true : false;
    self.secure = function(){
        return _secure;
    }

    var _bucket = "";
    self.bucket = function(b){
        if(arguments.length === 0) return _bucket;
        _bucket = toolkit.safely(b, _bucket);
        _domain = ((_bucket.indexOf(".") < 0 || self.secure() ? "https" : "http")+ "://%s.s3.amazonaws.com/").format(_bucket);  
        return _bucket;
    }

    self.public = function(){
        return encodeURI((_domain + _path).trim());
    }

    self.private = function(opts){
        opts = safely.attach(opts);
        return self.public();
    }

    var createFolder = function(opts){

        return Emitter.__call__(function(_){ 

            opts = safely.attach(opts);

            s3.putObject({
                'ACL' : opts.safely('acl', 'public-read'),
                'Bucket': self.bucket(), 
                'Key' : self.path()
            }, function(err, data) {
                if (!toolkit.isNaN(err)) return;
                _.emit('done', new BucketMan(self));
            }).on('error', function(err){
                _.emit('error', err);
            });

        });
    }

    var deleteFileFolder = function(){

        return Emitter.__call__(function(_){            
            s3.deleteObject({
                'Bucket': self.bucket(), 
                'Key': self.path() 
            }, function(err, data) {
                if(!toolkit.isNaN(err)) return;
                _.emit('done', self.parent());
            }).on('error', function(err){
                _.emit('error', err);
            });
        });
    }

    var uploadFile = function(file, opts){

        return Emitter.__call__(function(_){

            var prog = new Progress(undefined, 1);

            opts = safely.attach(opts);
            _.silence([ "progress" ]);

            s3.putObject({
                'ACL' : opts.safely('acl', 'public-read'),
                'Bucket': self.bucket(), 
                'Key' : self.path(),
                'Body': fs.readFileSync(file),
                'ContentType': opts.safely('contentType', 'application/octet-stream')
            }, function(err, data) {
                if (!toolkit.isNaN(err)) return
                if(prog.safeFix()) self.emit('progress', prog);
                _.emit('done',  new BucketMan(self));
            }).on('httpUploadProgress', function(p) {
                prog.read(p.loaded);
                prog.total(p.total);
                _.emit('progress', prog);
            }).on('error', function(err){
                _.emit('error', err);
            });
        });
    }

    var deleteBucket = function(){

        return Emitter.__call__(function(_){
            s3.deleteBucket({
                'Bucket': self.bucket()
            }, function (err, data) {
                if(!toolkit.isNaN(err)) return;
                _.emit("done", self.parent());
            }).on('error', function(err){
                _.emit('error', err);
            });
        });

    }

    var configure = function(){
        
        if(!toolkit.isNaN(self['upload'])) delete self['upload'];
        if(!toolkit.isNaN(self['delete'])) delete self['delete'];
        if(!toolkit.isNaN(self['create'])) delete self['create'];
        if(!toolkit.isNaN(self['stat'])) delete self['stat']; 

        switch(self.mode()){
            case "bucket": 
            self['delete'] = deleteBucket;
            return;

            case "folder": 
            self['create'] = createFolder;
            self['delete'] = deleteFileFolder;
            return;

            case "file":
            self['upload'] = uploadFile;
            self['delete'] = deleteFileFolder;
            if(self.folder) delete self.folder;
            return;

        }
    }

    self.folder = function(folder){

        if(!toolkit.regex('file/folder').test(folder) && toolkit.isNaN(folder = folder.trim()))
            throw Error("Invalid filename");

        var bmode = self.mode();
        var bpath = self.path();

        self.mode("folder");        
        self.path(self.path() + folder + "/");

        var bm = new BucketMan(self);

        self.mode(bmode);        
        self.path(bpath);

        return bm;
    }

    self.file = function(file){

        if(!toolkit.regex('file/folder').test(file) && toolkit.isNaN(file = file.trim()))
            throw Error("Invalid filename");

        var bmode = self.mode();
        var bpath = self.path();

        self.mode("file");        
        self.path(self.path() + file);

        var bm = new BucketMan(self);

        self.mode(bmode);        
        self.path(bpath);

        return bm;
    }

    self.parent = function(){
        if(self.path() === ""){
            return;
        }

        var split = toolkit.clean(self.path().split("/"), "")

        if(split.length === 0)
            return;

        if(split.length === 1)
            return new BucketMan(self.bucket(), self.secure());

        split.splice(split.length - 1, 1);

        var bm = new BucketMan(self.bucket(), self.secure());
        
        bm.mode('folder'); 
        bm.path(split.join('/') + '/');

        bm.configure();

        return bm;
    }

    self.isFile = function(){
        return self.mode() === 'file';
    }

    self.isBucket = function(){
        return self.mode() === 'bucket';
    }

    self.isFolder = function(){
        return self.mode() === 'folder';
    }

    if(toolkit.isNaN(bucket.__status)){
        self.bucket(bucket);
        self.path("");
        self.mode('bucket');
    } else {
        self.secure(bucket.secure());
        self.bucket(bucket.bucket());
        self.path(bucket.path());
        self.mode(bucket.mode());
    }

    self.configure = configure;    
    self.__status = "valid";

    configure();

    return self;
}

exports.s3 = {

    "bucket" : function(bucket){
        return Emitter.__call__(function(_){
            s3.createBucket({
                'Bucket': bucket
            }, function(err){
                if(!toolkit.isNaN(err)){
                    if(err.toString().indexOf("BucketAlreadyOwnedByYou") > -1){
                        return _.emit('done', new BucketMan(bucket));  
                    }
                } else {
                    return _.emit('done', new BucketMan(bucket));  
                }
                _.emit('error', err);          
            })
        });
    },
    "from" : function(uri){

        return Emitter.__call__(function(_){

            uri = uri.replace(/\/{1,}$/, '').replace('https', 'http');
            
            var secure = uri.indexOf("https") === 0;
            var split = uri.match(/https?:\/\/(.*)?.s3.amazonaws.com\/?(.*)?/);

            if(toolkit.isNaN(split) || split.length !== 3) 
                return _.emit("error", "Invalid URI");

            var bucket = split[1];
            var dir = split[2];

            if(toolkit.isNaN(dir)){
                return _.emit("done", new BucketMan(bucket, secure));
            }

            // if(/\/{2,}/g.test(dir)){
            //     toolkit.fire(callback, codes.status.FAILED, "Invalid URI");
            // }

            dir = path.normalize(decodeURI(dir));
            
            http.get(uri, function(res){

                var bm = new BucketMan(bucket, secure);
                
                if(res.statusCode == 403){
                    bm.path(dir + "/");
                    bm.mode('folder');
                } else {
                    bm.path(dir);
                    bm.mode('file');
                }

                bm.configure();

                _.emit("done", bm);

            }).on('error', function(err){
                _.emit("error", err);
            });
        });
    }
}