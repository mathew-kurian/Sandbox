
var aws = include("aws");
var codes = include("codes");
var path = require("path");
var worker = include("queue").of('worker');

exports.run = function(opts){
    
    var bucketA = "musec-atomic-cdn-a";
    var fileA = path.join(__dirname, "assets", "01_-_Mylo_Xyloto.mp3");

    worker.exec(function(thread){
        aws.s3.bucket(bucketA)
        .on("done", function(bucket){
            bucket.folder("test").create()
            .on('done', function(folder){
                folder.file("Col dplay.mp3").upload(fileA, {
                    'acl' : 'public-read',
                    'contentType' : 'audio/mpeg'
                }).on('start', function(msg){
                    console.log(msg);
                }).on('progress', function(progress){
                    if(progress.atleast(10))
                        console.log(progress.format())
                }).on('done', function(file){
                    file.delete()
                    .on('done', function(parent){
                        parent.delete()
                        .on('done', function(parent){                                                        
                            parent.delete()
                            .on('done', function(parent){
                                console.log("AWS S3 %s".f(bucketA));
                                thread.exit();
                            });
                        }).on('error', function(err){
                            console.error(err);
                            thread.exit();
                        });
                    }).on('error', function(err){
                        console.error(err);
                        thread.exit();
                    });
                }).on('error', function(err){
                    console.error(err);
                    thread.exit();
                });
            }).on('error', function(err){
                console.error(err);
                thread.exit();
            });
        }).on('error', function(err){
            console.error(err);
            thread.exit();
        });
    });
    
    var bucketB = "musec-atomic-cdn-b";
    var fileB = path.join(__dirname, "assets", "2035961717.mp3");

    worker.exec(function(thread){
        aws.s3.bucket(bucketB)
        .on("done", function(bucket){
            bucket.folder("test").create()
            .on('done', function(folder){
                folder.file("Col dplay.mp3").upload(fileA, {
                    'acl' : 'public-read',
                    'contentType' : 'audio/mpeg'
                }).on('start', function(msg){
                    console.log(msg);
                }).on('progress', function(progress){
                    if(progress.atleast(10))
                        console.log(progress.format())
                }).on('done', function(file){
                    aws.s3.from(file.public())  // File from url!
                    .on('done', function(file){
                        file.delete()
                        .on('done', function(parent){
                            parent.delete()
                            .on('done', function(parent){                                                        
                                parent.delete()
                                .on('done', function(parent){
                                    console.log("AWS S3 %s".f(bucketB));
                                    thread.exit();
                                });
                            }).on('error', function(err){
                                console.error(err);
                                thread.exit();
                            });
                        }).on('error', function(err){
                            console.error(err);
                            thread.exit();
                        });
                    }).on('error', function(err){
                        console.error(err);
                        thread.exit();
                    });
                }).on('error', function(err){
                    console.error(err);
                    thread.exit();
                });
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