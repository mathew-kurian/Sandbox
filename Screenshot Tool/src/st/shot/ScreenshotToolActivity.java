package st.shot;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class ScreenshotToolActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }
    public void onClick(View target){
    	switch (target.getId()){
    	case R.id.button1: 
    		startService(new Intent(this, ScreenshotService.class)); break;
    	case R.id.button2: 
    		stopService(new Intent(this, ScreenshotService.class)); break;
    	}
    }
    public void onBackPressed(){
    	super.onBackPressed();
    	startService(new Intent(this, ScreenshotService.class));
    }
}