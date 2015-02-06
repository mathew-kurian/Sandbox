package gforce.arena;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.Paint.Style;
import android.graphics.RectF;
import android.view.MotionEvent;
import android.widget.Toast;

import static gforce.arena.UniverseVariables.*;

public class ExampleWallpaper extends Universe<ExampleLevelState>{

	/*
	 * DONT USE Log.d(string tag, string message) anymore 
	 * USE UniverseLog.d(string tag, string message, string color)
	 * OR UniverseLog.d(string tag, string message)
	 * 
	 * THIS WILL CREATE AN HTML PAGE FOR LOGS THAT IS EASY TO VIEW DURING THE GAME FOR DEBUGGING
	 * 
	 */	

	public ExampleWallpaper(int surfaceID) {
		super(surfaceID, ExampleLevelState.class);
	}
	@Override
	public void onTick(ExampleLevelState s) throws Exception {	
		incrementBitmapEntityLocation(s.sun, 0.00006f, -0.0001f);

		for(int x = 0; x<s.clouds.length; x++){
			if(s.clouds[x].x > SCREEN_WIDTH)
				s.clouds[x].x = -SCREEN_WIDTH;
			s.clouds[x].x = s.clouds[x].x + 0.00001f;
		}
		
		s.hue += 0.0001;
		
		s.cm = adjustHue((int)(s.hue%360));
	}
	@Override
	public void onPrerender(ExampleLevelState s) throws Exception {		
		s.bgX = SCREEN_WIDTH/2;
		s.bgY = SCREEN_HEIGHT/2;

		s.sun.setLocation(20, SCREEN_HEIGHT-50);

		Thread.sleep(5000);
	}
	@Override
	public void onDraw(ExampleLevelState s, Canvas c) throws Exception {
		
		PAINT.setColorFilter(s.cm);
		drawBitmapEntity(s.bg,PAINT);
		PAINT.setColorFilter(null);
		drawBitmapEntity(s.sun, null);

		for(int x = 0; x<s.clouds.length; x++)	c.drawBitmap(s.clouds[x].cloud, (int) s.clouds[x].x, (int) s.clouds[x].y, null);		

		PAINT.setColor(Color.argb(100, 0, 0, 0)); 
		PAINT.setTextSize(20); 
		PAINT.setStyle(Style.FILL);
		c.drawRoundRect(new RectF(10,10,120,55), 5, 5, PAINT);
		PAINT.setStyle(Style.STROKE);
		PAINT.setStrokeWidth(2f);
		PAINT.setColor(Color.WHITE); 
		c.drawRoundRect(new RectF(10,10,120,55), 5, 5, PAINT);
		PAINT.setStyle(Style.FILL_AND_STROKE);
		c.drawText("FPS: " + Double.toString(INSTANTANEOUS_FRAMERATE), 20, 40, PAINT);

		if(s.touched){
			PAINT.setColor(Color.argb(120, 0, 0, 0)); 
			PAINT.setTextSize(50); 
			c.drawText("TOUCH ENABLED", 50, 150, PAINT);
		}
		drawBitmapEntity(s.drop,null);
	}
	@Override
	public void onStop(ExampleLevelState s) throws Exception {}
	@Override
	public void onTouch(ExampleLevelState s, MotionEvent me) throws Exception{		
		if(me.getAction() == MotionEvent.ACTION_DOWN)
			s.touched = true;
		if(me.getAction() == MotionEvent.ACTION_UP)
			s.touched = false;

		s.bgX = me.getX();
		s.bgY = me.getY();
	}
	@Override
	public void onCache(ExampleLevelState s) {

		s.drop = new BitmapEntity(R.drawable.droplet);
		s.bg =new BitmapEntity(R.drawable.window);
		s.sun = new BitmapEntity(R.drawable.sun);

		s.clouds[0].cloud = decodeResource(R.drawable.cl1);
		s.clouds[1].cloud = decodeResource(R.drawable.cl2);	
		s.clouds[2].cloud = decodeResource(R.drawable.cl3);
		s.clouds[3].cloud = decodeResource(R.drawable.cl4);	
		s.clouds[4].cloud = decodeResource(R.drawable.cl5);
		s.clouds[5].cloud = decodeResource(R.drawable.cl6);	
		s.clouds[6].cloud = decodeResource(R.drawable.cl7);
	}
	@Override
	public void onError(ExampleLevelState s, Exception e) {		
		toast("Corruption detected", Toast.LENGTH_SHORT);
		UniverseLog.d("Error", "Corruption detected");
	}
	@Override
	public void onPaneCreate(ExampleLevelState s) throws Exception {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void onValueChange(ExampleLevelState s, int selection, boolean check,
			int id) throws Exception {
		// TODO Auto-generated method stub
		
	}	
}
class ExampleLevelState{
	boolean touched = false;
	Cloud [] clouds = 
		{ new Cloud(), new Cloud(), new Cloud(), new Cloud(), new Cloud(), new Cloud(), new Cloud()	};

	BitmapEntity sun;	
	BitmapEntity bg;
	BitmapEntity drop;
    
	ColorFilter cm;
	
	double hue = 0;
	
	double sunX = -100.0;
	double sunY = 480.0;

	double bgX = 0.0;
	double bgY = 0.0;

	int R = 240;
	int G = 10;
	int B = 180;
};

class Cloud{
	Bitmap cloud;
	double x = 0.0;
	double y = 0.0;
	public Cloud(){
		this.x = -450 + (Math.random() * (450 - -450));
		this.y = Math.random()*200;
	}
}