package gforce.arena;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.ScrollView;


public class UniverseScrollView extends ScrollView{

	public UniverseScrollView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}
	public UniverseScrollView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}
	public UniverseScrollView(Context context) {
		super(context);
	}
    @Override
    public boolean onTouchEvent(MotionEvent ev) {
    	super.onTouchEvent(ev);
    	if(ev.getAction() == MotionEvent.ACTION_MOVE){
    		UniverseAVE.GFU.tickRunnable.pause();
    		UniverseAVE.GFU.drawRunnable.pause();
    	}else if(ev.getAction() ==  MotionEvent.ACTION_UP){
    		UniverseAVE.GFU.tickRunnable.resume();
    		UniverseAVE.GFU.drawRunnable.resume();
    	}
    	return true;
    }
    		
            
}