/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import oxylus.utils.*;
class oxylus.utils.UArray {
	private function UArray() { trace("Static class. No instantiation.") }
	
	/* Ascending direction for "forEach" method. */
	public static var DIR_ASC:Number = 1;
	/* Descending direction for "forEach" method. */
	public static var DIR_DSC:Number = -1;	
	
	/* Remove element at given index.
	 * Returns element or flase. */
	public static function removeAt(arr:Array, idx:Number) {
		if (idx < arr.length)			
			return arr.splice(idx, 1)[0];

		return false;
	}
	/* Insert element at given index. */
	public static function insertAt(arr:Array, idx:Number, val):Boolean {
		if (idx <= arr.length) {
			arr.splice(idx, 0, val);
			return true;
		}
		return false;
	}	
	/* Search element and, if found, remove it. */
	public static function remove(arr:Array, val):Boolean {
		var i:Number = UArray.indexOf(arr, val);
		if (i >= 0) {
			arr.splice(i, 1);
			return true;
		}
		return false;
	}
	/* Remove all elements from the array. */
	public static function clear(arr:Array):Void {
		arr.splice(0);
	}
	/* Get index of a given value. */
	public static function indexOf(arr:Array, val):Number {
		var n:Number = arr.length;
		for (var i:Number = 0; i < n; i++) {
			if (arr[i] === val) return i;
		}
		return -1;
	}
	/* Swaps two elements in the given array. */
	public static function swapElem(arr:Array, idx:Number, withIdx:Number):Boolean {
		var n:Number = arr.length;
		if (UMath.belongs(idx, 0, n - 1) && UMath.belongs(withIdx, 0, n - 1) && idx != withIdx) {
			var aux:Object 	= arr[idx];
			arr[idx] 		= arr[withIdx];
			arr[withIdx] 	= aux;
			
			return true;
		}
		return false;		
	}
	/* Returns a randomized copy of the given array.
	 * Can randomize elements between two indexes (optional).*/
	public static function randomizedCopy(arr:Array, fromIdx:Number, toIdx:Number):Array {
		var rArr:Array 	= UArray.clone(arr);		
		randomize(rArr, fromIdx, toIdx);		
		return rArr;
	}
	/* Randomizes the elements of a given array. */ 
	public static function randomize(arr:Array, fromIdx:Number, toIdx:Number):Boolean {
		var n:Number = arr.length;
		
		if (fromIdx == undefined) 	fromIdx = 0;
		if (toIdx 	== undefined) 	toIdx 	= n - 1;
		else if (toIdx < 0) 		toIdx 	+= n;
			
		if (UMath.belongs(fromIdx, 0, n - 1) && UMath.belongs(toIdx, 0, n - 1) && fromIdx < toIdx) {
			for (var i:Number = fromIdx; i <= toIdx; i++) {
				var r:Number = UMath.rand(i, toIdx);
				UArray.swapElem(arr, r, fromIdx);
			}
			return true;
		}		
		return false;
	}
	/* Goes through the array and calls a function at each iteration.
	 * Can define function name, scope, optional argument and direction. */
	public static function forEach(arr:Array, callBack:Function, scope:Object, arg, dir:Number):Void {
		if(isNaN(dir)) dir = DIR_ASC;
		
		var n:Number = arr.length;		;
		for (var i:Number 	= 0; i < n; i++) {
			callBack.call(scope, arr[dir < 0 ? n - i - 1 : i], arg);
		}
	}
	/* Creates a copy of the given array. */
	public static function clone(arr:Array):Array {
		var newArr:Array 	= new Array();
		var n:Number 		= arr.length;
		for (var i:Number = 0; i < n; i++) {
			newArr[i] = arr[i];
		}		
		return newArr;
	}
	/* Returns an array with the elements arranged backwards. */
	public static function reverse(arr:Array):Array {
		var temp:Array 	= new Array();
		var n:Number 	= arr.length;
		for (var i:Number = n - 1; i >= 0; i--) {
			temp.push(arr[i]);
		}		
		return temp;
	}
	/* Normalize index according to the array length. */
	public static function normIndex(arr:Array, idx:Number):Number {
		var n:Number = arr.length;
		idx = idx % n;
		if (idx < 0) return n + idx;
		else return idx;
	}
	/* Rotate array to the left. */
	public static function rotateLeft(arr:Array, times:Number):Void {
		if (isNaN(times)) times = 1;
		var n:Number = arr.length;		
		while (--times >= 0) {
			var first:Object 				= arr[0];
			var i:Number 					= 0;
			while (++i < n) arr[i - 1] 	= arr[i];
			arr[n - 1] 					= first;
		}
	}
	/* Rotate array to the right. */
	public static function rotateRight(arr:Array, times:Number):Void {
		if (isNaN(times)) times = 1;
		var n:Number = arr.length;		
		while (--times >= 0) {
			var last:Object 		= arr[n - 1];
			var i:Number 			= n;
			while (--i > 0) arr[i] 	= arr[i - 1];
			arr[0] 					= last;
		}
	}
	/* Left rotated array copy. */
	public static function leftRotatedCopy(arr:Array, times:Number):Array {
		var lArr:Array = clone(arr);
		if (isNaN(times)) times = 1;
		var n:Number = lArr.length;		
		while (--times >= 0) {
			var first:Object 				= lArr[0];
			var i:Number 					= 0;
			while (++i < n) lArr[i - 1] 	= lArr[i];
			lArr[n - 1] 					= first;
		}
		return lArr;
	}
	/* Right rotated array copy. */
	public static function rightRotatedCopy(arr:Array, times:Number):Array {
		var rArr:Array = clone(arr);
		if (isNaN(times)) times = 1;
		var n:Number = rArr.length;		
		while (--times >= 0) {
			var last:Object 		= rArr[n - 1];
			var i:Number 			= n;
			while (--i > 0) rArr[i] = rArr[i - 1];
			rArr[0] 				= last;
		}
		return rArr;
	}
}