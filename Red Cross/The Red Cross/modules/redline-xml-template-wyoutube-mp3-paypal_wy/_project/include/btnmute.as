/**
 * button.as
 * Mute button interface
 *
 * @version		1.0
 */
this.getState = function():Boolean {
	return Boolean(this.controls.off.visible);
};
this.setState = function(boolState:Boolean):void {
	if (!(boolState is Boolean)) return;
	this.controls.off.visible = boolState;
	this.controls.on.visible = !boolState;
};