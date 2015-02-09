var toolkit = include('toolkit'),
    path = include('path'),
    fs = include('fs'),
    jade = include('jade'),
    dbtools = include('dbtools'),
    codes = include('codes'),
    cntools = include('connect'),
    moment = include('moment'),
    youtube = include('youtube-feeds'),
    echonest = include('echonest'),
    notify = include('notify'),
    shortid = include('shortid'),
    emailer = include('./emailer'),
    emitter = include('./emitter');

var self = emitter.attach(this).silent(false);
var $ = self.$;
var get = {}, post = {};

var createNextTimeSlotByIp = {}; // global
var cureateUserMinRetryTime = 1200000; //ms

var MAX_DEFAULT_PLAYLIST_ART = 5;
var MAX_DEFAULT_MUSIC_ART = 5;
var PUBCFDOMAIN = 'd1rk5ck21lz9pi';

// -----------------------------------------------------------
// Get
// -----------------------------------------------------------

get.hd = function(req, res){
    res.render('hd/index');
}

get.index = function(req, res) {
    res.render('index', {
        title: 'Mus.ec'
    });
};

get.music = function(req, res) {
    res.render('music', {
        title: 'Music',
        pageId: 'music'
    });
};

get.feed = function(req, res) {
    dbtools.getUserInfo(req.session.user_id, $.database, function(status, msg, user) {
        res.send(user);
    });
};

get.upload = function(req, res) {
    res.render('upload', {
        title: 'Upload',
        pageId: 'upload'
    });
};

get.youtube = function(req, res) {
    res.render('youtube', {
        title: 'Youtube',
        pageId: 'youtube'
    });
};

get.refresh = function(req, res) {
    res.render('refresh', {
        title: 'Refresh',
        pageId: 'refresh'
    });
};


get.marketing = function(req, res) {
    res.render('marketing', {
        title: 'Marketing',
        pageId: 'marketing'
    });
};

get.search = function(req, res) {
    res.render('search', {
        title: 'Search Library',
        pageId: 'search'
    });
};

get.terms = function(req, res) {
    res.render('terms', {
        title: 'Mus.ec | Terms',
        pageId: 'terms'
    });
};

get.privacy = function(req, res) {
    res.render('privacy', {
        title: 'Mus.ec | Privacy',
        pageId: 'privacy'
    });
};

get.registration = function(req, res) {
    res.render('registration', {
        title: 'Mus.ec | Registration',
        pageId: 'registration'
    });
};


get.email = function(req, res) {
    if (req.session.user_id) return res.send("Please log off to make a new account.");

    res.render('email', {
        title: 'Email Me',
        pageId: 'email'
    });
};

get.password = function(req, res) {
    res.render('newpassword', {
        title: 'Change your password',
        pageId: 'newpassword'
    });
};

get.userlist = function(req, res) {
    $.database.collection('users').find().toArray(function(err, items) {
        res.render('userlist', {
            "userlist": items
        });
    });
};

get.verify = function(req, res) {

    var urlToken = req.url.substring(8);

    if (toolkit.isNaN(urlToken.length)) {
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Access denied.");
    }

    $.database.collection('registers').findOne({
        token: urlToken
    }, function(err, register) {
        if (!toolkit.isNaN(err)) res.send("Error in activation.");
        else if (!toolkit.isNaN(register)) toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid activation url.");
        else {

            // Remove document from db.
            $.database.collection('registers').remove(register, function(err, res) {
                if (!toolkit.isNaN(err)) console.log("[REGISTRATION]Error in db deletion.");
            });


            // Non blocking database store
            return dbtools.addUserAsync(register.email, register.password, register.fname, register.lname, $.database, function(status, msg, name) {
                if (!toolkit.isNaN(status)) return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);
                return toolkit.sendDefaultJSON(res, codes.status.OK, "Successfully created new user.");
            });



        }
    });

};


get.medata = function(req, res) {

    if (toolkit.isNaN(req.session.user_id))
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "You are not authorized to view this.");

    dbtools.getUserInfo(req.session.user_id, $.database, function(status, msg, user) {
        if (toolkit.isNaN(status)) return toolkit.sendDefaultJSON(res, codes.status.OK, msg, user);

        delete user.playlists;
        delete user.songs;

        return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);

    });
};

// -----------------------------------------------------------
// Post
// -----------------------------------------------------------


post.emailer = function(req, res) {

    var email = req.body.email,
        password = req.body.pass,
        firstName = req.body.fname,
        lastName = req.body.lname,
        mailOptions = {};

    if (!toolkit.regex('email').test(email)) {
        console.log("[REGISTRATION]" + email + " is an invalid email.");
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid email address.");
    }

    // Check if password has valid length.
    if (!toolkit.regex('password').test(password)) {
        console.log("[REGISTRATION]Password needs to have minimum of six characters.");
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid password.");
    }

    // Check first name.
    if (!toolkit.regex('name').test(firstName)) {
        console.log("[REGISTRATION]Please enter your first name.");
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid first name");
    }

    // Check last name.
    if (!toolkit.regex('name').test(lastName)) {
        console.log("[REGISTRATION]Please enter your last name.");
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid last name");
    }

    // Hash password for storage. #REMOVE LATER!!
    password = toolkit.hash(password);

    // Add register document in database.
    dbtools.createRegister(email, password, firstName, lastName, $.database, function(err, msg, reg) {

        console.log("[REGISTRATION]" + msg);

        if (!toolkit.isNaN(err))
            return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);

        console.log(reg);

        // Send an email to verify registration using token.
        emailer.sendConfirmationEmail(email, reg.token);

        return res.redirect('/email');

    });

};

post.changepw = function(req, res) {
    var newPass = req.body.newpass,
        userId = req.session.user_id;

    // Hash password before passing it in.
    newPass = toolkit.hash(newPass);

    if (toolkit.isNaN(userId))
        return toolkit.sendDefaultJSON(res, codes.status.FAILED, "You are not authorized to view this.");

    dbtools.changePassword(userId, newPass, $.database, function(err, msg) {
        if (toolkit.isNaN(err)) {
            console.log("[IX:ERR]" + msg);
            return toolkit.sendJSON(res, codes.status.FAILED, msg);
        } else {
            console.log("[IX:LOG]" + msg);
            return toolkit.sendJSON(res, codes.status.OK, msg);
        }
    });

};

post.secured = function(req, res) {

    var data = {},
        type = req.body.type,
        message = "",
        status = codes.status.OK;

    if (toolkit.isNaN(type))
        type = "no-type";

    switch (type) {
        case "create-new-user":
            var user = req.body.user,
                pass = req.body.pass,
                fname = req.body.fname,
                lname = req.body.lname;

            if (!toolkit.regex('email').test(user)) {
                console.log("[REGISTRATION]" + email + " is an invalid email.");
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid email address.");
            }

            // Check if password has valid length.
            if (!toolkit.regex('password').test(pass)) {
                console.log("[REGISTRATION]Password needs to have minimum of six characters.");
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid password.");
            }

            // Check first name.
            if (!toolkit.regex('name').test(fname)) {
                console.log("[REGISTRATION]Please enter your first name.");
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid first name");
            }

            // Check last name.
            if (!toolkit.regex('name').test(lname)) {
                console.log("[REGISTRATION]Please enter your last name.");
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Invalid last name");
            }

            // Hash password before storing.
            pass = toolkit.hash(pass);

            var nextTimeSlot = createNextTimeSlotByIp[req.ip];

            if (toolkit.isNaN(nextTimeSlot) || moment(nextTimeSlot).subtract(moment()).milliseconds() >= cureateUserMinRetryTime) {

                createNextTimeSlotByIp[req.ip] = moment().add('ms', cureateUserMinRetryTime);

                // Non blocking database store
                return dbtools.addUserAsync(user, pass, fname, lname, $.database, function(status, msg, name) {
                    if (!toolkit.isNaN(status)) return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);
                    return toolkit.sendDefaultJSON(res, codes.status.OK, "Successfully created new user.");
                });

            } else
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, "Misuse detected. Retry in " + moment(nextTimeSlot).fromNow(true) + ".");
        case "login":
            var user = req.body.user,
                pass = req.body.pass;

            if (toolkit.isNaN(user) | toolkit.isNaN(pass))
                return toolkit.sendDefaultJSON(res, codes.status.FAILED, 'No expected parameters.');

            // Check db if user/pw is valid
            return dbtools.checkLogin(user, pass, $.database, function(status, msg, name) {
                if (!toolkit.isNaN(status)) return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);
                else {
                    console.log(res.session);
                    res.session.user_id = name.user_id;
                    return toolkit.sendDefaultJSON(res, codes.status.OK, msg);
                }
            });
        case "no-type":
            return toolkit.sendDefaultJSON(res, codes.status.FAILED, 'No "type" parameter');
        default:
            return toolkit.sendDefaultJSON(res, codes.status.FAILED, 'Provided "type" not an available option.');
    }

    data.status = status;
    data.message = message;

    toolkit.sendJSON(res, data);
};

// Upload manager for youtube/video links to be converted to mp3.
post.uploadManagerV = function(req, res) {
    // Assume the request is always a link for now.
    // First validate url, then check if playlist exists
    // If doesn't exist, return error.
    var request = req.body.request,
        playlistName = req.body.playlist,
        userId = req.session.user_id;
 
    console.log(req.body);

    // Create new event for processing song.
    var eventId = shortid.generate();

    notify.sendDefaultMessage(userId, codes.notification.PROCESS_START, 
        "Processing request", eventId, notify.obj('request', request).build()); 

    youtube.tools.queryToUrl(request, function(err, url) { 
        console.log("sdsdfsdf")
        if (!toolkit.isNaN(err)) {
            toolkit.sendDefaultJSON(res, codes.status.FAILED, 
                "URL could not be generated for  " + request + ": " + err);
            return notify.sendDefaultMessage(userId, codes.notification.PROCESS_FAILED, 
                "Invalid url/query", eventId, notify.obj('request', request).build());
        }

        console.log("[UploadManagerV]" + url);

        // Get playlist to add stuff to.
        dbtools.getPlaylistByName(playlistName, userId, $.database, function(status, msg, playlist) {
            if (!toolkit.isNaN(status)) {
                toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);
                return notify.sendDefaultMessage(userId, codes.notification.PROCESS_FAILED, 
                    "Invalid playlist", eventId, notify.obj('url', url).build());
            }

            // Lock the playlist during upload. This is so we cannot delete this playlist.
            dbtools.addPlaylistLock(playlist._id, $.database, function(lockedErr, lockedMsg, playlistLock) {
                if (!toolkit.isNaN(lockedErr)) {
                    notify.sendDefaultMessage(userId, codes.notification.PROCESS_FAILED, 
                        lockedMsg, eventId, notify.obj('url', url).build());
                    return toolkit.sendDefaultJSON(res, codes.status.FAILED, msg);
                }

                toolkit.sendDefaultJSON(res, codes.status.OK, "Started processing request");
                notify.sendDefaultMessage(userId, codes.notification.CONVERT_START, 
                    "Converting video", eventId, notify.obj('url', url).set('albumart', "//mus.ec/assets/images/movie.png"));

                cntools.videoToMp3(url, userId, eventId, function(convStatus, convMsg, convRes) {
                    if (!toolkit.isNaN(convStatus)) {
                        toolkit.sendDefaultJSON(res, codes.status.FAILED, convMsg);

                        dbtools.removePlaylistLock(playlistLock, $.database, 
                            function(removeLockErr, removeLockMsg) {
                                if (!toolkit.isNaN(removeLockErr)) console.log("[IX:ERR]" + removeLockMsg)
                        });

                        notify.sendDefaultMessage(userId, codes.notification.CONVERT_FAILED, "Conversion failed", eventId,
                            notify.obj('url', url).set('albumart', "//mus.ec/assets/images/movie.png").build());

                        return notify.sendDefaultMessage(userId, codes.notification.PROCESS_FAILED, convMsg, eventId,
                            notify.obj('url', url).set('albumart', "//mus.ec/assets/images/failed.png").build());

                    }

                    notify.sendDefaultMessage(userId, codes.notification.CONVERT_ONPROGRESS, "Finished conversion", eventId,
                            notify.obj('videoTitle', convRes.vtitle).set('percent', 100).build());

                    notify.sendDefaultMessage(userId, codes.notification.CONVERT_FINISHED, "Finished conversion", eventId,
                            notify.obj('url', url).set('videoTitle', convRes.vtitle).build());

                    notify.sendDefaultMessage(userId, codes.notification.FINGERPRINT_START, "Fingerprinting audio", eventId,
                            notify.obj('url', url).set('videoTitle', convRes.vtitle).set('albumart', "//mus.ec/assets/images/genius.png").build());

                    echonest.getAlbumArtFromSongMultiPass(convRes.url, function(getInfoStatus, getInfoMsg, songInfo) {

                        var tags = {
                            title: songInfo.safely('title', convRes.vtitle),
                            artist: songInfo.safely('artist', 'Anonymous'),
                            album: songInfo.safely('album', 'Single'),
                            albumart: songInfo.safely('release_image', undefined)
                        }

                        if (toolkit.isNaN(tags.albumart)){
                            var defArt = String.format("https://%s.cloudfront.net/assets/images/default/music/def-%s.jpg", 
                                        PUBCFDOMAIN, Math.floor(Math.random() * MAX_DEFAULT_MUSIC_ART));
                            if (toolkit.isNaN(songInfo.images)) tags.albumart = defArt;
                            else tags.albumart = toolkit.isNaN(songInfo.images.length) ? defArt : songInfo.images[Math.floor(Math.random() * songInfo.images.length)];
                        }
                    

                        // Add proper case to tags.
                        tags.title = toolkit.toProperCase(tags.title);
                        tags.artist = toolkit.toProperCase(tags.artist);
                        tags.album = toolkit.toProperCase(tags.album);

                        console.log(tags);

                        notify.sendDefaultMessage(userId, codes.notification.FINGERPRINT_FINISHED, 
                                    "Fingerprinting finished", eventId, tags);

                        notify.sendDefaultMessage(userId, codes.notification.UPLOAD_START, 
                                    "Upload started", eventId, tags);

                        cntools.uploadFilesYT(convRes.path, 'mp3', userId, eventId, tags, function(uploadStatus, uploadMsg, newSong) {

                            if (!toolkit.isNaN(uploadStatus)) {

                                // Unlock playlist.
                                dbtools.removePlaylistLock(playlistLock, $.database, function(removeLockErr, removeLockMsg) {
                                    if (!toolkit.isNaN(removeLockErr)) console.log("[IX:ERR]" + removeLockMsg)
                                });

                                notify.sendDefaultMessage(userId, codes.notification.UPLOAD_FAILED,
                                            "Upload failed", eventId, newSong);

                                return notify.sendDefaultMessage(userId, codes.notification.PROCESS_FAILED, 
                                            "Process failed", eventId, newSong);
                            }

                            notify.sendDefaultMessage(userId, codes.notification.UPLOAD_FINISHED, 
                                            "Upload finished", eventId, newSong);

                            notify.sendDefaultMessage(userId, codes.notification.PROCESS_FINISHED, 
                                            "Process finished", eventId, newSong);

                            // Finally, add new song entry to playlist.
                            dbtools.addSongToPlaylist(newSong._id, playlist._id, $.database, function(addErr, addRes) {

                                if (!toolkit.isNaN(addErr)) {

                                    // Unlock playlist.
                                    dbtools.removePlaylistLock(playlistLock, $.database, function(removeLockErr, removeLockMsg) {
                                        if (!toolkit.isNaN(removeLockErr)) console.log("[IX:ERR]" + removeLockMsg)
                                    });

                                    return notify.sendDefaultMessage(userId, codes.notification.ADD_SONG_FAILED, 
                                                addRes, eventId, newSong)
                                }

                                newSong.playlist = playlist;
                                newSong.url = playlist.imageLarge;

                                notify.sendDefaultMessage(userId, codes.notification.ADD_SONG, 
                                            "Song added to playlist", eventId, newSong)

                                // Update playlist art for this playlist.
                                cntools.updatePlaylistArt(playlist._id, function(updArtErr, updArtMsg, updatedPlaylist) {
                                    if (!toolkit.isNaN(updArtErr)) {
                                        console.log("[IX:ERR]" + updArtMsg);

                                        // Unlock playlist.
                                        dbtools.removePlaylistLock(playlistLock, $.database, function(removeLockErr, removeLockMsg) {
                                            if (toolkit.isNaN(removeLockErr)) console.log("[IX:ERR]" + removeLockMsg)
                                        });

                                        return notify.sendDefaultMessage(userId, codes.notification.UPDATE_PLAYLIST_FAILED, 
                                                        updArtMsg, eventId);
                                    }

                                    // Unlock playlist.
                                    dbtools.removePlaylistLock(playlistLock, $.database, function(removeLockErr, removeLockMsg) {
                                        if (removeLockErr) console.log("[IX:ERR]" + removeLockMsg)
                                    });

                                    console.log("[IX:LOG]" + updArtMsg);
                                    console.log(updatedPlaylist);

                                    return notify.sendDefaultMessage(userId, codes.notification.UPDATE_PLAYLIST, 
                                                updArtMsg, eventId, updatedPlaylist);
                                });
                            });
                        });
                    });
                });
            });
        });
    });
};

post.audiomanager = function(req, res) {

    // BRENT PLEASE TRY CATCH THIS

    var files = req.files.files,
        filesLength = files.length,
        playlistName = req.body.playlist,
        userId = req.session.user_id,
        processEventId = shortid.generate();

    console.log("[IX:LOG]Adding songs to " + playlistName + " playlist.");

    notify.sendMessage(userId, {
        code: codes.notification.PROCESS_START,
        msg: "Adding songs to " + playlistName + " playlist.",
        eventid: processEventId,
        data: {
            request: "Add songs to " + playlistName,
            albumart: "//mus.ec/assets/images/handset.png"
        }
    });

    // Get playlist first before doing anything.
    dbtools.getPlaylistByName(playlistName, userId, $.database, function(playStatus, playMsg, playlist) {
        if (playStatus) {
            console.log("[IX:ERR]" + playMsg);

            notify.sendMessage(userId, {
                code: codes.notification.PROCESS_FAILED,
                msg: playMsg,
                eventid: processEventId,
                data: {
                    request: "Add to " + playlistName,
                    albumart: "//mus.ec/assets/images/handset.png"
                }

            })

            return toolkit.sendJSON(res, {
                status: codes.status.FAILED,
                message: playMsg
            });
        } else {
            toolkit.sendJSON(res, {
                status: codes.status.OK,
                message: playMsg,
                data: playlist
            });

            reqEventIds = [];

            // Create multiple eventIds for each request.
            for (var i = 0; i < files.length; i += 1) {
                reqEventIds.push(shortid.generate());
            }

            // Now start uploading songs.
            var type = {},
                reqProcessed = 0;

            var fireAtEnd = (function(i, callback) {
                var count = 0;
                return function() {
                    if (++count === i) return callback();
                }
            })(files.length, function() {
                // Update playlist when we finish.
                cntools.updatePlaylistArt(playlist._id, function(playErr, playMsg, updatedPlaylist) {
                    if (playErr) {
                        console.log("[IX:ERR]" + playMsg);
                        notify.sendMessage(userId, {
                            code: codes.notification.UPDATE_PLAYLIST_FAILED,
                            msg: playMsg,
                            eventid: processEventId,
                            data: updatedPlaylist
                        });
                        console.log("[IX:LOG]" + playMsg);
                        return toolkit.sendJSON(res, {
                            code: codes.notification.FAILED,
                            message: playMsg,
                        });
                    } else {
                        notify.sendMessage(userId, {
                            code: codes.notification.UPDATE_PLAYLIST,
                            msg: playMsg,
                            eventid: processEventId,
                            data: updatedPlaylist
                        });

                        notify.sendMessage(userId, {
                            code: codes.notification.PROCESS_FINISHED,
                            msg: "Finished addings to " + playlistName,
                            eventid: processEventId,
                            data: {
                                request: "Add to " + playlistName
                            }
                        });

                        return toolkit.sendJSON(res, {
                            code: codes.notification.OK,
                            message: playMsg
                        });
                    }
                })
            });

            for (var i = 0; i < files.length; i += 1) {
                (function(i) {
                    reqProcessed += 1;
                    type = files[i].name.substring(files[i].name.lastIndexOf(".") + 1);
                    // Only support mp3 files for now.
                    if (type == 'mp3') {
                        notify.sendMessage(req.session.user_id, {
                            code: codes.notification.PROCESS_START,
                            msg: "Processing request",
                            eventid: reqEventIds[i],
                            data: {
                                request: files[i].name
                            }
                        });

                        var tempArt = Math.floor(Math.random() * MAX_DEFAULT_PLAYLIST_ART) + '.jpg';

                        // Create cloudfront default playlist art.
                        var art = "https://" + PUBCFDOMAIN + ".cloudfront.net/assets/images/default/music/def-" + tempArt;

                        notify.sendMessage(userId, {
                            code: codes.notification.UPLOAD_START,
                            msg: "Uploading song",
                            eventid: reqEventIds[i],
                            data: {
                                title: files[i].name,
                                albumart: art
                            }
                        });


                        cntools.uploadFiles(files[i].path, files[i].name, userId, files[i].type, art, reqEventIds[i], function(uplStatus, uplMsg, song) {
                            if (uplStatus) {
                                console.log("[IX:ERR]" + uplMsg);
                                fireAtEnd();
                                // Already doing upload failed inside upload function.

                                notify.sendMessage(userId, {
                                    code: codes.notification.PROCESS_FAILED,
                                    msg: "Process failed",
                                    eventid: reqEventIds[i],
                                    data: {
                                        request: files[i].name
                                    }
                                })
                            } else {
                                console.log("[IX:LOG]" + uplMsg);

                                notify.sendMessage(userId, {
                                    code: codes.notification.UPLOAD_FINISHED,
                                    msg: "Upload finished",
                                    eventid: reqEventIds[i],
                                    data: song
                                })

                                // After upload, add songs to the playlist.
                                dbtools.addSongToPlaylist(song._id, playlist._id, $.database, function(addStatus, addMsg) {

                                    fireAtEnd();

                                    if (addStatus) {
                                        notify.sendMessage(userId, {
                                            code: codes.notification.ADD_SONG_FAILED,
                                            msg: addMsg,
                                            eventid: reqEventIds[i],
                                            data: null
                                        });

                                        notify.sendMessage(req.session.user_id, {
                                            code: codes.notification.PROCESS_FAILED,
                                            msg: addMsg,
                                            eventid: reqEventIds[i],
                                            data: {
                                                request: files[i].name
                                            }
                                        });
                                        toolkit.sendJSON(res, {
                                            status: codes.status.FAILED,
                                            message: addMsg
                                        })
                                    } else {
                                        song.playlist = playlist;
                                        song.url = playlist.imageLarge;
                                        notify.sendMessage(req.session.user_id, {
                                            code: codes.notification.ADD_SONG,
                                            msg: addMsg,
                                            eventid: reqEventIds[i],
                                            data: song
                                        });

                                        song.url = song.albumart;
                                        notify.sendMessage(userId, {
                                            code: codes.notification.PROCESS_FINISHED,
                                            msg: "Finished processing song",
                                            eventid: reqEventIds[i],
                                            data: song
                                        });
                                        toolkit.sendJSON(res, {
                                            status: codes.status.OK,
                                            message: addMsg
                                        })

                                    }
                                });
                            }
                        });
                    } else {
                        console.log("[IX:ERR]Invalid file type.");
                    }
                })(i);
            }
        }
    });
    //res.redirect('/upload');
};

post.convert = function(req, res) {
    var link = req.body.ylink;

    // cntools.videoToMp3(link, function(status, msg) {
    //     console.log(msg);
    // });

    // cntools.validateUrl("youtube.com/watch?v=32432434&playlist=234343434", function(status, msg) {
    //     console.log(msg);
    // });

    cntools.validateUrl("http://www.youtube.com/watch?v=lcLXDKMROlY", function(status, msg) {
        console.log("hererer");
        console.log(msg);
    });
    //cntools.getMusicInfo();

    res.redirect('/youtube');
};

post.renewlinks = function(req, res) {
    cntools.renewSongLinks(req.session.user_id, function(status, msg) {
        console.log(msg);
    });
    res.redirect('/refresh');
};

post.searchsongs = function(req, res) {
    var query = req.body.songrequest;

    dbtools.textSearchSong(query, req.session.user_id, $.database, function(status, msg, searchRes) {
        console.log(searchRes);
    });
};

post.searchplaylists = function(req, res) {
    console.log(req.body);
};

// PLAYLIST AND MUSIC REQUESTS
post.requestMusicData = function(req, res) {
    var reqType = req.body.type,
        reqIds = {},
        sanitize = req.body.sanitize,
        userId = req.session.user_id;

    if (sanitize === null) {
        return toolkit.sendJSON(res, {
            status: codes.status.FAILED,
            message: "Incomplete request data.",
        })
    }
    console.log('[IX:LOG]Requesting music data.');
    // SONG REQUEST.
    if (reqType === 'request-song-data') {
        // Requesting song data.
        reqIds = req.body.sid.split(',');
        if (reqIds[0] === "*") {
            // Request all songs.
            dbtools.getAllSongs(userId, $.database, function(status, msg, songData) {
                if (status) {
                    toolkit.sendJSON(res, {
                        "status": codes.status.FAILED,
                        message: msg,
                        "data": songData
                    });
                } else {
                    toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: msg,
                        "data": songData
                    })
                }
            });

        } else if (reqIds.length != null) {
            // Return chosen songs by id.
            dbtools.getEntriesById('music', reqIds, sanitize, $.database, function(status, msg, songData) {
                if (status) {
                    toolkit.sendJSON(res, {
                        "status": codes.status.FAILED,
                        message: msg,
                        "data": songData
                    });
                } else {
                    toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: msg,
                        "data": songData
                    });
                }
            })
        } else {
            // If null, return empty request error.
            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: "Empty request error",
                "data": null
            });
        }
        // PLAYLIST REQUEST.
    } else if (reqType === 'request-playlist-data') {
        // Requesting playlist data.
        reqIds = req.body.pid.split(',');
        if (reqIds[0] === "*") {
            // Request all songs.
            dbtools.getAllPlaylists(userId, $.database, function(status, msg, playlistData) {
                if (status) {
                    toolkit.sendJSON(res, {
                        "status": codes.status.FAILED,
                        message: msg,
                        "data": playlistData
                    });
                } else {
                    toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: msg,
                        "data": playlistData
                    })
                }
            });
        } else if (reqIds.length != 0) {
            // Return chosen playlists by id.
            dbtools.getEntriesById('playlists', reqIds, sanitize, $.database, function(status, msg, playlistData) {
                if (status) {
                    toolkit.sendJSON(res, {
                        "status": codes.status.FAILED,
                        message: msg,
                        "data": playlistData
                    });
                } else {
                    toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: msg,
                        "data": playlistData
                    });
                }
            })
        } else {
            // If null, return empty request error.
            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: "Empty request error",
                "data": null
            });
        }
        // UNKNOWN REQUEST.
    } else {
        // Unknown request. Return error.
        return toolkit.sendJSON(res, {
            "status": codes.status.FAILED,
            message: "Unknown request error",
            "data": null
        });
    }
}


post.login = function(req, res) {

    console.log("[LOGIN]Secure: " + req.secure);

    var user = req.body.user;
    var pass = req.body.pass;

    console.log("[LOGIN]User " + user + " is logging in.")
    //pass = toolkit.hash(pass); 

    return dbtools.checkLogin(user, pass, $.database, function(status, msg, name) {
        if (status) {
            console.log("[LOGIN]Expecting: " + name + " - Received: " + pass);
            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: msg
            });
        } else {
            console.log("[LOGIN]User " + name.email + " is now logged in.");
            req.session.user_id = name.user_id;
            console.log("[LOGIN]Assigned session id: " + req.session.user_id);
            return toolkit.sendJSON(res, {
                "status": codes.status.OK,
                message: msg
            });
        }
    });

};

post.login2 = function(req, res) {
    var user = "benriquez12@ymail.com",
        pass = "123456";

    pass = toolkit.hash(pass);

    return dbtools.checkLogin(user, pass, $.database, function(status, msg, name) {
        if (status) {
            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: msg
            });
        } else {
            req.session.user_id = name.user_id;
            console.log(req.session.user_id);
            toolkit.sendJSON(res, {
                "status": codes.status.OK,
                message: msg
            });
        }
    });
}

post.logoff = function(req, res) {
    console.log("[LOGOFF]User " + req.session.user_id + " is logging off.");
    delete req.session.user_id;
    //console.log(session.req.user_id);
    res.redirect('/');
};

// -----------------------------------------------------------
// Music Manager
// -----------------------------------------------------------


post.newPlaylist = function(req, res) {
    var userId = req.session.user_id,
        playlistName = req.body.playlistname,
        eventId = shortid.generate();

    var remoteFilename = Math.floor(Math.random() * MAX_DEFAULT_PLAYLIST_ART) + '.jpg';
    // Create cloudfront default playlist art.
    var playlistArt = "https://" + PUBCFDOMAIN + ".cloudfront.net/assets/images/default/playlist/def-" + remoteFilename,
        playlistArtB = "https://" + PUBCFDOMAIN + ".cloudfront.net/assets/images/default/playlist/blurred-def-" + remoteFilename;

    dbtools.createEmptyPlaylist(userId, playlistName, playlistArt, playlistArtB, $.database, function(status, msg, newPlaylist) {
        if (status) {
            console.log("[IX:ERR] " + msg);

            notify.sendMessage(userId, {
                code: codes.notification.ADD_PLAYLIST_FAILED,
                msg: msg,
                eventid: eventId,
                data: null
            })

            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: msg,
                "data": null
            });
        } else {
            console.log("[IX:RES]Created new playlist: " + newPlaylist[0].name);
            notify.sendMessage(userId, {
                code: codes.notification.ADD_PLAYLIST,
                msg: "Playlist added",
                eventid: eventId,
                data: newPlaylist[0]
            });

            toolkit.sendJSON(res, {
                "status": codes.status.OK,
                message: msg,
                "data": newPlaylist[0]
            });
        }
    });
}


post.renamePlaylist = function(req, res) {
    var playlistId = req.body.pid,
        newName = req.body.name,
        userId = req.session.user_id;

    var eventId = shortid.generate();

    dbtools.renamePlaylist(playlistId, newName, $.database, function(renameError, renameMsg) {
        if (renameError) {
            console.log("[IX:ERR]" + renameMsg);
            notify.sendMessage(userId, {
                code: codes.notification.UPDATE_PLAYLIST_FAILED,
                eventid: eventId,
                msg: renameError,
                data: {
                    name: newName
                }
            })
            return toolkit.sendJSON(res, {
                status: codes.status.FAILED,
                message: renameMsg
            });
        } else {
            console.log("[IX:LOG]" + renameMsg);
            // Get new playlist data to send back.
            dbtools.getEntryById('playlists', playlistId, $.database, function(getErr, playlist) {
                console.log(playlist);
                notify.sendMessage(userId, {
                    code: codes.notification.UPDATE_PLAYLIST,
                    eventid: eventId,
                    msg: "Playlist renamed",
                    data: playlist
                })
                return toolkit.sendJSON(res, {
                    status: codes.status.OK,
                    message: renameMsg
                });
            })
        }
    });
}

post.deletePlaylist = function(req, res) {
    var playlistId = req.body.pid,
        userId = req.session.user_id;

    var eventId = shortid.generate();
    // Check if playlist is locked first.
    dbtools.isLocked(playlistId, $.database, function(lockedErr, lockedMsg, locked) {
        if (lockedErr) {
            console.log("[IX:ERR]" + lockedErr)
            notify.sendMessage(userId, {
                code: codes.notification.DELETE_PLAYLIST_FAILED,
                eventid: eventId,
                msg: lockedMsg,
                data: {
                    pid: playlistId
                }
            })
            return toolkit.sendJSON(res, {
                status: codes.status.FAILED,
                message: lockedMsg
            })
        } else if (locked) {
            console.log("[IX:ERR]" + lockedErr)
            notify.sendMessage(userId, {
                code: codes.notification.DELETE_PLAYLIST_FAILED,
                eventid: eventId,
                msg: lockedMsg,
                data: {
                    pid: playlistId
                }
            })
            return toolkit.sendJSON(res, {
                status: codes.status.FAILED,
                message: lockedMsg
            })
        } else {
            // Proceed with deletion.
            dbtools.removePlaylist(playlistId, eventId, $.database, function(removeErr, removeMsg) {
                if (removeErr) {
                    console.log("[IX:ERR]" + removeMsg);
                    notify.sendMessage(userId, {
                        code: codes.notification.DELETE_PLAYLIST_FAILED,
                        eventid: eventId,
                        msg: removeMsg,
                        data: {
                            pid: playlistId
                        }
                    });
                    return toolkit.sendJSON(res, {
                        status: codes.status.FAILED,
                        message: removeMsg
                    });
                } else {
                    console.log("[IX:LOG]" + removeMsg);
                    notify.sendMessage(userId, {
                        code: codes.notification.DELETE_PLAYLIST,
                        eventid: eventId,
                        msg: removeMsg,
                        data: {
                            pid: playlistId
                        }
                    });
                    return toolkit.sendJSON(res, {
                        status: codes.status.OK,
                        message: removeMsg
                    });
                }
            });
        }

    })
}

post.deleteSong = function(req, res) {
    var songId = req.body.sid,
        playlistId = req.body.pid,
        userId = req.session.user_id,
        eventId = shortid.generate();

    // Get existing song data.
    dbtools.getEntryById('music', songId, $.database, function(getSongErr, song) {
        if (getSongErr) {
            notify.sendMessage(userId, {
                code: codes.notification.DELETE_SONG_FAILED,
                msg: getSongErr,
                eventid: eventId,
                data: null
            });
            return toolkit.sendJSON(res, {
                code: codes.status.FAILED,
                message: getSongErr
            })
        } else {
            // Delete song from requested playlist.
            dbtools.removeSongFromPlaylist(songId, playlistId, $.database, function(remErr, remMsg) {
                if (remErr) {
                    notify.sendMessage(userId, {
                        code: codes.notification.DELETE_SONG_FAILED,
                        msg: remMsg,
                        eventid: eventId,
                        data: null
                    })
                    return toolkit.sendJSON(res, {
                        code: codes.status.FAILED,
                        message: remErr
                    })
                } else {
                    // Get updated playlist data.
                    dbtools.getEntryById('playlists', playlistId, $.database, function(getPlayErr, playlist) {
                        if (getPlayErr) {
                            notify.sendMessage(userId, {
                                code: codes.notification.DELETE_SONG_FAILED,
                                msg: getPlayErr,
                                eventid: eventId,
                                data: null
                            });
                            return toolkit.sendJSON(res, {
                                code: codes.status.FAILED,
                                message: getPlayErr
                            });
                        } else {
                            song.playlist = playlist;
                            notify.sendMessage(userId, {
                                code: codes.notification.DELETE_SONG,
                                msg: "Deleted song from playlist",
                                eventid: eventId,
                                data: song
                            })
                            return toolkit.sendJSON(res, {
                                status: codes.status.OK,
                                message: "Deleted song and updated playlist"
                            })
                        }
                    });
                }
            })
        }
    });
};

post.addSongToPlaylist = function(req, res) {
    // Get playlist info.
    var songId = req.body.sid,
        playlistId = req.body.pid,
        eventId = shortid.generate();

    dbtools.addSongToPlaylist(songId, playlistId, $.database, function(status, msgRes) {
        if (status) {
            console.log("[IX:ERR] " + msgRes);
            notify.sendMessage(userId, {
                code: codes.notification.ADD_SONG_FAILED,
                msg: msgRes,
                eventid: eventId,
                data: {
                    sid: songId
                }
            })
            toolkit.sendJSON(res, {
                "status": codes.status.FAILED,
                message: msg
            });
        } else {
            // Update playlist art for this playlist.
            cntools.updatePlaylistArt(playlistId, function(updArtErr, updArtMsg, updatedPlaylist) {
                if (updArtErr) {
                    console.log("[IX:ERR]" + updArtMsg);
                    notify.sendMessage(userId, {
                        codes: codes.notification.UPDATE_PLAYLIST_FAILED,
                        msg: updArtMsg,
                        eventid: eventId,
                        data: null
                    });
                    return toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: updArtMsg,
                        data: updatedPlaylist
                    });
                } else {
                    console.log("[IX:LOG]" + updArtMsg);
                    notify.sendMessage(userId, {
                        codes: codes.notification.UPDATE_PLAYLIST,
                        msg: updArtMsg,
                        eventid: eventId,
                        data: updatedPlaylist
                    })
                    return toolkit.sendJSON(res, {
                        "status": codes.status.OK,
                        message: updArtMsg,
                        data: updatedPlaylist
                    })
                }
            });
        }
    });
};

// -----------------------------------------------------------
// Tests
// -----------------------------------------------------------

post.testPlaylistManager = function(req, res) {
    console.log("Inside playlist manager.");
    console.log(req.body);
    // dbtools.addToPlaylist("testplaylist", req.session.user_id, songId, $.database, function(err, msg) {
    //     console.log(err);
    //     console.log(msg);
    // });
};
post.testUpload = function(req, res) {
    //COMPLETED
    console.log("inside testupload");
    dbtools.getUserInfo(req.session.user_id, $.database, function(err, result) {
        console.log(result);
    });
};

post.testGetObjectID = function(req, res) {

    // Get user and create an empty playlist.
    dbtools.getEntry("users", "email", "benriquez12@ymail.com", $.database, function(err, result) {
        if (err) {
            console.log(err);
        } else {
            dbtools.createEmptyPlaylist(result._id, "Beast Mode", $.database, function(status, msg, result) {
                statusOutput(status, msg, res);
            });
        }
    });
};

post.testInsertPlaylist = function(req, res) {
    dbtools.addPlaylistToUser("benriquez12@ymail.com", "5343bf352a74e9a5129d0579", $.database, function(err, result) {
        console.log(arguments);
    });
};

post.testCreateSong = function(req, res) {
    dbtools.createMusicEntry("5343bf352a74e9a5129d0579", "Beautiful", "Eminem", "Relapse", $.database, function(err, result) {
        console.log(arguments);
    });
};

post.testDeletePlaylist = function(req, res) {
    // Get playlist info.
    dbtools.getEntry("playlists", "name", "Beast Mode", $.database, function(err, result) {
        var playlistId = result._id;
        dbtools.removePlaylist(playlistId, $.database, function(status, msg) {
            statusOutput(status, msg, res);
        });
    });
}

// -----------------------------------------------------------
// Other
// -----------------------------------------------------------

exports.checkAuth = function(req, res, next) {
    console.log("[AUTHENTICATION]Current session id: " + req.session.user_id);
    if (!req.session.user_id) {
        console.log("[AUTHENTICATION]Failed to access page.");
        res.send('You are not authorized to view this page.');
    } else {
        res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
        console.log("[AUTHENTICATION]Access to page granted.");
        next();
    }
};

var statusOutput = function(status, msg, res) {
    if (status) {
        toolkit.sendJSON(res, {
            "status": codes.status.FAILED,
            message: msg
        });
    } else {
        toolkit.sendJSON(res, {
            "status": codes.status.OK,
            message: msg
        });
    }
}



// -----------------------------------------------------------
// Attach
// -----------------------------------------------------------

exports.get = get;
exports.post = post;