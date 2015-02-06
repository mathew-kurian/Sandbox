class ScrollBar extends MovieClip {
	
	private var inter1:Number; //interval for setInterval function
	private var thisObj:MovieClip; //holds the "this" object
	private var mustReactivate:Boolean=false;
	
	static var instance:ScrollBar; //this class
	static var mouseListener:Object=[]; //mouse listener for mouse wheel
	
	function ScrollBar() {//constructor
		instance=this; //i am me
		trace("- ScroolBar "+this+" started.");
		init(); //initialize
	}
	
	function init() {		
		//set event handlers
		this["aU"].onPress=function() {
			clearInterval(instance.inter1);
			instance.inter1=setInterval(instance.scrollContinuously,50,this._parent._parent,false);
		}
		this["aD"].onPress=function() {
			clearInterval(instance.inter1);
			instance.inter1=setInterval(instance.scrollContinuously,50,this._parent._parent,true);
		}
		
		this["aU"].onRelease=this["aU"].onReleaseOutside=this["aD"].onRelease=this["aD"].onReleaseOutside=function(){
			clearInterval(instance.inter1);
		}
		this["elevator"].onRollOver=function() {
			gotoAndStop(2);
		}
		this["elevator"].onRollOut=this["elevator"].onReleaseOutside=function() {
			this.stopDrag();
			gotoAndStop(1);
		}
		this["elevator"].onPress=function() {
			//l,t,r,b
			startDrag(this,false,2,_parent.a1._y,2,_parent.a2._y-this._height);
			instance.inter1 = setInterval(instance.scrollToElevatorPosition, 50, this, _parent);
		}
		this["elevator"].onRelease=function() {
			this.stopDrag();
			clearInterval(instance.inter1);
		}
		
		//enable mouse wheel 
		Mouse.removeListener (ScrollBar.mouseListener);
		instance.thisObj=this._parent;
		ScrollBar.mouseListener = new Object();
		ScrollBar.mouseListener.onMouseWheel = function(delta) {
    		instance.scrollContinuously(instance.thisObj,true,-delta);
		}
		ScrollBar.mouseListener.onMouseMove = function () {
			var x=_root._xmouse;
			var y=_root._ymouse;
			if ((x>_root.aMDT._x && x<_root.aMDB._x) && (y>_root.aMDT._y && y<_root.aMDB._y)) {
				if (_root.main.newsPause==-1) {
					return;
				}
				clearInterval(_root.main.inter3);
				clearInterval(_root.interval);
				instance.mustReactivate=true;
			} else {
				if (_root.main.newsPause==-1) {
					return;
				}
				if (instance.mustReactivate) {
					instance.mustReactivate=false;
					clearInterval(_root.interval);
					clearInterval(_root.main.inter3);
					_root.interval = setInterval(function() {
										  clearInterval(_root.interval);
										  _root.main.autoPlay();
										  _root.main.inter3 = setInterval(_root.main.autoPlay,_root.main.newsPause*1000);},3000);
				}
			}
		}
		Mouse.addListener(ScrollBar.mouseListener);
		
		//initialize scroll bar
		reconstruct();
	}
	
	function reconstruct(){
		//activate components
		this._parent.scroll_bar._visible=true; //this["aU"].enabled=this["aD"].enabled=true;
		//scale the elevator
		this["elevator"]._yscale=100;this["elevator"]._y=this["a1"]._y;this["elevator"]._x=this["a1"]._x;_parent.txt.scroll=1;
		this["elevator"]._yscale=_parent.txt.bottomScroll*100/(_parent.txt.maxscroll+_parent.txt.bottomScroll);
		//don't allow elevator's height to be less than 5 pixels
		if (this["elevator"]._height<5) {
			this["elevator"]._height=5;
		}
		//hide the elevator if no scrolling is necessary & deactivate arrows
		if (_parent.txt.maxscroll==_parent.txt.scroll) {
			this._parent.scroll_bar._visible=false;
		}
	}
	
	//this will be called with setInerval to scroll continously when the arrow is pressed
	function scrollContinuously(thisObj:MovieClip, up:Boolean, delta:Number){
		if (delta!=undefined) {
			thisObj.txt.scroll+=delta;
		} else if (up) {
			thisObj.txt.scroll++;
		} else {
			thisObj.txt.scroll--;
		}
		var percent=100-(thisObj.txt.maxscroll-thisObj.txt.scroll)*100/(thisObj.txt.maxscroll-1);
		thisObj=thisObj.scroll_bar;
		thisObj.elevator._y=(100*thisObj.a1._y+percent*(thisObj.a2._y-thisObj.elevator._height-thisObj.a1._y))/100;
	}
	
	//this will scroll the text field according to the elevator position
	function scrollToElevatorPosition(thisObj:MovieClip, parent:MovieClip){
		var actual=100*(thisObj._y-parent.a1._y)/(parent.a2._y-parent.a1._y-thisObj._height);
		if (parent.a2._y-parent.a1._y-thisObj._height-(thisObj._y-parent.a1._y)<1) actual=100;
		parent._parent.txt.scroll=parent._parent.txt.maxscroll-(parent._parent.txt.maxscroll-actual*(parent._parent.txt.maxscroll-1)/100);// Math.round(287*actual/100);
		actual==100?parent._parent.txt.scroll=parent._parent.txt.maxscroll:false;
	}
	
	//adds htmtext to the text field
	function setText(txt:String){
		_parent["txt"].html=true;
		_parent["txt"].htmlText=txt;
		Selection.setFocus(_root.jhj);
		this.init();
		this.reconstruct();
	}
}