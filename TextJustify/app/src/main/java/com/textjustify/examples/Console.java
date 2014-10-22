package com.textjustify.examples;

/**
 * Created by Mathew Kurian on 10/22/2014.
 */

@SuppressWarnings("unused")
public class Console {

    public static void log(String tag, String s){
        android.util.Log.d(tag, s);
    }
    public static void log(String tag, int s){
        android.util.Log.d(tag, s + "");
    }
    public static void log(String tag, long s){
        android.util.Log.d(tag, s + "");
    }
    public static void log(String tag, double s){
        android.util.Log.d(tag, s + "");
    }
    public static void log(String tag, float s){
        android.util.Log.d(tag, s + "");
    }


    public static void log(String s){
        android.util.Log.d("", s);
    }
    public static void log(int s){
        android.util.Log.d("", s + "");
    }
    public static void log(long s){
        android.util.Log.d("", s + "");
    }
    public static void log(double s){
        android.util.Log.d("", s + "");
    }
    public static void log(float s){
        android.util.Log.d("", s + "");
    }
}
