
// -----------------------------------------------------------
// Elixir - Home
// -----------------------------------------------------------

require('elixir/cstate').extend({

    name : function(){
        return this.super().name();
    },
    after : function(){
        return 'base';
    },
    templates :{
        content : [elixir --tool:jade --file:home.jade],
    },
    ready: function () {

        // if(typeof this.userid() !== 'undefined'){
        //     require('elixir/toolkit').toState('music');
        // }

        $('#content').html(this.templates.content());
        $('#content-wrapper').css('overflow', 'auto');

        $('#dialog-0').transform3d().translate(0, '-200%', 0).apply();
        $('#dialog-1').transform3d().translate(0, '-200%', 0).apply();


        var _ = this;

         var gui = require('mui/gui')
           , toolkit = require('elixir/toolkit')
           , codes = require('elixir/codes')
           , debug = require('elixir/debug')
           , io = require('mui/io')
           , constants = require('elixir/constants')
           , listeners = this.private().listeners = {};

        $('#content').css('height', 'auto');

        toolkit.bind('#create-new-user-button', $('#create-new-user-button').parent(), listeners, "click", function (event) {
            $('#dialog-bg-a').css('display', 'block');
            $('#dialog-0').transform3d().translate(0,0,0).apply();
            $('#main-content').css('opacity', '0.2');
        });

        toolkit.bind('#create-new-user-button-2', $('#create-new-user-button-2').parent(), listeners, "click", function (event) {
            $('#dialog-bg-a').css('display', 'block');
            $('#dialog-0').transform3d().translate(0,0,0).apply();
            $('#main-content').css('opacity', '0.2');
        });

        toolkit.bind('#login-button', $('#login-button').parent(), listeners, "click", function (event) {
            $('#dialog-bg-a').css('display', 'block');
            $('#dialog-1').transform3d().translate(0,0,0).apply();
            $('#main-content').css('opacity', '0.2');
        });

        toolkit.bind('#dialog-bg-a', 'body', listeners, "click", function (event) {   
            _.hideDialogs();
        });

        toolkit.bind('#create-new-user-continue-button', '#dialog-0', listeners, 'click', function(event) {
            
            var __context = "muistate-home";
            var __behavior = "createuser";

            var id = $(this).attr('id')
              , $button = $(this)
              , $message = $('#create-new-user-message')
              , $email = $('#create-new-user-email')
              , $password = $('#create-new-user-password')
              , $fname = $('#create-new-user-fname')
              , $lname = $('#create-new-user-lname')
              , $agreement = $('#create-new-user-agreement');

            toolkit.execute(id, function () {
                io.connect('create-user', $email.val(), $password.val(), $fname.val(), $lname.val(), $agreement.attr('data-selected'), function (code, msg) {

                    debug.log(__context, __behavior, String.format('[code: %s][msg: %s]', code, msg));

                    switch (code) {
                        case codes.behavior.VALIDATION_ERROR: {

                            $email.removeClass('dialog-form-error');
                            $password.removeClass('dialog-form-error');
                            $fname.removeClass('dialog-form-error');
                            $lname.removeClass('dialog-form-error');
                            $agreement.removeClass('dialog-form-error');

                            if(msg === "user"){
                                $email.addClass('dialog-form-error');
                            } else if (msg == "pass"){
                                $password.addClass('dialog-form-error');
                            } else if (msg == "fname"){
                                $fname.addClass('dialog-form-error');
                            } else if (msg == "lname"){
                                $lname.addClass('dialog-form-error');
                            } else if (msg == "agreement"){
                                $agreement.addClass('dialog-form-error');
                            }
                            
                            toolkit.completed(id);
                            break;
                        }
                        case codes.behavior.ACTIVE: {

                            $email.removeClass('dialog-form-error');
                            $password.removeClass('dialog-form-error');
                            $fname.removeClass('dialog-form-error');
                            $lname.removeClass('dialog-form-error');
                            $agreement.removeClass('dialog-form-error');
                            
                            $button.css({ 'opacity': 0.5 });  

                            toolkit.completed(id);                      
                            break;
                        }
                        case codes.behavior.UNKOWN_ERROR: {
                            $message.parent().css({ 'display' : 'block' });
                            $message.text("Unexpected error: Please try again.");
                            toolkit.completed(id);and
                            break;
                        }
                        case codes.behavior.DEFINED_ERROR: {
                            $message.parent().css({ 'display' : 'block' });
                            $message.text("Server: " + msg);
                            toolkit.completed(id);
                            break;
                        }
                        case codes.behavior.COMPLETED:{
                            $message.parent().css({ 'display' : 'block' });
                            $message.text("Logging in...");
                            _.hideDialogs();
                            _.super().toast("Logging in...");
                            io.connect('login', $email.val(), toolkit.hash($password.val()), function (code, msg) {
                                if(code === codes.behavior.COMPLETED){                                    
                                    var uri = toolkit.getHashAsObj();
                                    uri.state = "music";
                                    toolkit.setHashWithObj(uri);
                                }
                            });

                            break;
                        }
                        case codes.behavior.INACTIVE: {   
                            $button.css({ 'opacity': 1.0 });
                            toolkit.completed(id);
                            break;
                        }
                    }
                });
            });
        });
        
        toolkit.bind('#login-continue-button', '#dialog-1', listeners, 'click', function(event) {
            
            var __context = "muistate-home";
            var __behavior = "login";

            var id = $(this).attr('id')
              , $button = $(this)
              , $message = $('#login-message')
              , $email = $('#login-email')
              , $password = $('#login-password');

            toolkit.execute(id, function () {
                io.connect('login', $email.val(), toolkit.hash($password.val()), function (code, msg) {
                    debug.log(__context, __behavior, String.format('[code: %s][msg: %s]', code, msg));

                    switch (code) {
                        case codes.behavior.VALIDATION_ERROR: {
                            if(msg === "user"){
                                $email.addClass('dialog-form-error');
                            } else if (msg == "password"){
                                $password.addClass('dialog-form-error');
                            }
                            
                            break;
                        }
                        case codes.behavior.ACTIVE: {
                            $email.removeClass('dialog-form-error');
                            $password.removeClass('dialog-form-error');
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

                            // $message.parent().css({ 'display' : 'block' });
                            $message.parent().css({ 'display' : 'none' });
                            $message.text("");
                            _.hideDialogs();
                            _.super().toast("Logging in...");
                            
                            var uri = toolkit.getHashAsObj();
                            uri.state = "music";
                            toolkit.setHashWithObj(uri);
                            // --------------- BRENT --------------

                            //toolkit.redirect(constants.address + "/feed");
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

        this.resize();
    },
    destroy : function(){
        $('#content').html('');
        var toolkit = require('elixir/toolkit');

        toolkit.unbindAll(this.private().listeners);
    },
    userid : function(){
        return [elixir --tool:userid];
    },
    resize : function(){
        var vwidth = 1280
          , vheight = 720
          , regionHeight = 780
          , newHeight = 0
          , newWidth = 0;

        if($(window).width() > vwidth){
            newWidth = $(window).width();
            newHeight = newWidth/vwidth * vheight;
        } else {
            newHeight = regionHeight;
            newWidth = newHeight/vheight * vwidth;
        }

        $('video').eq(0).css('height', newHeight + 'px')
                        .css('width', newWidth + 'px');
    },
    hideDialogs : function(){

            $('#dialog-bg-a').css('display', 'none');
            $('#dialog-1, #dialog-0').transform3d().translate(0,"-200%",0).apply();
            $('#main-content').css('opacity', '1.0');
    },
    bind : function(){

    },
    unbind : function(){
    }
});