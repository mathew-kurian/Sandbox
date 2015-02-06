package gforce.arena;

import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;

public class ExampleActivity extends UniverseActivity {

	@Override
	public int setLayoutId() {
		return R.layout.main;
	}
	@Override
	public void preCreate() {}

	@Override
	public void postCreate() {
		final Animation fadeOut = AnimationUtils.loadAnimation(this, R.anim.fo);		
		fadeOut.setAnimationListener(new AnimationListener(){
			public void onAnimationEnd(Animation animation) {
				ExampleGForce el = new ExampleGForce(R.id.holder);
				el.execute();
			}
			public void onAnimationRepeat(Animation animation) {}
			public void onAnimationStart(Animation animation) {}			
		});
		
		new Handler().postDelayed(new Runnable(){
			public void run() {
					findViewById(R.id.fadeout).startAnimation(fadeOut);		
			}			
		}, 4000);
		
	//	((WifiManager)this.getApplicationContext().getSystemService(Context.WIFI_SERVICE)).setWifiEnabled(true);
	}
    
}