var BUCKET_NAME = 'musicplayer-music-source'
  , toolkit = require('./toolkit')
  , codes = require('./codes')
  , fs = require('fs')
  , aws = require('aws-sdk')
  , s3 = {}
  , notify = require('./notify')
  , cf = require('cloudfront-private-url-creator')
  , mm = require('musicmetadata')
  , echojs = require('echojs')
  , ytdl = require('ytdl')
  , http = require('http')
  , request = require('request')
  , https = require('https')
  , tiling = require('../tiling')
  , ffmpeg = require('fluent-ffmpeg')
  , dbtools = require('./dbtools')
  , mongo = require('mongoskin')
  , db = mongo.db("mongodb://localhost:21111/Muzzler_MusicPlayer", {native_parser:true})
  , toObjectID = mongo.helper.toObjectID;

aws.config.loadFromPath('./AwsConfig.json');
s3 = new aws.S3();

var MAX_DEFAULT_PLAYLIST_ART = 5;
var MIN_DEFAULT_PLAYLIST_ART = 0;

var MAX_DEFAULT_MUSIC_ART = 4;
var MIN_DEFAULT_MUSIC_ART = 0;


var cfDomainName = 'dbjjkzvgg4mja'
  , cfDomainNamePub = 'd1rk5ck21lz9pi'
  , defaultAlbumArt = 'https://d1rk5ck21lz9pi.cloudfront.net/assets/images/albums/default-art.png';

// AMAZON KEY PAIR INFO
var keyPairId = 'APKAI3TXDMRQBDKTCLYQ'
  , privateKeyPath = './security/pk-APKAI3TXDMRQBDKTCLYQ.pem'
  , expireTime = 1; // links will expire in 1 hour.

// -----------------------------------------------------------
// Amazon Services
// -----------------------------------------------------------
exports.uploadFiles = function (path, name, userId, type, tempArt, eventId, callback) {

    console.log(path);
    console.log(name);
    console.log(userId);
    console.log(type);

    var remoteFilenameRoot = "song/"
      , fileBuffer = {}
      , remoteFilename = {}
      , metaData = {}
      , fileName = {}
      , textName = {}
      , url = {};



    processSongFile(path, type, tempArt, userId, eventId, function(bool, song) {
        if(bool) {
            // We upload the file using id.
            console.log("[CN:LOG] Uploading a song normal mode");

            fileName = song._id + ".mp3";
            fileBuffer = fs.readFileSync(path);
            remoteFilename = remoteFilenameRoot + fileName;
            textName = fileName + "\n";
            metaData = type;

            // Upload to S3.
            s3.putObject({
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: remoteFilename,
                Body: fileBuffer,
                ContentType: metaData
            }, function (err, obj) {
                if(err) {
                    console.log(err);
                    notify.sendMessage(userId, {
                        code : codes.notification.UPLOAD_FAILED,
                        msg: "Upload finished",
                        eventid : eventId,
                        data: song
                    })
                    callback(codes.status.CN_ERROR, "Upload failed.", null );
                } 
                else {
                    console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');
                    // Generate signed Cloudfront URL and save in db.

                    url = "https://" + cfDomainName + ".cloudfront.net/" + remoteFilename;
                    createSignedUrl(url, function(err, signedUrl) {
                        if(err) console.log(err);
                        else {
                            db.collection('music').updateById(song._id, {'$set':{link:signedUrl}}, function(err2, result2) {
                                if(err2) console.log(err2);
                                // Also set the expiration.
                                // Get epoch time.
                                var dateExpiration = new Date();
                                dateExpiration.setHours(dateExpiration.getHours() + expireTime);
                                var exprEpochTime = dateExpiration.getTime();

                                // Set expiration time in db.
                                db.collection('music').updateById(song._id, {'$set':{expiration:exprEpochTime}}, function(exprErr, exprRes) {
                                    if(exprErr) console.log("[CN:ERR]" + exprErr);
                                    else console.log("[CN:LOG]" + exprRes);

                                    // Update space used by user.
                                    console.log("[CN:LOG] Adding " + song.fsize + " to spaced used." );
                                    dbtools.updateMemoryUsed(userId, song.fsize, db, function(spErr, spMsg) {
                                        if(spErr) console.log("[CN:ERR]: " + spMsg);
                                        else console.log("[CN:LOG]" + spMsg);

                                        // Get album art and upload.
                                        console.log("[CN:LOG]Updating album art.");
                                        getAlbumArtBuffer(song, tempArt, function(updArtStatus, updArtMsg) {
                                            if(updArtStatus) {
                                                console.log("[CN:ERR] " + updArtMsg);
                                            } 
                                            else console.log("[CN:LOG]" + updArtMsg);

                                            // Before callback, get updated song.
                                            db.collection('music').findById(song._id, function(songErr, latestSong) {
                                                if(songErr) return callback(codes.status.CN_ERROR, "Error in retrieving updated song.", null);
                                                else return callback(codes.status.OK, "Upload and update success", latestSong);
                                            });
                                        });
                                    });
                                });
                            });
                        }
                    });
                }
            }).on('httpUploadProgress', function(progress) {
                notify.sendMessage(userId, {
                    code : codes.notification.UPLOAD_ONPROGRESS,
                    msg : 'Uploading song..',
                    eventid : eventId,
                    data : {percent: (progress.loaded/progress.total) * 100, url : tempArt}
                });
                console.log('Upload', progress.loaded, 'of' , progress.total, 'bytes');

            });

        } else {
         if(typeof callback !== undefined) {
                callback(codes.status.OK, "Song already exists. Added to library", song);
            }            
        }
    }, name);
   

};

exports.uploadFilesYT = function(path, type, userId, eventId, tags, callback) {
    var remoteFilenameRoot = "song/"
      , fileBuffer = {}
      , remoteFilename = {}
      , metaData = {}
      , fileName = {}
      , textName = {}
      , url = {};

    processSongFileYT(path, type, userId, tags, function(upload, song) {

        if(upload) {
            console.log("[CN:LOG] Uploading a song YT mode");
            fileName = song._id + ".mp3";
            fileBuffer = fs.readFileSync(path);
            remoteFilename = remoteFilenameRoot + fileName;
            textName = fileName + "\n";
            metaData = type;

            // Upload to S3.
            s3.putObject({
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: remoteFilename,
                Body: fileBuffer,
                ContentType: metaData
            }, function (err, obj) {
                if(err) console.log(err);
                else {
                    console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');
                    // Generate signed Cloudfront URL and save in db.
                    url = "https://" + cfDomainName + ".cloudfront.net/" + remoteFilename;
                    createSignedUrl(url, function(err, signedUrl) {
                        if(err) console.log(err);
                        else {
                            console.log("[CN:LOG]Upload converted music successful.");

                            // Also set the expiration.
                            // Get epoch time.
                            var dateExpiration = new Date();
                            dateExpiration.setHours(dateExpiration.getHours() + expireTime);
                            var exprEpochTime = dateExpiration.getTime();

                            db.collection('music').updateById(song._id, {'$set':{link:signedUrl, expiration:exprEpochTime}}, function(updsErr, updsRes) {
                                if(updsErr) console.log("[CN:ERR] " + updsErr);
                                else console.log("[CN:LOG]" + updsRes);

                                // Update space used by user.
                                dbtools.updateMemoryUsed(userId, song.fsize, db, function(spErr, spMsg) {
                                    if(spErr) console.log("[CN:ERR]: " + spMsg);
                                    else console.log("[CN:LOG]" + spMsg);

                                    // Check for new album art.
                                    getAlbumArtUrl(song, function(updArtErr, updArtMsg) {
                                        if(updArtErr) console.log("[CN:ERR]" + updArtMsg);
                                        else console.log("[CN:LOG]" + updArtMsg);

                                        // Before callback, get updated song.
                                        db.collection('music').findById(song._id, function(songErr, latestSong) {
                                            if(songErr) return callback(codes.status.CN_ERROR, "Error in retrieving updated song.", null);
                                            else return callback(codes.status.OK, "Upload and update success", latestSong);
                                        });
                                    });

                                });
                            });

                        }
                    });
                }
            }).on('httpUploadProgress', function(progress) {
                notify.sendMessage(userId, {
                    code : codes.notification.UPLOAD_ONPROGRESS,
                    msg : 'Uploading song..',
                    eventid : eventId,
                    data : {song: song, percent: (progress.loaded/progress.total) * 100, bytesld: progress.loaded, bytestl: progress.total}
                })
                //console.log('Upload', progress.loaded, 'of' , progress.total, 'bytes');
            });

            //req.send();

        } else {
            if(typeof callback !== undefined) {
                callback(codes.status.OK, "Song already exists. Added to library", song);
            } 
        }

        
    });

};

exports.renewSongLinks = function(userId, callback) {
   
    var url = {};
    console.log('inside renew song links');
    db.collection('users').findById(userId, function(err, user) {
        if(err) {
            console.log(err);
            return callback(codes.status.CN_ERROR, err);
        } else {

            for(var i = 0; i < user.songs.length; i += 1) {
                // Get id and make a new link, then set link field to new link.
                (function(i) {
                    // FIXME: ADD FILE TYPE IN DB.
                    url = "https://" + cfDomainName + ".cloudfront.net/song/" + user.songs[i] + ".mp3"; 
                    console.log('Signing url: ' + url);
                    createSignedUrl(url, function(err2, signedUrl) {
                        if(err2) {
                            console.log(err2);
                            //return callback(codes.status.CN_ERROR, err2);
                        } else {
                            var expr = new Date();
                            expr.setHours(expr.getHours() + expireTime);
                            db.collection('music').updateById(user.songs[i], {'$set':{link:signedUrl, expiration:expr.getTime()}}, function(err3, result) {
                                if(err3) {
                                    console.log(err3);
                                    //return callback(codes.status.CN_ERROR, err3);

                                    return callback(codes.status.OK, "Song renewed!");
                                }
                            });
                        }
                    });
                })(i);
            }
        }
    });
};

exports.checkAndRefreshLink = function(songExpiration, songId, callback) {
    // Get expiration and compare.
    var now = new Date();
    if(now.getTime() > songExpiration + 600) {
        // Expired, so renew link for this song.
        var url = "https://" + cfDomainName + ".cloudfront.net/song/" + songId + ".mp3";
        console.log("[CN:LOG]Renewing expired url: " + url );
        createSignedUrl(url, function(signErr, signedUrl) {
            if(signErr) return callback(codes.status.CN_ERROR, signErr);
            else {
                // Calculate new expiration.
                var expr = new Date()
                  , exprTime = {};
                expr.setHours(expr.getHours() + expireTime);
                exprTime = expr.getTime();
                // Get changed info for callback.
                var changedInfo = {
                    link: signedUrl,
                    expiration:exprTime
                };

                // Update song to new link.
                db.collection('music').updateById(songId, {'$set':{link:signedUrl, expiration:exprTime}}, function(updsErr, updsRes) {
                    if(updsErr) return callback(codes.status.DB_ERROR, updsErr, null);
                    else return callback(codes.status.OK, "Song url signed and updated.", changedInfo);
                });
            }
        });
    } else {
        // Return false as the url wasn't updated.
        return callback(codes.status.OK, "Song url is not expired.", null);
    }
}

var processSongFile = function (path, type, tempArt, userId, eventId, callback, name) {

    // Get tags first.
    var parser = mm(fs.createReadStream(path), {duration:true});
    parser.on('metadata', function(tags) {

        var titleFromPath = path;
        var overrideTitle = false;

        try {
            titleFromPath = name ? name : path.substring(path.lastIndexOf('\\') + 1);
            titleFromPath = titleFromPath.substring(0, titleFromPath.lastIndexOf('.'));
        } catch(e){}

        if(!tags.title)  // Normalize
            tags.title = "";
        if(overrideTitle = (tags.title = tags.title.trim()) === "") 
            tags.title = Math.abs(Math.random() * 5000000).toString();

        if(!tags.artist[0]) // Normalize
            tags.artist[0] = "";
        if((tags.artist[0] = tags.artist[0].trim()) === "")
            tags.artist[0] = "Anonymous";

        if(!tags.album)  // Normalize
            tags.album = "";
        if((tags.album = tags.album.trim()) === "")
            tags.album = "Single";

        // Check database if song exists.
        dbtools.checkSongExist(tags.title, tags.artist[0], tags.album, 'original', db, function(bool, songRes) {

            if(overrideTitle){
                tags.title = titleFromPath;
            }

            if(!bool) {

                // Get file size.
                fs.stat(path, function(errSize, stats) {
                    if(errSize) console.log("[ERR-CN]: " + errSize);
                    dbtools.createMusicEntry(userId, tags.title, tags.artist[0], tags.album, tags.duration, stats.size, 'original', tempArt, db, function(err, msg, song) {
                        if(err) console.log(err);
                        else {
                            // Get album art here and update. We simultaneously request album art + upload song to s3.
                            // Add album art buffer to return json to be used later.
                            song.picture = tags.picture;
                            callback(true, song);
                        }
                    });
                });
                

            } else {
                // If already exists, check if song is in user's song list and link.
                // Also add user to song's user list.


                db.collection('users').updateById(userId, {'$addToSet':{songs:toObjectID(songRes._id)}}, function(err1, result1) {
                    if(err1) console.log(err1);
                    else {
                        db.collection('music').updateById(songRes._id, {'$addToSet':{users:toObjectID(userId)}}, function(updErr, updRes) {
                            if(updErr) console.log(updErr);
                            else {
                            	//////////////////
                            	// notify.sendMessage(userId, {
                            	// 	code : codes.notification.ADD_SONG,
                            	// 	msg : "Song added to user library",
                             //        eventid : eventId,
                            	// 	data : songRes
                            	// });
                            	//////////////////
                                // BUG IN ADD TO SET: CANT TELL IF WE ADDED SOMETHING OR NOT.
                                // Update space used by user.
                                dbtools.updateMemoryUsed(userId, songRes.fsize, db, function(status, msg) {
                                    if(status) console.log("[CN:ERR] " + msg);
                                    console.log(result1);
                                    console.log("song exists already");
                                    callback(false, songRes);                                             
                                });
                            }
                        });
                    }
                });
            }           
        });
    });
}

var processSongFileYT = function(path, type, userId, tags, callback) {
    // Check if song exists in db already.
    dbtools.checkSongExist(tags.title, tags.artist, tags.album, 'converted', db, function(exist, oldSong) {
        if(!exist) {
            // Create new music entry and upload.
            // Get file size.
            fs.stat(path, function(errSize, stats) {
                if(errSize) console.log("[CN:ERR] " + errSize);

                // Get real duration via musicmetadata.
                var parser = mm(fs.createReadStream(path) , {duration:true});
                parser.on('metadata', function(parserTags) {
                    // ADD album art once thats tested in original upload.
                    // Replace original duration with parser's duration. More accurate.
                    dbtools.createMusicEntry(userId, tags.title, tags.artist, tags.album, parserTags.duration, stats.size, 'converted', tags.albumart, db, function(createErr, createMsg, newSong) {
                        if(createErr) {
                            console.log("[CN:ERR]" + createErr);
                            // Callback false so we won't upload after an error.
                            return callback(false, newSong);
                        } else {

                            // Add possible new art to return song json.
                            newSong.url = tags.albumart;

                            // Callback true for ok in uploading.
                            return callback(true, newSong);
                        }
                    });
                });


            })
        } else {
            // Link user to existing song.
            dbtools.addSongToUser(userId, oldSong, db, function(linkStatus, linkMsg) {
                if(linkStatus) console.log("[CN:ERR] " + linkMsg);
                else {
                    console.log("[CN:LOG]Song exists already. Linked to user.");
                    // Callback false so we won't upload as it already exists in cdn.
                    return callback(false, oldSong);
                }
            });
        }
    });

}


var imageDirectory = "./temp/images/"
  , BUCKET_NAME_PUBLIC = 'musicplayer';

getAlbumArtBuffer = function(song, tempArt, callback) {

    var remoteFilenameRoot = "assets/images/albums/"
      , fileName = {}
      , fileBuffer = {}
      , remoteFilename = {}
      , metaData = {}
      , url = {}
      , path = {}
      , imgType = {};

    if(song.picture.length === 0) {
        // If no picture buffer provided, use the temp art permanently.

        db.collection('music').updateById(song._id, {'$set':{albumart:tempArt}},function(updArtErr, updArtRes) {
            if(updArtErr) return callback(codes.status.CN_ERROR, "Error in setting album art.");
            else return callback(codes.status.OK, "Album art set using preset arts.");
        });

    } else {
        // Get picture data buffer and save it as image.
        imgType = '.' + song.picture[0].format;
        // imgType = '.jpg';
        fs.writeFileSync('./temp/images' + song._id + imgType, song.picture[0].data);
        fs.writeFile('./temp/images/' + song._id + imgType, song.picture[0].data, function(saveErr) {
            if(saveErr) return callback(codes.status.CN_ERROR, saveErr);
            else {
                // After saving file, upload to S3.
                fileName = song._id + imgType; // <-- appending mp3. possible bug. what if its a different filetype?
                fileBuffer = fs.readFileSync('./temp/images/' + song._id + imgType);
                remoteFilename = remoteFilenameRoot + fileName;
                metaData = 'image/' + song.picture[0].format;
                path = imageDirectory + song._id + imgType;

                // Upload to S3.
                s3.putObject({
                    ACL: 'public-read',
                    Bucket: BUCKET_NAME_PUBLIC,
                    Key: remoteFilename,
                    Body: fileBuffer,
                    ContentType: metaData
                }, function (err, obj) {
                    if(err) return callback(codes.status.CN_ERROR, err);
                    else {
                        console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');
                        // Create url and update db.
                        url = "https://" + cfDomainNamePub + ".cloudfront.net/" + remoteFilename;
                        db.collection('music').updateById(song._id, {'$set':{albumart:url}}, function(updsErr, updsRes) {
                            if(updsErr) return callback(codes.status.CN_ERROR, updsErr);
                            else return callback(codes.status.OK, 'Album art properly updated.');
                        })
                    }
                });
            }
        });
    }
};

getAlbumArtUrl = function(song, callback) {

    // If url is 'DEFAULT', that means we have not obtained any extra album art data.
    if(song.url === 'DEFAULT') {
        return callback(codes.status.CN_ERROR, "No extra album art data found.");

    } else {
        var img = fs.createWriteStream('./temp/images/' + song._id + '.jpg' );
        var req = request(song.url).pipe(img);
        req.on('finish', function() {
            // img.close(cb);

            // After downloading the file, upload to S3.
            var remoteFilenameRoot = "assets/images/albums/"
              , fileName = {}
              , fileBuffer = {}
              , remoteFilename = {}
              , metaData = {}
              , url = {}
              , path = imageDirectory + song._id + '.jpg';;

            fileName = song._id + ".jpg"; // <-- appending jpg. possible bug. what if its a different filetype?
            fileBuffer = fs.readFileSync('./temp/images/' + song._id + '.jpg');
            remoteFilename = remoteFilenameRoot + fileName;
            metaData = 'image/jpg';

            // Upload to S3.
            s3.putObject({
                ACL: 'public-read',
                Bucket: BUCKET_NAME_PUBLIC,
                Key: remoteFilename,
                Body: fileBuffer,
                ContentType: metaData
            }, function (err, obj) {
                if(err) return callback(codes.status.CN_ERROR, err);
                else {
                    console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');
                    // Create url and update db.
                    url = "https://" + cfDomainNamePub + ".cloudfront.net/" + remoteFilename;
                    console.log(url,"[COMBINED URL]");
                    db.collection('music').updateById(song._id, {'$set':{albumart:url}}, function(updsErr, updsRes) {
                        if(updsErr) return img.close(callback(codes.status.CN_ERROR, updsErr));
                        else return img.close(callback(codes.status.OK, 'Album art properly updated.'));
                    })
                }
            });
        })
        // var req = http.get(song.url, function(err, response, body) {
        //     response.pipe(img);
        //     img.on('finish', function() {


        //     });
        // });        
    }

};

getCombinedAlbumArtUrl = function(outputFile, listNum, outputType, callback) {
// After downloading the file, upload to S3.
    var remoteFilenameRoot = "assets/images/albums/"
      , fileName = {}
      , fileBuffer = {}
      , remoteFilename = {}
      , metaData = {}
      , url = {}
      , path = outputFile;

    fileName = listNum + outputType; // <-- appending jpg. possible bug. what if its a different filetype?
    fileBuffer = fs.readFileSync(outputFile);
    remoteFilename = remoteFilenameRoot + fileName;
    metaData = 'image/'+outputType;

    // Upload to S3.
    s3.putObject({
        ACL: 'public-read',
        Bucket: BUCKET_NAME_PUBLIC,
        Key: remoteFilename,
        Body: fileBuffer,
        ContentType: metaData
    }, function (err, obj) {
        if(err) return callback(codes.status.CN_ERROR, err);
        else {
            console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');
            // Create url and update db.
            url = "https://" + cfDomainNamePub + ".cloudfront.net/" + remoteFilename;
            db.collection('playlists').updateById(listNum, {'$set':{playlistart:url}}, function(updsErr, updsRes){
                if(updsErr) return callback(codes.status.CN_ERROR, updsErr);
                else return callback(codes.status.OK, 'Album art properly updated.');
            }) 
        }
    });
}

exports.updatePlaylistArt = function(playlistId, callback) {
    // Get url array from playlist id.
    getUrlFromPlaylist (playlistId, function(status, msg, urlData) {
        console.log(msg);
        if(status) {
            if(msg === 'DEFAULT') {
                // give the queue some default playlist art .
                // or maybe just update the playlist with preset art.
            } else {
                downloadUrls(urlData, function(dlErr, dlMsg, imagePaths) {
                    if(!dlErr) {
                        console.log(dlErr);
                        return callback(codes.status.CN_ERROR, "Error in downloading urls.");
                    }
                    else {
                    	console.log("Image paths: " + imagePaths);
                        console.log("ADDING TO QUEUE");
                        // Once we have image paths, begin converting.
                        var artFile = './art/processed/' + playlistId + '.jpg'
                          , artFileB = './art/processed/' + playlistId + '_b.jpg';
                        tiling.addToQueue(imagePaths, artFile, artFileB, function(procErr, procMsg) {
                            if(procErr) {
                                console.log(procErr);
                                console.log(procMsg);
                                return callback(codes.status.CN_ERROR, procMsg);
                            } else {
                                console.log("UPLOADING NEW ART");
                                // After processing these files, upload to s3.
                                uploadArt('original', artFile, playlistId, function(updStat1, updMsg1) {
                                    if(updStat1) return callback(codes.status.CN_ERROR, "Error in uploading updated album art.");
                                    else {
                                        // Upload next art.
                                        uploadArt('blurred', artFileB, playlistId, function(updStat2, updMsg2) {
                                            if(updStat2) return callback(codes.status.CN_ERROR, "Error in uploading updated album art.");
                                            else {
                                                // Get updated playlist.
                                                db.collection('playlists').findById(playlistId, function(findErr, playlist) {
                                                    if(findErr) return callback(codes.status.CN_ERROR, "Error in finding updated playlist,");
                                                    else if (playlist == null) return callback(codes.status.CN_ERROR, "Invalid playlist id.");
                                                    else return callback(codes.status.OK, "Playlist art updated.", playlist);
                                                });
                                                
                                            }
                                            
                                        });
                                    }
                                });
                            }
                        })
                    }
                });
            }
        } 
    });
}

var uploadArt = function(version, imgPath, playlistId, callback) {
    var remoteFilenameRoot = "assets/art/"
      , fileName = {}
      , fileBuffer = {}
      , remoteFilename = {}
      , metaData = {}
      , url = {}
      , path = imgPath;

    fileName = version === 'original' ? playlistId + '.jpg' : playlistId + '_b.jpg';
    fileBuffer = fs.readFileSync(imgPath);
    remoteFilename = remoteFilenameRoot + fileName;
    metaData = 'image/jpg';

    // Upload to S3.
    s3.putObject({
        ACL: 'public-read',
        Bucket: BUCKET_NAME_PUBLIC,
        Key: remoteFilename,
        Body: fileBuffer,
        ContentType: metaData
    }, function (err, obj) {
        if(err) return callback(codes.status.CN_ERROR, err);
        else {
            console.log('uploaded file[' + path + '] to [' + remoteFilename + '] as [' + metaData + ']');

            url = 'https://s3-us-west-2.amazonaws.com/musicplayer/' + remoteFilename;

            // Create url and update db.
            //url = "https://" + cfDomainNamePub + ".cloudfront.net/" + remoteFilename;
            key = version === 'original' ? 'imageLarge' : 'imageBlurred';
            var update = {}
            update[key] = url;
            db.collection('playlists').updateById(playlistId, {'$set':update}, function(updsErr, updsRes){
                if(updsErr) return callback(codes.status.CN_ERROR, updsErr);
                else return callback(codes.status.OK, 'Playlist art properly updated.');
            });
        }
    });
}

var getUrlFromPlaylist = function(playlistId, callback) {
    // Get playlist entry.
    dbtools.getEntryById('playlists', playlistId, db, function(getErr, playlist) {
        if(getErr) return callback(false, "Error during get playlist.", null);
        else if (playlist == null) return callback(false, "Invalid playlist id.", null);
        else {
            // Get songs first 4 songs in the playlist.
            var numUrls = Math.min(playlist.songs.length, 4)
              , checkedSongs = 0
              , urlData = [];

            var randUrls = getRandomArrayElements(playlist.songs, numUrls);

            // Check if empty. If its empty we use default album arts.
            var tempArt = Math.floor(Math.random() * MAX_DEFAULT_PLAYLIST_ART) + '.jpg';
            var art = "https://" + cfDomainNamePub + ".cloudfront.net/assets/images/default/playlist/def-" + tempArt;

            for(var i = 0; i < numUrls; i += 1) {
                (function(i) {
                    db.collection('music').findById(randUrls[i], function(findErr, song) {
                        if(findErr) console.log("[TILING]Error in finding song.");
                        else if(song == null) {
                            console.log("[TILING]Invalid song id detected in playlist: " + playlistId);
                            checkedSongs += 1;
                        } else {
                            // We do not support jpeg for making playlist art.
                            var s = JSON.stringify(song.albumart);
                            if( !(s.substring(s.lastIndexOf('.') + 1) === 'png"') )  {
                                 urlData.push(song.albumart);                                
                            }
//                            if(s.lastIndexOf('.png')) {
 
                            // }
                            checkedSongs += 1;
                            if(checkedSongs === numUrls) {
                                if(urlData.length === 0) {
                                    urlData.push(art);
                                }
                                console.log("FINISHED GETTING URLS FROM PLAYLIST");
                                return callback(true, "Finished getting data.", urlData);
                            }
                        }  

                    });
                })(i);
            }
            // If there's no songs, we say DEFAULT. Check for this.
            if(numUrls === 0) {
                return callback(true, "DEFAULT", null);
            }
        }
    });
};

// Source stackoverflow
function getRandomArrayElements(arr, count) {
    var shuffled = arr.slice(0), i = arr.length, min = i - count, temp, index;
    while (i-- > min) {
        index = Math.floor((i + 1) * Math.random());
        temp = shuffled[index];
        shuffled[index] = shuffled[i];
        shuffled[i] = temp;
    }
    return shuffled.slice(min);
}

var shortid = require('shortid')
    
var downloadUrls = function(urlArray, callback) {
    // Download each url async. Nested callbacks. 
    var filepaths = [];
    
    getter(urlArray, filepaths, function(msg, result) {
     //   while(result.length != urlArray.length) {
            //just wait till filepaths has been completely written to
     //   }
        return callback(true, "success", filepaths);
    });

    //if failiure
    //return callback(false, "failiure", filepaths);

};

function getter(urlArray, filepaths, callback) {
    //actual code to download
    var numSongs = urlArray.length;
    var randomId = shortid.generate();

    if(numSongs != 0) {
        var url = urlArray.shift();
        var img = fs.createWriteStream('./art/orig/' + randomId + '.jpg' );
        var req = request(url).pipe(img);
        req.on('finish', function() {
            filepaths.push('./art/orig/' + randomId + '.jpg');
            console.log("success in downloading image");
            if(urlArray.length != 0) {
                img.close(getter(urlArray, filepaths, callback));
            } else {
                return img.close(callback("tempimages downloaded", filepaths));                   
            }           
        })

    }

    
}


var createSignedUrl = function(url, callback) {
    loadPrivateKey(function privateKeyCb(err, keyContents) {
        if(err) {
            coonsole.log(err);
            return callback(err, null);
        } else {
            var dateLessThan = new Date();
            dateLessThan.setHours(dateLessThan.getHours() + expireTime);
            var config = {
                privateKey:keyContents,
                keyPairId: keyPairId,
                dateLessThan: dateLessThan
            };
            return callback(null, cf.signUrl(url, config));
        }
    });
}

var loadPrivateKey = function(callback) {
  fs.realpath(privateKeyPath, function (err, resolvedPath) {
    if (err) {
      return callback(err);
    }

    fs.readFile(resolvedPath, function (err, data) {
      if (err) {
        return callback(err);
      }
      callback(null, data);
    });
  });
}

exports.createBucket = function (bucketName) {
    s3.createBucket({
        Bucket: bucketName
    }, function () {
        console.log('created the bucket[' + bucketName + ']')
        console.log(arguments);
    });
};

// -----------------------------------------------------------
// Youtube and conversion services
// -----------------------------------------------------------

var MAX_VIDEO_DURATION = 900;

exports.videoToMp3 = function(link, userId, eventId, callback) {
    var stream = {}
      , proc = {}
      , filename = {}
      , directory = "./public/converted/";
    //Check if url is valid first.
    try{
        ytdl.getInfo(link, function(err, info) {
            if(err) {
                return;
            } else {
                var songLength = info.length_seconds
                  , h = {}
                  , m = {}
                  , s = {}
                  , prog = {};

                if(songLength > MAX_VIDEO_DURATION) {
                    return callback(codes.status.CN_ERROR, "Video too long", null);
                }
                console.log("Valid url!");
                // Prepare file name by hashing link.
                filename = toolkit.hash(link)
                // Get stream and pipe to convert to mp3.
                stream = ytdl(link);
                proc = new ffmpeg({source:stream})
                .withAudioCodec('libmp3lame')
                .withAudioBitrate('192k')
                .toFormat('mp3')
 /*               .on('progress', function(progress) {
                    prog = progress.timemark;
                    h = parseInt(prog.substring(0,2)) * 3600;
                    m = parseInt(prog.substring(3,5)) * 60;
                    s = parseInt(prog.substring(6,8));
                    prog = Math.floor(((h + m + s)/songLength) * 100);
                    notify.sendMessage(userId, {
                        code : codes.notification.CONVERT_ONPROGRESS,
                        msg : "Retrieving audio",
                        eventid : eventId,
                        data : {videoTitle: info.title, percent: prog, albumart : "//mus.ec/assets/images/handset.png"}
                    });
                    console.log('[CONVERT:LOG]Processing ' + prog + ' % done');
                })*/
                .on('error', function(err) {
                    console.log('An error occured: ' + err.message);
                    callback(codes.status.CN_ERROR, "Error occured during conversion: " + err, null);
                })
                .on('end', function() {
                    console.log('[CN:LOG]Finished processing ' + filename + '.mp3');
                    var returnJson = {
                        path: directory + filename + '.mp3',
                        vtitle: info.title,
                        file: filename + '.mp3',
                        url: 'http://mus.ec/converted/' + filename + '.mp3' 
                    }
                    callback(codes.status.OK, "Finished video to mp3 conversion.", returnJson);
                })
                .saveToFile('./public/converted/' + filename + '.mp3');
            }
        });
    } catch(e) {
        console.log(e);
        return callback(codes.status.CN_ERROR, "Error in getInfo: " + e);
    }
};

exports.validateUrl = function(link, callback) {
    try {
        ytdl.getInfo(link, function(err, info) {
            if(err) {
                console.log(err);
                return callback(codes.status.CN_ERROR, "Error in validation.");
            } else {
                console.log(info);
                return callback(codes.status.OK, "Valid url.");
            }
        })
    } catch(e) {
        console.log(e);
        return callback(codes.status.CN_ERROR, "Invalid url.");
    }
};







