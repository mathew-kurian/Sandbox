
var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var request = include('request');
var fs = require('fs');
var emitter = include('emitter');
var queue = include('queue');
var search = include('search');

var self = emitter.attach(this).silent('false');
var worker = queue.of('worker');

function Result(){
    this.title;
    this.artist;
    this.album;
    this.duration;
    this.type;
    this.strategy;
    this.src;
    this.id;
    this.images = {
        small : undefined,
        medium : undefined,
        large : undefined,
        extras : {
            glazed : undefined,
            blurred : undefined,
        }
    };

    this.duplicate = function(){
        var obj = JSON.parse(JSON.stringify(this));
        obj.duplicate = toolkit.cloneFunc(this.duplicate);    
    }
}

function Transport(){

    this.results = []
    this.id = toolkit.uuid();
    this.uid;
    this.time = Date.now()

}

var resultSet = {};

exports.find = function(q, callback){
    
    console.log("Received query - " + q);

    var opts = {
        'maxResults' : 10,
        'maxDuration' : 600000
    }
 
    var strategies = search.strategies('music');
    var results = [];
    var returned = 0;

    var addToResults = function(res){
        if(!toolkit.isNaN(res))
            if(!toolkit.isNaN(res.length))
                for(var i = 0; i < res.length; i++)
                    results.push(res[i]);
    
        if(++returned === strategies.length)
            sort(q, results, callback)
    }

    for(var i = 0; i < strategies.length; i++){
        (function(strategy){
            console.log("Attempting strategy " + strategy);
            worker.exec(function(thread){
                search.find('music', strategy, q, opts, function(err, msg, res){
                    if(!toolkit.isNaN(err)) 
                        console.error(msg);
                    addToResults(res);
                    thread.exit();
                }); 
            });
        })(strategies[i]);
    }
}

var sort = function(q, results, callback){
    console.log(results);
}