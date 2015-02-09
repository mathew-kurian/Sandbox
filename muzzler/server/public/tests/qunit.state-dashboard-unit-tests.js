
// Constants.Require

test( "unit.mui.constants.require", function() {
    ok( typeof require('constants') !== 'undefined' , "Submodule found correctly." );
});

test( "unit.mui.constants.require", function() {
    throws(function(){
        require('')
    }, RangeError, "Submodule threw RangeError." );
});

// Debug.Out

test( "unit.mui.debug.out", function() {
    ok( typeof require('debug').info !== 'undefined' , "Pipe found correctly." );
});

test( "unit.mui.debug.out", function() {
    ok( typeof require('debug').warning === 'undefined' , "Pipe not found." );
});

// Toolkit.LocalStorage.Exists

test( "unit.mui.toolkit.localStorage.exists", function() {
    ok( require('toolkit').localStorage.exists() === true  , "Browser has localStorage." );
});

test( "unit.mui.toolkit.localStorage.exists", function() {
    ok( require('toolkit').localStorage.exists() !== false  , "Browser has localStorage." );
});

// Toolkit.LocalStorage.Set

test( "unit.mui.toolkit.localStorage.set", function() {
    ok( typeof require('toolkit').localStorage.set("cat", 10) === 'undefined', "Added content" );
});

test( "unit.mui.toolkit.localStorage.set", function() {
    ok( typeof require('toolkit').localStorage.set("cata", 0) === 'undefined', "Added content" );
});

// Toolkit.LocalStorage.Get

test( "unit.mui.toolkit.localStorage.get", function() {
    ok( require('toolkit').localStorage.get("cat") == 10, "LocalStorage gets data.");
});

test( "unit.mui.toolkit.localStorage.get", function() {
    ok( require('toolkit').localStorage.get("cata") == 0, "LocalStorage gets data.");
});

// Toolkit.LocalStorage.Has

test( "unit.mui.toolkit.localStorage.has", function() {
    ok( require('toolkit').localStorage.has("cata") === true, "LocalStorage contains data.");
});

test( "unit.mui.toolkit.localStorage.has", function() {
    ok( require('toolkit').localStorage.has("catas") === false, "LocalStorage does not contain data.");
});

// Toolkit.Safely

test( "unit.mui.toolkit.safely", function() {
    
    var x = 0;

    require('toolkit').safely(x)
        .exists(function(){
            ok( true, "Variable exists.");
        }).noexists(function(){
            ok( false, "Variable exists; however it does not exit.");
        });

});

test( "unit.mui.toolkit.safely", function() {
    
    var x = undefined;

    require('toolkit').safely(x)
        .exists(function(){
            ok( false, "Variable does not exist; however it does exit.");
        }).noexists(function(){
            ok( true, "Variable exists.");
        });

});

// Toolkit.Extend

test( "unit.mui.toolkit.safely", function() {
    
    var x = undefined;

    require('toolkit').safely(x)
        .exists(function(){
            ok( false, "Variable does not exist; however it does exit.");
        }).noexists(function(){
            ok( true, "Variable exists.");
        });

});

// Toolkit.Validate

test("unit.mui.toolkit.validate", function(){
    ok( require('toolkit').validate.email('breant@gmail.com') === true, "Valid email detected.")
});

test("unit.mui.toolkit.validate", function(){
    ok( require('toolkit').validate.email() === false, "Invalid email detected.")
});

// Toolkit.Fire

var __test__ = function(){}

test("unit.mui.toolkit.fire", function(){
    require('toolkit', __test__);
    ok( true, "Fired callback!");
});

test("unit.mui.toolkit.fire", function(){
    require('toolkit', undefined);
    ok( true, "Null callback");
});




// Toolkit.URI

var __hash__ = "#state[music]:test[qunit]:criteria[unit]";
var __basic__ = "?state=music&test=qunit&criteria=unit";
var __obj__ = {
    state : "music",
    test : "qunit",
    criteria : "unit"
};

var __equalsObj__ = function(obj){
    for(var k in obj)
        if(__obj__[k] !== obj[k])
            return false;
    return true;
};

test("unit.mui.toolkit.uri.decodeFromBasic", function(){
    ok(__equalsObj__(require('toolkit').uri.decodeFromBasic(__basic__)), "Decoded correctly.");
});

test("unit.mui.toolkit.uri.decodeFromBasic", function(){
    ok(typeof require('toolkit').uri.decodeFromBasic("") === 'object' , "Decoded correctly.");    
});

test("unit.mui.toolkit.uri.decodeFromHash", function(){
    ok(__equalsObj__(require('toolkit').uri.decodeFromHash(__hash__)), "Decoded correctly.");        
});

test("unit.mui.toolkit.uri.decodeFromHash", function(){
    ok(typeof require('toolkit').uri.decodeFromHash("") === 'object' , "Decoded correctly.");    
});

test("unit.mui.toolkit.uri.encodeToBasic", function(){
    ok(require('toolkit').uri.encodeToBasic(__obj__) === __basic__, "Encoded correctly.");
});

test("unit.mui.toolkit.uri.encodeToBasic", function(){
    ok(require('toolkit').uri.encodeToBasic({}) === "" , "Encoded correctly.");    
});

test("unit.mui.toolkit.uri.encodeToHash", function(){
    ok(require('toolkit').uri.encodeToHash(__obj__) === __hash__, "Encoded correctly.");
});

test("unit.mui.toolkit.uri.encodeToHash", function(){
    ok(require('toolkit').uri.encodeToHash({}) === "" , "Encoded correctly.");    
});
