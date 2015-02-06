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
package fr.seraf.wow.math {
		
	import fr.seraf.wow.core.data.WMatrix4;
	import fr.seraf.wow.core.data.WVector;
	import fr.seraf.wow.util.WNumberUtil;
	import fr.seraf.wow.math.WFastMath;

	/**
	* Math functions for {@link Matrix4}.
	* @author		Thomas Pfeiffer - kiroukou
	* @since		0.1
	* @version		0.2
	* @date 		12.01.2006
	* 
	**/
	public class WMatrix4Math
	{
		/**
		 * Compute the multiplication of 2 {@code Matrix4} but as they were 3x3 matrix.
		 *
		 * @param {@code m1} a {@code Matrix}.
		 * @param {@code m2} a {@code Matrix}.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function multiply3x3(m1:WMatrix4, m2:WMatrix4) : WMatrix4 
		{
			var dest : WMatrix4 = WMatrix4.createIdentity();
			var m111:Number = m1.n11; var m211:Number = m2.n11;
			var m121:Number = m1.n21; var m221:Number = m2.n21;
			var m131:Number = m1.n31; var m231:Number = m2.n31;
			var m112:Number = m1.n12; var m212:Number = m2.n12;
			var m122:Number = m1.n22; var m222:Number = m2.n22;
			var m132:Number = m1.n32; var m232:Number = m2.n32;
			var m113:Number = m1.n13; var m213:Number = m2.n13;
			var m123:Number = m1.n23; var m223:Number = m2.n23;
			var m133:Number = m1.n33; var m233:Number = m2.n33;
			
			dest.n11 = m111 * m211 + m112 * m221 + m113 * m231;
			dest.n12 = m111 * m212 + m112 * m222 + m113 * m232;
			dest.n13 = m111 * m213 + m112 * m223 + m113 * m233;

			dest.n21 = m121 * m211 + m122 * m221 + m123 * m231;
			dest.n22 = m121 * m212 + m122 * m222 + m123 * m232;
			dest.n23 = m121 * m213 + m122 * m223 + m123 * m233;

			dest.n31 = m131 * m211 + m132 * m221 + m133 * m231;
			dest.n32 = m131 * m212 + m132 * m222 + m133 * m232;
			dest.n33 = m131 * m213 + m132 * m223 + m133 * m233;
		
			return dest;
		}
		
		
		public static function multiply4x3( m1:WMatrix4, m2:WMatrix4 ):WMatrix4
		{
			var dest : WMatrix4 = WMatrix4.createIdentity();
			var m111:Number = m1.n11; var m211:Number = m2.n11;
			var m121:Number = m1.n21; var m221:Number = m2.n21;
			var m131:Number = m1.n31; var m231:Number = m2.n31;
			var m112:Number = m1.n12; var m212:Number = m2.n12;
			var m122:Number = m1.n22; var m222:Number = m2.n22;
			var m132:Number = m1.n32; var m232:Number = m2.n32;
			var m113:Number = m1.n13; var m213:Number = m2.n13;
			var m123:Number = m1.n23; var m223:Number = m2.n23;
			var m133:Number = m1.n33; var m233:Number = m2.n33;
			var m214:Number = m2.n14; 
			var m224:Number = m2.n24; 
			var m234:Number = m2.n34; 
			
			dest.n11 = m111 * m211 + m112 * m221 + m113 * m231;
			dest.n12 = m111 * m212 + m112 * m222 + m113 * m232;
			dest.n13 = m111 * m213 + m112 * m223 + m113 * m233;

			dest.n21 = m121 * m211 + m122 * m221 + m123 * m231;
			dest.n22 = m121 * m212 + m122 * m222 + m123 * m232;
			dest.n23 = m121 * m213 + m122 * m223 + m123 * m233;

			dest.n31 = m131 * m211 + m132 * m221 + m133 * m231;
			dest.n32 = m131 * m212 + m132 * m222 + m133 * m232;
			dest.n33 = m131 * m213 + m132 * m223 + m133 * m233;
			
			dest.n14 = m214 * m111 + m224 * m112 + m234 * m113 + m1.n14;
			dest.n24 = m214 * m121 + m224 * m122 + m234 * m123 + m1.n24;
			dest.n34 = m214 * m131 + m224 * m132 + m234 * m133 + m1.n34;
			
			return dest;
		}

		
		/**
		 * Compute the multiplication of 2 {@code Matrix4}.
		 *
		 * @param {@code m1} a {@code Matrix}.
		 * @param {@code m2} a {@code Matrix}.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function multiply(m1:WMatrix4, m2:WMatrix4) : WMatrix4 
		{
			var dest:WMatrix4 = WMatrix4.createIdentity();
			var m111:Number, m211:Number, m121:Number, m221:Number, m131:Number, m231:Number, m141:Number, m241:Number;
			var m112:Number, m212:Number, m122:Number, m222:Number, m132:Number, m232:Number, m142:Number, m242:Number;
			var m113:Number, m213:Number, m123:Number, m223:Number, m133:Number, m233:Number, m143:Number, m243:Number;
			var m114:Number, m214:Number, m124:Number, m224:Number, m134:Number, m234:Number, m144:Number, m244:Number;

			dest.n11 = (m111=m1.n11) * (m211=m2.n11) + (m112=m1.n12) * (m221=m2.n21) + (m113=m1.n13) * (m231=m2.n31) + (m114=m1.n14) * (m241=m2.n41);
			dest.n12 = m111 * (m212=m2.n12) + m112 * (m222=m2.n22) + m113 * (m232=m2.n32) + m114 * (m242=m2.n42);
			dest.n13 = m111 * (m213=m2.n13) + m112 * (m223=m2.n23) + m113 * (m233=m2.n33) + m114 * (m243=m2.n43);
			dest.n14 = m111 * (m214=m2.n14) + m112 * (m224=m2.n24) + m113 * (m234=m2.n34) + m114 * (m244=m2.n44);

			dest.n21 = (m121=m1.n21) * m211 + (m122=m1.n22) * m221 + (m123=m1.n23) * m231 + (m124=m1.n24) * m241;
			dest.n22 = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
			dest.n23 = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
			dest.n24 = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;

			dest.n31 = (m131=m1.n31) * m211 + (m132=m1.n32) * m221 + (m133=m1.n33) * m231 + (m134=m1.n34) * m241;
			dest.n32 = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
			dest.n33 = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
			dest.n34 = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;

			dest.n41 = (m141=m1.n41) * m211 + (m142=m1.n42) * m221 + (m143=m1.n43) * m231 + (m144=m1.n44) * m241;
			dest.n42 = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
			dest.n43 = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
			dest.n44 = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;

			return dest;
		}
		
		/**
		 * Compute an addition {@code Matrix4}.
		 *
		 * @param {@code m1} Matrix to add.
		 * @param {@code m2} Matrix to add.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function addMatrix(m1:WMatrix4, m2:WMatrix4): WMatrix4
		{
			var dest : WMatrix4 = WMatrix4.createIdentity();
			dest.n11 = m1.n11 + m2.n11; dest.n12 = m1.n12 + m2.n12;
			dest.n13 = m1.n13 + m2.n13;	dest.n14 = m1.n14 + m2.n14;
			dest.n21 = m1.n21 + m2.n21;	dest.n22 = m1.n22 + m2.n22;	
			dest.n23 = m1.n23 + m2.n23;	dest.n24 = m1.n24 + m2.n24;
			dest.n31 = m1.n31 + m2.n31;	dest.n32 = m1.n32 + m2.n32;	
			dest.n33 = m1.n33 + m2.n33;	dest.n34 = m1.n34 + m2.n34;
			dest.n41 = m1.n41 + m2.n41;	dest.n42 = m1.n42 + m2.n42;	
			dest.n43 = m1.n43 + m2.n43;	dest.n44 = m1.n44 + m2.n44;
			return dest;
		}
		
		/**
		 * Compute a clonage {@code Matrix4}.
		 *
		 * @param {@code m1} Matrix to clone.
		 * @return The result of clonage : a {@code Matrix4}.
		 */
		public static function clone(m:WMatrix4):WMatrix4
		{
			return new WMatrix4(	m.n11,m.n12,m.n13,m.n14,
								m.n21,m.n22,m.n23,m.n24,
								m.n31,m.n32,m.n33,m.n34,
								m.n41,m.n42,m.n43,m.n44
							   );
		}
		
		/**
		 * Compute a multiplication of a vertex and the matrix{@code Matrix4}.
		 *
		 * @param {@code m} Matrix4.
		 * @param {@code v} Vertex
		 * @return void
		 */    
		public static function vectorMult( m:WMatrix4, v:WVector ): void
		{
			var vx:Number,vy:Number,vz:Number;
			v.x =	(vx=v.x) * m.n11 + (vy=v.y) * m.n12 + (vz=v.z) * m.n13 + m.n14;
			v.y = 	vx * m.n21 + vy * m.n22 + vz * m.n23 + m.n24;
			v.z = 	vx * m.n31 + vy * m.n32 + vz * m.n33 + m.n34;
		}

		/**
		 * Compute a multiplication of a vector and the matrix{@code Matrix4} 
		 *    as there were of 3 dimensions.
		 *
		 * @param {@code m} Matrix4.
		 * @param {@code v} Vector
		 * @return void
		 */
		public static function vectorMult3x3( m:WMatrix4, v:WVector ): void
		{
			var vx:Number, vy:Number, vz:Number; 
			v.x =	(vx=v.x) * m.n11 + (vy=v.y) * m.n12 + (vz=v.z) * m.n13;
			v.y = 	vx * m.n21 + vy * m.n22 + vz * m.n23;
			v.z = 	vx * m.n31 + vy * m.n32 + vz * m.n33;
		}
		
		/**
		* Compute the projection of a vector with a projection matrix.
		* The result gives a 2 dimension point represented by the x and y properties of the vector (z is null).
		* Be carefull: The passed matrix MUST be a PROJECTION matrix.
		* @param	mp MAtrix4 The projection matrix which will project the point from a 3D space to a 2D space.
		* @param	v The vector to project. Properties will be modified!
		*/
		public static function projectVector( mp:WMatrix4, v:WVector ):void
		{
			// computations for projection
			var c:Number = 	1 / ( v.x * mp.n41 + v.y * mp.n42 + v.z * mp.n43 + mp.n44 );
			WMatrix4Math.vectorMult( mp, v );
			// we give coordinate to screen
			v.x = v.x * c;
			v.y = v.y * c;
			v.z = 0;
		}
			
		/**
		 * Compute a Rotation {@code Matrix4} from the Euler angle in degrees unit.
		 *
		 * @param {@code ax} angle of rotation around X axis in degree.
		 * @param {@code ay} angle of rotation around Y axis in degree.
		 * @param {@code az} angle of rotation around Z axis in degree.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function eulerRotation ( ax:Number, ay:Number, az:Number ) : WMatrix4
		{
			var m:WMatrix4 = WMatrix4.createIdentity();
			ax = WNumberUtil.toRadian(ax) ; ay = WNumberUtil.toRadian(ay); az = WNumberUtil.toRadian(az);
			var a:Number = WFastMath.cos( ax );//_aCos[int(ax)] ;
			var b:Number = WFastMath.sin( ax );//_aSin[int(ax)]	;
			var c:Number = WFastMath.cos( ay );//_aCos[int(ay)]	;
			var d:Number = WFastMath.sin( ay );//_aSin[int(ay)]	;
			var e:Number = WFastMath.cos( az );//_aCos[int(az)]	;
			var f:Number = WFastMath.sin( az );//_aSin[int(az)]	;
			var ad:Number = a * d	;
			var bd:Number = b * d	;

			m.n11 =   c  * e         ;
			m.n12 = - c  * f         ;
			m.n13 =   d              ;
			m.n21 =   bd * e + a * f ;
			m.n22 = - bd * f + a * e ;
			m.n23 = - b  * c 	 ;
			m.n31 = - ad * e + b * f ;
			m.n32 =   ad * f + b * e ;
			m.n33 =   a  * c         ;
			// unused because loaded as an identity matrix allready.
			// m.n14 = m.n24 = m.n34 = m.n41= m.n42 = m.n43 = 0;
			// m.n44 = 1;
			return m;
		}
		
		/**
		 * 
		 * @param angle Number angle of rotation in degrees
		 * @return the computed matrix
		 */
		public static function rotationX ( angle:Number ):WMatrix4
		{
			var m:WMatrix4 = WMatrix4.createIdentity();
			var c:Number = _aCos[int(angle)] ;
			var s:Number = _aSin[int(angle)] ;
			m.n22 =  c;
			m.n23 =  s;
			m.n32 = -s;
			m.n33 =  c;
			return m;
		}
		
		/**
		 * 
		 * @param angle Number angle of rotation in degrees
		 * @return the computed matrix
		 */
		public static function rotationY ( angle:Number ):WMatrix4
		{
			var m:WMatrix4 = WMatrix4.createIdentity();
			var c:Number = _aCos[int(angle)] ;
			var s:Number = _aSin[int(angle)] ;
			m.n11 =  c;
			m.n13 = -s;
			m.n31 =  s;
			m.n33 =  c;
			return m;
		}
		
		/**
		 * 
		 * @param angle Number angle of rotation in degrees
		 * @return the computed matrix
		 */
		public static function rotationZ ( angle:Number ):WMatrix4
		{
			var m:WMatrix4 = WMatrix4.createIdentity();
			var c:Number = _aCos[int(angle)] ;
			var s:Number = _aSin[int(angle)] ;
			m.n11 =  c;
			m.n12 =  s;
			m.n21 = -s;
			m.n22 =  c;
			return m;
		}
		
		/**
		 * Compute a Rotation around a Vector which represents the axis of rotation{@code Matrix4}.
		 *
		 * @param {@code v} The axis of rotation
		 * @param The angle of rotation in degree
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function axisRotationVector ( v:WVector, angle:Number ) : WMatrix4
		{
			return WMatrix4Math.axisRotation( v.x, v.y, v.z, angle );
		}
		
		/**
		 * Compute a Rotation around an axis{@code Matrix4}.
		 *
		 * @param {@code nRotX} rotation X.
		 * @param {@code nRotY} rotation Y.
		 * @param {@code nRotZ} rotation Z.
		 * @param The angle of rotation in degree
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function axisRotation ( u:Number, v:Number, w:Number, angle:Number ) : WMatrix4
		{
			var m:WMatrix4 	= WMatrix4.createIdentity();
			angle = WNumberUtil.toRadian( angle );
			// -- modification pour verifier qu'il n'y ai pas un probleme de precision avec la camera
			var nCos:Number	= Math.cos( angle );
			var nSin:Number	= Math.sin( angle );
			var scos:Number	= 1 - nCos ;

			var suv	:Number = u * v * scos ;
			var svw	:Number = v * w * scos ;
			var suw	:Number = u * w * scos ;
			var sw	:Number = nSin * w ;
			var sv	:Number = nSin * v ;
			var su	:Number = nSin * u ;
			
			m.n11  =   nCos + u * u * scos	;
			m.n12  = - sw 	+ suv 			;
			m.n13  =   sv 	+ suw			;

			m.n21  =   sw 	+ suv 			;
			m.n22  =   nCos + v * v * scos 	;
			m.n23  = - su 	+ svw			;

			m.n31  = - sv	+ suw 			;
			m.n32  =   su	+ svw 			;
			m.n33  =   nCos	+ w * w * scos	;

			return m;
		}
		
		/**
		 * Compute a translation {@code Matrix4}.
		 * 
		 * <pre>
		 * |1  0  0  0|
		 * |0  1  0  0|
		 * |0  0  1  0|
		 * |Tx Ty Tz 1|
		 * </pre>
		 * 
		 * @param {@code nTx} translation X.
		 * @param {@code nTy} translation Y.
		 * @param {@code nTz} translation Z.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function translation(nTx:Number, nTy:Number, nTz:Number) : WMatrix4 
		{
			var m : WMatrix4 = WMatrix4.createIdentity();
			m.n14 = nTx;
			m.n24 = nTy;
			m.n34 = nTz;
			return m;
		}

		/**
		 * Compute a translation from a vector {@code Matrix4}.
		 * 
		 * <pre>
		 * |1  0  0  0|
		 * |0  1  0  0|
		 * |0  0  1  0|
		 * |Tx Ty Tz 1|
		 * </pre>
		 * 
		 * @param {@code v} translation Vector.
		 * @return The result of computation : a {@code Matrix4}.
		 */
		public static function translationVector( v:WVector ) : WMatrix4 
		{
			var m : WMatrix4 = WMatrix4.createIdentity();
			m.n14 = v.x;
			m.n24 = v.y;
			m.n34 = v.z;
			return m;
		}
		
		/**
		 * Compute a scale {@code Matrix4}.
		 * 
		 * <pre>
		 * |Sx 0  0  0|
		 * |0  Sy 0  0|
		 * |0  0  Sz 0|
		 * |0  0  0  1|
		 * </pre>
		 *
		 * @param {@code nRotX} translation X.
		 * @param {@code nRotY} translation Y.
		 * @param {@code nRotZ} translation Z.
		 * @return The result of computation : a {@code Matrix}.
		 */
		public static function scale(nXScale:Number, nYScale:Number, nZScale:Number) : WMatrix4 
		{
			var matScale : WMatrix4 = WMatrix4.createIdentity();
			matScale.n11 = nXScale;
			matScale.n22 = nYScale;
			matScale.n33 = nZScale;
			return matScale;
		}
		
		/**
		 * Compute a scale {@code Matrix4}.
		 * 
		 * <pre>
		 * |Sx 0  0  0|
		 * |0  Sy 0  0|
		 * |0  0  Sz 0|
		 * |0  0  0  1|
		 * </pre>
		 *
		 * @param {@code Vector} The vector containing the scale values
		 * @return The result of computation : a {@code Matrix}.
		 */
		public static function scaleVector( v:WVector) : WMatrix4 
		{
			var matScale : WMatrix4 = WMatrix4.createIdentity();
			matScale.n11 = v.x;
			matScale.n22 = v.y;
			matScale.n33 = v.z;
			return matScale;
		}
			
		/**
		* Compute the determinant of the 4x4 square matrix
		* @param m a Matrix4
		* @return Number the determinant
		*/
		public static function det( m:WMatrix4 ):Number
		{
			return	(m.n11 * m.n22 - m.n21 * m.n12) * (m.n33 * m.n44 - m.n43 * m.n34)- (m.n11 * m.n32 - m.n31 * m.n12) * (m.n23 * m.n44 - m.n43 * m.n24)
					 + 	(m.n11 * m.n42 - m.n41 * m.n12) * (m.n23 * m.n34 - m.n33 * m.n24)+ (m.n21 * m.n32 - m.n31 * m.n22) * (m.n13 * m.n44 - m.n43 * m.n14)
					 - 	(m.n21 * m.n42 - m.n41 * m.n22) * (m.n13 * m.n34 - m.n33 * m.n14)+ (m.n31 * m.n42 - m.n41 * m.n32) * (m.n13 * m.n24 - m.n23 * m.n14);

		}
		
		public static function det3x3( m:WMatrix4 ):Number
		{	
			return m.n11 * ( m.n22 * m.n33 - m.n23 * m.n32 ) + m.n21 * ( m.n32 * m.n13 - m.n12 * m.n33 ) + m.n31 * ( m.n12 * m.n23 - m.n22 * m.n13 );
		}


		/**
		 * Computes the trace of the matrix.
		 * @param m Matrix4 The matrix we want to compute the trace
		 * @return The trace value which is the sum of the element on the diagonal
		 */
		public static function getTrace( m:WMatrix4 ):Number
		{
			return m.n11 + m.n22 + m.n33 + m.n44;
		}
		
		/**
		* Return the inverse of the matrix passed in parameter.
		* @param m The matrix4 to inverse
		* @return Matrix4 The inverse Matrix4
		*/
		public static function getInverse( m:WMatrix4 ):WMatrix4
		{
			//take the determinant
			var d:Number = WMatrix4Math.det( m );
			if( Math.abs(d) < 0.001 )
			{
				//We cannot invert a matrix with a null determinant
				return null;
			}
			//We use Cramer formula, so we need to devide by the determinant. We prefer multiply by the inverse
			d = 1/d;
			var m11:Number = m.n11;var m21:Number = m.n21;var m31:Number = m.n31;var m41:Number = m.n41;
			var m12:Number = m.n12;var m22:Number = m.n22;var m32:Number = m.n32;var m42:Number = m.n42;
			var m13:Number = m.n13;var m23:Number = m.n23;var m33:Number = m.n33;var m43:Number = m.n43;
			var m14:Number = m.n14;var m24:Number = m.n24;var m34:Number = m.n34;var m44:Number = m.n44;
			return new WMatrix4 (
				d * ( m22*(m33*m44 - m43*m34) - m32*(m23*m44 - m43*m24) + m42*(m23*m34 - m33*m24) ),
				-d* ( m12*(m33*m44 - m43*m34) - m32*(m13*m44 - m43*m14) + m42*(m13*m34 - m33*m14) ),
				d * ( m12*(m23*m44 - m43*m24) - m22*(m13*m44 - m43*m14) + m42*(m13*m24 - m23*m14) ),
				-d* ( m12*(m23*m34 - m33*m24) - m22*(m13*m34 - m33*m14) + m32*(m13*m24 - m23*m14) ),
				-d* ( m21*(m33*m44 - m43*m34) - m31*(m23*m44 - m43*m24) + m41*(m23*m34 - m33*m24) ),
				d * ( m11*(m33*m44 - m43*m34) - m31*(m13*m44 - m43*m14) + m41*(m13*m34 - m33*m14) ),
				-d* ( m11*(m23*m44 - m43*m24) - m21*(m13*m44 - m43*m14) + m41*(m13*m24 - m23*m14) ),
				d * ( m11*(m23*m34 - m33*m24) - m21*(m13*m34 - m33*m14) + m31*(m13*m24 - m23*m14) ),
				d * ( m21*(m32*m44 - m42*m34) - m31*(m22*m44 - m42*m24) + m41*(m22*m34 - m32*m24) ),
				-d* ( m11*(m32*m44 - m42*m34) - m31*(m12*m44 - m42*m14) + m41*(m12*m34 - m32*m14) ),
				d * ( m11*(m22*m44 - m42*m24) - m21*(m12*m44 - m42*m14) + m41*(m12*m24 - m22*m14) ),
				-d* ( m11*(m22*m34 - m32*m24) - m21*(m12*m34 - m32*m14) + m31*(m12*m24 - m22*m14) ),
				-d* ( m21*(m32*m43 - m42*m33) - m31*(m22*m43 - m42*m23) + m41*(m22*m33 - m32*m23) ),
				d * ( m11*(m32*m43 - m42*m33) - m31*(m12*m43 - m42*m13) + m41*(m12*m33 - m32*m13) ),
				-d* ( m11*(m22*m43 - m42*m23) - m21*(m12*m43 - m42*m13) + m41*(m12*m23 - m22*m13) ),
				d * ( m11*(m22*m33 - m32*m23) - m21*(m12*m33 - m32*m13) + m31*(m12*m23 - m22*m13) )
				);
		}
		
		
		/**
		 * Realize a rotation around a specific axis (the axis must be normalized!) and from an pangle degrees and around a specific position.
		 * @param pAxis A 3D Vector representing the axis of rtation. Must be normalized
		 * @param ref Vector The center of rotation as a 3D point.
		 * @param pAngle Number The angle of rotation in degrees.
		 */
		public static function axisRotationWithReference( axis:WVector, ref:WVector, pAngle:Number ):WMatrix4
		{
			var angle:Number = ( pAngle + 360 ) % 360;
			var m:WMatrix4 = WMatrix4Math.translation ( ref.x, -ref.y, ref.z );
			m = WMatrix4Math.multiply ( m, WMatrix4Math.axisRotation( axis.x, axis.y, axis.z, angle ));
			m = WMatrix4Math.multiply ( m, WMatrix4Math.translation ( -ref.x, ref.y, -ref.z ));
			return m;
		}

		
		/////////////
		// PRIVATE
		/////////////	
		private static var _aSin : Array = new Array(360);
		private static var _aCos : Array = new Array(360);
		private static var _bIsPrecalculed : Boolean = false;
		private static var _bMatrixExtends : Boolean = WMatrix4Math.preCalc();

		/**
		 * Constructor
		 */
		public function WMatrix4Math (singletonBlocker:WSingletonBlocker)
		{
			//empty
		}
		
		private static function preCalc() : Boolean 
		{
			if(_bIsPrecalculed) 
				return true;
			
			_bIsPrecalculed = true;
			
			for( var nAlpha:Number = 0; nAlpha < 360; nAlpha++ ) 
			{
				_aSin[nAlpha] = WFastMath.sin(nAlpha*Math.PI/180);
				_aCos[nAlpha] = WFastMath.cos(nAlpha*Math.PI/180);
			}
			return true;
		}
	}
}

class WSingletonBlocker {}