(function (__context) {

    var exports = {};
    var self = exports;
    var running = {};
    var $ = {};

    self.uri = {};
    self.localStorage = {};
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

    Array.prototype.each = function(r, callback) {
        if (typeof r === 'undefined') return;
        if (typeof r === 'function') callback = r;
        if (typeof r !== 'boolean') r = true;

        if (r)
            for (var i = 0; i < this.length; i++)
                callback.apply(this[i], [this[i], i, this]);
        else
            for (var i = this.length - 1; i >= 0; i--)
                callback.apply(this[i], [this[i], i, this]);

    };

    Array.prototype.removeAll = function(val) {
        for (var i = 0; i < this.length; i++)
            if (this[i] === val)
                this.splice(i--, 1);

        return this;
    }

    Array.prototype.remove = function(val) {
        for (var i = 0; i < this.length; i++)
            if (this[i] === val) {
                this.splice(i--, 1);
                break;
            }

        return this;
    };

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

    exports.clean = function (a, b) {
        for (var i = 0; i < a.length; i++)
            if (self.isNaN(a[i]) || a[i] === b)
                a.splice(i--, 1);

        return a;
    }

    var _regex = {
        "default": /.*/g,
        "password": /^(.){6,}$/,
        "name": /^(.){2,}$/,
        "email": /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
        "file/folder": /^([\w|\(|\)\[|\]\-|\.]+\.?)*[\w|\(|\)\[|\]\-|\.]+$/
    }

    exports.formatSize = function (bytes) {
        if (bytes <= 0) {
            return 0;
        }
        var t2 = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), 12);
        return (Math.round(bytes * 100 / Math.pow(1024, t2)) / 100) +
            units.charAt(t2).replace(' ', '') + 'B';
    }

    exports.error = function (err) {
        return !self.isNaN(err);
    }

    exports.encodeQuery = function (q) {
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

    exports.regex = function (a) {
        if (self.isNaN(a) || self.isNaN(_regex[a + ""]))
            return _regex["default"];
        return _regex[a];
    }

    exports.isNaN = function (a) {
        try {
            return self.undef(a) || a === 0;
        } catch (e) {
            return true;
        }
    }

    exports.undef = function (a) {
        try {
            return typeof a === 'undefined' || a === null;
        } catch (e) {
            return true;
        }
    }

    exports.hash = function (str) {

        if (typeof str !== 'string') return 0;

        var hash = 0,
            i, char;

        if (str.length == 0) {
            return hash;
        }

        for (i = 0, l = str.length; i < l; i++) {
            char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash |= 0;
        }

        return hash;
    };

    exports.safely = function (a, d) {
        return self.undef(a) ? d : a;
    }

    exports.argsArray = exports._argsAsArray = function (args) {
        return Array.prototype.splice.call(args, 0);
    }


    exports.dfire = function (callback, args) {

        if (typeof callback !== 'function') {
            return;
        }

        if (typeof args.reverse === 'undefined') {
            return;
        }

        setTimeout(function () {
            callback.apply(this, args);
        }, 0);
    }


    exports.cloneFunc = function (a) {
        if (typeof a !== 'function') return;
        var clone;
        eval('clone=' + a.toString());
        return clone;
    }

    // -force, -safe, -none

    var _f = ["-s", "-n", "-f"]
    exports.extend = function (obj, attach, f) {
        f = typeof f === 'boolean' ? (f ? '-s' : '-n') : _f.indexOf(f + "") > -1 ? f : '-n';
        for (var key in attach) {
            switch (f) {
            case "-f":

                obj[key] = attach[key];
                break;

            case "-s":

                if (!self.isNaN(attach[key]))
                    obj[key] = attach[key];
                break;

            default:
            case "-n":

                if (self.isNaN(obj[key]))
                    obj[key] = attach[key];
            }
        }
    };

    exports.fire = function (callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = self._argsAsArray(arguments);
        args.splice(0, 1);

        setTimeout(function () {
            callback.apply(this, args);
        }, 0);
    }


    exports.invoke = function (c, callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = exports._argsAsArray(arguments);
        var sliced = args.splice(0, 2);

        setTimeout(function () {
            callback.apply(sliced[0], args);
        }, 0);
    }

    // source - stackoverflow
    exports.toProperCase = function (str) {
        var noCaps = ['of', 'a', 'the', 'and', 'an', 'am', 'or', 'nor', 'but', 'is', 'if', 'then',
            'else', 'when', 'at', 'from', 'by', 'on', 'off', 'for', 'in', 'out', 'to', 'into', 'with'
        ];
        return str.replace(/\w\S*/g, function (txt, offset) {
            if (offset != 0 && noCaps.indexOf(txt.toLowerCase()) != -1) {
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

    exports.guid = function () {
        return s4() + s4() + '-' +
            s4() + '-' + s4() +
            '-' + s4() + '-' +
            s4() + s4() + s4();
    }

    exports.addEvent = (function () {
        if (window.document.addEventListener) {
            return function (el, type, fn) {
                if (el && el.nodeName || el === window) {
                    el.addEventListener(type, fn, false);
                } else if (el && el.length) {
                    for (var i = 0; i < el.length; i++) {
                        addEvent(el[i], type, fn);
                    }
                }
            };
        } else {
            return function (el, type, fn) {
                if (el && el.nodeName || el === window) {
                    el.attachEvent('on' + type, function () {
                        return fn.call(el, window.event);
                    });
                } else if (el && el.length) {
                    for (var i = 0; i < el.length; i++) {
                        addEvent(el[i], type, fn);
                    }
                }
            };
        }
    })();

    exports.bind = function (selector, parent, listeners, event, callback) {
        if (typeof listeners[selector] !== 'undefined') {
            if (typeof listeners[selector][event] !== 'undefined')
                $.lib(selector).off(event, listeners[selector][event]);
        } else {
            listeners[selector] = {};
        }

        // var parent = $(selector)
        //   , _temp = undefined
        //   , scoping = include('constants').scopeMaxLayerCount;

        // while(typeof (_temp = parent.parent()) !== 'undefined' && --scoping >= 0){
        //     parent = _temp;
        // }

        $.lib(parent).on("click", selector, listeners[selector][event] = function (e) {
            e.preventDefault();
            e.stopPropagation();
            exports.invoke(this, callback, e);
        });
    }

    exports.unbindAll = function (listeners) {
        for (var selector in listeners)
            for (var event in listeners)
                $.lib(selector).off(event, listeners[selector][event]);
    }

    exports.localStorage.exists = function () {
        return typeof window.localStorage !== 'undefined';
    }

    exports.localStorage.set = function (name, value) {
        window.localStorage.setItem(name, value);
    }

    exports.localStorage.get = function (name) {
        return window.localStorage.getItem(name);
    }

    exports.localStorage.has = function (name) {
        return !(typeof self.localStorage.get(name) === 'undefined' || self.localStorage.get(name) == null);
    }

    exports.localStorage.flush = function () {
        window.localStorage.clear();
    }

    exports.execute = function (id, ctx, callback) {
        if (typeof callback === 'undefined') {
            callback = ctx;
            ctx = this;
        }

        if (typeof running[id] === 'undefined') {
            running[id] = "active";
            this.invoke(ctx, callback);
        } else if (running[id] === 'not-active') {
            running[id] = "active";
            this.invoke(ctx, callback);
        }
    }

    exports.completed = function (id) {
        running[id] = "not-active";
    }

    exports.fire = function (callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = self._argsAsArray(arguments);
        args.splice(0, 1);

        callback.apply(this, args);
    }

    exports.dfire = function (callback, args) {

        if (typeof callback !== 'function') {
            return;
        }

        if (typeof args.reverse === 'undefined') {
            return;
        }

        callback.apply(this, args);
    }

    exports.invoke = function (c, callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = self._argsAsArray(arguments);
        var sliced = args.splice(0, 2);

        callback.apply(sliced[0], args);
    }

    exports.hash = function (str) {

        if (typeof str !== 'string') return 0;

        var hash = 0,
            i, char;

        if (str.length == 0) {
            return hash;
        }

        for (i = 0, l = str.length; i < l; i++) {
            char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash |= 0;
        }

        return hash;
    }

    exports._argsAsArray = function (args) {
        return Array.prototype.splice.call(args, 0);
    }

    exports.redirect = function (href) {
        window.location.href = href;
    }

    exports.hashdirect = function (has) {
        window.location.hash = has;
    }

    exports.getHashAsObj = function () {
        return self.uri.decodeFromHash(window.location.hash);
    }

    exports.toState = function (s) {
        var obj = self.uri.decodeFromHash(window.location.hash);;
        obj.state = s;
        this.hashdirect(self.uri.encodeToHash(obj));
    }

    exports.setHashWithObj = function (obj) {
        window.location.hash = self.uri.encodeToHash(obj);
    }

    function BrowserCompatibility() {
        var browser = (function () {

            var ua = navigator.userAgent,
                tem, M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*([\d\.]+)/i) || [];

            if (/trident/i.test(M[1])) {
                tem = /\brv[ :]+(\d+(\.\d+)?)/g.exec(ua) || [];
                return 'IE ' + (tem[1] || '');
            }

            M = M[2] ? [M[1], M[2]] : [navigator.appName, navigator.appVersion, '-?'];

            if ((tem = ua.match(/version\/([\.\d]+)/i)) != null)
                M[2] = tem[1];

            return M.join(' ');

        })().toLowerCase();

        var execute = function (b, callback) {
            if (browser.indexOf(b) > -1)
                include('toolkit').fire(callback);
        }

        this.chrome = function (callback) {
            execute('chrome', callback);
            return this;
        }

        this.firefox = function (callback) {
            execute('firefox', callback);
            return this;
        }

        this.explorer = function (callback) {
            execute('ie', callback);
            return this;
        }
    }

    exports.chrome = function (callback) {
        return new BrowserCompatibility().chrome(callback);
    }

    exports.firefox = function (callback) {
        return new BrowserCompatibility().firefox(callback);
    }

    exports.explorer = function (callback) {
        return new BrowserCompatibility().explorer(callback);
    }

    var afterEvents = {};

    exports.after = function (id, s, callback) {
        clearTimeout(afterEvents[id]);
        afterEvents[id] = setTimeout(callback, s)
    }

    // For regex expression help, refer to http://www.cyber-reality.com/regexy.html
    // Produces cleaner urls that will look aesthetically better on browsers
    // and will be easier for users to understand. Primarily, it helps produce
    // a non-refresh experience on the web. Depends on elixir.js
    //
    // Consider these cases:
    //
    // Input:   turredo.com#context[home]:id[940398]
    // Output:  context = "home";
    //          state = "?context=home&id=940398";
    // Input:   turredo.com#context[request]:id[34322]:date[452334]
    // Output:  state = "?context=request&id=34322&date=452334"
    //
    // It accept either the Input or the Output and produce the Output or Input
    // respectively.

    var _encodeURI = function (str) {
        return encodeURI(str).replace(/\:/g, "%3A");
    }

    var _decodeURI = function (str) {
        return decodeURI(str).replace(/\%3A/g, ":");
    }

    var _decoder = function (a) {
        if (typeof a.reverse === 'undefined') return {};
        if (a === null) return {};

        var map = {};

        a.each(function (e, i, arr) {
            if (i % 2 == 1) map[_decodeURI(arr[i - 1])] = _decodeURI(this);
        });

        return map;
    }

    var _encoder = function (a, before, pre, post, after) {
        if (typeof a !== 'object') return;
        if (typeof before !== 'string') return;
        if (typeof pre !== 'string') return;
        if (typeof post !== 'string') return;
        if (typeof after !== 'string') return;

        var params = before;

        for (var key in a)
            params += _encodeURI(key) + pre + _encodeURI(a[key]) + post + after;

        return params.substring(0, params.length - after.length);
    }

    exports.uri.decodeFromBasic = function (a) {
        if (typeof a !== 'string') return;

        return _decoder(a.split(/[\?|\&|\#]*([^=]*)=([^&]*)/g).removeAll(""));
    }

    exports.uri.decodeFromHash = function (a) {
        if (typeof a !== 'string') return;

        return _decoder((a + ":").split(/[#]*([^\[]*?)\[([^\]|\:]*?)\]:/g).removeAll(""));
    }

    exports.uri.encodeToBasic = function (a) {
        return _encoder(a, "?", "=", "", "&");
    }

    exports.uri.encodeToHash = function (a) {
        return _encoder(a, "#", "[", "]", ":");
    }

    exports.set = function (obj, val) {
        $[obj] = val;
    }

    exports.configure = function (callback) {
        exports.fire(callback);
    }

    exports.init = function () {
        exports.ajax = $.lib.ajax;
        exports.get = $.lib.get;
        exports.post = $.lib.post;

        exports.waitForImages = function (sel, callback) {
            $.lib(sel).waitForImages(callback);
        }
    }

    attach(__context, exports);

})('toolkit');