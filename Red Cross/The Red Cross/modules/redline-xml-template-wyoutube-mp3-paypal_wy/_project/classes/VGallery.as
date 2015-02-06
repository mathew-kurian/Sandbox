/**
 * VGallery
 * Vertically oriented gallery implementation
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	//
	public class VGallery extends Gallery {
		//constants...
		private const __KALIGN:Array = [ { id: "", left: 0, right: 0 }, { id: "L", left: 1, right: 0 }, { id: "R", left: 0, right: 1 } ];
		protected const __KSCROLL:Object = { activezone: 0.33, interval: 500, ratio: 0.04 };
		//
		//private vars...
		private var __align:int = 0;
		private var __minwidth:Number = 0;
		//
		//constructor...
		public function VGallery(fDrawMask:Function, fModel:Function, boolTextIsEmbedded:Boolean = false, strAlign:String = "", backGround:* = undefined, objPadding:Object = undefined, objTransition:ITransition = undefined, mcBaloon:MovieClip = undefined, objThumbSource:ThumbSource = undefined, arrayThumbnails:Array = undefined) {
			if (strAlign is String) {
				strAlign = strAlign.toUpperCase();
				for (var i:int = 0; i < this.__KALIGN.length; i++) {
					if (strAlign == this.__KALIGN[i].id) {
						this.__align = i;
						break;
					};
				};
			};
			super(fDrawMask, fModel, boolTextIsEmbedded, backGround, objPadding, objTransition, mcBaloon, objThumbSource, arrayThumbnails);
			this.__minwidth = this.__mask.width + this.__KALIGN[this.__align].left * this.__status.padding.left + this.__KALIGN[this.__align].right * this.__status.padding.right;
		};
		//
		//private methods...
		protected override function __updatepositions():void {
			for (var i:int = 1; i < this.__items.length; i++) this.__items[i].container.y = this.__items[i - 1].container.y + this.__items[i - 1].container.height;
		};
		protected override function __onTimerScroll(event:TimerEvent):void {
			if (!(this.__list is Sprite)) this.__timerscroll.stop()
			else {
				var _step:Number;
				var _zone:Number = this.__KSCROLL.activezone * this.__mask.height;
				if (this.__mask.mouseY < _zone) {
					if (this.__list.y >= this.__mask.y) this.__timerscroll.stop()
					else {
						_step = this.__KSCROLL.ratio * (_zone - this.__mask.mouseY);
						if (this.__list.y + _step > this.__mask.y) this.__list.y = this.__mask.y
						else this.__list.y += _step;
					};
				}
				else if (this.__mask.mouseY > this.__mask.height - _zone) {
					if (this.__list.y + this.__list.height <= this.__mask.y + this.__mask.height) this.__timerscroll.stop()
					else {
						_step = -this.__KSCROLL.ratio * (this.__mask.mouseY - this.__mask.height + _zone);
						if (this.__list.y + this.__list.height + _step < this.__mask.y + this.__mask.height) this.__list.y = this.__mask.y + this.__mask.height - this.__list.height
						else this.__list.y += _step;
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
			var num:Number = this.__list.y;
			if (num + this.__list.height < this.__mask.y + this.__mask.height) num = this.__mask.y + this.__mask.height - this.__list.height;
			if (num > this.__mask.y) num = this.__mask.y;
			if (num + this.__status.selected.y + this.__status.selected.height > this.__mask.y + this.__mask.height) num = this.__mask.y + this.__mask.height - this.__status.selected.y - this.__status.selected.height;
			if (num + this.__status.selected.y < this.__mask.y) num = this.__mask.y - this.__status.selected.y;
			this.__list.y = num;
		};
		//
		//properties...
		public override function get fullHeight():Number {
			return (this.__list.height + this.__status.padding.bottom + this.__status.padding.top);
		};
		public override function get fullWidth():Number {
			return (this.__mask.width + this.__status.padding.left + this.__status.padding.right);
		};
		public override function set height(floatHeight:Number):void {
			if (isNaN(floatHeight)) return;
			if (floatHeight < this.__status.padding.bottom + this.__status.padding.top) floatHeight = this.__status.padding.bottom + this.__status.padding.top;
			this.__status.height = floatHeight;
			var _length:Number = this.__status.padding.bottom + this.__status.padding.top + ((this.__list is Sprite) ? this.__list.height : 0);
			if (floatHeight > _length) floatHeight = _length;
			this.__status._height = floatHeight;
			try {
				this.__drawmask(this.__mask, this.__status._height - this.__status.padding.bottom - this.__status.padding.top, this.__status.width - this.__status.padding.left - this.__status.padding.right);
				this.__drawmask(this.__hitarea, this.__status._height - this.__status.padding.bottom - this.__status.padding.top, this.__status.width - this.__status.padding.left - this.__status.padding.right);
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
			else if (this.__bkg is MovieClip) this.__bkg.height = this.__status.height;
		};
		public override function set width(floatWidth:Number):void {
			if (isNaN(floatWidth)) return;
			if (floatWidth < this.__minwidth) floatWidth = this.__minwidth;
			this.__status.width = this.__status._width = floatWidth;
			var _align:Object = this.__KALIGN[this.__align];
			var _padding:Number = this.__status.width - this.__mask.width - _align.left * this.__status.padding.left - _align.right * this.__status.padding.right;
			var _center:Number = ((_align.left == _align.right) ? 0.5 : 1);
			this.__status.padding.left = _align.left * this.__status.padding.left + (_center - _align.left) * _padding;
			this.__status.padding.right = _align.right * this.__status.padding.right + (_center - _align.right) * _padding;
			this.__hitarea.x = this.__status.padding.left;
			this.__hitarea.y = this.__status.padding.top;
			this.__mask.x = this.__hitarea.x;
			this.__mask.y = this.__hitarea.y;
			if (this.__list is Sprite) this.__list.x = this.__mask.x;
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