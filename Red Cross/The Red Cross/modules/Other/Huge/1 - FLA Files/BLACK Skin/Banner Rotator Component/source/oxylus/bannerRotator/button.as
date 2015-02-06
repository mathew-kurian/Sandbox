import caurina.transitions.*;
import mx.events.EventDispatcher;

class oxylus.bannerRotator.button extends MovieClip 
{
	
	public var node:XMLNode;
	
	private var holder:MovieClip;
	private var normal:MovieClip;
	private var over:MovieClip;
	private var selected:MovieClip;
	
	public var idx:MovieClip;
	
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function button() {
		EventDispatcher.initialize(this);
		
		normal = holder["normal"];
		over = holder["over"];
		selected = holder["selected"];
		
		over._alpha = selected._alpha = 0;
	}
	
	/**
	 * this will set the node
	 * @param	n
	 */
	public function setNode(n:XMLNode) {
		node = n;
		normal["txt"].text = over["txt"].text = selected["txt"].text = idx+1;
	}
	
	/**
	 * actions for rolling over one button
	 */
	private function onRollOver() {
		Tweener.addTween(over, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(normal, { _alpha:0, time:0.2, transition:"linear" } );
		dispatchEvent( { target:this, type:"buttonOver", mc:this } );
	}
	
	/**
	 * actions for rolling out of the button
	 */
	private function onRollOut() {
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(normal, { _alpha:100, time:0.2, transition:"linear" } );
		dispatchEvent( { target:this, type:"buttonOut", mc:this } );
	}
	
	/**
	 * actions for pressing the button
	 * if you would like to launch an url you add a getURL function and use node to send the proper url and target to the function
	 */
	private function onRelease() {
		
		activate(); 
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
	}
	
	private function onReleaseOutside() {
		onRollOut();
	}
	
	/**
	 * this will activate the button
	 */
	public function activate() {
		this.enabled = false;
		this.useHandCursor = false;
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(normal, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(selected, { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	/**
	 * this will deactivate the button
	 */
	
	public function deactivate() {
		this.enabled = true;
		this.useHandCursor = true;
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(normal, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(selected, { _alpha:0, time:0.2, transition:"linear" } );
	}
}