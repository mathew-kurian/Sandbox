(function(__context) {

    var exports = {};

    exports.behavior = {
        'VALIDATION_ERROR': -1,
        'ACTIVE': 2,
        'UNKOWN_ERROR': -3,
        'DEFINED_ERROR': -2,
        'INACTIVE': 1,
        'COMPLETED': 0,
        failed : function(s){
            if(s < 0) return true;
        },
        ok : function(s){
            if(s == 0) return true;
        },
        other : function(s){
            if( s == 1 || s == 2 ) return true;
        }
    };

    exports.status = {
        'FAILED': 1,
        'OK': 0,
        'NO_TYPE': 2,
        'DB_ERROR': 3
    };

    attach(__context, exports);

})('codes');