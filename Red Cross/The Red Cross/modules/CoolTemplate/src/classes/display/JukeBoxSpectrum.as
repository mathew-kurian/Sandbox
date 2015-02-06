/*
JukeBoxSpectrum.as
JukeBox

Created by Alexander Ruiz Ponce on 27/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;
	
	import classes.display.jukeBox.JukeBox;
	import classes.Global;
	
	public class JukeBoxSpectrum extends GenericComponent {
		
		private var __jukeBox:JukeBox;
		private var __spectrum:Spectrum;
		
		public function JukeBoxSpectrum () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		
		/*
		override protected function init ():void
		{			
			super.init();
		}
		
		/*
		override protected function onStage():void
		{
		}
		*/
		override protected function addChildren():void
		{
			// Create an instance of Spectrum
			__spectrum = new Spectrum();
			__spectrum.height = 200;
			
			// Add the spectrum only if Global.settings.jukeBoxShowSpectrum is true
			if (Global.settings.jukeBoxShowSpectrum) addChild(__spectrum);
			
			// Create an instance of JukeBox
			__jukeBox = new JukeBox();
			addChild(__jukeBox);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__jukeBox.x = (__width - __jukeBox.width) / 2;
			__spectrum.width = __width;
			__spectrum.y = -__spectrum.height + 50;
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
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get jukeBox ():JukeBox
		{
			return __jukeBox;
		}
		
		public function set data (value:Array):void
		{
			__jukeBox.data = value;
		}
		
		public function set autoPlay (value:Boolean):void
		{
			__jukeBox.autoPlay = value;
		}
	}
}