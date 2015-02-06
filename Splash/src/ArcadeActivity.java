package com.dEVELdRONE.GForce_Arena;
//Current Version:
//v7, v2.0.0, finalized
/*
 * what's new:
 * v2
 * default settings visible
 * fixed some slowness associated with large numbers of particles, still working on it
 * 
 * v7
 * MULTITOUCH IS HERE!!!
 * Two knew particle types:
 * Metro & Star Dust
 * Increased maximum number of particles and max GForce
 * 
 */

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnTouchListener;

//low density buttons still same size as med density
/*TODO: 
 * movement w/ accelerometer
 * add diff affects w/ diff multiples of fingers
 * create a Dark Matter particle type
 */

public class ArcadeActivity extends Activity implements OnTouchListener{
    /** Called when the activity is first created. */
	
	private Arcade ours;
	private static Bitmap particle, star;
	private static float dpi;
	//private static ArrayList<GravityParticle> gravity = new ArrayList<GravityParticle>();
	//private static GravityParticle[] gravity = new GravityParticle[5];
	public static boolean multitouch = true;
    
	public static float getDPI(){
		return dpi;
	}
	
	public static Bitmap getParticle(){
		return particle;
	}
	
	public static Bitmap getStar(){
		return star;
	}
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
      //enables full screen with no title
      	requestWindowFeature(Window.FEATURE_NO_TITLE);
      	getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
      	      	
      	//finds size of tail based on screen density
      	DisplayMetrics metrics = new DisplayMetrics();
      	getWindowManager().getDefaultDisplay().getMetrics(metrics);
      	switch(metrics.densityDpi){
      	     case DisplayMetrics.DENSITY_LOW:
      	    	 dpi = 3;
      	                break;
      	     case DisplayMetrics.DENSITY_MEDIUM:
      	    	 dpi = 4;
      	                 break;
      	     case DisplayMetrics.DENSITY_HIGH:
      	    	 dpi = 6;
      	                 break;
      	}
      	
        ours = new Arcade(this);
        ours.setOnTouchListener(this);
		
        setContentView(ours);
        
        star = BitmapFactory.decodeResource(getResources(), R.drawable.star_particle);
    }

	
	//have dual touch remove
	@Override
	public boolean onTouch(View v, MotionEvent event) {
		if(multitouch){
			//takes time to release gravity particle, will speed up if quickly tapped several times
			int action = event.getAction();
			int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK) 
	        >> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
	        int pointerId = event.getPointerId(pointerIndex); 
	        
			//make gforce be split between gravity particles 
	        //e.g. w/ 2 pointers, have gforce = gforce / 2;
	        
	        if(event.getPointerCount()>1)
	        	Particle.setLoseM(false);
	        else Particle.setLoseM(true);
			
	        switch(action & MotionEvent.ACTION_MASK){
			case MotionEvent.ACTION_DOWN: 
				Log.d("Down", pointerIndex + " " + ours.getNumGravityParticles());
				if(pointerId<5){
					//ours.addGravityParticle(ours.getSun(pointerIndex));
					new Particle().addArenaGravity(pointerId, ours.getSun(pointerId));
					ours.setSunAdded(pointerId, true);
					ours.moveSun(pointerId, event.getX(pointerIndex), event.getY(pointerIndex));
					//ours.setSunId(pointerIndex, pointerId);
					new Particle().arenaMove(); 
				}
				break;
				
			case MotionEvent.ACTION_UP:
				Log.d("Up", pointerIndex + " " + ours.getNumGravityParticles());
				if(pointerId<5){
					//ours.removeGravityParticle(pointerIndex);
					ours.setSunAdded(pointerId, false);
					Particle.arenaStopGravity(pointerId);
				}
				
				ours.rotateSuns(pointerIndex, event.getPointerCount(), event);
				
				//pointerCount is what it was b4 the action
				break;
				
			case MotionEvent.ACTION_MOVE:
				for(int a=0; a<event.getPointerCount(); a++){
					try{
						ours.moveSun(event.getPointerId(a), event.getX(a), event.getY(a));
						Log.d("Move", a+"");
					}catch(Exception e){
						//move stuff back
						//Log.d("Move Error", event.getPointerCount()+" "+pointerIndex);
					}
				}
				//Log.d("Move", event.getPointerCount()+"");
				break;
				
			case MotionEvent.ACTION_POINTER_DOWN: 
				//int open = -1;
				if(pointerId<5){
					/*for(int a=0; a<5; a++)
						if(!ours.getSun(a).isAdded()){
							open = a;
							break;
						}*/
					//ours.addGravityParticle(ours.getSun(pointerIndex));
					new Particle().addArenaGravity(pointerId, ours.getSun(pointerId));
					ours.setSunAdded(pointerId, true);
					ours.moveSun(pointerId, event.getX(pointerIndex), event.getY(pointerIndex));
					//ours.setSunId(pointerId, pointerId);
					new Particle().arenaMove(pointerId);
				}
				Log.d("P_Down", pointerIndex +"");
				break;
				
			case MotionEvent.ACTION_POINTER_UP: 
				Log.d("P_Up", pointerIndex + " " + pointerIndex);
				if(pointerId<5){
				    //ours.removeGravityParticle(pointerIndex);
					ours.setSunAdded(pointerId, false);
					Particle.arenaStopGravity(pointerId);
				}
				
				break;	
				
			}
			
			return true;
		}
		else{
			ours.moveSun(0, event.getX(), event.getY());
			
			switch(event.getAction()){
			case MotionEvent.ACTION_DOWN:
				ours.addGravityParticle(ours.getSun(0));
				//ours.addGravityParticle(new GravityParticle(event.getX(), event.getY(), GravityParticle.gforce, ours));
				//Log.d("ArcadeActivity", "Particle.gravity contains: "+Particle.gravity.size()); //1
				ours.setSunAdded(0, true);
				new Particle().move(); 
				break;
				
			case MotionEvent.ACTION_UP:
				ours.removeGravityParticle(0);
				Particle.stopGravity(0);
				ours.setSunAdded(0, false);
				break;
			}
			
			return true;
		}
	}

	@Override
	protected void onPause() {
		super.onPause();
		ours.pause();
	}

	@Override
	protected void onResume() {
		super.onResume();
		
		//sets up all preferences
		SharedPreferences getPrefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
		String values = getPrefs.getString("color_select", "G");
		
		Arcade.setChangeColors(false);
		if(values.equals("G")){
			Universe.setParticleColor(Color.GREEN);
		}
		else if(values.equals("B")){
			Universe.setParticleColor(Color.BLUE);
		}
		else if(values.equals("R")){
			Universe.setParticleColor(Color.RED);
		}
		else if(values.equals("Y")){
			Universe.setParticleColor(Color.YELLOW);
		}
		else if(values.equals("C")){
			Arcade.setChangeColors(true);
		}
        
		String tail_values = getPrefs.getString("tail_select", "G");
		if(tail_values.equals("G")){
			particle = BitmapFactory.decodeResource(getResources(), R.drawable.particleg);
		}
		else if(tail_values.equals("B")){
			particle = BitmapFactory.decodeResource(getResources(), R.drawable.particleb);
		}
		else if(tail_values.equals("R")){
			particle = BitmapFactory.decodeResource(getResources(), R.drawable.particler);
		}
		else if(tail_values.equals("Y")){
			particle = BitmapFactory.decodeResource(getResources(), R.drawable.particley);
		}
		
		if(ours.getNumParticles() != Preferences.num_particles){
			ours.setNumParticles(Preferences.num_particles);
			Arcade.setChangeNumParticles(true);
		}
		
		ours.setParticleStyle(getPrefs.getString("style_select", "classic"));
		
		ours.setTailLength(Preferences.tails);
		
		GravityParticle.setGForce(Preferences.gforce*50);
		
		Particle.setAntiGravity(getPrefs.getBoolean("anti", false));
		Particle.setWalls(getPrefs.getString("wall_select", "bounce"));
		//Particle.setLoseM(getPrefs.getBoolean("momentum", true));
		Particle.setExclusion(false);
		//Particle.setExclusion(getPrefs.getBoolean("exclude", false));
		//multitouch = getPrefs.getBoolean("multitouch", false);
		//Log.d("Integer", getPrefs.getString("num_particles_text", "None"));
		
		ours.resume();
	}
	
	//when the actual menu button on the phone is clicked (while the menu we made is opened)
	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		// TODO Auto-generated method stub
		super.onCreateOptionsMenu(menu);
		
		//brings up menu bar
		MenuInflater blowUp = getMenuInflater();
		blowUp.inflate(R.menu.selection_menu, menu);
		
		return true;
	}

		
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// TODO Auto-generated method stub
		super.onOptionsItemSelected(item);
			
		switch(item.getItemId()){
				
		case R.id.preferences:
			Intent pr = new Intent("com.dEVELdRONE.GForce_Arena.PREFERENCES");
			startActivity(pr);
			break;
				
		case R.id.menu_rate_it:
			Intent intent = new Intent(Intent.ACTION_VIEW);
			intent.setData(Uri.parse("market://details?id=com.dEVELdRONE.GForce_Arena"));
			startActivity(intent);
			break;
			
		/*case R.id.menu_rotating:
			Intent spin = new Intent("com.dEVELdRONE.GForce_Arena.SPINNINGSTUFF");
			startActivity(spin);
			break;*/
				
		default: return false;
		}
			
		return true;
	}
    
}