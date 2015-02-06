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
package fr.seraf.wow.core.face {
		
	import fr.seraf.wow.core.data.WVector;
	import flash.geom.Matrix;



	/**
	* Face
	*  
	* @author		Thomas Pfeiffer - kiroukou
	* @version		1.0
	* @date 		12.01.2006
	* 
	**/
	public interface WIPolygon
	{

		/**
		* create the normal vector of the Face
		* <p>This method must be called when a face is created. Quite often a single normal vector is used for many faces
		* , so in this case, use {@link sandy.core.face.IPolygon#setNotmale(Vertex)}</p>
		* <p>A vertex is returned rather than a {@link mb.sandy.core.data.Vector4} because it migth be useful to have it transform coordinates.</p>
		* 
		* @return	Vertex	the normal vector
		*/
		function createNormale():WVector;
		

		


		
		/**
		* Set the normale vector of the face. Useful when the normale for this face is alleady computed
		* <p>This method is called mainly in primitives, when th object is created. It can saves some CPU calculations when somes faces have the same normale vector</p>
		* <p>{@code n} represent the normale vector, but here as a Vertex, because the Vertex class is used in the engine.
		* @param	n		the normal Vector
		*/
		function setNormale( n:WVector ):void;



		
		/**
		* Allows you to get the vertex of the face. Very usefull when you want to make some calculation on a face after it has been clicked.
		* @param	void
		* @return Array The array of vertex.
		*/
		function getVertices():Array;

	}
}