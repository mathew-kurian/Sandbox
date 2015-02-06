package mk.universityoftexas.austin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.widget.TextView;

public class OverlayTextView extends TextView{

	private Canvas offscreen;
	private Canvas origCanvas;
	Bitmap bitmap;
	Paint p;
	int _saveFlag = 0x154;

	public OverlayTextView(Context context) {
		super(context);
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
			}
			else{
				origCanvas = canvas;
				if(bitmap==null){
					bitmap = Bitmap.createBitmap(getWidth(), getHeight(), Config.RGB_565);        	
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
	}
}