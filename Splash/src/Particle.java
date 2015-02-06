package com.dEVELdRONE.GForce_Arena;
import java.util.ArrayList;

import android.content.SharedPreferences;
import android.graphics.Point;
import android.preference.PreferenceManager;
import android.util.Log;

public class Particle{
	
	public float xloc, yloc;
	protected int width, height;
	//this is the number of pixels to move per second
	public double xvel, yvel, gvel, ovel;
	private static Universe reference;
	public static ArrayList<Gravity> gravity;
	public static Gravity[] arena_gravity;
	private ArrayList<android.graphics.Point> path;
	//private static ArrayList<android.graphics.Point> occupied;
	private static Move mover;
	private static boolean moving, antigravity, lose_m, exclusion;
	private static String walls;
	
	public Particle(){}

	public Particle(float x, float y, Universe u){
		xloc = x;
		yloc = y;
		width = 5; 
		height = 5;
		xvel = 0;
		yvel = 0;
		ovel = 0;//ovel = Math.sqrt(xvel*xvel + yvel*yvel);
		reference = u;
		gvel = 100;
		gravity = new ArrayList<Gravity>();
		arena_gravity = new Gravity[5];
		path = new ArrayList<Point>();
		//occupied = new ArrayList<Point>();
		mover = new Move();
		moving = false;
	}
	
	public float getX(){
		return xloc;
	}

	public float getY(){
		return yloc;
	}
	
	public static boolean isMoving(){
		return moving;
	}
	
	public static void setMoving(boolean b){
		moving = b;
	}
	
	public void addPath(Point p){
		path.add(p);
	}
	
	public void removePath(int h){
		path.remove(h);
	}
	
	public ArrayList<android.graphics.Point> getPath(){
		return path;
	}
	
	public static void setAntiGravity(boolean b){
		antigravity = b;
	}
	
	public static void setWalls(String b){
		walls = b;
	}
	
	public static void setLoseM(boolean b){
		lose_m = b;
	}
	
	public static void setExclusion(boolean b){
		exclusion = b;
	}
	
	public void setReference(Universe u){
		reference = u;
	}
	
	public void setLocation(float x, float y){
		xloc = x;
		yloc = y;
	}
	
	public void setSize(int w, int h){
		width = w;
		height = h;
	}
	
	public void setVelocity(double x, double y){
		xvel = x;
		yvel = y;
	}
	
	public void move(){
		//Log.d("Particle", "gravity contains: "+gravity.size());
		if(!moving && mover!=null){
			mover.start();
			Log.d("Move", "Resume");
		}
		else if(!moving && mover==null){
			mover = new Move();
			mover.start();
			Log.d("Move", "Start");
		}
		for(Gravity g : gravity){
			if(!g.isRunning)
				g.start();//e here
			Log.d("Move", "Gravity Added");
		}
	}
	
	public void arenaMove(){
		//Log.d("Particle", "gravity contains: "+gravity.size());
		if(!moving && mover!=null){
			mover.start();
			Log.d("Move", "Resume");
		}
		else if(!moving && mover==null){
			mover = new Move();
			mover.start();
			Log.d("Move", "Start");
		}
		for(Gravity g : arena_gravity){
			if(!(g==null) && !g.isRunning)
				g.start();//e here
			Log.d("Move", "Gravity Added");
		}
	}
	
	public void move(int i){
		//Log.d("Particle", "gravity contains: "+gravity.size());
		if(!moving && mover!=null){
			mover.start();
			Log.d("Move", "Resume");
		}
		else if(!moving && mover==null){
			mover = new Move();
			mover.start();
			Log.d("Move", "Start");
		}
		/*for(Gravity g : gravity){
			if(!g.isRunning)
				g.start();//e here
			Log.d("Move", "Gravity Added");
		}*/
		gravity.get(i).start();
	}
	
	public void arenaMove(int i){
		//Log.d("Particle", "gravity contains: "+gravity.size());
		if(!moving && mover!=null){
			mover.start();
			Log.d("Move", "Resume");
		}
		else if(!moving && mover==null){
			mover = new Move();
			mover.start();
			Log.d("Move", "Start");
		}
		/*for(Gravity g : gravity){
			if(!g.isRunning)
				g.start();//e here
			Log.d("Move", "Gravity Added");
		}*/
		arena_gravity[i].start();
	}
	
	public static void stop(){
		moving = false;
		while(true){
			try {
				mover.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		}
		mover = null;
		gravity.clear();
	}
	
	public static void arenaStop(){
		moving = false;
		while(true){
			try {
				mover.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		}
		mover = null;
		arenaStopGravity();
	}
	
	public static void stopGravity(){
		gravity.clear();
	}
	
	public static void arenaStopGravity(){
		for(int a=0; a<5; a++)
			arena_gravity[a]=null;
	}
	
	public static void stopGravity(int i){
		while(true){
			try {
				gravity.get(i).join();//index out of bounds error here
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		}
		gravity.set(i, null);
		gravity.remove(i);
	}
	
	public static void arenaStopGravity(int i){
		if(i<5)
		while(true){
			try {
				arena_gravity[i].join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		}
		arena_gravity[i] = null;
	}
	
	public void addGravity(GravityParticle p){
		gravity.add(new Gravity(p));
		//Log.d("Particle", "gravity contains: "+gravity.size());//1
	}
	
	public void addArenaGravity(int i, GravityParticle p){
		arena_gravity[i] = new Gravity(p);
	}
	
	public void exclude(Particle p, Particle e){
		double tempxvel = p.xvel/2, tempyvel = p.yvel/2;
		
		p.xvel += e.xvel/2;
		p.yvel += e.xvel/2;
				
		e.xvel += tempxvel;
		e.yvel += tempyvel;
	}

	//Changes velocity of particle based on gravity
		public class Gravity extends Thread{
			
			private GravityParticle gParticle;
			public boolean isRunning;
			
			Gravity(GravityParticle p){
				gParticle = p;
			}
			
			public synchronized void run(){
				super.run();
				isRunning = true;
				Log.d("Gravity", "Started " + GravityParticle.getGForce());
				while(gParticle.isAdded()){
					for(Particle p : reference.getMatter()){
						double xdif = gParticle.getX() - p.xloc;
						double ydif = gParticle.getY() - p.yloc;
						double dist = Math.sqrt(xdif*xdif+ydif*ydif);
						
						if(antigravity){
							p.xvel -= xdif/dist*p.gvel/300 * GravityParticle.getGForce()/*gParticle.mass*/;
							p.yvel -= ydif/dist*p.gvel/300 * GravityParticle.getGForce();
						}
						else{
							p.xvel += xdif/dist*p.gvel/300 * GravityParticle.getGForce();
							p.yvel += ydif/dist*p.gvel/300 * GravityParticle.getGForce();
						}
						if(!gParticle.isAdded())
							break;
					}
					if(!gParticle.isAdded())
						break;
					try {
						sleep(5);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					
				}
				isRunning = false;
				Log.d("Gravity", "Finished");
			}
		}
		
		//moves particle based on velocity
		public class Move extends Thread{
			
			public synchronized void run(){
				super.run();
				moving = true;
				float dpi;
				int count;
				
				while(moving){
					count = -1;
					for(Particle p : reference.getMatter()){
						count++;
						p.xloc+=p.xvel/300;
						p.yloc+=p.yvel/300;
						
						if(exclusion){
							dpi = ArcadeActivity.getDPI();
							for(int a=0; a<count; a++){
								//hit right, left, up, down
								if((reference.getMatter().get(a).getX()-dpi<=p.getX()+dpi && reference.getMatter().get(a).getX()-dpi>=p.getX()+dpi) ||
										(reference.getMatter().get(a).getX()-dpi>=p.getX()+dpi && reference.getMatter().get(a).getX()-dpi<=p.getX()+dpi) ||
										(reference.getMatter().get(a).getY()-dpi<=p.getY()+dpi && reference.getMatter().get(a).getY()-dpi>=p.getY()+dpi) ||
										(reference.getMatter().get(a).getY()-dpi>=p.getY()+dpi && reference.getMatter().get(a).getY()-dpi<=p.getY()+dpi)){
									exclude(p, reference.getMatter().get(a));
									break;
								}
							}
						}
						
						//gradual slowing
						//creates homing affect on gravity particle 
						if(lose_m){
							p.xvel/=1.005;
							p.yvel/=1.005;
						}
						
						//bounces off the wall
						if(walls.equals("bounce")){
							if(p.xloc < 5 || p.xloc > reference.getWidth() - 5){
								p.xvel = -p.xvel;
								p.xloc = p.xloc < 5 ? 5 : reference.getWidth() - 5;
							}
							if(p.yloc < 5 || p.yloc > reference.getHeight() - 5){
								p.yvel = -p.yvel;
								p.yloc = p.yloc < 5 ? 5 : reference.getHeight() - 5;
							}
						}
						else if(walls.equals("loop")){
							if(p.xloc < 5 || p.xloc > reference.getWidth() - 5)
								p.xloc = p.xloc < 5 ? reference.getWidth() - 5 : 5;
							if(p.yloc < 5 || p.yloc > reference.getHeight() - 5)
								p.yloc = p.yloc < 5 ? reference.getHeight() - 5 : 5;
						}
							
						
					}
					
					try {
						sleep(5);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					
				}
				
			}
		}	
	
}
