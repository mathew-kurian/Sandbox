class com.robertpenner.easing.Bounce
{
    function Bounce()
    {
    } // End of the function
    static function easeOut(t, b, c, d)
    {
        t = t / d;
        if (t < 3.636364E-001)
        {
            return (c * (7.562500E+000 * t * t) + b);
        }
        else if (t < 7.272727E-001)
        {
            t = t - 5.454545E-001;
            return (c * (7.562500E+000 * (t) * t + 7.500000E-001) + b);
        }
        else if (t < 9.090909E-001)
        {
            t = t - 8.181818E-001;
            return (c * (7.562500E+000 * (t) * t + 9.375000E-001) + b);
        }
        else
        {
            t = t - 9.545455E-001;
            return (c * (7.562500E+000 * (t) * t + 9.843750E-001) + b);
        } // end else if
    } // End of the function
    static function easeIn(t, b, c, d)
    {
        return (c - com.robertpenner.easing.Bounce.easeOut(d - t, 0, c, d) + b);
    } // End of the function
    static function easeInOut(t, b, c, d)
    {
        if (t < d / 2)
        {
            return (com.robertpenner.easing.Bounce.easeIn(t * 2, 0, c, d) * 5.000000E-001 + b);
        }
        else
        {
            return (com.robertpenner.easing.Bounce.easeOut(t * 2 - d, 0, c, d) * 5.000000E-001 + c * 5.000000E-001 + b);
        } // end else if
    } // End of the function
} // End of Class
