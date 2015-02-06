import flash.display.BitmapData;
class News {
	
	public var news:Array=new Array(); //the array that will hold XML file data
	public var inter3:Number; //interval used for autoPlay
	public var newsPause:Number=-1; //pause between news when autoplaied
	public var currentIndex:Number=0; //current index for autoplay
	public var free_content:MovieClip; //this is the movie clip that is hidden
	public var used_content:MovieClip; //this is the movie clip that is currently shown
	
	private var nextBtn:MovieClip; //the button that is next to be brought down
	private var inter1:Number; //interval used for setInterval action
	private var inter2:Number; //interval used to check if a picture is loaded
	private var left:Boolean=true; //should the buttons shift left or right
	private var target:String; //target read from XML file, where to load links _parent/_self.. etc.
	
	
	static var instance:News; //this class
	
	function News(){
		instance=this; //i am me :)
		trace("- news started.");
		init(); //begin initializations
	}
	
	function init(){
		//begin laoding XML file
		XMLRead("news.xml?nocache=" + random(1515));
		//XMLRead("news.xml");
		//assign event handlers
		_root.buttons.arrow_LB.onPress=instance.arrow_LBonPress;
		_root.buttons.arrow_LR.onPress=instance.arrow_LRonPress;
		_root.buttons.arrow_RR.onPress=instance.arrow_RRonPress;
		_root.buttons.arrow_RB.onPress=instance.arrow_RBonPress;
		_root.arrow_left.onPress=instance.arrow_leftonPress;
		_root.arrow_right.onPress=instance.arrow_rightonPress;
		//display current date 
		showCurrentDate();
		//disable items that are not needed now
		_root.buttons.arrow_RR.enabled=_root.buttons.arrow_LB.enabled=false;
		_root.buttons._visible=false;
		//set the names of the MovieClips that will hold news data on the stage
		instance.free_content=_root.content2; //this is the movie clip that is hidden
		instance.used_content=_root.content1; //this is the movie clip that is currently shown
	}
	
	//display a JS alert in browser window
	public static function JSAlert(str:String) {
		var alert:String = "javascript:alert('"+str+"');";
		getURL(alert);
	}
	
	//read XML file
	function XMLRead(fileName) {
		var xml:XML= new XML;
		xml.ignoreWhite=true;
		xml.onLoad = function (success:Boolean) {
			_root.news_text._x=570;
			if (success) {
				trace("-XML file: "+fileName+" successfully loaded.");
				instance.target=xml.firstChild.firstChild.firstChild.toString (); 
				if (xml.firstChild.firstChild.nextSibling.firstChild.toString ()=="on") {
					instance.newsPause=(xml.firstChild.firstChild.nextSibling.attributes["newspause"].toString ())
				}
				var itemsNode:XMLNode=xml.firstChild.firstChild.nextSibling.nextSibling.firstChild;//xml.firstChild.nextSibling.nextSibling.firstChild.firstChild;				
				var mainNode:XMLNode;
				//this will parse "items" node of the XML file
				while (itemsNode!=null) {
					mainNode=itemsNode.firstChild;
					var news_object:Object = new Object(); //creates an object
					//this will parse "item" node of the XML file
					while (mainNode!=null) {
						mainNode.nodeName.toLowerCase()=="title"?news_object.title=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="date"?news_object.date=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="picture"?news_object.picture=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="time"?news_object.time=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="description"?news_object.description=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="piclink"?news_object.piclink=mainNode.firstChild.toString():false;
						mainNode.nodeName.toLowerCase()=="titlelink"?news_object.titlelink=mainNode.firstChild.toString():false;
						mainNode=mainNode.nextSibling;
					}
					instance.news.push(news_object); //push the object into news array
					itemsNode=itemsNode.nextSibling;
				}
				/*     --------------- DEBUG --------------
						for (var i=0; i<instance.news.length; i++) {
						for (var name in instance.news[i]) {							
							trace("-->" +name+" = "+instance.news[i][name]);
						}
					}
				       ------------------------------------ */
//				       JSAlert("TOTAL ITEMS: "+instance.news.length);
				_root.buttons._visible=true;
				instance.initButtons(instance.news.length);
				//load first item
				instance.loadAllPictures();
				instance.addContent(_root.content1,0,null);
				if (instance.newsPause!=-1) {
					trace("- autplay enabled");
					instance.inter3 = setInterval(instance.autoPlay,instance.newsPause*1000);					
				}
			} else {
				trace("Unable to load XML file: "+fileName);
				JSAlert("Unable to load XML file: "+fileName);
				_root.buttons._visible=false;
			}
		}
		//load xml file
		xml.load(fileName);
	}
	
	function autoPlay() {
		//are all the pictures loaded?
		for (var i=0; i<=instance.news.length-1; i++) {
			if (_root.container["picture"+i]!=undefined) {
				trace("- exit because pictures are not loaded");
				return;
			}
		}
		var x=_root.buttons;
		//if buttons are disabled we can not play
		var cont=false;
		for (var i=1; i<=5; i++) {
			if (x["b"+i].enabled==true) {cont=true;}
		}
		if (!cont) {
			return;
		}
		if (instance.currentIndex==instance.news.length-1) {		
			instance.currentIndex=0;
			instance.addContent(instance.free_content,0,instance.arrow_LBonPress);
			return;
		}
		instance.left=true;
		instance.addContent(instance.free_content,instance.currentIndex,instance.arrow_leftonPress);
		
	}
	
	//shows the current date in the upper right corner
	function showCurrentDate() {
		//this will display current date in the upper-right corner of the screen
		var dayOfWeek_array:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		var monthNames_array:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		var today_date:Date = new Date();
		var day_str:String = dayOfWeek_array[today_date.getDay()];
		_root.current_date.text=dayOfWeek_array[today_date.getDay()]+", "+today_date.getDate()+" "+monthNames_array[today_date.getMonth()]+" "+today_date.getFullYear();
	}
	
	//draws a border around the picture
	function drawBorder(m:MovieClip, h:Number, w:Number, iX:Number, iY:Number) {
		//the border will be drawn in a separate movieClip that will stay over the picture
		//it will be removed and re-constructed for every picture
		//m=m._parent._parent;
		m.borders.removeMovieClip();
		m.createEmptyMovieClip("borders",m.getNextHighestDepth());
		//m.createEmptyMovieClip("borders",m.getNextHighestDepth());
		m.borders._y=5;
		m.borders.clear();
		m.borders.lineStyle(2,0xD6E6EC,100);
		m.borders.moveTo(iX, iY);
		m.borders.lineTo(h, iY);
		m.borders.lineTo(h, w);
		m.borders.lineTo(iX, w);
		m.borders.lineTo(iX, iY);
	}
	
	//initialize buttons
	function initButtons(no:Number) {
		var x=_root.buttons;
		if (instance.news.length==0) {
			x._visible=false;
			trace("-unable to build news array or 0 length XML file.");
			return;
		}
		
		function displayButtons(btnNo:Number) {
			for (var i=1; i<=btnNo; i++) {
				i<=3?x["b"+i].txt.text=i:0;
				x["b"+i]._x=x["a"+(i+2)]._x; x["b"+i]._y=x["a"+(i+2)]._y; x["b"+i]["pos"]=(i+2);
				if (x["a"+(i+2)]==undefined) {
					if (instance.nextBtn==undefined) {instance.nextBtn=x["b"+i];}
					x["b"+i]._x=x["a"+(i-2)+(i-2)]._x;
					x["b"+i]["pos"]=-1;
				}
				x["b"+i]._visible=true;
			}
			x.b1.gotoAndStop(3);
		}		
		displayButtons(no);
		//disbale the arrows if there is only one item
		no==1?appearance(false):0;
	}
	
	//enable or disable the buttons on the stage
	function appearance(enabled:Boolean) {
		_root.arrow_left.enabled=_root.arrow_right.enabled=_root.buttons.arrow_LR.enabled=_root.buttons.arrow_LB.enabled=_root.buttons.arrow_RR.enabled=_root.buttons.arrow_RB.enabled=enabled;
		for (var i=1; i<=5; i++) {
			_root.buttons["b"+i].enabled=enabled;
		}
	}
	
	//reset all buttons headers to the first frame
	function resetButtons() {
		for (var j=1; j<=5; j++) {
			_root.buttons["b"+j].gotoAndStop(1);
		}
	}
	
	//this will shift buttons to the left or to the right. trigger is the function that will be called
	//after the actions completed. parameters - the parameters that will be passed to this function
	function shiftButtons(left:Boolean, trigger:Function, parameters:Object) {
		//disable all buttons
		appearance(false);
		//reset buttons appearance
		resetButtons();
		//find the left most button and the right most button that is not masked
		var x=_root.buttons;
		var leftMost=-1;
		var rightMost=-1;
		var test:Boolean=false;
		for (var i=1; i<=5; i++) {
			if (x["b"+i]._y<x.a1._y) continue;
			if (!test) {
				leftMost=i; rightMost=i; test=true;
			} else {
				if (x["b"+i]._x<x["b"+leftMost]._x) {leftMost=i;}
				if (x["b"+i]._x>x["b"+rightMost]._x) {rightMost=i;}
			}
		}
		//bring down new button
			var bringDown:Function = function (tt:String) { //------------------------------- BRING DOWN ----------------------------
				clearInterval(instance.inter1);
				if (Number(x["b"+rightMost].txt.text)>=instance.news.length) {
					middleButton();
					trace("- nu mai trebuie coborate butoane..");
					return;
				}
				newLabel();
				instance.nextBtn._x=x.a22._x; instance.nextBtn._y=x.a22._y;
				if (ascended) {
					instance.nextBtn.tween("_y",x.a5._y,0.2,"linear",0,middleButton);
				} else {
					instance.nextBtn.tween("_y",x.a5._y,0.2,"linear",0,findNext);
				}
			}			
			
			//find next new button
			var findNext:Function = function () {           //------------------------------- FIND NEXT ----------------------------
				var found:Boolean=false;
				for (var i=1; i<=5; i++) {
					if (x["b"+i]._y<x.a1._y) {
						instance.nextBtn=x["b"+i];
						instance.nextBtn.txt.text="0";
						found=true;
						break;
					}
				}
				!found?instance.nextBtn=undefined:0;
				middleButton();
			}
			//assign new label
			var newLabel:Function = function () {           //------------------------------- NEW LABEL ----------------------------
				instance.nextBtn.txt.text=(Number(x["b"+rightMost].txt.text)+1);
				instance.nextBtn.pos=5;
			}
			//modify the state of the centered button
			var middleButton:Function = function () {       //------------------------------- MIDDLE BUTTON ----------------------------
				if (trigger!=undefined) {
					trigger.call(this, parameters.left,parameters.trigger,parameters.parameters);
					return;
				}
				var arr:Array=new Array();
				for (var j=1; j<=5; j++) {
					if (x["b"+j]._y>x.a11._y && x["b"+j].pos==3) {
						x["b"+j].gotoAndStop(3);
						instance.currentIndex=(x["b"+j].txt.text)-1;
					} else {
						x["b"+j].gotoAndStop(1);
					}
					if (x["b"+j]._y>x.a11._y) {
						arr.push(x["b"+j].pos);
					}
				}
				
				//enable all buttons because animation ended
				instance.appearance(true);
				//check if there are some buttons that should be disabled
				var arr2:Array = new Array(3,4,5);
				var arr3:Array = new Array(1,2,3);
				for (var i=0; i<arr.length; i++) {
					for (var j=0; j<arr2.length; j++) {
						if (arr[i]==arr2[j]) {
							arr2.splice (j,1);
						}
						if (arr[i]==arr3[j]) {
							arr3.splice (j,1);
						} 
					}
				}
				x.arrow_RB.enabled=x.arrow_LB.enabled=true;
				if (arr.length==3) {
					if (arr2.length==0) {x.arrow_RR.enabled=x.arrow_LB.enabled=false;}
					if (arr3.length==0) {x.arrow_LR.enabled=x.arrow_RB.enabled=false;}
				}
				if (arr.length==2) {
					if (arr2.length==1) {x.arrow_RR.enabled=x.arrow_LB.enabled=false;}
					if (arr3.length==1) {x.arrow_LR.enabled=x.arrow_RB.enabled=false;}
				}
				//call the function given as a parameter
				trigger.call(this, parameters.left,parameters.trigger,parameters.parameters);
			}
		
		
		if (left) {					
			//scroll left 1 position 						//------------------------------- MOVE LEFT ----------------------------
			var ascended:Boolean=false;
			for (var i=1; i<=5; i++) { //move buttons to the left
				if (x["b"+i]._y<x.a1._y) {continue;} //not interesed in masked buttons
				if (x["b"+i].pos==1) {//bring first button up if necessary
					ascended=true;
					instance.nextBtn=x["b"+i]; //the button that ascended is the next button to descend
					x["b"+i].tween("_y",x.a11._y,0.2,"linear",0,function(){bringDown("asked to descend");}); //move up and then call bringDown function to descend
					continue; //continue with next iteration
				}
				x["b"+i].tween("_x",x["a"+(x["b"+i].pos-1)]._x,0.4,"linear");
				x["b"+i].pos-=1;
			}
			//if a new button was not descended due to a call  made by the button that went up, the descend function must be called when last button finished tweening to the left side
			!ascended?instance.inter1 = setInterval(bringDown,500,"automatic"):0;
		} else {
			//                       						//------------------------------- MOVE RIGHT ----------------------------
			
			
			
			//bring down new button
			var bringDown2:Function = function (tt:String) { //------------------------------- BRING DOWN2 ----------------------------
				clearInterval(instance.inter1);
				if (label1) {
					middleButton();
					return;
				}
				newLabel2();
				instance.nextBtn._x=x.a11._x; instance.nextBtn._y=x.a11._y;
				if (ascended) {
					instance.nextBtn.tween("_y",x.a1._y,0.2,"linear",0,middleButton);
				} else {
					instance.nextBtn.tween("_y",x.a1._y,0.2,"linear",0,findNext);
				}
			}
			//assign new label
			var newLabel2:Function = function () {           //------------------------------- NEW LABEL2 ----------------------------
				instance.nextBtn.txt.text=(Number(x["b"+leftMost].txt.text)-1);
				instance.nextBtn.pos=1;
			}
			
			
									
			
			//check if the button with label 1 is visible. knowing this, we won't bringDown another button when scrolling right
			var label1:Boolean=false;
			for (var j=1; j<=5; j++) {
				if (x["b"+j]._y>x.a11._y && x["b"+j].txt.text=="1") {
					label1=true;
					break;
				}
			}
			
			//scroll right 1 position
			var ascended:Boolean=false;
			for (var i=1; i<=5; i++) { //move buttons to the RIGHT
				if (x["b"+i]._y<x.a1._y) {continue;} //not interesed in masked buttons
				if (x["b"+i].pos==5) {//bring last button up if necessary
					ascended=true;
					instance.nextBtn=x["b"+i]; //the button that ascended is the next button to descend
					x["b"+i].tween("_y",x.a55._y,0.2,"linear",0,function(){bringDown2("asked to descend");}); //move up and then call bringDown function to descend
					continue; //continue with next iteration
				}
				x["b"+i].tween("_x",x["a"+(x["b"+i].pos+1)]._x,0.4,"linear");
				x["b"+i].pos+=1;
			}
			//if a new button was not descended due to a call  made by the button that went up, the descend function must be called when last button finished tweening to the left side
			!ascended?instance.inter1 = setInterval(bringDown2,500,"automatic"):0;
		}
			
	}
	
	function shiftWithBlur(left:Boolean) {
		_root.mask._visible=false;
		instance.left?instance.free_content._y=_root.aR._y:instance.free_content._y=_root.aL._y;
		instance.used_content.filters = _root.blurfilterArray;
		instance.free_content.filters = _root.blurfilterArray;
		//tween
		instance.left?instance.used_content.tween("_y",_root.aL._y,0.3,"linear"):instance.used_content.tween("_y",_root.aR._y,0.3,"linear");
		instance.free_content.tween("_y",_root.aC._y,0.3,"linear",0,function(){instance.used_content.filters=[];instance.free_content.filters=[];_root.mask._visible=true;});
		//reintialize
		var x=instance.used_content;
		instance.used_content=instance.free_content;
		instance.free_content=x;
	}	
	
	function loadAllPictures() {
		_root.createEmptyMovieClip ("container",0); _root.container._y=300;
		var loadListener:Object = new Object();
		loadListener.onLoadInit = function(target_mc:MovieClip) {
			_root.preloader._visible=false;
			trace("Finished loading: "+target_mc+" x="+target_mc._x);
			
			//copy the picture from the loaded clip to another one so we can use it later ( duplicatemovieclip
			//extas from help:If you used MovieClip.loadMovie() or the MovieClipLoader class to load a movie clip, the contents of the SWF file are not duplicated. This means that you cannot save bandwidth by loading a JPEG, GIF, PNG, or SWF file and then duplicating the movie clip. 
			//Contrast this method with the global function version of duplicateMovieClip(). The global version of this method requires a parameter 
			var bitmapPic = new BitmapData(target_mc._width, target_mc._height);
			bitmapPic.draw(target_mc); 
			
			//mc wich will hold the copied movieclip
			var newMC=_root.container.createEmptyMovieClip(target_mc._name+"N", _root.container.getNextHighestDepth());			
    		newMC.attachBitmap(bitmapPic, _root.container.getNextHighestDepth());
    		newMC._x=target_mc._x;
    		newMC._y=target_mc._y;
    		
    		//remove old movieclip
    		target_mc.removeMovieClip();
		}
		var mcLoader:MovieClipLoader = new MovieClipLoader();
		mcLoader.addListener(loadListener);
		for (var i=0; i<instance.news.length; i++) {
			var mc:MovieClip=_root.container.createEmptyMovieClip("picture"+i,_root.container.getNextHighestDepth());
			mc._x+=i*199;
			mcLoader.loadClip(instance.news[i].picture+"?nocache=" + random(1515), mc);
			//mcLoader.loadClip(instance.news[i].picture, mc);
		}
	}
	
	function addContent(mainMovie:MovieClip, index:Number, trigger:Function) {	
		clearInterval(instance.inter2);
		//reinitialize the scroll bar for the new text content
		mainMovie.scroll_text.scroll_bar.setText(instance.news[index].description);
		mainMovie.scroll_text.scroll_bar.reconstruct();
		//set new title
		mainMovie.scroll_text.title.text=instance.news[index].title;		
		//dummy border
		instance.drawBorder(mainMovie.btn.pic,199,132,0,0);
		//set date
		mainMovie._visible=true;
		mainMovie.date.setWorkingSkin(2);
		mainMovie.date.showDate(instance.news[index].date);
		mainMovie.date.showClock(true,instance.news[index].time);
	
		//wait until the needed photo is loaded, then display it
		function waitUntilLoaded(thisObject, pic:MovieClip, index){
		if (pic.getBytesLoaded()==pic.getBytesTotal() || pic==undefined) {
			if (_root.container["picture"+index+"N"]==undefined) {
				return;
			}
			
			clearInterval(instance.inter2);
			_root.preloader._visible=false;
			//copy a picture "N"=normal from _root.container movieClip
			instance.used_content.picture.removeMovieClip();
			instance.used_content.inverted.removeMovieClip();
	
			var newMC = instance.used_content.createEmptyMovieClip ("picture", instance.used_content.date.getDepth()-2);
			var newMCI = instance.used_content.createEmptyMovieClip ("inverted", instance.used_content.date.getDepth()-3);
	
			//copy the normal movie clip
			var bitmapPic = new BitmapData(_root.container["picture"+index+"N"]._width, _root.container["picture"+index+"N"]._height);
			bitmapPic.draw(_root.container["picture"+index+"N"]); newMC._y+=5;
    		newMC.attachBitmap(bitmapPic, newMC.getNextHighestDepth());
   			
   			//copy the mirrored movie clip
			bitmapPic.draw(_root.container["inverted"+index+"N"]); newMCI._y+=5+newMC._height;
    		newMCI.attachBitmap(bitmapPic, newMCI.getNextHighestDepth());
    		newMCI._yscale=-100;
    		newMCI._y+=newMCI._height;
    		//prepare and set the mask
    		instance.used_content.mask._x=newMCI._x;
    		instance.used_content.mask._y=newMCI._y-newMCI._height;
    		instance.used_content.mask._width=newMCI._width;
    		instance.used_content.mask.cacheAsBitmap=true;
    		newMCI.cacheAsBitmap=true;
    		newMCI.setMask(instance.used_content.mask);
    		//draw border
    		instance.drawBorder(newMC,newMC._width,newMC._height-5,0,-5);
    		
    		//add event handler
    		if (instance.news[index].piclink!=undefined) {
    			newMC.onPress = function () {
    				getURL(instance.news[index].piclink,instance.target);
    			}
    		} else {
    			delete(newMC.onPress);
    		}
    		
    		 if (instance.news[index].titlelink!=undefined) {
    			instance.used_content.title_link.onPress = function() {
    				getURL(instance.news[index].titlelink,instance.target);
    			}
    		} else {
    			delete(instance.used_content.title_link.onPress);
    		}
		}
	}
		
		if (_root.container["picture"+index]!=undefined) {
			trigger.call();
			_root.preloader._visible=true;
			instance.inter2=setInterval(waitUntilLoaded,100,this,_root.container["picture"+index],index);
		} else {
			_root.preloader._visible=false;
			//copy a picture "N" +inverted "I" from _root.container movieClip
			instance.free_content.picture.removeMovieClip();
			instance.free_content.inverted.removeMovieClip();
		
		
			var newMC = instance.free_content.createEmptyMovieClip ("picture", instance.free_content.date.getDepth()-2);
			var newMCI = instance.free_content.createEmptyMovieClip ("inverted", instance.free_content.date.getDepth()-3);
			
			//copy the normal movie clip
			var	bitmapPic = new BitmapData(_root.container["picture"+index+"N"]._width, _root.container["picture"+index+"N"]._height);
			bitmapPic.draw(_root.container["picture"+index+"N"]); newMC._y+=5;
	    	newMC.attachBitmap(bitmapPic, newMC.getNextHighestDepth());
    		
	    	//copy the mirrored movie clip
			bitmapPic.draw(_root.container["inverted"+index+"N"]); newMCI._y+=5+newMC._height;
    		newMCI.attachBitmap(bitmapPic, newMCI.getNextHighestDepth());
	    	newMCI._yscale=-100;
	    	newMCI._y+=newMCI._height;
    		//prepare and set the mask
    		instance.free_content.mask._x=newMCI._x;
    		instance.free_content.mask._y=newMCI._y-newMCI._height;
    		instance.free_content.mask._width=newMCI._width;
	    	instance.free_content.mask.cacheAsBitmap=true;
    		newMCI.cacheAsBitmap=true;
    		newMCI.setMask(instance.free_content.mask);
    		//add border
    		instance.drawBorder(newMC,newMC._width,newMC._height-5,0,-5);
    		
  			//add event handler
    		if (instance.news[index].piclink!=undefined) {
    			newMC.onPress = function () {
    				getURL(instance.news[index].piclink,instance.target);
    			}
    		} else {
    			delete(newMC.onPress);
    		}
    		
    		if (instance.news[index].titlelink!=undefined) {
    			instance.free_content.title_link.onPress = function() {
    				getURL(instance.news[index].titlelink,instance.target);
    			}
    		} else {
    			delete(instance.free_content.title_link.onPress);
    		}
    		
    		//call the function given as a parameter
			trigger.call();
		}
	}
	
	//------------------- BUTTON HANDLERS ---------------------
	
	function arrow_LBonPress() {//for arrow LB=left & from begining
		
		this["enabled"]=false;
		_root.buttons.arrow_RB.enabled=true;
		var x=_root.buttons;		
		instance.resetButtons();
		//all buttons masked
		for (var i=1; i<=5; i++) {
			x["b"+i]._x=x["a"+i+i]._x;
			x["b"+i]._y=x["a"+i+i]._y;
		}
		//bring first 3 buttnos on start position
		for (var i=0; i<=3; i++) {
			if (i>=instance.news.length) {break;}
			x["b"+(i+1)]._x=x["a"+(i+3)]._x;
			x["b"+(i+1)]._y=x["a"+(i+3)]._y
			x["b"+(i+1)].pos=i+3;
			x["b"+(i+1)].txt.text=String(i+1);
			
		}
		x.b1.gotoAndStop(3);
		x.arrow_LR.enabled=_root.arrow_left.enabled=true;
		x.arrow_RR.enabled=false;
		instance.nextBtn=x["b"+(i+1)];
		instance.arrow_leftonPress(Number(x.b1.txt.text)-1,true);
	}
	
	function arrow_RBonPress() {//for arrow LB=left & from begining 
		instance.currentIndex=instance.news.length-1;
		if (instance.news.length<=3) {
			instance.arrow_LBonPress();
			return;
		}
		
		this["enabled"]=false;
		_root.buttons.arrow_LB.enabled=true;
		var x=_root.buttons;		
		instance.resetButtons();
		//all buttons masked
		for (var i=1; i<=5; i++) {
			x["b"+i]._x=x["a"+i+i]._x;
			x["b"+i]._y=x["a"+i+i]._y;
		}
		//bring last 3 buttons on end position
		for (var i=instance.news.length; i>instance.news.length-3; i--) {
			if (i<=0) {break;}
			x["b"+(Math.abs (instance.news.length-i)+1)]._x=x["a"+(Math.abs (instance.news.length-i)+1)]._x;
			x["b"+(Math.abs (instance.news.length-i)+1)]._y=x["a"+(Math.abs (instance.news.length-i)+1)]._y
			x["b"+(Math.abs (instance.news.length-i)+1)].pos=Math.abs (instance.news.length-i)+1;
			x["b"+(Math.abs (instance.news.length-i)+1)].txt.text=String(Math.abs (instance.news.length-i)+(instance.news.length-2));
			
		}
		x.b3.gotoAndStop(3);
		instance.nextBtn=x["b"+(Math.abs (instance.news.length-i)+1)];
		x.arrow_LR.enabled=false;
		x.arrow_RR.enabled=_root.arrow_right.enabled=true;
		instance.arrow_leftonPress(Number(x.b3.txt.text)-1,true);
	}
	
	function arrow_LRonPress() {//for arrow LR=left + rew
		instance.arrow_leftonPress();
	}
	
	function arrow_RRonPress() {//for arrow RR=right + rew
		instance.arrow_rightonPress();
	}
	
	function arrow_leftonPress(index:Number, skip:Boolean){//for lateral left arrow. if skip=true buttons won't be shifted
		//set current index for autoplay
		if (index==undefined) {
			//find the selected button
			for (var i=1; i<=5; i++) {
				if (_root.buttons["b"+i]._currentFrame==3) {
					index=Number(_root.buttons["b"+i].txt.text);
					break;
				}
			}
		}
		//last resort
		if (index==undefined) {
			trace("-- continue with index="+instance.currentIndex);
			index=instance.currentIndex;
		}
		if (index==instance.news.length) {
			instance.arrow_LBonPress();
			return;
		}
		!skip?instance.shiftButtons(true,undefined,null):0;
		//addContent to the lateral hided movieClip (prepare it to be shown)
		instance.left=true;
		instance.addContent(instance.free_content,index,instance.shiftWithBlur);
	}
	
	function arrow_rightonPress(index:Number, skip:Boolean){//for lateral left arrow. if skip=true buttons won't be shifted
		//set current index for autoplay
		
		if (index==undefined) {
			//find the selected button
			for (var i=1; i<=5; i++) {
				if (_root.buttons["b"+i]._currentFrame==3) {
					index=Number(_root.buttons["b"+i].txt.text)-2;
					break;
				}
			}
		}
		//last resort
		if (index==undefined) {
			trace("-- continue with index="+instance.currentIndex);
			index=instance.currentIndex;
		}
		if (index==-1) {
			instance.arrow_RBonPress();			
			return;
		}
		!skip?instance.shiftButtons(false,undefined,null):0;
		//addContent to the lateral hided movieClip (prepare it to be shown)
		instance.left=false;
		instance.addContent(instance.free_content,index,instance.shiftWithBlur);
	}
}