/**
 * btnrepeat.as
 * Repeat button interface
 *
 * @version		1.0
 */
this.getState = function():Boolean {
	return Boolean(this.controls.repeatoff.visible);
};
this.setState = function(boolState:Boolean):void {
	if (!(boolState is Boolean)) return;
	this.controls.repeatoff.visible = boolState;
	this.controls.repeaton.visible = !boolState;
};