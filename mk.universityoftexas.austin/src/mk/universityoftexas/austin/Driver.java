package mk.universityoftexas.austin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.os.Process;
import android.os.Vibrator;
import android.preference.PreferenceManager;
import android.content.SharedPreferences;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.view.WindowManager;
import android.provider.Settings;

public abstract class Driver extends Activity{	

	public static final int RESIZE_MARGIN_TOP = 1;
	public static final int RESIZE_MARGIN_RIGHT = 5;
	public static final int RESIZE_MARGIN_LEFT = 2;

	private SensorManager mSensorManager;
	private ShakeEventListener mSensorListener;

	private Toast tst;

	public LayoutInflater factory;

	public View lv;

	int animationCounter = 0;

	SharedPreferences SharedPreferences(){
		return PreferenceManager.getDefaultSharedPreferences(this);		
	}
	public void reApplyBrightness(){
		if(AVE.lightOn)
			brightness(1.0f);
		else
			brightness(0.050f);
	}
	public boolean setCurrent(){
		return true;
	}
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		tst = new Toast(getBaseContext());
		factory = LayoutInflater.from(this);

		if (setCurrent()) AVE.CURRENT = this;
		AVE.createLighting(this);
		AVE.setHighlightBitmaps(this);

		getWindow().setFormat(PixelFormat.RGBX_8888);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_DITHER);		

		reApplyBrightness();		

		mSensorListener = new ShakeEventListener();
		mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
		mSensorManager.registerListener(mSensorListener,
				mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_UI);


		mSensorListener.setOnShakeListener(new ShakeEventListener.OnShakeListener() {
			public void onShake() {
				if(AVE.lightOn){
					AVE.lightOn = false;
					toastImage(R.drawable.light_bulb_off, 0);
					Log.d("Light", "Off", "yellow");
				}
				else{
					AVE.lightOn = true;
					toastImage(R.drawable.light_bulb_on, 0);
					Log.d("Light", "On", "yellow");
				}	
				reApplyBrightness();
				Vibrator v = (Vibrator) AVE.CURRENT.getSystemService(Context.VIBRATOR_SERVICE);
				v.vibrate(100); 	
				try{
					((LightingLayoutRelative) AVE.CURRENT.findViewById(R.id.log)).post(new Runnable(){
						public void run() {
							((LightingLayoutRelative) AVE.CURRENT.findViewById(R.id.log)).invalidate();
						}	
					});					
				}catch(Exception e){}
				try{
					((LightingLayoutRelative) AVE.MAIN.findViewById(R.id.log)).post(new Runnable(){
						public void run() {
							((LightingLayoutRelative) AVE.MAIN.findViewById(R.id.log)).invalidate();
						}	
					});				
				}catch(Exception e){}
			}			
		});

		Log.d("Driver", "Attempting to create " + toString());		

		preAction();
		Process.setThreadPriority(-20);
		Process.setThreadPriority(Process.myTid(), -20);

		Log.d("Priority", "Set to " + Process.getThreadPriority(Process.myTid()) + " (19: lowest; -20: highest)", "Yellow");
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(setLayout()); 
		adjustForScreen(); 
		setWindowAnimation();        
		applyLogListener();
		modAVE();
		applyFont();
		showInstructions();  
		try {
			if(setProgressMAX()==0){
				((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(View.INVISIBLE);
			}else if(setProgressMAX()>0){
				((OverlayProgressBar) findViewById(R.id.progress)).setMax(setProgressMAX());
				((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(View.VISIBLE);
			}else if(setProgressMAX()==-1){
				setProgressINDETERMINATE(true);
				((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(View.INVISIBLE);
			}
		}catch(Exception npe){}
		action();

	}
	void toast(String s, int length){
		toastImageText(s, -50, length);
	}
	void toastImage(int drawable, int length){
		toastImageText("", drawable, length);
	}
	void toastImageText(String s, int drawable, int length){		
		LinearLayout toastLayout = new LinearLayout(getBaseContext());		
		toastLayout.setBackgroundResource(R.drawable.toast_bg);
		toastLayout.setOrientation(LinearLayout.HORIZONTAL);
		toastLayout.setPadding(25, 25, 25, 25);

		ImageView image = new ImageView(getBaseContext());
		TextView text = new TextView(getBaseContext());
		text.setGravity(Gravity.CENTER);

		LayoutParams lm = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		lm.gravity = Gravity.CENTER;

		try{	image.setImageResource(drawable);	}catch(Exception e){}
		text.setText(s);

		text.setLayoutParams(lm);
		image.setLayoutParams(lm);

		text.setPadding(6, 6, 6, 6);
		image.setPadding(6, 6, 6, 6);

		if(drawable!= -50) toastLayout.addView(image);		
		if(s!= "") toastLayout.addView(text);

		tst.setView(toastLayout);
		tst.setDuration(length <= 0 ? Toast.LENGTH_SHORT :Toast.LENGTH_LONG);
		tst.show();
	}
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d("Driver", "Instance of " + toString() + " finished. Resources freed.");
		try{
			unbindDrawables(findViewById(R.id.log));
		}catch(Exception npe){}
		System.gc();
	}
	private void unbindDrawables(View view) {
		if (view.getBackground() != null) {
			view.getBackground().setCallback(null);
		}
		if (view instanceof ViewGroup) {
			for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
				unbindDrawables(((ViewGroup) view).getChildAt(i));
			}
			((ViewGroup) view).removeAllViews();
		}
	}
	@Override
	protected void onResume() {
		super.onResume();
		AVE.CURRENT = this;
		mSensorManager.registerListener(mSensorListener,
				mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_UI);
		reApplyBrightness();
	}
	public abstract int[] toAnimate();
	public void defaultAnimationEngine(int post){
		AnimationEngine ae = new AnimationEngine(this, toAnimate(), animationTypes());
		ae.startAnimation(post);
	}
	public abstract int[] animationTypes();
	@Override
	protected void onStop() {
		mSensorManager.unregisterListener(mSensorListener);
		super.onStop();
	}
	public void brightness(float f){
		int brightnessMode;
		try {
			brightnessMode = Settings.System.getInt(getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE);
			if(AVE.lightDefaultCheck == false) AVE.lightDefaultMode = brightnessMode;
			if (brightnessMode == Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC) {
				Settings.System.putInt(getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE, Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);
			}

			WindowManager.LayoutParams layoutParams = getWindow().getAttributes();
			if(AVE.lightDefaultCheck == false) AVE.lightDefaultBrightness = layoutParams.screenBrightness;
			layoutParams.screenBrightness = f; // set 50% brightness
			getWindow().setAttributes(layoutParams);
		} catch (Exception e) {
			e.printStackTrace();
		}		
		AVE.lightDefaultCheck = true;
	}
	public void resetBrightness(){	
		if(AVE.lightDefaultMode == Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC)
			Settings.System.putInt(getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE, Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC);
		else		
			brightness(AVE.lightDefaultBrightness);
		AVE.lightDefaultCheck = false;
	}
	public void applyLogListener(){
		OnLongClickListener olcl = new OnLongClickListener(){
			public boolean onLongClick(View v) {
				startActivity(LogView.class);	
				return true;
			}
		};		
		try{
			((ViewGroup) this.findViewById(R.id.log)).setLongClickable(true);
			((ViewGroup) this.findViewById(R.id.log)).setOnLongClickListener(olcl);			
		}catch(Exception npe){};
	}
	public void fontPastel(View v){
		AVE.applyPastelFont(this, v);
	}
	public void fontNewspaper(View v){
		AVE.applyNewsFont(this, v);
	}
	public void fontPastel(int view){
		AVE.applyPastelFont(this, findViewById(view));
	}
	public void fontNewspaper(int view){
		AVE.applyNewsFont(this, findViewById(view));
	}
	public void setWindowAnimation(){
		getWindow().setWindowAnimations(android.R.style.Animation_Toast);
	}
	public void setProgressVISIBILITY(int v){		
		try{
			((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(v);	
			((OverlayProgressBar) findViewById(R.id.progress)).invalidate();		
		}catch(Exception npe){}
	}
	public void adjustForScreen(){
		resizeLayout(R.id.container, RESIZE_MARGIN_TOP);
	}
	public void resizeLayout(int layout, int margin){
		try{
			LinearLayout.LayoutParams a = (LinearLayout.LayoutParams) ((ViewGroup) this.findViewById(layout)).getLayoutParams();
			switch(margin){
			case RESIZE_MARGIN_TOP:
				a.topMargin = AVE.METRICS.heightPixels > 800 ? a.topMargin + (AVE.METRICS.heightPixels - 800)/4 : a.topMargin;
				break;
			case RESIZE_MARGIN_RIGHT:
				a.rightMargin = AVE.METRICS.widthPixels > 480 ? a.rightMargin - (AVE.METRICS.widthPixels - 480)/2 : a.rightMargin;
				break;
			case RESIZE_MARGIN_LEFT:
				a.leftMargin = AVE.METRICS.widthPixels > 480 ? a.leftMargin + (AVE.METRICS.widthPixels - 480)/2 : a.leftMargin;
				break;
			}
			((ViewGroup) this.findViewById(layout)).setLayoutParams(a);
			((ViewGroup) this.findViewById(layout)).invalidate();

		}catch(ClassCastException cce){
			RelativeLayout.LayoutParams a = (RelativeLayout.LayoutParams) ((ViewGroup) this.findViewById(layout)).getLayoutParams();
			switch(margin){
			case RESIZE_MARGIN_TOP:
				a.topMargin = AVE.METRICS.heightPixels > 800 ? a.topMargin + (AVE.METRICS.heightPixels - 800)/2 : a.topMargin;
				break;
			case RESIZE_MARGIN_RIGHT:
				a.rightMargin = AVE.METRICS.widthPixels > 480 ? a.rightMargin - (AVE.METRICS.widthPixels - 480)/2 : a.rightMargin;
				break;
			case RESIZE_MARGIN_LEFT:
				a.leftMargin = AVE.METRICS.widthPixels > 480 ? a.leftMargin + (AVE.METRICS.widthPixels - 480)/2 : a.leftMargin;
				break;
			}
			((ViewGroup) this.findViewById(layout)).setLayoutParams(a);
			((ViewGroup) this.findViewById(layout)).invalidate();
		}catch(Exception npe){}
	}
	public void setProgressINDETERMINATE (boolean a)throws NullPointerException{
		try{
			((OverlayProgressBar) this.findViewById(R.id.progress)).setIndeterminate(a);  		
		}catch(NullPointerException npe){}
	}
	public String getPreferenceString(String id){
		return PreferenceManager.getDefaultSharedPreferences(this).getString(id, "empty");
	}
	public void setProgressINT(final int x){
		try{
			((OverlayProgressBar) findViewById(R.id.progress)).setProgress(x);

			if(x >= setProgressMAX())
				((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(View.INVISIBLE);	            	
			else
				((OverlayProgressBar) findViewById(R.id.progress)).setVisibility(View.VISIBLE);	
		}catch(NullPointerException npe){}

	}
	public void setProgressRESET(){
		setProgressVISIBILITY(View.VISIBLE);
		setProgressINT(0);		
	}
	public int getProgressINT(){
		try{
			return ((ProgressBar) findViewById(R.id.progress)).getProgress();    		
		}catch(NullPointerException npe){}
		return 0;
	}
	public void setProgressINCREMENT(int x){
		setProgressINT(getProgressINT()+x);
	}
	public abstract int setLayout();
	public abstract void preAction();
	public abstract void action();
	public abstract void modAVE();
	public abstract int setProgressMAX();	
	public abstract void applyFont();    
	public abstract void showInstructions();    
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		if(this instanceof Main || this instanceof Entrance)
			resetBrightness();		
		finish();
		System.gc();
	}
	public void showBrowser(String url){
		Intent i = new Intent(Intent.ACTION_VIEW);
		i.setData(Uri.parse(url));
		startActivity(i);
	}
	public void startActivity(Class<?>n){
		Intent i = new Intent(this, n);
		i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
		super.startActivity(i);	
	}
	public boolean isOnline() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo netInfo = cm.getActiveNetworkInfo();
		if (netInfo != null && netInfo.isConnectedOrConnecting()) {
			return true;
		}
		return false;
	}	
}