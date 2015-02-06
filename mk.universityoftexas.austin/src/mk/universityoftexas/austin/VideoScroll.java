package mk.universityoftexas.austin;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ScrollView;


public class VideoScroll extends ScrollView{

	boolean unlocked = true;
	

	private boolean mScrollable = true;

    public void setIsScrollable(boolean scrollable) {
        mScrollable = scrollable;
    }
    public boolean getIsScrollable(){
        return mScrollable;
    }

	public VideoScroll(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
	}
	public VideoScroll(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}
	public VideoScroll(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}
	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
	        View view = (View) getChildAt(getChildCount()-1);
	        int diff = (view.getBottom()-(getHeight()+getScrollY()));// Calculate the scrolldiff
	        if( diff == 0 && unlocked){  // if diff is zero, then the bottom has been reached
	            new Youtube_Download(((Video) AVE.CURRENT).pg).execute(); ((Video) AVE.CURRENT).pg++;
	            unlocked = false;
	        }else if(diff > 150)
	        	unlocked = true;
	        super.onScrollChanged(l, t, oldl, oldt);
	}

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
    	if(!((Video) AVE.CURRENT).lock){
    		switch (ev.getAction()) {
    		case MotionEvent.ACTION_DOWN:
                // if we can scroll pass the event to the superclass
                if (mScrollable) return super.onTouchEvent(ev);
                // only continue to handle the touch event if scrolling enabled
                return mScrollable; // mScrollable is always false at this point
            default:
            	((Video) AVE.CURRENT).gallerySlideOut(5000);
                return super.onTouchEvent(ev);
    		}
    	}
    	((Video) AVE.CURRENT).gallerySlideOut(5000);
    	return true;
    }
    		
            
}