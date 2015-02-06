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
	
	import fr.seraf.wow.core.data.WVector;

	
	
	/**
	* Vertex of a 3D mesh.
	* 
	* <p>A vertex is a point which can be represented in differents coordinates. 
	* 	It leads to some extra properties specific to the vertex</p>
	* 
	* @author		Thomas Pfeiffer - kiroukou
	* @since		0.1
	* @version		1.0
	* @date 		15/12/2006
	*/
	public class WVertex extends WVector
	{
		/**
		* properties used to store transformed coordinates in the World coordinates
		*/
		public var wx:Number;
		public var wy:Number;
		public var wz:Number;
		
		/**
		* properties used to store transformed coordinates in screen World.
		*/ 
		public var sx:Number;
		public var sy:Number;
		public var sz:Number;
		
		/**
		* Create a new {@code Vertex} Instance.
		* If no
		* @param px the x position number
		* @param py the y position number
		* @param pz the z position number
		* 
		*/
		public function WVertex(px:Number = 0, py:Number = 0, pz:Number = 0)
		{
			super(px,py,pz);
			
			// -- 
			wx = px; 
			wy = py; 
			wz = pz;
			
			// --
			sy = sx = sz = 0;
		}
		
		/**
		* Returns a vector representing the vertex in the world coordinate
		* @param	void
		* @return	Vector	a Vector
		*/
		public function getWorldVector():WVector
		{
			return new WVector( wx, wy, wz );
		}
			
		/**
		* Get a String represntation of the {@code Vertex}.
		* 
		* @return	A String representing the {@code Vertex}.
		*/
		override public function toString():String
		{
			return getQualifiedClassName(this) + "(x:"+x+" y:"+y+" z:"+z+"\nwx:"+wx+" wy:"+wy+" wz:"+wz+"\nsx:" + sx + " sy:"+ sy + ", sz:" + sz +")";
		}
		
	}
}
