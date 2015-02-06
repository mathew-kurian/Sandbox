/**
 * HGallery
 * Horizontally oriented gallery implementation
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	//
	public class HGallery extends Gallery {
		//constants...
		protected const __KSCROLL:Object = { activezone: 0.33, interval: 500, ratio: 0.04 };
		//
		//constructor...
		public function HGallery(fDrawMask:Function, fModel:Function, boolTextIsEmbedded:Boolean = false, backGround:* = undefined, objPadding:Object = undefined, objTransition:ITransition = undefined, mcBaloon:MovieClip = undefined, objThumbSource:ThumbSource = undefined, arrayThumbnails:Array = undefined) {
			super(fDrawMask, fModel, boolTextIsEmbedded, backGround, objPadding, objTransition, mcBaloon, objThumbSource, arrayThumbnails);
		};
		//
		//private methods...
		protected override function __updatepositions():void {
			for (var i:int = 1; i < this.__items.length; i++) this.__items[i].container.x = this.__items[i - 1].container.x + this.__items[i - 1].container.width;
		};
		protected override function __onTimerScroll(event:TimerEvent):void {
			if (!(this.__list is Sprite)) this.__timerscroll.stop()
			else {
				var _step:Number;
				var _zone:Number = this.__KSCROLL.activezone * this.__mask.width;
				if (this.__mask.mouseX < _zone) {
					if (this.__list.x >= this.__mask.x) this.__timerscroll.stop()
					else {
						_step = this.__KSCROLL.ratio * (_zone - this.__mask.mouseX);
						if (this.__list.x + _step > this.__mask.x) this.__list.x = this.__mask.x
						else this.__list.x += _step;
					};
				}
				else if (this.__mask.mouseX > this.__mask.width - _zone) {
					if (this.__list.x + this.__list.width <= this.__mask.x + this.__mask.width) this.__timerscroll.stop()
					else {
						_step = -this.__KSCROLL.ratio * (this.__mask.mouseX - this.__mask.width + _zone);
						if (this.__list.x + this.__list.width + _step < this.__mask.x + this.__mask.width) this.__list.x = this.__mask.x + this.__mask.width - this.__list.width
						else this.__list.x += _step;
					};
				};
			};
		};
		protected override function __showselected():void {
			if (!(this.__mask is Sprite)) return;
			if (!(this.__list is Sprite)) return;
			if (this.__items.length < 1) return;
			if (!this.__status) return;
			if (!(this.__status.selected is MovieClip)) return;
			if (this.__status.selected.parent != this.__list) return;
			var num:Number = this.__list.x;
			if (num + this.__list.width < this.__mask.x + this.__mask.width) num = this.__mask.x + this.__mask.width - this.__list.width;
			if (num > this.__mask.x) num = this.__mask.x;
			if (num + this.__status.selected.x + this.__status.selected.width > this.__mask.x + this.__mask.width) num = this.__mask.x + this.__mask.width - this.__status.selected.x - this.__status.selected.width;
			if (num + this.__status.selected.x < this.__mask.x) num = this.__mask.x - this.__status.selected.x;
			this.__list.x = num;
		};
		//
		//properties...
		public override function get fullHeight():Number {
			return (this.__mask.height + this.__status.padding.bottom + this.__status.padding.top);
		};
		public override function get fullWidth():Number {
			return (this.__list.width + this.__status.padding.left + this.__status.padding.right);
		};
		public override function set width(floatWidth:Number):void {
			if (isNaN(floatWidth)) return;
			if (floatWidth < this.__status.padding.left + this.__status.padding.right) floatWidth = this.__status.padding.left + this.__status.padding.right;
			this.__status.width = floatWidth;
			var _length:Number = this.__status.padding.left + this.__status.padding.right + ((this.__list is Sprite) ? this.__list.width : 0);
			if (floatWidth > _length) floatWidth = _length;
			this.__status._width = floatWidth;
			try {
				this.__drawmask(this.__mask, this.__status.height - this.__status.padding.bottom - this.__status.padding.top, this.__status._width - this.__status.padding.left - this.__status.padding.right);
				this.__drawmask(this.__hitarea, this.__status.height - this.__status.padding.bottom - this.__status.padding.top, this.__status._width - this.__status.padding.left - this.__status.padding.right);
			}
			catch (_error:Error) {
				//...
			};
			//
			this.__showselected();
			if (this.__bkg is Bitmap) {
				try {
					this.__bkg.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				this.__bkg.bitmapData = this.__pattern(this.__bkgpool, this.__status.height, this.__status.width);
			}
			else if (this.__bkg is MovieClip) this.__bkg.width = this.__status.width;
		};
	};
};