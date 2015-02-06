class com.robertpenner.easing.Sine
{
    function Sine()
    {
    } // End of the function
    static function easeIn(t, b, c, d)
    {
        return (-c * Math.cos(t / d * 1.570796E+000) + c + b);
    } // End of the function
    static function easeOut(t, b, c, d)
    {
        return (c * Math.sin(t / d * 1.570796E+000) + b);
    } // End of the function
    static function easeInOut(t, b, c, d)
    {
        return (-c / 2 * (Math.cos(3.141593E+000 * t / d) - 1) + b);
    } // End of the function
} // End of Class
