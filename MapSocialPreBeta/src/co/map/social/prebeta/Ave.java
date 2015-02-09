package co.map.social.prebeta;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.graphics.Typeface;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

/*
 * This is the new activity that you extend
 */
public class Ave {
	static Typeface MyriadPro = null;
	static Activity current = null;
	
	public static void applyMyriadProFont(Context c, View v) {
		if(MyriadPro==null)
			MyriadPro = Typeface.createFromAsset(c.getAssets(),"fonts/MyriadProRegular.otf");
		
		if(v instanceof TextView)	((TextView) v).setTypeface(MyriadPro);
		if(v instanceof Button)		((Button) v).setTypeface(MyriadPro);
		if(v instanceof EditText)	((EditText) v).setTypeface(MyriadPro);
		if(v instanceof CheckBox)	((CheckBox) v).setTypeface(MyriadPro);
	}
	
	public static float sp(int sp) {
	    float scaledDensity = current.getResources().getDisplayMetrics().scaledDensity;
	    return sp*scaledDensity;
	}
	public static float sp(float sp){
		float scaledDensity = current.getResources().getDisplayMetrics().scaledDensity;
	    return sp*scaledDensity;
	}
	public static float dp(int dp){
		return dp;
	}
	public static int getScreenHeight(){
		WindowManager wm = (WindowManager) current.getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
		Display display = wm.getDefaultDisplay();
		return display.getHeight();
	}
	public static int getScreenWidth(){
		WindowManager wm = (WindowManager) current.getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
		Display display = wm.getDefaultDisplay();
		return display.getWidth();
	}
}