/*
 * 
 * Elixir.js/Toolkit
 * @author Mathew Kurian
 * 
 * From Elixir.js-NodeJS v1.0
 *
 * Please report any issues
 * https://github.com/bluejamesbond/Elixir.js/issues
 * 
 * Date: 4/19/2014
 * 
 */

var codes = require('./codes');
var path = require('path');
var self = exports;

self.is = {};
self.not = {};

self.is.array = function(a){
    if (!self.is.nan(a)) 
        return !self.is.nan(a.reverse);
    return false;
}

self.is.function = function(a){
    return typeof a === 'function';
}

self.is.defined = function(a){
    return !self.is.undefined(a);
}

self.is.nan = function(a){
    return self.isNaN(a);
}

self.is.undefined = function(a){
    return self.undef(a);
}

String.format = function() {
    var args = self._argsAsArray(arguments);
    return self.format.apply(this, args);
}

String.prototype.format = String.prototype.f = function () {    
    var args = self._argsAsArray(arguments);      
    args.unshift(String(this));     
    return self.format.apply(this, args);
}

// From NodeJS
var formatRegExp = /%[sdj%]/g;
exports.format = function () {

    var args = self._argsAsArray(arguments);
    var f = args.shift();

    if (typeof f !== 'string') {
        return args.join(' ');
    } 

    var str = String(f).replace(formatRegExp, function (x) {
        if (x === '%%') return '%';
        var arg = args.shift();
        if(self.undef(arg)) return arg;
        switch (x) {
        case '%s':
            return arg.toString();
        case '%d':
            return arg.toString();
        case '%j':
            try {
                return JSON.stringify(arg, null, 4);
            } catch (_) {
                return '[Circular]';
            }
        default:
            return x;
        }
    }); 

    var joined = args.join(' ');
    str += joined !== '' ? " // " + joined : '';

    return str;
}

exports.clean = function(a, b){
    for(var i = 0; i < a.length; i++)
        if(self.isNaN(a[i]) || a[i] === b)
            a.splice(i--, 1);

    return a;
}   

exports.sendJSON = function(res, data){
    res.end(JSON.stringify(data));
};

var _regex = {
    "default" : /.*/g,
    "password" : /^(.){6,}$/,
    "name" : /^(.){2,}$/,
    "email" : /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
    "file/folder" : /^([\w|\(|\)\[|\]\-|\.]+\.?)*[\w|\(|\)\[|\]\-|\.]+$/
}

exports.formatSize = function(bytes) {
    if (bytes <= 0) { return 0; }
    var t2 = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), 12);
    return (Math.round(bytes * 100 / Math.pow(1024, t2)) / 100) +
            units.charAt(t2).replace(' ', '') + 'B';
}

exports.error = function(err){
    return !self.isNaN(err);
}

exports.encodeQuery = function(q){
    return q.replace(/\$/g, "%24")
                 .replace(/\+/g, '%2B')
                 .replace(/\s/g, '+')
                 .replace(/&/g, "%26")
                 .replace(/\//g, "%2F")
                 .replace(/\=/g, "%3D")
                 .replace(/%/g, "%25")
                 .replace(/@/g, "%40")
                 .replace(/#/g, "%23")
                 .replace(/\?/g, "%3F")
                 .replace(/;/g, "%3B")
                 .replace(/,/g, "%2C");
}

exports.regex = function(a){
    if(self.isNaN(a) || self.isNaN(_regex[a + ""]))
        return _regex["default"];
    return _regex[a];
}

exports.isNaN = function(a){
    try {
        return self.undef(a) ||  a === 0;
    } catch(e) {
        return true;
    }
}

exports.undef = function(a){
    try {
        return typeof a === 'undefined' || a === null;
    } catch(e){
        return true;
    }
}

exports.sendDefaultJSON = function(res, stat, message, data){

    var obj = {};
    obj.status = typeof stat === "number" ? stat : codes.status.FAILED;
    obj.message = typeof message !== "undefined" ? message.toString() : "No specified message. Please contact webmaster@mus.ec";
    if(data) obj.data = data;

    self.sendJSON(res, obj);
};

exports.hash = function(str){

    if(typeof str !== 'string') return 0;

    var hash = 0, i, char;
    
    if (str.length == 0) {
        return hash;
    }
    
    for (i = 0, l = str.length; i < l; i++) {
        char  = str.charCodeAt(i);
        hash  = ((hash<<5)-hash)+char;
        hash |= 0;
    }

    return hash;
};

exports.safely = function(a, d){
    return self.undef(a) ? d : a;
}

exports.argsArray = exports._argsAsArray = function(args) {
    return Array.prototype.splice.call(args, 0);
}


exports.dfire = function(callback, args) {

    if (typeof callback !== 'function') {
        return;
    }

    if(typeof args.reverse === 'undefined'){
        return;
    }
    
    process.nextTick(function(){
        callback.apply(this, args);
    });
}


exports.cloneFunc = function(a){
    if(typeof a !== 'function') return;
    var clone;
    eval('clone=' + a.toString());
    return clone;
}

// -force, -safe, -none

var _f = [ "-s", "-n", "-f"]
exports.extend = function(obj, attach, f) {
    f = typeof f === 'boolean' ? (f ? '-s' : '-n') : _f.indexOf(f + "") > -1 ?  f : '-n'; 
    for (var key in attach){
        switch(f){
            case "-f" : 

            obj[key] = attach[key]; 
            break;

            case "-s" :

            if(!self.isNaN(attach[key]))
                obj[key] = attach[key];
            break;

            default:
            case "-n" :

            if(self.isNaN(obj[key]))
                obj[key] = attach[key];
        }
    }
};

exports.fire = function(callback) {

    if (typeof callback !== 'function') {
        return;
    }

    var args = self._argsAsArray(arguments);
    args.splice(0, 1);

    process.nextTick(function(){
        callback.apply(this, args);
    });
}


exports.invoke = function(c, callback) {

    if (typeof callback !== 'function') {
        return;
    }

    var args = exports._argsAsArray(arguments);
    var sliced = args.splice(0, 2);

    process.nextTick(function(){
        callback.apply(sliced[0], args);
    });
}

// source - stackoverflow
exports.toProperCase = function(str){
    var noCaps = ['of','a','the','and','an','am','or','nor','but','is','if','then', 
'else','when','at','from','by','on','off','for','in','out','to','into','with'];
    return str.replace(/\w\S*/g, function(txt, offset){
        if(offset != 0 && noCaps.indexOf(txt.toLowerCase()) != -1){
            return txt.toLowerCase();    
        }
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
               .toString(16)
               .substring(1);
}

exports.guid = function() {
    return s4() + s4() + '-' + 
           s4() + '-' + s4() + 
           '-'  + s4() + '-' + 
           s4() + s4() + s4();
}