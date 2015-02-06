class com.robertpenner.easing.Expo
{
    function Expo()
    {
    } // End of the function
    static function easeIn(t, b, c, d)
    {
        return (t == 0 ? (b) : (c * Math.pow(2, 10 * (t / d - 1)) + b));
    } // End of the function
    static function easeOut(t, b, c, d)
    {
        return (t == d ? (b + c) : (c * (-Math.pow(2, -10 * t / d) + 1) + b));
    } // End of the function
    static function easeInOut(t, b, c, d)
    {
        if (t == 0)
        {
            return (b);
        } // end if
        if (t == d)
        {
            return (b + c);
        } // end if
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * Math.pow(2, 10 * (t - 1)) + b);
        } // end if
        return (c / 2 * (-Math.pow(2, -10 * --t) + 2) + b);
    } // End of the function
} // End of Class
