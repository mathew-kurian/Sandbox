package com.dEVELdRONE.GForce_Arena;

import com.google.ads.*;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

public class Startup extends Activity implements OnClickListener{

	private static boolean back_clicked;
	
	public static boolean backClicked(){
		return back_clicked;
	}
	
	public static void setBackClicked(boolean b){
		back_clicked = b;
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		back_clicked = false;
		
		//enables full screen with no title
      	requestWindowFeature(Window.FEATURE_NO_TITLE);
      	getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		setContentView(R.layout.startup);
		
		SharedPreferences getPrefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());

		try{
			Preferences.num_particles = Integer.parseInt(getPrefs.getString("num_particles_text", "250"));
		}catch(Exception e){
			Preferences.num_particles = 1;
		}
		
		try{
			Preferences.tails = Integer.parseInt(getPrefs.getString("tails_text", "3"));
		}catch(Exception e){
			Preferences.tails = 1;
		}
		
		try{
			Preferences.gforce = Float.parseFloat(getPrefs.getString("gforce_text", "5"));
		}catch(Exception e){
			Preferences.gforce = 1;
		}
		
		//Start button starts ArcadeActivity
		//Preference button starts Preferences
		Button start = (Button) findViewById (R.id.bStart);
		Button pref = (Button) findViewById (R.id.bPref);
		Button rateit = (Button) findViewById (R.id.bRateIt);
        
		rateit.setOnClickListener(this);
		start.setOnClickListener(this);
		pref.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.bStart:
			Intent ma = new Intent("com.dEVELdRONE.GForce_Arena.ARCADEACTIVITY");
			startActivity(ma);
			break;
			
		case R.id.bPref:
			Intent pr = new Intent("com.dEVELdRONE.GForce_Arena.PREFERENCES");
			startActivity(pr);
			break;
			
		case R.id.bRateIt:
			Intent intent = new Intent(Intent.ACTION_VIEW);
			intent.setData(Uri.parse("market://details?id=com.dEVELdRONE.GForce_Arena"));
			startActivity(intent);
			break;
		}
		
	}

	@Override
	public void onBackPressed() {
		back_clicked = true;
		super.onBackPressed();
	}

	AdView ad;
	
	@Override
	protected void onResume() {
		ad = (AdView) findViewById(R.id.adView);
		ad.loadAd(new AdRequest());
		super.onResume();
		
		//AdRequest request = new AdRequest();

		//request.addTestDevice(AdRequest.TEST_EMULATOR);
		//request.addTestDevice("0A3C01E10B01E01C");
		
		//reloads add
	}

	@Override
	protected void onDestroy() {
		ad.destroy();
		super.onDestroy();
	}
	
}
