package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import net.flashden.lydian.photogallery.PhotoGallery;
		
	public class ContentHolder extends MovieClip {
		
		// Page content
		private var _content:MovieClip;
		
		/**
		 * Adds the given content to the content holder.
		 */
		public function set content(content:MovieClip):void {
			
			// Prepare the location of the content
			this._content = content;
			var targetY:Number = ConfigManager.CONTENT_HOLDER_TOP_MARGIN; 						
			_content.x = ConfigManager.CONTENT_HOLDER_LEFT_MARGIN;
			_content.y = -background.height;
			_content.alpha = 0;
			holder.addChild(_content);
			
			
			if (holder.numChildren >= 3) {
				// Remove the previous contents except the last one
				for (var i:int = 1; i < holder.numChildren - 2; i++) {
					var child:DisplayObject = holder.getChildAt(i);
					
					// Remove the event listeners if it's a photo gallery component
					if (child is PhotoGallery) {
						var photoGallery:PhotoGallery = child as PhotoGallery;
						photoGallery.removeEventListeners();
					}
					
					holder.removeChild(child);
				}					
			
				// Animate the contents
				var prevContent:DisplayObject = holder.getChildAt(1);				
				Tweener.addTween(prevContent, {y:background.height, time:1.3, alpha:0, onComplete:removePrevContent});
				Tweener.addTween(_content, {y:ConfigManager.CONTENT_HOLDER_TOP_MARGIN, alpha:1, time:1.3});				
			} else {
				// No animation needed
				_content.alpha = 1;
				_content.y = targetY;
			}
			
		}
		
		/**
		 * Removes the previous content from the holder.
		 */
		private function removePrevContent():void {
			
			if (holder.numChildren >= 3) {
				var prevContent:DisplayObject = holder.getChildAt(1);
				
				// Remove the event listeners if it's a photo gallery component
				if (prevContent is PhotoGallery) {
					var photoGallery:PhotoGallery = prevContent as PhotoGallery;
					photoGallery.removeEventListeners();
				}
				
				holder.removeChild(prevContent);
			}
			
		}
		
		/**
		 * Returns the current content.
		 */
		public function get content():MovieClip {
			
			return _content;
			
		}
		
		/**
		 * Returns the actual width.
		 */
		public override function get width():Number {
			
			return background.width;
			
		}
		
		/**
		 * Returns the actual height.
		 */
		public override function get height():Number {
			
			return background.height;
			
		}
		
	}
	
}