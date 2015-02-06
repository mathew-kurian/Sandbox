package net.flashden.lydian.template {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;	

	public class ScrollBar extends MovieClip {
		
		// Content to be scrolled
		private var _content:DisplayObject;
		
		// A display object for masking the content
		private var _contentMask:DisplayObject;
		
		// Indicates whether the scroll thumb is holded
		private var scrollThumbHold:Boolean = false;
		
		// Indicates whether the mouse is over the scroll thumb
		private var mouseOverScrollThumb:Boolean = false;

		/**
		 * Initializes the scroll bar.
		 */
		public function init():void {
			
			// Use the scroll thumb as a button
			scrollThumb.buttonMode = true;
			scrollThumb.useHandCursor = true;
			scrollThumb.mouseChildren = false;
			
			// Add necessary event listeners
			track.height = _contentMask.height;
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			scrollThumb.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			scrollThumb.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
		}
		
		/**
		 * Updates the scroll bar.
		 */
		public function update():void {					
										
			if (_content != null && _contentMask != null) {
				
				// Reset scroll bar
				if (Tweener.isTweening(_content)) {
					Tweener.removeTweens(_content);	
				}
												
				scrollThumb.stopDrag();
				scrollThumb.y = 0;
				_content.y = _contentMask.y;
				
				if (_content.height <= _contentMask.height) {
					scrollThumb.height = 0;
				} else {					
					scrollThumb.height = (track.height * _contentMask.height) / _content.height;
					scrollThumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown, false, 0, true);					
				}
			}
			
			// Hide if needed
			if (scrollThumb.height == 0) {
				visible = false;
			} else {
				visible = true;
			}

		}
		
		/**
		 * This method is called when the mouse is clicked on the thumb.
		 */
		private function onThumbDown(evt:MouseEvent):void {
						
			// Start dragging the thumb
			scrollThumbHold = true;
			scrollThumb.startDrag(false, new Rectangle(0, 0, 0, track.height + 1 - scrollThumb.height)); 
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);			
			
		}
		
		/**
		 * This method is called when the mouse released on the thumb.
		 */
		private function onThumbUp(evt:MouseEvent):void {
			
			// Stop dragging the thumb
			scrollThumbHold = false;
			scrollThumb.stopDrag();			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (!mouseOverScrollThumb) {			
				Tweener.addTween(scrollThumb, {_color:null, time:1});
			}
		}
		
		/**
		 * This method is called when the mouse is over the thumb.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			mouseOverScrollThumb = true;
			Tweener.addTween(scrollThumb, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the thumbn.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			mouseOverScrollThumb = false;
			
			if (!scrollThumbHold) {
				Tweener.addTween(scrollThumb, {_color:null, time:1});
			}
			
		}
		
		/**
		 * Handles mouse wheel support.
		 */
		private function onMouseWheel(evt:MouseEvent):void {
			
			if (evt.delta < 0) {
				if (scrollThumb.y < track.height - scrollThumb.height + 1) {
					var heightLeft:Number = track.height - scrollThumb.height + 1 - scrollThumb.y;
					
					if (heightLeft >= 10) {
						scrollThumb.y += 10;
					} else {
						scrollThumb.y += heightLeft;
					}
				}
			} else {
				if (scrollThumb.y > 0) {
					heightLeft = scrollThumb.y;
					if (scrollThumb.y >= 10) {
						scrollThumb.y -= 10;	
					} else {
						scrollThumb.y = 0;
					}
				}
			}
			
			animate();
			
		}
		
		/**
		 * Starts easing.
		 */
		private function onEnterFrame(evt:Event):void {
			
			animate();
			
		}
		
		/**
		 * Ease to the new location.
		 */
		private function animate():void {
			
			var target:Number = _contentMask.y + scrollThumb.y * (_contentMask.height - _content.height) /
								(track.height - scrollThumb.height);						
			Tweener.addTween(_content, {y:target, time:.5, transition:Equations.easeOutCirc});
			
			
		}
		
		/**
		 * Sets the content related with the scroll bar.
		 */
		public function set content(content:DisplayObject):void {
			
			this._content = content;
			
		}
		
		/**
		 * Sets the mask related with the scroll bar.
		 */
		public function set contentMask(contentMask:DisplayObject):void {
			
			this._contentMask = contentMask;
			
		}
		
	}
}
