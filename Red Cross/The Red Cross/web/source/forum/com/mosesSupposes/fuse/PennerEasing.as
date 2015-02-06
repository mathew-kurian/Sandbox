class com.mosesSupposes.fuse.PennerEasing
{
    function PennerEasing()
    {
    } // End of the function
    static function linear(t, b, c, d)
    {
        return (c * t / d + b);
    } // End of the function
    static function easeInQuad(t, b, c, d)
    {
        t = t / d;
        return (c * (t) * t + b);
    } // End of the function
    static function easeOutQuad(t, b, c, d)
    {
        t = t / d;
        return (-c * (t) * (t - 2) + b);
    } // End of the function
    static function easeInOutQuad(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * t * t + b);
        } // end if
        return (-c / 2 * (--t * (t - 2) - 1) + b);
    } // End of the function
    static function easeInExpo(t, b, c, d)
    {
        return (t == 0 ? (b) : (c * Math.pow(2, 10 * (t / d - 1)) + b));
    } // End of the function
    static function easeOutExpo(t, b, c, d)
    {
        return (t == d ? (b + c) : (c * (-Math.pow(2, -10 * t / d) + 1) + b));
    } // End of the function
    static function easeInOutExpo(t, b, c, d)
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
    static function easeOutInExpo(t, b, c, d)
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
            return (c / 2 * (-Math.pow(2, -10 * t) + 1) + b);
        } // end if
        return (c / 2 * (Math.pow(2, 10 * (t - 2)) + 1) + b);
    } // End of the function
    static function easeInElastic(t, b, c, d, a, p)
    {
        var _loc5;
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
            _loc5 = p / 4;
        }
        else
        {
            _loc5 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        t = t - 1;
        return (-a * Math.pow(2, 10 * (t)) * Math.sin((t * d - _loc5) * 6.283185E+000 / p) + b);
    } // End of the function
    static function easeOutElastic(t, b, c, d, a, p)
    {
        var _loc5;
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
            _loc5 = p / 4;
        }
        else
        {
            _loc5 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        return (a * Math.pow(2, -10 * t) * Math.sin((t * d - _loc5) * 6.283185E+000 / p) + c + b);
    } // End of the function
    static function easeInOutElastic(t, b, c, d, a, p)
    {
        var _loc5;
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
            _loc5 = p / 4;
        }
        else
        {
            _loc5 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        if (t < 1)
        {
            t = t - 1;
            return (-5.000000E-001 * (a * Math.pow(2, 10 * (t)) * Math.sin((t * d - _loc5) * 6.283185E+000 / p)) + b);
        } // end if
        t = t - 1;
        return (a * Math.pow(2, -10 * (t)) * Math.sin((t * d - _loc5) * 6.283185E+000 / p) * 5.000000E-001 + c + b);
    } // End of the function
    static function easeOutInElastic(t, b, c, d, a, p)
    {
        var _loc5;
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
            _loc5 = p / 4;
        }
        else
        {
            _loc5 = p / 6.283185E+000 * Math.asin(c / a);
        } // end else if
        if (t < 1)
        {
            return (5.000000E-001 * (a * Math.pow(2, -10 * t) * Math.sin((t * d - _loc5) * 6.283185E+000 / p)) + c / 2 + b);
        } // end if
        return (c / 2 + 5.000000E-001 * (a * Math.pow(2, 10 * (t - 2)) * Math.sin((t * d - _loc5) * 6.283185E+000 / p)) + b);
    } // End of the function
    static function easeInBack(t, b, c, d, s)
    {
        if (s == undefined)
        {
            s = 1.701580E+000;
        } // end if
        t = t / d;
        return (c * (t) * t * ((s + 1) * t - s) + b);
    } // End of the function
    static function easeOutBack(t, b, c, d, s)
    {
        if (s == undefined)
        {
            s = 1.701580E+000;
        } // end if
        t = t / d - 1;
        return (c * ((t) * t * ((s + 1) * t + s) + 1) + b);
    } // End of the function
    static function easeInOutBack(t, b, c, d, s)
    {
        if (s == undefined)
        {
            s = 1.701580E+000;
        } // end if
        t = t / (d / 2);
        if (t < 1)
        {
            s = s * 1.525000E+000;
            return (c / 2 * (t * t * ((s + 1) * t - s)) + b);
        } // end if
        t = t - 2;
        s = s * 1.525000E+000;
        return (c / 2 * ((t) * t * ((s + 1) * t + s) + 2) + b);
    } // End of the function
    static function easeOutInBack(t, b, c, d, s)
    {
        if (s == undefined)
        {
            s = 1.701580E+000;
        } // end if
        t = t / (d / 2);
        if (t < 1)
        {
            s = s * 1.525000E+000;
            return (c / 2 * (--t * t * ((s + 1) * t + s) + 1) + b);
        } // end if
        s = s * 1.525000E+000;
        return (c / 2 * (--t * t * ((s + 1) * t - s) + 1) + b);
    } // End of the function
    static function easeOutBounce(t, b, c, d)
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
    static function easeInBounce(t, b, c, d)
    {
        return (c - com.mosesSupposes.fuse.PennerEasing.easeOutBounce(d - t, 0, c, d) + b);
    } // End of the function
    static function easeInOutBounce(t, b, c, d)
    {
        if (t < d / 2)
        {
            return (com.mosesSupposes.fuse.PennerEasing.easeInBounce(t * 2, 0, c, d) * 5.000000E-001 + b);
        }
        else
        {
            return (com.mosesSupposes.fuse.PennerEasing.easeOutBounce(t * 2 - d, 0, c, d) * 5.000000E-001 + c * 5.000000E-001 + b);
        } // end else if
    } // End of the function
    static function easeOutInBounce(t, b, c, d)
    {
        if (t < d / 2)
        {
            return (com.mosesSupposes.fuse.PennerEasing.easeOutBounce(t * 2, 0, c, d) * 5.000000E-001 + b);
        } // end if
        return (com.mosesSupposes.fuse.PennerEasing.easeInBounce(t * 2 - d, 0, c, d) * 5.000000E-001 + c * 5.000000E-001 + b);
    } // End of the function
    static function easeInCubic(t, b, c, d)
    {
        t = t / d;
        return (c * (t) * t * t + b);
    } // End of the function
    static function easeOutCubic(t, b, c, d)
    {
        t = t / d - 1;
        return (c * ((t) * t * t + 1) + b);
    } // End of the function
    static function easeInOutCubic(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * t * t * t + b);
        } // end if
        t = t - 2;
        return (c / 2 * ((t) * t * t + 2) + b);
    } // End of the function
    static function easeOutInCubic(t, b, c, d)
    {
        t = t / (d / 2);
        return (c / 2 * (--t * t * t + 1) + b);
    } // End of the function
    static function easeInQuart(t, b, c, d)
    {
        t = t / d;
        return (c * (t) * t * t * t + b);
    } // End of the function
    static function easeOutQuart(t, b, c, d)
    {
        t = t / d - 1;
        return (-c * ((t) * t * t * t - 1) + b);
    } // End of the function
    static function easeInOutQuart(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * t * t * t * t + b);
        } // end if
        t = t - 2;
        return (-c / 2 * ((t) * t * t * t - 2) + b);
    } // End of the function
    static function easeOutInQuart(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (-c / 2 * (--t * t * t * t - 1) + b);
        } // end if
        return (c / 2 * (--t * t * t * t + 1) + b);
    } // End of the function
    static function easeInQuint(t, b, c, d)
    {
        t = t / d;
        return (c * (t) * t * t * t * t + b);
    } // End of the function
    static function easeOutQuint(t, b, c, d)
    {
        t = t / d - 1;
        return (c * ((t) * t * t * t * t + 1) + b);
    } // End of the function
    static function easeInOutQuint(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * t * t * t * t * t + b);
        } // end if
        t = t - 2;
        return (c / 2 * ((t) * t * t * t * t + 2) + b);
    } // End of the function
    static function easeOutInQuint(t, b, c, d)
    {
        t = t / (d / 2);
        return (c / 2 * (--t * t * t * t * t + 1) + b);
    } // End of the function
    static function easeInSine(t, b, c, d)
    {
        return (-c * Math.cos(t / d * 1.570796E+000) + c + b);
    } // End of the function
    static function easeOutSine(t, b, c, d)
    {
        return (c * Math.sin(t / d * 1.570796E+000) + b);
    } // End of the function
    static function easeInOutSine(t, b, c, d)
    {
        return (-c / 2 * (Math.cos(3.141593E+000 * t / d) - 1) + b);
    } // End of the function
    static function easeOutInSine(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * Math.sin(3.141593E+000 * t / 2) + b);
        } // end if
        return (-c / 2 * (Math.cos(3.141593E+000 * --t / 2) - 2) + b);
    } // End of the function
    static function easeInCirc(t, b, c, d)
    {
        t = t / d;
        return (-c * (Math.sqrt(1 - t * t) - 1) + b);
    } // End of the function
    static function easeOutCirc(t, b, c, d)
    {
        t = t / d - 1;
        return (c * Math.sqrt(1 - (t) * t) + b);
    } // End of the function
    static function easeInOutCirc(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (-c / 2 * (Math.sqrt(1 - t * t) - 1) + b);
        } // end if
        t = t - 2;
        return (c / 2 * (Math.sqrt(1 - (t) * t) + 1) + b);
    } // End of the function
    static function easeOutInCirc(t, b, c, d)
    {
        t = t / (d / 2);
        if (t < 1)
        {
            return (c / 2 * Math.sqrt(1 - --t * t) + b);
        } // end if
        return (c / 2 * (2 - Math.sqrt(1 - --t * t)) + b);
    } // End of the function
    static var registryKey = "pennerEasing";
} // End of Class
