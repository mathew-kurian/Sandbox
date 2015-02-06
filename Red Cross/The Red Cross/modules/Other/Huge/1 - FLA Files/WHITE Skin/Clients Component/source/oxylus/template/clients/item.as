import mx.events.EventDispatcher;
import oxylus.Utils;
import oxylus.Tooltip03.Tooltip;
import caurina.transitions.*;
import ascb.util.Proxy;

class oxylus.template.clients.item extends MovieClip 
{
	private var stroke:MovieClip;
	private var holder:MovieClip;
	private var loader:MovieClip;
	
	private var node:XMLNode;
	private var mcl:MovieClipLoader;
	private var myTooltip:MovieClip;
	
	private var settings:Object;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function item() {
		EventDispatcher.initialize(this);
		holder._alpha = stroke._alpha = 0;
		myTooltip = Tooltip.attach(this._parent._parent._parent);
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	public function setNode(n:XMLNode, sett:Object) {
		node = n;
		settings = sett;
		
		myTooltip.setCustomVars({myTexts:String(node.attributes.name + "<new_line>" + node.attributes.description),
			    myFonts:"a|a",
			    myColors:"0xf6f6f6|0x929292",
				mySizes:"12|8",
				myVerticalSpaces:"2|-2|-2|-2",
				textXPos:0,
				farX:0,
				strokeColor:"0x434343",
				strokeAlpha:100,
				strokeWidth:1,
					
				backgroundColor:"0x2d2d2d|0x3e3e3e|0x565656",
				backgroundAlpha:100,
				backgroundRadius:2,
				backgroundWidth:10,
				backgroundHeight:0,
				
				addShadow:"true",
				shadowAngleInDegrees:90,
				shadowDistance:2,
				shadowColor:"0x000000",
				shadowAlpha:"0.10",
				shadowBlurX:"6",
				shadowBlurY:"6",
				shadowStrength:"3",
				shadowQuality:"3",
				
				tipOrientation:"bottom",
				tipWidth:7,
				tipHeight:16,
				tipInclination:3.5,
				tipX:70,
				
				XDistanceFromCursor:-10,
				YDistanceFromCursor:-10,
				alignHoriz:"right",
				alignVerti:"top",
				stageToleranceX:0,
				stageToleranceY:10
			}, this._parent._parent._parent);
			
		
		loader["bg"]._width = settings.imageWidth;
		loader["bg"]._height = settings.imageHeight;
		
		loader["spin"]._x = Math.round(settings.imageWidth / 2);
		loader["spin"]._y = Math.round(settings.imageHeight / 2);
		
		mcl.loadClip(node.attributes.src, holder);
	}
	
	private function onLoadInit(mc:MovieClip) // executed when the image has fully loaded
	{
		Utils.getImage(mc, true);
		mc._width = settings.imageWidth;
		mc._height = settings.imageHeight;
		
		mc._x = mc._y = 4;
		
		
		stroke["over"]._width = mc._width + 6;
		stroke["over"]._height = mc._height + 6;
		
		stroke["white"]._width = mc._width + 6;
		stroke["white"]._height = mc._height + 6;
		
		stroke["black"]._width = mc._width + 8;
		stroke["black"]._height = mc._height + 8;
		
		Tweener.addTween(holder, { _alpha:100, time:.5, transition:"linear" } );
		Tweener.addTween(stroke, { _alpha:100, delay:.5, time:.5, transition:"linear" } );
		Tweener.addTween(loader, { _alpha:0, time: .5, transition: "easeOutQuad", onComplete: Proxy.create(this, stopSpin) } );
		
		dispatchEvent( { target:this, type:"itemLoaded" } );
	}
	
	private function stopSpin() {
		loader["spin"].stop();
		loader.removeMovieClip();
	}
	
	private function onRollOver() {
		myTooltip.show( { animationTime:0.3,	animationType:"linear",	stay:0 } );
		Tweener.addTween(stroke["over"], { _alpha:100, time:.1, transition:"linear" } );
	}
	
	private function onRollOut() {
		myTooltip.hide( { animationTime:0.3,	animationType:"linear"	} );
		Tweener.addTween(stroke["over"], { _alpha:0, time:.1, transition:"linear" } );
	}
	
	private function onRelease() {
		getURL(node.attributes.url, node.attributes.target);
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
}