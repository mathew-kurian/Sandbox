package gT.utils {
	
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	
	public class ObjectUtils {
		
		public static function forIn(target:Object):void {
			trace("--------------------------------------------");
			trace("ForIn: "+target+"\n");
			for (var i:String in target) {
				trace("propiedad: "+i+" valor: "+target[i]);
			}
			trace("\n");
		}
		
		public static function traceObject(obj:Object, indent:uint = 0):void { 
			var indentString:String = ""; 
			var i:uint; 
			var prop:String; 
			var val:*; 
			for (i = 0; i < indent; i++) 
			{ 
				indentString += "\t"; 
			} 
			for (prop in obj) 
			{ 
				val = obj[prop]; 
				if (typeof(val) == "object") 
				{ 
					trace(indentString + " " + prop + ": [Object]"); 
					traceObject(val, indent + 1); 
				} 
				else 
				{ 
					trace(indentString + " " + prop + ": " + val); 
				} 
			} 
		}
		
		public static function setPropertiesFrom (target:*, object:Object, filter:Array = null, showError:Boolean = true):void
		{
			var propertie:String;
			
			if (filter) {
				for (var i:uint; i < filter.length; i++) {
					propertie = filter[i];
					try {
						target[propertie] = object[propertie];
					} catch (e){
						if (showError) {
							trace(e.getStackTrace());
						}
					}
				}
			} else {
				for (propertie in object) {
					try {
						target[propertie] = object[propertie];
					} catch (e){
						if (showError) {
							trace(e.getStackTrace());
						}
					}
				}
			}
		}
		
		public static function compare(obj1:Object, obj2:Object):Boolean
		{
			var buffer1:ByteArray = new ByteArray();
			buffer1.writeObject(obj1);
			
			var buffer2:ByteArray = new ByteArray();
			buffer2.writeObject(obj2);
			
			// compare the lengths
			var size:uint = buffer1.length;
			
			if (buffer1.length == buffer2.length) {
				buffer1.position = 0;
				buffer2.position = 0;
				
				// then the bits
				while (buffer1.position < size) {
					
					var v1:int = buffer1.readByte();
					if (v1 != buffer2.readByte()) {
						return false;
					}
				}    
				return true;                        
			}
			return false;
		}
		
	}
}