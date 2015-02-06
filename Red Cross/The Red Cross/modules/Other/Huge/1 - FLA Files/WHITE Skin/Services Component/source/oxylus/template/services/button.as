import caurina.transitions.*;
import mx.events.EventDispatcher;

class oxylus.template.services.button extends MovieClip 
{
	public var node:XMLNode;
	public var posX:Number;
	public var totalWidth:Number;
	public var activated:Number = 0;
	
	private var bg:MovieClip;
	private var normal:MovieClip;
	private var over:MovieClip;
	private var pressed:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function button() {
		EventDispatcher.initialize(this);
		
		over._alpha = pressed._alpha = 0;
		normal["txt"].autoSize = over["txt"].autoSize = pressed["txt"].autoSize = true;
		
	}
	
	/**
	 * this will setup the .xml node
	 * @param	n
	 */
	public function setNode(n:XMLNode) {
		node = n;
	
		normal["txt"].text = over["txt"].text =  pressed["txt"].text = node.attributes.title;
		var my_fmt:TextFormat = new TextFormat(); 
		my_fmt.bold = true; 
		normal["txt"].setTextFormat(my_fmt); 
		over["txt"].setTextFormat(my_fmt); 
		pressed["txt"].setTextFormat(my_fmt); 

		drawOval(bg, normal._width + 6, normal._height, 0, 0x000000, 0);
		
		normal._x = over._x = pressed._x = 6;
		
		totalWidth = bg._width;
	}
	
	/**
	 * actions for rolling over one button
	 */
	private function onRollOver() {
		if (activated == 0) {
			Tweener.addTween(normal, { _alpha:0, time:0.2, transition:"linear"} );
			Tweener.addTween(over, { _alpha:100, time:0.2, transition:"linear" } );
		}
	}
	
	/**
	 * actions for rolling out of one button
	 */
	private function onRollOut() {
		if (activated == 0) {
			Tweener.addTween(normal, { _alpha:100, time:0.2, transition:"linear"} );
			Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		}
	}
	
	/**
	 * actions for pressing one thumbnail
	 */
	public function onRelease() {
		_global.treatAddress = false;
		SWFAddress.setValue(node.parentNode.attributes.url + node.attributes.url);
		_global.treatAddress = true;
	}
	
	private function onReleaseOutside() {
		onRollOut();
	}
	
	public function dispatchThisMC() {
		_global.treatAddress = false;
		trace(node.parentNode.attributes.urlTitle + " - " + node.attributes.urlTitle)
		SWFAddress.setTitle(node.parentNode.attributes.urlTitle + " - " + node.attributes.urlTitle);
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
		_global.treatAddress = true;
	}
	
	/**
	 * this will activate the button
	 */
	public function onn() {
		activated = 1;
		Tweener.addTween(normal, { _alpha:0, time:0.2, transition:"linear"} );
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(pressed, { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	/**
	 * this will deactivate the button
	 */
	public function off() {
		activated = 0;
		Tweener.addTween(normal, { _alpha:100, time:0.2, transition:"linear"} );
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(pressed, { _alpha:0, time:0.2, transition:"linear" } );
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