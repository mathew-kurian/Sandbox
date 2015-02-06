import oxylus.Utils;
class oxylus.apc.ClickDragCursor extends MovieClip {
	public function ClickDragCursor() {
		// stop and hide
		this.stop();
		Mouse.hide();
		this.onMouseMove();
	}
	// grab behavior
	private function onMouseDown() {
		//this.gotoAndStop(2);
		Utils.mcPlay(this, 0);
	}
	private function onMouseUp() {
		//this.gotoAndStop(1);
		Utils.mcPlay(this, 1);
	}
	// cursor behavior
	private function onMouseMove() {
		this._x = this._parent._xmouse;
		this._y = this._parent._ymouse;
	}
	// remove
	public function remove() {
		Mouse.show();
		this.removeMovieClip();
	}
}
