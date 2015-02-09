var toolkit = include('toolkit');
var codes = include('codes');
var path = include('path');
var fs = require('fs');
var cheerio = require('cheerio');
var request = require('request');

var normal = include('normal');
var Normalizer = normal.Normalizer("music", "vimeo");
var Progress = normal.Progress;

// type, src, title, artist, album, duration, img, extras

var self = exports;
var cacheDirectory = __search_cache_dirname;
var validExtras = ['uploader', 'description', 'category', 'viewCount', 'likeCount', 'rating'];
var vimeoLink = "http://vimeo.com/";

exports.find = function (q, opts, _) {

    q = toolkit.encodeQuery(q);
    sort = toolkit.safely(opts.sort, 'relevant');
    maxResults = toolkit.safely(opts.maxResults, 15);
    link = "http://vimeo.com/search/sort:%s/format:detail?q=%s".f(sort, q); 

    console.info("Requesting from %s".f(link));

    request.get({
        url : link,
        headers: {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Charset': 'UTF-8,*;q=0.5',
            'Accept-Language': 'en-US,en;q=0.8',
            'Host': 'vimeo.com',
            'Referer': 'http://vimeo.com/',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
        },
        jar : true
    }, function(err, res, body){

        if(toolkit.error(err)) 
            return _.emit('error', err);

        var $ = cheerio.load(body);
        var response = [];
        var resultCount = 0;

        var results = $(".kane li");

        for(var i = 0; i < Math.min(maxResults, results.length); i++){

            var id, title, uploader, thumb, duration, plays, links, comments, dateAdded;

            var $this = results.eq(i);
            var $a = $this.find('a');
            var id = $a.eq(1).attr('href').replace(/\//g, '');

            try {
                uploader = $a.eq(2).text();
            } catch(e){
                uploader = 'Unkown';
            }

            try {
                title = $a.eq(1).text().replace(/\n/g, '');
            } catch(e){
                title = 'Unititled';
            }

            try {
                thumb = $this.find('img').attr('src').replace(/150x84/g, '640');
            } catch(e){}

            try {
                duration = $this.find('.duration').html();
            } catch(e){}

            try {
                plays = parseInt($this.find('.plays').html().split(' ')[0]);
            } catch(e){
                plays = 0;
            }

            try {
                likes = parseInt($this.find('.likes').html().split(' ')[0]);
            } catch(e){
                likes = 0;
            }

            try {
                comments = parseInt($this.find('.comments').html().split(' ')[0]);
            } catch(e){
                comments = 0;
            }

            try {
                dateAdded = new Date($this.find('time').attr('datetime')).getTime();
            } catch(e){
                dateAdded = Date.now().getTime();
            }


            if(duration) {

                var durationms = 0;
                duration = duration.split(':');

                switch(duration.length){
                    default: 
                        durationms = 0;
                        return;
                    case 3:
                        durationms += parseInt(duration[2]) * 60 * 60 * 1000;
                    case 2:
                        durationms += parseInt(duration[1]) * 60 * 1000;
                    case 1:
                        durationms += parseInt(duration[0]) * 1000;
                }

                duration = durationms;

            } else {

                duration = 0;

            }

            var data = new Normalizer(q, vimeoLink + id, title, 
                undefined, undefined, duration, thumb, {
                    'likeCount' : likes,
                    'dateAdded' : dateAdded,
                    'playCount' : plays,
                    'commentCount' : comments,
                    'uploader' : uploader
                }, resultCount++);

            data.vimeo = {
                'referrer' : link
            }

            response.push(data);
        }

        if(response.length === 0)
            return _.emit('error', 'Could not find any videos.');

        _.emit('done', response);
    });
}

exports.save = function(normalizer, opts, _){

    console.log(normalizer.src);
    console.log(normalizer.src + "/?action=download");

    request.get({
        url : normalizer.src,
        headers: {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Charset': 'UTF-8,*;q=0.5',
            'Accept-Language': 'en-US,en;q=0.8',
            'Host': 'vimeo.com',
            'Referer': normalizer.vimeo.referrer,
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
        },
        jar : true
    }, function(err, res, body){

        console.log(res.headers);

        request.get({
            url : normalizer.src + "/?action=download",
            headers: {
                'Accept': 'text/html, application/xml, text/xml, */*',
                'Accept-Charset': 'UTF-8,*;q=0.5',
                'Accept-Language': 'en-US,en;q=0.8',
                'Host': 'vimeo.com',
                'Referer': normalizer.src,
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1',
                'X-Requested-With':'XMLHttpRequest'
            },
            jar : true
        }, function(err, res, body){
            console.log(body);
        });
    });
}