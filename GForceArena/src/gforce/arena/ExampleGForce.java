package gforce.arena;

import java.util.ArrayList;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.view.Gravity;
import android.view.MotionEvent;
import static gforce.arena.UniverseVariables.*;
import static gforce.arena.UniverseConstants.*;


/* ---DETAILS---
 *             ExampleGForce.java extends Universe.java
 * Engine:     Universe.java
 * InputClass: ExampleGForceState.java
 *             **Place the class that extends UniverseState.java between < > (i.e. <ExampleGForceState>)
 */

//Universe has algorithms in the back end that control Thread timings and delays to create maximum fps.
public class ExampleGForce extends Universe<ExampleGForceState>{
	public ExampleGForce(int surfaceID){
		//Here just keep the surfaceID section the same, and then pass in the class that extends UniverseState
		super(surfaceID, ExampleGForceState.class);		
	}
	@Override
	public void onTick(ExampleGForceState s) throws Exception {
		//This method is called over 40 times a minute and contains all the calculations during every state change
		
		//In my case, the particle locations are updated and much more.		
		for(int x = 0; x<s.PARTICLE_COUNT; x++){
			s.pt.get(x).update();
			s.pt.get(x).decrementVelocity();
			if(s.touched) s.pt.get(x).setVelocity(s.touchX,s.touchY);	
			if(s.AUTO)	s.pt.get(x).setVelocity((int)s.autoX,(int)s.autoY);	
		}
		
		s.count++;
		if(s.count==1000){
			s.count = 0;
			s.autoX = SCREEN_WIDTH*Math.random();
			s.autoY = SCREEN_HEIGHT*Math.random();
		}
		
		if(s.AUTO){
			if(s.auto_flower<500 || s.auto_flower>2000)	s.auto_flower_controller*=-1;
			s.auto_flower+=s.auto_flower_controller;
			
			if(s.auto_flower1<200 || s.auto_flower1>100000)	s.auto_flower_controller1*=-1;
			s.auto_flower1+=s.auto_flower_controller1;
			
			//Take note here: You can force the seek bar to move while the program is running. This looks very cool. To see in the application, enable auto generate
			//and look at the seek bar, one of them will be moving by itself.
			forceSeekBar((int)s.auto_flower, 0x8489);
			forceSeekBar((int)s.auto_flower1, 0x5423);
		}else
			s.auto_flower = 501;
		
		s.radarY+=0.5;
		if(s.radarY>SCREEN_HEIGHT+200) s.radarY = -50;
		
	}
	@Override
	public void onPrerender(ExampleGForceState s) throws Exception {
		//You can can do whatever you need to prepare the arena before startup
		
		//In my case, I have sent out a toast signal to GForceUniverse which will release the information to the Activity to show you a quick pop up
		//Toast: HTML font enabled		
		toast("<font color = \"red\"; size = 25><b>//WARMING UP</b></font>", 5);		
		
		//Developed the particles here
		for (int x = 0; x<s.MAX_PARTICLE_COUNT; x++)		s.pt.add(new Particle(SCREEN_WIDTH, SCREEN_HEIGHT, s));
		
		//With a Thread.sleep(...) all methods are paused except the onDraw(...) which will still develop the screen. This makes it possible for you to show
		//an instruction screen for a brief moment.
		Thread.sleep(2000);
	}
	@Override
	public void onDraw(ExampleGForceState s, Canvas c) throws Exception {
		//Almost 40 times a second, this method is called which will allow the state information to be converted to a drawable.
		//Paint directly onto the canvas here
		//Provided paints: PAINT and TEXT_PAINT
		//FYI: You can save the state of the canvas and restore it at your will.
		
		//In my case, the the particles are painted directly onto the screen.
		c.drawColor(Color.BLACK); //Clearing the canvas first
		PAINT.setColor(Color.MAGENTA);
		for(int x = 0; x<s.PARTICLE_COUNT; x++){
			c.drawCircle((int)s.pt.get(x).x, (int) s.pt.get(x).y, s.PARTICLE_RADIUS+1, PAINT);
			if(s.TAIL_LENGTH>5)	c.drawLine((int)s.pt.get(x).x, (int) s.pt.get(x).y, (int) s.pt.get(x).tailx, (int) s.pt.get(x).taily, PAINT);
		}
	}
	@Override
	public void onStop(ExampleGForceState s) throws Exception {
		//Under development
	}
	@Override
	public void onTouch(ExampleGForceState s, MotionEvent me) throws Exception{	
		//All touch inputs will call this method under specific environment stress.
		
		//In my case, the particles accelerate toward a finger sense
		if(me.getAction() == MotionEvent.ACTION_DOWN || me.getAction() == MotionEvent.ACTION_MOVE){
			s.touched = true;
			s.touchX = (int) me.getX();
			s.touchY = (int) me.getY();
		}else if (me.getAction()==MotionEvent.ACTION_UP){
			s.touched = false;
		}
	}
	@Override
	public void onCache(ExampleGForceState s) {
		s.radar = decodeResource(R.drawable.radar);
	}
	@Override
	public void onError(ExampleGForceState s, Exception e) {	
		//All errors should call this method
		//It is ideal to use UniverseLog to store the data. This can be later accessed via an html page.
		UniverseLog.d("Error", "Corruption detected");
	}
	@Override
	public void onPaneCreate(ExampleGForceState s) throws Exception {
		//Create a menu panel with ID: 0x123 with a option menu title "Options" during hidden and "Hide" when shown. 
		//You MUST place a "|" symbol separating the texts.
		//Font cannot be adjusted for menu titles due to limitation in Android
		createMenuPane(0x123, Color.TRANSPARENT, "Options|Hide");
		
		//Create a label with text "Live Update Properties" with ID: 0x123789 on menu panel with ID: 0x123 with CENTERED text
		createLabel(0x123789,"<b>Live Update Properties</b>", Gravity.CENTER, 0x123);
				
		//Similar method to create seek bars and check boxes
		//Font appearance can be adjusted via HTML code
		createSeekBar(50000,100000, 0x5423, "ACCELERATION", "Two lines to add and adjust properties. Set speed up rate.", 0x123);
		createSeekBar(1000,50000, 0x8423, "DECCELERATION_DIVIDER", "Live updating properties. Set slow down rate.", 0x123);
		createSeekBar(s.PARTICLE_COUNT, s.MAX_PARTICLE_COUNT, 0x8489, "PARTICLE_COUNT", "Live updating properties. Set from 0-4000.", 0x123);
		createSeekBar(s.PARTICLE_RADIUS,4, 0x842312, "PARTICLE_RADIUS", "Radius of particle (1-5)", 0x123);
		createSeekBar(s.TAIL_LENGTH,500, 0x84238, "TAIL_LENGTH", "Length of particle trail (0-500)", 0x123);
		
		//Another menu panel with its sub sections
		createMenuPane(0x125, Color.DKGRAY, "Extras|Hide");
		createLabel(0x123710,"<b>Live Update Properties</b>", Gravity.CENTER, 0x125);
		createCheckBox(true, 0x890, "ARENA_BOUNDARIES", "Screen edges act as boundaries of the particles to bounce of off.", 0x125);
		createCheckBox(false, 0x891, "GENERATED_VISUALS", "Self generated visuals can be set on/off.", 0x125);	
		
		createMenuPane(0x12854, Color.TRANSPARENT, "CPU|Hide");
		
		//Create a label with text "Live Update Properties" with ID: 0x123789 on menu panel with ID: 0x123 with CENTERED text
		createLabel(0x123789,"<b>Live Update Properties</b>", Gravity.CENTER, 0x12854);
		
		createCPUDetails(0x12854);
	}
	@Override
	public void onValueChange(ExampleGForceState s, int selection,  boolean check,
			int id) throws Exception {
		
		//Any change to the seek bar, etc will call this method which will provide the information made during that change
		//Do a switch command with the id corresponding to the seek bar id that you had provided in the onPanelCreate(...) method
		
		switch(id){
		case 0x8423: 	s.DECCELERATION = 1+((double)(selection))/10000000.0;; 	
						if(!s.AUTO)	toast("<font color = \"red\"; size = 25><b>//" + s.DECCELERATION +"</b></font>", 0);
						break;
		case 0x5423: 	s.ACCELERATION = ((double)(selection))/1000000.0; 	
						if(!s.AUTO)	toast("<font color = \"red\"; size = 25><b>//" + s.ACCELERATION +"</b></font>", 0);
						break;
		case 0x8489: 	s.PARTICLE_COUNT =selection;
						if(!s.AUTO)	toast("<font color = \"red\"; size = 25><b>//" + s.PARTICLE_COUNT +"</b></font>", 0);
						break;
		case 0x890: 	s.BOUNDARIES = check;
						if(check)	for(int x = 0; x<(s.PARTICLE_COUNT-selection); x++)	s.pt.get(x).resetBoundaries();	break;
		case 0x891: 	s.AUTO = check;						break;
		case 0x842312: 	s.PARTICLE_RADIUS = selection;		break;
		case 0x84238:   s.TAIL_LENGTH = selection;			break;
		}		
	}	
}
class ExampleGForceState extends UniverseState{	
	//Extend UniverseState and place all the variables here	
	ArrayList<Particle>pt = new ArrayList<Particle>();	
	int PARTICLE_COUNT = 1000;	int MAX_PARTICLE_COUNT = 4000;	int PARTICLE_RADIUS = 0;
	int touchX = 0;	int touchY = 0;
	boolean touched = false;
	Bitmap radar;
	double radarY = 0;
	boolean BOUNDARIES = true;
	boolean AUTO = false;
	int count = 0;
	double ACCELERATION = 0.01;
	double DECCELERATION = 1.001;
	double TRAIL_LENGTH = 20;
	int [] rbg = {(int) (Math.random()*255),(int) (Math.random()*255),(int) (Math.random()*255)};
	int TAIL_LENGTH = 0;
	double auto_flower = 501;
	double auto_flower_controller = 2;
	double auto_flower1 = 200;
	double auto_flower_controller1 = 20;
	double autoX = 0;
	double autoY = 0;
	public void onMultithreading(Thread touch, Thread tick, Thread surface) {
		//set each thread priority here. Nothing more otherwise the engine will refuse to run.
		touch.setPriority(Thread.MIN_PRIORITY);
		tick.setPriority(Thread.MAX_PRIORITY);
		surface.setPriority(Thread.MAX_PRIORITY);
	}
}
class Particle{
	//Algorithms for each particle can be found here	
	double x,y,velocityX,velocityY,velocity,propX,propY, width, height,tailx, taily = 0;
	Bitmap b;
	ExampleGForceState s;
	public Particle(int w, int h, ExampleGForceState _s){
		x =Math.random()*550;		y =Math.random()*960;
		width = w; 					height = h;		
		s = _s;
	}
	public void update(){
		x += velocityX;		y += velocityY;
		if(s.BOUNDARIES){
			if(x>width || x<0)  velocityX = velocityX*-1;			if(y>height || y<0)  velocityY = velocityY*-1;
		}
		velocity = Math.sqrt(Math.pow(velocityX, 2) + Math.pow(velocityX, 2));
		tailx = x+velocityX*s.TAIL_LENGTH;		taily = y+velocityY*s.TAIL_LENGTH;
	}
	public void resetBoundaries(){
		if(x>width)  	x = width;		if(x<0)  x = 0;
		if(y>height)  y = height;		if(y<0)  x = 0;
	}
	public void setVelocity(float touchX, float touchY){
		try{
			double offsetX = touchX - x;						double offsetY = touchY - y;
			double distance = Math.sqrt(Math.pow(offsetX,2) + Math.pow(offsetY, 2));
			propX = offsetX/distance;							propY = offsetY/distance;
			velocityX = velocityX + propX*s.ACCELERATION;			velocityY = velocityY + propY*s.ACCELERATION;
		}catch(Exception e){}
	}
	public void decrementVelocity(){
		velocityX/=s.DECCELERATION;
		velocityY/=s.DECCELERATION;
	}
}