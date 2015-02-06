package com.dEVELdRONE.GForce_Arena;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.Log;
import android.view.MotionEvent;

public class Arcade extends Universe{

	private static boolean changecolors, changing, change_num_particles;
	private GravityParticle sun[] = new GravityParticle[5];
	private static Thread colorgen;
	
	public Arcade(Context context) {
		super(context);
		changecolors = false;
		/*Also add to menu:
		 * tail length
		 * set colors
		 * filled or hallowed
		 */
		holder = getHolder();
		
		colorgen = new ColorGenerator();
		changing = false;
		
		drawer = new Thread(this);
		
		running = false;
		added = false;
		particle_color = Color.GREEN;
		//num_particles = 300;
		
		for(int a=0; a<5; a++)
			sun[a] = new GravityParticle(0, 0, GravityParticle.getGForce(), this);
	}
	
	public void setSunId(int sunIndex, int id){
		sun[sunIndex].setId(id);
	}
	
	public void setSunAdded(int i, boolean b){
		if(i<5)
			sun[i].setAdded(b);
	}
	
	public void setSunAddedById(int id, boolean b){
		try{
			getSunById(id).setAdded(b);
		}catch(Exception e){
			
		}
	}
	
	public void moveSun(int i, float x, float y){
		if(i<5)
			sun[i].setLocation(x, y);
	}
	
	public void rotateSuns(int removed, int suns, MotionEvent event){ //not done
		//switch all pointers past index 4 back 1
		if(suns>5){
			moveSun(4, event.getX(4), event.getY(4));
			setSunAdded(4, true);
			addGravityParticle(sun[4]);
			new Particle().move(4);
		}
	}
	
	public GravityParticle getSun(int i){
		if(i<5)
			return sun[i];
		else return null;
	}
	
	public GravityParticle getSunById(int id){
		for(int a=0; a<5; a++)
			if(sun[a].getId()==id)
				return sun[a];
		return null;
	}
	
	public static boolean isChangingColors(){
		return changecolors;
	}
	
	public static void setChangeColors(boolean b){
		changecolors = b;
	}
	
	public static boolean isChangingNumParticles(){
		return change_num_particles;
	}
	
	public static void setChangeNumParticles(boolean b){
		change_num_particles = b;
	}
	
	public void deactivateGravityParticle(int i){
		gravity.get(i).setAdded(false);
	}
	
	public void activateGravityParticle(int i){
		Particle.gravity.get(i).start();
	}
	
	//fix to have only 
	@Override
	public void run() {

		//** draws over what has been drawn (last drawn is drawn on top)
		Canvas canvas;
		Paint paint;
		int stardist = 0;
		boolean distup = true;
		
		while(running){
			if(!holder.getSurface().isValid())
				continue;
			
			if(!added){
				addParticles(num_particles);//50 for emulator
				added = true;
			}
			else if(change_num_particles){
				removeParticles();
				addParticles(num_particles);
				change_num_particles = false;
			}
			
			canvas = holder.lockCanvas();
			canvas.drawColor(Color.BLACK);
			
			//if(sun.isAdded())
			//	canvas.drawBitmap(ArcadeActivity.sun_pic, sun.getX()-ArcadeActivity.sun_pic.getWidth()/2, sun.getY()-ArcadeActivity.sun_pic.getHeight()/2, null);

			paint = new Paint();
			//keep alpha at 255
			if (changecolors)
				paint.setColor(Color.rgb(rgb[0], rgb[1], rgb[2]));
			else paint.setColor(particle_color);
			

			//Paint paint2 = new Paint();
			//paint2.setColor(Color.BLACK);
			
			float dpi = ArcadeActivity.getDPI();
			
			//draws the path
			for(Particle p : matter){
				p.addPath(new android.graphics.Point((int)p.getX(), (int)p.getY()));
				while(p.getPath().size()>tail_length) 
					p.removePath(0);
				if(particle_type.equals("metro") && p.getPath().size() > 0)
					canvas.drawLine(p.getX(), p.getY(), p.getPath().get(p.getPath().size()-1).x, p.getPath().get(p.getPath().size()-1).y, paint);
				for(int a=particle_type.equals("metro") ? 1 : 0; a<p.getPath().size(); a++)
					if(particle_type.equals("classic")){
						canvas.drawBitmap(ArcadeActivity.getParticle(), (float)p.getPath().get(a).x-dpi, (float)p.getPath().get(a).y-dpi, null);
					}
					else if(particle_type.equals("metro"))
						canvas.drawLine(p.getPath().get(a-1).x, p.getPath().get(a-1).y, p.getPath().get(a).x, p.getPath().get(a).y, paint);
			}
				
			if(particle_type.equals("star")){
				if(distup) stardist++;
				else stardist--;
				
				if(stardist>tail_length*4) distup = false;
				else if(stardist<0) distup = true;
			}
				
			for(Particle p : matter){
				if(particle_type.equals("classic"))
					//canvas.drawBitmap(ArcadeActivity.particle, (float)p.path.get(a).x, (float)p.path.get(a).y, null);
					canvas.drawOval(new RectF((float)p.getX()-dpi, (float)p.getY()-dpi, (float)p.getX()+dpi, (float)p.getY()+dpi), paint);
				else if(particle_type.equals("metro"))
					canvas.drawPoint(p.getX(), p.getY(), paint);
				else if(particle_type.equals("star")){
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)p.getX()-dpi, (float)p.getY()-dpi, null);
					
					//draw exploding
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)p.getX()-dpi+stardist, (float)p.getY()-dpi, null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)p.getX()-dpi-stardist, (float)p.getY()-dpi, null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)p.getX()-dpi, (float)p.getY()-dpi+stardist, null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)p.getX()-dpi, (float)p.getY()-dpi-stardist, null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)(p.getX()-dpi+(.707*stardist)/3), (float)(p.getY()-dpi+(.707*stardist)/3), null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)(p.getX()-dpi+(.707*stardist)/3), (float)(p.getY()-dpi-(.707*stardist)/3), null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)(p.getX()-dpi-(.707*stardist)/3), (float)(p.getY()-dpi+(.707*stardist)/3), null);
					canvas.drawBitmap(ArcadeActivity.getStar(), (float)(p.getX()-dpi-(.707*stardist)/3), (float)(p.getY()-dpi-(.707*stardist)/3), null);
				}
			}
			
			//paint.setColor(Color.RED);			
			//for(GravityParticle p : gravity) //adds gravity particle correctly
				//canvas.drawOval(new RectF((float)p.xloc, (float)p.yloc, (float)p.xloc+20, (float)p.yloc+20), paint);
			
			holder.unlockCanvasAndPost(canvas);
				
		}
	}
	
	@Override
	public void pause(){ //doesn't work at all!!... does now
		running = false;
		Particle.setMoving(false);
		changecolors = false;
		if(changing)
			while(true){
				try {
					colorgen.join();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
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
		colorgen = null;
		removeGravityParticles();
		for(int a=0; a<5; a++)
			sun[a].setAdded(false);
		Particle.stop();
	}
	
	@Override
	public void resume(){ //error in here **fixed
		running = true;

		if(changecolors && !changing){
			colorgen = new ColorGenerator();
			colorgen.start();
		}
		else if(!changecolors && changing){
			while(true){
				try {
					colorgen.join();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
			colorgen = null;
		}
		
		drawer = new Thread(this);
		drawer.start();
		
		new Particle().move();
	}

	public int[] rgb = new int[3];
	
	public class ColorGenerator extends Thread{
		
		public void run(){
			super.run();
			while(changecolors){
				changing = true;
				for(int s=0; s<3; s++){
					if(!changecolors) break;
					for(int w=0; w<3; w++)
						for(int a=100; a<256; a++){
							if(!changecolors) break;
							rgb[(w+s)%3]=a;
							try {
								sleep(30);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							if(!changecolors) break;
						}
					
					for(int w=0; w<3; w++)
						for(int a=254; a>=100; a--){
							if(!changecolors) break;
							rgb[(w+s)%3]=a;
							try {
								sleep(30);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
				}	
			}
			changing = false;
		}
	}

}
