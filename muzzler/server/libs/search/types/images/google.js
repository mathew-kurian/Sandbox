var cheerio = require('cheerio');
var request = require('request');
var toolkit = include('toolkit');
var codes = include('codes');
var http = include('http');
var https = include('https');
var fs = require('fs');
var path = require('path');
var safely = include('safely');

var normal = include('normal');
var Normalizer = normal.Normalizer("images", "google");
var Progress = normal.Progress;

var cacheDirectory = __search_cache_dirname;
var headers = {
    'User-Agent:': 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:29.0) Gecko/20100101 Firefox/29.0',
    'Accept:': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
}

exports.find = function (q, opts, _) {

    var size = toolkit.safely(opts.size, 'l').substring(0,1);
    var lang = toolkit.safely(opts.lang, 'en').substring(0,2);

    request.get({
        'url': 'https://www.google.com',
        'headers': headers
    }, function (err, res, body) {

        console.log("[Google.js]Received response from google.com");

        if (!toolkit.isNaN(err) && res.statusCode !== 200)
            return _.emit('error', err);
            
        try {

            var $ = cheerio.load(body);
            var link = $('.gb_c').eq(2).attr('href');

            headers['Host'] = 'www.google.com';
            headers['Referer'] = link;

            q = toolkit.encodeQuery(q);

            url = String.format('https://www.google.com/search?hl=%s&site=imghp&tbm=isch&source=hp&biw=1090&bih=220&q=%s&oq=%s&tbm=isch&tbs=isz:%s', lang, q, q, size);

        } catch (e) {
            return _.emit('error', 'Parse error - unable to find image search url');
        }

        request.get({
            'url': url,
            'headers': headers
        }, function (err, res, body) {

            console.log("[Google.js]Received response from google.com/images");

            if (!toolkit.isNaN(err) || toolkit.isNaN(body) && res.statusCode !== 200)
                return _.emit('error', err);

            var imgurls;

            try {

                imgurls = searchDOM(body);

            } catch (e) {
                return _.emit('error', 'Parse error - unable to extract images from response');
            }

            if (imgurls.length === 0) {

                var start = "Please click ";
                var end = "here</a> if you"

                if (body.indexOf(start) > -1) {

                    try {

                        var content = body.substring(body.indexOf(start) + start.length, body.indexOf(end));
                        var $ = cheerio.load(content);
                        var redirect = $("a").eq(0).attr("href").replace(/oq%3D/g, "&oq=").replace("gbv=1", "gbv=2");

                        console.warn('[Google.js]Profane word in search - Redirection => ' + redirect);

                    } catch (e) {
                        return _.emit('error', 'Parse error - unable to extract images from response');
                    }

                    request.get({
                        'url': redirect,
                        'headers': headers
                    }, function (err, res, body) {

                        console.log("[Google.js]Received response from google.com/images/redirect");

                        if (!toolkit.isNaN(err) || toolkit.isNaN(body) && res.statusCode !== 200)
                            return _.emit('error', err);

                        try {
                            imgurls = searchDOM(body);
                        } catch (e) {
                            return _.emit('error', 'Parse error - unable to extract images from response');
                        }

                        return processAndRespond(q, imgurls, opts, _);
                    });

                    return;
                }

                return _.emit('error', 'No images and no redirection');
            }

            return processAndRespond(q, imgurls, opts, _);

        });
    });
}

var processAndRespond = function (q, imgurls, opts, _) {

    var maxResults = toolkit.safely(opts.maxResults, 10);
    var response = [];
    var resultCount = 0;

    console.log("[Google.js]Found " + imgurls.length + " images.");

    for (var i = 0; i < Math.min(maxResults, imgurls.length); i++) {
        imgurls[i] = imgurls[i].replace(/\%253F/g, "?")
                               .replace(/\%253D/g, "=")
                               .replace(/\%2526/g, "&")
                               .replace(/\%2525/g, "%");
        var data = new Normalizer(q, imgurls[i], 'Image', undefined,
            undefined, undefined, undefined, undefined, resultCount++);
        data.ext = "image";

        response.push(data);
    }

    _.emit('done', response);
}


var extractImage = function (url) {
    var param = 'imgurl=';
    var nexparam = '&imgrefurl=';

    return url.substring(url.indexOf(param) + param.length, url.indexOf(nexparam))
}

var searchDOM = function (body) {

    var $ = cheerio.load(body);
    var results = $('.rg_di');
    var urls = [];

    for (var i = 0; i < results.length; i++) {

        try {
            var imgurl = extractImage(results.eq(i).find('a').attr('href'), 'imgurl');
            urls.push(imgurl);
        } catch (e) {
            console.error("[Google.js]Error extracting image url.");
        }
    }

    return urls;
}

var validateExtension = function (contentType) { 

    switch (contentType) {
    case 'png':
        return "png";
    case 'gif':
        return "gif";
    case 'tiff':
        return "tiff";
    default: return undefined;
    case 'jpeg':
    case 'jpg':
        return "jpg";
    }
}

exports.save = function (normalizer, opts, _) {

    var secure =  normal.secure(normalizer.src);
    var output = toolkit.safely(opts.saveTo, path.join(cacheDirectory, normalizer.id));

    (secure ? https : http).get(normalizer.src, function (res) {

        var total = 0;
        var extension;

        try { 
            total = toolkit.safely(parseInt(res.headers['content-length'], 10), 0);
        } catch(e){}

        try {
            var contentType = toolkit.safely(res.headers['content-type'], 'image/jpeg');
            extension = mime.extension(contentType);
        } catch(e){}

        if(toolkit.isNaN(extension)){
            var urlExt;
            var extInd = normalizer.src.lastIndexOf('.');
            if(extInd > -1 && extInd + 1 <= normalizer.src.length) 
                urlExt = validateExtension(normalizer.src.substring(extInd + 1))

            extension = urlExt;
        }

        normalizer.ext = extension = toolkit.safely(extension, "jpg");;

        var dataRead = 0;
        var prog = new Progress(total, 1);
        output = output + (toolkit.isNaN(extension) ? '.jpg' : '.' + extension);

        trackFile = fs.createWriteStream(output);

        res.on('data', function (chunk) {

            if (prog.total !== 0) {
                dataRead += chunk.length;
                prog.read(dataRead);
                _.emit('progress', prog);
            }

            trackFile.write(chunk);

        });

        res.on('error', function(err){
            _.emit('error', err);
        });

        res.on('end', function () {

            if(prog.safeFix())
                _.emit('progress', prog)

            trackFile.end();

            if(normal.mime('image', output, normalizer))
                return _.emit('error', 'Failed file saving.')

            normalizer.filePath = output;
            _.emit('done', output);
        });

    }).on('error', function(err){
        _.emit('error', err);
    });

    _.emit('start', "Started retreiving image");
}