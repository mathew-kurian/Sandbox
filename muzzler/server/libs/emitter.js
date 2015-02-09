
var toolkit = include('toolkit');
var stack = require('callsite');
var path = require('path');

function Emitter(attachTo, invokeAfter){

    var __context = "Emitter";
    var listeners = {};
    var $ = {};
    var self = attachTo;
    var silent = false;
    var invokeId = 0;
    var __invoke;
    var ignore = [];

    if(!toolkit.isNaN(invokeAfter)){
        __invoke = function(callback){
            clearTimeout(invokeId);
            invokeId = setTimeout(function(){
                invokeAfter = false;
                toolkit.fire(self['__invoke'], self);
                delete self['__invoke'];
            }, invokeAfter);
        }
        __invoke();
    }

    var stackId = function(){
        var st = stack()[2];
        return path.basename(st.getFileName()) + ":" + st.getLineNumber();
    }

    self.fireListeners = function(type){
        type = type + "";
        try { if( typeof listeners[type] === 'undefined') return; } catch(e){ return; }
        var args = toolkit._argsAsArray(arguments);
        args.splice(0, 1);
        for(var key in listeners[type])
            toolkit.dfire(listeners[type][key], args);
        if(!silent && ignore.indexOf(type) < 0) {
            console.t(stackId()).info('Listeners fired for on `%s` event.'.format(type));
        }
    }

    self.emit = self.broadcast = self.fireListeners;

    self.on = function(type, callback){
        if(!toolkit.isNaN(invokeAfter)) __invoke();
        type = type + ""; 
        if(typeof listeners[type] === 'undefined') listeners[type] = {};
        listeners[type][toolkit.hash(callback.toString())+ ''] = callback;
        if(!silent) console.t(stackId()).warn('Listener add for on `%s` event.'.format(type));
        return self;
    }

    self.off = function(type, callback){
        if(!toolkit.isNaN(invokeAfter)) __invoke();
        type = type + "";
        try { 
            delete  listeners[type][toolkit.hash(callback.toString()) + ''];  
            if(!silent) console.t(stackId()).info('Listener removed for on `%s` event.'.format(type));
        } catch(e){
            if(!silent) console.t(stackId()).info('Listener could not be removed for on `%s` event.'.format(type));
        } 

        return self;
    }

    self.set = function(a, obj){
        if(!toolkit.isNaN(invokeAfter)) __invoke();
        $[a + ""] = obj;
        return self;
    }

    self.$ = $;

    self.silent = function(a){
        silent = typeof a === 'boolean' ? a : false;
        return self;
    }

    self.silence = function(a){
        if(toolkit.isNaN(a) || toolkit.isNaN(a.reverse)) return;
        ignore = a;
    }
 
    self.configure = function(callback) {
        callback();
    }

    return self;
}

exports.attach = function(a){
    return new Emitter(a, 0);
}

exports.__call__ = function(a){
    return new Emitter({ '__invoke' : a }, 40);
}