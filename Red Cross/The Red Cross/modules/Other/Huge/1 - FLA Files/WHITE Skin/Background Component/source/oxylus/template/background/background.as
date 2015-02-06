import caurina.transitions.*;

class oxylus.template.background.background extends MovieClip 
{
	private var loader:MovieClip;
	
	private var bg:MovieClip;
		private var bgIdx:Number = 0;

	private var HOLDER:MovieClip;
	
	var mcl:MovieClipLoader;
		
	public function background() {
		
		var newMenu:ContextMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		this.menu = newMenu;
		
		loader._alpha = 0;
		
		loadStageResize();
		
		HOLDER = this.createEmptyMovieClip("HOLDER", this.getNextHighestDepth());
		HOLDER._alpha = 0;
		
		mcl =  new MovieClipLoader();
		mcl.addListener(this);
		
		mcl.loadClip("main.swf", HOLDER);
	}
	
	private function onLoadStart(mc:MovieClip) {
		Tweener.addTween(loader, { _alpha:100, time: .5, transition: "linear", rounded:true } );
	}
	
	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number) {
		var per:Number = Math.round(bytesLoaded/bytesTotal*100)
		if (per < 99) {
			loader["text"]["n"].text = per;
		}
	}

	private function onLoadComplete(mc:MovieClip, httpStatus:Number) {
		loader["text"]["n"].text = "99";
		Tweener.addTween(loader, { _alpha:0, time: .5, delay:.2, transition: "linear", rounded:true } );
	}
	
	private function onLoadInit(mc:MovieClip) {
		Tweener.addTween(HOLDER, { _alpha:100, time: .5, transition: "easeOutQuart", rounded:true } );
	}
	
	private function onLoadError(target_mc:MovieClip, errorCode:String, httpStatus:Number) {
		trace(">> onLoadError()");
		trace(">> ==========================");
		trace(">> errorCode: " + errorCode);
		trace(">> httpStatus: " + httpStatus);
	}

	private function resize(w:Number, h:Number) {
		if (w < 980) {
			w = 980;
		}
		
		if (h < 600) {
			h = 600;
		}

		backgroundResize(w, h);
		
		/**
		 * loader positioning
		 */
		
		loader._x = Math.round(w / 2 - loader._width / 2);
		loader._y = Math.round(h / 2 - loader._height / 2);
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	private function backgroundResize(w:Number, h:Number) {
		/**
		 * this will resize the background, the background is formed by many squares multiplied to fill the whole screen
		 */
		var posX:Number = 0;
		var posY:Number = 0;
		
		if ((bg._width < w) || (bg._height < h)) {
			var i:Number = 1;
			
			while (bg["copy" + i]) {
				bg["copy" + i].removeMovieClip();
				i++;
			}
			
			while (posX < w) {
				bgIdx++;
				posX += bg["copy"]._width;
				var duplicate:MovieClip = bg["copy"].duplicateMovieClip("copy" + bgIdx, bg.getNextHighestDepth(), { _x:posX, _y:posY } );
				if (posX >= w) {
					posX = -bg["copy"]._width;
					posY += bg["copy"]._height;
				}
				if (posY > h) {
					break;
				}
			}
		}
	}
}