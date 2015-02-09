
var aws = include("aws");
var worker = include('queue').of('worker');
var codes = include("codes");

exports.run = function(opts){
    
    var bucketname = "test.musec";

    worker.exec(function(thread){
        aws.s3.bucket(bucketname)
        .on("done", function(bucket){
            bucket.delete()
            .on("done", function(parent){
                console.test("AWS Parent of bucket: %s".f(bucketname))
                       .should(parent)
                       .be('undefined');
                thread.exit();
            }).on('error', function(err){
                console.error(err);
                thread.exit();
            })
        }).on("error", function(err){
            console.error(err);
            thread.exit();
        })
    });
}