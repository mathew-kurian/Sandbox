// -----------------------------------------------------------
// Elixir - Music
// -----------------------------------------------------------

[elixir --tool:security]

require('elixir/cstate').extend({

    name: function() {
        return this.super().name();
    },
    after: function() {
        return "dashboard";
    },
    templates: {
        activity: [elixir --tool:jade --file:activity.jade],
        activityItem: [elixir --tool:jade --file:templates/activity-list.jade]
    },
    resize: function() {
        if (typeof this.private().lyne !== 'undefined')
            this.private().lyne.resize();
    },
    graphTheme : {
        "xyAxisStrokeStyle": 'transparent',
        "xyAxisLineWidth": 0,
        "yAxisLabelTextShadowStrokeStyle": "transparent",
        "yAxisLabelTextShadowOffsetY": 1,
        "yAxisLabelStrokeStyle": "transparent",
        "yAxisLabelFontSize": "12px",
        "yAxisLabelFontWeight": "700",
        "yAxisLabelFontFamily": "'Museo Sans'",
        "yAxisGridSpacingMin": 15,
        "yAxisGridSpacingMax": 55,
        "yAxisGridStrokeStyle": "transparent",
        "yAxisGridLineWidth": 1,
        "xAxisLabelTextShadowStrokeStyle": "transparent",
        "xAxisLabelTextShadowOffsetY": 1,
        "xAxisGridStrokeStyle": "rgba(255,255,255, 0.3)",
        "xAxisGridLineWidth": 1,
        "xAxisLabelStrokeStyle": "#FFF",
        "xAxisLabelFontSize": "10px",
        "xAxisLabelFontWeight": "300",
        "xAxisLabelFontFamily": "'Museo Sans'",
        "plotPointStrokeStyle": 'transparent',
        "plotPointFillStyle": '#FFF',
        "plotPointLineWidth": 8,
        "plotPointRadius": 3,
        "plotAreaFillGradientStyle": 1, 
        "plotAreaStrokeColorStart": '#FFF',
        "plotAreaStrokeColorStop": '#FFF',
        "plotAreaFillColorStart": 'transparent',
        "plotAreaFillColorStop": 'transparent',
        "plotAreaLineWidth": 3,
        "canvasPadding": 50,
        "debugVarTweener": false,
        "debugVarTweenerLabelTextShadowStrokeStyle": "transparent",
        "debugVarTweenerLabelTextShadowOffsetY": 1,
        "debugVarTweenerLabelStrokeStyle": "#555",
        "debugVarTweenerLabelFontSize": "10px",
        "debugVarTweenerLabelFontWeight": "bold",
        "debugVarTweenerLabelFontFamily": "'Proxima Nova'",
        "debugAboutLyne": false,
        "debugAboutLyneLabelTextShadowStrokeStyle": "transparent",
        "debugAboutLyneLabelTextShadowOffsetY": 1,
        "debugAboutLyneLabelStrokeStyle": "#777",
        "debugAboutLyneLabelFontSize": "10px",
        "debugAboutLyneLabelFontWeight": "bold",
        "debugAboutLyneLabelFontFamily": "'Proxima Nova'",
        "animationTime": 1800,
        "animationYStartStretch": 0,
        "animationXStartStretch": 2,
        "animationClearQueue": true
    },
    destroy: function() {
        $('#flow').html('');
        require('elixir/toolkit').unbindAll(this.private().listeners);
    },
    ready: function() {

        var __context = 'elixirstate-activity';

        var gui = require('mui/gui'),
            toolkit = require('elixir/toolkit'),
            codes = require('elixir/codes'),
            debug = require('elixir/debug'),
            io = require('mui/io'),
            constants = require('elixir/constants'),
            listeners = this.private().listeners = {}, 
            _ = this,
            handler = this.super().super();

        var base = handler.super();

        io.connect('get-user-data', function(err, msg, data){
            if(codes.behavior.failed(err)) return base.toast("Sorry, we have hit an error. " + msg);
            else if (codes.behavior.other(err)) return;
            data = data.data;
            $('#drive-usage').text(Math.round(data.spaceused / 1024 / 1024 * 100) / 100 + " MB / 25 GB");
        })

        this.super().setMenuSelected('activity');
        this.super().removeFlowScrollBar();

        $('#flow').html(this.templates.activity())
        $('#flow').scrollTop(0);

        // Points to be plotted
        var dataset = [10, 1000, 20, 235, 2500];
        var labels = ["-4 DAYS", "-3 DAYS", "-2 DAYS", "YESTERDAY", "TODAY"];
        var canvas = document.getElementById('activity-graph-canvas');

        $('#activity-song-list').html('');

        var DL_ID = "@34234234";
        var TL_ID = "@342342342";

        var selected = this.private().selected = this.private().safely('selected', {});

        toolkit.execute(DL_ID, this, function(){
            handler.getPlaylist('*', true, function(err, msg, data){
                for(var i in data){   
                    (function(pid){                 
                        handler.getSong(data[i].songs.join(','), true, function(err, msg, data){
                            if(err !== codes.status.OK) return base.toast("Unexpected error. Please refresh the page and try again.");
                            for(var key in data){
                                var song = data[key];

                                toolkit.extend(song, {
                                    fsize : '18350023'
                                }, false);

                                var songData = {
                                    song : song.song,
                                    _id : song._id,
                                    fsize : Math.round( parseInt(song.fsize)/(1024 * 1024) * 100) / 100 + "MB",
                                    artist : song.artist,
                                    id : song._id + pid,
                                    pid : pid,
                                    sid : song._id
                                }

                                var $item = $(_.templates.activityItem(songData));

                                if(typeof selected[songData.id] === 'undefined'){
                                    $item.find('.music-menu').transform3d().translate('-80px', 0, 0).apply();
                                } else {
                                    $item.find('.music-menu').transform3d().translate(0, 0, 0).apply();
                                    $item.children().eq(1).transform3d().translate('80px', 0, 0).apply();
                                    $item.children().eq(1).children().eq(0).addClass('music-minus').removeClass('music-plus');
                                }

                                $('#activity-song-list').append($item);
                            }
                        });
                    })(i);
                }
                
                toolkit.completed(DL_ID);

            });
        });
        
        toolkit.bind('.music-show-icon', 'body', listeners, 'click', function() {
            
            var $this = $(this).hasClass('activity-list') ? $(this).children().eq(1).children().eq(0) :
                            $(this);
            toolkit.execute(TL_ID, $this, function() {

                var $this = $(this);
                var trackId = $this.parent().parent().attr('data-sid') + $this.parent().parent().attr('data-pid');
                if ($this.hasClass('music-minus')) {  
                    $this.parent().parent().children().eq(0).transform3d().translate('-80px', 0, 0).apply(); // increase by 2px
                    $this.parent().transform3d().translate(0, 0, 0).apply();
                    removeClass = 'music-minus';
                    addClass = 'music-plus';
                    delete selected[trackId];
                } else {
                    $this.parent().parent().children().eq(0).transform3d().translate(0, 0, 0).apply();
                    $this.parent().transform3d().translate('80px', 0, 0).apply();
                    removeClass = 'music-plus';
                    addClass = 'music-minus';
                    selected[trackId] = 'selected';
                }

                $this.transform3d().scale(0, 0, 1).apply();

                setTimeout(function() {
                    $this.removeClass(removeClass).addClass(addClass).transform3d().scale(1, 1, 1).apply();
                    toolkit.completed(TL_ID);
                }, 120);
            });
        });

        toolkit.bind('.music-delete', '#activity-song-list', listeners, 'click', function(){

            var $this = $(this);
            var parent = $this.parent().parent();
            var sid = parent.attr('data-sid');
            var pid = parent.attr('data-pid');

            $this.css('opacity', '0.5');

            toolkit.execute(sid, this, function() {
                handler.deleteSong(sid, pid, function(err, msg){
                    toolkit.completed(sid);
                    if(err === codes.status.OK) 
                        parent.slideUp(function(){
                            parent.remove();
                        });
                    else base.toast("We weren't able to delete the song now. Please try again later.");
                    $this.css('opacity', '1');
                });
            });
        });

        // Initialize basic graph graph
        this.private().lyne = new Lyne.Graph(dataset, canvas, this.graphTheme, labels);
    }
});