import oxylus.Utils2;
import ascb.util.Proxy;
import caurina.transitions.*;


class oxylus.template.guest.entry extends MovieClip 
{
	private var node:XMLNode;
	public var settings:Object;
	
	private var separator:MovieClip;
	private var theText:MovieClip;
	private var theTitle:MovieClip;
	
	public function main() {
		
	}
	
	public function setNode(n, settings_:Object) {
		node = n ;
		settings = settings_;
		
		
		Utils2.initMhtf(theText["txt"], false);
		theText["txt"]._width = settings.contentWidth - 14;
		theText["txt"].htmlText = node.firstChild.nodeValue;
		theText._x = 12;
		theTitle["txt"].text = node.attributes.name;
		
		theText._y = Math.round(theTitle._height + 4);
		
		separator._width = settings.contentWidth;
		separator._y = Math.round(theText._height + theText._y + 10);
		
	}

}