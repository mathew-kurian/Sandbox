class com.robertpenner.easing.Elastic
{
    function Elastic()
    {
    } // End of the function
    static function easeIn(t, b, c, d, a, p)
    {
        if (t == 0)
        {
            return (b);
        } // end if
        t = t / d;
        if (t == 1)
        {
            return (b + c);
        } // end if
        if (!p)
        {
            p = d * 3.000000E-001;
        } // end if
        if (!a || a < Math.abs(c))
        {
            a = c;
            var _loc7 = p / 4;
        }
        else
        {
            _loc7 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        t = t - 1;
        return (-a * Math.pow(2, 10 * (t)) * Math.sin((t * d - _loc7) * 6.283185E+000 / p) + b);
    } // End of the function
    static function easeOut(t, b, c, d, a, p)
    {
        if (t == 0)
        {
            return (b);
        } // end if
        t = t / d;
        if (t == 1)
        {
            return (b + c);
        } // end if
        if (!p)
        {
            p = d * 3.000000E-001;
        } // end if
        if (!a || a < Math.abs(c))
        {
            a = c;
            var _loc7 = p / 4;
        }
        else
        {
            _loc7 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        return (a * Math.pow(2, -10 * t) * Math.sin((t * d - _loc7) * 6.283185E+000 / p) + c + b);
    } // End of the function
    static function easeInOut(t, b, c, d, a, p)
    {
        if (t == 0)
        {
            return (b);
        } // end if
        t = t / (d / 2);
        if (t == 2)
        {
            return (b + c);
        } // end if
        if (!p)
        {
            p = d * 4.500000E-001;
        } // end if
        if (!a || a < Math.abs(c))
        {
            a = c;
            var _loc7 = p / 4;
        }
        else
        {
            _loc7 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        if (t < 1)
        {
            t = t - 1;
            return (-5.000000E-001 * (a * Math.pow(2, 10 * (t)) * Math.sin((t * d - _loc7) * 6.283185E+000 / p)) + b);
        } // end if
        t = t - 1;
        return (a * Math.pow(2, -10 * (t)) * Math.sin((t * d - _loc7) * 6.283185E+000 / p) * 5.000000E-001 + c + b);
    } // End of the function
} // End of Class
