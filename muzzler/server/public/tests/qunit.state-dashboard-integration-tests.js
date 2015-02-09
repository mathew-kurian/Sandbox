
// Constants.Require

test( "integration.mui.processExistingHash", function() {
    ok( require('toolkit').uri.decodeFromHash(window.location.hash).test === 'qunit', 
                    "Submodules - require + decode");
});

test( "integration.mui.validateThenStoreAndRestore", function() {

    var toolkit = require('toolkit');

    var testData = [
        { email : "bluejamesbond@gmail.com", expected : true },
        { email : "sdf24234@gmail.com", expected : true },
        { email : "@gmail.com", expected : false },
        { email : "", expected : false },
        { email : "syk342@gmail.com", expected : true },
        { email : "2234dsfsd@gmail.com", expected : true },
        { email : "45@gmail.com", expected : true },
        { email : "ssf.sdf.dsf.@gmail.com", expected : false },
        { email : "___@gmail.com", expected : true },
        { email : ".sf.df@gmail.com", expected : false },
        { email : undefined, expected : false }
    ];

    expect(testData.length);

    testData.each(function(e, i, a){
        if(toolkit.validate.email(e.email)){
            toolkit.localStorage.set(e.email, 0);
            if(toolkit.localStorage.get(e.email) == 0)
                ok(e.expected, "Bulk store and validate.");
        } else ok(e.expected === false, "Store avoided beacuse of invalid email.");
    });
});

test("integration.mui.core.loadSubsequence", function(){

    var core = require('core');

    var testData = [
        {
            request : ['a', 'b', 'c', 'd', 'e'],
            existing : ['c', 'd', 'e'],
            message : "All existing states needed.",
            test : function(output){
                return output.length === 0;
            }
        },
        {
            request : ['a', 'b', 'c', 'd', 'e'],
            existing : [],
            message : "Add all the states. Don't Pop any existing.",
            test : function(output){
                return output.length === 0;
            }
        },
        {
            request : ['a', 'b', 'c', 'd', 'e'],
            existing : ['z', 'd', 'e'],
            message : "Pop 1 existing state - z",
            test : function(output){
                return output.length === 1 && output[0] === 'z';
            }
        },
        {
            request : [],
            existing : [],
            message : "Empty sets. Don't Pop anything.",
            test : function(output){
                return output.length === 0;
            }
        },
        {
            request : [1, 'd', 'e'],
            existing : ['c', 'd', 'e'],
            message : "Pop 1 state. Too many states. - c",
            test : function(output){
                return output.length === 1 && output[0] === 'c';
            }
        },
        {
            request : [undefined, 'e'],
            existing : ['c', 'd', 'e'],
            message : "Pop 2 states from back.",
            test : function(output){
                return output.length === 2 && output[1] === 'c' && output[0] === 'd';
            }
        }
    ];

    expect(testData.length);

    testData.each(function(e, i, a){
        ok(e.test(core.executeByLongestSubsequence(e.existing, e.request)), e.message);
    });
});


test("integration.mui.core.loadSubsequence", function(){
    var core = require('core');
    var request = [ "a", "b", "c", "d", "e" ];
    var existing = [];

    var output = core.executeByLongestSubsequence(existing, request);
    ok(output.length === 0, "Pop no existing states.");
});

test("integration.mui.core.loadSubsequence", function(){
    var core = require('core');
    var request = [ "a", "b", "c", "d", "e" ];
    var existing = [ "z", "c", "d", "e" ];

    var output = core.executeByLongestSubsequence(existing, request);
    ok(output.length === 1 && output[0] === 'z', "Only Pop 1 state.");
});

test("integration.mui.core.loadSubsequence", function(){
    var core = require('core');
    var request = [ "d", "e" ];
    var existing = [ "a", "c", "d", "e" ];

    var output = core.executeByLongestSubsequence(existing, request);
    ok(output.length === 2 && output[0] === "c" && output[1] === "a", "Removing only 2 ");
});