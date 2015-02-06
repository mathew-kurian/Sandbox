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
package fr.seraf.wow.core.collision{
	import fr.seraf.wow.primitive.WOWPlane;
	import fr.seraf.wow.primitive.WSphere;
	import fr.seraf.wow.primitive.WParticle;
	import fr.seraf.wow.core.data.WInterval;
	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.math.WVectorMath;
	import fr.seraf.wow.math.WPlaneMath;
	public class WCollisionDetector {

		/**
		 * Tests the collision between two objects. If there is a collision it is passed off
		 * to the CollisionResolver class to resolve the collision.
		 */
		public static function test(objA:WParticle, objB:WParticle):void {

			if (objA.fixed && objB.fixed) {
				return;
			}


			// circle to circle
			if (objA is WSphere && objB is WSphere) {
				testSpherevsSphere(WSphere(objA), WSphere(objB));


			}
			// plan to circle
			if (objA is WOWPlane && objB is WSphere) {
				testPlanevsSphere(WOWPlane(objA), WSphere(objB));


			}
			// plan to circle
			if (objA is WSphere && objB is WOWPlane) {
				testPlanevsSphere(WOWPlane(objB), WSphere(objA));


			}
		}
		private static function testPlanevsSphere(ra:WOWPlane, ca:WSphere):void {

			var collisionNormal:WVector;
			var collisionDepth:Number = Number.POSITIVE_INFINITY;
			
			var depth:Number=WPlaneMath.distanceToPoint(ra.getPlane(),ca.position);
			if (depth == 0) {
				return;
			}

			if (Math.abs(depth) < Math.abs(collisionDepth)) { 
				collisionNormal = ra.getNormale();
				collisionDepth = depth;
			}
			//}
			// determine if the circle's center is in a vertex region

			var r:Number = ca.radius;
			
			/*if (Math.abs(depth) > r ) {
				return;
			}*/
			var mag:Number = WVectorMath.getNorm(collisionNormal);
			collisionDepth = r - collisionDepth;

			if (collisionDepth > 0) {
				WVectorMath.divEquals(collisionNormal,mag);
			} else {
				return;
			}
			WCollisionResolver.resolveParticleParticle(ra, ca, WVectorMath.negate(collisionNormal), collisionDepth);

		}

		/**
		 * Tests the collision between two Spheres. If there is a collision it 
		 * determines its axis and depth, and then passes it off to the CollisionResolver
		 * for handling.
		 */
		private static function testSpherevsSphere(ca:WSphere, cb:WSphere):void {

			var depthX:Number = testIntervals(ca.getIntervalX(), cb.getIntervalX());
			if (depthX == 0) {
				return;
			}

			var depthY:Number = testIntervals(ca.getIntervalY(), cb.getIntervalY());
			if (depthY == 0) {
				return;
			}

			var depthZ:Number = testIntervals(ca.getIntervalZ(), cb.getIntervalZ());
			if (depthZ == 0) {
				return;
			}

			var collisionNormal:WVector = WVectorMath.sub(ca.curr,cb.curr);
			var mag:Number = WVectorMath.getNorm(collisionNormal);
			var collisionDepth:Number = (ca.radius + cb.radius) - mag;

			if (collisionDepth > 0) {

				collisionNormal=WVectorMath.divEquals(collisionNormal,mag);
				WCollisionResolver.resolveParticleParticle(ca, cb, collisionNormal, collisionDepth);
			}
		}
		/**
		 * Returns 0 if intervals do not overlap. Returns smallest depth if they do.
		 */
		private static function testIntervals(intervalA:WInterval, intervalB:WInterval):Number {

			if (intervalA.max < intervalB.min) {
				return 0;
			}
			if (intervalB.max < intervalA.min) {
				return 0;
			}

			var lenA:Number = intervalB.max - intervalA.min;
			var lenB:Number = intervalB.min - intervalA.max;

			return Math.abs(lenA) < Math.abs(lenB)?lenA:lenB;
		}
	}
}