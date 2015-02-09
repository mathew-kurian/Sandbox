
var codes = include('codes');
var toolkit = include('toolkit');
var moment = include('moment');
var emitter = include('emitter');

var self = emitter.attach(this).silent(false);

var $ = self.$;
$.ignore = {};

exports.ignore = function(a){
    if(!toolkit.undef(a))
        $.ignore[a.toString()] = "";
}

exports.allow = function(a){
    var code = codes.notification[a].toString();
    if(!toolkit.undef(code))
        delete $.ignore[code];
}

// Default as per Brent's requirements

self.on(codes.notification.PROCESS_FINISHED, function(){
    console.log("[NOTIFY]Process finished sending via sockets.");
});


self.on(codes.notification.ADD_SONG, function(){
    console.log("[NOTIFY]Song added sending via sockets.");
});

self.on(codes.notification.UPLOAD_FINISHED, function(){
    console.log("[NOTIFY]Upload finished sending via sockets.");
});

self.ignore(codes.notification.ANALYZE_ONPROGRESS);

exports.sendMessage = function(uid, message) {

    uid = uid + "";

    var __context = String.format("[Notify.js][%s] ", uid);

    if(toolkit.undef(message)) 
        return console.error(__context + "Undefined message parameter");

    if(toolkit.undef(message.code))
        throw Error("Undefined code ");

    message.time = moment().format("MMM Do YYYY");
    message.msg = toolkit.undef(message.msg) ? "Message not specified. Please contact webmaster@mus.ec" : message.msg;
    
    var code = message.code.toString();

    if(toolkit.undef($.ignore[code])){
        console.log(__context + JSON.stringify(message, null, 4));
        $.io.sockets.emit(uid, message);
        self.fireListeners("emit", code)
    }
};

exports.sendDefaultMessage = function(uid, code, message, eid, data){

    if(toolkit.undef(code) || toolkit.undef(eid))
        throw Error("[Notify.js] Requires `code` and `eid` paramter.")

    var obj = {};
    obj.code = code;
    obj.eventId = eid;
    obj.msg = toolkit.undef(message) ? "Message not specified. Please contact webmaster@mus.ec" : message;
    if(!toolkit.undef(data)) obj.data = data;

    self.sendMessage(uid, obj);
}

function ObjBuilder(){
    this.obj = {};
    this.set = function(a, d){
        this.obj[a + ""] = d;
        return this;
    }
    this.build = function(){
        return this.obj;
    }
}

exports.obj = function(a, b){
    var obj = new ObjBuilder();
    obj.set(a, b);
    return obj;
}