/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import oxylus.utils.UStr;
 
class oxylus.utils.UTime {
	private function UTime() { trace("Static class. No instantiation.") }
	
	/* Array with month names. */
	public static var MONTH_NAMES:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	/* Array with day names. */
	public static var DAY_NAMES:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	
	/* "from" parameter for the "convertToMs" function. */
	/* Convert from seconds to ms. */
	public static var SECONDS:Number 	= 0;
	/* Convert from minutes to ms. */
	public static var MINUTES:Number 	= 1;
	/* Convert from hours to ms. */
	public static var HOURS:Number 		= 2;
	/* Convert from days to ms. */
	public static var DAYS:Number 		= 3;
	/* Convert from weeks to ms. */
	public static var WEEKS:Number 		= 4;
	/* Convert from months to ms. */
	public static var MONTHS:Number 	= 5;
	/* Convert from years to ms. */
	public static var YEARS:Number 		= 6;	
	
	/* Convert to milliseconds, from
	 * 0 - seconds, 1 - minutes, 2 - hours, 3 - days,
	 * 4 - weeks, 5 - months, 6 - years, default - days. */
	public static function convertToMs(t:Number, from:Number) {		
		switch(from) {
			case 0: 	return t * 1000; 					break;
			case 1: 	return convertToMs(t, 0) * 60; 		break;
			case 2: 	return convertToMs(t, 1) * 60; 		break;
			case 3: 	return convertToMs(t, 2) * 24; 		break;
			case 4: 	return convertToMs(t, 3) * 7; 		break;
			case 5: 	return convertToMs(t, 4) * 4.35; 	break;
			case 6: 	return convertToMs(t, 5) * 12; 		break;
			default: 	return convertToMs(t, 3); 			break;
		}
	}
	/* Returns month name string by given index.
	 * Return abreaviated form by setting the number
	 * of chars in the "abrevLen" parameter */
	public static function monthName(idx:Number, abrevLen:Number) {
		var mn:String = MONTH_NAMES[idx];
		return abrevLen >= 2 ? mn.substr(0, abrevLen) : mn;
	}
	/* Returns day name string by given index
	 * Return abreaviated form by setting the number
	 * of chars in the "abrevLen" parameter */
	public static function dayName(idx:Number, abrevLen:Number) {
		var dn:String = DAY_NAMES[idx];
		return abrevLen >= 2 ? dn.substr(0, abrevLen) : dn;
	}
	/* Get number of days in given month. */
	public static function getDaysInAMonth(monthIdx:Number, leapYear:Boolean):Number {
		monthIdx ++;
		switch(monthIdx) {
			case 1:	case 3: case 5: case 7: case 8: case 10: case 12: 	return 31; 					break;
			case 4: case 6: case 9: case 11: 							return 30; 					break;
			case 2:														return leapYear ? 29 : 28; 	break;
		}
		return 0;
	}
	/* Check if given year is leap year. */
	public static function isLeapYear(year:Number):Boolean {
		return (year % 4 == 0 && year % 100 != 0) || year % 100 == 0;
	}
	/* Time formatted string like (hh:mm:ss), 
	 * hours only displayed if needed */
	public static function timeToStr(sec:Number):String {
		sec 					= Math.round(sec);
		var hours:Number 		= Math.floor(sec / 3600);
		var minutes:Number  	= Math.floor((sec % 3600) / 60);
		var seconds:Number  	= Math.round((sec % 3600) % 60);		
		var hoursStr:String   	= UStr.nrToStr(hours, 	2) + ":";
		var minutesStr:String 	= UStr.nrToStr(minutes, 2) + ":";
		var secondsStr:String 	= UStr.nrToStr(seconds, 2);
		
		return (hours > 0 ? hoursStr : "") + minutesStr + secondsStr;
	}
}