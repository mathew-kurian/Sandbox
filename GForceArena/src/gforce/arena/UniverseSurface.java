package gforce.arena;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnTouchListener;
import static gforce.arena.UniverseAVE.*;

@SuppressWarnings("rawtypes")
public class UniverseSurface extends SurfaceView implements OnTouchListener, SurfaceHolder.Callback{
	public Thread surfaceThread;	
	
	private Universe gfu;

	public UniverseSurface(Context context) {
		super(context);
		getHolder().addCallback(this);
		setOnTouchListener(this);
	}
	public UniverseSurface(Context context, AttributeSet attrs) {
		super(context, attrs);
		getHolder().addCallback(this);
		setOnTouchListener(this);
	}
	public UniverseSurface(Context context, AttributeSet attrs, int styleID) {
		super(context, attrs, styleID);	
		getHolder().addCallback(this);
		setOnTouchListener(this);
	}
	public void setUniverse(Universe gForceUnverse){
		gfu = gForceUnverse;
	}
	public void createDrawingThread(Runnable rn){
		surfaceThread = new Thread(rn);
		setDrawingPriority(Thread.MAX_PRIORITY);
		surfaceThread.start();
	}
	public void setDrawingPriority(int threadPiority){
		surfaceThread.setPriority(threadPiority);
	}
	public Canvas lockCanvas()  throws Exception{		
		Canvas canvas = null;
		canvas = getHolder().lockCanvas();
		return canvas; 
	}
	public void unlockCanvasAndPost(Canvas canvas) throws Exception{
		getHolder().unlockCanvasAndPost(canvas);
	}
	public boolean onTouch(View v, MotionEvent event) {
		try{
			gfu.fireTouchEvent(event);
		}catch(Exception e){
			return false;
		}
		return true;
	}
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {		
	}
	public void surfaceCreated(SurfaceHolder holder) {	
		SURF_ENABLED = true;
	}
	public void surfaceDestroyed(SurfaceHolder holder) {
		SURF_ENABLED = false;
	}	
}

