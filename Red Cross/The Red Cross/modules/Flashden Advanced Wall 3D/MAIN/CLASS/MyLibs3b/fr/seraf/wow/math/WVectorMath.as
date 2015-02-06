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

package fr.seraf.wow.math {

	import fr.seraf.wow.core.data.WVector;
	 
	/**
	* Math functions for {@link Vector4}.
	*  
	* @author		Thomas Pfeiffer - kiroukou
	* @author		Tabin Cédric - thecaptain
	* @author		Nicolas Coevoet - [ NikO ]
	* @author		Jerome Birembaut - Seraf
	* @since		0.1
	* @version		0.3
	* @date 		1.04.2007 
	**/
	public class WVectorMath {
		
		/**
		 * Compute the norm of the {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @return the norm of the {@code Vector}.
		 */
		public static function getNorm( v:WVector ):Number
		{
			return Math.sqrt( v.x*v.x + v.y*v.y + v.z*v.z );
		}
		
		/**
		 * Compute the oposite of the {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @return a {@code Vector}.
		 */
		public static function negate( v:WVector ): WVector
		{
			return new WVector( - v.x, - v.y, - v.z );
		}
		
		/**
		 * Compute the addition of the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return The resulting {@code Vector}.
		 */
		public static function addVector( v:WVector, w:WVector ): WVector
		{
			return new WVector( 	v.x + w.x ,
								v.y + w.y ,
								v.z + w.z );
		}
		
		/**
		 * Compute the substraction of the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return The resulting {@code Vector}.
		 */
		public static function sub( v:WVector, w:WVector ): WVector
		{
			return new WVector(	v.x - w.x ,
								v.y - w.y ,
								v.z - w.z );
		}
		
		/**
		 * Compute the power of the current vector
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code pow} a {@code Number}.
		 * @return The resulting {@code Vector}.
		 */
		public static function pow( v:WVector, pow:Number ): WVector
		{
			return new WVector(	Math.pow( v.x, pow ) ,
								Math.pow( v.x, pow ) ,
								Math.pow( v.x, pow ) );
		}
		/**
		 * Compute the multiplication of the {@code Vector} and the scalar.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code n a {@code Number}.
		 * @return The resulting {@code Vector}.
		 */
		public static function scale( v:WVector, n:Number ): WVector
		{
			return new WVector(	v.x * n ,
								v.y * n ,
								v.z * n );
		}
		
		/**
		 * Compute the dot product of the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return the dot procuct of the 2 {@code Vector}.
		 */
		public static function dot( v: WVector, w: WVector):Number
		{
			return ( v.x * w.x + v.y * w.y + w.z * v.z );
		}
		
		/**
		 * Compute the cross product of the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return the {@code Vector} resulting of the cross product.
		 */
		public static function cross(w:WVector, v:WVector):WVector
		{
			// cross product vector that will be returned
					// calculate the components of the cross product
			return new WVector( 	(w.y * v.z) - (w.z * v.y) ,
								(w.z * v.x) - (w.x * v.z) ,
								(w.x * v.y) - (w.y * v.x));
		}
		
		/**
		 * Normalize the {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @return a Boolean true for success, false for mistake.
		 */	
		public static function normalize( v:WVector ): Boolean
		{
			// -- We get the norm of the vector
			var norm:Number = WVectorMath.getNorm( v );
			// -- We escape the process is norm is null or equal to 1
			if( norm == 0 || norm == 1) return false;
			v.x /= norm;
			v.y /= norm;
			v.z /= norm;

			return true;
		}
		
		/**
		* Returns the angle in radian between the two 3D vectors. The formula used here is very simple.
		* It comes from the definition of the dot product between two vectors.
		* @param	v	Vector	The first Vector
		* @param	w	Vector	The second vector
		* @return 	Number	The angle in radian between the two vectors.
		*/
		public static function getAngle ( v:WVector, w:WVector ):Number
		{
			var ncos:Number = WVectorMath.dot( v, w ) / ( WVectorMath.getNorm(v) * WVectorMath.getNorm(w) );
			var sin2:Number = 1 - ncos * ncos;
			
			if (sin2<0)
			{
				trace(" wrong "+ncos);
				sin2 = 0;
			}
			//I took long time to find this bug. Who can guess that (1-cos*cos) is negative ?!
			//sqrt returns a NaN for a negative value !
			return  Math.atan2( Math.sqrt(sin2), ncos );
			
			//return Math.acos( VectorMath.dot( v, w ) / (VectorMath.getNorm(v) * VectorMath.getNorm(w)) );
		}
		
		/**
		 * clone the {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @return a clone of the Vector passed in parameters
		 */	
		public static function clone( v:WVector ): WVector
		{
			return new WVector( v.x, v.y, v.z );
		}
		
		/**
		 * Compute the division of the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return The resulting {@code Vector}.
		 */
		public static function divEquals(v:WVector,s:Number):WVector {
			if (s == 0) s = 0.0001;
			return new WVector(	v.x / s ,
								v.y  / s ,
								v.z / s );
		}
		
		/**
		 * Compute the distance between the two {@code Vector}.
		 *
		 * @param {@code v} a {@code Vector}.
		 * @param {@code w} a {@code Vector}.
		 * @return The resulting {@code Number}.
		 */
		public static function distance(v:WVector, w:WVector ):Number {
			var delta:WVector = WVectorMath.sub(v,w);
			return WVectorMath.getNorm(delta);
		}


	}
}