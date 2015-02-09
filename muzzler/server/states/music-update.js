
// -----------------------------------------------------------
// Elixir - Music
// -----------------------------------------------------------

[elixir --tool:security]

require('elixir/cstate').extend({

    name : function(){
        return this.super().name();
    },
    after : function(){
        return "dashboard-update";
    },
    templates :{
        tile : [elixir --tool:jade --file:templates/album-tile.jade],
        songList : [elixir --tool:jade --file:templates/song-list.jade],
        audio : [elixir --tool:jade --file:templates/audio.jade]
    },
    load: function () {

        // stackBlurImage('profile-img', 'profile-img-canvas', 50, false, 'auto', "100%");
        // setTimeout(function () {
        //     console.log("here");
        //     $('#profile-img-canvas').addClass('animator').css("opacity", "0.6");
        // }, 1000);

    },
    resize: function () {
        var toolkit = require('elixir/toolkit');
        var _ = this;

        // don't resize immediately
        toolkit.after('stater-resize-0', 500, function () {

            // grid has been setup? then reapply it
            if(typeof _.private().albumGrid !== 'undefined')
                _.private().albumGrid.apply(_.getFlowScrollBarControl());
        });
    },
    getFlowScrollBarControl : function(){
        var _ = this;

        return function(y) {
            $('#flow').css('height', y);            
            if(y <= $('#flow').parent().height()) {      
                _.super().hideFlowScrollBar();  
                _.super().requestFlowScrollInvisibility(true);
            } else {               
                _.super().initFlowScrollBar();
                _.super().showFlowScrollBar();
                _.super().resizeFlowScrollBar();
                _.super().requestFlowScrollInvisibility(false);
            }

            _.private().albumGrid.apply();
        }
    },
    destroy : function(){
        $('#flow').html('');
    },
    ready: function () {

        var __context = 'elixirstate-music';

        var gui = require('mui/gui')
          , toolkit = require('elixir/toolkit')
          , codes = require('elixir/codes')
          , debug = require('elixir/debug')
          , io = require('mui/io')
          , constants = require('elixir/constants')
          , listeners = this.private().listeners = {}
          , _ = this;
        
        this.super().setMenuSelected('music');

        var handler = this.super().super();
        var base = handler.super();

        handler.getPlaylist('*', true, function(err, msg, data){        

            // if error notify user
            if(err) return base.toast("Could not load playlists. Please try again.");

            // load from res data
            for(var key in data){
                var playlist = data[key];
                var $playlist = $(_.templates.tile(playlist));
                $playlist.children().eq(0).transform3d().scale(0, 0, 1).apply();
                $('#flow').append($playlist);
            }

            // animate just for looking good
            $(".album-parent div").delay(1000).each(function () {
                $(this).delay(Math.random() * 1000).transform3d().scale(1, 1, 1).apply();
            });

            // build grids
            _.private().albumGrid = new require('mui/gui').GridBuilder('#flow', 280, 300);
            _.private().albumGrid.apply(_.getFlowScrollBarControl());    
        });
        
        var playlistadd = function(pid){
            handler.getPlaylist(pid, function(err, msg, data){
                if(err) return;
                var playlist = data[pid];
                var $playlist = $(_.templates.tile(playlist));
                $playlist.children().eq(0).transform3d().scale(0, 0, 1).apply();
                $('#flow').prepend($playlist);
                _.private().albumGrid = new require('mui/gui').GridBuilder('#flow', 280, 300);
                _.private().albumGrid.apply(_.getFlowScrollBarControl());
                setTimeout(function(){
                    $playlist.children().eq(0).transform3d().scale(1, 1, 1).apply();    
                }, 500);  
            }); 
        };

        var playlistdelete = function(pid){
            $("#playlist_" + pid).children().eq(0).transform3d().scale(0, 0, 1).apply();  
            setTimeout(function(){
                $("#playlist_" + pid).remove();
                _.private().albumGrid = new require('mui/gui').GridBuilder('#flow', 280, 300);
                _.private().albumGrid.apply(_.getFlowScrollBarControl());    
            }, 500);
        };

        var playlistupdate = function(pid){
            handler.getPlaylist(pid, function(err, msg, data){
                if(err) return;
                $("#playlist_" + pid).find('.album_name').text(data[pid].name);   
                $("#playlist_" + pid).find('.album').css('background-image', String.format("url(%s)", data[pid].imageLarge));   
                $("#playlist_" + pid).find('.album_canvas').css('background-image', String.format("url(%s)", data[pid].imageBlurred)); 
            });            
        };

        toolkit.bind('.album', 'body', listeners, 'click', function () {

            var id = $(this).attr('class')
              , $album = $(this);

            toolkit.execute(id, this, function() {
                
                var pid = $album.attr('data-pid');

                _.super().showPlaylist(pid);

                var $songsDom = $('#focused-playlist-scrollable').empty();

                handler.getPlaylist(pid, function(err, msg, data){  
                    if(err) {
                        toolkit.completed(id);
                        return alert("Sorry, we have detected an error. Please try again later. - 1");
                    }   

                    $('#album-blur-canvas').delay(500)
                                           .removeClass('animator')
                                           .css('opacity', 0)
                                           .css('background-image', String.format("url(%s)", data[pid].imageBlurred))
                                           .addClass('animator')
                                           .delay(400)
                                           .css('opacity', 0.4);

                    $('#album').removeClass('animator')
                               .css('opacity', 0)
                               .css('background-image', String.format("url(%s)", data[pid].imageLarge))
                               .addClass('animator')
                               .delay(400)
                               .css('opacity', 1);

                    if(data[pid].songs.length == 0) return toolkit.completed(id);

                    handler.getSong(data[pid].songs.join(','), function(err, msg, data){

                        toolkit.completed(id);
                    
                        if(err) return alert("Sorry, we have detected an error. Please try again later. - 2");

                        for(var sid in data){

                            var song = data[sid];

                            var songData = {
                                song : song.song,
                                artist : song.artist,
                                length : song.length,
                                id : song._id + pid,
                                pid : pid,
                                _id : song._id
                            }

                            var $songDom = $(_.templates.songList(songData));

                            if(handler.existsInQueue(sid, pid))
                                $songDom.find('.music-control-icon').addClass('music-remove')
                                                                    .removeClass('music-add');

                            if(!_.super().isPlayingFromQueue() && handler.getSongPlaying() === sid)
                                $songDom.addClass('music-tile-selected');
                             
                            $songsDom.prepend($songDom);
                        }

                        _.super().showPlaylistScrollbar();
                        _.super().resizePlaylistScrollbar();

                        debug.info(__context, "Focused on playlist.");
                    });
                });
            });
        });
        
        handler.on('playlist', 'add', playlistadd);
        handler.on('playlist', 'delete', playlistdelete);
        handler.on('playlist', 'update', playlistupdate);
    }    
});