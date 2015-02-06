import oxylus.Utils;
import ascb.util.Proxy;
import caurina.transitions.*;
import oxylus.template.guest.lightImage;
import mx.events.EventDispatcher;

class oxylus.template.guest.smily extends MovieClip 
{
	public var node:XMLNode;
	public var settings:Object;
	private var imageHandler:lightImage;
	
	private var holder:MovieClip;
	
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function smily() {
		EventDispatcher.initialize(this);
		
	}
	
	public function setNode(n, settings_:Object) {
		node = n ;
		settings = settings_;
		
		imageHandler = new lightImage( { holder:holder, address:node.attributes.src, resize:[settings.smilyWidth, settings.smilyHeight, "fixed"], theParent:this} );
	}
	
	private function onPress() {
		dispatchEvent( { target:this, type:"smilyPressed", mc:this } );
	}

}