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
	* Matrix with 4 lines & 4 columns.
	*  
	* @author		Thomas Pfeiffer - kiroukou
	* @author		Tabin Cédric - thecaptain
	* @author		Nicolas Coevoet - [ NikO ]
	* @version		1.0
	* @date 		28.03.2006
	*/
	public class WMatrix4 
	{
		/**
		 * {@code Matrix4} cell.
		 * <p><code>1 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n11:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 1 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n12:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 1 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n13:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 1 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n14:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          1 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n21:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 1 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n22:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 1 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n23:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 1 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n24:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          1 0 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n31:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 1 0 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n32:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 1 0 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n33:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 1 <br>
		 *          0 0 0 0 </code></p>
		 */
		public var n34:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          1 0 0 0 </code></p>
		 */
		public var n41:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 1 0 0 </code></p>
		 */
		public var n42:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 1 0 </code></p>
		 */
		public var n43:Number;
		
		/**
		 * {@code Matrix4} cell.
		 * <p><code>0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 0 <br>
		 *          0 0 0 1 </code></p>
		 */
		public var n44:Number;
		
		/**
		 * Create a new {@code Matrix4}.
		 * <p>If 16 arguments are passed to the constructor, it will
		 * create a {@code Matrix4} with the values. In the other case,
		 * a identity {@code Matrix4} is created.</p>
		 * <code>var m:Matrix4 = new Matrix4();</code><br>
		 * <code>1 0 0 0 <br>
		 *       0 1 0 0 <br>
		 *       0 0 1 0 <br>
		 *       0 0 0 1 </code><br><br>
		 * <code>var m:Matrix4 = new Matrix4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
		 * 13, 14, 15, 16);</code><br>
		 * <code>1  2  3  4 <br>
		 *       5  6  7  8 <br>
		 *       9  10 11 12 <br>
		 *       13 14 15 16 </code>
		 */	
		public function WMatrix4(...rest) 
		{
			//TODO voir si on peut pas faire n11 = 1 || arguments[0] n12 = 0 || arguments[1] etc.
			if(rest.length == 16)
			{
				n11 = rest[0] ; n12 = rest[1] ; n13 = rest[2] ; n14 = rest[3] ;
				n21 = rest[4] ; n22 = rest[5] ; n23 = rest[6] ; n24 = rest[7] ;
				n31 = rest[8] ; n32 = rest[9] ; n33 = rest[10]; n34 = rest[11];
				n41 = rest[12]; n42 = rest[13]; n43 = rest[14]; n44 = rest[15];
			}
			else
			{
				n11 = n22 = n33 = n44 = 1;
				n12 = n13 = n14 = n21 = n23 = n24 = n31 = n32 = n34 = n41 = n42 = n43 = 0;
			}
		}
		
		/**
		* Create a new Identity Matrix4.
		* <p>An Identity Matrix4 is represented like that :</p>
		* <code>1 0 0 0 <br>
		*       0 1 0 0 <br>
		*       0 0 1 0 <br>
		*       0 0 0 1 </code>
		* 
		* @return	The new Identity Matrix4
		*/
		public static function createIdentity():WMatrix4
		{
			return new WMatrix4( 1, 0, 0, 0,
								0, 1, 0, 0,
								0, 0, 1, 0, 
								0, 0, 0, 1);
		}

		/**
		* Create a new Zero Matrix4.
		* <p>An zero Matrix4 is represented like that :</p>
		* <code>0 0 0 0 <br>
		*       0 0 0 0 <br>
		*       0 0 0 0 <br>
		*       0 0 0 0 </code>
		* 
		* @return	The new Identity Matrix4
		*/
		public static function createZero():WMatrix4
		{
			return new WMatrix4( 0, 0, 0, 0,
								0, 0, 0, 0,
								0, 0, 0, 0, 
								0, 0, 0, 0);
		}
		
		/**
		 * Get a string representation of the {@code Matrix4}.
		 *
		 * @return	A String representing the {@code Matrix4}.
		 */
		public function toString(): String
		{
			var s:String =  getQualifiedClassName(this) + "\n (";
			s += n11+"\t"+n12+"\t"+n13+"\t"+n14+"\n";
			s += n21+"\t"+n22+"\t"+n23+"\t"+n24+"\n";
			s += n31+"\t"+n32+"\t"+n33+"\t"+n34+"\n";
			s += n41+"\t"+n42+"\t"+n43+"\t"+n44+"\n)";
			return s;
		}
	}
}