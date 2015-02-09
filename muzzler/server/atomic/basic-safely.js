
var safely = include("safely");

function Result(){
   this.data;
   this.cat;
   this.extras = {
      "obj" : "lol",
      "test" : {
        "obj" : "sup" 
      }
   }

   safely.attach(this);
}

exports.run = function(opts){

   var result = new Result();

   result.set('a', "whats up!")

   console.test("SAFELY test#1").should(result.safely('a')).be('whats up!');

   result.set('data', "hahaha");

   console.test("SAFELY test#2").should(result.safely('data')).be('hahaha');

   result.set('data+', "hahaha");

   console.test("SAFELY test#3").should(result.safely('data[0]')).be('hahaha');

   result.set('data>funny+', "lol");

   console.test("SAFELY test#4").should(result.safely('data>funny[0]')).be('lol');

   result.set('test>funny+', 0, '-f');

   console.test("SAFELY test#5").should(result.safely('test>funny[0]')).be('0');

   result.set('extras>images>specialized+', 'nostaliagia');

   console.test("SAFELY test#6").should(result.safely('extras>images>specialized')).be(["nostaliagia"]);
   console.test("SAFELY test#7").should(result.safely('extras>images>specialized>cat')).be(undefined);

}