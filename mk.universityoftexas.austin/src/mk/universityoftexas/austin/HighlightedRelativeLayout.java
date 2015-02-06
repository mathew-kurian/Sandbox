package mk.universityoftexas.austin;

import android.content.Context;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

public class HighlightedRelativeLayout extends RelativeLayout implements OnTouchListener{

	Bitmap _highlight_cache;
	
	boolean onTouch = false;		
	int _saveFlag = 0x1547;
	
	public HighlightedRelativeLayout(Context context) {
		super(context);
		setOnTouchListener(this);
	}
	public HighlightedRelativeLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		setOnTouchListener(this);
	}
	@Override
	public void onDraw(Canvas canvas) {
		canvas.save(_saveFlag);
		try{
			if(_highlight_cache==null)
				_highlight_cache = getHighlightCache();
			if(onTouch) canvas.drawBitmap(_highlight_cache, 0, 0, null);
			super.onDraw(canvas);
		}catch(Exception e){
			Log.d("HighlightedRelativeLayout", "onDraw error", "Red");
			canvas.restoreToCount(_saveFlag);
			super.onDraw(canvas);
		}
	}
	private Bitmap getHighlightCache(){
		int x = (int) (Math.random()*6);

		BitmapDrawable bmd = AVE.h1;

		switch(x){
		case 0: bmd = AVE.h1; break;
		case 1: bmd = AVE.h2; break;
		case 2: bmd = AVE.h3; break;
		case 3: bmd = AVE.h4; break;
		case 4: bmd = AVE.h5; break;
		case 5: bmd = AVE.h6; break;
		}		
		return AVE.resize(bmd, getWidth(), getHeight()).getBitmap();	
	}
	public boolean onTouch(View v, MotionEvent event) {
		if(event.getAction() == MotionEvent.ACTION_DOWN){
			onTouch = true;
			invalidate();
			return false;
		}else if (event.getAction() == MotionEvent.ACTION_MOVE){
			onTouch = true;
			invalidate();
			return false;
		}else{
			onTouch = false;
			invalidate();
			return false;
		}
	}

}
