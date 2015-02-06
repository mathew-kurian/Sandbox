package mk.universityoftexas.austin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.AttributeSet;
import android.widget.ProgressBar;

public class OverlayProgressBar extends ProgressBar{
	Bitmap bitmap;
			
	public OverlayProgressBar(Context context) {
		super(context);
		applyAttributes();
	}
	public OverlayProgressBar(Context context, AttributeSet attrs) {
		super(context, attrs);
		applyAttributes();
	}
	public OverlayProgressBar(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		applyAttributes();
	}
	public void applyAttributes(){
		setBackgroundColor(Color.WHITE);
		setProgressDrawable(getResources().getDrawable(R.drawable.ut_bar));
	}
}
