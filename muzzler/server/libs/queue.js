
var Worker = require('webworker-threads').Worker;
var toolkit = include('toolkit');
var self = exports;
var queues = {};

exports.of = function(a){
    if(toolkit.isNaN(queues[a]))
        queues[a] = new Queue(a);    

    return queues[a];
}

function Queue(a){

    var name = a;
    var processing = false;
    var works = [];

    this.exec = function(callback){
        works.push(callback);
        if(!processing) thread.exit();
    }

    var thread = {
        exit : function(){

            var work = works.shift();

            if(!toolkit.isNaN(work)) {
                processing = true;
                
                // var worker = new Worker(function(){
                //     thread.message = worker.postMessage;
                //     thread.close = self.close;
                //     toolkit.fire(work, thread);
                // });

                // worker.onmessage = function(event) {
                //     console.log("[Worker]" + event.data);
                // };
            
                // worker.postMessage('ali');

                toolkit.fire(work, thread);

                return;
            }

            processing = false;

            if(arguments.length !== 0){
                toolkit.fire.apply(null, toolkit._argsAsArray(arguments));
            }
        }
    }
}