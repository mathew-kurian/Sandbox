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

package fr.seraf.wow.core.face{

	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;

	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.core.data.WVertex;
	import fr.seraf.wow.core.face.WIPolygon;
	import fr.seraf.wow.primitive.WOWPlane;
	import fr.seraf.wow.math.WVectorMath;

	public class WPolygon implements WIPolygon {
	
		private var _aVertex:Array;

		private var _nL:int;
		private var _nCL:int;
		private var _o:WOWPlane;// reference to is owner object
		/**
		 * Vertex representing the normal of the face!
		 */
		private var _vn:WVector;// Vertex containing the normal of the 


	
		public function WPolygon( oref:WOWPlane, ...rest) {
			_o = oref;


			//_s = _sb = undefined;
			_aVertex = rest;

			_nCL = _nL = _aVertex.length;
		
		}
		/**
		* Allows you to get the vertex of the face. Very usefull when you want to make some calculation on a face after it has been clicked.
		* @paramvoid
		* @return Array The array of vertex.
		*/
		public function getVertices():Array {
			return _aVertex;
		}
		/**
		* Get a String represntation of the {@code NFace3D}.
		* 
		* @returnA String representing the {@code NFace3D}.
		*/
		public function toString():String {
			return getQualifiedClassName(this) + " [Points: " + _aVertex.length +"]";
		}

		/**
		 * Create the normal vector of the face.
		 *
		 * @returnThe resulting {@code Vertex} corresponding to the normal.
		 */
		public function createNormale():WVector {
			if ( _nL > 2 ) {
				var v:WVector, w:WVector;
				var a:WVertex = _aVertex[0], b:WVertex = _aVertex[1], c:WVertex = _aVertex[2];
				v = new WVector( b.wx - a.wx, b.wy - a.wy, b.wz - a.wz );
				w = new WVector( b.wx - c.wx, b.wy - c.wy, b.wz - c.wz );
				// -- we compute de cross product
				_vn = WVectorMath.cross( v, w );//new Vector( (w.y * v.z) - (w.z * v.y) , (w.z * v.x) - (w.x * v.z) , (w.x * v.y) - (w.y * v.x) );
				// -- we normalize the resulting vector
				WVectorMath.normalize( _vn );
				// -- we return the resulting vertex
				return _vn;
			} else {
				return _vn=null;
			}
		}

		/**
		 * Set the normal vector of the face.
		 *
		 * @paramVertex
		 */
		public function setNormale( n:WVector ):void {
			_vn = n;
		}

	}
}