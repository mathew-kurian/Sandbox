
/*
 * 
 * Elixir.js
 * @author Mathew Kurian
 * 
 * From Elixir.js-NodeJS v1.0
 *
 * Please report any issues
 * https://github.com/bluejamesbond/Elixir.js/issues
 * 
 * Date: 4/19/2014
 * 
 */

var path = require('path'),
    fs = require('fs'),
    jade = require('jade');

var $ = {
    states : path.join(__dirname, 'states'),
    views : path.join(__dirname, 'views'),
    mapping : '/states',
    express : undefined
}

var codes = {};

codes.behavior = {
    'VALIDATION_ERROR': -1,
    'ACTIVE': 0,
    'UNKOWN_ERROR': -3,
    'DEFINED_ERROR': -2,
    'INACTIVE': 0,
    'COMPLETED': 1
};

codes.status = {
    'FAILED': 1,
    'OK': 0,
    'NO_TYPE': 2,
    'DB_ERROR': 3
};

codes.security = {
    'LOGIN_REQUIRED': 1,
    'LOGIN_OPTIONAL': 0
};

var sendJSON = function(res, data, h){
    h = typeof h === 'undefined' ? true : false;
    if(h) res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(data));
};

// Basic function of reading files
var readFromFile = function (req, res, filepath, prep) {
    fs.readFile(filepath, {
        encoding: 'utf-8'
    }, function (err, file) {

        var data = {};
        data.security = codes.security.LOGIN_OPTIONAL;

        if (err) {

            data.code = codes.status.FAILED;
            data.msg = "Unable to read file data";
            sendJSON(res, data);

        } else {

            data.code = codes.status.OK;
            data.msg = "Successfully read data.";
            data.data = prep(file);

            try {

                preprocess(req, res, data, data.data.match(/\[elixir(.*?)\]/g));

            } catch (e) {

                data.code = codes.status.FAILED;
                data.msg = e.message;
                data.data = "";
                sendJSON(res, data);
            }
        }
    });
}

// Apply preprocessor
var preprocess = function (req, res, data, options) {

    if (options == null) return sendJSON(res, data);
    if (typeof options === 'undefined') return sendJSON(res, data);
    if (options.length === 0) return sendJSON(res, data);

    var rawOptions = options.shift();
    var optsList = rawOptions.substring(1, rawOptions.length - 1).split(/\s--(.*?):/g);
    var opts = {};

    if (optsList.length === 1) {
        return preprocess(req, res, data, options);
    }

    for (var i = 1; i < optsList.length; i++) {
        if (i % 2 === 1) {
            try { opts[optsList[i]] = optsList[i + 1]; }
            catch(e){} // FIXME Fix later
        }
    }

    switch (opts.tool) {
        case "security" :

            if($.logincheck(req)) {

                data.security = codes.security.LOGIN_REQUIRED;
                data.data = data.data.replace(rawOptions, '');

            }
            else throw Error("Content requires you to login.");

        case "userid" :
            data.data = data.data.replace(rawOptions, ((req.session.user_id) ? "\'" +  req.session.user_id + "\'" : 'undefined'));
        default: preprocess(req, res, data, options); break;
        case "jade":
            jade.renderFile(path.join($.views, opts.file), {}, function (err, html) {                

                if (!err) {

                    try {
                        var htmlOby = objectify(html);
                        data.data = data.data.replace(rawOptions, htmlOby);
                    } catch (e) {
                        throw Error(e);
                    }
                    
                } else {
                    throw Error(err);
                }

                preprocess(req, res, data, options);

            });
    }
}

String.prototype.escape = function() {
    return this.replace(/"/g, '\\\"').replace(/'/g, "\\\'");
};

String.prototype.unescape = function() {
    return this.replace(/\\\"/g, '"').replace(/\\\'/g, "'");
};

// Objectify 
var objectify = function (src) {

    var escapedHTML = src.escape();
    var evals = escapedHTML.match(/\{\$(.*?)\}/g);
    var params = {};
    var paramsList = [];

    if (evals != null) {

        for (var i = 0; i < evals.length; i++) {

            var script = evals[i];
            var _script = script.unescape();
            var tempIndex = _script.indexOf('$') + 1;
            var obj = _script.substring(tempIndex, _script.indexOf('.'));
            var objectAccess = _script.substring(tempIndex, _script.length - 1);

            escapedHTML = escapedHTML.replace(script, '\'+ (' + obj + " ? " + objectAccess + ' : \'\') + \'')
            params[obj] = 1;
        }
    }

    for (var i in params) {
        paramsList.push(i);
    }

    return "function(" + paramsList.join(',') + ") { return '" + escapedHTML + "'; }";
}

var setExpressHandle = function(){
    if(typeof $.express === 'undefined') return;

    $.express.get($.mapping, function (req, res) {
        readFromFile(req, res,
            path.join($.states, req.query.id + '.js'), function (file) {
                return file;
            });
    });
}

exports.configure = function(callback){
    if(typeof callback !== 'function') return;
    callback();
    setExpressHandle();
}

exports.set = function(key, val){
    $[key] = val;
}