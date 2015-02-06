package gforce.arena;

import java.io.RandomAccessFile;
import java.util.ArrayList;

import android.app.Activity;
import android.app.Service;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.text.Html;
import android.view.Display;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioGroup.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

import static gforce.arena.UniverseAVE.*;

abstract class UniverseState{
	public abstract void onMultithreading(Thread touch, Thread tick, Thread drawer);
}
public abstract class Universe<T>{	
	
	private T state;
	
	private UniverseSurface surface;
	
	public RunnableWithPause drawRunnable, tickRunnable, touchRunnable;
	
	private Canvas surfaceCanvas;
	
	private Thread tickThread, touchThread;
	
	private Display display;
	
	Paint PAINT = new Paint(), TEXT_PAINT = new Paint();
	
	private long curTime,prevTime = System.currentTimeMillis();
	
	protected double INSTANTANEOUS_FRAMERATE = 0;
	
	private boolean fireTouch = false;
	
	private MotionEvent currentMotionEvent;
	
	private RelativeLayout overallContainer;
	
	private LinearLayout mainContainer;
	
	private ArrayList<Integer> subContainerIDs = new ArrayList<Integer>();


	public abstract void onCache(T s) throws Exception;
	
	public abstract void onTick(T s)  throws Exception;
	
	public abstract void onPrerender(T s)  throws Exception;
	
	public abstract void onDraw(T s, Canvas c)  throws Exception;
	
	public abstract void onStop(T s)  throws Exception;
	
	public abstract void onTouch(T s, MotionEvent me) throws Exception;
	
	public abstract void onError(T s, Exception e);
	
	public abstract void onPaneCreate(T s) throws Exception;
	
	public abstract void onValueChange(T s, int selection, boolean check, int id) throws Exception;

	public void forceSeekBar(double forced, int id){
		((ProgressBar) findViewById(id)).setProgress((int) forced);
	}
	public void forceCheckBox(boolean forced, int id){
		((CheckBox) findViewById(id)).setChecked(forced);
	}
	public void forceLabel(String s, int id){
		((TextView) findViewById(id)).setText(Html.fromHtml(s));
	}
	public void createLabel(int id, String s, int gravity, int viewGroupId){
		TextView label = new TextView(GFA);
		label.setGravity(gravity);			
		label.setText(Html.fromHtml(s));
		((ViewGroup) findViewById(viewGroupId)).addView(label);
	}
	public void createSeekBar(double _default, double max, int id, String title, String details, int viewGroupId){
		SeekBar pb = new SeekBar(UniverseAVE.GFA);
		pb.setOnSeekBarChangeListener(new OnSeekBarChangeListener(){
			public void onProgressChanged(SeekBar arg0, int arg1, boolean arg2) {
				try {
					onValueChange(state, arg1, false, arg0.getId());
				} catch (Exception e) {
					onError(state, e);
				}
			}
			public void onStartTrackingTouch(SeekBar arg0) {}

			public void onStopTrackingTouch(SeekBar arg0) {}			
		});

		pb.setMax((int)max);
		pb.setProgress((int) _default);
		pb.setId(id);
		TextView tx = new TextView(UniverseAVE.GFA);
		tx.setPadding(0, 10, 0, 0);
		tx.setText(Html.fromHtml(title));
		TextView tx2 = new TextView(UniverseAVE.GFA);
		tx2.setText(Html.fromHtml(details));
		tx2.setPadding(0, 0, 0, 10);
		tx2.setTextSize(10);

		((ViewGroup) findViewById(viewGroupId)).addView(tx);
		((ViewGroup) findViewById(viewGroupId)).addView(pb);
		((ViewGroup) findViewById(viewGroupId)).addView(tx2);
	}
	public void createCheckBox(boolean _default, int id, String title, String details, int viewGroupId){
		CheckBox chek = new CheckBox(UniverseAVE.GFA);
		chek.setChecked(_default);
		chek.setId(id);
		LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams( LinearLayout.LayoutParams.WRAP_CONTENT,  LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		chek.setLayoutParams(lp);
		chek.setOnCheckedChangeListener(new OnCheckedChangeListener(){
			public void onCheckedChanged(CompoundButton arg0, boolean arg1) {
				try {
					onValueChange(state, 0, arg1, arg0.getId());
				} catch (Exception e) {
					onError(state, e);
				}
			}			
		});
		TextView tx = new TextView(UniverseAVE.GFA);
		tx.setPadding(0, 10, 0, 0);
		tx.setText(Html.fromHtml(title));		

		TextView tx2 = new TextView(UniverseAVE.GFA);
		tx2.setText(Html.fromHtml(details));
		tx2.setPadding(0, 0, 0, 0);
		tx2.setTextSize(10);
		tx2.setLayoutParams(lp);

		LinearLayout inside = new LinearLayout(UniverseAVE.GFA);
		inside.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT));
		inside.setOrientation(LinearLayout.HORIZONTAL);
		inside.addView(chek);
		inside.addView(tx2);
		inside.setPadding(0, 0, 0, 10);

		((ViewGroup) findViewById(viewGroupId)).addView(tx);
		((ViewGroup) findViewById(viewGroupId)).addView(inside);
	}
	public void createCPUTemperature(int viewGroupId){
		LinearLayout lp = new LinearLayout(GFA);
		lp.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		lp.setOrientation(LinearLayout.HORIZONTAL);
		final TextView tx = new TextView(GFA);
		tx.setGravity(Gravity.CENTER);
		LayoutParams lpa = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		lpa.weight = 3;
		tx.setLayoutParams(lpa);
		final Button update = new Button(GFA);
		lpa = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		lpa.weight = 1;
		update.setLayoutParams(lpa);
		update.setText("Refresh");
		update.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				((SensorManager)GFA.getSystemService(Service.SENSOR_SERVICE)).getDefaultSensor(Sensor.TYPE_TEMPERATURE)
				tx.setText(Html.fromHtml("<b>CPU Usage: </b>" + .toString(readCPU()*100)+"%"));
				
			}
			
		});
		tx.setText(Float.toString(readCPU()*100));
		lp.addView(tx);
		lp.addView(update);
		((ViewGroup) findViewById(viewGroupId)).addView(lp);
	}
	public void createCPUDetails(int viewGroupId){
		LinearLayout lp = new LinearLayout(GFA);
		lp.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		lp.setOrientation(LinearLayout.HORIZONTAL);
		final TextView tx = new TextView(GFA);
		tx.setGravity(Gravity.CENTER);
		LayoutParams lpa = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		lpa.weight = 3;
		tx.setLayoutParams(lpa);
		final Button update = new Button(GFA);
		lpa = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		lpa.weight = 1;
		update.setLayoutParams(lpa);
		update.setText("Refresh");
		update.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				tx.setText(Html.fromHtml("<b>CPU Usage: </b>" + Float.toString(readCPU()*100)+"%"));
				
			}
			
		});
		tx.setText(Float.toString(readCPU()*100));
		lp.addView(tx);
		lp.addView(update);
		((ViewGroup) findViewById(viewGroupId)).addView(lp);
	}
	public void createMenuPane(int id, int backgroundColor, String s){
		LinearLayout l = new LinearLayout(GFA);
		l.setPadding(15, 10, 15, 10);	
		l.setLayoutParams(new LinearLayout.LayoutParams( LinearLayout.LayoutParams.FILL_PARENT,  LinearLayout.LayoutParams.FILL_PARENT));
		l.setId(id);
		l.setBackgroundColor(backgroundColor);
		l.setOrientation(LinearLayout.VERTICAL);
		l.setVisibility(View.GONE);
		l.setTag(s);
		mainContainer.addView(l);
		subContainerIDs.add(id);
	}
	public void developUniverseContainer(int id){		
		overallContainer = new RelativeLayout(GFA);
		overallContainer.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
		
		((ViewGroup)findViewById(id)).removeAllViews();		
		((ViewGroup)findViewById(id)).addView(overallContainer);
		
		surface = new UniverseSurface(GFA);
		surface.setUniverse(this);
		surface.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
		overallContainer.addView(surface);

		mainContainer = new LinearLayout(GFA);
		mainContainer.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
		mainContainer.setOrientation(LinearLayout.VERTICAL);	
		overallContainer.addView(mainContainer);
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Universe(int layoutId, Class c){
		GFU = this;	
		developUniverseContainer(layoutId);
		display = ((WindowManager) GFA.getSystemService(Activity.WINDOW_SERVICE)).getDefaultDisplay();
		try{
			this.state = (T) c.newInstance();
		}catch(Exception e){}		
	}
	public void execute(){
		UniverseVariables.SCREEN_WIDTH = display.getWidth();
		UniverseVariables.SCREEN_HEIGHT = display.getHeight();
		UniverseVariables.SCREEN_ORIENTATION = display.getOrientation();

		try {
			onPaneCreate(state);			
		} catch (Exception e) {
			onError(state, e);
		}
		fireCache();	
		firePrerenderAndTick();	
	}
	protected void onBackPressed(){
		for(int x = 0; x<subContainerIDs.size(); x++)	findViewById(subContainerIDs.get(x)).setVisibility(View.GONE);
	}
	protected boolean onPrepareOptionsMenu(Menu menu) {
		menu.clear();
		for(int x = 0; x<subContainerIDs.size(); x++){
			String full = ((String) findViewById(subContainerIDs.get(x)).getTag());
			int splitter = ((String) findViewById(subContainerIDs.get(x)).getTag()).indexOf("|");
			String menuShow = full.substring(0, splitter);
			String menuHide = full.substring(splitter+1);
			menu.add(0, subContainerIDs.get(x), 0, findViewById(subContainerIDs.get(x)).getVisibility() == View.GONE ? menuShow: menuHide);
		}
		return true;
	}
	public boolean onOptionsItemSelected(MenuItem item) {
		if(subContainerIDs.size()>0){
			for(int x = 0; x<subContainerIDs.size(); x++)			
				if(findViewById(subContainerIDs.get(x)).getVisibility() == View.VISIBLE && item.getItemId()!=subContainerIDs.get(x)) 
					findViewById(subContainerIDs.get(x)).setVisibility(View.GONE);

			findViewById(item.getItemId()).setVisibility(findViewById(item.getItemId()).getVisibility()==View.VISIBLE ? View.GONE : View.VISIBLE);
			return true;
		}
		return false;
	}
	private float readCPU() {
	    try {
	        RandomAccessFile reader = new RandomAccessFile("/proc/stat", "r");
	        String load = reader.readLine();

	        String[] toks = load.split(" ");

	        long idle1 = Long.parseLong(toks[5]);
	        long cpu1 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4])
	              + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

	        try {
	            Thread.sleep(360);
	        } catch (Exception e) {}

	        reader.seek(0);
	        load = reader.readLine();
	        reader.close();

	        toks = load.split(" ");

	        long idle2 = Long.parseLong(toks[5]);
	        long cpu2 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4])
	            + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

	        return (float)(cpu2 - cpu1) / ((cpu2 + idle2) - (cpu1 + idle1));

	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }

	    return 0;
	} 
	public View findViewById(int id){
		return GFA.findViewById(id);
	}
	protected void setDrawingThreadPriority(int threadPriority){
		surface.setDrawingPriority(threadPriority);
	}
	protected void setTickThreadPriority(int threadPriority){
		tickThread.setPriority(threadPriority);
	}
	protected void setTouchThreadPriority(int threadPriority){
		touchThread.setPriority(threadPriority);
	}
	protected void fireTouchEvent(MotionEvent me){
		fireTouch = true;
		currentMotionEvent = me;

		System.out.println("sdfsdf");
	}
	private void firePrerender(){
		try {
			onPrerender(state);
		} catch (Exception e) {
			onError(state, e);
		}
	}
	private void fireCache(){
		try {
			onCache(state);
		} catch (Exception e) {
			onError(state, e);
		}
	}
	private void fireTouch(){
		touchRunnable = new RunnableWithPause(){
			public void action() throws Exception{
				while(UniverseVariables.TOUCH_ENABLED){
					Thread.sleep(UniverseVariables.TOUCH_POLLING_DELAY);
					if(fireTouch) {
						while(PAUSE)	Thread.sleep(500);
						if(UniverseVariables.TOUCH_SLEEP>0)				Thread.sleep(UniverseVariables.TOUCH_SLEEP);
						try {
							onTouch(state, currentMotionEvent);
						} catch (Exception e) {
							onError(e);
						}
						fireTouch = false;
					}
				}
			}
			@Override
			public void onError(Exception e) {
				Universe.this.onError(state, e);
			}
		};
		touchThread = new Thread(touchRunnable);
		touchThread.start();		
	}
	private void firePrerenderAndTick(){
		tickRunnable = new RunnableWithPause(){
			public void action()  throws Exception{
				firePrerender();
				fireTouch();
				fireDraw();	
				while(UniverseVariables.TICK_ENABLED){
					while(PAUSE)	Thread.sleep(500);
					UniverseVariables.SCREEN_ORIENTATION = display.getOrientation();
					if(UniverseAVE.SURF_ENABLED){
						if(UniverseVariables.TICK_SLEEP>0)	Thread.sleep(UniverseVariables.TICK_SLEEP);
						try {
							onTick(state);
						} catch (Exception e) {
							onError( e);
						}
					}
				}
			}
			@Override
			public void onError(Exception e) {
				Universe.this.onError(state, e);				
			}
		};
		tickThread = new Thread(tickRunnable);
		tickThread.setPriority(Thread.MAX_PRIORITY);
		tickThread.start();		

		//Placed here to prevent null pointer error		 
		//	((UniverseState) state).onMultithreading(touchThread, tickThread, surface.surfaceThread);
	}
	private void updateFramerate(){
		curTime = System.currentTimeMillis();	
		try{
			INSTANTANEOUS_FRAMERATE =  1000 / (curTime - prevTime);
		}catch(Exception e){}
		prevTime = new Long(curTime);
	}
	private void fireDraw(){
		drawRunnable = new RunnableWithPause(){
			public void action() throws Exception {
				while(UniverseVariables.DRAWING_ENABLED){
					while(PAUSE)									Thread.sleep(500);
					if(UniverseAVE.SURF_ENABLED){
						updateFramerate();
						if(UniverseVariables.DRAWING_SLEEP>0)		Thread.sleep(UniverseVariables.DRAWING_SLEEP);
						try {
							surfaceCanvas = surface.lockCanvas();
							synchronized (surface.getHolder()) {
								try {
									onDraw(state, surfaceCanvas);
								} catch (Exception e) {
									onError(e);
								}
							}
						} catch (Exception e) {
							onError(e);
						} finally {
							if (surfaceCanvas != null)try {
								surface.unlockCanvasAndPost(surfaceCanvas);
							} catch (Exception e) {
								onError(e);
							}
						}
					}
				}
			}
			@Override
			public void onError(Exception e) {
				Universe.this.onError(state, e);
			}

		};		
		surface.createDrawingThread(drawRunnable);
	}
	public static ColorFilter adjustHue(float value) { 
		ColorMatrix cm = new ColorMatrix();
		value = cleanValue(value,180f)/180f*(float)Math.PI; 
		if (value == 0 ) { return new ColorMatrixColorFilter(cm); } 
		float cosVal = (float)Math.cos(value); 
		float sinVal = (float)Math.sin(value); 
		float lumR = 0.213f; 
		float lumG = 0.715f; 
		float lumB = 0.072f; 
		float[] mat = new float[] { 
				lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(- 
						lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0, 
						lumR+cosVal*(-lumR)+sinVal*(0.143f),lumG+cosVal*(1-lumG) 
						+sinVal*(0.140f),lumB+cosVal*(-lumB)+sinVal*(-0.283f),0,0, 
						lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG) 
						+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0, 
						0f,0f,0f,1f,0f, 
						0f,0f,0f,0f,1f 
		}; 
		cm.postConcat(new ColorMatrix(mat));
		return new ColorMatrixColorFilter(cm);
	} 
	protected static float cleanValue(float p_val, float p_limit) { 
		return Math.min(p_limit,Math.max(-p_limit,p_val)); 
	} 
	void toast(String s, int length){
		GFA.toast(s, length);
	}
	void toastImage(int drawable, int length){
		GFA.toastImage(drawable, length);
	}
	void toastImageText(String s, int drawable, int length){		
		GFA.toastImageText(s, drawable, length);
	}
	public void drawBitmapEntity(BitmapEntity e, Paint p){
		surfaceCanvas.drawBitmap(e.getBitmap(), (int) e.getX(), (int) e.getY(), p);
	}
	public void setBitmapEntityLocation(BitmapEntity e, double x, double y){
		e.setX(x);
		e.setY(y);
	}
	public void incrementBitmapEntityLocation(BitmapEntity e, float offsetX, float offsetY){
		e.setX(e.getX()+offsetX);
		e.setY(e.getY()+offsetY);
	}
	public Bitmap decodeResource(int id){
		return BitmapFactory.decodeResource(UniverseAVE.GFA.getResources(), id);
	}
}
abstract class RunnableWithPause implements Runnable{
	public boolean PAUSE = false;
	public void run(){		
		try {
			action();
		} catch (Exception e) {
			onError(e);
		}
	}
	public void pause(){
		PAUSE = true;
	}
	public void resume(){
		PAUSE = false;
	}
	public abstract void action()  throws Exception;
	public abstract void onError(Exception e);

}
