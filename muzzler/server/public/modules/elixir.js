/*
 *
 * Elixir.js
 * @author Mathew Kurian
 *
 * !-- Requires -- !
 * Nickname.js [Attached in this bundle]
 *
 * From Elixir.js-ClientSide v1.0
 *
 * Please report any issues
 * https://github.com/bluejamesbond/Elixir.js/issues
 *
 * Date: 4/19/2014
 * Protected under Apache V2 License
 *
 */

// -----------------------------------------------------------------------------
// Javascript Core Addons
// -----------------------------------------------------------------------------

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

// This is too good. - Courtesy of Google. Not mine.
Array.prototype.shuffle = function(){ 
    for(var j, x, i = this.length; i; j = Math.floor(Math.random() * i), x = this[--i], this[i] = this[j], this[j] = x);
    return this;
};

Array.prototype.asyncEach = function(callback) {
    if (typeof callback !== 'function') return;

    for (var i = 0; i < this.length; i++)
        (function(i, arr) {
            setTimeout(function() {
                callback.apply(arr[i], [arr[i], i, arr]);
            }, 0);
        })(i, this);
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

// -----------------------------------------------------------------------------
// Require
// -----------------------------------------------------------------------------

(function(ctx) {

    var exports = {};
    var models = {};

    exports.attach = function(nickname, model) {
        models[nickname] = model;
    };

    ctx.require = function(nickname) {
        if (typeof models[nickname] === 'undefined')
            throw new RangeError(nickname + " - could not find submodule. More details: /n" + arguments.callee.caller.toString());
        else if (typeof models[nickname] === 'function')
            return models[nickname]();
        else return models[nickname];
    };

    ctx.Elixir = exports;

})(window);

// -----------------------------------------------------------------------------
// Constants
// -----------------------------------------------------------------------------

(function(__context) {

    var exports = {};

    exports.elog = "/elog"
    exports.scopeMaxLayerCount = 10;
    exports.localStorageEnabled = false;
    exports.debugEnabled = true;
    exports.defaultState = "home";
    exports.statesURL = "/states";
    exports.domain = "mus";
    exports.address = "http://www.mus.ec";
    exports.development = true;

    Elixir.attach(__context, exports);

})('elixir/constants');

// -----------------------------------------------------------------------------
// Codes
// -----------------------------------------------------------------------------

(function(__context) {

    var exports = {};

    exports.behavior = {
        'VALIDATION_ERROR': -1,
        'ACTIVE': 2,
        'UNKOWN_ERROR': -3,
        'DEFINED_ERROR': -2,
        'INACTIVE': 1,
        'COMPLETED': 0,
        failed : function(s){
            if(s < 0) return true;
        },
        ok : function(s){
            if(s == 0) return true;
        },
        other : function(s){
            if( s == 1 || s == 2 ) return true;
        }
    };

    exports.status = {
        'FAILED': 1,
        'OK': 0,
        'NO_TYPE': 2,
        'DB_ERROR': 3
    };

    Elixir.attach(__context, exports);

})('elixir/codes');

// -----------------------------------------------------------------------------
// Toolkit
// -----------------------------------------------------------------------------

(function(__context) {

    var exports = {};

    var out = function(m) {
        return function() {
            if (!require('elixir/constants').debugEnabled) return;

            var argsList = require('elixir/toolkit')._argsAsArray(arguments);

            if (argsList.length == 0) return;

            var tags = "",
                msg = argsList[argsList.length - 1];

            argsList.splice(argsList.length - 1, 1);

            if (argsList.length > 0)
                argsList.each(function(e, i, a) {
                    if (typeof e === 'undefined') return;

                    if (e.length > 0) {
                        e = e.toString().toLowerCase();
                        e = e.substring(0, 1).toUpperCase() + e.substring(1);
                        tags += String.format("[%s]", e);
                    }
                });

            console[m].call(console, tags + " " + msg);

            $.post("//mus.ec" + require('elixir/constants').elog, {
               data : tags + " " + msg
            }, function(){});
        }
    }

    exports.log = out('log');
    exports.error = out('error');
    exports.info = out('info');

    Elixir.attach(__context, exports);

})('elixir/debug');

// -----------------------------------------------------------------------------
// Toolkit
// -----------------------------------------------------------------------------

(function(__context) {

    var exports = {}, activeElements = {};

    exports.uri = {};
    exports.localStorage = {};

    exports.addEvent = (function() {
        if (window.document.addEventListener) {
            return function(el, type, fn) {
                if (el && el.nodeName || el === window) {
                    el.addEventListener(type, fn, false);
                } else if (el && el.length) {
                    for (var i = 0; i < el.length; i++) {
                        addEvent(el[i], type, fn);
                    }
                }
            };
        } else {
            return function(el, type, fn) {
                if (el && el.nodeName || el === window) {
                    el.attachEvent('on' + type, function() {
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

    exports.bind = function(selector, parent, listeners, event, callback) {
        if (typeof listeners[selector] !== 'undefined') {
            if (typeof listeners[selector][event] !== 'undefined')
                $.lib(selector).off(event, listeners[selector][event]);
        } else
            listeners[selector] = {};

        // var parent = $(selector)
        //   , _temp = undefined
        //   , scoping = require('elixir/constants').scopeMaxLayerCount;

        // while(typeof (_temp = parent.parent()) !== 'undefined' && --scoping >= 0){
        //     parent = _temp;
        // }

        $.lib(parent).on("click", selector, listeners[selector][event] = function(e) {
            e.preventDefault();
            e.stopPropagation();
            exports.invoke(this, callback, e);
        });
    }

    exports.unbindAll = function(listeners) {
        for (var selector in listeners)
            for (var event in listeners)
                $.lib(selector).off(event, listeners[selector][event]);
    }

    function Safely(obj) {
        this.exists = function(callback) {
            if (typeof obj !== 'undefined')
                callback.call(obj, callback);

            return this;
        }

        this.noexists = function(callback) {
            if (typeof obj === 'undefined')
                require('elixir/toolkit').fire(callback);

            return this;
        }

        return this;
    }

    exports.safely = function(obj) {
        return new Safely(obj);
    }

    exports.localStorage.exists = function() {
        return typeof window.localStorage !== 'undefined';
    }

    exports.localStorage.set = function(name, value) {
        window.localStorage.setItem(name, value);
    }

    exports.localStorage.get = function(name) {
        return window.localStorage.getItem(name);
    }

    exports.localStorage.has = function(name) {
        return !(typeof exports.localStorage.get(name) === 'undefined' || exports.localStorage.get(name) == null);
    }

    exports.localStorage.flush = function() {
        window.localStorage.clear();
    }

    exports.clone = function(obj) {
        if (obj == null || typeof(obj) != 'object')
            return obj;

        var temp = obj.constructor();

        for (var key in obj)
            temp[key] = clone(obj[key]);

        return temp;
    }

    exports.extend = function(obj, attach, override) {
        override = typeof override !== 'boolean' ? true : override;

        for (var key in attach)
            if (override)
                obj[key] = attach[key];
            else
        if (typeof obj[key] === 'undefined')
            obj[key] = attach[key];
    };

    exports.execute = function(id, ctx, callback) {
        if (typeof callback === 'undefined') {
            callback = ctx;
            ctx = this;
        }

        if (typeof activeElements[id] === 'undefined') {
            activeElements[id] = "active";
            this.invoke(ctx, callback);
        } else if (activeElements[id] === 'not-active') {
            activeElements[id] = "active";
            this.invoke(ctx, callback);
        }
    }

    exports.completed = function(id) {
        activeElements[id] = "not-active";
    }

    exports.fire = function(callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = exports._argsAsArray(arguments);
        args.splice(0, 1);

        callback.apply(this, args);
    }

    exports.dfire = function(callback, args) {

        if (typeof callback !== 'function') {
            return;
        }

        if(typeof args.reverse === 'undefined'){
            return;
        }
        
        callback.apply(this, args);
    }

    exports.invoke = function(c, callback) {

        if (typeof callback !== 'function') {
            return;
        }

        var args = exports._argsAsArray(arguments);
        var sliced = args.splice(0, 2);

        callback.apply(sliced[0], args);
    }

    exports.hash = function(str) {

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

    exports._argsAsArray = function(args) {
        return Array.prototype.splice.call(args, 0);
    }

    exports.redirect = function(href) {
        window.location.href = href;
    }

    exports.hashdirect = function(has) {
        window.location.hash = has;
    }

    exports.getHashAsObj = function() {
        return this.uri.decodeFromHash(window.location.hash);
    }

    exports.toState = function(s){
        var obj = this.uri.decodeFromHash(window.location.hash);;
        obj.state = s;
        this.hashdirect(this.uri.encodeToHash(obj));
    }

    exports.setHashWithObj = function(obj) {
        window.location.hash = this.uri.encodeToHash(obj);
    }

    function BrowserCompatibility() {
        var browser = (function() {

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

        var execute = function(b, callback) {
            if (browser.indexOf(b) > -1)
                require('elixir/toolkit').fire(callback);
        }

        this.chrome = function(callback) {
            execute('chrome', callback);
            return this;
        }

        this.firefox = function(callback) {
            execute('firefox', callback);
            return this;
        }

        this.explorer = function(callback) {
            execute('ie', callback);
            return this;
        }
    }

    exports.chrome = function(callback) {
        return new BrowserCompatibility().chrome(callback);
    }

    exports.firefox = function(callback) {
        return new BrowserCompatibility().firefox(callback);
    }

    exports.explorer = function(callback) {
        return new BrowserCompatibility().explorer(callback);
    }

    var afterEvents = {};

    exports.after = function(id, s, callback) {
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

    var _encodeURI = function(str) {
        return encodeURI(str).replace(/\:/g, "%3A");
    }

    var _decodeURI = function(str) {
        return decodeURI(str).replace(/\%3A/g, ":");
    }

    var _decoder = function(a) {
        if (typeof a.reverse === 'undefined') return {};
        if (a === null) return {};

        var map = {};

        a.each(function(e, i, arr) {
            if (i % 2 == 1) map[_decodeURI(arr[i - 1])] = _decodeURI(this);
        });

        return map;
    }

    var _encoder = function(a, before, pre, post, after) {
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

    exports.uri.decodeFromBasic = function(a) {
        if (typeof a !== 'string') return;

        return _decoder(a.split(/[\?|\&|\#]*([^=]*)=([^&]*)/g).removeAll(""));
    }

    exports.uri.decodeFromHash = function(a) {
        if (typeof a !== 'string') return;

        return _decoder((a + ":").split(/[#]*([^\[]*?)\[([^\]|\:]*?)\]:/g).removeAll(""));
    }

    exports.uri.encodeToBasic = function(a) {
        return _encoder(a, "?", "=", "", "&");
    }

    exports.uri.encodeToHash = function(a) {
        return _encoder(a, "#", "[", "]", ":");
    }

    exports.set = function(obj, val) {
        $[obj] = val;
    }

    exports.configure = function(callback) {
        exports.fire(callback);
    }

    exports.init = function() {
        exports.ajax = $.lib.ajax;
        exports.get = $.lib.get;
        exports.post = $.lib.post;

        exports.waitForImages = function(sel, callback) {
            $.lib(sel).waitForImages(callback);
        }
    }

    Elixir.attach(__context, exports);

})('elixir/toolkit');

(function(__context) {

    var exports = {};

    var __elixir_cstate_identifier = "elixir/cstate";
    var __elixir_hash_identifier = 'elixir-global-hash';
    var __elixir_cache_identifier = 'elixir-content-cache';

    String.format = function() {
        var args = require('elixir/toolkit')._argsAsArray(arguments);
        if (args.length == 0) return "";

        var smb = args.shift();;

        args.each(function(e, i, a) {
            smb = smb.replace("%s", this.toString());
        });

        return smb;
    }

    // -------------------------------------------------------

    var layers = [],
        $ = {},
        cache,
        privateStorage = {},
        publicStorage = {};

    var safely = {
        'safely': function(val, def) {
            return typeof this[val] === 'undefined' ? def : this[val];
        }
    };

    function Cache(c) {

        var exports = {};
        var toolkit = require('elixir/toolkit');
        var partitions = ['state', 'persistence'];

        partitions.each(function(e, i, a) {
            (function(e, exports) {

                var e_ = e.substring(0, 1).toUpperCase() + e.substring(1);

                exports[e] = {};

                exports['get' + e_] = function(a) {
                    return exports[e][a];
                }

                exports['has' + e_] = function(a) {
                    return typeof exports[e][a] !== 'undefined';
                }

                exports['set' + e_] = function(a, v) {
                    return exports[e][a] = v;
                }

                toolkit.extend(exports[e], safely);

            })(e, exports);
        });

        this.setMemory = function(c) {
            for (var e in c) {
                exports[e] = c[e];
            }
        }

        this.clearState = function(c){
            delete exports['state'][c];
        }

        this.getMemory = function() {
            var obj = {};
            partitions.each(function(e, i, a) {
                obj[e] = exports[e];
            });

            return obj;
        }

        toolkit.extend(this, exports);

        return this;
    };

    function ClassifiedStorage(pu, pr, pe) {

        var toolkit = require('elixir/toolkit'),
            _public = pu,
            _private = pr,
            _persistence = pe;

        this.public = function() {
            return _public;
        }

        this.private = function() {
            return _private;
        }

        this.persistence = function() {
            return _persistence;
        }

        toolkit.extend(_public, safely);
        toolkit.extend(_private, safely);
        toolkit.extend(_persistence, safely);
    }

    ClassifiedStorage.from = function(name) {
        return new ClassifiedStorage(publicStorage, privateStorage[name], exports.persistence());
    }

    exports.persistence = function() {
        return cache.persistence;
    }

    exports.getCache = function() {
        return cache;
    }

    // State interface
    function State() {

        var listeners = {};
        var __context = 'muistate-default';

        this.name = function() {};
        this.after = function() {
            return undefined;
        };
        this.ready = function() {};
        this.bind = function() {};
        this.load = function() {};
        this.resize = function() {};
        this.unbind = function() {};
        this.destroy = function() {};
        this.update = function(params) {}
        this.extend = function(obj) {
            require('elixir/toolkit').extend(this, obj, true);
        };

        // --- message broadcasting --
        // Overriding these will cause you problems!

        this.fireListeners = function(type, event){
            var toolkit = require('elixir/toolkit');
            var debug = require('elixir/debug');
            try { if( typeof listeners[type][event] === 'undefined') return; } catch(e){ return; }
            var args = toolkit._argsAsArray(arguments);
            args.splice(0, 2);
            for(var key in listeners[type][event])
                toolkit.dfire(listeners[type][event][key], args);
            if(!(type === 'audio' && event === 'timeupdate')) debug.info(__context, String.format('Listeners fired for `%s` on `%s` event.', type, event));
        }
        
        this.broadcast = this.fireListeners;

        this.on = function(type, event, callback){
            var toolkit = require('elixir/toolkit');
            var debug = require('elixir/debug');
            if(typeof listeners[type] === 'undefined') listeners[type] = {};
            if(typeof listeners[type][event] === 'undefined') listeners[type][event] = {};
            listeners[type][event][toolkit.hash(callback.toString())+ ''] = callback;
            debug.info(__context, String.format('Listener add for `%s` on `%s` event.', type, event));
        }

        this.off = function(type, event, callback){
            var toolkit = require('elixir/toolkit');
            var debug = require('elixir/debug');
            try { 
                delete  listeners[type][event][toolkit.hash(callback.toString()) + ''];  
                debug.info(__context, String.format('Listener removed for `%s` on `%s` event.', type, event));
            } catch(e){
                debug.info(__context, String.format('Listener could not be removed for `%s` on `%s` event.', type, event));
            }
        }

        // --- internal use only ---
        this._asJavaScript = '';

        return this;
    }

    exports.getStateSequence = function(name, req, callback) {

        var toolkit = require('elixir/toolkit'),
            codes = require('elixir/codes');

        if (typeof name === 'undefined') {
            return toolkit.fire(callback, codes.status.OK, 'Loaded state', req);
        }

        var tonext = function(state) {
            req.push(name);
            exports.getStateSequence(state.after(), req, callback);
        }

        if (!cache.hasState(name)) {
            exports.downloadStateEx(name, function(code, msg, state) {
                if (code !== codes.status.OK)
                    return toolkit.fire(callback, code, msg, req);
                tonext(state);
            });
        } else {

            tonext(cache.getState(name));
        }

        return req;
    }

    exports.downloadStateEx = function(name, callback) {

        var debug = require('elixir/debug'),
            toolkit = require('elixir/toolkit'),
            codes = require('elixir/codes');

        // ----
        var state = new State();
        state._name = name;
        privateStorage[name] = {};
        // ----

        downloadState(state, function(code, msg) {

            debug.info(__context, 'State request complete.');

            if (code === codes.status.OK) {
                Elixir.attach(__elixir_cstate_identifier, state);
                window.eval.call(window, state._asJavaScript);
                debug.info(__context, 'State downloaded successfully.');
                cache.setState(name, state);
                toolkit.fire(callback, code, msg, state);
            } else {
                debug.error(__context, 'State downloaded error dectected.');
                toolkit.fire(callback, code, msg);
            }

        });
    }

    exports.loadStateSequence = function(name, callback) {

        var __identifier = 'loadStateSequence';
        var codes = require('elixir/codes');
        var toolkit = require('elixir/toolkit');
        var debug = require('elixir/debug');
        var state;

        exports.getStateSequence(name, [], function(err, msg, req) {

            if (err) {
                alert(msg);
                // toolkit.hashdirect('#');
                return debug.error(__context, __identifier, msg);
            }

            exports.execLongestSubsequence(layers, req, function(n, i, a) {

                debug.info(__context, __identifier, "Unload " + n);

                if (typeof(state = cache.getState(n)) !== 'undefined') {
                    state.unbind();
                    state.destroy();
                }

            }, function(n, i, a) {

                debug.info(__context, "Create " + n);

                (function(state, n){
                    if (typeof state !== 'undefined') {

                        var cstorage = ClassifiedStorage.from(n);

                        (function(after){
                            toolkit.extend(state, {
                                'super': function() {
                                    return cache.getState(after);
                                }
                            }, true);
                        })(a[i + 1]);

                        toolkit.extend(state, cstorage);

                        try {

                            document.title = state.name();

                            state.ready();
                            state.bind();

                            toolkit.waitForImages('body', function() {
                                if (layers.indexOf(state._name) > -1) {
                                    state.load();
                                }
                            });

                        } catch (e) {
                            debug.error(__context, e);
                            toolkit.fire(callback, codes.status.FAILED, "Detected error");
                        }
                    }
                })(cache.getState(n), n);

            }, function() {

                layers = req;

                resizeHandler();
                debug.info(__context, "Propgating resize event");

                toolkit.fire(callback, codes.status.OK, "Loaded sequence successfully.");

            });
        });
    }

    exports.execLongestSubsequence = function(existing, request, destroy, create, finish) {

        if (typeof existing.reverse === 'undefined') throw TypeError("existing - not of array type.");
        if (typeof request.reverse === 'undefined') throw TypeError("request - not of array type.");

        if (existing.length == 0 && request.length == 0)
            return [];

        // O(3n) complexity
        // FIXME Remove the need to equalize array lengths!

        var toolkit = require('elixir/toolkit');
        var __invalid = "___";
        var _c = [];
        var pop_to = 0,
            cr_from = 0,
            pop_from = 0;

        if (existing.length != request.length) {

            var shorter = existing.length > request.length ? request : existing,
                shortBy = Math.abs(existing.length - request.length);

            for (var i = 0; i < shortBy; i++) {
                shorter.splice(0, 0, __invalid);
            }
        }

        var subsequenceLength = existing.length - 1;

        for (var i = subsequenceLength; i >= 0; i--) {

            if (request[i] !== existing[i]) {

                if (request[i] !== __invalid &&
                    existing[i] !== __invalid) {

                    cr_from = i;
                    pop_to = 0;
                    pop_from = i;
                    break;

                } else if (request[i] !== __invalid &&
                    existing[i] === __invalid) {

                    cr_from = i;
                    pop_to = 0;
                    pop_from = -1;
                    break;

                } else if (request[i] === __invalid &&
                    existing[i] !== __invalid) {

                    cr_from = 0;
                    pop_to = 0;
                    pop_from = i;
                    break;

                }
            }
        }

        for (var i = pop_from; i >= pop_to; i--) {
            if (existing[i] !== __invalid) {
                toolkit.fire(destroy, existing[i], i, existing);
                _c.push(existing[i]);
            }
        }

        for (var i = cr_from; i >= 0; i--) {
            if (request[i] !== __invalid) {
                toolkit.fire(create, request[i], i, request);
            }
        }

        request.removeAll(__invalid);
        existing.removeAll(__invalid);

        toolkit.fire(finish);

        return _c;
    }

    var download = function(url, id, postprocess, callback) {
        var constants = require('elixir/constants'),
            toolkit = require('elixir/toolkit'),
            codes = require('elixir/codes');

        toolkit.get(url, {
            id: id
        }, function(data) {

            try {
                data = JSON.parse(data)
            } catch (e) {}

            if (data.code === codes.status.OK)
                postprocess(data);

            toolkit.fire(callback, data.code, 'Server: ' + data.msg);

        }).fail(function() {

            toolkit.fire(callback, codes.status.FAILED,
                'Unable to download. Check if mapping exists and you have a stable internet connection.');

        });
    }

    var downloadState = function(state, callback) {
        download(require('elixir/constants').statesURL, state._name, function(data) {
            state._asJavaScript = data.data;
        }, callback);
    }

    var updateHandler = function(params) {
        layers.each(false, function(e, i, a) {
            try {
                cache.getState(e).update(params);
            } catch (c) {
                console.info(__context, e + " " + a + " - " + c);
            }
        });
    }

    var hashChangeHandler = function(event, overridehash) {
        var toolkit = require('elixir/toolkit'),
            debug = require('elixir/debug'),
            constants = require('elixir/constants'),
            codes = require('elixir/codes');

        var hash = typeof overridehash !== 'undefined' ? overridehash : window.location.hash,
            params = {};

        // Update local storage
        require('elixir/toolkit').localStorage.set(__elixir_hash_identifier, hash);

        params = toolkit.uri.decodeFromHash(hash);
        params = typeof params !== 'object' ? {} : params;
        toolkit.extend(params, {
            'state': constants.defaultState,
        }, false);
        toolkit.extend(params, safely);

        debug.info(__context, "Requested state - " + params.state);

        if (params.state === layers[0]) {
            debug.info(__context, "Propgating update event.");
            return updateHandler(params);
        }

        exports.loadStateSequence(params.state, function(code, msg) {

            if (code === codes.status.OK) {

                debug.info(__context, "State changed to " + params.state);
                debug.info(__context, "Propgating update event.");

                updateHandler(params);

                if (require('elixir/constants').localStorageEnabled) {
                    exports.saveCacheToClientStorage();
                }

            } else {

                debug.error(msg);

            }
        });
    }

    exports.set = function(obj, val) {
        $[obj] = val;
    }

    exports.configure = function(callback) {
        require('elixir/toolkit').fire(callback);
    }

    exports.trigger = function(s) {
        switch (s) {
            case 'save':
                return exports.saveCacheToClientStorage();
        }
    }

    exports.saveCacheToClientStorage = function() {

        var toolkit = require('elixir/toolkit');

        if (!toolkit.localStorage.exists()) return;

        toolkit.localStorage.set(__elixir_cache_identifier, JSONfn.stringify(cache.getMemory()));
    }

    exports.loadCacheFromClientStorage = function() {

        var toolkit = require('elixir/toolkit');

        if (!toolkit.localStorage.exists()) return;

        var memory = JSONfn.parse(toolkit.localStorage.get(__elixir_cache_identifier));
        cache.setMemory(typeof cache === 'undefined' || cache == null ? {} : memory);
    }

    var resizeHandler = function() {
        layers.each(false, function(e, i, a) {
            try {
                cache.getState(e).resize();
            } catch (e) {
                require('elixir/debug').error(__context, e);
            }
        });
    }
    exports.init = function() {

        var toolkit = require('elixir/toolkit');

        cache = new Cache();

        // load from browser cache
        if (require('elixir/constants').localStorageEnabled)
            exports.loadCacheFromClientStorage();

        // Add listeners for localStorage
        if (toolkit.localStorage.exists()) {
            toolkit.addEvent(window, 'storage', function(event) {
                if (event.key == __elixir_hash_identifier) {
                    window.location.hash = toolkit.localStorage.get(event.key);
                }
            });
        }

        window.onhashchange = hashChangeHandler;
        window.onresize = resizeHandler;

        // invoke the first time
        hashChangeHandler();
    }

    Elixir.attach(__context, exports);
    Elixir.attach('elixir/persistence', exports.persistence);

})('elixir/core');