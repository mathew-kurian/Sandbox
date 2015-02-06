package mk.universityoftexas.austin;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

public class LightingLayoutRelative extends RelativeLayout {

	Paint p;
	boolean onTouch = false;
	float touchX = 0;
	float touchY = 0;

	public LightingLayoutRelative(Context context, AttributeSet attrs) {
		super(context, attrs);
		p = new Paint();
		p.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.MULTIPLY));
	}
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
	} 
	@Override
	protected void dispatchDraw(Canvas canvas){
		super.dispatchDraw(canvas);
		try {
			if(AVE.lightOn)
				drawLighting(canvas);
		} catch (Exception e) {
			Log.d("LightingLayoutRelative", "Lighting Error", "blue");
		}	
	}
	protected void drawLighting(Canvas canvas) throws Exception{
		if(AVE.LIGHTING_LANDSCAPE!=null&&AVE.LIGHTING_PORTRAIT!=null){
			if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) canvas.drawBitmap(AVE.LIGHTING_PORTRAIT, 0, 0, p);
			if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) canvas.drawBitmap(AVE.LIGHTING_LANDSCAPE, 0, 0, p);
		}		
	}
}
