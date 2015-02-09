
// Constants.Require

var user = {};

asyncTest( "system.mui.connection.createUser", function() {

	codes = require('codes');   

    var isCorrect = false;	
    var message = "";

    require('connection').createUser("benriquez12@ymail.com", "5311f112", 'a', 'b', function(code, msg) {
		if(code === codes.behavior.DEFINED_ERROR){
            isCorrect = true;
            message = msg;
        } else if(code === codes.behavior.INACTIVE) {;
            ok(isCorrect, message);
            start();
        }
	});
});

// asyncTest( "Logged in", function() {

//     codes = require('codes');   

//     var isCorrect = false;  
//     var message = "";

//     require('connection').createUser("benriquez12@ymail.com", "5311f112", 'a', 'b', function(code, msg) {
//         if(code === codes.behavior.DEFINED_ERROR){
//             isCorrect = true;
//             message = msg;
//         } else if(code === codes.behavior.INACTIVE) {;
//             ok(isCorrect, message);
//             start();
//         }
//     });
// });

// test("create user: success", function() {
// 	codes = require('codes');
// 	toolkit = require('toolkit');
// 	var toTest = (Math.random() * 100000).toString();
// 	toTest = toolkit.hash(toTest);
// 	toTest = toTest + "@gmail.com";
// 	user = toTest;

// 	stop();
// 	require('connection').createUser(toTest, "123456", "brent", "enriquez", function(code, msg) {
// 		ok(code === codes.behavior.COMPLETED, "");
// 		start();

// 	});
// });



// test("create user: fail", function() {
// 	codes = require('codes');
// 	require('connection').createUser(user, "123456", "brent", "enriquez", function(code, msg) {
// 		ok(code === codes.behavior.DEFINED_ERROR);
// 	});
// });

// test("login : success", function() {
// 	codes = require('codes');	
// 	require('connection').login(user, "123456", function(code, msg) {
// 		ok(code === codes.behavior.COMPLETED);
// 	});
// });

// test("login : fail", function() {
// 	codes = require('codes');	
// 	require('connection').login(user, "2112f11g91f91n", function(code, msg) {
// 		ok(code === codes.behavior.DEFINED_ERROR);
// 	});
// });

var x = 0;