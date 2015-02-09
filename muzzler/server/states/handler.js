
// -----------------------------------------------------------
// Elixir - Music Handler
// -----------------------------------------------------------

[elixir --tool:security]

require('elixir/cstate').extend({

    name : function(){
        return this.super().name();
    },
    after : function(){
        return 'base';
    },
    userid : function(){
        return [elixir --tool:userid];
    },
    initSockets : function(){

        var socket = io.connect('https://mus.ec/');
        var _ = this;

        socket.on(this.userid(), function (data) {
            _.notify(data);
        });

    },
    applyDefaultImages : function(data, type){

        this.private().defaultCounter = this.private().safely('defaultCounter', 0);

        var large = '//mus.ec/assets/images/default/' + type + '/def-' + this.private().defaultCounter + '.jpg';
        var blurred = '//mus.ec/assets/images/default/' + type + '/blurred-def-' + this.private().defaultCounter + '.jpg';

        toolkit.extend(data, {
            'imageLarge' : large,
            'imageBlurred' : blurred
        }, false);

        data.imageLarge = data.imageLarge === '' ? large : data.imageLarge;
        data.imageBlurred = data.imageBlurred === '' ? blurred : data.imageBlurred;
                
        this.private().defaultCounter = ++this.private().defaultCounter > 5 ? 0 : this.private().defaultCounter;

        return data;
    },
    notify : function(data){

        var toolkit = require('elixir/toolkit');
        var codes = require('elixir/codes');
        var debug = require('elixir/debug');

        toolkit.extend(data, {
            'eventid' : (Math.random() * 100000).toString()
        }, false);

        var ecode = data.code;
        var eid = data.eventid.toString();

        debug.info('muistate-handler', 'notify', ecode, data.msg, data.time, JSON.stringify(data));

        switch(ecode){

            case codes.notifications.UPLOAD_START: return this.fireListeners('upload', 'start', data);
            case codes.notifications.UPLOAD_ONPROGRESS: return this.fireListeners('upload', 'progress', data);
            case codes.notifications.UPLOAD_FINISHED: return this.fireListeners('upload', 'finished', data);

            case codes.notifications.CONVERT_START: return this.fireListeners('convert', 'start', data);
            case codes.notifications.CONVERT_ONPROGRESS: return this.fireListeners('convert', 'progress', data);
            case codes.notifications.CONVERT_FINISHED: return this.fireListeners('convert', 'finished', data);

            case codes.notifications.ANALYZE_START: return this.fireListeners('analyze', 'start', data);
            case codes.notifications.ANALYZE_ONPROGRESS: return this.fireListeners('analyze', 'progress', data);
            case codes.notifications.ANALYZE_FINISHED: return this.fireListeners('analyze', 'finished', data);

            case codes.notifications.PLAY_SONG: return this.fireListeners('song', 'play', data);
            case codes.notifications.DELETE_SONG: 
                                                var sid = data.data._id; // I need to be able to acess this info brent <-----------------
                                                var pid = data.data.playlist._id;  // <-------------------------
                                                this.cache().playlist[pid].songs.removeAll(sid);
                                                return this.fireListeners('song', 'delete', sid, pid);
            case codes.notifications.ADD_SONG:  var sid = data.data._id;
                                                var pid = data.data.playlist._id;
                                                this.cache().playlist[pid].songs.push(sid);
                                                return this.fireListeners('song', 'add', sid, pid);

            case codes.notifications.ADD_PLAYLIST: 
                                                var pid = data.data._id;
                                                this.cache().playlist[pid] = this.applyDefaultImages(data.data, 'playlist');
                                                return this.fireListeners('playlist', 'add', pid);
            case codes.notifications.DELETE_PLAYLIST:  return this.fireListeners('playlist', 'delete', data.data.pid);
            case codes.notifications.UPDATE_PLAYLIST:  
                                                var pid = data.data._id;
                                                this.cache().playlist[pid] = this.applyDefaultImages(data.data, 'playlist');
                                                return this.fireListeners('playlist', 'update', pid);

            case codes.notifications.PROCESS_START: return this.fireListeners('process', 'start', data);
            case codes.notifications.PROCESS_FINISHED: return this.fireListeners('process', 'finished', data);
            case codes.notifications.PROCESS_FAILED: return this.fireListeners('process', 'failed', data);
            case codes.notifications.CONVERT_FAILED: return this.fireListeners('convert', 'failed', data);
        }
    },
    ready : function(){
        this.private().queue = [];
        this.private().eventHandlers = {};
        this.private().queueid = 0;

        this.initSockets();

        // Testing

        // var _ = this;
        // var count = 0;

        // var onqueue = function(qob){
        //     console.log("added qob - " + qob);
        //     if(++count > 3) _.off('queue', 'offer', onqueue);
        // };

        // this.on('queue', 'offer', onqueue);

        // this.getPlaylist('535b9a46a21c5a7015309992', function(err, msg, data){
        //     console.log(err + " - " + msg + " - " + JSON.stringify(data));
        // });

        // this.getPlaylist('*', true, function(err, msg, data){
        //     console.log(err + " - " + msg + " - " + JSON.stringify(data));
        // });

        // this.getPlaylist('535b9a46a21c5a7015309992,535b9a46a21c5a7015309992', function(err, msg, data){
        //     console.log(err + " - " + msg + " - " + JSON.stringify(data));
        // });

        // this.addToQueue('playlist', '535b9a46a21c5a7015309992');
    },
    clearQueue : function(){
        return this.private().queue = [];
    },
    getQueue : function(){
        return this.private().queue;
    },
    setActivePlaylist : function(pid){
        this.private().activePlaylist = pid;
    },
    addToQueue : function(type, psid, frompid){

        var _ = this;
        var codes = require('elixir/codes');

        if(type === 'song'){
            var id = this.private().queueid++;
            var qob = { 'id' : id , 'sid' : psid, 'pid' : frompid };
            this.private().queue.push(qob);
            return _.fireListeners('queue', 'offer', codes.status.OK, 'Added to queue.', qob);
        } else if (type === 'playlist'){
            this.getPlaylist(psid, function(err, msg, data){
                if(err !== codes.status.FAILED){
                    for(var pid in data){
                        var playlist = data[pid];
                        if(typeof playlist.songs === 'undefined') continue;
                        if(typeof playlist.songs.reverse === 'undefined') continue;
                        for(var i = 0; i <playlist.songs.length; i++){
                            var id = _.private().queueid + i;
                            var sid = playlist.songs[i];
                            var qob = { 'id' : id , 'sid' : sid, 'pid' : pid };
                            _.private().queue.push(qob);
                            _.fireListeners('queue', 'offer', err, 'Added to queue.',  qob);
                        }
                    }
                    return;
                }

                _.fireListeners('queue', 'offer', err, 'Queue add failure. ' + msg);

            });
        }
    },
    existsInQueue : function(sid, pid){

        var queue = this.private().queue;

        for(var i = 0; i < queue.length; i++)
            if(sid === queue[i].sid && pid === queue[i].pid)
                return true;

        return false;
    },
    shuffleQueue : function(){
        return this.fireListeners('queue', 'shuffle', require('elixir/codes').status.OK, 'Shuffled queue', this.private().queue.shuffle()); // just pass in the parameters for conistency
    },
    peekQueue : function(){
        return this.private().queue[0];
    },
    afterInQueue : function(sid, pid, repeat){        
        var queue = this.private().queue;
        for(var i = 0; i < queue.length; i++)
            if(sid === queue[i].sid && pid === queue[i].pid)
                if((i + 1 < queue.length) || !repeat)
                    return queue[i + 1];
                else return queue[0];
        return;
    },
    beforeInQueue : function(sid, pid, repeat){        
        var queue = this.private().queue;
        for(var i = 0; i < queue.length; i++)
            if(sid === queue[i].sid && pid === queue[i].pid)
                if((i - 1 > -1) || !repeat)
                    return queue[i - 1];
                else return queue[queue.length - 1];
        return;
    },
    removeFromQueue : function(qob){

        var queue = this.private().queue;
        var codes = require('elixir/codes');

        console.log(queue); 

        for(var i = 0; i < queue.length; i++){
            if(qob.id === queue[i].id){
                queue.splice(i, 1);
                return this.fireListeners('queue', 'poll', codes.status.OK, 'Removed from queue', qob);
            }
        }

        return this.fireListeners('queue', 'poll', codes.status.FAILED, 'Unable to remove from queue');
    },
    removeFromQueueBySid : function(sid, pid){

        var queue = this.private().queue;
        var codes = require('elixir/codes');

        for(var i = 0; i < queue.length; i++){
            if(sid === queue[i].sid && pid === queue[i].pid){
                var qob = queue.splice(i, 1); 
                return this.fireListeners('queue', 'poll', codes.status.OK, 'Removed from queue', qob[0] );
            }
        }

        return this.fireListeners('queue', 'poll', codes.status.FAILED, 'Unable to remove from queue');
    },
    cache : function(){
        return this.private().cache = this.private().safely('cache', {
            song : {},
            playlist : {}
        });
    },
    cacheExists : function(type, psid){ 
        var has = true;
        var psids = psid.split(',');

        if(psid !== '*'){            
            for(var i = 0; i < psids.length; i++){
                if(typeof this.cache()[type][psids[i]] === 'undefined'){
                    has = false;
                    break;
                }
            }
        }

        return has;
    },
    getPlaylist : function(pid, f, callback){

        callback = typeof callback === 'undefined' ? f : callback;
        f = typeof f !== 'boolean' ? false : f;

        this.iohandler(pid, f, 'playlist', callback)
    },
    getSong : function(pid, f, callback, s){

        callback = typeof callback === 'undefined' ? f : callback;
        f = typeof f !== 'boolean' ? false : f;
        s = typeof s === 'undefined' ? false : s;

        this.iohandler(pid, f, 'song', callback, s);
    },
    deletePlaylist : function(pid, callback){

        var _ = this;
        var type = 'playlist';
        var toolkit = require('elixir/toolkit');
        var debug = require('elixir/debug');
        var codes = require('elixir/codes');
        var io = require('mui/io');
        var pids = pid.split(',');
        var cachedPlaylists = this.cache()[type];

        debug.info('muistate-handler', 'deletehandler', 'Requesting deletion of ' + pid + ' of type ' + type);

        io.connect('delete-' + type, pid, function(err, msg, data){
            if(codes.behavior.failed(err)) return toolkit.fire(callback, codes.status.FAILED, msg);
            else if (codes.behavior.other(err)) return;
            for(var i = 0; i < pids.length; i++){
                try { 
                    delete cachedPlaylists[pids[i]]; 
                } catch(e){}
            }
            toolkit.fire(callback, codes.status.OK, msg + " Deleted " + type + " from server.", data.data);
        });
    },
    renamePlaylist : function(pid, to, callback){

        this.renamehandler(pid, to, 'playlist', callback);
    },
    deleteSong : function(sid, pid, callback){

        var _ = this;
        var type = 'song';
        var toolkit = require('elixir/toolkit');
        var debug = require('elixir/debug');
        var codes = require('elixir/codes');
        var io = require('mui/io');
        var cachedPlaylists = this.cache()[type];

        debug.info('muistate-handler', 'deletehandler', 'Requesting deletion of ' + sid + ' of type ' + type);

        io.connect('delete-' + type, sid, pid, function(err, msg, data){
            if(codes.behavior.failed(err)) return toolkit.fire(callback, codes.status.FAILED, msg);
            else if (codes.behavior.other(err)) return;
            toolkit.fire(callback, codes.status.OK, msg + " Deleted " + type + " from server.", data.data);
        });
    },
    renamehandler : function(psid, to, type, callback){

        var _ = this;
        var toolkit = require('elixir/toolkit');
        var debug = require('elixir/debug');
        var codes = require('elixir/codes');
        var io = require('mui/io');
        var psids = psid.split(',');
        var cachedPlaylists = this.cache()[type];

        debug.info('muistate-handler', 'renamehandler', 'Requesting rename of ' + psid + ' of type ' + type);

        io.connect('rename-' + type, psid, to, function(err, msg, data){
            if(codes.behavior.failed(err)) return toolkit.fire(callback, codes.status.FAILED, msg);
            else if (codes.behavior.other(err)) return;
            for(var i = 0; i < psids.length; i++){
                cachedPlaylists[psids[i]].name = to; 
            }
            toolkit.fire(callback, codes.status.OK, msg + " Renamed " + type + " in server.", data.data);
        });
    },
    iohandler : function(psid, f, type, callback, sanitize){

        var _ = this;
        var toolkit = require('elixir/toolkit');
        var debug = require('elixir/debug');
        var codes = require('elixir/codes');
        var io = require('mui/io');
        var requestFromServer = !this.cacheExists(type, psid);
        var psids = psid.split(',');

        debug.info('muistate-handler', 'iohandler', 'Requesting ' + psid + ' of type ' + type);

        sanitize = typeof sanitize === 'undefined' ? false : sanitize;

        if(f || requestFromServer){
            io.connect('get-' + type +'-data', psid, sanitize, function(err, msg, data){
                if(codes.behavior.failed(err)) return toolkit.fire(callback, codes.status.FAILED, msg);
                else if (codes.behavior.other(err)) return;
                for(var key in data.data)
                    data.data[key] = _.applyDefaultImages(data.data[key], type);
                toolkit.extend(_.cache()[type], data.data, true);
                toolkit.fire(callback, codes.status.OK, msg + " Rerieved " + type + " from server.", data.data);
            });
        } else {

            var retobj = {};
            var cachedPlaylists = this.cache()[type];

            for(var i = 0; i < psids.length; i++)
                retobj[psids[i]] = cachedPlaylists[psids[i]];

            toolkit.fire(callback, codes.status.OK, " Loading " + type + " from cache.", retobj);
        }
    },
    pauseSong : function(){
        if(typeof this.private().psong !== 'undefined'){
            this.private().psong.pause();
            this.fireListeners('audio', 'pause', this.private().psong, this.private().currentSid, this.private().currentPid);
        }
    },
    resumeSong : function(){
        if(typeof this.private().psong !== 'undefined'){
            this.private().psong.play();
            this.private().psong.volume = this.private().safely('vol', 0.3);   
            this.fireListeners('audio', 'resume', this.private().psong, this.private().currentSid, this.private().currentPid);
        }
    },
    stopSong : function(){
        if(typeof this.private().psong !== 'undefined'){
            this.private().psong.pause();
            try { this.private().psong.currentTime = 0; } catch(e){}
            this.fireListeners('audio', 'stop', this.private().psong, this.private().currentSid, this.private().currentPid);
        }
    },
    skipSongTo : function(a){        
        if(typeof this.private().psong !== 'undefined'){
            try { this.private().psong.currentTime = a; } catch(e){}
            this.fireListeners('audio', 'skippedto', this.private().psong, this.private().currentSid, this.private().currentPid);
        }
    },
    skipSongToPercentage : function(a){        
        if(typeof this.private().psong !== 'undefined'){
            try { this.skipSongTo(this.private().psong.duration * a/100); } catch(e){}
        }
    },
    sanitize : function(sid, callback){

        var __context = 'muistate-handler';
        var __identifier = 'sanitize';
        var toolkit = require('elixir/toolkit');
        var codes = require('elixir/codes');
        var debug = require('elixir/debug');
        var audio = this.cache().song[sid];

        if(typeof audio === 'undefined'){
            debug.info(__context, __identifier, 'Song does not exisit - ' + sid);
            return toolkit.fire(callback, codes.status.FAILED, "Song does not exist!")
        }

        // if usable data does not exist
        toolkit.extend(audio, {
            'expiration' : -8640000000000000,
            'lengthms' : 0
        }, false);

        var expiration = new Date(parseInt(audio.expiration) - parseInt(audio.lengthms));
        var now = new Date(Date.now());

        if(expiration < now){     
            debug.info(__context, __identifier, 'Links expired; requesting new links for ' + sid);
            return this.getSong(sid, true, function(err, msg, data){       
                if(err !== codes.status.OK) return toolkit.fire(callback, err, msg);
                toolkit.fire(callback, err, msg + " - Sanitized data.");
            }, true);
        }
        
        debug.info(__context, __identifier, 'Using existing links; expiration - ' + expiration.toString());

        toolkit.fire(callback, codes.status.OK, 'Data already sanitized');
        
    },
    safePlay : function(sid, pid, callback){

        var __context = 'muistate-handler';
        var __identifier = 'safePlay';
        var _ = this;
        var codes = require('elixir/codes');
        var debug = require('elixir/debug');
        var toolkit = require('elixir/toolkit');
        var sanitized = false;

        var playHandler = function(err, msg){  
            debug.info(__context, __identifier, msg);
            if(err !== codes.status.OK) 
                return toolkit.fire(callback, err, msg, sid);
            _.playSong(sid, pid, callback, sanitized);
        }

        if(typeof this.cache().song[sid] === 'undefined'){
            debug.info(__context, __identifier, 'Request server retrieve of song -' + sid);
            this.getSong(sid, playHandler);
            sanitized = true;
        } else {
            debug.info(__context, __identifier, 'Request sanitize of song - ' + sid);
            this.sanitize(sid, playHandler);
        }
    },
    setVolume : function(vol){
        this.private().vol = vol;
        try { this.private().psong.volume = this.private().safely('vol', 0.3); } catch(e){}
    },
    playSong : function(sid, pid, callback, f){

        var toolkit = require('elixir/toolkit');
        var codes = require('elixir/codes');
        var _ = this;

        this.stopSong();

        f = typeof f !== 'boolean' ? false : f;

        if(this.private().safely('currentSid', 0) === sid && !f){
            this.private().psong.play();
            return toolkit.fire(callback, codes.status.OK, "Restarting song.", sid);
        }

        var audioData = this.cache().song[sid];
        var audio = this.private().psong = new Audio(audioData.link);
        audio.volume = this.private().safely('vol', 0.3);

        this.private().currentSid = sid;
        this.private().currentPid = pid;

        audio.addEventListener('timeupdate', function(){   _.fireListeners('audio', 'timeupdate', this, sid, pid);  });
        audio.addEventListener('canplay', function(){   _.fireListeners('audio', 'canplay', this, sid, pid); });
        audio.addEventListener('ended', function(){   _.fireListeners('audio', 'ended', this, sid, pid); });
        audio.addEventListener('error', function(){  
            _.cache().song[sid].expiration = 0; // force check expiration next time
            _.private().currentSid = 0;
             _.fireListeners('audio', 'error', this, sid, pid); 
         });

        audio.play();

        _.fireListeners('audio', 'play', audio, sid, pid); // we fire this.

        toolkit.fire(callback, codes.status.OK, "Playing song.", sid, pid);
    },
    getSongPlaying : function(){
        return this.private().currentSid;
    },
    getPlaylistPlaying : function(){
        return this.private().currentPid;
    },
    isPlaying : function(){
        try {
        return !this.private().psong.paused && !this.private().psong.ended && 0 < this.private().psong.currentTime;
    } catch(e) {return false;}
    }
});