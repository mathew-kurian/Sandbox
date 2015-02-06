

class oxylus.mp3Player.mp03.scrubber extends MovieClip 
{
	private var settings:Object;
	private var int:Number;
	public var sound:Sound;
	public var aprxPos:Number;
	public function scrubber()
	{
		settings = new Object();
		
		this.createEmptyMovieClip("bg", this.getNextHighestDepth());
		this.createEmptyMovieClip("loadingBg", this.getNextHighestDepth());
		this.createEmptyMovieClip("progressBg", this.getNextHighestDepth());
		
	}
	
	public function attach(settings_:Object)
	{
		settings = settings_;
		
		drawOval(this["bg"], settings.scrubberWidth, settings.scrubberHeight, 0, settings.scrubberNormalBgColor, 100);
		drawOval(this["loadingBg"], settings.scrubberWidth, settings.scrubberHeight, 0, settings.scrubberLoadingBgColor, 100);
		drawOval(this["progressBg"], settings.scrubberWidth, settings.scrubberHeight, 0, settings.scrubberProgressBgColor, 100);
		this["loadingBg"]._xscale = this["progressBg"]._xscale = 0;
		this._x = settings.scrubberX + settings.playerX;
		this._y = settings.scrubberY + settings.playerY;
	}
	
	public function playProgress(ratio:Number)
	{
		this["progressBg"]._xscale = ratio;
	}
	
	public function loadProgress(ratio:Number)
	{
		this["loadingBg"]._xscale = ratio;
	}
	
	private function onPress()
	{
		if(this._parent.main.playing==1)
			int = setInterval(this, "dragg", 5);
	}
	
	private function onRelease()
	{
		clearInterval(int);	
	}
	
	private function onReleaseOutside()
	{
		clearInterval(int);	
	}
	
	public function dragg()
	{
		if ((_xmouse > 0) && (_xmouse < this["loadingBg"]._width))
		{
			var t:Number = this._xmouse / this._width * 100;
			this["progressBg"]._xscale = t;
			sound.start((aprxPos/100*t)/1000);
		}
	}
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
		mc.beginFill(fillColor,alphaAmount);
		mc.moveTo(r,0);
		mc.lineTo(mw-r,0);
		mc.curveTo(mw,0,mw,r);
		mc.lineTo(mw,mh-r);
		mc.curveTo(mw,mh,mw-r,mh);
		mc.lineTo(r,mh);
		mc.curveTo(0,mh,0,mh-r)
		mc.lineTo(0,r);
		mc.curveTo(0,0,r,0);
		mc.endFill();
	}
}