import caurina.transitions.*;
import mx.events.EventDispatcher;

class oxylus.template.news.button extends MovieClip 
{
	public var node:XMLNode;
	public var idx:Number;
	
	private var holder:MovieClip;
		private var title:MovieClip;
			private var titleNormal:MovieClip;
			private var titleOver:MovieClip;
		private var date:MovieClip;
		private var plus:MovieClip;
	
	private var bg:MovieClip;
		private var bgNormal:MovieClip;
		private var bgOver:MovieClip;
	
		
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function button() {
		EventDispatcher.initialize(this);
		
		title = holder["title"];
			titleNormal = title["normal"]; titleNormal["txt"].autoSize = true; titleNormal["txt"].wordWrap = false; titleNormal["txt"].selectable = false;
			titleOver = title["over"]; titleOver["txt"].autoSize = true; titleOver["txt"].wordWrap = false; titleOver["txt"].selectable = false;
		date = holder["date"]; date["txt"].autoSize = true; date["txt"].wordWrap = false; date["txt"].selectable = false;
		plus = holder["plus"];
		
		bg = this["bg"];
			bgNormal = bg["normal"];
			bgOver = bg["over"];
			
			
	}
	
	/**
	 * this will set the node
	 * @param	n
	 */
	public function setNode(n:XMLNode) {
		node = n;
		titleNormal["txt"].text = titleOver["txt"].text = node.attributes.title;
		date["txt"].text = node.attributes.date;
		date._y = Math.round(titleNormal._height - 4);
	}
	
	/**
	 * actions for rolling over one button
	 */
	private function onRollOver() {
		Tweener.addTween(titleOver, { _alpha:100, time: .2, transition: "linear" } );
		Tweener.addTween(plus, { _alpha:100, time: .2, transition: "linear" } );
		Tweener.addTween(bgOver, { _alpha:100, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for rolling out of one button
	 */
	private function onRollOut() {
		Tweener.addTween(titleOver, { _alpha:0, time: .2, transition: "linear" } );
		Tweener.addTween(plus, { _alpha:0, time: .2, transition: "linear" } );
		Tweener.addTween(bgOver, { _alpha:0, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for pressing one button
	 */
	public function onRelease() {
		_global.treatAddress = false;
		SWFAddress.setValue(node.parentNode.attributes.url + node.attributes.url);
		_global.treatAddress = true;
	}
	
	public function dispatchThisMC() {
		_global.treatAddress = false;
		onRollOut();
		SWFAddress.setTitle(node.parentNode.attributes.urlTitle + " - " + node.attributes.urlTitle);
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
		_global.treatAddress = true;
	}
	
	private function onReleaseOutside() {
		onRollOut();
	}
}