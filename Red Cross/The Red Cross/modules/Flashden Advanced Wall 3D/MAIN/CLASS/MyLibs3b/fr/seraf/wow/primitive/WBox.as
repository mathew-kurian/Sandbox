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

package fr.seraf.wow.primitive{

	import fr.seraf.wow.core.WOWEngine;
	import fr.seraf.wow.primitive.WSphere;
	import fr.seraf.wow.constraint.WSpringConstraint;
		/**
	* WBox
	*  
	* @authorJerome Birembaut - Seraf
	* @since0.1
	* @version0.1 pretty ugly
	* @date 12.01.2006 
	**/
	public class WBox {
		public var centerSphere:WSphere;
		public var coin0_0:WSphere;
		public var coin0_1:WSphere;
		public var coin0_2:WSphere;
		public var coin0_3:WSphere;
		public var coin1_0:WSphere;
		public var coin1_1:WSphere;
		public var coin1_2:WSphere;
		public var coin1_3:WSphere;
		public var size:Number;
		private var sphereArray:Array;
		private var springArray:Array;
		private var springDefArray:Array;
		public var springRotation:WSpringConstraint;
		public var springRotationZ:WSpringConstraint;
		
		/**
		* This is the constructor to call when you nedd to create a boundArea primitive.
		* @param x Number position x of the box
		* @param y Number position y  of the box
		* @param z Number position z  of the box
		* @param s Number size of the box
		*/
		public function WBox(x:Number,y:Number,z:Number,s:Number,engine:WOWEngine) {

			//box de 20 de coté
			size=s;
			sphereArray=new Array();
			springArray=new Array();
			springDefArray=new Array();
			centerSphere = new WSphere(x,y,z,size/2,false,0.5);
			centerSphere.name="centerSphere";
			engine.addParticle(centerSphere);
			//sphereArray.push(centerSphere);
			//calcule de l'hypotenuse pour deduire le rayon des spheres des coins du cube
			//var i:Number=Math.sqrt((size*size)*2)-size;//8.2

			var r:Number=size/8;


			coin0_0 = new WSphere(x-size/2+r,y+size/2-r,z-size/2+r,r,false,0.5);
			coin0_0.name="coin0_0";
			engine.addParticle(coin0_0);
			sphereArray.push(coin0_0);

			coin0_1 = new WSphere(x+size/2-r,y+size/2-r,z-size/2+r,r,false,0.5);
			coin0_1.name="coin0_1";
			engine.addParticle(coin0_1);
			sphereArray.push(coin0_1);

			coin0_2 = new WSphere(x+size/2-r,y-size/2+r,z-size/2+r,r,false,0.5);
			coin0_2.name="coin0_2";
			engine.addParticle(coin0_2);
			sphereArray.push(coin0_2);

			coin0_3 = new WSphere(x-size/2+r,y-size/2+r,z-size/2+r,r,false,0.5);
			coin0_3.name="coin0_3";
			engine.addParticle(coin0_3);
			sphereArray.push(coin0_3);
			///////////////////////////////////////////////////////////////////////////

			coin1_0 = new WSphere(x-size/2+r,y+size/2-r,z+size/2-r,r,false,0.5);
			coin1_0.name="coin1_0";
			engine.addParticle(coin1_0);
			sphereArray.push(coin1_0);

			coin1_1 = new WSphere(x+size/2-r,y+size/2-r,z+size/2-r,r,false,0.5);
			coin1_1.name="coin1_1";
			engine.addParticle(coin1_1);
			sphereArray.push(coin1_1);

			coin1_2 = new WSphere(x+size/2-r,y-size/2+r,z+size/2-r,r,false,0.5);
			coin1_2.name="coin1_2";
			engine.addParticle(coin1_2);
			sphereArray.push(coin1_2);

			coin1_3 = new WSphere(x-size/2+r,y-size/2+r,z+size/2-r,r,false,0.5);
			coin1_3.name="coin1_3";
			engine.addParticle(coin1_3);
			sphereArray.push(coin1_3);
			//////
			springRotationZ=new WSpringConstraint(coin0_1, coin0_2,0.5);
			springRotationZ.massAffected=false;
			engine.addConstraint(springRotationZ);
			springArray.push(springRotationZ);
			springDefArray[String(coin0_1.name+ coin0_2.name)] =true;
			springDefArray[String(coin0_2.name+coin0_1.name )] =true;
			var iComparaison:WSphere;
			for (var i:int=0; i<sphereArray.length; i++) {
				iComparaison=sphereArray[i];
				var spring:WSpringConstraint;
				for (var u:int=0; u<sphereArray.length; u++) {
					if (iComparaison != sphereArray[u] && springDefArray[String(iComparaison.name+ sphereArray[u].name)] == null && springDefArray[String(sphereArray[u].name+iComparaison.name )] == null) {
						spring=new WSpringConstraint(iComparaison, sphereArray[u],0.5);
						spring.massAffected=false;
						engine.addConstraint(spring);
						springArray.push(spring);
						springDefArray[String(iComparaison.name+ sphereArray[u].name)] =true;
						springDefArray[String(sphereArray[u].name+iComparaison.name )] =true;
					}
				}
			}
			springRotation=new WSpringConstraint(centerSphere, coin0_0,0.7);
			springRotation.massAffected=false;
			engine.addConstraint(springRotation);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin0_1,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin0_2,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin0_3,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin1_0,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin1_1,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin1_2,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);
			spring=new WSpringConstraint(centerSphere, coin1_3,0.7);
			spring.massAffected=false;
			engine.addConstraint(spring);
			springArray.push(spring);

		}
	}
}