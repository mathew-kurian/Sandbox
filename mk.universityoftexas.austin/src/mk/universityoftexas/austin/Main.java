package mk.universityoftexas.austin;

import mk.universityoftexas.austin.R;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;
import android.app.Dialog;
import android.graphics.drawable.BitmapDrawable;

public class Main extends Driver {	    	
	public void modAVE(){
		getWindowManager().getDefaultDisplay().getMetrics(AVE.METRICS);
		AVE.MAIN = this;
	}
	public void showInstructions(){
		if(SharedPreferences().getBoolean(AVE.INSTRUCTION_PREF_MAIN, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	public void onBackPressed(){
		super.onBackPressed();
		resetBrightness();
	}
	public void onClick(View target) {
		switch(target.getId()){
		case R.id.home_news_1: 					setNews((TextView) findViewById(R.id.home_news_1), AVE.NEWS_DOWNLOADED_IMAGE_1, AVE.NEWS_DETAILS_1); 	break;
		case R.id.home_news_2: 					setNews((TextView) findViewById(R.id.home_news_2), AVE.NEWS_DOWNLOADED_IMAGE_2, AVE.NEWS_DETAILS_2); 	break;
		case R.id.home_news_3: 					setNews((TextView) findViewById(R.id.home_news_3), AVE.NEWS_DOWNLOADED_IMAGE_3, AVE.NEWS_DETAILS_3);	break;
		case R.id.home_news_4: 					setNews((TextView) findViewById(R.id.home_news_4), AVE.NEWS_DOWNLOADED_IMAGE_4, AVE.NEWS_DETAILS_4);	break;
		case R.id.home_campus_life_button: 		startActivity(CampusLifeMenu.class);		break;
		case R.id.home_alerts_safety_button: 	startActivity(AlertsSafetyMenu.class);		break;
		case R.id.home_utacess_button: 			if(isOnline())startActivity(EID.class);
		else toast("Internet Required", 0); 			break;
		case R.id.home_blogs_button: 			if(isOnline())startActivity(BlogMenu.class);
		else toast("Internet Required", 0); 			break;
		case R.id.home_news_button: 			if(isOnline())startActivity(NewspaperMenu.class);
		else toast("Internet Required", 0);  			break;
		case R.id.home_sports_button: 			if(isOnline()) startActivity(SportsMenu.class);
		else toast("Internet Required", 0);  			break;
		case R.id.home_media_button: 			if(isOnline()) startActivity(Video.class);
		else toast("Internet Required", 0);  			break;
		}
	}
	public void setNews(TextView selector, BitmapDrawable bd, String details){
		if(!((TextView) findViewById(R.id.home_news_text)).getText().equals(details)){
			newsAlphaDefaulter();
			selector.setTextColor(0xFF000000);
			Animation fadeIn = AnimationUtils.loadAnimation(this, R.anim.fadeinimage);
			Animation fadeOut = AnimationUtils.loadAnimation(this, R.anim.fadeoutimage);
			((ImageView) findViewById(R.id.home_news_image)).startAnimation(fadeOut);
			((ImageView) findViewById(R.id.home_news_image)).setImageDrawable(bd);
			((ImageView) findViewById(R.id.home_news_image)).startAnimation(fadeIn);
			((TextView) findViewById(R.id.home_news_text)).setText(details);    		
		}
	}
	public void newsAlphaDefaulter(){
		((TextView) findViewById(R.id.home_news_1)).setTextColor(0x52000000);
		((TextView) findViewById(R.id.home_news_2)).setTextColor(0x52000000);
		((TextView) findViewById(R.id.home_news_3)).setTextColor(0x52000000);
		((TextView) findViewById(R.id.home_news_4)).setTextColor(0x52000000);
	}
	protected Dialog onCreateDialog(int id){
		Dialog dialog = null;
		switch(id){
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.MAIN, AVE.INSTRUCTION_PREF_MAIN, InstructionDialog.PORTRAIT){
				@Override
				public void onDismiss(View v) {
					toast("Too dark? Shake me...", 0);
				}    				
			}.getDialog();
			break;
		}
		AVE.setDialogWindowConfigurations(dialog);
		return dialog;
	}
	@Override
	public int setProgressMAX() {
		return 3;
	}
	@Override
	public int setLayout() {
		return R.layout.main;
	}
	@Override
	public void applyFont() {
		fontPastel(R.id.home_news_text);
		fontNewspaper(R.id.home_news_1);
		fontNewspaper(R.id.home_news_2);
		fontNewspaper(R.id.home_news_3);
		fontNewspaper(R.id.home_news_4);
	}
	@Override
	public void action() {		
		if(AVE.NEWS_DOWNLOADED_IMAGE_1!=null && AVE.NEWS_DOWNLOADED_IMAGE_2!=null && AVE.NEWS_DOWNLOADED_IMAGE_3!=null)	{	
			setNews((TextView) findViewById(R.id.home_news_1), AVE.NEWS_DOWNLOADED_IMAGE_1, AVE.NEWS_DETAILS_1);
			setProgressVISIBILITY(View.INVISIBLE);
			Log.d("Main", "Loaded daily news from memory");
		}else
			downloadNews();
		((ImageView) findViewById(R.id.home_news_image)).setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				showBrowser("http://www.utexas.edu");

			}
		});
		defaultAnimationEngine(500);
	}
	public void onResume(){
		super.onResume();
		if(AVE.NEWS_DOWNLOADED_IMAGE_1==null || AVE.NEWS_DOWNLOADED_IMAGE_2==null || AVE.NEWS_DOWNLOADED_IMAGE_3==null)
			downloadNews();			
	}
	@Override
	public void preAction() {}
	public void downloadNews(){
		new MainNews_Download().execute();
	}
	public void onPause(){
		super.onPause();
		resetBrightness();	
	}
	@Override
	public int[] animationTypes() {
		return new int [] {R.anim.fastfadein};
	}
	@Override
	public int[] toAnimate() {
		return new int [] {R.id.home_utacess_button, R.id.home_blogs_button, R.id.home_news_button, R.id.home_sports_button, R.id.home_media_button, R.id.home_campus_life_button, R.id.home_alerts_safety_button};
	}
}