package {
    import flash.display.*;						//Import necessary classes, DO NOT REMOVE!
	import flash.events.*;						//	
	import flash.net.*;							//
	import flash.geom.Rectangle;				//
	import flash.geom.ColorTransform;			//
	import caurina.transitions.*;				//
	import flash.text.*;						//
	

 
    public class fileUpload extends MovieClip {
        public static var LIST_COMPLETE:String = "listComplete"; //Creation of Variables needed by Class
		public var fileRef:RefList = new RefList();			     //
		public var hold:MovieClip = new MovieClip();			 //
		public var masker:Sprite;								 //
		public var MainCol;										 //
		
		
		public function fileUpload() {
		   this.addChild(hold);													// Instantiates class
		   this.browse.addEventListener(MouseEvent.CLICK, initiateFileBrowse);	// adds Event Listeners
		   this.browse.buttonMode = true;										// to buttons.
		   this.browse.addEventListener(MouseEvent.ROLL_OVER, rollover);		//
		   this.browse.addEventListener(MouseEvent.ROLL_OUT, rollout);			//
		   this.up.buttonMode = true;											//
		   this.up.addEventListener(MouseEvent.ROLL_OVER, rollover);			//
		   this.up.addEventListener(MouseEvent.ROLL_OUT, rollout);				//
		   this.up.addEventListener(MouseEvent.CLICK, initiateFileUpload);		//
		   scroll.visible = false;												//
		   fileRef.loader.addEventListener(Event.COMPLETE, setColors);			//
		 

		}
		
		public function listCompleteHandler(event:Event):void {					// Creates list of files to
			if(this.getChildByName("mask")){									// be uploaded.
				this.removeChild(this.getChildByName("mask"));					//
				}																// Checks whether scrollbar
			masker = new Sprite();												// is visible.
			masker.name = "mask";
			masker.graphics.beginFill(0xFF0000);
			masker.graphics.drawRect(0,0,this.itemHolder.width,this.itemHolder.height - 3);
			masker.graphics.endFill();
			masker.x = this.itemHolder.x;
			masker.y = this.itemHolder.y + 3;
			addChild(masker);
			hold.x = this.itemHolder.x;
			hold.y = this.itemHolder.y + 3;
			hold.mask = masker;
			while(hold.numChildren > 0){
				hold.removeChildAt(0);
				}
			for(var i:uint = 0;i < fileRef.pendingFiles.length;i++){
				var item:uploadItem = new uploadItem();
				item.ID = i;
				item.name = fileRef.pendingFiles[i].name;
				item.name_tb.text = fileRef.pendingFiles[i].name;
				item.size_tb.text = "Size:" + (((fileRef.pendingFiles[i].size)/1024).toFixed(2)) + "Kb";
				item.type_tb.text = "Type:" + fileRef.pendingFiles[i].type;
				item.close.buttonMode = true;
				item.close.addEventListener(MouseEvent.ROLL_OVER, rollover);
				item.close.addEventListener(MouseEvent.ROLL_OUT, rollout);
				item.close.addEventListener(MouseEvent.CLICK, deleteitem);
				item.x = 1;
				item.y = i * (item.height + 1);
				hold.addChild(item);
				}
			checkScroll();
			}
		
		public function rollover(e:MouseEvent){ // RollOver Event for buttons
			Tweener.addTween(e.currentTarget.hover,{alpha:1,time:1,onComplete:function(){Tweener.removeTweens(this);}});
			}
			
		public function rollout(e:MouseEvent){ // RollOut Event for buttons
			Tweener.addTween(e.currentTarget.hover,{alpha:0,time:1,onComplete:function(){Tweener.removeTweens(this);}});
			}
			
		public function deleteitem(e:MouseEvent){ // Deletes Items from the item list and file array.
			fileRef.pendingFiles.splice(e.currentTarget.parent.ID,1);
			hold.removeChildAt(e.currentTarget.parent.ID);
			for(var i:uint = 0; i < hold.numChildren; i++){
			var It = hold.getChildAt(i);
			if(It.ID > e.currentTarget.parent.ID){
			It.ID--;
			Tweener.addTween(hold.getChildAt(i),{y:hold.getChildAt(i).y - hold.getChildAt(i).height - 1,time:0.6,delay:i * 0.03});
			}
			}
			checkScroll();
		}
			
		private function progressHandler(event:ProgressEvent):void { // Updates progress of file being uploaded
        	var file = FileReference(event.target);
			var item = hold.getChildAt(fileRef.pendingFiles.indexOf(file));
			item.type_tb.visible = false;
			item.Progress.visible = true;
			item.close.visible = false;
			item.size_tb.text = "Sending:" + ((event.bytesLoaded/1000).toFixed(2)) + "kb";
			item.Progress.Bar.scaleX = event.bytesLoaded/event.bytesTotal;
			
		}
			
			
		public function completeHandler(event:Event):void {						// Fires when file is uploaded
       		var file = FileReference(event.target);								// successfully.
			var item = hold.getChildAt(fileRef.pendingFiles.indexOf(file));		//
			item.size_tb.text = "Complete";										// Empties file list and file
			Tweener.addTween(item,{delay:1,onComplete:function(){				// Array
																fileRef.pendingFiles.splice(item.ID,1);
																hold.removeChildAt(item.ID)
																for(var i:uint = 0; i < hold.numChildren; i++){
																var It = hold.getChildAt(i);
																if(It.ID > item.ID){
																It.ID--;
																Tweener.addTween(It,{y:It.y - It.height - 1,time:0.6});
																Tweener.removeTweens(this);
																}
																}
																checkScroll();
																if(fileRef.pendingFiles.length < 1){
																	up.hover.alpha = 0;
																	up.alpha = 1;
																	browse.alpha = 1;
																	browse.addEventListener(MouseEvent.CLICK, initiateFileBrowse);
																	browse.buttonMode = true;
																	browse.addEventListener(MouseEvent.ROLL_OVER, rollover);
																	browse.addEventListener(MouseEvent.ROLL_OUT, rollout);
																	up.addEventListener(MouseEvent.CLICK, initiateFileUpload);
																	up.buttonMode = true;
																	up.addEventListener(MouseEvent.ROLL_OVER, rollover);
																	up.addEventListener(MouseEvent.ROLL_OUT, rollout);
																	}
																}});
			
			 
    		}
				
        public function initiateFileBrowse(e:MouseEvent):void { // Starts file browsing and gets valid file types
			warning.text = "";
            fileRef.addEventListener(fileUpload.LIST_COMPLETE, listCompleteHandler);
            fileRef.browse(fileRef.getTypes());
        }
		
		private function initiateFileUpload(e:MouseEvent):void { //Starts file upload
			if(fileRef.pendingFiles.length == 0){
			warning.text = "*A file must be selected";
			}else{
			up.alpha = 0.5;
			browse.alpha = 0.5;														
			this.up.removeEventListener(MouseEvent.CLICK, initiateFileUpload);		//
		   	this.up.buttonMode = false;												//
		   	this.up.removeEventListener(MouseEvent.ROLL_OVER, rollover);			//
		   	this.up.removeEventListener(MouseEvent.ROLL_OUT, rollout);				//
			this.browse.removeEventListener(MouseEvent.CLICK, initiateFileBrowse);	// Removes button functions
		   	this.browse.buttonMode = false;											// to prevent interruption
		   	this.browse.removeEventListener(MouseEvent.ROLL_OVER, rollover);		// to upload.
		   	this.browse.removeEventListener(MouseEvent.ROLL_OUT, rollout);			//
			
			
			var Req:URLRequest; // Creates the URLRequest to use for the file upload
			if(fileRef.xml.userSetFolder == false){
			Req = new URLRequest(fileRef.xml.scriptURL + "?upPath=" +  fileRef.xml.defaultFolder);
				}else{
			Req = new URLRequest(fileRef.xml.scriptURL + "?upPath=" +  this.path_tb.text);}
							
           	for(var i:uint = 0;i < fileRef.pendingFiles.length;i++){
				var file:FileReference = fileRef.pendingFiles[i];
				file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				file.addEventListener(Event.COMPLETE, completeHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        		file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				file.upload(Req);			
				
				}				
			}
        }
		
		public function checkScroll(){  // Handles whether scrollbar should be visible or not
			if(this.hold.height > this.masker.height){  // Also adds all function if scrollbar is visible
				this.scroll.visible = true;
				scroll.Thumb.buttonMode = true;
				scroll.Thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
				}else{
				this.scroll.visible = false;
				hold.x = this.itemHolder.x;
				hold.y = this.itemHolder.y;
				scroll.Thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
				}
			}
			
		public function thumbMouseDown(e:MouseEvent){ // Mouse Down Event for scrollbar Thumb
				var Rect:Rectangle = new Rectangle(0,0,0,scroll.Track.height - scroll.Thumb.height);
				scroll.Thumb.startDrag(false,Rect);
				addEventListener(Event.ENTER_FRAME, scrollHolder);
			}
			
		public function stageMouseUp(e:MouseEvent){ // Mouse Up event to cancel scrollbar scrolling
			scroll.Thumb.stopDrag();
			removeEventListener(Event.ENTER_FRAME, scrollHolder);
			}
			
		public function scrollHolder(e:Event){ // Scroll Event for list of items
			var diff = scroll.Thumb.y;
			var perc = scroll.Thumb.y / (scroll.Track.height - scroll.Thumb.height);
			Tweener.addTween(hold, {y:-perc * (hold.height - masker.height) + masker.y,time:0.4,onComplete:function(){Tweener.removeTweens(this);}});
			}
			
		public function setColors(e:Event){ // Event sets colors of stage objects from XML settings
			
			if(fileRef.xml.userSetFolder == false){
				this.path_tb.text = fileRef.xml.defaultFolder;
				this.path_tb.selectable = false;
				}
			
			var arr:Array = new Array(mainBG.bg,browse.hover.bg,up.hover.bg);
			MainCol = fileRef.xml.child(4);
			
			for(var i:uint = 0; i < arr.length;i++){
				var tran:ColorTransform = arr[i].transform.colorTransform;
				tran.color = fileRef.xml.child(i + 3);
				arr[i].transform.colorTransform = tran;
				}
			}
			
		private function ioErrorHandler(event:Event):void {
        	var file = FileReference(event.target);
        	trace("ioErrorHandler: name=" + file.name);
   		 }
 
   		private function securityErrorHandler(event:Event):void {
        	var file = FileReference(event.target);
        	trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
    	}
						      		
    }
}

// New FileReferenceList class
 
import flash.events.*;					// Imports necessary classes, DO NOT REMOVE!
import flash.net.FileReference;			//
import flash.net.FileReferenceList;		//
import flash.net.FileFilter;			//
import flash.net.*;						//
  
class RefList extends FileReferenceList {			// Creates variables for class
    public var pendingFiles:Array = new Array();	//
	public var file:FileReference;					//
	public var loader:URLLoader = new URLLoader();	//
	public var xml;									//
	
	public var checkFileNames:Function = function(item:*,Index:int, arr:Array){ // Function to check whether 
		return (item.name == this.name);										// file exists in File array
		}
 	
    public function RefList() { //Instantiates class
	   loader.addEventListener(Event.COMPLETE, initializeListListeners);
	   var req:URLRequest = new URLRequest("upload.xml");
	   loader.load(req);// Loads XML file, alter this for different XML file name or location
     }
	
    private function initializeListListeners(e:Event):void {
		xml = new XML(e.currentTarget.data); // formats XML data loaded.
		addEventListener(Event.SELECT, selectHandler);
       }
   
   public function getTypes():Array { // Gets file types that are valid from XML settings
        var allTypes:Array = new Array();
        for(var i:uint = 0; i < xml.filetypes.label.length();i++){
			var filter:FileFilter = new FileFilter(xml.filetypes.label[i],xml.filetypes.type[i]);
			allTypes.push(filter);
			}
        return allTypes;
    }
 
   private function doOnComplete():void { // Fires when file browsing is complete
        var event:Event = new Event(fileUpload.LIST_COMPLETE);
        dispatchEvent(event);
		}
 
    private function addPendingFile(file:FileReference):void { // Adds files to file array
       	if(pendingFiles.length == 0){						   // checks that a file isn't in array twice
			pendingFiles.push(file);
			}else{
			if(!pendingFiles.some(checkFileNames,file)){
			   pendingFiles.push(file);
			   }
			}
		doOnComplete();
		
    }
	
	public function returnFiles():Array{
		return pendingFiles;
		}
		
    
    private function selectHandler(event:Event):void { // Adds files to temp List befoer passing them to file array 
	    for (var i:uint = 0; i < fileList.length; i++) {
            file = FileReference(fileList[i]);
            addPendingFile(file);
        }
    }
 
}
