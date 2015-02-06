package gT.utils {
	
	public class ArrayUtils {
				
		public static function unsortArray(oldArray:Array):Array{
			var new_array:Array = oldArray;
			for (var i:Number = 0; i<new_array.length; i++) {
				var posic = (Math.round(Math.random()*((new_array.length-1)-i)))+i;
				new_array.splice(i,0,new_array[posic]);
				new_array.splice(posic+1,1);
			}
			
			return new_array;
		}
		
		public static function unsort(oldArray:Array):Array{
			var new_array:Array = oldArray;
			for (var i:Number = 0; i<new_array.length; i++) {
				var posic = (Math.round(Math.random()*((new_array.length-1)-i)))+i;
				new_array.splice(i,0,new_array[posic]);
				new_array.splice(posic+1,1);
			}
			
			return new_array;
		}
		
		public static function findElement(array:Array, target:* ) : Number {
			for (var i:uint; i < array.length; i++) {
				if (array[i] == target) {
					return i;
					break;
				}
			}
			return NaN;
		}
		
		public static function contains (array:Array, value:Object):Boolean
		{
			return (array.indexOf(value) != -1);
		}
		
		
		public static function copy (targetArray:Array):Array 
		{		
			var newArray = [];
			for (var prop in targetArray) {
				newArray[prop] = targetArray[prop];
			}
			return newArray;
		}
		
		public static function clone(array:*, recursive:Boolean = true):*
		{
			var result:Array = [];
			var pos:String;
			var val:*;
			
			for (pos in array) 
			{ 
				val = array[pos];
				if (typeof(val) == "object" && recursive) 
				{ 
					result[pos] = clone(val);
				} 
				else 
				{ 
					result[pos] = val;
				} 
			}
			
			return result;
		}  
	}
}