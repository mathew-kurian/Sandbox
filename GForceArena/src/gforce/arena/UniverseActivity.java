package gforce.arena;

import android.app.Activity;
import android.content.Context;
import android.graphics.PixelFormat;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.text.Html;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.LinearLayout.LayoutParams;

import static gforce.arena.UniverseAVE.*;

public abstract class UniverseActivity extends Activity{
	public abstract int setLayoutId();
	public abstract void preCreate();
	public abstract void postCreate();
	private Toast tst;
	public LayoutInflater factory;
	public View lv;
	private SensorManager mSensorManager;
	private UniverseShakeListener mSensorListener;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		GFA = this;
		tst = new Toast(getBaseContext());
		factory = LayoutInflater.from(this);
		preCreate();
		mSensorListener = new UniverseShakeListener();
		mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
		mSensorManager.registerListener(mSensorListener,
				mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_UI);
		
		mSensorListener.setOnShakeListener(new UniverseShakeListener.OnShakeListener() {
			public void onShake() {
				UniverseVariables.GESTURE_SHAKE = true;
			}
			
		});		
		super.onCreate(savedInstanceState);
		setContentView(setLayoutId());
		postCreate();
	}
	public boolean onPrepareOptionsMenu(Menu menu){
		try{
			return GFU.onPrepareOptionsMenu(menu);
		}catch(Exception e){
			return false;
		}
	}
	public boolean onOptionsItemSelected(MenuItem item) {
		try{
			return GFU.onOptionsItemSelected(item);
		}catch(Exception e){
			return false;
		}
    }
	@Override
	protected void onStop() {
		mSensorManager.unregisterListener(mSensorListener);
		super.onStop();
	}
	@Override
	public void onBackPressed(){
		try{
			GFU.onBackPressed();
		}catch(Exception e){		}
	}
	public void onPause(){
		super.onPause();
		UniverseAVE.GFU.tickRunnable.pause();
		UniverseAVE.GFU.drawRunnable.pause();
		UniverseAVE.GFU.touchRunnable.pause();
	}
	protected void onDestroy() {
		super.onDestroy();
		try{
			unbindDrawables(findViewById(R.id.RelativeLayout1));
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
		try{
			UniverseAVE.GFU.tickRunnable.resume();
			UniverseAVE.GFU.drawRunnable.resume();
			UniverseAVE.GFU.touchRunnable.resume();
		}catch(Exception e){}
		mSensorManager.registerListener(mSensorListener,
				mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_UI);
	}
	public void onAttachedToWindow() {
	    super.onAttachedToWindow();
	    Window window = getWindow();
	    window.setFormat(PixelFormat.RGBA_8888);
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
		text.setText(Html.fromHtml(s));

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
}