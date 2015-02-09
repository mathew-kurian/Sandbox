
var Emitter = include('emitter');

exports.run = function(){
    methodB().on('start', console.log)
             .on('done',console.warn);
}

var methodB = function(opts){
    return Emitter.__call__(function(self){
        methodC(opts, self);
    });
}

var methodC = function(opts, _){
    _.broadcast("start", "[emitter-proto.js] MethodC invoked");
    setTimeout(function(){
        _.broadcast("done", "[emitter-proto.js] MethodC returned");
    }, 5000);
}
