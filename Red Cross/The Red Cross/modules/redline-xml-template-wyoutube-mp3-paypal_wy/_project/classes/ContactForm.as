/**
 * ContactForm
 * Contact form container
 *
 * @version		3.0
 */
package _project.classes	{
	use namespace AS3;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	//
	import _project.classes.ITransition;
	import _project.classes.SwfLoader;
	//
	public class ContactForm extends SwfLoader {
		//private vars...
		private var __btnclose:MovieClip;
		//
		//constructor...
		public function ContactForm(mcBtnClose:MovieClip, boolAutoShow:Boolean = false, objTransition:ITransition = undefined) {
			super(boolAutoShow, undefined, undefined, objTransition);
			this.__btnclose = MovieClip(this.addChild(mcBtnClose));
			this.__btnclose.buttonMode = true;
		};
		//
		//private methods...
		protected override function __onAdded(event:Event):void {
			this.swapChildren(this.__btnclose, DisplayObject(event.currentTarget));
			super.__onAdded(event);
			this.__btnclose.x = this.__media.x + this.__media.width;
			this.__btnclose.y = this.__media.y;
		};
		//
		//public metods...
		public override function resize(height:Number = undefined, width:Number = undefined):void {
			super.resize(height, width);
			try {
				this.__btnclose.x = this.__media.x + this.__media.width;
				this.__btnclose.y = this.__media.y;
			}
			catch (_error:Error) {
				//...
			};
		};
	};
};
