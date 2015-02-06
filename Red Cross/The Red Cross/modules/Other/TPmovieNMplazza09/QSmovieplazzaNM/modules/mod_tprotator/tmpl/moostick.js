if(typeof(window['MooTools']) == 'undefined'){
    var mstkRedirect = 'http:/www.mootools.net/';
    if(confirm('Moostick requires the MooTools JavaScript framework.\n'
               + 'Be sure to include it before Moostick.\n\n'
               + 'Click OK for more info, or Cancel to load the page without it.')){
        top.location.href = redirect;
    }
}else{
    var MstkHelpers = {
        qsVar: function(key){
            var val = false;
            if(key.length > 0){
                $ES('script').each(function(s){
                    if(s.src.match('moostick.js?')){
                        var uriParts = s.src.split('?');
                        if(uriParts[1]){
                            uriParts[1].split('&').each(function(keyPair){
                                var tmp = keyPair.split('=');
                                if(tmp[1] && tmp[0] == key)
                                    val = tmp[1];
                            });
                        }
                    }
                });
            }
            return val;
        },
        checkArray: function(val){
            if(!val[0])
                return [val];
            else
                return val;
        }
    }
    if(MstkHelpers.qsVar('init') !== 'false'){
        window.addEvent('domready', function() {
            MstkInit.go(false, true);
        });
    }
    var MstkInit = {
        lists        : false,
        autoStart    : false,
        interval     : 5000,
        fxOptions    : {},
        trust4Speed  : false,
        trustOpacity : false,
        go: function(lists, autoStart, interval, fxOptions, trust4Speed, trustOpacity) {
            this.lists        = (!lists)
                              ? this.lists
                              : lists;
            this.autoStart    = (autoStart === true)
                              ? autoStart
                              : this.autoStart;
            this.interval     = (!interval) || (interval.toInt() < 500)
                              ? this.interval
                              : interval.toInt();
            this.fxOptions    = ((!fxOptions) || (typeof(fxOptions) != 'object'))
                              ? this.fxOptions
                              : fxOptions;
            this.trust4Speed  = (trust4Speed === true)
                              ? trust4Speed
                              : this.trust4Speed;
            this.trustOpacity = (trustOpacity === true)
                              ? trustOpacity
                              : this.trustOpacity;
            if(this.autoStart === true){
                if(this.trust4Speed === true){
                    this._fastMode();
                }
                else{
                    this._safeMode();
                }
            }
        },
        _fastMode: function(){
            this.lists = MstkHelpers.checkArray(this.lists);
            this.lists.each(function(list){
                new Moostick(
                    list,
                    this.autoStart,
                    this.interval,
                    this.fxOptions,
                    this.trust4Speed,
                    this.trustOpacity
                )
            }, this);
        },
        _safeMode: function(){
            
            if(this.lists === false){
                var defaultLists = false;
                if($('moostick'))
                    defaultLists = [$('moostick')];
                else if($$('.moostick'))
                    defaultLists = $$('.moostick');
                this.lists = (!defaultLists) ? false : defaultLists;
            }
            if(this.lists){
                this.lists = MstkHelpers.checkArray(this.lists);
                this.lists.each(function(list){
                    new Moostick(
                        list,
                        this.autoStart,
                        this.interval,
                        this.fxOptions,
                        this.trust4Speed,
                        this.trustOpacity
                    )
                }, this);
            }
        }
    }
    var Moostick = Class({
        version         : '1.0',
        list         : {},
        autoStart    : false,
        interval     : 3500,
        fxOptions    : {},
        trust4Speed  : false,
        trustOpacity : false,
        _firstRun    : true,
        _elSched     : null,
        _fx: false,
        initialize: function(list, autoStart, interval, fxOptions, trust4Speed, trustOpacity) {
            this.list         = ((!list) || (typeof(list) != 'object'))
                              ? this.list
                              : list;
            this.autoStart    = (autoStart === true)
                              ? autoStart
                              : this.autoStart;
            this.interval     = (!interval) || (interval.toInt() < 500)
                              ? this.interval
                              : interval.toInt();
            this.fxOptions    = ((!fxOptions) || (typeof(fxOptions) != 'object'))
                              ? this.fxOptions
                              : fxOptions;
            this.trust4Speed  = (trust4Speed === true)
                              ? trust4Speed
                              : this.trust4Speed;
            this.trustOpacity = (trustOpacity === true)
                              ? trustOpacity
                              : this.trustOpacity;
            this.list.moostick = this;
            if(this.autoStart === true){
                if(this.trust4Speed === true){
                    this._fastMode();
                }
                else{
                    this._safeMode();
                }
            }
        },
        startTick: function(list, interval, fxOptions, trust4Speed, trustOpacity){
            this.initialize(list, true, interval, fxOptions, trust4Speed, trustOpacity);
        },
        stopTick: function(){
            // TODO: figure out why removeEvent isn't working here
            this.list.$events.mouseenter = false;
            this.list.$events.mouseleave = false;
            this.pauseTick();
        },
        pauseTick: function(){
            this._elSched = $clear(this._elSched);
        },    
        resumeTick: function(){
            this._schedule();
        },
        _fastMode: function(){
            this._liHandler();
            this._schedule();
        },
        _safeMode: function(){
            if(this.list){
                if($ES('li', this.list)){
                    var items = $ES('li', this.list);
                    if(!this.list.hasClass('moostick')) this.list.addClass('moostick');
                    var noStyle = false;
                    if( this.list.getStyle('overflow') != 'hidden'
                        || items[0].getStyle('display') != 'block'
                        || items[0].getStyle('list-style-type') != 'none'){
                        noStyle = true;
                    }
                    if(noStyle){                
                        this.list.setStyles({
                            'display' : 'block',
                            'height'  : '1.5em',
                            'overflow': 'hidden'
                        });
                        
                        this._liHandler({
                            'display'        : 'block',
                            'list-style-type': 'none'
                        });
                    }
                    else{
                        this._liHandler();
                    }
                    this._schedule();
                }
            }
        },
        _setMouseEvents: function(){  
            this.list.addEvents({
                'mouseenter': function(){
                    this.moostick.pauseTick();
                },
                'mouseleave': function(){
                    this.moostick.resumeTick();
                }
            });
        },
        _liHandler: function(styles){
            if((!styles) || (typeof(styles) != 'object')) styles = false;
            if((this.trustOpacity !== true) || (styles !== false)){
                $ES('li', this.list).each(function(li){
                    if(styles !== false) li.setStyles(styles);
                    if(this.trustOpacity !== true)
                        li.setOpacity(0);
                });
            }
        },
        _schedule: function(){
            if(!this._elSched){
                var firstItem = $E('li', this.list);
                if(firstItem.getStyle('opacity') != 1)
                    this._fadeIn(firstItem);
                else if(this._firstRun === true)
                    this._fadeIn(firstItem);
                this._elSched = this._run.periodical(
                    this.interval,
                    this,
                    this.list
                );
                listEvents = this.list.$events;
                if(!listEvents)
                    this._setMouseEvents();
                else if((!listEvents.mouseenter) && (!listEvents.mouseleave))
                    this._setMouseEvents();
            }
        },
        _run: function(){
            var items = $ES('li', this.list);
            if(items[1]){
                items[0].injectAfter(items.getLast());
                this._fadeIn(items[1]);
                $ES('li', this.list).getLast().setOpacity(0);
            }
        },
        _fadeIn: function(item){
            this._fx = item.effect('opacity', this.fxOptions).start(0,1);
            this._firstRun = false;
        }
    });
}
