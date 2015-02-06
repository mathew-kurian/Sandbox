package mk.universityoftexas.austin;

import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.ScrollView;
import mk.universityoftexas.austin.R;

public class LogView extends Driver {	
	@Override
	public int setLayout() {
		// TODO Auto-generated method stub
		return R.layout.log;
	}
	public boolean setCurrent(){
		return false;
	}
	@Override
	public void action() {
		Log.appendMemoryUsage();
		((TextView) findViewById(R.id.log_text)).setText(Html.fromHtml(Log.LOG.toString()));	
		((Button) findViewById(R.id.log_button)).setOnClickListener(new OnClickListener(){
			public void onClick(View v) {				
				((ScrollView) findViewById(R.id.log_scroll)).scrollTo(0, 100000);
			}

		});
	}
	@Override
	public void modAVE() {}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {}
	@Override
	public void showInstructions() {}

	@Override
	public void preAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public int[] toAnimate() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int[] animationTypes() {
		// TODO Auto-generated method stub
		return null;
	}
}