class com.oop.animation.transitions.ColorTransition extends com.oop.animation.Animator
{
    var format, callTween;
    function ColorTransition()
    {
        super();
        format = new Object();
        this.addFormat("_default", {ra: 1, rb: 0, ga: 1, gb: 0, ba: 1, bb: 0, aa: 1, ab: 0});
    } // End of the function
    function addFormat(n, ct)
    {
        format[n] = ct;
    } // End of the function
    function convertHex(n)
    {
        var _loc2;
        var _loc1;
        if (n.toLowerCase() == "ff")
        {
            _loc2 = 255;
        }
        else if (n.toLowerCase() == "cc")
        {
            _loc2 = 204;
        }
        else
        {
            _loc1 = n.split("");
            _loc1[0] = _loc1[0] * 16;
            _loc2 = Number(_loc1[0]) + Number(_loc1[1]);
        } // end else if
        return (Number(_loc2));
    } // End of the function
    function apply(clip, sP, eP)
    {
        clip.startColorTransform = sP;
        clip.endColorTransform = eP || sP;
        this.init(clip);
    } // End of the function
    function applyF(clip, sP, eP)
    {
        clip.startColorTransform = format[sP];
        clip.endColorTransform = eP ? (format[eP]) : (format[sP]);
        this.init(clip);
    } // End of the function
    function applyHex(clip, cStart, aStart, cEnd, aEnd)
    {
        clip.startColorTransform = {ra: 1, ga: 1, ba: 1, aa: 1, rb: this.convertHex(cStart.substring(cStart.length - 6, cStart.length - 4)), gb: this.convertHex(cStart.substring(cStart.length - 4, cStart.length - 2)), bb: this.convertHex(cStart.substring(cStart.length - 2, cStart.length)), ab: 255 * aStart / 100 - 255};
        clip.endColorTransform = {ra: 1, ga: 1, ba: 1, aa: 1, rb: cEnd ? (this.convertHex(cEnd.substring(cEnd.length - 6, cEnd.length - 4))) : (clip.startColorTransform.rb), gb: cEnd ? (this.convertHex(cEnd.substring(cEnd.length - 4, cEnd.length - 2))) : (clip.startColorTransform.gb), bb: cEnd ? (this.convertHex(cEnd.substring(cEnd.length - 2, cEnd.length))) : (clip.startColorTransform.bb), ab: aEnd ? (255 * aEnd / 100 - 255) : (clip.startColorTransform.ab)};
        if (!clip.__transform)
        {
            this.init(clip);
        } // end if
    } // End of the function
    function setTransform(clip, ct)
    {
        clip.__transform.colorTransform = new flash.geom.ColorTransform(ct.ra, ct.ga, ct.ba, ct.aa, ct.rb, ct.gb, ct.bb, ct.ab);
    } // End of the function
    function init(clip)
    {
        clip.__transform = new flash.geom.Transform(clip);
        this.setTransform(clip, clip.startColorTransform);
    } // End of the function
    function remove(clip)
    {
        clip.__transform = new flash.geom.Transform(clip);
        this.setTransform(clip, format._default);
    } // End of the function
    function start(clip, easeClass, easeFunction, time)
    {
        clip.__transform = new flash.geom.Transform(clip);
        this.callTween(clip, this, "setTransform", this.actualParams(clip), format._default, time, easeClass, easeFunction);
    } // End of the function
    function end(clip, easeClass, easeFunction, time)
    {
        clip.__transform = new flash.geom.Transform(clip);
        this.callTween(clip, this, "setTransform", this.actualParams(clip), clip.endColorTransform, time, easeClass, easeFunction);
    } // End of the function
    function toStart(clip, easeClass, easeFunction, time)
    {
        this.callTween(clip, this, "setTransform", this.actualParams(clip), clip.startColorTransform, time, easeClass, easeFunction);
    } // End of the function
    function toEnd(clip, easeClass, easeFunction, time)
    {
        this.callTween(clip, this, "setTransform", this.actualParams(clip), clip.endColorTransform, time, easeClass, easeFunction);
    } // End of the function
    function actualParams(clip)
    {
        var _loc1 = clip.__transform.colorTransform;
        return ({ra: _loc1.redMultiplier, rb: _loc1.redOffset, ga: _loc1.greenMultiplier, gb: _loc1.greenOffset, ba: _loc1.blueMultiplier, bb: _loc1.blueOffset, aa: _loc1.alphaMultiplier, ab: _loc1.alphaOffset});
    } // End of the function
} // End of Class
