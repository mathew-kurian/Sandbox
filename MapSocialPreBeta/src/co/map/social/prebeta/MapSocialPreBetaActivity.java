package co.map.social.prebeta;

import android.app.Activity;
import android.os.Bundle;
import android.view.OrientationEventListener;
import android.widget.ImageView;
import android.widget.Toast;

public class MapSocialPreBetaActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Ave.current = this;
        setContentView(R.layout.main);
        
        ((ImageView) this.findViewById(R.id.top_banner)).setImageBitmap(ImageFactory.createGroupBanner(getApplicationContext(), R.drawable.test1));
        Toast.makeText(this, SunnyReader.getArticles(this), Toast.LENGTH_LONG).show();
        
        OrientationEventListener l = new OrientationEventListener(this){

			@Override
			public void onOrientationChanged(int orientation) {
				 ((ImageView) MapSocialPreBetaActivity.this.findViewById(R.id.top_banner)).setImageBitmap(ImageFactory.createGroupBanner(getApplicationContext(), R.drawable.test1));
				
			}
        	
        };
    }
}