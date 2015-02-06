import caurina.transitions.*;
import mx.events.EventDispatcher;

class oxylus.template.main.button extends MovieClip 
{
	public var node:XMLNode;
	
	private var bg:MovieClip;
		private var title:MovieClip;
			private var normal:MovieClip;
			private var over:MovieClip;
		
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	
	public var hiddenModule:Number = 0;
	public var externalLink:Number = 0;
	
	public function button() {
		EventDispatcher.initialize(this);
		
		normal = title["normal"];
		over = title["over"]; over._alpha = 0;
		
		bg._alpha = 0;
		
		normal["txt"].autoSize = over["txt"].autoSize = true;
	}
	
	/**
	 * this will setup the node
	 * @param	n
	 */
	public function setNode(n:XMLNode) {
		node = n;
		normal["txt"].text = over["txt"].text = node.attributes.title;
		
		drawOval(bg, normal._width + 16, normal._height + 8, 6, 0x292929, 100);
		
		title._x = 10;
		
		title._y = Math.round(bg._height / 2 - title._height / 2);
		
		hiddenModule = node.attributes.hiddenModule;
		externalLink = node.attributes.externalLink;
	}
	
	/**
	 * actions for rolling over the button
	 */
	public function onRollOver() {
		Tweener.addTween(over , { _alpha:100, time: .15, transition: "linear" } );
	}
	
	/**
	 * actions for rolling out of the button
	 */
	private function onRollOut() {
		Tweener.addTween(over , { _alpha:0, time: .15, transition: "linear" } );
	}
	
	/**
	 * actions for pressing the button
	 */
	public function onRelease() {
		onRollOut();
		if (externalLink == 1) {
			getURL(node.attributes.url, node.attributes.externalTarget);
		}
		else {
			if (this._parent._parent._parent.getThePermitValue() == 1) {
				_global.treatAddress = true;
				SWFAddress.setValue(node.attributes.url);
			}
		}
		
	}
	
	public function dispatchThisMC() {
		SWFAddress.setTitle(node.attributes.urlTitle);
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	public function reset() {
		Tweener.addTween(bg , { _alpha:0, time: .15, transition: "linear" } );
	}
	
	public function act() {
		Tweener.addTween(bg , { _alpha:100, time: .15, transition: "linear" } );
	}
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
		//this function draws an ovel or a sqare if the radius will be 0
		mc.clear();
		mc.beginFill(fillColor,alphaAmount);
		mc.moveTo(r,0);
		mc.lineTo(mw-r,0);
		mc.curveTo(mw,0,mw,r);
		mc.lineTo(mw,mh-r);
		mc.curveTo(mw,mh,mw-r,mh);
		mc.lineTo(r,mh);
		mc.curveTo(0,mh,0,mh-r)
		mc.lineTo(0,r);
		mc.curveTo(0,0,r,0);
		mc.endFill();
	}
}