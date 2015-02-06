package tiffany.wordeditor;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;

@SuppressWarnings("static-access")
public class Home extends Activity {
    /** Called when the activity is first created. */
	Tiffany t;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
  //      new Blog_Download(this).execute();
        t = new Tiffany((WordEditor) findViewById(R.id.editText1));
        ((SeekBar) findViewById(R.id.seekbar)).setMax(20);
        ((SeekBar) findViewById(R.id.seekbar)).setOnSeekBarChangeListener(new OnSeekBarChangeListener(){
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				int size = progress + 5;
				t.setClipFromSelection();
				t.setTextSize(size);
			}
			public void onStartTrackingTouch(SeekBar seekBar) {}
			public void onStopTrackingTouch(SeekBar seekBar) {}        	
        });
    }
	public void onClick(View target){
    	t.setClipFromSelection();
    	switch(target.getId()){
	    	case R.id.Bold: t.setTextStyle(TextStyle.Mode.BOLD); break;
	    	case R.id.Bold_italic: t.setTextStyle(TextStyle.Mode.BOLD_ITALIC); break;
	    	case R.id.Underline: t.setTextStyle(TextStyle.Mode.UNDERLINE); break;
	    	case R.id.Normal: t.setTextStyle(TextStyle.Mode.NONE); break;
	    	case R.id.Italic: t.setTextStyle(TextStyle.Mode.ITALIC); break;
	    	case R.id.Bullet1: t.addBullet(BulletStyle.Mode.GENERIC); break;
	    	case R.id.Bullet2: t.removeBullet(); break;
	    	case R.id.Increase: t.increaseTextSize(2); break;
	    	case R.id.Decrease: t.decreaseTextSize(2); break;
	    	case R.id.HighlightRed: t.setTextHighlight(Color.RED); break;
	    	case R.id.HighlightRemove: t.setTextHighlight(Color.TRANSPARENT); break;
	    	case R.id.TextWhite: t.setTextColor(Color.WHITE); break;
	    	case R.id.TextBlack: t.setTextColor(Color.BLACK); break;
	    	case R.id.AddStar: t.addImage(R.drawable.star); break;
	    	case R.id.ShowHtml: showHTML(); break;
    	}
    }
	public void showHTML(){
		AlertDialog alertDialog = new AlertDialog.Builder(this).create();  
	    alertDialog.setTitle("Alert 1");  
	    alertDialog.setMessage(Html.toHtml(((WordEditor)this.findViewById(R.id.editText1)).getEditableText()));  
	    alertDialog.show();
	}
}