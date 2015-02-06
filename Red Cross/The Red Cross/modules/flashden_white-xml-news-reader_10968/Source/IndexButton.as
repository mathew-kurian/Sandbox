class IndexButton extends MovieClip {
	
	function IndexButton() {
		trace("-button ["+this._name+"] started.");
	}
	
	function onRollOver() {
		if (_currentFrame==3) return;
		gotoAndStop(2);
	}
	
	function onRollOut() {
		if (_currentFrame==3) return;
		gotoAndStop(1);
	}
	
	function onReleaseOutside(){
		if (_currentFrame==3) return;
			clearInterval(_root.interval);
		gotoAndStop(1);
	}
	
	function onPress() {
		//abort if is a tween in progress
		if (Math.abs(this["pos"]-3)==0) {return;}
		this.gotoAndStop(1);		
		if (Math.abs(this["pos"]-3)==1) {
			if (this["pos"]-3>0) {
				_root.main.shiftButtons(true,undefined,null); _root.main.arrow_leftonPress(Number(this["txt"].text)-1,true);
			} else {
				_root.main.shiftButtons(false,undefined,null); _root.main.arrow_rightonPress(Number(this["txt"].text)-1,true);
			}
		} else {
			if (this["pos"]-3>0) {
				var parameters:Object = new Object();
				parameters.left=true; parameters.trigger=undefined; parameters.parameters=null;
				_root.main.shiftButtons(true,_root.main.shiftButtons,parameters); _root.main.arrow_leftonPress(Number(this["txt"].text)-1,true);
			} else {
				var parameters:Object = new Object();
				parameters.left=false; parameters.trigger=undefined; parameters.parameters=null;
				_root.main.shiftButtons(false,_root.main.shiftButtons,parameters); _root.main.arrow_rightonPress(Number(this["txt"].text)-1,true);
			} 
		}
	}
		
}