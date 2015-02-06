package mk.universityoftexas.austin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.util.AttributeSet;
import android.webkit.WebView;
import android.widget.LinearLayout;

public class OverlayWebView extends WebView{

	private Canvas offscreen;
	private Canvas origCanvas;
	Bitmap bitmap;
	Paint p;
	int _saveFlag = 0x154;

	public OverlayWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
		setBackgroundColor(Color.WHITE);
		p = new Paint();
		p.setAntiAlias(true);
		p.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.MULTIPLY));
	}
	@Override
	public void onDraw(Canvas canvas) {
		canvas.save(_saveFlag);
		try{
			if(canvas==offscreen){
				origCanvas.drawBitmap(bitmap, 0, 0, p);
				freeMemory();
			}
			else{
				origCanvas = canvas;
				if(bitmap==null){
					bitmap = Bitmap.createBitmap(getWidth()*2, getHeight()*4, Config.RGB_565);        	
					android.util.Log.d("safsdfsf", "Sfsd");
				}
				if(offscreen==null) offscreen=new Canvas(bitmap);
				super.onDraw(offscreen);
				onDraw(offscreen);
			}
		}catch(Exception e){
			Log.d("OverlayWebview", "onDraw error", "red");
			canvas.restoreToCount(_saveFlag);
			super.onDraw(canvas);
		}
	}
	public void recycle(){
		if(bitmap!=null) bitmap.recycle();
		bitmap = null;
		p = null;
		offscreen = null;
		origCanvas = null;
		freeMemory();
	}
}
class PinnedLinearLayout extends LinearLayout{

	private Bitmap pin;
	Paint p;
	int _saveFlag = 0x154;

	
	public PinnedLinearLayout(Context context) {
		super(context);
		setBackgroundColor(Color.WHITE);
		p = new Paint();
		p.setAntiAlias(true);
	}
	@Override
	public void dispatchDraw(Canvas canvas) {
		canvas.save(_saveFlag);
		try{
			if(pin == null)
				pin = BitmapFactory.decodeResource(getResources(), R.drawable.pin1, null);
			super.dispatchDraw(canvas);
			canvas.drawBitmap(pin, 10,10, p);

		}catch(Exception e){
			Log.d("PinnedWebView", "dispatchDraw error", "red");
			canvas.restoreToCount(_saveFlag);
			super.dispatchDraw(canvas);
		}

	}

}
