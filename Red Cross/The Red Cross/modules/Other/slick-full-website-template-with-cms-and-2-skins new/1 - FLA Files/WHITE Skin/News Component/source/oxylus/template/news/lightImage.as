import oxylus.Utils;

class  oxylus.template.news.lightImage extends MovieClip
{
	private var mcl:MovieClipLoader;
	private var holder:MovieClip;
	private var address:String;
	private var resize:Array;
	
	private var startFunction:Function;
	private var progressFunction:Function;
	private var completeFunction:Function;
	private var initFunction:Function;
	private var errorFunction:Function;
	
	/**
	 * This will handle loading one image
	 * @param	pObj
	 */
	public function lightImage(pObj:Object) {
		
		for (var i in pObj) {
			switch(i)
			{
				case "holder":
					holder = pObj.holder;
					break;
				
				case "resize":
					resize = new Array();
					resize[0] = Number(pObj.resize[0]);
					resize[1] = Number(pObj.resize[1]);
					resize[2] = String(pObj.resize[2]);
					break;
				
				case "address":
					address = pObj.address;
					break;
				
				case "startFunction":
					startFunction = pObj.startFunction;
					break;
						
				case "progressFunction":
					progressFunction = pObj.progressFunction;
					break;
						
				case "completeFunction":
					completeFunction = pObj.completeFunction;
					break;
					
				case "initFunction":
					initFunction = pObj.initFunction;
					break;
					
				case "errorFunction":
					errorFunction = pObj.errorFunction;
					break;
						
				default:
					trace("Object " + pObj[i] + " inexistent !");
					break;
				}
		}
		
		if ((holder) && (address)) {
			mcl = new MovieClipLoader();
			mcl.addListener(this);
			mcl.loadClip(address, holder)
		}
		else {
			trace("Holder or address missing !");
		}
	}
	
	private function onLoadStart(pMc:MovieClip):Void {
		if (startFunction) {
			startFunction(pMc);
		}
	}
	
	private function onLoadProgress(pMc:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
		if (progressFunction) {
			progressFunction(Math.round(bytesLoaded/bytesTotal*100));
		}
	}
	
	private function onLoadComplete(pMc:MovieClip):Void {
		if (completeFunction) {
			completeFunction(pMc);
		}
	}
	
	/**
	 * this will execute the initFunction +:
	 * smoothen the image
	 * resize the image by ratio if resize[2] = true, taking into consideration the max width and height ( resize[0], resize[1] values )
	 * resize the image to ( resize[0] and resize[1] values )
	 * @param	pMc
	 */ 
	private function onLoadInit(pMc:MovieClip):Void {
		if (initFunction) {
			Utils.getImage(pMc, true);
			
			if (resize[2] == "ratio") {
				var obj:Object = Utils.getDims("fit", pMc._width, pMc._height, resize[0], resize[1], false);
				pMc._width = obj.w;
				pMc._height = obj.h;
				pMc._x = obj.x;
				pMc._y = obj.y;
			}
			
			if (resize[2] == "fixed") {
				pMc._width = resize[0];
				pMc._height = resize[1];
			}
			
			initFunction(pMc);
		}
	}
	
	private function onLoadError(pMc:MovieClip, errorCode:String, httpStatus:Number) {
		if (errorFunction) {
			errorFunction(pMc);
			trace(">> errorCode: " + errorCode);
			trace(">> httpStatus: " + httpStatus);
		}
	}
}