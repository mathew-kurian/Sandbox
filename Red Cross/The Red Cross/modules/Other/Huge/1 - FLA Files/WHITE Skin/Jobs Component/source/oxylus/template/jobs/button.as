import caurina.transitions.*;
import mx.events.EventDispatcher;
import oxylus.Utils;
import ascb.util.Proxy;


class oxylus.template.jobs.button extends MovieClip 
{
	public var node:XMLNode;
	public var idx:Number;
	public var totalHeight:Number;
	
	private var holder:MovieClip;
		private var title:MovieClip;
			private var titleNormal:MovieClip;
		private var date:MovieClip;
		private var ht:MovieClip;
			private var description:MovieClip;
			private var read:MovieClip;
			private var apply:MovieClip;
		
	private var bg:MovieClip;
		private var bgNormal:MovieClip;
		private var bgOver:MovieClip;
	
		
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function button() {
		EventDispatcher.initialize(this);
		
		title = holder["title"];
			titleNormal = title["normal"]; titleNormal["txt"].autoSize = true; titleNormal["txt"].wordWrap = true; titleNormal["txt"].selectable = false;
			titleNormal["txt"]._width = 260;
		date = holder["date"]; date["txt"].autoSize = true; date["txt"].wordWrap = false; date["txt"].selectable = false;
		ht = holder["ht"];
			description = ht["description"];
			Utils.initMhtf(description["txt"], false);
			read = ht["read"];
			apply = ht["apply"];
		description["txt"]._width = 600;
		bg = this["bg"];
			bgNormal = bg["normal"];
		
		
		
		read.onRollOver = Proxy.create(this, readOnRollOver);
		read.onRollOut = Proxy.create(this, readOnRollOut);
		read.onPress = Proxy.create(this, readOnPress);
		
		apply.onRollOver = Proxy.create(this, applyOnRollOver);
		apply.onRollOut = Proxy.create(this, applyOnRollOut);
		apply.onPress = Proxy.create(this, applyOnPress);
	}
	
	/**
	 * actions for rolling over the read button
	 */
	private function readOnRollOver() {
		Tweener.addTween(read , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for rolling out of the read button
	 */
	private function readOnRollOut() {
		Tweener.addTween(read , { _alpha:50, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for pressing the read button
	 */
	private function readOnPress() {
		_global.jobStatus = 0;
		SWFAddress.setValue(node.parentNode.attributes.url + node.attributes.url);
	}
	
	
	public function dispatchThisMC() {
		readOnRollOut();
		SWFAddress.setTitle(node.parentNode.attributes.urlTitle + " - " + node.attributes.urlTitle);
		if (_global.jobStatus == 0) {
			dispatchEvent( { target:this, type:"readPressed", mc:this } );
		}
		else {
			dispatchEvent( { target:this, type:"applyPressed", mc:this } );
		}
	}
	
	/**
	 * actions for rolling over the apply button
	 */
	private function applyOnRollOver() {
		Tweener.addTween(apply , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for rolling out of the apply button
	 */
	private function applyOnRollOut() {
		Tweener.addTween(apply , { _alpha:50, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for pressing the apply button
	 */
	private function applyOnPress() {
		_global.jobStatus = 1;
		SWFAddress.setValue(node.parentNode.attributes.url + node.attributes.url);
		applyOnRollOut();
	}
	
	/**
	 * this will set the node
	 * @param	n
	 */
	public function setNode(n:XMLNode) {
		node = n;
		titleNormal["txt"].text = node.attributes.title;
		date["txt"].text = node.attributes.date;
		date._y = Math.round(titleNormal._height - 4);
		description["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		read._y = apply._y = Math.round(description._height + 14);
		
		totalHeight = Math.round(this._height+14);
		dispatchEvent( { target:this, type:"proressiveLoading", mc:this } );
	}
}