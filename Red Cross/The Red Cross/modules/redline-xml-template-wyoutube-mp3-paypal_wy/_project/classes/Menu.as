/**
 * Menu:VGallery
 * Vertically oriented Menu implementation
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.ITransition;
	import _project.classes.VGallery;
	//
	public class Menu extends VGallery {
		//private vars...
		private var __locked:Boolean = false;
		//
		//constructor...
		public function Menu(fDrawMask:Function, fModel:Function, boolTextIsEmbedded:Boolean = false, backGround:* = undefined, objPadding:Object = undefined, objTransition:ITransition = undefined) {
			super(fDrawMask, fModel, boolTextIsEmbedded, "R", backGround, objPadding, objTransition);
			this.__removelistener(this, MouseEvent.ROLL_OUT, this.__onRollOut);
			this.__removelistener(this, MouseEvent.ROLL_OVER, this.__onRollOver);
		};
		//
		//private methods...
		protected override function __onItemClick(event:MouseEvent):void {
			var _index:int = this.__itemvalid(MovieClip(event.currentTarget));
			if (_index >= 0) {
				var _valid:Boolean = false;
				try {
					if (this.__items[_index].node is Array) {
						_valid = (this.__items[_index].node.length > 0);
					};
				}
				catch (_eror:Error) {
					//...
				};
				if (_valid) return;
			};
			super.__onItemClick(event);
		};
		protected override function __onItemMouseOut(target:MovieClip):void {
			if (this.__locked) return;
			super.__onItemMouseOut(target);
		};
		protected override function __onItemMouseOver(target:MovieClip):void {
			this.locked = false;
			super.__onItemMouseOver(target);
		};
		protected override function __onRollOver(event:MouseEvent):void {
			this.__locked = false;
			if (this.mouseOver) return;
			super.__onRollOver(event);
		};
		protected override function __onTransitionClose(event:Event = undefined):void {
			super.__onTransitionClose(event);
			//outro...
			this.__removelistener(this, MouseEvent.ROLL_OUT, this.__onRollOut);
			this.__addlistener(this, MouseEvent.ROLL_OVER, this.__onRollOver);
		};
		protected override function __onTransitionOpen(event:Event = undefined):void {
			super.__onTransitionOpen(event);
			//intro...
			this.__addlistener(this, MouseEvent.ROLL_OUT, this.__onRollOut);
			this.__removelistener(this, MouseEvent.ROLL_OVER, this.__onRollOver);
		};
		//
		//properties...
		public function get locked():Boolean {
			return this.__locked;
		};
		public function set locked(boolLocked:Boolean):void {
			if (!(boolLocked is Boolean)) return;
			if (this.__locked != boolLocked) {
				this.__locked = boolLocked;
				try {
					this.__items[this.rolledOver.index].container.setLocked(boolLocked);
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		//
		//public methods...
		public override function hide():void {
			if (this.__locked) return;
			super.hide();
		};
		public override function reset():void {
			this.__locked = false;
			super.reset();
		};
		public override function show():void {
			if (this.__locked) return;
			super.show();
		};
	};
};