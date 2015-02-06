class com.oop.animation.transitions.BlurTransition extends com.oop.animation.Animator
{
    var format, callTween;
    function BlurTransition()
    {
        super();
        format = new Object();
        this.addFormat("_default", {blurX: 0, blurY: 0, quality: 3});
    } // End of the function
    function addFormat(n, ct)
    {
        format[n] = ct;
    } // End of the function
    function apply(clip, sP, eP)
    {
        clip.startBlurTransform = sP;
        clip.endBlurTransform = eP || sP;
    } // End of the function
    function applyF(clip, sP, eP)
    {
        clip.startBlurTransform = format[sP];
        clip.endBlurTransform = eP ? (format[eP]) : (format[sP]);
    } // End of the function
    function setTransform(clip, ct)
    {
        var _loc2 = new flash.filters.BlurFilter(ct.blurX, ct.blurY, ct.quality);
        var _loc1 = new Array();
        _loc1.push(_loc2);
        clip.filters = _loc1;
    } // End of the function
    function init(clip)
    {
        this.setTransform(clip, clip.startBlurTransform);
    } // End of the function
    function remove(clip)
    {
        clip.filters = new Array();
    } // End of the function
    function start(clip, easeClass, easeFunction, time)
    {
        this.callTween(clip, this, "setTransform", this.actualParams(clip), format._default, time, easeClass, easeFunction);
    } // End of the function
    function end(clip, easeClass, easeFunction, time)
    {
        this.callTween(clip, this, "setTransform", this.actualParams(clip), clip.endBlurTransform, time, easeClass, easeFunction);
    } // End of the function
    function actualParams(clip)
    {
        var _loc1 = clip.filters[0];
        return ({blurX: _loc1.blurX, blurY: _loc1.blurY, quality: _loc1.quality});
    } // End of the function
} // End of Class
