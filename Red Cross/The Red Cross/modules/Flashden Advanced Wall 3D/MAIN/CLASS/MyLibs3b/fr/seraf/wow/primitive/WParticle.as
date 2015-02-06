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
		import fr.seraf.wow.core.WOWEngine;
		import fr.seraf.wow.core.collision.WCollision;
		import fr.seraf.wow.core.data.WInterval;
		import fr.seraf.wow.core.data.WVector;
		import fr.seraf.wow.math.WVectorMath;
	
	/**
	 * The abstract base class for all particles.
	 * 
	 * <p>
	 * You should not instantiate this class directly -- instead use one of the subclasses.
	 * </p>
	 */
	public class WParticle {
		
		// public properties are not hidden from asdoc?
		
		/** @private */
		public var curr:WVector;
		/** @private */
		public var prev:WVector;
		/** @private */
		public var isColliding:Boolean;
		/** @private */
		public var interval:WInterval;

		public var name:String;
		
		private var forces:WVector;
		private var temp:WVector;
		
		private var _kfr:Number;
		private var _mass:Number;
		private var _invMass:Number;
		private var _fixed:Boolean;
		private var _friction:Number;
		private var _collidable:Boolean;
		private var collision:WCollision;
		private var _WOWEngine:WOWEngine;
		
		public static const MIN_MASS:Number = 0.0001;
		/** 
		 * @private
		 */
		public function WParticle (
				x:Number=0, 
				y:Number=0, 
				z:Number=0, 
				isFixed:Boolean=true, 
				mass:Number=1, 
				elasticity:Number=0.3,
				friction:Number=0) {
		
			interval = new WInterval(0,0);
			
			curr = new WVector(x, y,z);
			prev = new WVector(x, y,z);
			temp = new WVector(0,0,0);
			fixed = isFixed;
			
			forces = new WVector(0,0,0);
			collision = new WCollision(new WVector(0,0,0), new WVector(0,0,0));
			isColliding = false;
			
			this.mass = mass;
			this.elasticity = elasticity;
			this.friction = friction;
			
			collidable = true;
			
		}
	
		public function get engine():WOWEngine {
			return _WOWEngine; 
		}
		
		
		public function set engine(e:WOWEngine):void {
			_WOWEngine=e
		}
		/**
		 * The mass of the particle. Valid values are greater than zero. By default, all particles
		 * have a mass of 1. 
		 * 
		 * <p>
		 * The mass property has no relation to the size of the particle. However it can be
		 * easily simulated when creating particles. A simple example would be to set the 
		 * mass and the size of a particle to same value when you instantiate it.
		 * </p>
		 * @throws flash.errors.Error flash.errors.Error if the mass is set less than zero. 
		 */
		public function get mass():Number {
			return _mass; 
		}
		
		
		/**
		 * @private
		 */
		public function set mass(m:Number):void {
			_mass = Math.max(m,MIN_MASS);
			_invMass = 1 / _mass;
		}	
	
		
		/**
		 * The elasticity of the particle. Standard values are between 0 and 1. 
		 * The higher the value, the greater the elasticity.
		 * 
		 * <p>
		 * During collisions the elasticity values are combined. If one particle's
		 * elasticity is set to 0.4 and the other is set to 0.4 then the collision will
		 * be have a total elasticity of 0.8. The result will be the same if one particle
		 * has an elasticity of 0 and the other 0.8.
		 * </p>
		 * 
		 * <p>
		 * Setting the elasticity to greater than 1 (of a single particle, or in a combined
		 * collision) will cause particles to bounce with energy greater than naturally 
		 * possible. Setting the elasticity to a value less than zero is allowed but may cause 
		 * unexpected results.
		 * </p>
		 */ 
		public function get elasticity():Number {
			return _kfr; 
		}
		
		
		/**
		 * @private
		 */
		public function set elasticity(k:Number):void {
			_kfr = k;
		}
		

				
		/**
		 * The surface friction of the particle. Values must be in the range of 0 to 1.
		 * 
		 * <p>
		 * 0 is no friction (slippery), 1 is full friction (sticky).
		 * </p>
		 * 
		 * <p>
		 * During collisions, the friction values are summed, but are clamped between 1 and 0.
		 * For example, If two particles have 0.7 as their surface friction, then the resulting
		 * friction between the two particles will be 1 (full friction).
		 * </p>
		 * 
		 * <p>
		 * Note: In the current release, only dynamic friction is calculated. Static friction
		 * is planned for a later release.
		 * </p>
		 * 
		 * @throws flash.errors.Error flash.errors.Error if the friction is set less than zero or greater than 1
		 */	
		public function get friction():Number {
			return _friction; 
		}
	
		
		/**
		 * @private
		 */
		public function set friction(f:Number):void {
			_friction = Math.max(Math.min(f,1),0);
		}
		
		
		/**
		 * The fixed state of the particle. If the particle is fixed, it does not move
		 * in response to forces or collisions. Fixed particles are good for surfaces.
		 */
		public function get fixed():Boolean {
			return _fixed;
		}

 
		/**
		 * @private
		 */
		public function set fixed(f:Boolean):void {
			_fixed = f;
		}
		
		
		/**
		 * The position of the particle. Getting the position of the particle is useful
		 * for drawing it or testing it for some custom purpose. 
		 * 
		 * <p>
		 * When you get the <code>position</code> of a particle you are given a copy of the current
		 * location. Because of this you cannot change the position of a particle by
		 * altering the <code>x</code> and <code>y</code> components of the Vector you have retrieved from the position property.
		 * You have to do something instead like: <code> position = new Vector(100,100)</code>, or
		 * you can use the <code>px</code> and <code>py</code> properties instead.
		 * </p>
		 * 
		 * <p>
		 * You can alter the position of a particle three ways: change its position, set
		 * its velocity, or apply a force to it. Setting the position of a non-fixed particle
		 * is not the same as setting its fixed property to true. A particle held in place by 
		 * its position will behave as if it's attached there by a 0 length sprint constraint. 
		 * </p>
		 */
		public function get position():WVector {
			return WVectorMath.clone(curr);
		}
		
		
		/**
		 * @private
		 */
 		public function set position(p:WVector):void {
			curr=WVectorMath.clone(p);
			prev=WVectorMath.clone(p);
		}

	
		/**
		 * The x position of this particle
		 */
		public function get px():Number {
			return curr.x;
		}

		
		/**
		 * @private
		 */
		public function set px(x:Number):void {
			curr.x = x;
			prev.x = x;	
		}


		/**
		 * The y position of this particle
		 */
		public function get py():Number {
			return curr.y;
		}


		/**
		 * @private
		 */
		public function set py(y:Number):void {
			curr.y = y;
			prev.y = y;	
		}


		/**
		 * The y position of this particle
		 */
		public function get pz():Number {
			return curr.z;
		}


		/**
		 * @private
		 */
		public function set pz(z:Number):void {
			curr.z = z;
			prev.z = z;	
		}
		/**
		 * The velocity of the particle. If you need to change the motion of a particle, 
		 * you should either use this property, or one of the addForce methods. Generally,
		 * the addForce methods are best for slowly altering the motion. The velocity property
		 * is good for instantaneously setting the velocity, e.g., for projectiles.
		 * 
		 */

		public function get velocity():WVector {
			return WVectorMath.sub(curr,prev);
		}
		
		
		/**
		 * @private
		 */	
		public function set velocity(v:WVector):void {
			prev =WVectorMath.sub(curr,v);
			
		}
		
		
		/**
		 * Determines if the particle can collide with other particles or constraints.
		 * The default state is true.
		 */
		public function get collidable():Boolean {
			return _collidable;
		}
	
				
		/**
		 * @private
		 */		
		public function set collidable(b:Boolean):void {
			_collidable = b;
		}
		
			
		// NEED REMOVE FORCES METHODS
		/**
		 * Adds a force to the particle. The mass of the particle is taken into 
		 * account when using this method, so it is useful for adding forces 
		 * that simulate effects like wind. Particles with larger masses will
		 * not be affected as greatly as those with smaller masses. Note that the
		 * size (not to be confused with mass) of the particle has no effect 
		 * on its physical behavior.
		 * 
		 * @param f A Vector represeting the force added.
		 */ 
		public function addForce(f:WVector):void {

			var f:WVector=WVectorMath.scale(f,invMass)
			forces=WVectorMath.addVector(forces,f);
			//forces.plusEquals(f.multEquals(invMass));
		}
		
		
		/**
		 * Adds a 'massless' force to the particle. The mass of the particle is 
		 * not taken into account when using this method, so it is useful for
		 * adding forces that simulate effects like gravity. Particles with 
		 * larger masses will be affected the same as those with smaller masses.
		 *
		 * @param f A Vector represeting the force added.
		 */ 	
		public function addMasslessForce(f:WVector):void {
			//forces.plusEquals(f);
			forces=WVectorMath.addVector(forces,f);
		}
		
		
		/**
		 * @private
		 */
		public function update(dt2:Number):void {
			
			if (fixed) return;
			
			// global forces
			addForce(engine.force);
			addMasslessForce(engine.masslessForce);
	
			// integrate
			//temp.copy(curr);
			temp=WVectorMath.clone(curr);
			forces=WVectorMath.scale(forces,dt2)
			var nv:WVector =WVectorMath.addVector(velocity,forces);
			//var nv:Vector = velocity.plus(forces.multEquals(dt2));
			//nv.multEquals(0.98);
			nv=WVectorMath.scale(nv,0.98)
			nv=WVectorMath.scale(nv,engine.damping)
			curr=WVectorMath.addVector(curr,nv);
			//curr.plusEquals(nv.multEquals(WOWEngine.damping));
			prev=WVectorMath.clone(temp);
			//prev.copy(temp);
		
			// clear the forces
			forces=new WVector(0,0,0);
		}
		
		
		/**
		 * @private
		 */		
		public function getComponents(collisionNormal:WVector):WCollision {
			var vel:WVector =velocity;
			var vdotn:Number = WVectorMath.dot(collisionNormal,vel);
			
			//var vdotn:Number = collisionNormal.dot(vel);
			collision.vn = WVectorMath.scale(collisionNormal,vdotn);
			//collision.vn = collisionNormal.mult(vdotn);
			collision.vt = WVectorMath.sub(vel,collision.vn);
			//collision.vt = vel.minus(collision.vn);	
			return collision;
		}
	
	
		/**
		 * @private
		 */	
		public function resolveCollision(mtd:WVector, vel:WVector, n:WVector, d:Number, o:Number):void {
			curr=WVectorMath.addVector(curr,mtd);
			//curr.plusEquals(mtd);
		
			switch (engine.collisionResponseMode) {
				
				case engine.STANDARD:
					velocity = vel;
					break;
				
				case engine.SELECTIVE:
					if (! isColliding) velocity = vel;
					isColliding = true;
					break;
					
				case engine.SIMPLE:
					break;
			}
		}
		
		
		/**
		 * @private
		 */		
		public function get invMass():Number {
			return _invMass; 
		}
		
		
		/**
		 * @private
		 */		
		public function getProjection(axis:WVector):WInterval {
			return null;
		}
	}	
}