package mk.universityoftexas.austin;

import android.os.Handler;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.Animation.AnimationListener;

public class AnimationEngine {

	private int [] toAnimate;
	private int [] animationTypes;
	private int animationCounter = 0;
	private Driver d;
	
	public AnimationEngine(Driver _d, int [] _toAnimate, int [] _animationTypes ){	
		toAnimate = _toAnimate;
		animationTypes = _animationTypes;
		d = _d;
	}
	public void startAnimation(int post){
		if(toAnimate!=null){
			final AnimationSet seed = createAnimationSet();
			Handler hnd = new Handler();
			Runnable r = new Runnable(){
				public void run(){
					try{					
						developAnimation(seed);	
						d.findViewById(toAnimate[animationCounter]).setVisibility(View.VISIBLE);
						d.findViewById(toAnimate[animationCounter]).startAnimation(seed);
					}catch(Exception e){}		
				}
			};
			hnd.postDelayed(r, post);
		}
	}
	private void developAnimation(AnimationSet anim){
		AnimationSet ans = anim;
		ans.setAnimationListener(new AnimationListener(){
			public void onAnimationEnd(Animation animation) {
				animationCounter ++;
				if(animationCounter<toAnimate.length){		
					AnimationSet ani = createAnimationSet();
					developAnimation(ani);
					d.findViewById(toAnimate[animationCounter]).setVisibility(View.VISIBLE);
					d.findViewById(toAnimate[animationCounter]).startAnimation(ani);
				}else					
					d = null;
				
			}
			public void onAnimationRepeat(Animation animation) {}
			public void onAnimationStart(Animation animation) {}				
		});		
	}
	private AnimationSet createAnimationSet(){
		AnimationSet ans = new AnimationSet(false);	
		for(int x = 0; x<animationTypes.length; x++){
			Animation anim = AnimationUtils.loadAnimation(d, animationTypes[x]);
			ans.addAnimation(anim);
		}
		return ans;
	}
}
