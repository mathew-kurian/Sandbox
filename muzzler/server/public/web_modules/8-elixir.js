/*
 *
 * Elixir.js
 * @author Mathew Kurian
 *
 * !-- includes -- !
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
// Constants
// -----------------------------------------------------------------------------

(function(__console) {
    
    var console = __console;

    var __elixir_cstate_identifier = "elixir-cstate";
    var __elixir_publicstorage_identifier = "elixir-publicstorage";
    var __elixir_hash_identifier = 'elixir-global-hash';
    var __elixir_cache_identifier = 'elixir-content-cache';

    var toolkit = include('toolkit');
    var codes = include('codes');
    var store = include('store');
    var jsonfn = include('jsonfn');
    var Emitter = include('emitter');
    var Safely = include('safely');

    var exports = Emitter.attach({}).silent(false);

    var $ = exports.$;
    var layers = [];
    var cache;
    var publicStorage = {};

    // -------------------------------------------------------

    attach(__elixir_publicstorage_identifier, publicStorage);

    function Cache(c) {

        var exports = {};        
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

                Safely.attach(exports[e]);

            })(e, exports);
        });

        this.memory = function() {
            var obj = {};
            partitions.each(function(e, i, a) {
                obj[e] = exports[e];
            });

            return obj;
        }

        toolkit.extend(this, exports);

        return this;
    };

    // State interface
    function State(n) {

        var self = Safely.attach(Emitter.attach(this));

        self.inherits = undefined;
        self._name = n;
        self.name = function(){}
        self.ready = function() {};
        self.bind = function() {};
        self.load = function() {};
        self.resize = function() {};
        self.unbind = function() {};
        self.destroy = function() {};
        self.update = function(params) {}

        // --- internal use only ---
        self.__js__ = '';

        return this;
    }

    exports.sequence = function(name, req, callback) {

        if (typeof name === 'undefined') {
            return toolkit.fire(callback, codes.status.OK, 'Loaded state', req);
        }

        var tonext = function(state) {
            req.push(name);
            exports.sequence(state.inherits, req, callback);
        }

        if (!cache.hasState(name)) {
            exports.downloadex(name, function(code, msg, state) {
                if (code !== codes.status.OK)
                    return toolkit.fire(callback, code, msg, req);
                tonext(state);
            });
        } else {
            tonext(cache.getState(name));
        }

        return req;
    }

    exports.downloadex = function(name, callback) {

        var state = new State(name);

        downloadstate(state, function(code, msg) {

            console.info('State request complete.');

            if(toolkit.error(code)){
                console.error('State downloaded error dectected.');
                return toolkit.fire(callback, code, msg);                
            }

            attach(__elixir_cstate_identifier, state);

            var superVar = "elixir_gen_super_" + Math.floor((Math.random() * 10000)).toString();  
            var inherits = /\n[\s|\t]{1,}"extend\s{1,}(.*?)\s{0,}";/g.exec(state.__js__);

            window[superVar] = undefined;              

            if(inherits && inherits.length > 1){
                state.inherits = inherits[1];
                window[superVar] = cache.getState(inherits[1]);
            } 

            var scoping = "(function(%s,%s,%s,%s,%s){%s;})(%s,%s,%s,%s,%s)".f('exports','__filename', '__super', '__shared', 
                'global', state.__js__, 'include("elixir-cstate")', '"' + state._name + '"', superVar, 'include("elixir-publicstorage")', 'window');

            window.eval.call(window,  scoping);

            cache.setState(name, state);
            toolkit.fire(callback, code, msg, state);

            console.info('State downloaded successfully.');
        });
    }

    exports.load = function(name, callback) {

        var state;

        exports.sequence(name, [], function(err, msg, req) {

            if (toolkit.error(err)){
                alert(msg);
                return console.error(msg);
            }

            exports.exec(layers, req, function(n, i, a) {

                console.info("Unload " + n);

                if (typeof(state = cache.getState(n)) !== 'undefined') {
                    state.unbind();
                    state.destroy();
                }

            }, function(n, i, a) {

                console.info("Create " + n);

                (function(state, n){

                    if (typeof state !== 'undefined') {

                        try {

                            document.title = state.name();

                            state.ready();
                            state.bind();

                            toolkit.waitForImages('body', function() {
                                if (layers.indexOf(state._name) > -1)
                                    state.load();
                            });

                        } catch (e) {
                            console.error(e);
                            toolkit.fire(callback, codes.status.FAILED, "Detected error");
                        }
                    }

                })(cache.getState(n), n);

            }, function() {

                console.info("Propgating resize event");

                layers = req;
                resizeHandler();
                toolkit.fire(callback, codes.status.OK, "Loaded sequence successfully.");

            });
        });
    }

    exports.exec = function(existing, request, destroy, create, finish) {

        if (!toolkit.is.array(existing)) 
            throw TypeError("existing - not of array type.");
        if (!toolkit.is.array(request)) 
            throw TypeError("request - not of array type.");

        if (existing.length == 0 && request.length == 0)
            return [];

        // O(3n) complexity
        // FIXME Remove the need to equalize array lengths!
        
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

    var downloadstate = function(state, callback) {
        download($.statesURL, state._name, function(data) {
            state.__js__ = data.data;
        }, callback);
    }

    var updateHandler = function(params) {
        layers.each(false, function(e, i, a) {
            try {
                cache.getState(e).update(params);
            } catch (c) {
                console.info(e + " " + a + " - " + c);
            }
        });
    }

    var hashChangeHandler = function(event, overridehash) {

        var hash = toolkit.safely(overridehash, window.location.hash);
        var params = {};

        // Update local storage
        store.set(__elixir_hash_identifier, hash);

        params = toolkit.uri.decodeFromHash(hash);
        params = Safely.attach(params);
        params.set('state', params.safely('state', $.defaultState));

        console.info("Requested state - " + params.state);

        if (params.state === layers[0]) {
            console.info("Propgating update event.");
            return updateHandler(params);
        }

        exports.load(params.state, function(code, msg) {
            if (code === codes.status.OK) {
                console.info("State changed to " + params.state);
                console.info("Propgating update event.");
                updateHandler(params);
                // exports.saveCacheToClientStorage();
            } else {
                console.error(msg);
            }
        });
    }

    exports.saveCacheToClientStorage = function() {
        store.set(__elixir_cache_identifier, jsonfn.stringify(cache.memory()));
    }

    var resizeHandler = function() {
        layers.each(false, function(e, i, a) {
            try {
                cache.getState(e).resize();
            } catch (e) {
                console.error(e);
            }
        });
    }
    exports.init = function() {

        cache = new Cache();

        // Add listeners for localStorage
        toolkit.addEvent(window, 'storage', function(event) {
            if (event.key == __elixir_hash_identifier) {
                window.location.hash = store.get(event.key);
            }
        });

        window.onhashchange = hashChangeHandler;
        window.onresize = resizeHandler;

        // invoke the first time
        hashChangeHandler();
    }

    attach('core', exports);

})(console.t('elixir.js'));