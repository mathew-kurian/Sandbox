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
package fr.seraf.wow.primitive {
	
	import fr.seraf.wow.core.data.WInterval;
	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.math.WVectorMath;
	/**	
	 * A sphere object particle. 	 
	 */
	public class WSphere extends WParticle {
	
		private var _radius:Number;
		
		/**
		 * @param x The initial x position of this particle.
		 * @param y The initial y position of this particle.
		 * @param z The initial z position of this particle.
		 * @param radius The radius of this particle.
		 * @param fixed Determines if the particle is fixed or not. Fixed particles
		 * are not affected by forces or collisions and are good to use as surfaces.
		 * Non-fixed particles move freely in response to collision and forces.
		 * @param mass The mass of the particle.
		 * @param elasticity The elasticity of the particle. Higher values mean more elasticity or 'bounciness'.
		 * @param friction The surface friction of the particle.
		 */
		public function WSphere (
				x:Number, 
				y:Number, 
				z:Number, 
				radius:Number, 
				fixed:Boolean,
				mass:Number = 1, 
				elasticity:Number = 0.3,
				friction:Number = 0) {
					
			super(x, y, z,fixed, mass, elasticity, friction);
			_radius = radius;
		}

		/**
		 * The radius of the particle.
		 */
		public function get radius():Number {
			return _radius;
		}		
		
		
		/**
		 * @private
		 */
		public function set radius(r:Number):void {
			_radius = r;
		}

	
		// REVIEW FOR ANY POSSIBILITY OF PRECOMPUTING
		/**
		 * @private
		 */
		public override function getProjection(axis:WVector):WInterval {
			var c:Number = WVectorMath.dot(curr,axis);
			interval.min = c - _radius;
			interval.max = c + _radius;
			return interval;
		}
		
		
		/**
		 * @private
		 */
		public function getIntervalX():WInterval {
			interval.min = curr.x - _radius;
			interval.max = curr.x + _radius;
			return interval;
		}
		
		
		/**
		 * @private
		 */		
		public function getIntervalY():WInterval {
			interval.min = curr.y - _radius;
			interval.max = curr.y + _radius;
			return interval;
		}
				/**
		 * @private
		 */		
		public function getIntervalZ():WInterval {
			interval.min = curr.z - _radius;
			interval.max = curr.z + _radius;
			return interval;
		}
	}
}
	
	