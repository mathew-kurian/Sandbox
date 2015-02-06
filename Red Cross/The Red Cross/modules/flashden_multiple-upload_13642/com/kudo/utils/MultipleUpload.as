// delegate
import mx.utils.Delegate;
// ui components
import mx.controls.DataGrid;
import mx.controls.Button;
import mx.controls.ProgressBar;
import mx.controls.CheckBox;
import mx.controls.Alert;
// file reference
import flash.net.FileReferenceList;
import flash.net.FileReference;
import flash.external.*;
class com.kudo.utils.MultipleUpload {
	private var fileRef:FileReferenceList;
	private var fileRefListener:Object;
	//private var list:Array;
	public var list:Array;
	private var files_dg:DataGrid;
	private var browse_btn:Button;
	private var upload_btn:Button;
	private var remover_btn:Button;
	private var quidinh_cb:CheckBox;
	private var listenerObject:Object = new Object();
	private var loading_pBar:ProgressBar;
	private var item:Number;
	public var totalByte:Number = 0;
	private var percentBar:Number=0;
	private var currentFile:Number = 0;
	private var fileComplete:String=" 0 files";
	private var mPhp:String;
	private var ei1:Boolean;
	private var listFiles:Array;
	private var allTypes:Array = new Array();
	private var imageTypes:Object = new Object();
	public var maxFileSize:Number = 0;//0 unlimited
	public var fileTypeDes : String = "All files";
	public var fileTypes : String = "*.*"
	
	//public var maxTotalSize:Number = 0;//0 unlimited

	//////////////////////////////////////////////////////////////////////
	//
	// Constructor (files_dg, browse_btn, upload_btn, remove_btn,loadingBar,CheckBox,filePhp)
	//
	//////////////////////////////////////////////////////////////////////
	public function MultipleUpload(fdg:DataGrid, bb:Button, ub:Button, rb:Button, lBar:ProgressBar,cb:CheckBox,filePhp:String) {
		// references for objects on the stage
		files_dg = fdg;
		browse_btn = bb;
		upload_btn = ub;
		remover_btn = rb;
		loading_pBar = lBar;
		quidinh_cb = cb;	
		mPhp = filePhp;
		
		listFiles = [];
		imageTypes.description = fileTypeDes;
		imageTypes.extension = fileTypes;
		allTypes.push(imageTypes);		
		ei1 = ExternalInterface.addCallback("doUpLoad", null, _root.doUpLoad);
		// file list references & listener
		fileRef = new FileReferenceList();
		fileRefListener = new Object();
		fileRef.addListener(fileRefListener);
		// setup
		iniUI();
		inifileRefListener();
	}
	//////////////////////////////////////////////////////////////////////
	//
	// iniUI
	//
	//////////////////////////////////////////////////////////////////////
	public function iniUI() {
		// buttons
		browse_btn.onRelease = Delegate.create(this, this.browse);
		upload_btn.onRelease = Delegate.create(this, this.upload);
		remover_btn.onRelease = Delegate.create(this, this.remover);		
		remover_btn.enabled = false;
		upload_btn.enabled = false;
		browse_btn.enabled = false;
		files_dg.enabled = false;
		// check box
		listenerObject.click = Delegate.create(this, clickCheckBox);
		quidinh_cb.addEventListener("click", listenerObject);
		// columns for dataGrid
		files_dg.addColumn("name");
		files_dg.addColumn("size");
		files_dg.addColumn("status");
		var dgListener:Object = new Object();
		dgListener.change = function(evt_obj:Object) {
			//trace("The selection has changed to "+evt_obj.target.selectedIndex);
			_root.item = evt_obj.target.selectedIndex;
		};
		// Add listener.
		files_dg.addEventListener("change", dgListener);
	}
	// check the check box selected
	private function clickCheckBox(evt_obj:Object){
		if (evt_obj.target.selected){
			browse_btn.enabled = true;		
			files_dg.enabled = true;	
			if (_root.selectFile) {
				remover_btn.enabled = true;
				upload_btn.enabled = true;
				_root.upload1_btn.enabled = true;
			} else {
				remover_btn.enabled = false;
				upload_btn.enabled = false;
				_root.upload1_btn.enabled = false;
			}
		} else {
			browse_btn.enabled = false;
			files_dg.enabled = false;
			remover_btn.enabled = false;
			upload_btn.enabled = false;
			_root.upload1_btn.enabled = false;
		}
	}
	public function remover() {
		totalByte = 0;
		list[_root.item].cancel();
		files_dg.removeItemAt(_root.item);
		var myTemp_array:Array = new Array();
		myTemp_array = list.splice(_root.item, 1);
		for (var i = 0; i<list.length; i++) {
			totalByte = totalByte + Math.round(list[i].size);
		}
		if (_root._upload == true){
			upload();
		}
	}
	public function browse() {
		_root._upload = false;
		currentFile = 0;
		percentBar = 0;
		totalByte = 0;
		fileComplete = "0 file";
		fileRef.browse(allTypes);
	}
	public function upload() {
		//trace("// upload");
		//update_pBar();
		/*
		// upload the files
		for (var i:Number = 0; i<list.length; i++) {
		var file = list[i];
		trace("name: "+file.name);
		trace(file.addListener(this));
		//file.upload("http://timnhanhdev.com/upload/uploadNew/uploadfiles.php");			
		file.upload("http://mad.timnhanh.com/test/uploadfiles.php");
		}
		*/
		browse_btn.enabled = false;
		var file = list[currentFile];
		_root.myText.text = file.addListener(this) +"name: "+file.name ;
		//file.upload("http://mad.timnhanh.com/test/uploadfiles.php");
		file.upload(mPhp);
	}
	//*************************************************************
	// Phan ket noi giua Javascript va Flash
	//*************************************************************
	
	//////////////////////////////////////////////////////////////////////
	//
	// inifileRefListener
	//
	//////////////////////////////////////////////////////////////////////
	public function inifileRefListener() {
		fileRefListener.onSelect = Delegate.create(this, this.onSelect);
		fileRefListener.onCancel = Delegate.create(this, this.onCancel);
		fileRefListener.onOpen = Delegate.create(this, this.onOpen);
		fileRefListener.onProgress = Delegate.create(this, this.onProgress);
		fileRefListener.onComplete = Delegate.create(this, this.onComplete);
		fileRefListener.onHTTPError = Delegate.create(this, this.onHTTPError);
		fileRefListener.onIOError = Delegate.create(this, this.onIOError);
		fileRefListener.onSecurityError = Delegate.create(this, this.onSecurityError);
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onSelect
	//
	//////////////////////////////////////////////////////////////////////
	private function copyArr(tar,src: Array){
		for (var i: Number =0; i<src.length; i++){
			tar.push(src[i]);
		}
	}
	
	private function checkConcide(chkfile: FileReference, flist: Array): Boolean{
		var chk : Boolean = false;
		
		
		for (var i = 0; i<flist.length; i++){
			var cFile: FileReference = flist[i];			
			if (cFile.name == chkfile.name && cFile.size == chkfile.size){
				chk = true;
				break;
			}
		}
		return chk;
	}	
	public function onSelect(fileRefList:FileReferenceList) {
		//trace("// onSelect");
		// list of the file references		
		//new
		remover_btn.enabled = true;
		upload_btn.enabled = true;
		_root.upload1_btn.enabled = true;
		_root.selectFile = true;
		(list == undefined)? list=[] : null;
		var delList : Array = [];
		var delListNames : String = "";
		for (var i: Number=0; i<fileRefList.fileList.length; i++){
			var file : FileReference = fileRefList.fileList[i];
			if (file.size > maxFileSize && maxFileSize>0){
				if (delListNames != ""){
					delListNames = delListNames + ", ";
				}
				if (delListNames.length<300){
					delListNames = delListNames + file.name;
				}
				delList.push(fileRefList.fileList.splice(i,1)[0]);				
				i--;				
			} else {
				if (checkConcide(file, list)) {
					fileRefList.fileList.splice(i,1);
					i--;
				}
			}
		}
		if (delList.length > 0) {
			//ExternalInterface.call("delList",delList)
			Alert.show(delListNames, "Invalid file size");
		}
		copyArr(list, fileRefList.fileList);		
		//old
		//list = fileRefList.fileList;		
		// data provider list so we can customize things
		var list_dp = new Array();			
		// loop over original list, convert bytes to kilobytes
		for (var i:Number = 0; i<list.length; i++) {			
			//list_dp.push({name:list[i].name, size:Math.round(list[i].size/1000)+" kb", status:"ready for upload"});
			list_dp.push({name:list[i].name, size:Math.round(list[i].size/1000)+" kb", status:"ready for upload"});
			//totalByte = totalByte + Math.round(list[i].size/1000);			
			totalByte = totalByte + Math.round(list[i].size);					
		}
		// display list of files in dataGrid
		//percentBar = Math.round(list[0].size/1000);
		files_dg.dataProvider = list_dp;
		files_dg.spaceColumnsEqually();
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onCancel
	//
	//////////////////////////////////////////////////////////////////////
	public function onCancel() {
		//trace("// onCancel");
		ExternalInterface.call("onCancel");
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onOpen
	//
	//////////////////////////////////////////////////////////////////////
	public function onOpen(file:FileReference) {
		_root._upload = false;
		//trace("// onOpenName: "+file.name);
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onProgress
	//
	//////////////////////////////////////////////////////////////////////
	public function onProgress(file:FileReference, bytesLoaded:Number, bytesTotal:Number) {
		//trace("// onProgress with bytesLoaded: "+bytesLoaded+" bytesTotal: "+bytesTotal);		
		for (var i:Number = 0; i<list.length; i++) {
			if (list[i].name == file.name) {
				var percentDone = Math.round((bytesLoaded/bytesTotal)*100);				
				files_dg.editField(i, "status", "uploading: "+percentDone+"%");					
			}
		}
		update_pBar(percentBar+bytesLoaded,"% upload success "+fileComplete);
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onComplete
	//
	//////////////////////////////////////////////////////////////////////
	public function onComplete(file:FileReference) {
		//trace("// onComplete: "+currentFile + "---> "+list.length);			
		if (currentFile<list.length) {
			percentBar= percentBar + Math.round(list[currentFile].size);
			listFiles.push(file.name);
			currentFile++;			
			upload();
		} else {
			trace("Xong het file");
			currentFile =0;			
			percentBar = 0;
			totalByte = 0;
			fileComplete = "0 file";			
		}				
		for (var i:Number = 0; i<list.length; i++) {
			if (list[i].name == file.name) {
				files_dg.editField(i, "status", "complete");			
			}
		}
		fileComplete = currentFile+" file";
		update_pBar(percentBar,"% upload success "+fileComplete);	
		if (currentFile == list.length) {
			//trace(listFiles)
			ExternalInterface.call("onComplete",listFiles);
			browse_btn.enabled = true;
		}
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onHTTPError
	//
	//////////////////////////////////////////////////////////////////////
	public function onHTTPError(file:FileReference, httpError:Number) {
		trace("// onHTTPError: "+file.name+" httpError: "+httpError);
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onIOError
	//
	//////////////////////////////////////////////////////////////////////
	public function onIOError(file:FileReference) {
		trace("// onIOError: "+file.name);
		if (currentFile<list.length) {
			upload();
		}
	}
	//////////////////////////////////////////////////////////////////////
	//
	// onSecurityError
	//
	//////////////////////////////////////////////////////////////////////
	public function onSecurityError(file:FileReference, errorString:String) {
		trace("onSecurityError: "+file.name+" errorString: "+errorString);
	}
	//////////////////////////////////////////////////////////////////////
	//
	// ProgressBar
	//
	//////////////////////////////////////////////////////////////////////
	public function update_pBar(minBar:Number,labelBar:String) {
		trace(minBar+" : " + totalByte);
		loading_pBar.mode = "manual";
		loading_pBar.label = Math.round((minBar/totalByte)*100)+" "+labelBar;
		//"%1 out of %2 loaded";
		//minimum numerical value before progress bar increments
		loading_pBar.minimum =0;
		//maximum value of progress bar before it stops
		loading_pBar.maximum = totalByte;
		//update progress of number incrementing
		loading_pBar.setProgress(minBar, totalByte);
	}
}
