// Scribe.js (NodeJS)
// Copyright 2014 by Mathew Kurian
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT SPLICEED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

// Module dependences
// ---------------------------------

(function(){

    var moment = include('moment');
    var toolkit = include('toolkit');
    var jquery = include('jquery');

    var self = {};

    // Configuration
    // ---------------------------------

    var $ = {
        app : "Mus.ec",
        postPath : "http://mus.ec/elog",
        maxTagLength : 18,
        indentation : 0,
        divider : ' : ',
        testOutput : function(result, pipes, actual, expected, opts){

            var pipe = result ? 'log' : 'error';
            var ne = expected.indexOf("\n") > -1;
            var na = actual.indexOf("\n") > -1;

            pipes[pipe](" " + opts + (result ? " PASSED " : " FAILED "))
            pipes[pipe](" EXPECTED " + (!ne ? expected: ""))
            if(ne) pipes[pipe](expected);
            pipes[pipe](" ACTUAL " + (!na ? actual : ""))
            if(na) pipes[pipe](actual);
        }
    }


    // Active settings
    // ---------------------------------

    var activeDefaultTag;

    var loggers = {};
    var fsOptions = { encoding : 'utf8' }
    var __reserved = [ "f", "t", "tag", "file", "should", "be", "test", "assert" ];

    // Cache pipe out
    // ---------------------------------

    var __stdpipe = (function(){
        return console.log;
    })();

    // Utility functions
    // ---------------------------------

    var pretty = function(a){
        if(!a) return a + "";
        if(typeof a === 'object')
            return JSON.stringify(a, null, 4);
        return a.toString();
    }

    var compress = function(a){
        if(!a) return a + "";
        if(typeof a === 'object')
            return JSON.stringify(a);
        return a.toString();
    }

    var tag = function(a){
        return "[" + a + "]";
    }

    function Extender(tag, opts, stack){

        var self = this;

        self.tag = tag;
        self.opts = opts;

        self.do = self.invoke = self.should = function(actual){

            var _actual = compress(actual);

            self.expect = self.be = function(expected){

                var _expected = compress(expected);

                $.testOutput(_actual === _expected, self, pretty(actual), pretty(expected), self.opts);

                return self;
            }

            return self;
        }
    }

    var spaces = function(sp){
        var s = '';
        for(var z = 0; z < sp; z++)
            s += ' ';
        return s;
    }

    // Exports
    // ---------------------------------

    self.addLogger = function(name, post, console){
        if(arguments.length < 3) 
            return false;

        if(__reserved.indexOf(name) > -1)
            throw Error("Reserved pipe - " + name);

        loggers[name] = {
            "post" : post,
            "console" : console
        }

        addPipe(name);

        return true;
    }

    self.removeLogger = function(name){
        if(loggers[name]) {
            delete loggers[name];
            delete console[name];
            return true;
        }

        return false;
    }

    self.set = function(a, b){
        $[a] = b;
    }

    self.configure = function(callback){

        if(callback) callback();
        activeDefaultTag = tag($.app.toLowerCase());
    }

    // Additional Features
    // ---------------------------------

    console['t'] = console['tag'] = function(n){ 
        return new Extender(n ? tag(n) : activeDefaultTag);
    }

    console['f'] = console['file'] = function(n){
        return new Extender(tag(n));
    }

    console['assert'] = console['test'] = function(name, tag){
        tag = tag ? tag : "scribe.js";
        return new Extender(tag, name);
    } 

    var addPipe = function(n) {

        Extender.prototype[n] = function(){
            var args = Array.prototype.splice.call(arguments, 0);
            args.unshift(this.tag + args.shift());
            console[n].apply(this, args);
        }

        console[n] = (function (i) {

            return function () {

                var args = toolkit._argsAsArray(arguments);
                var utfs = (args.length == 1 ? pretty(args[0]) : toolkit.format.apply(this, args)).trim();
                var time = moment().format('h:mm:ss A')
                var indent = spaces($.indentation);
                var tag = utfs.match(/^\[(.*?)\]\s{0,}/m);

                if(loggers[i].post && utfs != ''){

                    var outfs = utfs;
                    var cleanTag = "";

                    if(tag) {
                        outfs = outfs.replace(tag[0], "");
                        cleanTag = tag[0].trim();
                    } 

                    outfs = time + $.divider + cleanTag + outfs.replace(/\n/g, '\n' + time + $.divider + cleanTag) + '\n';

                    jquery.post($.postPath, {
                       data : outfs
                    }, function(){});
                }

                if (loggers[i].console){

                    if(!tag) { 
                        tag = [ activeDefaultTag ];
                    }

                    var tabIn;
                    var cleanTag = tag[0].trim();

                    if(cleanTag.length <= $.maxTagLength){
                        utfs = utfs.replace(tag[0], ""); 
                        tabIn = spaces($.maxTagLength - cleanTag.length);
                        utfs = indent + cleanTag + tabIn + utfs.replace(/\n/g, '\n' + indent + cleanTag + tabIn);
                    } else {
                        tabIn = indent + spaces($.maxTagLength);
                        utfs = tabIn + utfs.replace(/\n/g, '\n' + tabIn);
                    }
                    
                    __stdpipe.call(console, utfs);
                }
            }

        })(n);

        console.t()[n]('Created pipe console.%s', n.toUpperCase());
    }

    // Startup
    self.configure();

    attach('scribe', self);

})({});