/*
 CircularGallery.as
 CoolTemplate
 
 Created by Carlos Vergara Marrugo on 29/10/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.display.circularGallery
{
	
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.motion.easing.*;
	
	import gT.display.components.GenericComponent;
	import gT.utils.ObjectUtils;
	import gs.TweenMax;
	
	import classes.CustomEvent;
	import classes.Global;
	
	public class CircularGallery extends GenericComponent{
		
		private var __radius:Number = 2550;
		private var __angleRange:Number = -90;
		private var __separation:uint = 10;
		private var __betweenAngle:Number;
		private var __items:Array;
		private var __galleryItems:Array;
		private var __dragging:Boolean;
		private var __initMousePos:Point = new Point;
		private var __finalMousePos:Point = new Point;		
		private var __lastX:Number = 0;
		private var __currentX:Number = 0;
		private var __vx:Number = 0;
		private var __lastY:Number = 0;
		private var __currentY:Number = 0;
		private var __vy:Number = 0;
		private var __offSetAngle:Number = 0;
		private var __acum:Number = 0;
		private var __totalItemsAngle:Number = 0;
		private var __availableAngle:Number = 0;
		private var __limitAngle:Number = 0;
		private var __middleItemsAngle:Number = 0;
		private var __busy:Boolean;
		private var __selectedItem;
		private var __selectedSubItem;
		private var __inertia:Number = Global.settings.galleryInertia || 0;
		private var __tweenSpeed:Number = 1;

		private var __open:Boolean;
		private var __radians:Number;
		private var __openSize:uint  = 500;
		private var __itemsAdded:Array;
		private var __checkPos:Boolean;
		private var __dragDirection:String;
		
		public static const D2R:Number = Math.PI / 180;
		public static const R2D:Number = 180 / Math.PI;
		
		public static const MOVE_COMPLETE:String = "moveComplete";
		public static const MOVE_COMPLETE_SUBITEM:String = "moveCompleteSubItem";
		
		public function CircularGallery(items:Array):void{
			__galleryItems = [];
			__items = items;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function addChildren():void
		{
			for(var i:uint;i < __items.length;i++){
				
				__galleryItems[i] = __items[i];
				__galleryItems[i].id = i;
				
				if(i == 0){
					__betweenAngle = radiansToDegree(Math.atan((__items[i].width+__separation) / __radius));
				}
			
				addChild(__galleryItems[i]);
			}
			
			__totalItemsAngle = __betweenAngle*(__galleryItems.length-1);
			__middleItemsAngle = __totalItemsAngle / 2;
		}
		
		override protected function onComponentReady():void
		{
			var offSetAngle = 0;
			if(__totalItemsAngle < __availableAngle){
				offSetAngle = __middleItemsAngle
			}else{
				offSetAngle = __limitAngle;
			}
			for(var i:uint;i < __galleryItems.length; i++){
				
				setItem(__galleryItems[i], i, (__betweenAngle * i) + (__angleRange - offSetAngle));
			}
			
			start();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		public function addItems(items:Array):void
		{
			var i:uint = 0;
			__itemsAdded = items;
			
			for(i = 0; i < items.length; i++){
				addChild(items[i]);
				setItem(items[i], i, __betweenAngle + (__betweenAngle * i) + __selectedItem.currentAngle);
			}
			
			
			var con = 1;
			var startIndex = __selectedItem.id;
			for (i = 0; i < items.length; i++)
			{	
				__galleryItems.splice(startIndex+con, 0, items[i])
				con++;
			}
			
			for(i = startIndex+1; i < __galleryItems.length; i++){
				__galleryItems[i].id = i;
			}
			
			__totalItemsAngle = __betweenAngle*(__galleryItems.length-1);
			
			if(__selectedItem.id == (__galleryItems.length-1)-items.length){
				onCompleteMoveItems();
				return;
			}
			
			
			moveItems(__selectedItem.id+items.length+1, getRadians(__selectedItem.y, __selectedItem.x, items[items.length-1].y, items[items.length-1].x));
		}
		
		private function setItem(item, id, angle):void
		{
			var degrees:Number = angle;
			var radianAngle:Number = degreeToRadians(degrees);
			
			item.x = __radius*Math.cos(radianAngle);
			item.y = __radius*Math.sin(radianAngle);
			item.rotation =  (degrees)+90;	
			item.rot = item.rotation;
			item.angle = degrees;
			
			item.currentAngle = item.angle;
		}
		
		public function start():void
		{
			Global.addEventListener(CustomEvent.GLOBAL_RENDER, onEnterframe, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag, false, 0, true);
		}
		
		public function stop():void
		{
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, onEnterframe);
			removeEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		public function slide(content:Boolean = false):void
		{
			dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_SLIDE_START, null, true));
			
			__busy = true;
			stop();
			updateItemsData();
			
			var pos;
			var item;
			
			
			if(__selectedSubItem){
				item = __selectedSubItem;
				pos = -__openSize;
			}else{
				item = __selectedItem;
				pos = -__openSize;
			}
			
			var radians = getRadians(item.y, item.x, -__radius, pos);
			
			
			TweenMax.to(this, __tweenSpeed, {offSetAngle:radians, ease:Exponential.easeInOut, onUpdate:draw, onComplete:onComplete});
			
			function onComplete () {
				updateItemsData();
				dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_MOVE_COMPLETE, null, true));
			}
		}
		
		public function openContent(){
			
			if(__selectedItem.id == __galleryItems.length-1){
				onCompleteMoveItems();
				return;
			}
			
			if(__selectedSubItem){
				if(__selectedSubItem.id == __galleryItems.length-1){
					onCompleteMoveItems();
					return;
				}
			}
			
			var index:uint = (__selectedSubItem) ? __selectedSubItem.id+1 : __selectedItem.id+1;
			
			moveItems(index, getRadians(__galleryItems[index].y,__galleryItems[index].x, -__radius, __openSize));
		}
		
		public function moveItems(index:uint, radianDistance:Number, mode:String = "open"){
			__busy = true;
			
			TweenMax.to(this, __tweenSpeed, {offSetAngle:radianDistance, ease:Exponential.easeInOut, onUpdate:onUpdate, onComplete:onCompleteMoveItems, onCompleteParams:[mode]});
			
			function onUpdate () 
			{
				distribute(index);
			}
		}
		
		public function close(mode:String = "close", closeSubItem:Boolean = false, timeOut:Number = 0){
			var index:uint;
			var startAngle:Number;
			var endAngle:Number;
			var radianBetween:Number;
			var radians:Number;
			var radianPos:Number;
			
			stop();
			
			if(__itemsAdded && closeSubItem == false){
				var i:uint;				
				
				index = __selectedItem.id+1;
				
				for(i = index; i < (index+__itemsAdded.length);i++){
					var item = __galleryItems.splice(index,1)[0];
					item.addEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_OFF, destroyItem, false, 0, true);
					item.off();	
				}
				__totalItemsAngle = __betweenAngle*(__items.length-1);
				
				var con:uint = 0;
				for(i = index; i < __galleryItems.length;i++){
					
					__galleryItems[i].id = index + con;
					con++;
				}
				
				__itemsAdded = null;
				
				if(__selectedItem.id == __galleryItems.length-1){
					
					TweenMax.delayedCall(.1, onCompleteMoveItems, [mode]);
					return;
				}
				
				radianBetween = degreeToRadians(__betweenAngle);
				
				radians = getRadians(__galleryItems[index].y, __galleryItems[index].x,__selectedItem.y, __selectedItem.x);
				radianPos = radians+radianBetween;
				
				moveItems(index, radianPos, mode);
				
			} else {
				index = (__selectedSubItem) ?__selectedSubItem.id : __selectedItem.id;
				
				if((index == __galleryItems.length-1) && mode == "close"){
					onCompleteMoveItems(mode, true);
					dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_CLOSE_START, null, true));
					return;
				}else if((index == __galleryItems.length-1) && mode == "change"){
					TweenMax.delayedCall(.1, onCompleteMoveItems, [mode]);
					dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_CLOSE_START, null, true));
					return;
				}
				
				radianBetween = degreeToRadians(__betweenAngle);
				radians = getRadians(__galleryItems[index+1].y, __galleryItems[index+1].x, __galleryItems[index].y, __galleryItems[index].x);
				radianPos = radians + radianBetween;
				
				TweenMax.delayedCall(timeOut, function () {
									 
									 moveItems(index+1, radianPos, mode);
									 
									 });
			}
			
			
			dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_CLOSE_START, null, true));
		}
		
		override public function draw():void{
			distribute();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function onStartDrag(e):void
		{
			__dragging = true;
			__offSetAngle = 0;
			
			__initMousePos = new Point(mouseX, mouseY);
	
			updateItemsData();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		}
		
		private function onStopDrag(e):void
		{
			__finalMousePos = new Point(mouseX, mouseY);
			//Get the Dragging Direction
			if(x - __initMousePos.x < x - __finalMousePos.x ){
				__dragDirection = "right";
			}else{
				__dragDirection = "left";
			}
			
			updateItemsData();
			__dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function getRadians(v1:Number, v2:Number, v3:Number, v4:Number):Number{
			var startAngle:Number = Math.atan2(v1, v2);
			var endAngle:Number = Math.atan2(v3, v4);
			return getRadianDistance(startAngle, endAngle);
		}
		
		private function onCompleteMoveItems(mode:String = "open", sw:Boolean = false){
				
			updateItemsData();
			__open = true;
			__busy = false;
			
			if(mode == "reset"){
				start();
				return;
			}
			
			if(mode == "close"){
				var aux = __selectedItem;
				__checkPos = true;
				__dragging = false;
				
				__lastX = 0;
				__currentX = 0;
				__vx = 0;
				__lastY = 0;
				__currentY = 0;
				__vy = 0;
				
				if(__selectedSubItem){
					if(__selectedSubItem.contentType != "content"){
						__selectedItem = null;
					}
					__selectedSubItem = null;
				}else{
					
					__selectedItem = null;
					__open = false;
				}
				if(sw){
					updateItemsData();
					reset(aux, "right");
				}else{
					start();
				}
				
				dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_ITEM_CLOSED, {isSubItem:__open}, true));
			}
			
			if(mode == "change"){
				if(__selectedSubItem){
					if(__selectedSubItem.contentType != "content"){
						slide();
					}else{
						slide(true);
					}
				}else{
					slide();
				}
			}
			
			if(mode == "open" && __selectedItem.contentType != "content"){
				if(__selectedSubItem){
					if(__selectedSubItem.contentType != "content"){
						start();
					}
				}else{
					dispatchEvent(new CustomEvent(CustomEvent.CIRCULAR_GALLERY_OPEN_COMPLETE, null, true));
					start();
				}
			}
		}
		
		private function updateItemsData(){			
			for(var i:uint = 0;i < __galleryItems.length; i++){
				__galleryItems[i].angle = __galleryItems[i].currentAngle;
				__galleryItems[i].rot = __galleryItems[i].rotation;
			}
			__offSetAngle = 0;
		}
		
		private function destroyItem (e:CustomEvent):void
		{
			var item = e.currentTarget;
			item.removeEventListener(CustomEvent.CIRCULAR_GALLERY_ITEM_OFF, destroyItem);
			removeChild(item);
			item = null;
		}
		
		private function mouseMoveHandler(e:MouseEvent){
			__offSetAngle = getRadians(__initMousePos.y, __initMousePos.x, mouseY, mouseX);			
			__checkPos = true;
			e.updateAfterEvent();
		}
		
		private function onEnterframe(e:Event):void
		{
			if(__dragging)
			{
				__lastX = __currentX;
				__currentX = mouseX;
				__vx = __currentX - __lastX;
				
				__lastY = __currentY;
				__currentY = mouseY;
				__vy = __currentY - __lastY;
			}else{
				
				if(__finalMousePos.equals(__initMousePos)){
					return;
				}
				
				var totalAngle = getRadians(__lastY, __lastX, (__lastY + __vy), (__lastX + __vx));
				__offSetAngle += totalAngle
				__vx *= __inertia;
				__vy *= __inertia;				
				
				
				if(Math.abs(__vx) < 0.2 && Math.abs(__vy) < 0.2) {
					__vx = 0;
					__vy = 0;
					updateItemsData();
					
					//Find the center
					
					
					if(__totalItemsAngle < __availableAngle && __checkPos && !__busy){
						__checkPos = false;
						stop();
						reset(__galleryItems[0]);
						return;
					}
					
					var angleFirstItem:Number = __galleryItems[0].angle;
					var angleLastItem:Number = __galleryItems[__galleryItems.length-1].angle;
					var limitLeft:Number = __angleRange-__limitAngle;
					var limitRight:Number = __angleRange+__limitAngle;
					
					//Find the left
					if((angleFirstItem > limitLeft && angleFirstItem < limitRight) && !(angleLastItem > limitLeft && angleLastItem < limitRight) && __checkPos){
						__checkPos = false;
						stop();
						reset(__galleryItems[0], "left");
						return;
					}
					
					//Find the right
					if(!(angleFirstItem > limitLeft && angleFirstItem < limitRight) && (angleLastItem > limitLeft && angleLastItem < limitRight) && __checkPos){
						__checkPos = false;
						stop();
						reset(__galleryItems[__galleryItems.length-1], "right");
						return;
					}

					//Check if there is no items in the available range
					if(!checkItemsInRange() && __checkPos){
						__checkPos = false;
						stop();
						
						validateDirection();
						return;
					}
				
					//Check is the first and last item are in the available range
					if((angleFirstItem > limitLeft && angleFirstItem < limitRight) && (angleLastItem > limitLeft && angleLastItem < limitRight) && __checkPos){
						__checkPos = false;
						stop();
						validateDirection();
						return;
					}
					
					//check whether or not there are items in the available range
					function checkItemsInRange():Boolean{
						for(var i in __galleryItems){
							var item = __galleryItems[i];
							if((item.angle > limitLeft && item.angle < limitRight)){
								return true;
							}
						}
						return false;
					}
					
					//validates dragging direction to Reset
					function validateDirection(){
						if(__dragDirection == "left"){
							reset(__galleryItems[0], "left");
						}else{
							reset(__galleryItems[__galleryItems.length-1], "right");
						}
					}
				}
			}
			
			draw();
		}
		
		private function reset(item, direction:String = null){
			var limitLeft:Number = __angleRange-__limitAngle;
			var limitRight:Number = __angleRange+__limitAngle;
			var startAngle = Math.atan2(item.y,item.x);
			var radianAngle:Number = 0;
			var endAngle:Number;
			var radians :Number;
			var radianPos:Number;
			
			if(direction == "left"){
				endAngle = degreeToRadians(limitLeft);
				
				
			}else if(direction == "right"){
				endAngle = degreeToRadians(limitRight);
			} else {
				endAngle = degreeToRadians(__angleRange);
				radianAngle = degreeToRadians(__middleItemsAngle);
			}
			
			radians =  getRadianDistance(startAngle, endAngle);
			radianPos = radians - radianAngle;
			moveItems(0, radianPos, "reset");
		}
		
		private function distribute (startIndex:uint = 0):void
		{
			var i:uint = startIndex;
			var l:uint = __galleryItems.length;
			
			for(i; i < l; i++) {	
				var item = __galleryItems[i];
				var v = degreeToRadians(item.angle) +__offSetAngle;
				var offSetAngleDegree = radiansToDegree(__offSetAngle);
				item.x = __radius*Math.cos(v);
				item.y = __radius*Math.sin(v);
				item.rotation =  (item.rot)+ radiansToDegree(__offSetAngle);
				item.currentAngle = ((item.angle) + radiansToDegree(__offSetAngle)) % 360;
			}
		}
		
		private function radiansToDegree(value:Number):Number{
			return value * R2D;
		}
		
		private function degreeToRadians(value:Number):Number{
			return value * D2R;
		}
		
		private function getRadianDistance(alpha:Number, beta:Number):Number {
			var delta:Number = (beta - alpha);
			
			return Math.atan2(Math.sin(delta), Math.cos(delta));			
		}
		
		private function getDegreeDistance(alpha:Number, beta:Number):Number {
			var delta:Number = D2R * (beta - alpha);
			return Math.atan2(Math.sin(delta), Math.cos(delta)) * R2D;			
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function set radius(value:Number):void{
			__radius = value;
			draw();
		}
		
		public function get radius():Number{
			return __radius;
		}
		
		public function get limitAngle():Number{
			return __limitAngle;
		}
		
		public function get initMousePos():Point {
			return __initMousePos;
		}
		
		public function set selected(value){
			__selectedItem = value;
		}
		
		public function get selected(){
			return __selectedItem;
		}
		
		public function set selectedSubItem(value){
			__selectedSubItem = value;
		}
		
		public function get selectedSubItem(){
			return __selectedSubItem;
		}
		
		public function set offSetAngle(value){
			__offSetAngle = value;
		}
		
		public function get open ():Boolean
		{
			return __open;
		}
		
		public function get offSetAngle(){
			return __offSetAngle;
		}
		
		public function get busy(){
			return __busy;
		}
		
		public function set inertia (value:Number):void
		{
			__inertia = value;
		}
		
		public function get mainItems ():Array
		{
			return __items;
		}
		
		override public function set x(value:Number):void{
			super.x = value;
			var p = Math.atan(x / __radius);
			__limitAngle = radiansToDegree(p) - 2 ;
			__availableAngle = __limitAngle*2; 
		}
	}
}