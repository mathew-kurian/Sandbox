/*
 TemplateManager
 CoolTemplate
 
 Created by Alexander Ruiz on 18/11/09.
 Copyright 2009 goTo! Multiemdia. All rights reserved.
 */
package classes.templates 
{
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gT.display.components.GenericComponent;
	import gT.utils.ObjectUtils;
	import classes.Global;
	import classes.CustomEvent;
	
	public class TemplateManager extends EventDispatcher {
		
		private var __holder:GenericComponent;
		private var __currentTemplate:Template;
		
		public function TemplateManager (holder:GenericComponent) {
			__holder = holder;
			init();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function init ():void
		{
			__holder.addEventListener(Event.RESIZE, resize, false, 0, true);
		}
		
		
		private function resize (e:Event = null):void
		{
			var w = __holder.width;
			var h = __holder.height;
			
			if (__currentTemplate) {
				__currentTemplate.width = w;
				__currentTemplate.height = h;
			}
		}
		
		private function templateHandler (e:CustomEvent):void
		{
			var current = e.currentTarget;
			switch (e.type) {
				case CustomEvent.TEMPLATE_ON:
					//<#statements#>
					break;
				case CustomEvent.TEMPLATE_OFF:
					current.removeEventListener(CustomEvent.TEMPLATE_ON, templateHandler);
					current.removeEventListener(CustomEvent.TEMPLATE_OFF, templateHandler);
					__holder.removeChild(current);
					current = null;
					break;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		public function createTemplate ():void
		{
			var templateInfo = Global.templateInfo;
			// ObjectUtils.traceObject(templateInfo.data);
			
			switch (templateInfo.type) {
				case "text":
					__currentTemplate = new TextTemplate(templateInfo.data);
					break;
				case "news":
					__currentTemplate = new NewsTemplate(templateInfo.data);
					break;
				case "contact":
					__currentTemplate = new ContactTemplate(templateInfo.data);
					break;
				case "music":
					__currentTemplate = new MusicTemplate(templateInfo.data);
					break;
				case "custom":
					__currentTemplate = new PluginTemplate(templateInfo.data);
					break;
				case "plugin":
					__currentTemplate = new PluginTemplate(templateInfo.data);
					break;
			}
			
			resize();
			
			if(__currentTemplate){
				__currentTemplate.addEventListener(CustomEvent.TEMPLATE_ON, templateHandler, false, 0, true);
				__currentTemplate.addEventListener(CustomEvent.TEMPLATE_OFF, templateHandler, false, 0, true);
				__holder.addChild(__currentTemplate);
				__currentTemplate.on();
			}
		}
		
		public function off ():void {
			if (__currentTemplate) {
				__currentTemplate.off();
				__currentTemplate = null;
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}