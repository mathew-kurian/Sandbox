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

package fr.seraf.wow.core.data {
	
	import flash.utils.getQualifiedClassName;
	
	/**
	* Point in a 4D world but very useful in 3D world too.
	* 
	* <p>A Point4 has got one more coordinate than the basic Point3D : w. This
	* can represent the time coordinate in a 3D world</p>
	*
	* @author		Thomas Pfeiffer - kiroukou
	* @author		Tabin Cédric - thecaptain
	* @author		Nicolas Coevoet - [ NikO ]
	* @since		0.1
	* @version		0.3
	* @date 		28.03.2006
	*/
	public class WVector
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;

		/**
		* <p>Create a new {@code Vector} Instance</p>
		* 
		* @param	px	the x coordinate
		* @param	py	the y coordinate
		* @param	pz	the z coordinate
		*/ 	
		public function WVector(px:Number = 0, py:Number = 0, pz:Number = 0)
		{
			x = px;
			y = py;
			z = pz;
		}
		
		
		/**
		* Get a String represntation of the {@code Vector}.
		* 
		* @return	A String representing the {@code Vector}.
		*/ 	
		public function toString():String
		{
			return getQualifiedClassName(this) + "("+x+","+y+","+z+ ")";
		}
	}

}