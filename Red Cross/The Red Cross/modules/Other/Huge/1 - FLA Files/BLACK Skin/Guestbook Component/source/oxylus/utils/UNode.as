/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 10/02/2009 (mm/dd/yyyy) */

import oxylus.utils.UStr;

class oxylus.utils.UNode {
	private function UNode() { trace("Static class. No instantiation.") }
	
	/* Transform XMLNode to Object. */
	public static function nodeToObj(node:XMLNode):Object {
		var p:XMLNode 		= node.firstChild;
		var obj:Object 		= new Object();	
		var nodes:Object 	= new Object();
		
		for (; p != null; p = p.nextSibling) {			
			var nodeName:String 	= p.nodeName;
			var fstChild:XMLNode 	= p.firstChild;
			nodes[nodeName]			= p;			
			if (p.hasChildNodes()) {
				obj[nodeName] = fstChild.nodeType == 3 ? UStr.parse(fstChild.nodeValue) : p;
			} else {
				obj[nodeName] = "";
			}
			for (var attribName in p.attributes) {
				obj[nodeName + "_" + attribName] = UStr.parse(p.attributes[attribName]);
			}
		}
		
		obj.$nodes 	= nodes;
		obj.$source	= node;
		
		return obj;
	}
	/* Goes through the node children and calls a function with given scope and argument. */
	public static function forEachChild(node:XMLNode, callBack:Function, scope:Object, arg):Void {
		var p:XMLNode = node.firstChild;
		for (; p != null; p = p.nextSibling) {
			callBack.call(scope, p, arg);
		}
	}	
	/* Get next node.
	 * If parameter is the last node, it will return the first one */
	public static function nextNode(node:XMLNode):XMLNode {
		return node.nextSibling == null ? node.parentNode.firstChild : node.nextSibling;
	}
	/* Get previous node.
	 * If parameter is the first node, it will return the last one */
	public static function prevNode(node:XMLNode):XMLNode {
		return node.previousSibling == null ? node.parentNode.lastChild : node.previousSibling;
	}
}