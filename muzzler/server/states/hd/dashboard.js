
// -----------------------------------------------------------
// Elixir - Home
// -----------------------------------------------------------

"extend hd/empty";

var toolkit = include('toolkit');
var interact = include('interact');
var $ = include('jquery');

var self = exports;
var handle;
var handleWidth;
var sectionPos;
var x;

// -----------------------------------------------------------
// Sample
// -----------------------------------------------------------

var tracks = [
    {
        id : "3234344354354534535",
        title : "Green Eyes",
        track : 1,
        artist : "Coldplay",
        duration : 1200000,
        images : {
            large : "",
            medium : "",
            small : "",
            blurred : "",
        }
    },
    {
        id : "3234344354354534535",
        title : "Green Eyes",
        track : 2,
        artist : "Coldplay",
        duration : 1200000,
        images : {
            large : "",
            medium : "",
            small : "",
            blurred : "",
        }
    },
    {
        id : "3234344354354534535",
        title : "Green Eyes",
        track : 3,
        artist : "Coldplay",
        duration : 1200000,
        images : {
            large : "",
            medium : "",
            small : "",
            blurred : "",
        }
    }
];

// -----------------------------------------------------------
// Templates
// -----------------------------------------------------------

var content = [elixir --tool:jade --file:hd/dashboard.jade];

// -----------------------------------------------------------
// Extend
// -----------------------------------------------------------

exports.views = {};
exports.views.show = {};
exports.views.hide = {};
exports.views.add = {};
exports.views.update = {};

exports.events = {};
exports.events.click = {};

// -----------------------------------------------------------
// Exports
// -----------------------------------------------------------

exports.views.show.flow = function(e){

    $('#flow').addClass('animator')
              .transform3d()
              .translate(0,0,0).apply();
}

exports.views.show.playlist = function(e){

    var parentHeight = $('#playlist-focus-list').parent().height();
    var height = $('#playlist-focus-list').height();
    var artHeight = $('#playlist-focus-art').height() + 20; // offset

    $('#playlist-focus-list').css('padding-top', (parentHeight - height)/2 + 'px');
    $('#playlist-focus-art').css('top', (parentHeight - artHeight)/2 + 'px')
}

exports.views.hide.flow = function(e){
    $('#flow').addClass('animator')
              .transform3d()
              .translate(0, $(window).height() + 'px', 0)
              .apply();
}

exports.views.add.track = function(track){



    self.emit('add-track', track);    
}

exports.views.update.section = function(p, a){
    a = a ? true : false;
    sectionPos = p;

    var p = p / 100;
    var type = a ? 'animate' : 'css';
    var minRightWidth = 300;
    var minLeftWidth = 800;
    var parentWidth = handle.parent().width();
    var leftWidth = parentWidth * p;
    var rightWidth = parentWidth - (handleWidth + leftWidth);

    if(leftWidth < minLeftWidth) {
        $("#section-left")[type]({'left': - ((minLeftWidth - leftWidth)/parentWidth * 100) + '%',
                                  'width': ( minLeftWidth/parentWidth * 100) + '%'}, 'slow');
    } else {
        $('#section-left')[type]({'left': 0,
                                  'width': (leftWidth/parentWidth * 100) + '%'}, 'slow');
    }
        
    if(rightWidth < minRightWidth) {
        $("#section-right")[type]({'right': - ((minRightWidth - rightWidth)/parentWidth * 100)  + '%',
                                   'width': (minRightWidth/parentWidth * 100) + '%'}, 'slow');
    } else {
        $('#section-right')[type]({'right': 0,
                                    'width': (rightWidth/parentWidth * 100) + '%'}, 'slow');
    }

    handle[type]({'right': rightWidth/parentWidth * 100 + '%'}, 'slow');

    self.views.update.tiles();
}

exports.views.update.tiles = function(){    
    $('.playlist').wookmark({
        align: 'left',
        autoResize: true,
        container: $('#playlists'),
        ignoreInactiveItems: true,
        itemWidth: 300,
        fillEmptySpace: true,
        flexibleWidth: '50%',
        offset: 0,
        outerOffset: 0,
        possibleFilters: [],
        resizeDelay: 50,
    });
}

// -----------------------------------------------------------
// Basic
// -----------------------------------------------------------

exports.name = function(){
    return 'Mus.ec | HD';
}

exports.ready = function(){

    $('#content').html(content());

    $('#playlist-focus-list').sortable();
    $('#playlist-focus-list').disableSelection();

    handle = $("#section-handle");
    handleWidth = 10;
    x = handle.position().left;
    sectionPos = x / handle.parent().width() * 100;

    interact('#section-handle')
        .draggable({
            mode: 'anchor',
            anchors: [
                { x:  0, range: 10 },
                { x: 500, range:  5 },
            ],
            onmove: function (event) {
                x += event.dx;

                var parentWidth = handle.parent().width();
                self.views.update.section(x/parentWidth * 100);

                $('body').css('cursor', 'ew-resize');
            },
            onend: function (event) {

                var p = sectionPos / 100;
                var parentWidth = handle.parent().width();
                var leftWidth = parentWidth * p;
                var rightWidth = parentWidth - (handleWidth + leftWidth);
                var maxWidth = parentWidth - handleWidth;

                if(rightWidth > maxWidth) {
                    self.views.update.section(0, true);
                } else if (leftWidth > maxWidth){
                    self.views.update.section(maxWidth/parentWidth * 100, true);
                }

                $('body').css('cursor', 'auto');
            }
        })
        .styleCursor(false)
        .inertia(true)
        .restrict({
            drag: "parent",
            endOnly: false
        });

    $('.playlist').click(function(){
        self.views.hide.flow();
        self.views.show.playlist();
    });

    $('#playlist-focus').click(function(){
        self.views.show.flow();
    });
    
    self.views.update.tiles();
    self.views.show.playlist();

}

exports.resize = function(e){    
    x = handle.position().left;
    self.views.update.section(sectionPos);
    self.views.update.tiles();
}