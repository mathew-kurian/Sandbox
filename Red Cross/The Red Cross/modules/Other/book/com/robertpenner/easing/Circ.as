class com.robertpenner.easing.Circ
{
    function Circ()
    {
    } // End of the function
    static function easeIn(t, b, c, d)
    {
        t = t / d;
        return (-c * (Math.sqrt(1 - t * t) - 1) + b);
    } // End of the function
    static function easeOut(t, b, c, d)
    {
        t = t / d - 1;
        return (c * Math.sqrt(1 - (t) * t) + b);
    } // End of the function
    static function easeInOut(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (-c / 2 * (Math.sqrt(1 - t * t) - 1) + b);
        } // end if
        t = t - 2;
        return (c / 2 * (Math.sqrt(1 - (t) * t) + 1) + b);
    } // End of the function
} // End of Class
