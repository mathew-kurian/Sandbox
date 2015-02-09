var search = include('search');
var worker = include('queue').of('worker');
var toolkit = include('toolkit');

exports.run = function(opts){
    worker.exec(function(thread){
        search.find('music', 'youtube', 'rogue dubstep', {
                preferredQuality : "1080p"
            }).on('done', function(res){
            console.log(res[0]);        
            search.save(res[0]).on('done', function(msg){
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