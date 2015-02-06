// Advance Wall 3D
// RimV: www.mymedia-art.com || trieuduchien@gmail.com 
// Please read documentation before customizing

package {
	
	// Tweener, Flash class and Greate White Papervision3D 2.0
	import caurina.transitions.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Dictionary;
	
	import org.papervision3d.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	//_________________________________________________ MAIN CLASS
	
	public class adWall3D extends Sprite
	{
		
		//------------------------ PARAMETERS -----------------------//
		// Tweening parameters, more Tweener information at:
		// http://hosted.zeh.com.br/tweener/docs/en-us/
		private var easeFactor:Number = 0.01; // easing of camera's orientation 
		private var cameraTweenTime:Number = 2;
		private var cameraTweenEasing:String = "easeOutQuint";
		private var scrubberTweenTime:Number = 1;
		private var planeTweenTime:Number = 2;
		private var planeTweenEasing:String = "easeOutQuint";
		
		// Gallery property
		private var categoryDistance:Number = 500;
		private var categoryAngle:Number = 20;
		
		// Distance between photos
		private var XDist:Number = 220;
		private var YDist:Number = 220;
		
		// Pressed photo moves to front
		private var moveForward:Number = 150;
		
		// Camera Default property
		private var cameraZMin:Number = 250;
		private var cameraY:Number = 0;
		private var cameraZDefault:Number = -600;
		// camera angle delta
		private var CAMDELTA:Number = 20;
		
		// Plane infor
		private var planeDoubleSide:Boolean = false;
		private var planeSmooth:Boolean = true;
		private var planePrecise:Boolean = true;
		private var transparent:Boolean = false;
		private var quality:Number = 1;
		
		// Transparency
		private var photoTransparent:Boolean = false;
		
		// Scrubber 
		private var scrubberStep:Number = 40.6;
		
		// Reflection
		private var reflection:Boolean = true; // turn on/off reflection
		private var refDist:Number = 200;  	//Distance from image to its corresponding reflection
		private var refCateDist:Number = 500;  	//Distance from category image to its corresponding reflection
		private var refIn1:Number = 0.5;	// Reflection Intensity 1
		private var refIn2:Number = 0;		// Reflection Intensity 2
		private var refDen1:Number = 0;		// Reflection Density 1
		private var refDen2:Number = 100;	// Reflection Density 2
		private var refSmooth:Boolean = false;	// Smooth Reflection
		private var refDoubleSide:Boolean = false;	// 2 side Reflection
		
		// XML/CSS path
		private var mainXML:String = "adWall3D.xml";	// XML path
		private var css_path:String = "css/styles.css" // CSS path
		
		//--------------- end of -- PARAMETERS -----------------------//
		
		
				
		//------------------------ 3D VARS --------------------------//
		
		private var scene:Scene3D = new Scene3D();
		private var camera:FreeCamera3D = new FreeCamera3D();
		private var cameraZoom:Number = 5;
		private var viewport:Viewport3D;
		private var renderer:BasicRenderEngine = new BasicRenderEngine();
				
		//--------------- end of -- 3D VARS -----------------------//
		
		
		//------------------------ XML VARS --------------------------//
		
		private var xmlLoader:URLLoader = new URLLoader();
		private	var xmlData:XML = new XML();
		
		//--------------- end of -- XML VARS -----------------------//
		
		
		//------------------------ GENERAL DATA --------------------------//
		
		private var TOTAL:Number; 	// Number of images/videos/mp3s
		private var description:Array = new Array();
		
				
		//------------------------ GENERAL DATA --------------------------//
		
			
		//------------------------ MISC VARS -----------------------//
		private var cID:Number = 0;	// Current pressed plane ID
		private var currentPlane:Plane;
		private var currentCategory:Number;
		private var currentPhoto:Number = undefined;
		private var count:Number = 0;
		private var categoryMode:Boolean = true;
		private var galleryMode:Boolean = false;
		private var rollOver:Boolean = false;
		private var rollOverBar:Boolean = false;
		private var rollOverLeft:Boolean = false;
		private var rollOverRight:Boolean = false;
		private var category:Array = new Array();
		private var categoryInfor:Dictionary = new Dictionary();
		private var pInfor:Dictionary = new Dictionary();
		private var cameraCenter:Number;
		private var j0:Number;
		private var i0:Number;
		private var range:Number;
		private var deltaX:Number;
		private var deltaY:Number;
		private var lPlane:Plane;
		private var cPlane:Plane;
		private var refTemp:Plane;
		private var cameraAngle:Number;
		private var newCameraPos:Number;
		private var delta:Number;
		private var categoryRollOver:Boolean = false;
		private var categoryBoardRollOver:Boolean = false;
		private var categorySelected:Boolean = false;
		//sliding limit, these 2 values indicate the range of scrubber
		private var sl1:Number = 41; 
		private var sl2:Number = 406;
		private var css:StyleSheet = new StyleSheet(); // StyleSheet
		
		//------------------------ MISC VARS -----------------------//
		
		
		
		//___________________________________________________ CONSTRUCTOR: Intial 3D and Start creating Gallery
		
		public function adWall3D()
		{
			// Initial 3d environment
			Initial3D();
			
			// Create 3D Gallery
			create3DGallery();	
		}
		
		// Inital 3D
		public function Initial3D():void
		{
			// Align , scale Stage to full fill screen
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			buttonMode = true;
			// Reposition element if stage is resized
			stage.addEventListener(	Event.RESIZE, rePosition);
			
			// Tempary remove components
			removeChild(chooseCategory);
			removeChild(categoryBoard);		
			removeChild(descriptionClip);
			removeChild(CIcon);
			
			// Viewport
			viewport = new Viewport3D(stage.stageWidth, stage.stageHeight, true, true);
			addChild(viewport);
			
			// Setup Scrollbar
			addChild(scrollBar);
			scrollBar.visible = false;
			scrollBar.alpha = 0;
			// Scroll Bar
			scrollBar.x = (stage.stageWidth - scrollBar.width) * .5 ;
			scrollBar.y = stage.stageHeight - scrollBar.height;
			// Description Clip
			descriptionClip.content.width = stage.stageWidth - 5;
			descriptionClip.back.width = stage.stageWidth;
			descriptionClip.content.autoSize = TextFieldAutoSize.LEFT;
			// Category button
			CIcon.x = stage.stageWidth / 2;
			CIcon.y = stage.stageHeight - 62;
			// Camera 3D
			camera.zoom = cameraZoom;
			camera.y = 0;
			camera.z = cameraZDefault;
			camera.x = -stage.stageWidth;
			// preloader
			removeChild(preloader);
			preloader.x = stage.stageWidth / 2;
			preloader.y = stage.stageHeight / 2; 
			// init Stylesheet
			initStyleSheet();
			//addEventListener(Event.ENTER_FRAME, render3D);
		}
		
		// Create Flowing Stack
		public function create3DGallery():void 
		{
			// Load category from XML
			xmlLoad(mainXML);
		}
		
		
		//__________________________________________________________ LOAD XML
		
		private function xmlLoad(xmlPath:String):void
		{
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.load(new URLRequest(xmlPath));
		}
		
		private function xmlLoaded(e:Event):void
		{
			//Extract data
			xmlData = new XML(e.target.data);
			if (categoryMode)
				ParseCategory(xmlData);
			else
				ParseGallery(xmlData);
		}
		
		private function ParseCategory(data:XML):void
		{
			//Number of category
			TOTAL = data.category.length();
			
			// Show preloader
			addChild(preloader);
			preloader.loadText.text = "Loading Category";
			
			// data saved in separate arrays
			for (var i:uint = 0; i < TOTAL; i++)
			{
				category[i] = new Object();
				category[i].loaded = false;
				category[i].title = data.category.attributes()[i];
				category[i].xmlPath = data.category.xmlPath.attributes()[i];
				category[i].description = data.category.description.text()[i];
				
				//Load Category
				var myLoader:Loader = new Loader();
				var myRequest:URLRequest = new URLRequest(data.category.image.attributes()[i]);
				myLoader.load(myRequest);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, categoryLoaded);
				categoryInfor[myLoader] = i;
				
			}
		}
		
		private function ParseGallery(data:XML):void
		{
			//Number of photos
			category[currentCategory].TOTAL = data.items.item.length();
			category[currentCategory].rows = Number(data.attributes()[0]);
			category[currentCategory].columns = Number(data.attributes()[1]);
			category[currentCategory].asset = new Array();
			var asset:Array = category[currentCategory].asset;
			// data saved in separate arrays
			for (var i:uint = 0; i < category[currentCategory].TOTAL; i++)
			{
				asset[i] = new Object();
				asset[i].description = data.items.item.description.text()[i];
				asset[i].imagePath = data.items.item.image.attributes()[i];
			}
			// init parameters
			deltaX = XDist * category[currentCategory].columns / 2;
			deltaY = YDist * category[currentCategory].rows / 2;
			range = XDist * (category[currentCategory].columns - 1);
			// Show preloader
			addChild(preloader);
			preloader.loadText.text = "Loading Photo";
			loadAsset(currentCategory);
		}
		
		//___________________________________________ LOAD IMAGE ASSET
		
		// Load asset in current category
		private function loadAsset(index:Number):void
		{
			for (var i:uint = 0; i < category[currentCategory].TOTAL; i++)
			{
				var myLoader:Loader = new Loader();
				var myRequest:URLRequest = new URLRequest(category[currentCategory].asset[i].imagePath);
				myLoader.load(myRequest);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetLoaded);
				pInfor[myLoader] = i;
			}
		}
		
		// Asset Loaded, create plane
		private function assetLoaded(e:Event):void
		{
			// retrieve asset
			var loadedObject:Loader = e.target.loader;
			
			// Create Bitmapdata for material
			var bmpData:BitmapData = new BitmapData( loadedObject.width, loadedObject.height, photoTransparent, 0x000000 );
			bmpData.draw(loadedObject);
			
			//Bitmap Material
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bmpData);
			bitmapMaterial.precise = planePrecise;
			bitmapMaterial.interactive = true;
			bitmapMaterial.doubleSided = planeDoubleSide;
			bitmapMaterial.smooth = planeSmooth;
			
			// Create a plane
			var p:Plane = new Plane(bitmapMaterial, loadedObject.width / 2, loadedObject.height / 2, quality, quality);
									
			//retrieve index
			var index:Number = pInfor[loadedObject];
					
			// add to scene
			scene.addChild( p, "category" + currentCategory + "_plane" + index );
			
			// data embeded in each plane
			p.extra = {
				index:new Number
			}
			
			// save index for later reference
			p.extra.index = index;
			
			// Position of Plane
			p.x = j0 * XDist - deltaX;
			p.y = -( i0 * YDist - deltaY + YDist / 2);
			
									
			//______________________________________________________________ REFLECTION
			
			if (reflection && i0 == category[currentCategory].rows - 1) 
			{
				// save reflection for later use
				p.extra.reflection = new Plane();
				
				// Create new reflection Bitmap Data 
				var bitmapData2:BitmapData = new BitmapData( loadedObject.width, loadedObject.height, true, 0x000000);
				
				// Flip vertical
				var m:Matrix = new Matrix();
				m.createBox(1, -1, 0, 0, loadedObject.height);
				bitmapData2.draw( bmpData, m );
				
				//Reflection Bitmap Object
				var b2:Bitmap = new Bitmap(bitmapData2);
				
				// Reflection mask
				m.createGradientBox(loadedObject.width, loadedObject.height,Math.PI/2,loadedObject.height);
				var mymask:Shape = new Shape();
				mymask.graphics.lineStyle(0,0,0);
				mymask.graphics.beginGradientFill("linear", [0x000000, 0x000000],[refIn1, refIn2], [refDen1, refDen2],m) ;
				mymask.graphics.lineTo(0, loadedObject.height);
				mymask.graphics.lineTo(loadedObject.width, loadedObject.height);
				mymask.graphics.lineTo(loadedObject.width, 0)
				mymask.graphics.lineTo(0, 0)
				mymask.graphics.endFill();
				
				// CacheaAsBitmap
				mymask.cacheAsBitmap = true;
				b2.cacheAsBitmap = true;
				
				// Create mask
				b2.mask = mymask;
				
				addChild(b2);
				addChild(mymask);
				
				var bmp3:BitmapData = new BitmapData(loadedObject.width, loadedObject.height, true, 0x000000);
				bmp3.draw(b2);
				
				// Create Reflection plane
				var bm2:BitmapMaterial = new BitmapMaterial(bmp3);
				bm2.precise = false;
				bm2.doubleSided = refDoubleSide;
				bm2.smooth = refSmooth;
				var p2:Plane = new Plane(bm2, loadedObject.width / 2, loadedObject.height / 2, 1, 1);
				
				p2.x = p.x;
				p2.z = p.z
				p2.y = -refDist + p.y;
				p.extra.reflection = p2;
				
				scene.addChild(p2, "category" + currentCategory + "_reflection" + index);
				removeChild(b2);
				removeChild(mymask);
			}
						
			// Interactive Roll Over, Roll Out, Press/Release
			p.addEventListener( InteractiveScene3DEvent.OBJECT_RELEASE, onPlaneRelease, false, 0, true );
			p.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, onPlaneRollOver, false, 0, true );
			p.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, onPlaneRollOut, false, 0, true );
			currentPlane = p;
			
			// Update preloader
			preloader.loadText.text = "Loading Photo " + ++count + "/" + category[currentCategory].TOTAL; 
			
			// Finish loading, add interactive
			if (count == category[currentCategory].TOTAL) 
			{
				category[currentCategory].loaded = true;
				removeChild(preloader);
				// Reset camera property
				camera.z = -300;
				camera.y = 0;
				camera.x = -j0 * XDist + deltaX;
				camera.rotationY = 40;
				cPlane = p;
				// show description 
				addChild(descriptionClip);
				descriptionClip.visible = true;
				descriptionClip.content.htmlText = "<note>" + category[currentCategory].title + "</note>";
				//Show category button
				addChild(CIcon);
				CIcon.visible = true;
				CIcon.alpha = 0;
				currentPhoto = undefined;
				// Show viewport, display gallery, show scrollbar
				viewport.visible = true;
				viewport.alpha = 0;
				scrollBar.visible = true;
				Tweener.addTween([viewport,scrollBar, CIcon], 
											{	alpha:1, 
												time:2
												});
			}
											
			if (++j0 == category[currentCategory].columns) { j0 = 0; ++i0 };
			renderer.renderScene(scene, camera, viewport);
		}
		//___________________________________________ PLANE INTERACTIVE
		
		private function onPlaneRelease(e:InteractiveScene3DEvent):void
		{
			Tweener.removeTweens(camera);
			// retrieve clicked plane
			var p:Plane = e.target as Plane;
			var index:Number = e.target.extra.index;
			
			if (currentPhoto != index)
			{
				currentPhoto = index;
				// Apply new text
				Tweener.addTween(descriptionClip,
									{	y:-descriptionClip.height,
										time:0.5,
										onComplete:function():void
										{
											descriptionClip.content.htmlText = category[currentCategory].asset[index].description;
											descriptionClip.content.width = stage.stageWidth - 5;
											descriptionClip.back.height  = descriptionClip.content.height + 10;
											descriptionClip.back.width = descriptionClip.content.width + 5;
											Tweener.addTween(descriptionClip,{	y:0, time:1});	
										}
									});
			}
													
			lPlane = cPlane;
			refTemp = scene.getChildByName("category" + currentCategory + "_reflection" + lPlane.extra.index) as Plane;
			
			// Tween last plane back to original position
			Tweener.addTween(lPlane, 
								{ 	z: 0,
									time: planeTweenTime,
									transition: planeTweenEasing,
									onUpdate: moveReflection,
									onUpdateParams: [lPlane]
								}
							);
											
			// assign current plane to new one for further tracking
			cPlane = p;
			Tweener.addTween(camera, {	x: p.x,
										y: p.y,
										z: -cameraZMin,
										time: cameraTweenTime,
										transition: cameraTweenEasing,
										
										// Rendering scene on tweening update
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);
										}
									}
								);
								
			// remove camera's movement by moving scrubber
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation2);
			
			// Update camera's orientation
			this.addEventListener(Event.ENTER_FRAME, updateOrientation, false, 0, true);
					
			// Tween plane to front
			Tweener.addTween(p, { 	z: -moveForward,
									time: planeTweenTime,
									transition: planeTweenEasing,
									
									// move reflection 
									onUpdate: function():void
									{
										if (p.extra.reflection != null)
										{
											p.extra.reflection.z = p.z;
										}
									}
								}
								);
								
			// update scrubber position
			Tweener.addTween(scrollBar.scroller.scrubber,	
									{	x: (cPlane.x + deltaX) / range * sl2 + sl1,
										time:scrubberTweenTime
									}
							);
		}
		
		private function moveReflection(p:Plane):void
		{
			if (p.extra.reflection != null) p.extra.reflection.z = p.z;
		}
		
		
		//____________________________________________________ CAMERA's ORIENTATION
		
		// by pressing on thumbnails
		private function updateOrientation(e:Event):void
		{
			// calculate angle of camera's orientation
			cameraAngle = Math.atan((camera.x - cPlane.x) / camera.z) * 180 / Math.PI;
			delta = (cameraAngle - camera.rotationY) * easeFactor;
			
			// subtract or add delta with some number to adjust easing
			camera.rotationY += delta - 0.0005;
							
			if (Math.abs(camera.rotationY) < 0.07) {
				this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			}
			// Render 3D
			renderer.renderScene(scene, camera, viewport);
		}
		
		// by moving scrubber
		private function updateOrientation2(e:Event):void
		{
			// calculate angle of camera's orientation
			cameraAngle = Math.atan((camera.x - newCameraPos) / camera.z) * 180 / Math.PI;
			delta = (cameraAngle - camera.rotationY) * easeFactor;
			
			// subtract or add delta with some number to adjust easing
			camera.rotationY += delta - 0.0005;
							
			if (Math.abs(camera.rotationY) < 0.07) {
				this.removeEventListener(Event.ENTER_FRAME, updateOrientation2);
			}
			
			// Render 3D
			renderer.renderScene(scene, camera, viewport);
		}	
		
		
		private function onPlaneRollOver(e:InteractiveScene3DEvent):void
		{
			rollOver = true;
			var index:Number = e.target.extra.index;
		}
		
		private function onPlaneRollOut(e:InteractiveScene3DEvent):void
		{
			rollOver = false;
		}
		
		//___________________________________________ CATEGORY LOADED
		
		// Category image loaded create 3d plane
		private function categoryLoaded(e:Event):void
		{
			var image:Loader = e.target.loader;
			
			// retrieve thumbnail
			var loadedObject:Loader = e.target.loader;
						
			// Bitmapdata
			var bmpData:BitmapData = new BitmapData( loadedObject.width, loadedObject.height, transparent, 0x000000 );
			bmpData.draw(loadedObject);
			
			//Bitmap Material
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bmpData);
			bitmapMaterial.precise = true;
			bitmapMaterial.interactive = true;
			bitmapMaterial.doubleSided = false;
			bitmapMaterial.smooth = true;
			
			// Create category plane
			var p:Plane = new Plane(bitmapMaterial, loadedObject.width, loadedObject.height, quality, quality);
						
			//retrieve index
			var index:Number = categoryInfor[loadedObject];
					
			// add to scene
			scene.addChild( p, "categoryPlane" + index );
						
			// data embeded in each plane
			p.extra = {
				index:new Number
			}
			
			// save index for later reference
			p.extra.index = index;
			p.x = index * categoryDistance;
						
			//______________________________________________________________ REFLECTION
			
			if (reflection) 
			{
				// save reflection for later use
				p.extra.reflection = new Plane();
				
				// Create new reflection Bitmap Data 
				var bitmapData2:BitmapData = new BitmapData( loadedObject.width, loadedObject.height, true, 0x000000);
				
				// Flip vertical
				var m:Matrix = new Matrix();
				m.createBox(1, -1, 0, 0, loadedObject.height);
				bitmapData2.draw( bmpData, m );
				
				//Reflection Bitmap Object
				var b2:Bitmap = new Bitmap(bitmapData2);
				
				// Reflection mask
				m.createGradientBox(loadedObject.width, loadedObject.height,Math.PI/2,loadedObject.height);
				var mymask:Shape = new Shape();
				mymask.graphics.lineStyle(0,0,0);
				mymask.graphics.beginGradientFill("linear", [0x000000, 0x000000],[refIn1, refIn2], [refDen1, refDen2],m) ;
				mymask.graphics.lineTo(0, loadedObject.height);
				mymask.graphics.lineTo(loadedObject.width, loadedObject.height);
				mymask.graphics.lineTo(loadedObject.width, 0)
				mymask.graphics.lineTo(0, 0)
				mymask.graphics.endFill();
				
				// CacheaAsBitmap
				mymask.cacheAsBitmap = true;
				b2.cacheAsBitmap = true;
				
				// Create mask
				b2.mask = mymask;
				addChild(b2);
				addChild(mymask);
				
				var bmp3:BitmapData = new BitmapData(loadedObject.width, loadedObject.height, true, 0x000000);
				bmp3.draw(b2);
				// Create Reflection plane
				var bm2:BitmapMaterial = new BitmapMaterial(bmp3);
				bm2.precise = false;
				bm2.doubleSided = false;
				bm2.smooth = false;
				var p2:Plane = new Plane(bm2, 1, 0, 1, 1);
				
				p2.x = p.x;
				p2.z = p.z
				p2.y = -refCateDist + p.y;
				p.extra.reflection = p2;
				
				scene.addChild(p2,"reflection" + index);
				removeChild(b2);
				removeChild(mymask);
			}
						
			// Interactive Roll Over, Roll Out, Press/Release
			p.addEventListener( InteractiveScene3DEvent.OBJECT_RELEASE, onCategoryPlaneRelease, false, 0, true );
			p.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, onCategoryPlaneRollOver, false, 0, true );
			p.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, onCategoryPlaneRollOut, false, 0, true );
			currentPlane = p;
								
			// Finish loading, add interactive
			if (++count == TOTAL) 
			{
				// Remove preloader
				removeChild(preloader);
				// Add scrollbar interactive
				addScrollBarInteractive();
				// Add category button interactive
				addCategoryButtonInteractive();
				// Add category launch function
				categoryBoard.launch.addEventListener(MouseEvent.MOUSE_DOWN, launchCategory);
				categoryBoard.launch.addEventListener(MouseEvent.MOUSE_OVER, launchOver);
				categoryBoard.launch.addEventListener(MouseEvent.MOUSE_OUT, launchOut);
				setupStageMouseDown();
				categoryDemo();
			}	
		}
		
		//_____________________________________________ LAUNCH CATEGORY
		
		private function launchCategory(e:Event):void
		{
			// reset parameters
			categoryMode = false;
			galleryMode = true;
			j0 = i0 = deltaX = deltaY = count = 0;
			rollOver = false;
			rollOverBar = false;
			rollOverLeft = false;
			rollOverRight = false;
			Tweener.removeAllTweens();
			// Load asset
			// Fade out category plane, category board
			Tweener.addTween([categoryBoard, chooseCategory],
								{	alpha:0,
									time:1,
									onComplete:function():void
									{
										categoryBoard.visible = false;
										chooseCategory.visible = false;	
									}
								});
			Tweener.addTween(viewport,
								{	alpha:0,
									time:1,
									onComplete:function():void
									{
										viewport.visible = false;
										// Hide all category plane	
										for (var i:uint = 0; i < TOTAL; i++)
										{
											scene.getChildByName("categoryPlane" + i).z = 0;
											scene.getChildByName("categoryPlane" + i).visible = false;
											scene.getChildByName("categoryPlane" + i).extra.reflection.visible = false;
											scene.getChildByName("categoryPlane" + i).extra.reflection.z = 0;
										}
										if (!category[currentCategory].loaded)
											xmlLoad(category[currentCategory].xmlPath);
										else
										{
											// init parameters
											deltaX = XDist * category[currentCategory].columns / 2;
											deltaY = YDist * category[currentCategory].rows / 2;
											range = XDist * (category[currentCategory].columns - 1);
											camera.z = -300;
											camera.y = 0;
											camera.x = -category[currentCategory].columns * XDist + deltaX;
											camera.rotationY = 40;
											// Show asset
											scrollBar.visible = CIcon.visible = true;
											Tweener.addTween([scrollBar, CIcon],
																{	alpha:1,
																	time:1
																});		
											// show viewport
											viewport.visible = true;
											// show description 
											addChild(descriptionClip);
											descriptionClip.visible = true;
											descriptionClip.content.htmlText = "<note>" + category[currentCategory].title + "</note>";
											// Show all current photo
											for (var j:uint = 0; j < category[currentCategory].TOTAL; j++)
											{
												scene.getChildByName("category" + currentCategory + "_plane" + j).visible = true;
												if (scene.getChildByName("category" + currentCategory + "_reflection" + j) != null)
													scene.getChildByName("category" + currentCategory + "_reflection" + j).visible = true;
											}
											Tweener.addTween(viewport,{	alpha:1, time:1	});
										}
									}
								});
		}
		
		private function launchOver(e:Event):void
		{
			categoryBoardRollOver = true;
			e.target.gotoAndPlay(2);
		}
		
		private function launchOut(e:Event):void
		{
			categoryBoardRollOver = false;
			e.target.gotoAndPlay(21);
		}
		
		//_____________________________________________ CATEGORY PLANE INTERACTIVE
		
		private function onCategoryPlaneRelease(e:InteractiveScene3DEvent):void
		{
			var p:Plane = e.target as Plane;
			currentPlane = p;
			categorySelected = true;
			var index:Number = p.extra.index;
			currentCategory = index;
			// Display new category information
			categoryBoard.title.text = category[index].title;
			categoryBoard.desc.text =  category[index].description;
			categoryBoard.alpha = 0;
			categoryBoard.visible = true;
			Tweener.addTween(categoryBoard,	{	alpha:1, time:2});
			// Bring selected plant to front
			Tweener.addTween([currentPlane, currentPlane.extra.reflection],
								{	z:0, 
									time:1 
								});
			// Bring Back other category plane
			for (var i:uint = 0; i < TOTAL; i++)
				if (i != p.extra.index)
				{
					var p1:Plane = scene.getChildByName("categoryPlane" + i) as Plane;
					Tweener.addTween([p1, p1.extra.reflection],
										{	z:600,
											time:1,
											onUpdate:function():void
											{
												renderer.renderScene(scene, camera, viewport);		
											}
										});	
				}
			// rotate camera to form perspective
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			Tweener.addTween(camera,{	rotationX: 0,
										rotationY: categoryAngle,
										x:p.x,
										z:-500,
										y:0,
										time:2,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);											
										}
									});
		}
		
		private function onCategoryPlaneRollOver(e:InteractiveScene3DEvent):void
		{
			categoryRollOver = true;
		}
		
		private function onCategoryPlaneRollOut(e:InteractiveScene3DEvent):void
		{
			categoryRollOver = false;
		}
		
		//________________________________________________ DEMO EFFECT
		
		private function categoryDemo():void
		{
			// Add text
			addChild(chooseCategory);
			chooseCategory.gotoAndPlay(2);
			// Category board
			addChild(categoryBoard);
			categoryBoard.x = stage.stageWidth / 2;
			categoryBoard.y = stage.stageHeight / 2;
			categoryBoard.visible = false;
			cameraCenter =  (TOTAL - 1) * categoryDistance / 2;
			var action:Object = {		rotationY:40,
										x:(TOTAL - 1) * categoryDistance,
										time:2,
										transition:"easeInQuint",
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);											
										},
										onComplete:function():void
										{
											
											Tweener.addTween(camera,{	x:cameraCenter,
																		rotationY:0,
																		time:3,
																		onUpdate:function():void
																		{
																			// Render 3D
																			renderer.renderScene(scene, camera, viewport);											
																		},
																		onComplete:function():void
																		{
																			setUpMouseMove();
																		}
																	}); 
										}
							}	
			Tweener.addTween(camera, action);
		}
		
		
		
		//_________________________________________________ SET UP MOUSE MOVE/WHEEL HANDLER
		
		private function setUpMouseMove():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(e:Event):void
		{
			var deltaY:Number = (stage.mouseX - stage.stageWidth * .5) / CAMDELTA;
			var deltaX:Number = -(stage.mouseY - stage.stageHeight * .5) / CAMDELTA;
			Tweener.addTween(camera,{	rotationX: deltaX,
										rotationY: deltaY,
										time:1,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);											
										}
									});
		}
		
		private function setupMouseWheel():void
		{
			
			
		}
		
		
		// Mouse click on stage
		private function setupStageMouseDown():void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stagePress);
		}
		
		private function stagePress(e:Event):void
		{
			if (categoryMode)
			{
				// Bring camera to original position
				if (!categoryRollOver && !categoryBoardRollOver)
				{
					Tweener.removeAllTweens();
					Tweener.addTween(camera,{	x:cameraCenter,
												z:-600,
												rotationY:0,
												time:2,
												onUpdate:function():void
												{
													// Render 3D
													renderer.renderScene(scene, camera, viewport);
												}
											});
					if (categorySelected)
					{
						for (var i:uint = 0; i < TOTAL; i++)
						{
							var p:Plane = scene.getChildByName("categoryPlane" + i) as Plane;
							Tweener.addTween([p, p.extra.reflection],
									{	z:0, 
										time:2,
										onUpdate:function():void
												{
													// Render 3D
													renderer.renderScene(scene, camera, viewport);
												}
									});
						}
						setUpMouseMove();
						// Hide category board
						Tweener.addTween(categoryBoard,	
										{	alpha:0, 
											time:1,
											onUpdate:function():void
											{
												categoryBoard.visible = false;
											}		
											});
					}
				}
			}
			else
			if (galleryMode)
			{
				if (!rollOver && !rollOverBar && !rollOverLeft && !rollOverRight)
				{
				Tweener.addTween(camera,	{	z:cameraZDefault,
												delay:0.1,
												time:2,
												transition:"easeOutQuint",
												onUpdate:function():void
												{
													// Render 3D
													renderer.renderScene(scene, camera, viewport);
												}
											}
									);
							
				lPlane = cPlane;
				// Tween last plane back to original position
				Tweener.addTween(lPlane, 
									{ 	z: 0,
										time: planeTweenTime,
										transition: planeTweenEasing,
										// move reflection 
										onUpdate: moveReflection,
										onUpdateParams: [lPlane]
									}
								);	
				}
			}
		}
		
		//_________________________________________________ SCROLL BAR INTERACTIVE
		
		private function addScrollBarInteractive():void
		{
			scrollBar.scroller.scrubber.buttonMode = true;
			scrollBar.scroller.bar.buttonMode = true;
			scrollBar.scroller.left.buttonMode = true;
			scrollBar.scroller.right.buttonMode = true;
			scrollBar.scroller.scrubber.addEventListener(MouseEvent.MOUSE_DOWN, scrubberPress);
			scrollBar.scroller.bar.addEventListener(MouseEvent.MOUSE_DOWN, barPress);
			scrollBar.scroller.bar.addEventListener(MouseEvent.MOUSE_OVER, barRollOver);
			scrollBar.scroller.bar.addEventListener(MouseEvent.MOUSE_OUT, barRollOut);
			scrollBar.scroller.left.addEventListener(MouseEvent.MOUSE_DOWN, leftPress);
			scrollBar.scroller.left.addEventListener(MouseEvent.MOUSE_OVER, leftRollOver);
			scrollBar.scroller.left.addEventListener(MouseEvent.MOUSE_OUT, leftRollOut);
			scrollBar.scroller.right.addEventListener(MouseEvent.MOUSE_DOWN, rightPress);
			scrollBar.scroller.right.addEventListener(MouseEvent.MOUSE_OVER, rightRollOver);
			scrollBar.scroller.right.addEventListener(MouseEvent.MOUSE_OUT, rightRollOut);
		}
				
		// press scrubber
		private function scrubberPress(e:MouseEvent):void
		{
			// check if release
			stage.addEventListener(MouseEvent.MOUSE_UP, scrubberRelease);
			// retrieve scrubber
			var scrub = scrollBar.scroller.scrubber;
			scrub.startDrag(false, new Rectangle(sl1, scrub.y, sl2, scrub.y) );
			//turn camera to corresonding position
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubberMove);
		}
		
		// release scrubber
		private function scrubberRelease(e:MouseEvent):void
		{
			var scrub = scrollBar.scroller.scrubber;
			scrub.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubberMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrubberRelease);
		}
		
		// move scrubber, move camera
		private function scrubberMove(e:MouseEvent):void
		{
			var scrub = scrollBar.scroller.scrubber;
			//calculate camera's position based on scrubber's position
			newCameraPos = (scrub.x - sl1) / sl2 * range - deltaX;
			// new Camera position
			Tweener.addTween(camera, {	x: newCameraPos,
										time: cameraTweenTime,
										transition: cameraTweenEasing,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);	
										}
									}
								);
										
			// remove camera's movement by pressing on thumbnail
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			
			// Update orientation of camera
			this.addEventListener(Event.ENTER_FRAME, updateOrientation2, false, 0, true);
		}
		
		// press bar
		private function barPress(e:MouseEvent):void
		{
			var scrub = scrollBar.scroller.scrubber;
			var targetPos:Number = (scrollBar.scroller.mouseX > sl2 + sl1 ) ? (sl2 + sl1) : scrollBar.scroller.mouseX; 
			Tweener.addTween(scrub,	{	x:targetPos,
											time:scrubberTweenTime
										}
									);
									
			//calculate camera's position based on scrubber's position
			newCameraPos = (targetPos - sl1) / sl2 * range - deltaX;
					
			// new Camera position
			Tweener.addTween(camera, {	x: newCameraPos,
										time: cameraTweenTime,
										transition: cameraTweenEasing,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);	
										}
									}
								);
										
			// remove camera's movement by pressing on thumbnail
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			
			// Update orientation of camera
			this.addEventListener(Event.ENTER_FRAME, updateOrientation2, false, 0, true);						
		}	
		
		// roll over bar
		private function barRollOver(e:MouseEvent):void
		{
			rollOverBar = true;
		}
		
		// roll out bar
		private function barRollOut(e:MouseEvent):void
		{
			rollOverBar = false;
		}
		
		// press left button
		private function leftPress(e:MouseEvent):void
		{
			var scrub = scrollBar.scroller.scrubber;
			var targetPos:Number = (scrub.x - scrubberStep > sl1 ) ? (scrub.x - scrubberStep) : sl1; 
			Tweener.addTween(scrub,	{	x:targetPos,
										time:scrubberTweenTime
									}
									);
									
			//calculate camera's position based on scrubber's position
			newCameraPos = (targetPos - sl1) / sl2 * range - deltaX;
					
			// new Camera position
			Tweener.addTween(camera, {	x: newCameraPos,
										time: cameraTweenTime,
										transition: cameraTweenEasing,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);	
										}
									}
								);
										
			// remove camera's movement by pressing on thumbnail
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			
			// Update orientation of camera
			this.addEventListener(Event.ENTER_FRAME, updateOrientation2, false, 0, true);						
		}	
		
		// roll over left button
		private function leftRollOver(e:MouseEvent):void
		{
			rollOverLeft = true;
		}
		
		// roll out left button
		private function leftRollOut(e:MouseEvent):void
		{
			rollOverLeft = false;
		}
		
		// press left button
		private function rightPress(e:MouseEvent):void
		{
			var scrub = scrollBar.scroller.scrubber;
			var targetPos:Number = (scrub.x + scrubberStep <= sl2 + sl1) ? (scrub.x + scrubberStep) : (sl2 + sl1); 
			Tweener.addTween(scrub,	{	x:targetPos,
											time:scrubberTweenTime
										}
									);
									
			//calculate camera's position based on scrubber's position
			newCameraPos = (targetPos - sl1) / sl2 * range - deltaX;
					
			// new Camera position
			Tweener.addTween(camera, {	x: newCameraPos,
										time: cameraTweenTime,
										transition: cameraTweenEasing,
										onUpdate:function():void
										{
											// Render 3D
											renderer.renderScene(scene, camera, viewport);	
										}
									}
								);
										
			// remove camera's movement by pressing on thumbnail
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			
			// Update orientation of camera
			this.addEventListener(Event.ENTER_FRAME, updateOrientation2, false, 0, true);						
		}	
		
		// roll over left button
		private function rightRollOver(e:MouseEvent):void
		{
			rollOverRight = true;
		}
		
		// roll out left button
		private function rightRollOut(e:MouseEvent):void
		{
			rollOverRight = false;
		}
		
				
		private function render3D(e:Event):void
		{	
			renderer.renderScene(scene, camera, viewport);
		}
		
		
		//__________________________________________ CATEGORY BUTTON 
		
		private function addCategoryButtonInteractive():void
		{
			CIcon.addEventListener(MouseEvent.MOUSE_DOWN, CIconPress);
		}
		
		private function CIconPress(e:Event):void
		{
			viewport.interactive = false;
			// remove camera orientation update
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation);
			this.removeEventListener(Event.ENTER_FRAME, updateOrientation2);
			Tweener.removeAllTweens();
			Tweener.addTween(descriptionClip,{	y:-descriptionClip.height, 
												time:1, 
												onComplete:function():void
												{
													descriptionClip.visible = false
												}
											});
			Tweener.addTween([scrollBar, CIcon],
								{	alpha:0,
									time:1,
									onComplete:function():void
									{
										scrollBar.visible = false;
										CIcon.visible = false;
									}
								});
			Tweener.addTween(viewport,
								{	alpha:0,
									time:1,
									onComplete:function():void
									{
										// Hide all current photo
										for (var i:uint = 0; i < category[currentCategory].TOTAL; i++)
										{
											scene.getChildByName("category" + currentCategory + "_plane" + i).visible = false;
											if (scene.getChildByName("category" + currentCategory + "_reflection" + i) != null)
												scene.getChildByName("category" + currentCategory + "_reflection" + i).visible = false;
										}
										
										// show category plane	
										for (var j:uint = 0; j < TOTAL; j++)
										{
											scene.getChildByName("categoryPlane" + j).visible = true;
											scene.getChildByName("categoryPlane" + j).extra.reflection.visible = true;
										}
										
										camera.x = cameraCenter;
										camera.y = 0;
										camera.rotationY = 0;
										camera.z = cameraZDefault;
										viewport.interactive = true;
										Tweener.addTween([viewport, categoryBoard, chooseCategory],
																	{	alpha:1,
																		time:1
																	});
										setUpMouseMove();
										categoryMode = true;
										galleryMode = false;
										
									}
								});					
		}
		
		//__________________________________________ APPLY STYLE SHEET
			
		private function initStyleSheet():void
		{
			// load external css
			var req:URLRequest = new URLRequest(css_path);
			var loader:URLLoader = new URLLoader();
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, cssLoaded);
			// Adding text link event
			addEventListener(TextEvent.LINK, clickText);
		}
		
			
		private function cssLoaded(e:Event):void
		{
			css.parseCSS(e.target.data);
			descriptionClip.content.styleSheet = css;
		}
		
		private function clickText(li:TextEvent):void
		{
			var myURL:URLRequest = new URLRequest(li.text);
			navigateToURL(myURL,"_blank");
		}
		
		//__________________________________________ REPOSITION
		
		private function rePosition(e:Event):void
		{
			// Scroll Bar
			scrollBar.x = (stage.stageWidth - scrollBar.width) * .5 ;
			scrollBar.y = stage.stageHeight - scrollBar.height;
			// Description Clip
			descriptionClip.content.width = stage.stageWidth - 5;
			descriptionClip.back.width = stage.stageWidth;
			// Category button
			CIcon.x = stage.stageWidth / 2;
			CIcon.y = stage.stageHeight - 62;
			// Preloader
			preloader.x = stage.stageWidth / 2;
			preloader.y = stage.stageHeight / 2;
		}
				
	}
}
