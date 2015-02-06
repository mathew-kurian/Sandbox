package com.dEVELdRONE.GForce_Arena;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

public class Splash extends Activity {

	private static boolean done = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//enables full screen with no title
      	requestWindowFeature(Window.FEATURE_NO_TITLE);
      	getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
      	
		setContentView(R.layout.logo);
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		if(!done){
			done = true;
			Thread timer = new Thread(){
				public void run(){
					try {
						sleep(2000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}finally{
						Intent start = new Intent("com.dEVELdRONE.GForce_Arena.STARTUP");
						startActivity(start);
					}
				}
			};
			timer.start();
		}
		else if(Startup.backClicked()){
			Startup.setBackClicked(false);
			finish();
		}
		else{
			Intent start = new Intent("com.dEVELdRONE.GForce_Arena.STARTUP");
			startActivity(start);
		}
	}

	@Override
	public void onBackPressed() {
		finish();
		super.onBackPressed();
	}

	/*@Override
	protected void onPause() {
		super.onPause();
		done=true;
	}*/
	
	

}
