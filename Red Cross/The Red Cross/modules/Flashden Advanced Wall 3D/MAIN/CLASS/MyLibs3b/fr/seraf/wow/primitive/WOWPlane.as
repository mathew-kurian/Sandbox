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

	import fr.seraf.wow.core.data.WPlane;
	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.core.data.WVertex;
	import fr.seraf.wow.core.face.WIPolygon;
	import fr.seraf.wow.core.face.WPolygon;
	import fr.seraf.wow.math.WPlaneMath;
	import fr.seraf.wow.math.WMatrix4Math;
	import fr.seraf.wow.math.WVectorMath;
	import fr.seraf.wow.core.data.WMatrix4;
	import fr.seraf.wow.primitive.WParticle;


	/**
	* VPlane
	*
	* @authorJerome Biremabut - Seraf
	* @authorThomas Pfeiffer - kiroukou
	* @authorTabin Cédric - thecaptain
	* @authorNicolas Coevoet - [ NikO ]
	* @since0.1
	* @version0.2
	* @date 12.01.2006 
	**/

	public class WOWPlane extends WParticle {
		private var _plane:WPlane;
		private var _h:Number;
		private var _lg:Number;
		private var _f:WIPolygon;
		private var _n:WVector;
		private var center:WVertex;
		private var rotation:WVector;
		private var aPoints:Array=new Array();
		private var _m:WMatrix4;
		private var _mPos:WMatrix4;
		private var _mRot:WMatrix4;
		/**
		* This is the constructor to call when you need to create an unlimited Plane primitive.
		* @param x Number position x of the box
		* @param y Number position y  of the box
		* @param z Number position z  of the box
		* @param rx Number rotation x of the box
		* @param ry Number rotation y of the box
		* @param rz Number rotation z of the box
		*/
		public function WOWPlane(x:Number =0, y:Number =0, z:Number = 0, rx:Number = 0, ry:Number = 0, rz:Number = 0) {
			super(0,0,0,true,10000,0,.1);
			generate();
			_mRot= WMatrix4.createIdentity();
			_mPos= WMatrix4.createIdentity();
			setRotation(rx,ry,rz);
			setPosition(x,y,z);
		}


		public function generate():void {
			//Creation of the points

			var p:WVertex;
			var id1:int,id2:int,id3:int;
			//stockage des vertex du polygone

			p = new WVertex(50*Math.cos(2*1*Math.PI/3),0,50*Math.sin(2*1*Math.PI/3));
			id1 = aPoints.push (p) - 1;
			p = new WVertex(50*Math.cos(2*2*Math.PI/3),0,50*Math.sin(2*2*Math.PI/3));
			id2 = aPoints.push (p) - 1;
			p = new WVertex(50*Math.cos(2*3*Math.PI/3),0,50*Math.sin(2*3*Math.PI/3));
			id3 = aPoints.push (p) - 1;
			center = new WVertex(0,0,0);
			aPoints.push (center) ;
			//polygone
			_f = new WPolygon(this, aPoints[int(id1)], aPoints[int(id3)], aPoints[int(id2)] );
			//normale du polygone
			//_n = _f.createNormale ();
			//_plane=new Plane(_n.x,_n.y,_n.z,0);
		}
		public function setRotation(rx:Number,ry:Number,rz:Number) {
			rx = ( rx + 360 ) % 360;
			ry = ( ry + 360 ) % 360;
			rz = ( rz + 360 ) % 360;
			//
			rotation=new WVector(rx,ry,rz);

			_mRot=WMatrix4Math.eulerRotation( rx,ry, rz );
			updateVertexPos();
		}
		public function setPosition(tx:Number,ty:Number,tz:Number) {
			position=new WVector(tx,ty,tz);
			_mPos = WMatrix4Math.translation ( tx, ty, tz );
			updateVertexPos();
		}
		private function updateVertexPos() {

			var m11:Number,m21:Number,m31:Number,m41:Number,m12:Number,m22:Number,m32:Number,m42:Number,m13:Number,m23:Number,m33:Number,m43:Number,m14:Number,m24:Number,m34:Number,m44:Number;

			var m:WMatrix4 =_mRot;
			m=WMatrix4Math.multiply(_mPos ,m);
			//
			m11 = m.n11;
			m21 = m.n21;
			m31 = m.n31;
			m41 = m.n41;
			m12 = m.n12;
			m22 = m.n22;
			m32 = m.n32;
			m42 = m.n42;
			m13 = m.n13;
			m23 = m.n23;
			m33 = m.n33;
			m43 = m.n43;
			m14 = m.n14;
			m24 = m.n24;
			m34 = m.n34;
			m44 = m.n44;

			var v:WVertex;
			var lp:int = aPoints.length;
			while ( --lp > -1 ) {
				v = aPoints[int(lp)];
				v.wx = v.x * m11 + v.y * m12 + v.z * m13 + m14;
				v.wy = v.x * m21 + v.y * m22 + v.z * m23 + m24;
				v.wz = v.x * m31 + v.y * m32 + v.z * m33 + m34;
			}
		_plane=WPlaneMath.computePlaneFromPoints(new WVector(aPoints[0].wx,aPoints[0].wy,aPoints[0].wz),new WVector(aPoints[1].wx,aPoints[1].wy,aPoints[1].wz),new WVector(aPoints[2].wx,aPoints[2].wy,aPoints[2].wz));

			  _plane.d=- _plane.d;
		}
		/**
		* Returns the position of the Object3D as a 3D vector.
		* The returned position in the position in the World frame, not the camera's one.
		* In case you want to get the position to a camera, you'll have to add its position to this vector with VectorMat::add eg.
		* @paramvoid
		* @returnVector the 3D position of the object
		*/
		public function setPlane(p:WPlane) {
			_plane=p;
		}

		public function getPlane():WPlane {
			return _plane;
		}
		public function getVertex():Array {
			return aPoints;
		}
		public function getNormale():WVector {
			return new WVector(_plane.a,_plane.b,_plane.c);
		}
	}

}