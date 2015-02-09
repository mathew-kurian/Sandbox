
/*
 * 
 * MUI.js
 * @author Brent Enriquez, Mathew Kurian
 * 
 * Please report any issues
 * https://github.com/Muzzler/MUI.js/issues
 * 
 * Date: 4/19/2014
 * Copyright: Muzzler, LLC.
 * 
 */

// -----------------------------------------------------------------------------
// Connection
// -----------------------------------------------------------------------------

(function (__context) {

    var codes = require('elixir/codes')
      , toolkit = require('elixir/toolkit');

    function Input(name, type, regex, validate){
        return { 
                    "name" : name, 
                    "type" : type, 
                    "regex" : (typeof regex === 'undefined' ? new RegExp(/.*/) : regex ), 
                    "validate" : (typeof validate === 'undefined' ? function(s){ return true; } : validate ),
                };
    }

    var selectors = {
        'get-song-data' : {
            layout :  [ Input('sid', 'string') ],
            type : "request-song-data",
            url : "/requestMusicData",
            method : "post"
        },
        'create-user' : {
            layout : [ Input('user', 'string', new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)),
                       Input('pass', 'string', new RegExp(/^(.){6,}$/)), 
                       Input('fname', 'string'), 
                       Input('lname', 'string') ],
            type : "create-new-user",
            url : "/secured",
            method : "post"
        },
        'request-song' : {
            layout : [ Input('user', 'string', new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)),
                       Input('pass', 'string', new RegExp(/^(.){6,}$/)), 
                       Input('fname', 'string'), 
                       Input('lname', 'string') ],
            type : "create-new-user",
            url : "/secured",
            method : "post"
        },
        'request-song' : {
            layout : [ Input('user', 'string', new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)),
                       Input('pass', 'string', new RegExp(/^(.){6,}$/)), 
                       Input('fname', 'string'), 
                       Input('lname', 'string') ],
            type : "create-new-user",
            url : "/secured",
            method : "post"
        }
    }

    exports.connect = function(){

        var toolkit = require('elixir/toolkit');
        var args = toolkit._argsAsArray(arguments);
        var type = args.shift();
        var callback = args.splice(args.length - 1, 1)[0];
        var accessor = selectors[type];
        var layout = accessor.layout;
        var requestData = {};

        if(typeof callback !== 'function') throw TypeError('[Mui/connection] Expecting callback.');
        if(typeof layout === 'undefined') throw RangeError('[Mui/connection] Invalid type.');

        if(layout.length > args.length)
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Expecting more parameters");

        for(var i = 0; i < layout.length; i++){
            var e = layout[i];
            var arg = args[i];
            if(typeof arg === 'string') arg = arg.trim();
            if((typeof arg !== e.type) || (!e.regex.test(arg.toString())) || (!e.validate(arg))) 
                return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, e.name);
            requestData[e.name] = arg;
        }

        if(typeof accessor.type !== 'undefined') 
            requestData.type = accessor.type;

        toolkit.fire(callback, codes.behavior.ACTIVE);

        toolkit[accessor.method](accessor.url, requestData, function (data) {
            try { data = JSON.parse(data) } catch(e){};
            
            if(typeof data !== 'object') {
                data = {};
                data.status = codes.status.FAILED;
                data.message = data;
            } 

            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message, data);
                    break;
                }
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.requestSong = function (request, playlist, callback) {
        
        // Check if the parameters exist
        if (typeof request !== "string"){
            console.log(request);
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "request");
        }

        if (typeof playlist !== "string"){
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "playlist");
        }
        
        request = request.trim();
        playlist = playlist.trim();

        if (request === ''){
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "request");
        }

        if (playlist === ''){
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "playlist");
        }

        toolkit.fire(callback, codes.behavior.ACTIVE);

        toolkit.post("/testPlaylistManager", {
            'type' : "request-song",
            'request' : request,
            'playlist' : playlist
        }, function (data) {

            try { data = JSON.parse(data) } 
            catch(e){};

            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });

    }

    exports.login = function (user, pass, callback) {

        // Check if the parameters exist
        if (typeof user !== "string"){
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "user");
        }

        if (typeof pass !== "string"){
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "password");
        }

        if(!exports.validate.email(user)){ 
            return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, "user");
        }

        toolkit.fire(callback, codes.behavior.ACTIVE);

        toolkit.post("/login", {
            'user' : user,
            'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            data = JSON.parse(data);
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }



    exports.test1 = function() {
        toolkit.post("/testPlaylistManager", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.test2 = function() {
        toolkit.post("/testAddSongToPlaylist", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.test3 = function() {
        toolkit.post("/testDeletePlaylist", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.testLogin = function() {
        toolkit.post("/login", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.testLogin2 = function() {
        toolkit.post("/login2", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    exports.testLogoff = function() {
        toolkit.post("/logoff", {
            // 'type' : "login",
            // 'user' : user,
            // 'pass' : (pass = toolkit.hash(pass)).toString()
        }, function (data) {
            
            switch(data.status) {
                case codes.status.OK: {
                    toolkit.fire(callback, codes.behavior.COMPLETED, data.message);
                    break;
                }    
                default: {
                    toolkit.fire(callback, codes.behavior.DEFINED_ERROR, data.message);
                    break;
                }
            }

            toolkit.fire(callback, codes.behavior.INACTIVE);

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE);
        });
    }

    Elixir.attach(__context, exports);

})('mui/connection');

// -----------------------------------------------------------------------------
// GUI
// -----------------------------------------------------------------------------

(function (__context) {

    var codes = require('elixir/codes');
    var exports = {};

    var $ = {};

    exports.set = function (obj, val) {
        $[obj] = val;
    }

    exports.configure = function (callback) {
        require('elixir/toolkit').fire(callback);
    }

    exports.expand = function () {

        function Transform3d(jObject) {
            this.desc = "";
            this.obj = jObject;

            this.translate = function (x, y, z) {
                this.desc += ' translate3d(' + x + ',' + y + ',' + z + ')';
                return this;
            };
            this.scale = function (x, y, z) {
                this.desc += ' scale3d(' + x + ',' + y + ',' + z + ')';
                return this;
            };
            this.rotate = function (x, y, z) {
                this.desc += ' rotate3d(' + x + ',' + y + ',' + z + ')';
                return this;
            };
            this.apply = function () {

                var obj = this.obj;
                var desc = this.desc;

                (obj = $.lib(obj)).css({
                    '-webkit-transform': desc,
                    '-ms-transform': desc,
                    '-moz-transform': desc,
                    'transform': desc,
                });

                return obj;
            };
        }

        $.lib.fn.transform3d = function () {
            return new Transform3d(this);
        };

        $.lib.fn.center = function () {
            this.css("position", "absolute");
            this.css("top", Math.max(0, (($.lib(window).height() - this.outerHeight()) / 2) +
                $.lib(window).scrollTop()) + "px");
            this.css("left", Math.max(0, (($.lib(window).width() - this.outerWidth()) / 2) +
                $.lib(window).scrollLeft()) + "px");
            return this;
        }

        $.lib.fn.centerInParent = function () {
            this.css("position", "absolute");
            this.css("top", Math.max(0, ((this.parent().height() - this.outerHeight()) / 2) +
                this.parent().scrollTop()) + "px");
            this.css("left", Math.max(0, ((this.parent().width() - this.outerWidth()) / 2) +
                this.parent().scrollLeft()) + "px");
            return this;
        }
    }

    function GridBuilder(parent, width, height) {

        var _DISTRO = this;

        if (typeof (this.parent = $.lib(parent)) === 'undefined') return;
        if (typeof (this.width = width) === 'undefined') return;
        if (typeof (this.height = height) === 'undefined') return;

        if (this.parent.css('position') !== 'absolute')
            this.parent.css('position', 'relative');

        this.validate = function() {
            this.elements = this.parent.children();
            this.elementCount = this.elements.length;
        };

        this.apply = function (callback) {

            this.boundaryWidth = parseInt(this.parent.width());
            this.boundaryHeight = parseInt(this.parent.height());

            var optimalSize = this.boundaryWidth / Math.floor(this.boundaryWidth / this.width),
                map = {},
                coords = {
                    x: 0,
                    y: 0
                },
                icoords = {
                    x: 0,
                    y: 0
                };

            var mapId = function (xi, yi) {
                return String.format("%s_%s", xi, yi);
            }

            var renderTile = function ($a, coords, icoords, size, map, maxWidth) {
                if (coords.x + size >= maxWidth + 1) {
                    coords.y += height;
                    icoords.y++;
                    icoords.x = coords.x = 0;
                }

                $a.css({
                    width: size + "px",
                    height: height + "px",
                });

                map[mapId(icoords.x, icoords.y)] = $a;

                $a.transform3d().translate(coords.x + "px", coords.y + "px", 0).apply();

                coords.x += size;
                icoords.x++;
            };

            this.elements.each(function (e, i, a) {
                renderTile($.lib(this), coords, icoords, optimalSize, map, _DISTRO.boundaryWidth);
            });

            this.parent.css('height', coords.y + this.height);

            require('elixir/toolkit').fire(callback, coords.y + this.height);
        }

        this.validate();

        this.elements.each(function (i) {
            $.lib(this).css({
                position: "absolute",
                left: 0,
                top: 0,
                height: height + "px",
                width: width + "px",
                right: "auto",
                bottom: "auto",
                zIndex: 1
            });
        });

        return this;
    };

    exports.GridBuilder = GridBuilder;

    Elixir.attach(__context, exports);

})('mui/gui');