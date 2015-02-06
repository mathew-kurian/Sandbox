/*
 CircularGalleryManager.as
 CoolTemplate
 
 Created by Carlos Vergara Marrugo on 29/10/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.display.circularGallery
{
	
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class CircularGalleryManager extends EventDispatcher {
		
		private var __gallery:CircularGallery;
		private var __items:Array;
		private var __contMain:uint;
		private var __mainItems:Array;
		private var __cont:uint;
		private var __contSubItems:uint;
		private var __itemsToAdd:Array;
		private var __externalClick:Boolean;
		private var __itemPoint:Point = new Point;
		
		public function CircularGalleryManager() {
			__mainItems = [];
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		public function addMainItems(items:Array){
			for(var i:uint;i < items.length;i++){
				var item = new CircularGalleryItem(items[i]);
				item.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_LOAD_COMPLETE, itemHandler, false, 0, true);
				__mainItems[i] = item;
			}
			__contMain = 0;
			__mainItems[__contMain].load();
			
			createCircularGallery();
		}
		
		public function addSubItems (data:Array):void
		{
			__itemsToAdd = new Array;
			
			for(var i:uint;i < data.length;i++){
				var item = new CircularGalleryItem(data[i]);
				item.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_LOAD_COMPLETE, subItemsCompleteHandler, false, 0, true);
				__itemsToAdd.push(item);
			}
			__contSubItems = 0;
			__itemsToAdd[__contSubItems].load();
			
			__gallery.addItems(__itemsToAdd);
		}
		
		public function click (index:uint):void
		{
			if (!__mainItems) return;
			
			__externalClick = true;
			__mainItems[index].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		public function closeContent ():void
		{
			if (__gallery.selected) {
				if (__gallery.selected.contentType == "content" && __gallery.open )
				{
					__gallery.selected.expander.showIcon("expand");
					__gallery.close();
				}
			}
			
			if (__gallery.selectedSubItem) {
				if(__gallery.selectedSubItem.contentType == "content")
				{
					__gallery.selectedSubItem.expander.showIcon("expand");
					__gallery.close("close", true);
				}
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function createCircularGallery(){
			__gallery = new CircularGallery(__mainItems);
			__gallery.addEventListener(CustomEvent.CIRCULAR_GALLERY_MOVE_COMPLETE, galleryHandler, false, 0, true);
		}
		
		private function galleryHandler(e){
			if(__gallery.selected.contentType == "gallery" && !__gallery.selectedSubItem){
				__gallery.dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_OPEN_START, null, true));
			}else{
				__gallery.openContent();
				__gallery.dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_OPEN_CONTENT_START, null, true));
			}
		}
		
		
		
		private function subItemsCompleteHandler(e){
			
			if(__contSubItems < __itemsToAdd.length-1){
				__contSubItems++;
				__itemsToAdd[__contSubItems].load();
			}
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, mainItemDownHandler, false, 0 , true);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, subItemUpHandler, false, 0 , true);
		}
		
		private function subItemUpHandler(e:MouseEvent){
			if(!__gallery.busy){

				var point:Point = new Point(__gallery.mouseX, __gallery.mouseY);
				
				if((point.x == __itemPoint.x) && (point.y == __itemPoint.y)) {
					
					if(__gallery.selectedSubItem == e.currentTarget){
						if(__gallery.selectedSubItem.contentType == "content"){
							__gallery.selectedSubItem.expander.showIcon("expand");
							__gallery.close("close", true);
						}
					}else{
						if(__gallery.selectedSubItem == undefined){
							__gallery.selectedSubItem = e.currentTarget;
							
							if(__gallery.selectedSubItem.contentType == "content"){
								__gallery.selectedSubItem.expander.showIcon("unexpand");
								__gallery.slide();
							}
						}else{
							if(__gallery.selectedSubItem.contentType == "content"){
								__gallery.selectedSubItem.expander.showIcon("expand");
								if(e.currentTarget.contentType == "content"){
									__gallery.close("change", true);
									__gallery.selectedSubItem = e.currentTarget;
								}
								
							}else{
								if(e.currentTarget.contentType == "content"){
									//__gallery.close("change", true);
									__gallery.selectedSubItem = e.currentTarget;
									__gallery.slide();
								}
							}
							
						}
						
						dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_SUB_ITEM_CLICKED, {target:e.currentTarget, index:e.currentTarget.id}));
					}		
				}
			}
		}
		
		private function itemHandler(e:CustomEvent){			
			if(__contMain < __mainItems.length-1){
				__contMain++;
				__mainItems[__contMain].load();
			}
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, mainItemDownHandler, false, 0 , true);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, mainItemUpHandler, false, 0 , true);
		}
		
		private function mainItemDownHandler(e:MouseEvent){
			if(!__gallery.busy){
				__itemPoint = new Point(__gallery.mouseX, __gallery.mouseY);
			}
		}
		
		private function mainItemUpHandler(e:MouseEvent){
			if(!__gallery.busy){
				var point:Point = new Point(__gallery.mouseX, __gallery.mouseY);
				if((point.x == __itemPoint.x) && (point.y == __itemPoint.y) || __externalClick) {
					// Was click
					__gallery.selectedSubItem = undefined;
					
					// Determine if currentTarget is equal to selected item in the gallery
					
					if(__gallery.selected == e.currentTarget) {
						// If is equal them the gallery has to close
						__gallery.selected.expander.showIcon("expand");
						__gallery.close();
					}else{
						// Determine whether or not exist a selected item in the gallery
						if(__gallery.selected == undefined) {
							
							if (e.currentTarget.contentType == "externalLink") {
								// none
							} else {
								__gallery.selected = e.currentTarget;
								__gallery.slide();
								__gallery.selected.expander.showIcon("unexpand");
							}
						}else{
							__gallery.selected.expander.showIcon("expand");
							
							if(e.currentTarget.contentType != "externalLink"){
								__gallery.close("change");
								__gallery.selected = e.currentTarget;
								__gallery.selected.expander.showIcon("unexpand");
							}
						}
						
						if (!__externalClick) {
							dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_ITEM_CLICKED, {target:e.currentTarget, index:e.currentTarget.id}));
						}
					}
				}
			}	
			__externalClick = false;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function get gallery():CircularGallery{
			return __gallery;
		}
		
	}
}