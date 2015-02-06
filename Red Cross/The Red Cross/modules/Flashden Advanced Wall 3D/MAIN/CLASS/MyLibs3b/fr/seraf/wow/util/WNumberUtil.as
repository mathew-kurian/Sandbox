/**
 * WOW-Engine AS3 3D Physics Engine, http://www.wow-engine.com
 * Copyright (c) 2007-2008 Seraf ( Jerome Birembaut ) http://seraf.mediabox.fr
 * 
 * Based on APE by Alec Cove , http://www.cove.org/ape/
 *       & Sandy3D by Thomas Pfeiffer, http://www.flashsandy.org/
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
*/

package fr.seraf.wow.util {

	public class WNumberUtil 
	{
		/**
		 * Constant used pretty much everywhere. Trick of final const keywords use.
		 */
		public static function get TWO_PI():Number { return __TWO_PI; }
		internal static const __TWO_PI:Number = 2 * Math.PI;
		/**
		 * Constant used pretty much everywhere. Trick of final const keywords use.
		 */
		public static function get PI():Number { return __PI; }
		internal static const __PI:Number = Math.PI;	
		
		/**
		 * Constant used pretty much everywhere. Trick of final const keywords use.
		 */
		public static function get HALF_PI():Number { return __HALF_PI; }
		internal static const __HALF_PI:Number = 0.5 * Math.PI;	
		
		/**
		 * Constant used to convert angle from radians to degress
		 */
		public static function get TO_DEGREE():Number { return __TO_DREGREE; }
		internal static const __TO_DREGREE:Number = 180.0 /  Math.PI;
		
		/**
		 * Constant used to convert degress to radians.
		 */
		public static function get TO_RADIAN():Number { return __TO_RADIAN; }
		internal static const __TO_RADIAN:Number = Math.PI / 180;
		
		/**
		 * Value used to compare a number and another one. Basically it's used to say if a number is zero or not.
		 */
		public static var TOL:Number = 0.0001;	
			
		/**
		 * Say if a Number is close enought to zero to ba able to say it's zero. 
		 * Adjust TOL property depending on the precision of your Application
		 * @param n Number The number to compare with zero
		 * @return Boolean true if the Number is comparable to zero, false otherwise.
		 */
		public static function isZero( n:Number ):Boolean
		{
			return _fABS( n ) < TOL ;
		}
		
		/**
		 * Say if a Number is close enought to another to ba able to say they are equal. 
		 * Adjust TOL property depending on the precision of your Application
		 * @param n Number The number to compare m
		 * @param m Number The number you want to compare with n
		 * @return Boolean true if the numbers are comparable to zero, false otherwise.
		 */
		public static function areEqual( n:Number, m:Number ):Boolean
		{
			return _fABS( n - m ) < TOL ;
		}
		
		/**
		 * Convert an angle from Radians to Degrees unit
		 * @param n  Number Number representing the angle in radian
		 * @return Number The angle in degrees unit
		 */
		public static function toDegree ( n:Number ):Number
		{
			return n * TO_DEGREE;
		}
		
		/**
		 * Convert an angle from Degrees to Radians unit
		 * @param n  Number Number representing the angle in dregrees
		 * @return Number The angle in radian unit
		 */
		public static function toRadian ( n:Number ):Number
		{
			return n * TO_RADIAN;
		}
			
		/**
		 * Add a constrain to the number which must be between min and max values. Usually name clamp ?
		 * @param n Number The number to constrain
		 * @param min Number The minimal valid value
		 * @param max Number The maximal valid value
		 * @return Number The number constrained
		 */
		 public static function constrain( n:Number, min:Number, max:Number ):Number
		 {
			return Math.max( Math.min( n, max ) , min );
		 }
		 
		 
		internal static const _fABS:Function = Math.abs;	
	}
}