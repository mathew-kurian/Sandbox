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
/*
* TODO : handle collision
*/
package fr.seraf.wow.core.collision {

	import fr.seraf.wow.core.collision.WCollision;
	import fr.seraf.wow.primitive.WParticle;
	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.math.WVectorMath;
	// NEED TO EXCLUDE VELOCITY CALCS BASED ON collisionResponseMode
	internal final class WCollisionResolver {
		
		internal static function resolveParticleParticle(
				pa:WParticle, 
				pb:WParticle, 
				normal:WVector, 
				depth:Number):void {
			var mtd:WVector = WVectorMath.scale(normal,depth);
			var te:Number = pa.elasticity + pb.elasticity;
			
			// the total friction in a collision is combined but clamped to [0,1]
			var tf:Number = 1 - (pa.friction + pb.friction);
			if (tf > 1) tf = 1;
			else if (tf < 0) tf = 0;
		
			// get the total mass, and assign giant mass to fixed particles
			var ma:Number = (pa.fixed) ? 100000 : pa.mass;
			var mb:Number = (pb.fixed) ? 100000 : pb.mass;
			var tm:Number = ma + mb;
			
			// get the collision components, vn and vt
			var ca:WCollision = pa.getComponents(normal);
			var cb:WCollision = pb.getComponents(normal);
		 
		 	// calculate the coefficient of restitution based on the mass  
			var vnA:WVector =WVectorMath.divEquals(WVectorMath.addVector(WVectorMath.scale(cb.vn,(te + 1) * mb),WVectorMath.scale(ca.vn,ma - te * mb)),tm);	

			var vnB:WVector =WVectorMath.divEquals(WVectorMath.addVector(WVectorMath.scale(ca.vn,(te + 1) * ma),WVectorMath.scale(cb.vn,mb - te * ma)),tm);	

			ca.vt=WVectorMath.scale(ca.vt,tf);

			cb.vt=WVectorMath.scale(cb.vt,tf);
			
			// scale the mtd by the ratio of the masses. heavier particles move less
			var mtdA:WVector =WVectorMath.scale(mtd,mb / tm);

			var mtdB:WVector =WVectorMath.scale(mtd,-ma / tm);
			
			if (! pa.fixed) pa.resolveCollision(mtdA, WVectorMath.addVector(vnA,ca.vt), normal, depth, -1);
			if (! pb.fixed) pb.resolveCollision(mtdB, WVectorMath.addVector(vnB,cb.vt), normal, depth,  1);
			//TODO HANDLE COLLISION
		}
	}
}

