
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
 
    var codes = include('codes')
      , toolkit = include('toolkit');

    var exports = {};

    codes.notifications = {
        'UPLOAD_START' : 1,
        'UPLOAD_ONPROGRESS' : 2,
        'UPLOAD_FINISHED' : 3,
        'CONVERT_START' : 4,
        'CONVERT_ONPROGRESS' : 5,
        'CONVERT_FINISHED' : 6,
        'ANALYZE_START' : 7,
        'ANALYZE_ONPROGRESS' : 8,
        'ANALYZE_FINISHED' : 9,

        'PLAY_SONG' : 10,
        "ADD_SONG" : 11,
        "ADD_PLAYLIST" : 12,
        'UPDATE_PLAYLIST' : 13,
        "DELETE_SONG" : 14,
        "DELETE_PLAYLIST" : 15,
        "PROCESS_START" : 16,
        "PROCESS_FINISHED" : 17,

        "PROCESS_FAILED" : 18,
        "ADD_SONG_FAILED" : 19,
        "ADD_PLAYLIST_FAILED" : 20,
        "UPLOAD_FAILED" : 21,
        "CONVERT_FAILED" : 22,

        "UPDATE_PLAYLIST_FAILED" : 23,
        "DELETE_SONG_FAILED" : 24
    }

    function Input(name, type, regex, validate){
        return { 
                    "name" : name, 
                    "type" : (typeof type === 'undefined' ? 'string' : type), 
                    "regex" : (typeof regex === 'undefined' ? new RegExp(/.*/) : regex ), 
                    "validate" : (typeof validate === 'undefined' ? function(s){ return true; } : validate ),
                };
    }

    var reqmap = {
        'get-song-data' : {
            layout :  [ Input('sid', 'string'), Input('sanitize', 'boolean') ],
            type : "request-song-data",
            url : "/requestMusicData",
            method : "post"
        },
        'get-playlist-data' : {
            layout :  [ Input('pid', 'string') ],
            type : "request-playlist-data",
            url : "/requestMusicData",
            method : "post"
        },
        'get-user-data' : {
            layout :  [],
            type : "user-data",
            url : "/medata",
            method : "get"
        },
        'delete-song' : {
            layout :  [ Input('sid', 'string'), Input('pid', 'string') ],
            type : "delete-song",
            url : "/deleteSong",
            method : "post"
        },
        'delete-playlist' : {
            layout :  [ Input('pid', 'string') ],
            type : "delete-playlist",
            url : "/deletePlaylist",
            method : "post"
        },
        't-add-to-playlist' : {
            layout :  [ Input('sid', 'string'),
                        Input('pid', 'string') ],
            type : "add-playlist-data",
            url : "/addSongToPlaylist",
            method : "post"
        },
        'rename-playlist' : {
            layout :  [ Input('pid', 'string'), 
                        Input('name', 'string') ],
            type : "rename-playlist",
            url : "/renamePlaylist",
            method : "post"
        },
        't-add-new-playlist' : {
            layout :  [ Input('playlistname', 'string') ],
            type : "add-playlist",
            url : "/newPlaylist",
            method : "post"
        },
        'create-user' : {
            layout : [ Input('user', 'string', new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)),
                       Input('pass', 'string', new RegExp(/^(.){6,}$/)), 
                       Input('fname', 'string', new RegExp(/^(.){2,}$/)), 
                       Input('lname', 'string', new RegExp(/^(.){2,}$/)),
                       Input('agreement', 'string', undefined, function(d){
                            return d === 'true';
                       }) ],
            type : "create-new-user",
            url : "/secured",
            method : "post"
        },
        'request-song' : {
            layout : [ Input('request', 'string', new RegExp(/^(.){1,}$/)),
                       Input('playlist', 'string', new RegExp(/^(.){1,}$/)),
                       Input('agreement', 'string', undefined, function(d){
                            return d === 'true';
                       }) ],
            type : "request-song",
            url : "/uploadManagerV",
            method : "post"
        },
        'login' : {
            layout : [ Input('user', 'string', new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)),
                       Input('pass', 'number', new RegExp(/^(.){6,}$/)) ],
            type : "login",
            url : "/login",
            method : "post"
        },
        'logoff' : {
            layout : [],
            type : "logoff",
            url : "/logoff",
            method : "post"
        }
    }

    exports.connect = function(){

        var toolkit = include('toolkit');
        var debug = include('debug');
        var args = toolkit._argsAsArray(arguments);
        var type = args.shift();
        var callback = args.splice(args.length - 1, 1)[0];
        var accessor = reqmap[type];

        if(typeof callback !== 'function') throw TypeError('[Mui/io] Expecting callback.');
        if(typeof accessor === 'undefined') throw RangeError('[Mui/io] Invalid type.');

        var layout = accessor.layout;
        var reqdata = {};

        if(layout.length > args.length)
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Expecting more parameters");

        for(var i = 0; i < layout.length; i++){
            var e = layout[i];
            var arg = args[i];
            if(typeof arg === 'string') arg = arg.trim();
            if((typeof arg !== e.type) || (!e.regex.test(arg.toString())) || (!e.validate(arg))) 
                return toolkit.fire(callback, codes.behavior.VALIDATION_ERROR, e.name);
            reqdata[e.name] = arg.toString();
        }

        if(typeof accessor.type !== 'undefined') 
            reqdata.type = accessor.type;

        toolkit.fire(callback, codes.behavior.ACTIVE, "Connection open.");

        debug.info('mui/connect','reqdata', JSON.stringify(reqdata));

        toolkit[accessor.method](accessor.url, reqdata, function (data) {
            try { data = JSON.parse(data) } catch(e){};
            
            if(typeof data !== 'object') {
                data = {};
                data.status = codes.status.FAILED;
                data.message = data;
            } 

            debug.info("mui/connect", "resdata", JSON.stringify(data));

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

            toolkit.fire(callback, codes.behavior.INACTIVE, "Connection closed.");

        }).fail(function () {
            toolkit.fire(callback, codes.behavior.DEFINED_ERROR, "Unable to access server.");
            toolkit.fire(callback, codes.behavior.INACTIVE, "Connection closed.");
        });
    }

    attach(__context, exports);

})('io');

// -----------------------------------------------------------------------------
// GUI
// -----------------------------------------------------------------------------

(function (__context) {

    var codes = include('codes');
    var exports = {};

    var $ = {};

    exports.set = function (obj, val) {
        $[obj] = val;
    }

    exports.configure = function (callback) {
        include('toolkit').fire(callback);
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

            include('toolkit').fire(callback, coords.y + this.height);
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

    exports.GridBuilder = GridBuilder;

    attach(__context, exports);

})('gui');