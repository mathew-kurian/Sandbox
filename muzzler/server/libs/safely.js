
var toolkit = include('toolkit');

function Safely(attachTo){

    var self = attachTo;

    // FIXME Add support for index of array!!!!

    var _f = [ "-s", "-n", "-f"]
    self.set = function(a, b, f){
        f = typeof f === 'boolean' ? (f ? '-s' : '-n') : _f.indexOf(f + "") > -1 ?  f : '-n'; 
        if(toolkit.undef(a)) return false;
        a = a.split(/[>|\.]/g);
        var obj = self;
        while(!toolkit.isNaN(a.length)){
            var key = a.shift();
            if((toolkit.undef(obj[key]) || (f && (typeof obj[key] !== 'object' || !toolkit.isNaN(obj[key].reverse)))) && a.length > 0){
                obj[key] = {};
                obj = obj[key];
            } else if(a.length === 0){
                var _key = key.substring(0, key.length - 1);
                var plus = key.substring(key.length - 1) === "+";
                if(!toolkit.undef(obj[_key]) && plus  &&  
                    !toolkit.isNaN(obj[_key].reverse)){
                    obj[_key].push(b);
                    return true; 
                } else if(toolkit.undef(obj[key]) || (f === '-s' && !toolkit.undef(b)) || f === '-f'){
                    if(plus) {
                        obj[_key] = toolkit.undef(b) ? [] : [ b ];
                        return true;
                    }

                    obj[key] = b;
                    return true;
                }
                return false;
            } else {
                obj = obj[key];
            }
        }

        return false;
    }

    self.safely = function(a, b){

        if(toolkit.undef(a)) return b;

        a = a.split(/[>|\.]/g);
        var obj = self;

        while(!toolkit.isNaN(a.length)){

            var key = a.shift();
            var index = key.match(/\[([0-9]*?)\]/g);

            if(!toolkit.isNaN(index)){
                key = key.replace(index, '');
                index = parseInt(index[0].replace(/[\[\]]/g, ''));

                if(toolkit.isNaN(obj[key]) || toolkit.isNaN(obj[key]).reverse || isNaN(index)) 
                    return b;

                obj = obj[key];
                key = index;
            }  

            if(toolkit.undef(obj[key]))
                return b;         

            if(a.length === 0)
                return obj[key];

            obj = obj[key];
        }

        return b;
    }

    self.extend = function(a, b, f) {
        for (var key in attach){
            var _a = a + ">" + key.replace(/(\+{1,})$/g, '_$1_');
            self.safely(_a, attach[key], f)
        }
    }

    self.__safely = true;
}

exports.attach = function(a){
    a = toolkit.undef(a) || typeof a !== 'object' ? {} : a;

    new Safely(a);

    return a;
}

exports.validate = function(a){
    if(toolkit.isNaN(a)) return false;
    return a['__safely'] === true;
}