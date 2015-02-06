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

	import flash.utils.*;

	
	/**
	* Plane representation in a 3D space. Used maily to represent the frustrum planes of the camera
	* This class is not used yet in Sandy.
	* @author		Thomas Pfeiffer - kiroukou
	* @since		0.3
	* @version		0.1
	* @date 		22.02.2006
	*/
	public class WPlane
	{
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;

		/**
		* <p>Create a new {@code Plane} Instance</p>
		* 
		* @param	a	the first plane coordinate
		* @param	b	the second plane coordinate
		* @param	c	the third plane coordinate
		* @param	d	the forth plane coordinate
		*/ 	
		public function WPlane( a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0 )
		{
			this.a = a; 
			this.b = b; 
			this.c = c; 
			this.d = d;
		}
		
		
		/**
		* Get a String represntation of the {@code Plane}.
		* 
		* @return	A String representing the {@code Plane}.
		*/ 	
		public function toString():String
		{
			return getQualifiedClassName(this) + "(a:"+a+", b:"+b+", c:"+c+", d:"+d+")";
		}
	}
}