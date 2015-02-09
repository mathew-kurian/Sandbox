
var codes = require('./codes')
  , mongo = require('mongoskin')
  , cntools = require('./connect')
  , ObjectID = mongo.ObjectID
  , toObjectID = mongo.helper.toObjectID
  , crypto = require('crypto')
  , notify = require('./notify');

//var defaultAlbumArt = "https:/dbjjkzvgg4mja.cloudfront.net/assets/images/albums/default-art.png";


// -----------------------------------------------------------
// User
// -----------------------------------------------------------
exports.addUserAsync = function(user, pass, firstName,lastName, db, callback) {
    //var collection = db.get('users');

    db.collection('users').insert({ 
        email : user, 
        password : pass,
        fname: firstName,
        lname: lastName,
        spaceused: 0, // will be in bytes
        songs: [],
        playlists : [] 
    }, function(err, result){
        // you can actually extract the error and send only that.
        if(typeof callback !== "undefined") {
            var status = err ? codes.status.DB_ERROR : codes.status.OK
              , msg = err ? "User already exists!" : "Successfully created new user.";

            callback(status, msg);
        }    
    });
};

exports.createRegister = function(user, pass, firstName, lastName, db, callback) {

    // First check if the user exists already.
    db.collection('users').findOne({email:user}, function(findErr, existingUser) {
        console.log(user);
        console.log(existingUser);
        if(findErr) return callback(codes.status.DB_ERROR, findErr, null);
        else if (existingUser != null) return callback(codes.status.DB_ERROR, "User exists already!", null);
        else {
            // Delete any registration requests for the user by email.
            db.collection('registers').remove({email:user}, function(remErr, remRes) {
                if(remErr) {
                    console.log(remErr);
                    return callback(codes.status.DB_ERROR, remErr);
                } else {
                    // Create token for registering.
                    crypto.randomBytes(48, function(ex, buf) {
                        db.collection('registers').insert({
                            createdAt : new Date(),
                            email : user,
                            password : pass,
                            fname : firstName,
                            lname : lastName,
                            token : buf.toString('hex')
                        }, function(insErr, newRegister) {
                            if(insErr) return callback(codes.status.DB_ERROR, "Error in register insert", null);
                            else return callback(codes.status.OK, "Register will expire in 10 minutes", newRegister[0]);
                        });

                    });            
                }
            });           
        }
    });



}

exports.createReset = function(userId, db, callback) {

    // Delete any existing reset requests for the user.
    db.collection('resets').remove({user:toObjectID(userId)}, function(remErr, remRes) {
        if(remErr) {
            console.log(remErr);
            return callback(codes.status.OK, remErr);
        } else {
            // Create new reset request with token.
            crypto.randomBytes(48, function(ex, buf) {
                db.collection('resets').insert({
                    user : toObjectID(userId),
                    token : buf.toString('hex')
                }, function(insErr, newReset) {
                    if(insErr) return callback(codes.status.DB_ERROR, "Error in reset insert", null);
                    else return callback(codes.status.OK, "Stored a password reset request", newReset[0]);
                })
            });
        }
    });
}

exports.changePassword = function(userId, newPass, db, callback) {
    db.collection('users').updateById(userId, {'$set':{password:newPass}}, function(updErr, updRes) {
        if(updErr) {
            console.log(updErr);
            return callback(codes.status.DB_ERROR, "Error in updating password.");
        } else {
            console.log("[USERMANAGEMENT]User " + userId + " changed pw successfully.");
            return callback(codes.status.OK, "Password changed successfully.");
        }
    });
}

// exports.checkLogin = function(user, pass, db, callback) {
//     // Check first is the user is on already.
//     exports.getEntry('users', 'email', user, db, function(err, result1) {
//         if(err) {
//             callback(codes.status.DB_ERROR, "Cannot find valid email/password combination.", null);
//         } else {
//             exports.isUserOn(result1._id, db, function(status, msg, bool) {
//                 if(bool) {
//                     // If user is found and already logged in, return error.
//                     callback(codes.status.DB_ERROR, "User already logged in", null);
//                 } else {
//                     db.collection('users').findOne({email:user}, function(err, result){
//                         if(typeof callback !== "undefined") {
//                             // Prepare status message.
//                             var status = err ? codes.status.DB_ERROR: codes.status.OK
//                               , msg = {}
//                               , name = {};

//                             // Compare password hashes if an entry is found.
//                             if(result != null) {
//                                 if(pass == result.password) {
//                                     msg = "Login success!";
//                                     name.email = result.email;
//                                     name.lname = result.lname;
//                                     name.fname = result.fname;
//                                     name.user_id = result._id;
//                                     // set status field inside the user.
//                                     db.collection('users').updateById(result._id, {'$set':{status:'on'}}, function(err, result2) {
//                                         status = err ? codes.status.DB_ERROR:codes.status.OK;
//                                         msg = err ? "Setting to logged in error" : "Status set to on."
//                                         return callback(status, msg, name);
//                                     });
//                                 } else {
//                                     msg = "Cannot find valid email/password combination.";
//                                     name = null;
//                                     callback(status, msg, name);
//                                 }
//                             } else {
//                                     msg = "Cannot find valid email/password combination.";
//                                     name = null;
//                                     callback(status, msg, name);
//                             }
//                         }
//                     });
//                 }
//             });
//         }

//     });
    
// };

exports.checkLogin = function(user, pass, db, callback) {
    db.collection('users').findOne({email:user}, function(err, result){
        if(typeof callback !== "undefined") {
            // Prepare status message.
            var msg = {}
              , name = {};
            // Compare password hashes if an entry is found.
            if(result != null) {
                if(pass == result.password) {
                    msg = "Login success!";
                    name.email = result.email;
                    name.lname = result.lname;
                    name.fname = result.fname;
                    name.user_id = result._id;
                    callback(codes.status.OK, msg, name);
                } else {
                    msg = "Cannot find valid email/password combination.";
                    name = null;
                    //TOREMOVE ON FINAL.
                    callback(codes.status.DB_ERROR, msg, result.password);
                    //callback(codes.status.DB_ERROR, msg, name);
                }
            } else {
                    msg = "Cannot find valid email/password combination.";
                    name = null;
                    callback(codes.status.DB_ERROR, msg, name);
            }
        }
    });
}

exports.isUserOn = function(userID, db, callback) {
    db.collection('users').findById(userID, function(err, result) {
        var status = err ? codes.status.DB_ERROR:codes.status.OK
          , msg = err ? "Cannot find user" : "";
        if(result != null) {
            if(result.status === "on") {
                callback(status, "User logged in.", true);
            }
        }
        callback(status, "User not logged in.", false);
    }) ;
};

exports.getUserInfo = function(userID, db, callback) {
    db.collection('users').findById(userID, function(err, user) {
        if(err) {
            callback(codes.status.DB_ERROR, "Invalid user id.", null);
        } else {
            // First delete the password entry
            delete user.password;
            // Extract all info
            //console.log("inside get user info.");
            //console.log("Song length: " + user.songs.length);
            //console.log("Playlist length: " + user.playlists.length);
            var checkedSongs = 0
              , checkedPlaylists = 0
              , amountSongs = user.songs.length
              , amountPlaylists = user.playlists.length
              , userObj = JSON.parse(JSON.stringify(user));
            for(var i = 0; i < amountSongs; i += 1) {
                // Create an anonymous function which passes in the object
                // as a variable. This techqniue should be used sparingly
                // I feel that this solve your problem though.
                (function(i) {
                    db.collection('music').findById(userObj.songs[i], function(err2, song) {
                        if(err2) {
                            console.log(err2);
                            userObj.songs[i] = null;
                        } else {
                            userObj.songs[i] = song;
                        } 

                        // Always do callbacks using a fire method
                        // Look at elixir/toolkit.fire and elixir/toolkit.invoke
                        // These are context based invokers
                        // Callbacks can be null.
                        checkedSongs += 1
                        if(checkedSongs === amountSongs && checkedPlaylists === amountPlaylists) {
                            //console.log(userObj);
                            return callback(codes.status.OK, "Finished getting data.", userObj);
                        }               
                        //console.log("Not yet finished processing data.");
                    });
                })(i);
            }
            for(var i = 0; i < amountPlaylists; i += 1) {
                (function(i) {
                    db.collection('playlists').findById(user.playlists[i], function(err3, playlist) {
                        if(err3) {
                            console.log(err3);
                            userObj.playlists[i] = null;
                        } else {
                            userObj.playlists[i] = playlist;
                        }
                        checkedPlaylists += 1;
                        if(checkedSongs === amountSongs && checkedPlaylists === amountPlaylists) {
                            // console.log(userObj);
                            return callback(codes.status.OK, "Finished getting data.", userObj);
                        }
                        //console.log("Not yet finished processing data.");
                    });
                })(i);
                
            }
            if(amountSongs === 0 & amountPlaylists === 0) {
                return callback(codes.status.OK, "User has no uploaded data.", userObj);               
            }  
        }
    });
};


exports.getAllSongs = function(userId, db, callback) {
    // Get user first.
    db.collection('users').findById(userId, function(userErr, user) {
        if(typeof callback !== undefined) {
            if(userErr) return callback(codes.status.DB_ERROR, "Error inside user search.", null);
            else if(user == null) return callback(codes.status.DB_ERROR, "Invalid user id.", null);
            else {
                var songData = {}
                  , checkedSongs = 0;
                // Get each song and make a hashmap out of it.
                for(var i = 0; i < user.songs.length; i += 1) {
                    (function(i) {
                        //console.log(user.songs[i]);
                        db.collection('music').findById(user.songs[i], function(songErr, song) {
                            if(songErr) console.log("Error inside song search.");
                            else if(song == null) console.log("Invalid song id detected on user: " + userId);
                            else {
                                songData[user.songs[i]] = song;
                                checkedSongs += 1;
                                if(checkedSongs === user.songs.length) {
                                    if(typeof callback !== undefined) {
                                        return callback(codes.status.OK, "Finished getting song data.", songData);
                                    } else {
                                        return;
                                    }
                                }
                            }
                        });
                    })(i);
                }
                if(user.songs.length === 0) {
                    return callback(codes.status.OK, "User has no uploaded song data.", songData);
                }
            }
        }
    }); 
}

exports.getAllPlaylists = function(userId, db, callback) {
    // Get user first.
    db.collection('users').findById(userId, function(userErr, user) {
        if(typeof callback !== undefined) {
            if(userErr) return callback(codes.status.DB_ERROR, "Error inside user search.", null);
            else if(user == null) return callback(codes.status.DB_ERROR, "Invalid user id.", null);
            else {
                var playlistData = {}
                  , checkedPlaylists = 0
                  , z = 0;
                // Get each playlist and make a hashmap out of it.
                for(var i = 0; i < user.playlists.length; i += 1) {
                    (function(i) {

                        db.collection('playlists').findById(user.playlists[i], function(playErr, playlist) {
                            if(playErr) console.log("Error inside playlist search.");
                            else if (playlist == null) {
                                console.log("Invalid playlist id detected on user: " + userId);
                                checkedPlaylists += 1;
                            }
                            else {
                                playlistData[user.playlists[i]] = playlist;
                                checkedPlaylists += 1;
                                if(checkedPlaylists === user.playlists.length) {
                                    if(typeof callback !== undefined) {
                                        return callback(codes.status.OK, "Finished getting playlist data.", playlistData);
                                    } else {
                                        return;
                                    }
                                }
                            }
                        });
                    })(i);
                }
                if(user.playlists.length === 0) {
                    return callback(codes.status.OK, "User has no playlists.", playlistData);
                }
            }
        }
    });
};

exports.updateMemoryUsed = function(userId, addSpace, db, callback) {
    db.collection('users').findById(userId, function(userErr, userRes) {
        if(typeof callback !== undefined) {
            if(userErr) return callback(codes.status.DB_ERROR, "Error in user search.");
            else if (userRes == null) return callback(codes.status.DB_ERROR, "Invalid user id.");
            else {
                var updatedUsedSpace = userRes.spaceused + addSpace;
                db.collection('users').updateById(userId, {'$set':{spaceused:updatedUsedSpace}}, function(updErr, updRes) {
                    if(updErr) return callback(codes.status.DB_ERROR, "Error during space used update.");
                    else return callback(codes.status.OK, "Updated used space for user.");
                });
            }
        }
    });
}

// -----------------------------------------------------------
// Playlist
// -----------------------------------------------------------

exports.addPlaylistLock = function(playlistId, db, callback) {
    db.collection('plocks').insert({
        playlist : playlistId        
    }, function(insErr, pLock) {
        if(insErr) return callback(codes.status.DB_ERROR, "Error in inserting playlist lock.", null);
        else return callback(codes.status.OK, "Playlist locked", pLock[0]);
    });
}

exports.removePlaylistLock = function(playlistLock, db, callback) {
    db.collection('plocks').remove(playlistLock, function(remErr, remRes) {
        console.log(playlistLock);
        console.log(remErr);
        console.log(remRes);
        if(remErr) return callback(codes.status.DB_ERROR, "Error in removing playlist lock.");
        else if (remErr == 0) return callback(codes.status.DB_ERROR, "Playlist lock not found.");
        else return callback(codes.status.OK, "Playist lock removed.");
    });
}

exports.isLocked = function(playlistId, db, callback) {
    db.collection('plocks').findOne({playlist: toObjectID(playlistId)}, function(findErr, findRes) {
        console.log(findErr);
        console.log(findRes);
        if(findErr) return callback(codes.status.DB_ERROR, "Error in finding lock.", null);
        else if (findRes == null) return callback(codes.status.OK, "Playlist is not locked.", false);
        else return callback(codes.status.OK, "Playlist is locked.", true);
    });
}

exports.getPlaylistByName = function(playlistName, userId, db, callback) {
    // Validate if userId is correct. If not return an error.
    db.collection('users').findById(userId, function(findUserErr, user) {
        if(typeof callback !== undefined) {
            if(findUserErr) return callback(codes.status.DB_ERROR, findUserErr, null);
            else {
                if(user == null) return callback(codes.status.DB_ERROR, "Invalid user id", user);
                else {
                    db.collection('playlists').findOne({
                        name: playlistName,
                        user: toObjectID(userId)
                    }, function(findPlaylistErr, playlist) {
                        console.log(playlist);
                        if(typeof callback !== undefined) {
                            if(findPlaylistErr) return callback(codes.status.DB_ERROR, findPlaylistErr, null);
                            else if (playlist == null) return callback(codes.status.DB_ERROR, "Playlist doesn't exist", playlist);
                            else return callback(codes.status.OK, "Found playlist", playlist);
                        }
                    });
                }
            }            
        }

    });
}

exports.addToPlaylist = function(userId, playlistName, songId, db, callback) {
    // Validate if song is valid first.
    db.collection('music').findById(songId, function(songErr, songResult) {
        if(songErr) return callback(codes.status.DB_ERROR, "Error in db songid search.");
        else if(songResult == null) return callback(codes.status.DB_ERROR, "Invalid song id!");
        else {
            // Do a find for userId and name combined.
            db.collection('playlists').findOne({name:playlistName, user:toObjectID(userId)}, function(err, playlist) {
                if (err) return callback(codes.status.DB_ERROR, "Error inside addToPlaylist");
                if(playlist == null) {
                    // Create new playlist using this name.
                    db.collection('playlists').insert({
                        name:playlistname, 
                        user:toObjectID(userId), 
                        songs:[]
                    }, function(insertErr, addedPlaylist) {
                        // Now do the song add.
                        db.collection('playlists').updateById(playlist._id, {'$push':{songs:songId}}, function(songAddErr, songAddRes) {
                            if(songAddErr) return callback(codes.status.DB_ERROR, "Error: add song to playlist.")
                            else return callback(codes.status.OK, "Song successfully added to playlist.");
                        });
                    });
                } else {
                    // Do the song add.
                    db.collection('playlists').updateById(playlist._id, {'$push':{songs:songId}}, function(songAddErr, songAddRes) {
                            if(songAddErr) return callback(codes.status.DB_ERROR, "Error: add song to playlist.")
                            else return callback(codes.status.OK, "Song successfully added to playlist.");
                    });
                }
            });
        }
    });  
};

// Get playlist(s) struct by user id.
exports.getPlaylistsByUser = function(userID, db, callback) {
    db.collection('playlists').find({user:toObjectID(userID)}, function(err, result) {
        if(result !== null) {
            result.each(function(err, playlists) {
                console.log(playlists);
            });
        }
    });
};

// Link an existing playlist to a select user.
exports.addPlaylistToUser = function(userID, playlistID, db, callback) {
    // Check if valid playlist id first.
    exports.isValidID(playlistID, "playlists", db, function(bool) {
        if(!bool) {
            return callback(codes.status.DB_ERROR, "Invalid playlist id.");
        } else {
            db.collection('users').update( 
                {_id:toObjectID(userID)}, {'$addToSet':{playlists:toObjectID(playlistID)}}, function(err, result) {
                    if(typeof callback !== "undefined") {
                        // Prepare status message.
                        var status = result == 0 ? codes.status.DB_ERROR: codes.status.OK
                          , msg = result == 0 ? "Invalid user id.": "Added playlist successfully.";
                        return callback(status, msg);
                    }
            });
        }
    });

};

// Add songs to a playlist.
exports.addSongToPlaylist = function(songId, playlistId, db, callback) {

    db.collection('playlists').findOne({
        _id : toObjectID(playlistId),
        songs : toObjectID(songId)
    }, function(findErr, playlist) {
        if(findErr) return callback(codes.status.DB_ERROR, findErr);
        else if (playlist !== null) return callback(codes.status.DB_ERROR, "Song exists inside playlist already");
        else {
            db.collection('playlists').updateById(playlistId, {'$addToSet': {songs:toObjectID(songId)}}, function(updErr, updRes) {
                if(updErr) return callback(codes.status.DB_ERROR, updErr);
                else return callback(codes.status.OK, "Song added to playlist");
            });
        }
    })

};
// Create a playlist for a user given array of music ObjectIDs.
exports.createEmptyPlaylist = function(userID, playlistName, art, artB, db, callback) {
    // Check if userID is valid first.
    exports.isValidID(userID, "users", db, function(bool) {
        if(!bool){
            return callback(codes.status.DB_ERROR, "Invalid user id", null);
        } else {
            // If user is valid, create the playlist.
            db.collection('playlists').insert({
                name: playlistName,
                songs: [],
                user: toObjectID(userID),
                imageLarge : art,
                imageBlurred : artB
            }, function(err, result) {
                    if(typeof callback !=="undefined") {
                        // Prepare status message.
                        var status = err ? codes.status.DB_ERROR: codes.status.OK
                          , msg = err ? "Playlist already exists.": "Empty playlist created for user.";

                        if(!err) {
                            // After we created the playlist, make sure to link the user to this playlist.
                            exports.addPlaylistToUser(userID, result[0]._id, db, function(status, msg) {
                                if(status) {
                                    console.log("[DB:ERR] " + msg);
                                }
                            });
                        }
                        callback(status, msg, result);
                    }

            });
        }
    });
};

// Rename a playlist.
exports.renamePlaylist = function(playlistId, newName, db, callback) {
    db.collection('playlists').updateById(playlistId, {'$set':{name:newName}}, function(edtErr, edtRes) {
        console.log(edtErr);
        console.log(edtRes);
        if(edtErr) return callback(codes.status.DB_ERROR, "Error in editing playlist name.");
        else if (edtRes === 0) return callback(codes.status.DB_ERROR, "Playlist name already exists."); 
        else return callback(codes.status.OK, "Updated playlist");
    });
}

// Remove playlist from the db.
exports.removePlaylist = function(playlistId, eventId, db, callback) {
    // Remove it from the user first.
    exports.getEntryById("playlists", playlistId, db, function(err, result) {
        if(result === null || err) {
            callback(codes.status.DB_ERROR, "Invalid playlist id");
        } else {
            // First get playlist to fire delete songs on its members.
            db.collection('playlists').findById(playlistId, function(findErr, playlist) {
                if(findErr) return callback(codes.status.DB_ERROR, "Error in find playlist.");
                else {
                    var checkedSongs = 0;
                    for(var i = 0; i < playlist.songs.length; i += 1) {
                        (function(i) {
                            db.collection('music').findById(playlist.songs[i], function(songErr, song) {
                                checkedSongs += 1;
                                if(songErr) console.log("[DB:ERR]" + songErr);
                                else if (song === null) console.log("[DB:ERR]Found invalid song id in playlist.");
                                else {
                                    
                                    // MK ADD
                                    song.playlist = playlist;

                                    notify.sendMessage(playlist.user, {
                                        code : codes.notification.DELETE_SONG,
                                        msg : "Song inside playlist deleted",
                                        eventid : eventId,
                                        data : song
                                    });
                                }
                                if(checkedSongs === playlist.songs.length) {
                                    // We have checked all songs.. so move on.
                                    // Update by popping the playlist id from user.
                                    db.collection('users').update(
                                        {_id:toObjectID(result.user)}, {'$pull':{playlists:toObjectID(playlistId)}}, 
                                        function(err, result) {
                                            if(err) callback(codes.status.DB_ERROR, "Invalid user id");
                                            // Since we know that playlist id is valid, we always remove it.
                                            db.collection('playlists').remove({_id:toObjectID(playlistId)}, function(err, result) {
                                                var status = err ? codes.status.DB_ERROR: codes.status.OK
                                                  , msg = err ? "Error occured in playlist deletion." : "Playlist deleted.";
                                                  callback(status, msg);
                                            });

                                    });
                                }
                            });
                        })(i);   
                    }
                    if(playlist.songs.length === 0) {
                        db.collection('users').update(
                            {_id:toObjectID(result.user)}, {'$pull':{playlists:toObjectID(playlistId)}}, 
                            function(err, result) {
                                if(err) callback(codes.status.DB_ERROR, "Invalid user id");
                                // Since we know that playlist id is valid, we always remove it.
                                db.collection('playlists').remove({_id:toObjectID(playlistId)}, function(err, result) {
                                    var status = err ? codes.status.DB_ERROR: codes.status.OK
                                      , msg = err ? "Error occured in playlist deletion." : "Playlist deleted.";
                                      callback(status, msg);
                                });

                        });
                    }
                 
                }

            });

        }
    });
}


exports.removeSongFromPlaylist = function(songId, playlistId, db, callback) {
    db.collection('playlists').updateById(playlistId, {'$pull':{songs:toObjectID(songId)}}, function(remErr, remRes) {
        if(remErr) return callback(codes.status.DB_ERROR, remErr);
        else return callback(codes.status.OK, "Song removed.");
    });
}


// -----------------------------------------------------------
// Music
// -----------------------------------------------------------

// Get song struct by song id
exports.getSong = function(songID, db, callback) {
    // db.collection('music').findOne({_id:toObjectID(songID)}, function(err, result) {
    //     console.log(result);
    // });

    db.collection('music').findById(songID, function(err, result) {
        // Prepare status message.
        var status = err ? codes.status.DB_ERROR: codes.status.OK
          , msg = err ? "Invalid music id!":"Music struct found!";

        callback(status, msg, result);
    });
};

exports.addSongToUser = function(userId, song, db, callback) {
    // Add song to user's list.
    db.collection('users').updateById(userId, {'$addToSet':{songs:toObjectID(song._id)}}, function(updErr, updRes) {
        if(updErr) return callback(codes.status.DB_ERROR, updErr);
        else {
            // Add user to song's list.
            db.collection('music').updateById(song._id, {'$addToSet':{users:toObjectID(userId)}}, function(mscErr, mscRes) {
                if(mscErr) return callback(codes.status.DB_ERROR, msgErr);
                else {
                    // Update space used by user.
                    exports.updateMemoryUsed(userId, song.fsize, db, function(status, msg) {
                        if(status) return callback(status, msg);
                        else return callback(codes.status.OK, msg);
                    });
                }
            });
        }
    });
};

// Create a music entry after an upload.
exports.createMusicEntry = function(userID, title, artistName, albumName, songLength, fileSize, songVersion, art, db, callback) {
    // Check if valid userID first.
    exports.isValidID(userID, "users", db, function(bool) {
        if(!bool) {
            callback(codes.status.DB_ERROR, "Invalid user id.");
        } else {
            // If user is valid, create music entry.

            // First calculate proper duration.
            var ms = songLength * 1000
              , min = Math.floor(songLength/60)
              , secs = songLength - min * 60
              , time = {};

            // Add a preceding 0 if seconds is a single digit.
            if(secs.toString().length === 1) {
            time = min.toString() + ":0" + secs.toString();
            } else {
            time = min.toString() + ":" + secs.toString();
            }

            // Do music insert.
            db.collection('music').insert({
                song:title,
                artist:artistName,
                album:albumName,
                version:songVersion,
                length:time, 
                lengthms:ms,
                users:[toObjectID(userID)],
                fsize: fileSize,
                expiration: "",
                link: "",
                albumart: art
            }, function(err, result) {

                    if(!err) {
                        // Link song and user.
                        db.collection('users').updateById(userID, {'$addToSet':{songs:result[0]._id}}, function(err2, result2) {
                            if(err2) {
                                console.log(err2);
                                callback(codes.status.DB_ERROR, "Song already linked to user.", result);
                            } else {
                                // Also update memory used by user.
                                return callback(codes.status.OK, "Successfully created new and linked to user.", result[0]);
                            }
                        });
                    } else {
                        callback(codes.status.DB_ERROR, "Music entry already exists!", result);
                    }

                    // // Prepare status message.
                    // var status = err ? codes.status.DB_ERROR: codes.status.OK
                    //   , msg = err ? "Music entry already exists!":"Successfully created new song";
                    // if(!err) result = result[0];
                    // callback(status, msg, result);
            });
        }
    });

};

// Remove song from user's library.
exports.deleteSong = function(songId, userId, db, callback) {
     // Update by user id.
     db.collection('users').updateById(userId, {'$pull':{songs:toObjectID(songId)}}, function(updErr, updRes) {
        if(updErr) return callback(codes.status.DB_ERROR, "Error in pulling song from user.");
        else {
            // Get playlists for each user.
            db.collection('users').findById(userId, function(fndErr, user) {
                // No error checking since we know this user exists.
                var checkedPlaylists = 0;
                for(var i = 0; i < user.playlists.length; i += 1) {
                    (function(i) {
                        // Force pull song from each playlist
                        db.collection('playlists').updateById(user.playlists[i], {'$pull':{songs:toObjectID(songId)}}, function(updPErr, updPRes) {
                            if(updPErr) console.log("[DB:ERR]" + updPErr);
                            // After pulling the song, we update album art.
                            checkedPlaylists += 1;
                            if(checkedPlaylists === user.playlists.length) {
                                return callback(codes.status.DB_ERROR, "Song deleted. Updated playlists.", user);
                            }
                        });

                    })(i);
                };
                if(user.playlists.length === 0) {
                    return callback(codes.status.OK, "Song deleted. User has no playlists.");
                }
            });

        }
     });
};

exports.removeSongFromUser = function(songId, userId, db, callback) {
    // Update user id.
    db.collection('users').updateById(userId, {'$pull' : {songs:toObjectID(songId)}}, function(updErr, updRes) {
        if(updErr) return callback(codes.status.DB_ERROR, "Error in pulling song from user.");
        else {
            // Return updated user.
            db.collection('users').findById(userId, function(fndErr, user) {
                if(fndErr) return callback(codes.status.DB_ERROR, "Error in finding user.");
                else return callback(codes.status.OK, "User entry updated.", user);
            });
        }
    });
}

// Checks if a song exists via song info.
exports.checkSongExist = function(title, artistName, albumName, songVersion, db, callback) {

    var songEntry = {
        song:title,
        artist:artistName,
        album:albumName,
        version:songVersion
    };
    
    db.collection('music').findOne(songEntry, function(err, result) {
        if(result != null) {
            callback(true, result);
        } else {
            callback(false, result);
        }
    })
}

// -----------------------------------------------------------
// Misc
// -----------------------------------------------------------
exports.textSearchSong = function(query, userId, db, callback) {
    console.log("Searching for: " + query + ".");
    db.collection('music').find({
        users:toObjectID(userId),
        '$text':{'$search':query}
    }, function(searchErr, searchRes) {
        if(typeof callback !== undefined) {
            if(searchErr) return callback(codes.status.DB_ERROR, "Error during search.", null);
            else if (searchRes == null || searchRes.length == 0) return callback(codes.status.OK, "No results found.", null);
            else {
                // Create the actual music entry with title, song, album.
                return callback(codes.status.OK, "Found results.", searchRes);
            }           
        }
    });
}

exports.textSearchPlaylist = function(query, userId, db, callback) {
    db.collection('playlists').find({
        user:toObjectID(userId),
        '$text':{'$search':query}
    }, function(searchErr, searchRes) {
        if(typeof callback !== undefined) {
            if(searchErr) return callback(codes.status.DB_ERROR, "Error during search.", null);
            else if(searchRes == null) return callback(codes.status.OK, "No results found.", null);
            else {
                // Create the actual playlist entry with name.
                return callback(codes.status.OK, "Found results.", searchRes);
            }            
        }
    });
}

exports.getEntriesById = function(object, objectIds, sanitize, db, callback) {
    var objectData = {}
      , objectsChecked = 0;
    for(var i = 0; i < objectIds.length; i += 1) {
        (function(i) {
            db.collection(object).findById(objectIds[i], function(err, objRes) {
                if(err) console.log("Error in " + object + " search.");
                else if (objRes == null) console.log("Invalid " + object + " id.");
                else {
                    //console.log('Requesting ' + object + ' sanitize: ' + sanitize);
                    if(object === 'music' && sanitize === 'true') {
                        // Special case: check if song link is expired.
                        console.log("[DB:LOG]Doing a check on expiration..");
                        cntools.checkAndRefreshLink(objRes.expiration, objRes._id, function(status, msg, newInfo) {
                            if(status) console.log("[DB:ERR]" + msg);
                            else {
                                if(newInfo) {
                                    // If song is refreshed, get updated info.
                                    objRes.link = newInfo.link;
                                    objRes.expiration = newInfo.expiration;
                                } 
                                objectData[objectIds[i]] = objRes;
                                objectsChecked += 1;
                           
                                if(objectsChecked === objectIds.length) {
                                    console.log("Request processed.");
                                    return callback(codes.status.OK, "Finished processing " + object + " request.", objectData);
                                }                                
                            }
                        });
                    } else {
                        objectData[objectIds[i]] = objRes;
                        objectsChecked += 1;
                        if(objectsChecked === objectIds.length) {
                            //console.log(objectData);
                            return callback(codes.status.OK, "Finished processing " + object + " request.", objectData);
                        }
                    }
                }
            });
        })(i);
    }
    if(objectIds.length === 0) {
        return callback(codes.status.DB_ERROR, "Empty request error.", null);
    }
}

exports.getEntryById = function(object, objectID, db, callback) {
    db.collection(object).findById(objectID, function(err, result) {
        callback(err, result);
    });
}
exports.getEntry = function(object, key, name, db, callback) {
    var keyS = key.toString()
      , nameS = name.toString();

    var obj = {};
    obj[key] = name;
    db.collection(object).findOne(obj, function(err, result) {
        callback(err, result);
    });
}

exports.isValidID = function(objectID, object, db, callback) {
    return db.collection(object).findById(objectID, function(err, result) {
        if(result != null) {
            callback(true);
        } else {
            callback(false);
        }
    });

}

var getObjectIDJson = function(object, json, db, callback) {
    db.collection(object).findOne(json, function(err, result) {
        console.log(result);
    });
}

// -----------------------------------------------------------
// Tests
// -----------------------------------------------------------
exports.test2 = function(db) {
    console.log("inside dbtools");

    getObjectID("playlists", "name", "Workout", db, function(err, result) {
        console.log(result);
    });
    //getObjectID("music", "artist", "Paramore", db);
};

exports.test1 = function() {
    // SET DATABASE playlist
    // function getCollection(collection)
    // d = getCollection("collection");
    var d = db.collection('playlist');
    // CONTAINS id `53255678df0a407c64aa8f60`
    // function contains(key, value);
    /// result = contains('_id', '53255678df0a407c64aa8f60');
    // if id, always findOne
    var i = _id;
    var id = '53255678df0a407c64aa8f60';
    var res;
    var d = d.findOne({i: id}, function(err, result) {
        if(err) throw err;
        res = result;
    })
    // SELECT 'songs'
    var i1 = songs;
    var d1 = result.i1;
    // FOR EACH -> toArray (maybe check for arrays)
    for(var i = 0; i < d1.length; i++) {
        d = db.collection('song');
    }

}