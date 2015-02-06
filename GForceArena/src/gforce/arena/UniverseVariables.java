package gforce.arena;

import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class UniverseVariables{
	public static boolean DRAWING_ENABLED = true;
	public static long DRAWING_SLEEP = 0;

	public static boolean TICK_ENABLED = true;
	public static long TICK_SLEEP = 0;
	
	public static boolean TOUCH_ENABLED = true;
	public static long TOUCH_SLEEP = 0;
	public static long TOUCH_POLLING_DELAY = 100;
	
	public static int SCREEN_WIDTH = 0;
	public static int SCREEN_HEIGHT = 0;

	public static int SCREEN_ORIENTATION = Orientation.PORTRAIT;
	public static boolean GESTURE_SHAKE = false;
}
final class Orientation{
	public static final int PORTRAIT = Configuration.ORIENTATION_LANDSCAPE;
	public static final int LANDSCAPE = Configuration.ORIENTATION_LANDSCAPE;
}
class BitmapEntity{
	private double height = 0;
	private double width = 0;
	private double x = 0;
	private double y = 0;
	private Bitmap bmp;
	
	public BitmapEntity(){}
	public BitmapEntity(int id){
		bmp = BitmapFactory.decodeResource(UniverseAVE.GFA.getResources(), id);
		update();
	}
	public Bitmap getBitmap(){
		return bmp;
	}
	public BitmapEntity(Bitmap b){
		bmp = b;	
		update();
	}
	public void setBitmap(Bitmap bmp){
		this.bmp = bmp;
		update();
	}
	public void update(){
		height = bmp.getHeight();
		width = bmp.getWidth();
	}
	public void setBounds(double x, double y, double width, double height){
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}	
	public boolean isInBounds(int x, int y){
		if(x>=this.x&&y>=this.y&&x<=(this.x+this.width)&&y<=(this.y+this.height))
				return true;
		else	return false;
	}
	public void setLocation(double x, double y){
		this.x = x;
		this.y = y;
	}
	public double getX(){
		return this.x;
	}
	public double getY(){
		return this.y;
	}
	public void setX(double x){
		this.x = x;
	}
	public void setY(double y){
		this.y = y;
	}
}