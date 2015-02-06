package {
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.*;
	import flash.utils.*;
    import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

    public class GetFile extends Sprite {
		

		public var vars:Object; //Variables
		public var loadedData:Loader;
		public var UloadedData:URLLoader;
		public var url:String;
		public var request:URLRequest = new URLRequest();
		public var separateDefinitions:LoaderContext = new LoaderContext();
		//
		//	functions & parameters
		//
		
		public var onCOMPLETE:Function; 	
		public var onCOMPLETEParams:Array; 	
		public var onIO_ERROR:Function; 	
		public var onIO_ERRORParams:Array; 	
		public var onOPEN:Function; 		
		public var onOPENParams:Array; 		
		public var onPROGRESS:Function; 	
		public var onPROGRESSParams:Array; 	
		
        public function GetFile() {
        }
		
        public function Go() {
			var $url = url;
			var $vars = vars;
			
			if ($url == null) {return};
			
            request.url = $url;
			
			onCOMPLETE = $vars.onCOMPLETE;
			onCOMPLETEParams = $vars.onCOMPLETEParams || [];
			
			onOPEN = $vars.onOPEN;
			onOPENParams = $vars.onOPENParams || [];
			
			onPROGRESS = $vars.onPROGRESS;
			onPROGRESSParams = $vars.onPROGRESSParams || [];
			
			onIO_ERROR = $vars.onIO_ERROR;
			onIO_ERRORParams = $vars.onIO_ERRORParams || [];
			//
			if($url.match(".jpg") == null && $url.match(".gif") == null && $url.match(".mp3") == null && $url.match(".png") == null && $url.match(".bmp") == null && $url.match(".flv") == null && $url.match(".swf") == null) {
				UloadedData = new URLLoader();
				configureListeners(UloadedData);
				UloadedData.load(request);
				} else {
				loadedData = new Loader();
				configureListeners(loadedData.contentLoaderInfo);
				separateDefinitions.applicationDomain = new ApplicationDomain();
				loadedData.load(request, separateDefinitions);
				}
        }
		
//		public static function like($url:String, $vars:Object):GetFile {
//			return new GetFile($url, $vars);
//		}
		
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        public function completeHandler(event:Event):void {
           // trace(event);
			this.onCOMPLETEParams = [];
			this.onCOMPLETEParams.push(event.currentTarget);
			if (this.onCOMPLETE != null) {
				this.onCOMPLETE.apply(null, this.onCOMPLETEParams);
				
			}
        }

        public function openHandler(event:Event):void {
            //trace(event);
			this.onOPENParams = [];
			this.onOPENParams.push(event);
			if (this.onOPEN != null) {
				this.onOPEN.apply(null, this.onOPENParams);
				
			}
        }
        public function progressHandler(event:Event):void {
			//trace(event.target.bytesLoaded);
			//+ " bytesTotal=" + event.bytesTotal
			this.onPROGRESSParams = [];
			this.onPROGRESSParams.push(event);
			this.onPROGRESSParams.push(event.target.bytesLoaded);
			this.onPROGRESSParams.push(event.target.bytesTotal);
			if (this.onPROGRESS != null) {
				this.onPROGRESS.apply(null, this.onPROGRESSParams);
				
			}
        }
        public function ioErrorHandler(event):void {
           // trace("ioErrorHandler: " + event);
			this.onIO_ERRORParams = [];
			this.onIO_ERRORParams.push(event);
			if (onIO_ERROR != null) {
				onIO_ERROR.apply(null, onIO_ERRORParams);
			}
			
        }

		public function stopLoading(){
			try{
				loadedData.close();
				loadedData.unload();
				loadedData.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loadedData.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				} catch(e:Error){}
			try{
				UloadedData.close();
				UloadedData.removeEventListener(Event.COMPLETE, completeHandler);
				UloadedData.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				} catch(e:Error){}
			}

    }
}