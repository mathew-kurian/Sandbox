// -----------------------------------------------------------
// Elixir - Dashboard
// -----------------------------------------------------------

[elixir --tool:security]

require('elixir/cstate').extend({

    name: function() {
        return this.super().name();
    },
    after: function() {
        return 'handler';
     },
    hideDownloadDialog : function(a){

        // check if any failed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        var inprogress = false;
        if(a){
            $('#dialog-1-files').children().each(function(){
                if($(this).attr('data-status') === 'processing' || $(this).attr('data-status') === 'tostart')
                    inprogress = inprogress | true;
            });
        }

        if(inprogress) return;
        this.private().bgEnabled = true;
        this.private().toUpload = [];
        $('#dialog-bg').css('display', 'none');
        $('#dialog-1').transform3d().translate(0, '-200%', 0).apply();
        $('#dashboard-content').css('opacity', '1');
        require('elixir/toolkit').completed('#dialog-1-continue');
        $('#dialog-1-continue').css('opacity', 1);     
        $('#dialog-1-message').parent().css('display', 'none');
        $('#dialog-1-playlist').removeClass('dialog-form-error').removeClass('menu-active').text('SELECT PLAYLIST');
        $('#up-playlists').slideUp();
    },
    showDownloadDialog : function(){      

        this.private().bgEnabled = false;
        $('#dialog-bg').css('display', 'block');
        $('#dialog-1').transform3d().translate(0, 0, 0).apply();
        $('#dashboard-content').css('opacity', '0.2');
    },
    hideDialog : function(){

            $('#dialog-bg').css('display', 'none');
            $('#dialog-1, #dialog-0, #dialog-4, #dialog-5').transform3d().translate(0, "-200%", 0).apply();
            $('#dialog-3').transform3d().translate('350px', 0, 0).apply();
            $('#dashboard-content').css('opacity', '1.0');
            $('#notification-handle').removeClass('notification-icon-selected');

            this.private().isPlaylistEditing = false;
    },
    initUploader : function(){

        var ul = $('#dialog-1-files');

        var _ = this;
        var base = this.super().super();
        var toUpload = this.private().toUpload;

         // Helper function that formats the file sizes
        var formatFileSize = function(bytes) {
            if (typeof bytes !== 'number') {
                return '';
            }

            if (bytes >= 1000000000) {
                return (bytes / 1000000000).toFixed(2) + ' GB';
            }

            if (bytes >= 1000000) {
                return (bytes / 1000000).toFixed(2) + ' MB';
            }

            return (bytes / 1000).toFixed(2) + ' KB';
        }

        // Prevent the default action when a file is dropped on the window
        $(document).on('drop dragover', function (e) {
            e.preventDefault();
        });

        $('#drop a').click(function(){
            // Simulate a click on the file input button
            // to show the file browser dialog
            $(this).parent().find('input').click();
        });

        // Initialize the jQuery File Upload plugin
        $('#dashboard-upload-form').fileupload({

            // This element will accept file drag/drop uploading
            dropZone: $('#dashboard-sidebar-upload'),

            // This function is called when a file is added to the queue;
            // either via the browse button, or via drag/drop:
            add: function (e, data) {

                // Append the file name and file size
                // tpl.find('p').text(data.files[0].name)
                //              .append('<i>' + formatFileSize(data.files[0].size) + '</i>');
                var filename = data.files[0].name;
                var extension = filename.match(/\.[0-9a-z]+$/i);
                var size = formatFileSize(data.files[0].size);

                filename = filename.substring(0, filename.lastIndexOf('.'));
                extension = extension ? extension[0] : "";

                if(extension !== '.mp3'){
                    base.toast("Wrong file type.");
                    return; 
                }

                var song = {
                    name : (filename.length > 20 ? filename.substring(0, 20) + '..' : filename) + extension,
                    size : size
                }

                var $fileDom = $(_.templates.fileList(song));
                data.context = $fileDom.appendTo(ul);
                $fileDom.attr('data-status', 'tostart');

                (function(index){
                     // Listen for clicks on the cancel icon
                    $fileDom.find('.file-control-icon').click(function(){

                        if($fileDom.attr('data-status') === 'processing'){
                            try { toUpload[index].abort(); } catch(e){}
                        }

                        $fileDom.remove();

                        _.hideDownloadDialog(true);

                    });
                })(_.private().toUpload.length);

                _.showDownloadDialog(true);

                // Automatically upload the file once it is added to the queue
                _.private().toUpload.push(data);
            },
            progress: function(e, data){

                // Calculate the completion percentage of the upload
                var progress = parseInt(data.loaded / data.total * 100, 10);

                // Update the hidden input field and trigger a change
                // so that the jQuery knob plugin knows to update the dial
                var $dom = $(data.context);                
                $dom.find('.file-progress').css('width',progress + "%");

                if(progress == 100)  {
                    $dom.attr('data-status', 'done')
                    $dom.remove();
                    _.hideDownloadDialog(true);
                }
            },

            fail:function(e, data){
                var $dom = $(data.context);
                $dom.find('.file-progress').addClass('file-progress-error');
                $dom.attr('data-status', 'failed');
                base.toast("File upload error!");
                _.hideDownloadDialog(true);
            }
        });
    },
    templates: {
        content: [elixir --tool:jade --file:dashboard.jade],
        queueItem: [elixir --tool:jade --file:templates/queue-list.jade],
        emptyList: [elixir --tool:jade --file:templates/empty-list.jade],
        fileList: [elixir --tool:jade --file:templates/file-list.jade],
        menuItem: [elixir --tool:jade --file:templates/menu-item.jade],
        notificationProgress: [elixir --tool:jade --file:templates/notification-progress-item.jade],
        notificationProcessStart: [elixir --tool:jade --file:templates/notifcation-process-start.jade],
        notificaitonAnaylsisStart: [elixir --tool:jade --file:templates/notifcation-analysis-start.jade],
        editList: [elixir --tool:jade --file:templates/edit-list.jade],
        songList : [elixir --tool:jade --file:templates/song-list.jade],
    },
    setMenuSelected: function(id) {
        $('.dashboard-sidebar-btn').removeClass('animator')
            .removeClass('dashboard-sidebar-btn-selected')
            .css('height', '40px') 
            .css('opacity', '0.5')
            .css('background', 'transparent')
            .children().css('line-height', '40px');

        $('#dashboard-sidebar-btn-' + id).css('height', '50px')
            .children().css('line-height', '50px');

        $('#dashboard-sidebar-btn-' + id).addClass('animator')
            .addClass('dashboard-sidebar-btn-selected')
            .css('opacity', '1')
            .css('background', '#18AEAA');

        $('.dashboard-sidebar-btn').addClass('animator');
    },
    hideFlowScrollBar: function() {
        if (this.private().safely('initFlowScoll', false)) {
            $('#flow').parent().getNiceScroll().hide();
        }

        $('#flow').parent().css('right', '300px');
        $('#flow').css('height', 'auto');
    },
    requestFlowScrollInvisibility: function(a) {
        this.private().requestFlowScrollInvisibility = a;
    },
    showPlaylist: function(pid, title, count) {

        var _ = this;

        _.hideFlowScrollBar();
        _.private().disableScrollBar = true;
        _.private().activePlaylist = pid;

        $('#album-blur-canvas').removeClass('animator').css('opacity', '0');
        $('#reveal').transform3d().translate('-400px', '0', '0').apply();
        $('#curtain').css('display', 'block').css('opacity', 1);

        _.super().getPlaylist(pid, function(err, msg, data){
            if(err) return;
            $('#playlist-name').text(data[pid].name);
            $('#playlist-count').text(data[pid].songs.length);
        })

        // $('#dashboard-upload-form').css('opacity', 1);

    },
    activePlaylist: function() {
        return this.private().activePlaylist;
    },
    resizePlaylistScrollbar : function(){

        try { $('#focused-playlist-scrollable-parent').getNiceScroll().resize(); } catch(e){}
    },
    showPlaylistScrollbar : function(){

        $('#focused-playlist-scrollable-parent').css('overflow-x', 'hidden').niceScroll({
            cursorvclass: "dark-cursor",
            railvclass: "dark-rail",
            cursorwidth: "8",
            horizrailenabled: false,
            autohidemode: false,
            railoffset: {
                top: 0,
                left: 0
            }
        });
    },
    hidePlaylistScrollbar : function(){

        try {$('#focused-playlist-scrollable-parent').getNiceScroll().remove(); } catch(e){}
    },
    hidePlaylist: function() {

        var _ = this;

        _.private().disableScrollBar = false;
        _.hidePlaylistScrollbar();

        $('#album-blur-canvas').removeClass('animator').css('opacity', '0');
        $('#reveal').transform3d().translate('0', '0', '0').apply();
        $('#curtain').css('opacity', 0).css('display', 'none');

        if (!this.private().safely('requestFlowScrollInvisibility', false)) {
            this.showFlowScrollBar();
        }

        // $('#dashboard-upload-form').css('opacity', 0);
    },
    resizeFlowScrollBar: function() {
        if (this.private().safely('initFlowScoll', false)) {
            $('#flow').parent().getNiceScroll().resize();
        }
    },
    showFlowScrollBar: function() {
        if (this.private().safely('disableScrollBar', false) || this.private().safely('requestFlowScrollInvisibility', false)) {
            this.hideFlowScrollBar();
            return;
        }

        if (this.private().safely('initFlowScoll', false)) {
            $('#flow').parent().css('right', '308px').getNiceScroll().show();
        }
    },
    removeFlowScrollBar: function() {
        if (this.private().safely('initFlowScoll', false)) {
            $('#flow').parent().getNiceScroll().remove();
            this.private().initFlowScoll = false;
        }

        $('#flow').parent().css('right', '300px')
            .css('overflow', 'hidden').getNiceScroll().hide();
        $('#flow').css('height', 'auto');

    },
    initFlowScrollBar: function() {
        if (!this.private().safely('initFlowScoll', false)) {

            $('#flow').parent().css('right', '308px')
                .css('overflow', 'auto')
                .css('overflow-x', 'hidden')
                .niceScroll({
                    cursorvclass: "dark-cursor",
                    railvclass: "dark-rail",
                    cursorwidth: "8",
                    horizrailenabled: false,
                    autohidemode: false,
                    railoffset: {
                        top: 0,
                        left: 8
                    }
                });

            if (this.private().safely('disableScrollBar', false) || this.private().safely('requestFlowScrollInvisibility', false)) {
                this.hideFlowScrollBar();
            }
            // Aesthetic improvements by browser
            // require('elixir/toolkit').chrome(function () {
            //     $('#flow').parent().css('right', '308px');
            // }).explorer(function () {
            //     $('#flow').parent().css('right', '308px');
            // }).firefox(function () {
            //     $('#flow').parent().css('right', '308px');
            // }); 

            this.private().initFlowScoll = true;
        }
    },
    resetController: function() {
        $('#music-previous,#music-next,#music-play').addClass('music-disabled');
        $('#music-play').removeClass('music-pause')
        $('#music-controller').css('width', 0);
        $('#music-scrubber').css('left', 0);
        $('#music-current-time').text('00:00');
        $('#music-duration').text('00:00');
    },
    initNotifications : function(){

        var _ = this;
        var handler = this.super();
        var toolkit = require('elixir/toolkit');
        var codes = require('elixir/codes');
        var notificationMap = this.private().notificationMap = this.private().safely('notificationMap', {});

        var handleProcessStart = function(data, dom, id){            

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificationProcessStart()); 
            }

            dom.attr('id', id);
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(data.data.request);
            try { if(data.data.albumart) dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart)) } catch(e){};
            dom.find('.notification-img').css('background-size', '60%');
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);

            return dom;

        }

        var handleProcessFailure = function(data, dom, id,  eid, ecode){
            
            for(var i = 0; i < 25; i++){
                var startId = i + eid;
                try { 
                    $("#" + startId).remove();
                    delete notificationMap[startId];
                } catch(e){};
            }

            var dom = $(_.templates.notificationProcessStart()); 

            dom.attr('id', id);
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(data.data.request);
            try { if(data.data.albumart) dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart)) } catch(e){};
            dom.find('.notification-img').css('background-size', '60%');
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);


            return dom;
        }

        var handleConvertStart = function(data, dom, id, eid, ecode){
            
            var startId = "16" + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}


            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificaitonAnaylsisStart()); 
            }

            dom.attr('id', id);
            dom.find('.notification-pgs-overlay').addClass('animator').css('width', "0%");
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(data.data.url);
            try { if(data.data.albumart) dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart)) } catch(e){};
            dom.find('.notification-img').css('background-size', '60%');
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);

            return dom;
        }


        var handleConvertProgress = function(data, dom, id, eid, ecode){
            
            var gui = require('mui/gui');

            var startId = (ecode - 1) + eid;
            dom = $('#' + startId);

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificaitonAnaylsisStart()); 
                return handleConvertStart(data, dom, id, eid, ecode - 1);
            }

            dom.find('.notification-pgs-overlay').addClass('animator').css('width', data.data.percent + "%");
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(gui.toProperCase(data.data.videoTitle));
            try { if(data.data.albumart) dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart)) } catch(e){};
            dom.find('.notification-img').css('background-size', '60%');

            return;
        }

 
        var handleConvertEnd = function(data, dom, id, eid, ecode){
            
            var startId = (ecode - 2) + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}
        }

        var handleAnalyzeStart = function(data, dom, id, eid, ecode){

            var startId = "16" + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}

            var gui = require('mui/gui');

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificaitonAnaylsisStart()); 
            }

            dom.attr('id', id);
            dom.find('.notification-pgs-overlay').addClass('animator-90000ms');
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(gui.toProperCase(data.data.videoTitle));
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);
            setTimeout(function(){ dom.find('.notification-pgs-overlay').css('width', '100%'); }, 500);
            try { if(data.data.albumart) dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart)) } catch(e){};
            dom.find('.notification-img').css('background-size', '60%');

            setTimeout(function(){
                try { dom.find('.notification-h1').text("Give us some more time..."); } catch(e){};
            }, 90000);

            return dom; 
        }

        var handleAnalyzeEnd = function(data, dom, id, eid, ecode){

            var startId = (ecode - 2) + eid;

            $('#' + startId).slideUp(function(){
                $(this).remove();
                delete notificationMap[startId];
            });

            return;
        }

        var handleUploadStart = function(data, dom, id, eid, ecode){
            
            var startId = "16" + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}

            var gui = require('mui/gui');

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificaitonAnaylsisStart()); 
            }

            dom.attr('id', id);
            dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart));
            dom.find('.notification-pgs-overlay').addClass('animator').css('width', "0%");
            dom.find('.notification-h1').text(data.msg);
            dom.find('.notification-h2').text(gui.toProperCase(data.data.title));
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);

            return dom;
        }


        var handleUploadProgress = function(data, dom, id, eid, ecode){
            
            var startId = (ecode - 1) + eid;
            dom = $('#' + startId);

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificaitonAnaylsisStart()); 
                return handleUploadStart(data, dom, id, eid, ecode - 1);
            }

            dom.find('.notification-pgs-overlay').addClass('animator').css('width', data.data.percent + "%");
            dom.find('.notification-h1').text(data.msg);

            return;
        }


        var handleUploadEnd = function(data, dom, id, eid, ecode){
            
            var startId = (ecode - 2) + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}
        }

        var handleProcessEnd = function(data, dom, id, eid, ecode){

            var gui = require('mui/gui');

            if(typeof dom === 'undefined'){
                dom = $(_.templates.notificationProcessStart()); 
            }

            var startId = (ecode - 1) + eid;

            try {
                $('#' + startId).slideUp(function(){
                    $(this).remove();
                    delete notificationMap[startId];
                });
            } catch(e){}

            dom.attr('id', id);
            dom.find('.notification-h1').text(gui.toProperCase(data.data.song));
            dom.find('.notification-h2').text(gui.toProperCase(data.data.artist + " // " + data.data.album));
            dom.find('.notification-time').text(moment(data.time).fromNow());
            dom.find('.notification-time').attr('data-time', data.time);
            dom.find('.notification-img').css('background-image', String.format('url(%s)', data.data.albumart));

            return dom;
        }

        var toDOM = function(callback){

            return function(data){

                toolkit.extend(data, {
                    'eventid' : (Math.random() * 100000).toString()
                }, false);

                var ecode = data.code.toString();
                var eid = data.eventid.toString();
                var notification = notificationMap[ecode + eid];
                var prepend = typeof notification === 'undefined';

                notification = notificationMap[ecode + eid] = callback(data, notification, ecode + eid, eid, data.code);

                if(prepend && typeof notification !== 'undefined')
                    $('#dashboard-notifications').prepend(notification);

            }
        }

        handler.on('process', 'start', toDOM(handleProcessStart));
        handler.on('process', 'failed', toDOM(handleProcessFailure));
        handler.on('convert', 'start', toDOM(handleConvertStart));
        handler.on('convert', 'progress', toDOM(handleConvertProgress));
        handler.on('convert', 'finished', toDOM(handleConvertEnd));
        handler.on('convert', 'failed', toDOM(handleProcessFailure));
        handler.on('analyze', 'start', toDOM(handleAnalyzeStart));
        handler.on('analyze', 'finished', toDOM(handleAnalyzeEnd));
        handler.on('upload', 'start', toDOM(handleUploadStart));
        handler.on('upload', 'progress', toDOM(handleUploadProgress));
        handler.on('upload', 'finished', toDOM(handleUploadEnd));
        handler.on('upload', 'failed', toDOM(handleProcessFailure));
        handler.on('process', 'finished', toDOM(handleProcessEnd));

    },
    ready: function() {

        this.private().toUpload = [];
        var __context = "muistate-dashboard";
        var gui = require('mui/gui'),
            toolkit = require('elixir/toolkit'),
            codes = require('elixir/codes'),
            debug = require('elixir/debug'),
            core = require('elixir/core'),
            io = require('mui/io'),
            base = this.super().super(),
            constants = require('elixir/constants'),
            listeners = this.private().listeners = {}, 
            handler = this.super(),
            _ = this;

        $('#content').html(this.templates.content())
        $('#content').css('height', '100%');
        $('#content-wrapper').css('overflow', 'hidden');

        this.resetController();

        io.connect('get-user-data', function(err, msg, data){
            if(codes.behavior.failed(err)) return base.toast("Sorry, we have hit an error. " + msg);
            else if (codes.behavior.other(err)) return;
            data = data.data;
            $('#user-usage').text(Math.round(data.spaceused / 1024 / 1024 * 100) / 100 + " MB / 25 GB");
            $('#user-fullname').text(data.fname + " " + data.lname);
        })

        toolkit.bind('#logoff', 'body', listeners, 'click', function(){
            toolkit.execute('#logoff', this, function(){
                io.connect('logoff', function(err, msg, data){
                    toolkit.hashdirect('#');
                    toolkit.completed('#logoff');
                }); 
            });
        });

        /*** MENU BOOTRAPPER **/

        toolkit.bind('.menu-item', '.menu', listeners, 'click', function() {
            $menuItem = $(this);
            $menuItem.parent().parent().children().eq(0).text($menuItem.text()).removeClass('menu-active');
            $menuItem.parent().slideUp();
        });

        toolkit.bind('.menu-title', '.menu', listeners, 'click', function() {
            $menuTitle = $(this);

            if ($menuTitle.hasClass('menu-active')) {
                $menuTitle.parent().children().eq(1).slideUp();
                $menuTitle.removeClass('menu-active');
                return;
            }

            if($menuTitle.parent().children().eq(1).children().length === 0) 
                return base.toast($menuTitle.attr('data-error'))

            $menuTitle.addClass('menu-active');
            $menuTitle.parent().children().eq(1).slideDown();
        });

        /*** CURTAIN BEHAVIOUR **/


        toolkit.bind('#curtain', 'body', listeners, 'click', function() {
            _.hidePlaylist();
        });

        /*** MUSIC TILE **/

        this.private().qobTracker = {};
        this.private().qobHTMLTracker = {};

        var queueadd = function(err, msg, qob) {
            debug.info(__context, 'queueadd', msg);

            if (err !== codes.status.OK) return;

            var trackerID = qob.sid + qob.pid;
            var qobTracker = _.private().qobTracker;
            var qobHTMLTracker = _.private().qobHTMLTracker;

            qobTracker[trackerID] = qob;

            // Get the song data
            var song = handler.cache().song[qob.sid];
            song.id = "queue-list-" + qob.id;
            song.pid = qob.pid;

            var $songDom = qobHTMLTracker[trackerID] = $(_.templates.queueItem(song))

            // Remove the empty notification
            if($('#queue').find('.center-in-parent').length > 0)
                $('#queue').html('');


            $('#queue').append($songDom);
        };

        var queueremove = function(err, msg, qob) {
            debug.info(__context, 'queueremove', msg);

            if (err !== codes.status.OK) return;

            var trackerID = qob.sid + qob.pid;
            var qobTracker = _.private().qobTracker;
            var qobHTMLTracker = _.private().qobHTMLTracker;

            delete qobTracker[trackerID];
            $(qobHTMLTracker[trackerID]).remove();
            delete qobHTMLTracker[trackerID];

            if($('#queue').children().length === 0){
                $('#queue').html(_.templates.emptyList());
                _.super().super().resize(); // invoke parent resize
                if(_.isPlayingFromQueue()){
                    handler.stopSong();
                    _.resetController();
                }

            }

        };

        var queueshuffle = function(err, msg, queue){
            $('#queue').html('');

            var qobHTMLTracker = _.private().qobHTMLTracker;

            for(var i = 0; i < queue.length; i++){
                var qob = queue[i];
                var trackerID = qob.sid + qob.pid;
                $('#queue').append($(qobHTMLTracker[trackerID]));
            }

            toolkit.completed('#queue-shuffle');
        }

        var SAFE_PLAY_ID = "334342312";
        var currentQueueSid = undefined;

        toolkit.bind('#queue-shuffle', 'body', listeners, 'click', function() {
            toolkit.execute('#queue-shuffle', this, function() {
                handler.shuffleQueue();
            });
        });

        setTimeout(function(){
            toolkit.execute('#dialog-1-continue', this, function(){
                handler.getPlaylist('*', true, function(err, msg, data){
                    toolkit.completed('#dialog-1-continue');
                    if(err !== codes.status.OK) return;
                    for(var i in data){
                      var $ytbDOM = $(_.templates.menuItem(data[i]));
                      var $upDOM = $(_.templates.menuItem(data[i]));
                      $ytbDOM.attr('id', "ytb_" + i);
                      $upDOM.attr('id', "up_" + i);
                      $('#ytb-playlists').prepend($ytbDOM);  
                      $('#up-playlists').prepend($upDOM);  
                    } 
                })
            });
        }, 500);

        toolkit.bind('#queue-play', 'body', listeners, 'click', function() {
            _.private().queueEnabled = true;
            toolkit.execute(SAFE_PLAY_ID, this, function() {
                if(typeof handler.peekQueue() !== 'undefined')
                    handler.safePlay(handler.peekQueue().sid, function(err, msg, sid) {

                        debug.info(__context, msg);
                        toolkit.completed(SAFE_PLAY_ID);

                        if (err) return base.toast("Sorry, we have detected an error. Please try again later.");

                        currentQueueSid = sid;
                        var lastPlayed = _.private().lastPlayed;

                        if (typeof lastPlayed !== 'undefined') lastPlayed.removeClass('music-tile-selected');
                        lastPlayed =  _.private().qobHTMLTracker[sid].addClass('music-tile-selected');
                        _.private().lastPlayed = lastPlayed;

                    });
                else 
                    toolkit.completed(SAFE_PLAY_ID);
            });
        });

        // Add to parent state
        handler.on('queue', 'offer', queueadd);
        handler.on('queue', 'poll', queueremove);
        handler.on('queue', 'shuffle', queueshuffle);

        toolkit.bind('.music-control-icon', 'body', listeners, 'click', function() {
            var id = $(this).attr('class');
            toolkit.execute(id, this, function() {

                var $this = $(this);
                var sid = $this.parent().attr('data-sid');
                var pid = $this.parent().attr('data-pid');

                var addClass, removeClass;
                var trackerID = sid + pid;
                var qobTracker = _.private().qobTracker;

                if ($this.hasClass('music-remove')) {
                    handler.removeFromQueue(qobTracker[trackerID]);
                    removeClass = 'music-remove';
                    addClass = 'music-add';
                } else {
                    handler.addToQueue('song', sid, pid);
                    console.log(handler.getQueue());
                    removeClass = 'music-add';
                    addClass = 'music-remove';
                }

                $this.transform3d().scale(0, 0, 1).apply();

                setTimeout(function() {
                    $this.removeClass(removeClass).addClass(addClass).transform3d().scale(1, 1, 1).apply();
                    toolkit.completed(id);
                }, 120);
            });
        });

        /*** SETUP **/

        $('#dashboard-content').css('opacity', 1);
        $('#dialog-bg').css('display', 'none');
        $('#dialog-0, #dialog-1, #dialog-4, #dialog-5').transform3d().translate(0, '-200%', 0).apply();
        $('#dialog-3').transform3d().translate('350px', 0, 0).apply();

        /*** DIALOGS **/

        toolkit.bind('#dialog-bg', $('#dialog-bg').parent(), listeners, "click", function(event) {
            if(_.private().safely('bgEnabled', true))
                _.hideDialog();
        });

        var resetDialog0 = function(){            
            $('#dialog-0-message').parent().css('display', 'none');
            $('#dialog-0-request').val('');
            $('#dialog-0-playlist').removeClass('menu-active').text('SELECT PLAYLIST');
            $('#ytb-playlists').slideUp();
        }


        $('#dialog-0-playlist').removeClass('menu-active').text('SELECT PLAYLIST');
        $('#dialog-1-playlist').removeClass('menu-active').text('SELECT PLAYLIST');

        var resetDialog1 = function(){}

        this.private().isPlaylistEditing = false;

        toolkit.bind('#playlist-edit-button', '#reveal', listeners, 'click', function(event) {
            $('#dialog-bg').css('display', 'block');
            $('#dialog-5').transform3d().translate(0, 0, 0).apply();
            $('#dashboard-content').css('opacity', '0.2');

            toolkit.execute('#playlist-edit-button', this, function(){

                var pid = _.private().activePlaylist;

                handler.getPlaylist(pid, function(err, msg, data){

                    if(err) {
                        toolkit.completed('#playlist-edit-button')
                        return base.toast("Could not find the playlist. Try again later.");
                    }

                    var playlistinfo = data[pid];

                    $("#dialog-5").css('background-image', String.format('url(%s)', playlistinfo.imageBlurred));
                    $("#album-edit-bg-img").css('background-image', String.format('url(%s)', playlistinfo.imageLarge));
                    $("#album-edit-name").val(playlistinfo.name);
                    $("#album-edit-name").val(playlistinfo.name);
                    $('#album-edit-songs').html('');

                    var songs = playlistinfo.songs;

                    if(songs.length === 0)
                        toolkit.completed('#playlist-edit-button')

                    handler.getSong(songs.join(','), function(err, msg, data){

                        toolkit.completed('#playlist-edit-button')
                        if(err) return base.toast("Could not find the playlist. Try again later.");

                        _.private().isPlaylistEditing = true;

                        for(var sid in data){
                            var song = data[sid];
                            song.pid = pid;
                            var $editListDom = $(_.templates.editList(song));
                            $('#album-edit-songs').prepend($editListDom);
                        }
                    })
                });
            });    
        });


        toolkit.bind('#add-playlist-handle', '#topbar', listeners, 'click', function(event) {
            $('#dialog-bg').css('display', 'block');
            $('#dialog-4').transform3d().translate(0, 0, 0).apply();
            $('#dashboard-content').css('opacity', '0.2');       
        });

        toolkit.bind('#dialog-1-continue', '#dialog-1', listeners, 'click', function(event) {
            toolkit.execute('#dialog-1-continue', this, function(){

                var $playlist = $("#dialog-1-playlist");
                var playlist = $('#dialog-1-playlist').text();

                if(playlist==='SELECT PLAYLIST'){ 
                    $playlist.addClass('dialog-form-error');
                    base.toast("Select a playlist!");
                    return toolkit.completed('#dialog-1-continue');
                }

                $playlist.removeClass('dialog-form-error');
                $(this).css('opacity', '0.5');

                var toUpload = _.private().toUpload;
                for(var i = 0; i < toUpload.length; i++){
                    toUpload[i].formData = { 'playlist' : playlist };
                    $(toUpload[i].context).attr('data-status', 'processing');
                    toUpload[i] = toUpload[i].submit();
                }
            });
        });

        toolkit.bind('#dashboard-sidebar-upload', '#dashboard-sidebar', listeners, "click", function(event) {
            $('#dialog-bg').css('display', 'block');
            $('#dialog-0').transform3d().translate(0, 0, 0).apply();
            $('#dashboard-content').css('opacity', '0.2');
            resetDialog0();
        });

        toolkit.bind('#notification-handle', '#topbar', listeners, "click", function(event) {
            $('#dialog-bg').css('display', 'block');
            $('#dialog-3').transform3d().translate(0, 0, 0).apply();
            $('#dashboard-content').css('opacity', '0.2');
            $(this).addClass('notification-icon-selected');
        });

        toolkit.bind('#search-box', '#topbar', listeners, "click", function(event) {
           base.toast("Sorry, this feature is still under construction. Please try again later.");
        });

        toolkit.bind('#dialog-0-continue', '#dialog-0', listeners, 'click', function(event) {

            var __behavior = "request-song";

            var id = $(this).attr('id'),
                $button = $(this),
                $message = $('#dialog-0-message'),
                $request = $('#dialog-0-request'),
                $playlist = $('#dialog-0-playlist'),
                $agreement = $('#dialog-0-agreement');

            toolkit.execute(id, function() {

                if($playlist.text() === 'SELECT PLAYLIST') {
                    $playlist.addClass('dialog-form-error');
                    return toolkit.completed(id);
                }
                            
                io.connect('request-song', $request.val(), $playlist.text(), $agreement.attr('data-selected'), function(code, msg) {

                    debug.log(__context, __behavior, String.format('[code: %s][msg: %s]', code, msg));

                    switch (code) { 
                        case codes.behavior.VALIDATION_ERROR:
                            {
                                $request.removeClass('dialog-form-error');
                                $playlist.removeClass('dialog-form-error');
                                $agreement.removeClass('dialog-form-error');

                                if (msg === "request")
                                    $request.addClass('dialog-form-error');
                                else if (msg === "playlist")
                                    $playlist.addClass('dialog-form-error');
                                else if (msg === "agreement")
                                    $agreement.addClass('dialog-form-error');

                                break;
                            }
                        case codes.behavior.ACTIVE:
                            {
                                $request.removeClass('dialog-form-error');
                                $playlist.removeClass('dialog-form-error');
                                $agreement.removeClass('dialog-form-error');

                                $button.css({
                                    'opacity': 0.5
                                });
                                break;
                            } 
                        case codes.behavior.UNKOWN_ERROR:
                            {
                                $message.parent().css({
                                    'display': 'block'
                                });
                                $message.text("Unexpected error: Please try again.");
                                break;
                            }
                        case codes.behavior.DEFINED_ERROR:
                            {
                                $message.parent().css({
                                    'display': 'block'
                                });
                                $message.text("Server: " + msg);
                                break;
                            }
                        case codes.behavior.COMPLETED:
                            {
                                // $message.parent().css({
                                //     'display': 'block'
                                // });
                                // $message.text("Server: " + msg);
                                _.hideDialog();
                                base.toast('Your music is being retrieved. Click on notifications for updates.');
                                break;
                            }
                        case codes.behavior.INACTIVE:
                            {
                                $button.css({
                                    'opacity': 1.0
                                });
                                break;
                            }
                    }

                    toolkit.completed(id);

                });
            });
        });
        

        toolkit.bind('#dialog-4-create', '#dialog-4', listeners, 'click', function(event) {

            var __behavior = "create-playlist";

            var id = $(this).attr('id'),
                $button = $(this), 
                $message = $('#dialog-4-message'),
                $request = $('#dialog-4-playlist');

            toolkit.execute(id, function() {

                io.connect('t-add-new-playlist', $request.val(), function(code, msg, data) {

                    debug.log(__context, __behavior, String.format('[code: %s][msg: %s]', code, msg));

                     switch (code) {
                        case codes.behavior.VALIDATION_ERROR: {
                            $request.addClass('dialog-form-error');                            
                            break;
                        }
                        case codes.behavior.ACTIVE: {
                            $request.removeClass('dialog-form-error');
                            $button.css({ 'opacity': 0.5 });                        
                            break;
                        }
                        case codes.behavior.UNKOWN_ERROR: {
                            $message.parent().css({ 'display' : 'block' });
                            $message.text("Unexpected error: Please try again.");
                            break;
                        }
                        case codes.behavior.DEFINED_ERROR: {
                            $message.parent().css({ 'display' : 'block' });
                            $message.text("Server: " + msg);
                            break;
                        }
                        case codes.behavior.COMPLETED:{
                            var $ytbElement = $(_.templates.menuItem(data.data));
                            $ytbElement.attr('id', 'ytb_' + data.data._id);
                            $('#ytb-playlists').prepend($ytbElement);

                             var $upElement = $(_.templates.menuItem(data.data));
                            $upElement.attr('id', 'up_' + data.data._id);
                            $('#up-playlists').prepend($upElement);

                            _.hideDialog();
                            base.toast('Your playlist has been created!');
                            //  $message.parent().css({ 'display' : 'block' });
                            // $message.parent().css({ 'display' : 'none' });
                            // $message.text("Server: " + msg);
                            break;
                        }
                        case codes.behavior.INACTIVE: {   
                            $button.css({ 'opacity': 1.0 });
                            break;
                        }
                    }

                    toolkit.completed(id);

                });
            });
        });

        /*** SIDEBAR**/

        toolkit.bind('.dashboard-sidebar-btn', '#dashboard-sidebar', listeners, 'click', function(e) {

            if($(this).hasClass('dashboard-sidebar-btn-selected')) return;
            if($(this).hasClass('not-built')) return base.toast("Sorry, this is not part of our MVP. It will be built in the next few months.");

            var $id = $(this).attr('id');
            var state = $id.substring($id.lastIndexOf('-') + 1);
            var uri = toolkit.getHashAsObj();

            uri.state = state;
            _.setMenuSelected(state);
            toolkit.setHashWithObj(uri);
        });

         toolkit.bind('#music-volume', '#music-bar', listeners, 'click', function(e) {

            var $this = $(this);

            if($this.hasClass('music-volume-med')){
                $this.removeClass('music-volume-med').addClass('music-volume-high');
                handler.setVolume(1);
            } else if($this.hasClass('music-volume-high')){
                $this.removeClass('music-volume-high').addClass('music-volume-mute')
                handler.setVolume(0);
            } else if($this.hasClass('music-volume-mute')){
                $this.removeClass('music-volume-mute').addClass('music-volume-low')
                handler.setVolume(0.3);
            } else if($this.hasClass('music-volume-low')){
                $this.removeClass('music-volume-low').addClass('music-volume-med')
                handler.setVolume(0.6);
            } 
        });


        /*** MUSIC MENU **/

        var xminleft = 450;
        var xminright = 200;
        var $controller = $('#music-controller');
        var $srcubber = $('#music-scrubber');
        var firedOnce = false;

        var repeatOnce = false;
        var repeat = true;
        var shuffle = false;

        this.private().queueEnabled = false;

        toolkit.bind('#music-controller', 'body', listeners, 'click', function(e) {
            mouseMove(e);
        });

        toolkit.bind('#music-controller-wrapper', 'body', listeners, 'click', function(e) {
            mouseMove(e);
        });

        toolkit.bind('#music-repeat', 'body', listeners, 'click', function(e) {
            switch($(this).text()){
                case 'SINGLE' : 
                        repeat = true; 
                        repeatOnce = false; 
                        return $(this).text('ALL');
                case 'ALL' : 
                        repeat = false; 
                        repeatOnce = false; 
                        return $(this).text('NONE');
                default :
                case 'NONE' : 
                        repeat = false; 
                        repeatOnce = true;
                        return $(this).text('SINGLE');
            }
        });

        toolkit.bind('#music-scrubber', 'body', listeners, 'mousedown', function(e) {
            if (firedOnce) {
                quitMouseMove(e);
                return;
            };
            firedOnce = true;
            $controller.removeClass('animator');
            $srcubber.removeClass('animator');
            $('body').on('mousemove', '#music-bar', mouseMove);
        });

        var mouseMove = function(e, audio) {
            var winWidth = $(window).width();
            if (e.clientX >= xminleft && e.clientX <= winWidth - xminright) {
                var width = (e.clientX - xminleft) / (winWidth - xminright - xminleft) * 100;
                $controller.css('width', width + '%')
                $srcubber.css('left', width + '%')
                handler.skipSongToPercentage(width);
            }
        }

        var formatTime = function(seconds) {
            minutes = Math.floor(seconds / 60);
            minutes = (minutes >= 10) ? minutes : "0" + minutes;
            seconds = Math.floor(seconds % 60);
            seconds = (seconds >= 10) ? seconds : "0" + seconds;
            return minutes + ":" + seconds;
        }

        var timeupdate = function(audio, sid, pid) {
            var percentage = (audio.currentTime / audio.duration) * 100;
            $('#music-controller').css('width', percentage + "%");
            $('#music-scrubber').css('left', percentage + "%");
            $('#music-current-time').text(formatTime(audio.currentTime));
            $('#music-duration').text(formatTime(audio.duration));
        }

        var ended = function(audio, sid, pid) {
            if (repeatOnce) return handler.safePlay(sid, pid);
            if (!_.private().queueEnabled) return _.resetController();
            var qob = handler.afterInQueue(sid, pid, repeat);
            if (typeof qob === 'undefined') return _.resetController();
            else handler.safePlay(qob.sid, pid, function(err, msg, sid) {

                debug.info(__context, msg);

                if (err) return base.toast("Sorry, we have detected an error. Please try again later.");

                var trackerID = sid + pid;
                var lastPlayed = _.private().lastPlayed;
                var $song = _.private().qobHTMLTracker[trackerID];

                if (typeof lastPlayed !== 'undefined') lastPlayed.removeClass('music-tile-selected');
                lastPlayed = $song.addClass('music-tile-selected');
                _.private().lastPlayed = lastPlayed;

            });
        }

        var quitMouseMove = function(e) {
            $('body').off("mousemove", '#music-bar', mouseMove);
            firedOnce = false;
            $controller.addClass('animator');
            $srcubber.addClass('animator');
        }

        toolkit.bind('.music-delete', '#album-edit-songs', listeners, 'click', function(){

            var $this = $(this);
            var parent = $this.parent().parent();
            var sid = parent.attr('data-sid');
            var pid = parent.attr('data-pid');

            $this.css('opacity', '0.5');

            toolkit.execute(sid, this, function() {
                handler.deleteSong(sid, pid, function(err, msg){
                    toolkit.completed(sid);
                    if(err === codes.status.OK) {
                        parent.slideUp(function(){
                            parent.remove();
                        });
                        base.toast("Deleted your song!");
                    }

                    else base.toast("We weren't able to delete the song now. Please try again later.");
                    $this.css('opacity', '1');
                });
            });
        });

        toolkit.bind("#playlist-delete-button", "#dialog-5", listeners, 'click', function(){
             toolkit.execute("#playlist-delete-button", this, function() {
                handler.deletePlaylist(_.private().activePlaylist, function(err, msg, data){
                    toolkit.completed("#playlist-delete-button");
                    if(err) return base.toast("Sorry, we couldn't delete your playlist now. " + msg);
                    base.toast("Deleted your playlist.");
                    _.hideDialog();
                    _.hidePlaylist();
                });
             });
        });

        toolkit.bind("#dialog-5-continue", "#dialog-5", listeners, 'click', function(){
            toolkit.execute("#dialog-5-continue", this, function() {
                handler.renamePlaylist(_.private().activePlaylist, $('#album-edit-name').val(), function(err, msg, data){
                    toolkit.completed("#dialog-5-continue");
                    if(err) return base.toast("Sorry! " + msg);
                    base.toast("Updated your playlist.");
                    _.hideDialog();
                });
            });
        });

        var TL_ID = "23423434";

         toolkit.bind('.music-show-icon', '#album-edit-songs', listeners, 'click', function() {
            
            var $this = $(this).hasClass('activity-list') ? $(this).children().eq(1).children().eq(0) :
                            $(this);
            toolkit.execute(TL_ID, $this, function() {

                var $this = $(this);

                if ($this.hasClass('music-minus')) {  
                    $this.parent().parent().children().eq(0).transform3d().translate('-80px', 0, 0).apply(); // increase by 2px
                    $this.parent().transform3d().translate(0, 0, 0).apply();
                    removeClass = 'music-minus';
                    addClass = 'music-plus';
                    // delete selected[$this.parent().parent().attr('data-sid')];
                } else {
                    $this.parent().parent().children().eq(0).transform3d().translate(0, 0, 0).apply();
                    $this.parent().transform3d().translate('80px', 0, 0).apply();
                    removeClass = 'music-plus';
                    addClass = 'music-minus';
                    // selected[$this.parent().parent().attr('data-sid')] = 'selected';
                }

                $this.transform3d().scale(0, 0, 1).apply();

                setTimeout(function() {
                    $this.removeClass(removeClass).addClass(addClass).transform3d().scale(1, 1, 1).apply();
                    toolkit.completed(TL_ID);
                }, 120);
            });
        });


        toolkit.bind('.music-tile', 'body', listeners, 'click', function() {

            var $song = $(this);

            toolkit.execute(SAFE_PLAY_ID, this, function() {
                
                if($song.hasClass('activity-list') || $song.hasClass('edit-list')) {
                    return toolkit.completed(SAFE_PLAY_ID);
                } else if ($song.hasClass('queue-list')) {
                    _.private().queueEnabled = true;
                } else {
                    _.private().queueEnabled = false;
                }

                if(_.private().queueEnabled){
                    $('#music-previous,#music-next').removeClass('music-disabled');
                } else {                    
                    $('#music-previous,#music-next').addClass('music-disabled');
                }

                handler.safePlay($song.attr('data-sid'), $song.attr('data-pid'), function(err, msg, sid) {

                    debug.info(__context, msg);
                    toolkit.completed(SAFE_PLAY_ID);

                    if (err){
                        _.resetController();
                     return base.toast("Sorry, we have detected an error. Please try again later.");
                 }

                    $('#music-play').removeClass('music-disabled');
                    var lastPlayed = _.private().lastPlayed;

                    if (typeof lastPlayed !== 'undefined') lastPlayed.removeClass('music-tile-selected');
                    lastPlayed = $song.addClass('music-tile-selected');
                    _.private().lastPlayed = lastPlayed;

                });
            });
        });

        toolkit.bind('#music-bar', 'body', listeners, 'mouseup', function(e) {
            quitMouseMove(e);
        });

        toolkit.bind('#music-play', '#music-bar', listeners, 'click', function(e) {
            if (!$(this).hasClass('music-pause')) {
                handler.resumeSong();
                $(this).addClass('music-pause');
            } else {
                handler.pauseSong();
                $(this).removeClass('music-pause');
            }
        });

        var _sid = 0;
        var _pid = 0;

        toolkit.bind('#music-next', '#music-bar', listeners, 'click', function(e) {
            if($(this).hasClass('music-disabled')) return;
            if (!_.private().queueEnabled) return;
            var sid = handler.getSongPlaying();
            var pid = handler.getPlaylistPlaying();
            var qob = handler.afterInQueue(sid, pid, true);
            if (typeof qob === 'undefined') return _.resetController();
            else handler.safePlay(qob.sid, qob.pid, function(err, msg, sid) {

                debug.info(__context, msg);

                if (err) return base.toast("Sorry, we have detected an error. Please try again later.");

                var trackerID = qob.sid + qob.pid;
                var lastPlayed = _.private().lastPlayed;
                var $song = _.private().qobHTMLTracker[trackerID];

                if (typeof lastPlayed !== 'undefined') lastPlayed.removeClass('music-tile-selected');
                lastPlayed = $song.addClass('music-tile-selected');
                _.private().lastPlayed = lastPlayed;

            });
        });
    

        toolkit.bind('#music-previous', '#music-bar', listeners, 'click', function(e) {
            if($(this).hasClass('music-disabled')) return;
            if (!_.private().queueEnabled) return;
            var sid = handler.getSongPlaying();
            var pid = handler.getPlaylistPlaying();
            var qob = handler.beforeInQueue(sid, pid, true);
            if (typeof qob === 'undefined') return _.resetController();
            else handler.safePlay(qob.sid, qob.pid, function(err, msg, sid) {

                debug.info(__context, msg);

                if (err) return base.toast("Sorry, we have detected an error. Please try again later.");

                var trackerID = qob.sid + qob.pid;
                var lastPlayed = _.private().lastPlayed;
                var $song = _.private().qobHTMLTracker[trackerID];

                if (typeof lastPlayed !== 'undefined') lastPlayed.removeClass('music-tile-selected');
                lastPlayed = $song.addClass('music-tile-selected');
                _.private().lastPlayed = lastPlayed;

            });
        });

        // add listeners to parent state

        var play = function(audio, sid, pid){
            _sid = sid;
            _pid = pid;
            handler.getSong(sid, function(err, msg, data){
                $('#music-play').removeClass('music-disabled');
                $('#music-play').addClass('music-pause');
                if(err !== codes.status.OK) return;
                var ellpises = data[sid].song;
                ellpises = ellpises.length > 29 ? ellpises.substring(0, 30) + '...' : ellpises;
                $('#now-playing-title').text(ellpises);
                if(typeof pid === 'undefined') return;
                handler.getPlaylist(pid, function(err, msg, _data){
                    if(err !== codes.status.OK) return;
                    $('#now-playing-album-art-blurred').css('background-image', String.format('url(%s)', _data[pid].imageBlurred));
                    $('#now-playing-album-art').css('background-image', String.format('url(%s)', _data[pid].imageLarge));
                });
            });
        }


        var addsong = function(sid, pid){
            if(_.activePlaylist() === pid){

                handler.getSong(sid, function(err, msg, data){

                    if(err) return alert("Sorry, we have detected an error. Please try again later.");

                    var $songsDom = $('#focused-playlist-scrollable');

                    // process and insert into sidebar
                    for(var sid in data){

                        var song = data[sid];
                        song.pid = pid;

                        var $songDom = $(_.templates.songList(song));

                        if(handler.existsInQueue(sid)){
                            $songDom.find('.music-control-icon').addClass('music-remove')
                                                                .removeClass('music-add');
                        }

                        if(!_.isPlayingFromQueue() && handler.getSongPlaying() === sid){
                            $songDom.addClass('music-tile-selected');
                        }
                        
                        $songsDom.prepend($songDom);

                        if(_.private().isPlaylistEditing){
                            var song = data[sid];
                            var editListDom = $(_.templates.editList(song));
                            $('#album-edit-songs').prepend(editListDom);
                        }
                    }
                });

            }
        }

        var playlistupdate = function(pid){
            handler.getPlaylist(pid, function(err, msg, data){
                if(err) return;
                $("#ytb_" + pid).text(data[pid].name);
                if(_.private().activePlaylist !==  pid) return;
                $("#playlist-name").text(data[pid].name);  
                $("#album").css('background-image', String.format("url(%s)", data[pid].imageLarge));   
                $("#album-blur-canvas").css('background-image', String.format("url(%s)", data[pid].imageBlurred));   
            });            
        };

        var playlistdelete = function(pid){
            handler.getPlaylist(pid, function(err, msg, data){
                if(err) return;
                $("#ytb_" + pid).remove();
            });
        }

        // TEST TEST TEST

        var songdelete = function(sid, pid){

            $("#" + sid + pid).slideUp(function(){
                 $(this).remove();
            });

            handler.removeFromQueueBySid(sid, pid);

            if(handler.getSongPlaying() == sid && handler.getPlaylistPlaying() == pid){
                handler.skipSongToPercentage(100);
            }


        }

        handler.on('playlist', 'update', playlistupdate);
        handler.on('playlist', 'delete', playlistdelete);
        handler.on('audio', 'play', play);
        handler.on('audio', 'timeupdate', timeupdate);
        handler.on('audio', 'ended', ended);
        handler.on('audio', 'error', ended);
        handler.on('song', 'add', addsong);
        handler.on('song', 'delete', songdelete);
        // handler.on('song', 'delete', deletesong);

        this.initUploader();
        this.initNotifications();
    },
    destroy: function() {
        $('#content').html('');
        this.super().pauseSong();
        toolkit.unbindAll(this.private().listeners);
        this.hideFlowScrollBar();
        this.hidePlaylistScrollbar();
    },
    isPlayingFromQueue : function(){
        return this.private().safely('queueEnabled', false);
    }
});
