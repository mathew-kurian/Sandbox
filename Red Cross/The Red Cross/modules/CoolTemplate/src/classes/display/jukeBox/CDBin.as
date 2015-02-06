/*
CDbin.as
JukeBox

Created by Alexander Ruiz Ponce on 28/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.motion.easing.Bounce;
	
	import org.bytearray.display.ScaleBitmap;
	import gT.display.Draw;
	import gs.TweenMax;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class CDBin extends Sprite 
	{
		
		private var __mask:Sprite;
		private var __hit:Sprite;
		private var __cd:Bitmap;
		private var __hole:ScaleBitmap;
		private var __holeShadow:ScaleBitmap;
		private var __dropArrow:Bitmap;
		private var __h:Number;
		
		public function CDBin () 
		{
			height = 70;
			// buttonMode = true;
			init();
		}
		
		private function init (e:Event = null):void
		{	
			var w:uint = 248;
			//var h:uint = 70;
			
			// mask
			__mask = Draw.rectangle(w, __h, 0xff0000, .5);
			addChild(__mask);
			mask = __mask;
			
			// Invisible hit
			__hit = Draw.rectangle(w, __h, 0xff0000, 0);
			__hit.y = __mask.height -  __hit.height;
			__hit.name = "CDBinHit"
			addChild(__hit);
			
			// Hole
			__hole = new ScaleBitmap(new BJukeBoxCDBinHole(0,0));
			__hole.scale9Grid = new Rectangle(5, 1, 17, 3);
			__hole.width = w;
			__hole.y = __mask.height - __hole.height;
			addChild(__hole);
			
			// CD
			__cd = new Bitmap(new BJukeBoxCD(0,0));
			__cd.x = Math.round((w - __cd.width) / 2);
			__cd.y = __mask.height - __cd.height;
			addChild(__cd);
			
			// Drop Arrow			
			__dropArrow = new Bitmap(new BDropArrow(0, 0));
			__dropArrow.smoothing = true;
			addChild(__dropArrow);
			__dropArrow.x = Math.round((w - __dropArrow.width) / 2);
			//__dropArrow.y = -10;
			__dropArrow.visible = false;
			
			// shadown
			__holeShadow = new ScaleBitmap(new BJukeBoxCDBinHoleShadow(0,0));
			__holeShadow.scale9Grid = new Rectangle(5, 1, 17, 3);
			__holeShadow.width = w;
			__holeShadow.y = __hole.y;
			addChild(__holeShadow);
			
			// Evensts
			addEventListener(MouseEvent.CLICK, handler, false, 0, true);
			Global.addEventListener(CustomEvent.DRAG_DISC, onDragAndDropDiscHandler, false, 0, true);
			Global.addEventListener(CustomEvent.DROP_DISC, onDragAndDropDiscHandler, false, 0, true);
		}
				
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		public function change ():void
		{
			if (!TweenMax.isTweening(__cd)) {
				dispatchEvent(new JukeBoxEvent(JukeBoxEvent.CD_BIN_CHANGE));
				TweenMax.to(__cd, Global.settings.time/2, {y:__mask.height, ease:Global.settings.easeInOut, yoyo:1});
			}
		}
		
		public function hide ():void
		{
			if (!TweenMax.isTweening(__cd)) {
				TweenMax.to(__cd, Global.settings.time/2, {y:__mask.height, ease:Global.settings.easeInOut});
			}
		}
		
		public function show (delay:Number = 0):void
		{
			if (!TweenMax.isTweening(__cd)) {
				TweenMax.to(__cd, Global.settings.time/2, {y:__mask.height - __cd.height, ease:Global.settings.easeInOut, delay:delay});
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function handler (e:MouseEvent):void
		{
			dispatchEvent(new JukeBoxEvent(JukeBoxEvent.CD_BIN_CLICKED));
			change();
		}
		
		private function onDragAndDropDiscHandler (e:CustomEvent):void
		{
			if (e.type == CustomEvent.DRAG_DISC) {
				hide();
				__dropArrow.y = 0;
				__dropArrow.visible = false;
				__dropArrow.alpha = 0;
				
				TweenMax.to(__dropArrow, Global.settings.time, {y:__mask.height - __dropArrow.height, autoAlpha:1, ease:Bounce.easeOut, loop:0});
			} else {
				show(.2);
				TweenMax.to(__dropArrow, Global.settings.time, {y:__mask.height + 10, ease:Global.settings.easeOut, onComplete:function () {
							TweenMax.killTweensOf(__dropArrow);
							}});
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		override public function set height (value:Number):void
		{
			__h = value;
		}
		override public function get height ():Number
		{
			return __h;
		}
	}
}