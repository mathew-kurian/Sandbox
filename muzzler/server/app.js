
// -----------------------------------------------------------------------------
// Scribe.js
// -----------------------------------------------------------------------------

var scribe = require('./libs/scribe');

scribe.addLogger("log", true, true, 'green');
scribe.addLogger('error', true, true, 'red');
scribe.addLogger('warn', true, true, 'yellow');
scribe.addLogger('realtime', true, true, 'underline');
scribe.addLogger('high', true, true, 'magenta');
scribe.addLogger('normal', true, true, 'white');
scribe.addLogger('low', true, true, 'grey');
scribe.addLogger('info', true, true, 'cyan');

// -----------------------------------------------------------------------------
// Require --> Include
// -----------------------------------------------------------------------------

require("./libs/include");

attach("scribe", "./libs/scribe");
attach("routes", "./routes");
attach("tiling", "./tiling");
attach("codes", "./routes/codes");
attach("notify", "./routes/notify");
attach("connect", "./routes/connect");
attach("dbtools", "./routes/dbtools");
attach("echonest", "./routes/echonest");
attach("emitter", "./routes/emitter"); 
attach("emailer", "./routes/emailer");
attach("emitter", "./libs/emitter");
attach("dbtools", "./routes/dbtools");
attach("notify", "./routes/notify");
attach("toolkit", "./routes/toolkit");
attach("user", "./routes/user");
attach("search", "./libs/search");
attach("queue", "./libs/queue"); 
attach("safely", "./libs/safely"); 
attach("processor", "./libs/processor"); 
attach("atomic", "./atomic"); 
attach("normal", "./libs/normal");
attach("aws", "./libs/aws");
attach("bundler", "./libs/bundler");

// -----------------------------------------------------------------------------
// App.js
// -----------------------------------------------------------------------------

var express = include('express');
var routes = include('./routes');
var user = include('./routes/user');
var path = include('path');
var fs = include('fs');
var http = include('http');
var https = include('https');
var elixir = include('./elixir');
var mongo = include('mongoskin');
var toolkit = include('toolkit');
var socket = require('socket.io');
var notify = include('notify');
var bundler = include('bundler');

var db = mongo.db("mongodb://localhost:21111/Muzzler_MusicPlayer", {
    native_parser: true
});

var mongostore = include('connect-mongo')(express);
var app = express();

// Add max sockets.
http.globalAgent.maxSockets = 30;
https.globalAgent.maxSockets = 30;

bundler.compactSync('./public/web_modules', './public/bundled.js');
bundler.compactSync('./public/stylesheets', './public/bundled.css');

var cors = function(req, res, next) {
    if (req.originalUrl.indexOf('/converted') < 0) return next();

    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');

    // intercept OPTIONS method
    if ('OPTIONS' == req.method) {
        res.send(200);
    } else {
        next();
    }
};

var secure = function(req, res, next) {
    // if (!req.secure && req.url.indexOf('/converted') < 0) {
    //     // Force no subdomains.
    //     return res.redirect(['https://mus.ec', req.url].join(''));
    // }
    next();
}

var cachecontrol = function(req, res, next) {
    res.setHeader("X-UA-Compatible", "IE=edge,chrome=1");
    if (!res.getHeader('Cache-Control')) res.setHeader('Cache-Control', 'public, max-age=' + 3456000000);
    return next();
}


var sessionStore = new mongostore({
    db: 'Muzzler_MusicPlayer',
    host: '127.0.0.1',
    port: 21111
}, function(e) {

    app.configure(function() {
    
        app.set('port', process.env.PORT || 80);
        app.set('views', path.join(__dirname, 'views'));
        app.set('view engine', 'jade');
        app.use(cors);
        app.use(scribe.express.logger(function(req, res){
            return req.url !== '/elog';
        }));
        app.use(express.compress());
        app.use(express.methodOverride());
        app.use(express.bodyParser());
        app.use(express.cookieParser('brent-best'));
        app.use(express.session({
            store: sessionStore
        }));

        app.use(secure);
        app.use(app.router);
        
        app.use(express.static(path.join(__dirname, 'public'), {
            maxAge: 3456000000
        }));

        app.use(cachecontrol);
    });

    if ('development' == app.get('env')) {
        app.use(express.errorHandler());
    }

    routes.configure(function() {
        routes.set('database', db);
    });

    app.get('/', routes.get.index);
    app.get('/hd', routes.get.hd);
    app.get('/terms', routes.get.terms);
    app.get('/privacy', routes.get.privacy);
    app.get('/music_hd', routes.get.music);
    app.get('/feed', routes.checkAuth, routes.get.feed);
    app.get('/userlist', routes.get.userlist);
    app.get('/users', user.list);
    app.get('/upload', routes.checkAuth, routes.get.upload);
    app.get('/youtube', routes.checkAuth, routes.get.youtube);
    app.get('/refresh', routes.checkAuth, routes.get.refresh);
    app.get('/search', routes.checkAuth, routes.get.search);
    app.get('/email', routes.get.email);
    app.get('/verify/*', routes.get.verify);
    app.get('/registration', routes.get.registration);
    app.get('/password', routes.checkAuth, routes.get.password);
    app.get('/medata', routes.get.medata);
    app.get('/marketing', routes.get.marketing);
    app.get('/log', scribe.express.controlPanel());

    app.post('/secured', routes.post.secured);
    app.post('/audiomanager', routes.checkAuth, routes.post.audiomanager);
    app.post('/', routes.checkAuth, routes.post.audiomanager);
    app.post('/convert', routes.checkAuth, routes.post.convert);
    app.post('/renewlinks', routes.checkAuth, routes.post.renewlinks);
    app.post('/searchsongs', routes.checkAuth, routes.post.searchsongs);
    app.post('/searchplaylists', routes.checkAuth, routes.post.searchplaylists);
    app.post('/emailer', routes.post.emailer);
    app.post('/changepw', routes.checkAuth, routes.post.changepw);
    app.post('/elog', scribe.express.webpipe());

    app.post('/requestMusicData', routes.checkAuth, routes.post.requestMusicData);
    app.post('/uploadManagerV', routes.checkAuth, routes.post.uploadManagerV);
    app.post('/deletePlaylist', routes.checkAuth, routes.post.deletePlaylist);
    app.post('/renamePlaylist', routes.checkAuth, routes.post.renamePlaylist);
    app.post('/newPlaylist', routes.checkAuth, routes.post.newPlaylist);
    app.post('/deleteSong', routes.checkAuth, routes.post.deleteSong);

    app.post('/testPlaylistManager', routes.checkAuth, routes.post.testPlaylistManager);
    app.post('/testUpload', routes.post.testUpload);
    app.post('/testGetObjectID', routes.post.testGetObjectID);
    app.post('/testInsertPlaylist', routes.post.testInsertPlaylist);
    app.post('/testCreateSong', routes.post.testCreateSong);
    app.post('/addSongToPlaylist', routes.post.addSongToPlaylist);
    app.post('/testDeletePlaylist', routes.post.testDeletePlaylist); 

    app.post('/login', routes.post.login);
    app.post('/login2', routes.post.login2);
    app.post('/logoff', routes.post.logoff);

    elixir.configure(function() {
        elixir.set('express', app);
        elixir.set('mapping', '/states');
        elixir.set('logging', '/elog');
        elixir.set('states', path.join(__dirname, 'states'));
        elixir.set('views', path.join(__dirname, 'views'));
        elixir.set('logincheck', function(req) {
            if (req.session.user_id) return true;
            return false;
        });
    }); 

    var options = {
        key: fs.readFileSync('security/salem.key'),
        cert: fs.readFileSync('security/salem.crt'),
        passphrase: 'muzzlermuzzler'
    };

    var httpsServer = https.createServer(options, app).listen(443);
    var httpServer = http.createServer(app);

    var io = socket.listen(httpsServer, {
        log: false
    });

    notify.set('io', io);

    httpServer.listen(80, function() {
        console.log('Server listening on port ' + app.get('port'));
    });
});

// include('atomic').run('search-id3'); 
// include('atomic').run('emitter-proto'); 
// include('atomic').run('basic-safely'); 
// include('atomic').run('search-youtube-query'); 
// include('atomic').run('search-grooveshark-query'); 
// include('atomic').run('search-soundcloud-query'); 
// include('atomic').run('search-vimeo-query'); 
// include('atomic').run('search-soundcloud-url'); 
// include('atomic').run('aws-create-delete-bucket'); 
// include('atomic').run('search-google-images');
// include('atomic').run('aws-upload-delete-files-bucket');
// include('atomic').run('search-echonest');