package gT.utils {

	public class XMLUtils {
		
		public static function validate(target:*):* {
			if (target != undefined && target != null) {
				return target;
			} else {
				return null;
			}
		}
		
		public static function validateBoolean(target:*, defaultValue:Boolean):Boolean {
			if (target != undefined && target != null) {
				return String(target) == "true";
			} else {
				return defaultValue;
			}
		}
		
		public static function validateString(target:*, defaultValue:String):String {
			if (target != undefined && target != null) {
				return String(target);
			} else {
				return defaultValue;
			}
		}
		
		public static function contains(value:*):Boolean {
			if (value != undefined && value != null) {
				return true;
			} else {
				return false;
			}
		}
		
		public static function validateNumber(raw:*, def:Number, low:Number = Number.MIN_VALUE, high:Number = Number.MAX_VALUE):Number {
			if (raw != undefined && raw != null) {
				if (Number(raw) < low) {
					return low;
				} else if (Number(raw) > high) {
					return high;
				} else {
					return Number(raw);
				}
			} else {
				return def;
			}
		}
		
		public static function validateValue(target:*):* {
			if (target != undefined && target != null) {
				
				if (validateNumber(target, NaN)){
					// is Number
					return (Number(target));
				} else if (target == "true" || target == "false") {
					// is Boolean
					return target == "true";
				} else {
					// is String
					return validateString(target, null);
				}

			} else {
				return null;
			}
		}
		
		public static function toObject(xml):Object {
		
			var obj:Object = {};
			var el:XML;
			var name:String;
			var value:Object;
	
			for each(el in xml.@*) {
				name = el.localName();
				obj[name] = String(xml.attribute(name));
			}
			
			value = xml.text()
			if (value) obj.content = value;
	
			if (xml.hasComplexContent()) {
				for each(el in xml.*) {
					name = el.localName();
					value = XMLUtils.toObject(el);
					if (obj[name] is Array) {
						obj[name].push(value);
					} else {
						obj[name] = [value];
					}
				}
			}
			return obj;
		}
		
		public static function sortListByAttribute(xmlList:XMLList, attribute:String, filter:*):XMLList 
		{	
			var array:Array	= [];
			
			for each (var child in xmlList) 
			{
				var obj = {};
				obj.child = child;
				obj.orderBy = child.attribute(attribute);
				array.push(obj);
			};
			
			array.sortOn("orderBy", filter);
			
			var result:XMLList = new XMLList;
			
			for (var i in array) 
			{
				result += array[i].child
				//result.appendChild(element.child);
			};
			
			return result;
		}
		
		
	}
}