class mx.transitions.easing.Regular
{
    function Regular()
    {
    } // End of the function
    static function easeIn(t, b, c, d)
    {
        t = t / d;
        return (c * (t) * t + b);
    } // End of the function
    static function easeOut(t, b, c, d)
    {
        t = t / d;
        return (-c * (t) * (t - 2) + b);
    } // End of the function
    static function easeInOut(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * t * t + b);
        } // end if
        return (-c / 2 * (--t * (t - 2) - 1) + b);
    } // End of the function
    static var version = "1.1.0.52";
} // End of Class
