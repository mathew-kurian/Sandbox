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

package fr.seraf.wow.math{

	import fr.seraf.wow.core.data.WPlane;
	import fr.seraf.wow.core.data.WVector;
	//import sandy.primitive.Plane3D;
	import fr.seraf.wow.math.WVectorMath;


	/**
	* Math functions for planes.
	*  
	* @authorThomas Pfeiffer - kiroukou
	 * @since0.3
	 * @version0.1
	 * @date 21.02.2006
	* 
	**/
	public class WPlaneMath {

		public static  const NEGATIVE:int = -1;
		public static  const ON_PLANE:int = 0;
		public static  const POSITIVE:int = 1;

		/**
		 * Normalize the plane. Often before making some calculations with a plane you have to normalize it.
		 * @param plane Plane The plane that we want to normalize.
		 */
		public static function normalizePlane( plane:WPlane ):void {
			var mag:Number;
			mag = Math.sqrt( plane.a * plane.a + plane.b * plane.b + plane.c * plane.c );
			plane.a = plane.a / mag;
			plane.b = plane.b / mag;
			plane.c = plane.c / mag;
			plane.d = plane.d / mag;
		}
		/**
		 * Computes the distance between a plane and a 3D point (a vector here).
		 * @param plane Plane The plane we want to compute the distance from
		 * @param pt Vector The vector in the 3D space
		 * @return Number The distance between the point and the plane.
		 */
		public static function distanceToPoint( plane:WPlane, pt:WVector ):Number {

			return plane.a * pt.x + plane.b * pt.y + plane.c * pt.z + plane.d;
		}
		/**
		 * Computes the distance between a plane and a 3D point (a vector here).
		 * @param plane Plane The plane we want to compute the distance from
		 * @param pt Vector The vector in the 3D space
		 * @return Number The distance between the point and the plane.
		 */
		/*public static function distanceToProjection( plane:Plane, pt:Vector ):Number {
			
			
			var L:Number=(-plane.a*pt.x-plane.b*pt.y-plane.c*pt.z-plane.d)/(plane.a*plane.a+plane.b*plane.b+plane.c*plane.c);
			var ptp:Vector=new Vector(L*plane.a+pt.x,L*plane.b+pt.y,L*plane.c+pt.z);

			return VectorMath.distance(ptp,pt);
		}*/
		/**
		 * Returns a constant PlaneMath.NEGATIVE PlaneMath.POSITIVE PlaneMath.ON_PLANE depending of the position
		 * of the point compared to the plane
		 * @param plane Plane The reference plane
		 * @param pt Vector The point we want to classify
		 * @return Number The classification of the point PlaneMath.NEGATIVE or PlaneMath.POSITIVE or PlaneMath.ON_PLANE 
		 */
		public static function classifyPoint( plane:WPlane, pt:WVector ):int {
			var d:Number;
			d = WPlaneMath.distanceToPoint( plane, pt );
			if (d < 0) {
				return WPlaneMath.NEGATIVE;
			}
			if (d > 0) {
				return WPlaneMath.POSITIVE;
			}
			return WPlaneMath.ON_PLANE;
		}
		public static function computePlaneFromPoints( pA:WVector, pB:WVector, pC:WVector ):WPlane {
			var p:WPlane = new WPlane();
			var n:WVector = WVectorMath.cross( WVectorMath.sub( pA, pB), WVectorMath.sub( pA, pC) );
			WVectorMath.normalize( n );
			var d:Number = WVectorMath.dot( pA, n);
			// --
			p.a = n.x;
			p.b = n.y;
			p.c = n.z;
			p.d = d;
			// --
			return p;
		}
		public static function createFromNormalAndPoint( pNormal:WVector, pD:Number ):WPlane {
			var p:WPlane = new WPlane();
			WVectorMath.normalize(pNormal);
			p.a = pNormal.x;
			p.b = pNormal.y;
			p.c = pNormal.z;
			p.d = pD;
			WPlaneMath.normalizePlane( p );
			return p;
		}

	}

}