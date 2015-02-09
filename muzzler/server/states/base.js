
// -----------------------------------------------------------
// Elixir - Base
// -----------------------------------------------------------

require('elixir/cstate').extend({

    name : function(){
        return "Mus.ec | Music Management";
    },
    ready : function(){

        var toolkit = require('elixir/toolkit');
        var listeners = this.private().listeners = {}; 

        $('#overlay').css('display', 'none');
        $('#toast').transform3d().translate(0, '200px', 0).apply();
        $('#toast').addClass('animator');

        this.private().timeUpdateId = setInterval(function(){
            $('.update-time').each(function(){
                $(this).text(moment($(this).attr('data-time')).fromNow());
            })
        }, 6000);

        $('.toggle-box').each(function(){
            $(this).attr('data-selected', 'false');
            $(this).removeClass('toggle-box-selected');
        })

         toolkit.bind('.toggle-box', 'body', listeners, "click", function (event) {
            $(this).toggleClass('toggle-box-selected');
            $(this).attr('data-selected', $(this).hasClass('toggle-box-selected').toString())
        });
    },
    update : function(params){
        var __context = 'elixir-state-dashboard',
            debug = require('elixir/debug'),
            persistence = require('elixir/persistence');

        this.processTests(params);

        debug.info(__context, 'testing-mode', persistence.safely('test', false));

    },
    destroy : function(){
        clearInterval(this.private().timeUpdateId);
    },
    resize : function(){
        $('.fill-parent').each(function(){
            var $this = $(this);
            $this.css('height', $this.parent().height())
                 .css('width', $this.parent().width());
        });

        $('.center-in-parent').each(function(){
            var $this = $(this);
            $this.css('right', 'auto')
                 .css('bottom', 'auto')
                 .css('top', ($this.parent().height() - $this.height()) / 2 + 'px')
                 .css('left', ($this.parent().width() - $this.width()) / 2 + 'px');
        });

        $('#toast').css('left', ($(window).width() - $('#toast').width()) / 2 + 'px');
    },
    toast : function(msg){
        clearInterval(this.private().safely('toastIntervalId', 0));
        $('#toast').removeClass('animator').text(msg).css('left', ($(window).width() - $('#toast').width()) / 2 + 'px')
                             .addClass('animator')
                             .transform3d().translate(0, 0, 0).apply();
        this.private().toastIntervalId = setTimeout(function(){
            $('#toast').transform3d().translate(0, '200px', 0).apply();
        }, 5000);
    },
    processTests : function(params){

        var persistence = require('elixir/persistence');

        var gtest = persistence.safely('test', false),
            test = params.safely('test', false),
            criteria = params.safely('criteria', 'unit');

        if( test == 'qunit' && !gtest ) {
            
            persistence.test = true;

            this.tests.init();
            this.tests.run(criteria);            

        } else if ( test === 'disabled' || test === 'none' || test === '' ) {

            persistence.test = false;
            this.tests.hide();

        } else if ( gtest ) {
            
            this.tests.init();
            this.tests.run(criteria);  
        }
    },
    tests : 
    {
        init : function(){

            var __context = 'elixir-state-dashboard',
                debug = require('elixir/debug');

            $('#overlay').css('display', 'block').children().css('display', 'none');
            $('#overlay-qunit').css('display', 'block');

            debug.info(__context, 'Activating tests.');
        },
        run : function(criteria){

            var __context = 'elixir-state-dashboard',
                debug = require('elixir/debug');

            var tests = [];

            switch(criteria) {
                case "all":            
                case "integration":
                    tests.push('qunit.state-dashboard-integration-tests.js');
                    if(criteria !== "all") break;
                case "system":                
                    tests.push('qunit.state-dashboard-system-tests.js');
                    if(criteria !== "all") break;
                default:
                case "unit":                
                    tests.push('qunit.state-dashboard-unit-tests.js');
            }
            
            QUnit.init();

            var processCriteria = function(){
                var testfile = tests.shift();
                if(typeof testfile !== 'undefined'){
                    $.get('tests/' + testfile, {}, function(s){
                        eval("var _qunit_test = function(){ " + s + "}");
                        _qunit_test();
                        processCriteria();
                    });
                } else {
                    QUnit.start();
                }
            }

            processCriteria();

            debug.info(__context, 'Running tests.');
        },
        hide : function(){

            var __context = 'elixir-state-dashboard',
                debug = require('elixir/debug');

            $('#overlay').css('display', 'none').children().css('display', 'none');
            $('#qunit-tests').empty();
            
            debug.info(__context, 'Removing tests.');
        }
    },    
});