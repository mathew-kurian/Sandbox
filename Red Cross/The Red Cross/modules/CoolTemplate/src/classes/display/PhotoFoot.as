/*
PhotoFoot.as
CoolTemplate

Created by Alexander Ruiz Ponce on 3/12/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;
	import gT.display.layout.VLayout;
	import classes.display.Label;
	import flash.geom.Rectangle;
	import flash.filters.DropShadowFilter;
	
	import gs.TweenMax;
	import classes.Global;
	
	public class PhotoFoot extends GenericComponent {
		
		private var __texts:Array;
		private var __labels:Array;
		private var __holder:VLayout;
		
		public static const TEXT_CHANGED:String = "textChanged";
		
		public function PhotoFoot () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
			
		override protected function addChildren():void
		{
			// Holder
			__holder = new VLayout;
			addChild(__holder);
			
			__holder.filters = [new DropShadowFilter (3, 45, 0, .3, 0, 0, 1)];
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__width = __holder.width;
			__height = __holder.height;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createLabels ():void
		{		
			__labels = [];
			var endArrays:Array = [];
			
			for (var i in __texts) {
				var label:Label = new Label();
				label.text = __texts[i];
				
				__holder.addChild(label);
				__labels.push(label);
				
				label.scrollRect = new Rectangle(0, label.height, label.width, label.height);
				endArrays.push([label.height]);
				TweenMax.to(endArrays[i], Global.settings.time/2, {endArray:[0], onUpdate:update, onUpdateParams:[__labels[i], i], ease:Global.settings.easeOut, delay:0.07*i});
			}
			
			function update(target, arrayId) {
				target.scrollRect = new Rectangle(0, endArrays[arrayId], target.width, target.height);
			}
			
			draw();
			dispatchEvent(new Event(TEXT_CHANGED));
		}
		
		private function clear (callback:Function = null):void
		{
			var cont:uint;
			var endArrays:Array = [];
			
			for (var i in __labels) {
				endArrays.push([0]);
				TweenMax.to(endArrays[i], Global.settings.time/2, {endArray:[__labels[i].height], onUpdate:update, onUpdateParams:[__labels[i], i], ease:Global.settings.easeOut, onComplete:complete, onCompleteParams:[__labels[i], i], delay:0.07*i});
			}
			
			function update(target, arrayId) {
				target.scrollRect = new Rectangle(0, endArrays[arrayId], target.width, target.height);
			}
			
			function complete(target, index) {
				__holder.removeChild(target);
				if (index == __labels.length-1) {
					__labels = null;
					if (callback != null) callback();
				}
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set text (value:String):void
		{
			if (!value) {
				__texts = [];
				clear();
				return
			};
						
			__texts = value.split("<br>");
			
			// clear spaces at init
			for (var i in __texts) {
				__texts[i] = __texts[i].replace(/^\s+|\s+$/g, "");
			}

			if (__labels) {
				clear(createLabels);
			} else {
				createLabels();
			}
		}
	}
}