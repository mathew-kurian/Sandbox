package com.dEVELdRONE.GForce_Arena;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

public class Universe extends SurfaceView implements Runnable{
	
	protected ArrayList<Particle> matter = new ArrayList<Particle>();
	public ArrayList<GravityParticle> gravity = new ArrayList<GravityParticle>();
	protected boolean running, added;
	protected static int particle_color;
	protected Thread drawer;
	protected SurfaceHolder holder;
	protected int num_particles, tail_length;
	//protected boolean circle_particles = true;
	protected String particle_type = "metro"; //"classic", "star"
	
	public Universe(Context context) {
		super(context);
		//put in menu
		/*Also add to menu:
		 * tail length
		 * set colors
		 * filled or hallowed
		 */
		holder = getHolder();
		
		drawer = new Thread(this);
		
		running = false;
		added = false;
		particle_color = Color.GREEN;
	}
	
	public ArrayList<Particle> getMatter(){
		return matter;
	}
	
	public GravityParticle getGravityParticle(int i){
		return gravity.get(i);
	}
	
	public void setParticleStyle(String style){
		particle_type = style;
	}
	
	public static void setParticleColor(int c){
		particle_color = c;
	}
	
	public void setNumParticles(int n){
		num_particles = n;
	}
	
	public int getNumParticles(){
		return num_particles;
	}
	
	public int getNumGravityParticles(){
		return gravity.size();
	}
	
	public void setTailLength(int l){
		tail_length = l;
	}
	
	public void addParticles(int h){
		for(int a=0; a<h; a++)
			addParticle((int)(Math.random()*(getWidth()-5)+10), (int)(Math.random()*(getHeight()-5)+10));
	}
	
	public void addParticle(int x, int y){
		matter.add(new Particle(x, y, this));
	}
	
	public void addParticle(Particle p){
		matter.add(p);
	}
	
	public void moveParticles(){
		//for(Particle p : matter)
			//p.move();
		new Particle().move();
	}
	
	public void removeParticles(){
		matter.clear();
	}
	
	public void removeGravityParticles(){
		for(GravityParticle p : gravity)
			p.setAdded(false);
		gravity.clear();
	}
	
	public void removeGravityParticle(GravityParticle gp){
		gp.setAdded(false);
		gravity.remove(gp);
	}
	
	public void removeGravityParticle(int i){
		gravity.get(i).setAdded(false);
		gravity.remove(i);
	}
	
	public void setGravityParticle(int i, GravityParticle gp){
		gravity.set(i, gp);
	}
	
	public void moveGravityParticle(GravityParticle p, float x, float y){
		if(p!=null)
			p.setLocation(x, y);
	}
	
	public void addGravityParticle(float x, float y){
		GravityParticle toadd = new GravityParticle(x, y, 10, this);
		gravity.add(toadd);
		//for(Particle p : matter)
			//p.addGravity(new GravityParticle(x, y, 10, this));
		new Particle().addGravity(toadd);
	}
	
	public void addGravityParticle(GravityParticle particle){
		gravity.add(particle);
		//for(Particle p : matter)
			//p.addGravity(particle);
		new Particle().addGravity(particle);
	}
	
	public void addMovingGravityParticle(float x, float y){
		GravityParticle toadd = new GravityParticle(x, y, 10, this);
		gravity.add(toadd);
		for(Particle p : matter)
			p.addGravity(toadd);
		matter.add(toadd);
	}
	
	public void pause(){ //doesn't work at all!!... does now
		running = false;
		Particle.setMoving(false);
		while(true){
			try {
				drawer.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		}
		drawer = null;
	}
	
	public void resume(){ //error in here **fixed
		running = true;
		
		drawer = new Thread(this);
		drawer.start();
		
	}
	
	public void run(){
		//** draws over what has been drawn (last drawn is drawn on top)
		Canvas canvas;
		Paint paint;
		while(running){
			if(!holder.getSurface().isValid())
				continue;
			
			canvas = holder.lockCanvas();
			canvas.drawColor(Color.BLACK);
			
			paint = new Paint();
			paint.setColor(particle_color);
			
			float dpi = ArcadeActivity.getDPI();
			
			for(Particle p : matter)
				canvas.drawOval(new RectF((float)p.getX()-dpi, (float)p.getY()-dpi, (float)p.getX()+dpi, (float)p.getY()+dpi), paint);
			
			holder.unlockCanvasAndPost(canvas);
				
		}
	}
	
}
	
