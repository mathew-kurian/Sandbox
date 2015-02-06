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

package fr.seraf.wow.math
{
	/**
	* 	Fast trigonometry functions using cache table and precalculated data. 
	* 	Based on Michael Kraus implementation.
	* 
	* 	@author	Mirek Mencel	// miras@polychrome.pl
	* 	@date	01.02.2007
	*/
	public const WFastMath:_FastMath_ = _FastMath_.initialize();
}

import flash.utils.getTimer;

class _FastMath_ 
{
	private static var instance:_FastMath_;
	
	/** Precission. The bigger, the more entries in lookup table so the more accurate results. */
	public static var PRECISION:int = 0x100000;
	public static var TWO_PI:Number = 2*Math.PI;
	public static var HALF_PI:Number = Math.PI/2;
	
	/** Precalculated values with given precision */
	private static var sinTable:Array = new Array(PRECISION);
	private static var tanTable:Array = new Array(PRECISION);
	
	private static var RAD_SLICE:Number = TWO_PI / PRECISION;
	
	
	public static function initialize():_FastMath_
	{
		if (!instance) instance = new _FastMath_();
		
		return instance;
	}
	
	public function _FastMath_()
	{
		var timer:int = getTimer();
		var rad:Number = 0;

		for (var i:int = 0; i < PRECISION; i++) {
			rad = Number(i * RAD_SLICE);
			sinTable[i] = Number(Math.sin(rad));
			tanTable[i] = Number(Math.tan(rad));
		}
		
		trace("FastMath initialization time: " + (getTimer() - timer)); 
		
	}

	private function radToIndex(radians:Number):int 
	{
		return int( ((radians / TWO_PI) * PRECISION) & (PRECISION - 1) );
	}

	/**
	 * Returns the sine of a given value, by looking up it's approximation in a
	 * precomputed table.
	 * @param radians The value to sine.
	 * @return The approximation of the value's sine.
	 */
	public function sin(radians:Number):Number 
	{
		return sinTable[ radToIndex(radians) ];
	}

	/**
	 * Returns the cosine of a given value, by looking up it's approximation in a
	 * precomputed table.
	 * @param radians The value to cosine.
	 * @return The approximation of the value's cosine.
	 */
	public function cos(radians:Number ):Number 
	{
		return sinTable[radToIndex(HALF_PI-radians)];
	}

	/**
	 * Returns the tangent of a given value, by looking up it's approximation in a
	 * precomputed table.
	 * @param radians The value to tan.
	 * @return The approximation of the value's tangent.
	 */
	public function tan(radians:Number):Number 
	{
		return tanTable[radToIndex(radians)];
	}
}
