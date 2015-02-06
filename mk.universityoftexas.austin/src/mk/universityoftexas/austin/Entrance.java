package mk.universityoftexas.austin;


import java.util.Calendar;

import android.os.AsyncTask;
import android.os.Handler;
import android.text.InputFilter;
import android.text.Spanned;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Button;
import mk.universityoftexas.austin.EIDConstants.Event;
import mk.universityoftexas.austin.EIDConstants.StatusCode;
import mk.universityoftexas.austin.R;

public class Entrance extends Driver {
	protected boolean _active = true;
	protected Entrance_Login el;
	@Override
	public int setLayout() {
		return R.layout.entrance;
	}
	public void onBackPressed(){
		super.onBackPressed();
		resetBrightness();
	}
	public void onClick(View target){
		switch(target.getId()){
		case R.id.entrance_cancel_skip:
			if(((Button) findViewById(R.id.entrance_cancel_skip)).getText() == "Cancel"){
				el.cancel(true);
				if(el.getCurrentThread() != ThreadWorker.Method.POSTEXECUTE)
					showLoginFromProgress();
			}else if(((Button) findViewById(R.id.entrance_cancel_skip)).getText() == "Skip"){
				if(el!=null)	el.cancel(true);
				AVE.CURRENT.toast("Entering offline mode", 1);
				((Entrance) AVE.CURRENT).goMain();
			}break;
		case R.id.entrance_button:
			if(el==null){
				loginThread();
			}else if(el.getStatus() == AsyncTask.Status.FINISHED || el.isCancelled()){
				loginThread();
			}	break;

		}
	}
	@Override
	public void action() {
		((Button) findViewById(R.id.entrance_cancel_skip)).setText("Skip");

		InputFilter filter = new InputFilter() {
			
			public CharSequence filter(CharSequence source, int start, int end,
					Spanned dest, int dstart, int dend) {
				for (int i = start; i < end; i++) {
					if (Character.isSpaceChar(source.charAt(i))) {
						return "";
					}
				}
				return null;
			}
		};
		
		((EditText) findViewById(R.id.entrance_eid)).setFilters(new InputFilter[] { filter });
			

		((CheckBox) findViewById(R.id.entrance_remember)).setChecked(EIDManager.getRemember());
		if(EIDManager.getRemember()){
			((EditText) findViewById(R.id.entrance_eid)).setText(EIDManager.getUsername());
			((EditText) findViewById(R.id.entrance_password)).setText(EIDManager.getPassword());
		}

		showLogin(1000);
	}
	public void loginThread(){
		String user = ((EditText) findViewById(R.id.entrance_eid)).getText().toString();
		String pass = ((EditText) findViewById(R.id.entrance_password)).getText().toString();
		EIDManager.setRemember(((CheckBox) findViewById(R.id.entrance_remember)).isChecked());
		if(EIDManager.getRemember()){
			EIDManager.setUsername(user);
			EIDManager.setPassword(pass);
		}else{
			EIDManager.setUsername("uteid");
			EIDManager.setPassword("password");
		}

		el = new Entrance_Login(user, pass);
		el.execute();
	}
	public void showLogin(int time){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					findViewById(R.id.entrance_logo).setVisibility(View.VISIBLE);

					final Animation fadeIn1 = AnimationUtils.loadAnimation(Entrance.this, R.anim.fadeinforms);
					final Animation slideTop = AnimationUtils.loadAnimation(Entrance.this, R.anim.slidetop);
					final Animation fadeIn2 = AnimationUtils.loadAnimation(Entrance.this, R.anim.fadeinforms);

					fadeIn1.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							findViewById(R.id.entrance_logo).startAnimation(slideTop);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});
					slideTop.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							findViewById(R.id.entrance_form_layout).setVisibility(View.VISIBLE);
							findViewById(R.id.entrance_form_layout).startAnimation(fadeIn2);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});				

					findViewById(R.id.entrance_logo).startAnimation(fadeIn1);
				}catch(Exception e){}
			}
		};
		hnd.postDelayed(r, time);
	}
	public void slideCancelSkipButton(final String text){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){				
				try{
					final Animation slideOut = AnimationUtils.loadAnimation(Entrance.this, R.anim.slideoutleft_entrance);
					final Animation slideIn = AnimationUtils.loadAnimation(Entrance.this, R.anim.slideinright_entrance);	

					slideOut.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							((TextView) findViewById(R.id.entrance_cancel_skip)).setText(text);
							findViewById(R.id.entrance_cancel_skip).startAnimation(slideIn);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});		

					findViewById(R.id.entrance_cancel_skip).startAnimation(slideOut);
				}catch(Exception e){}
			}
		};
		hnd.post(r);
	}
	public void showLoginFromProgress(){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					slideCancelSkipButton("Skip");

					findViewById(R.id.entrance_logo).setVisibility(View.VISIBLE);

					final Animation slideTop = AnimationUtils.loadAnimation(Entrance.this, R.anim.slidetop);
					final Animation fadeIn1 = AnimationUtils.loadAnimation(Entrance.this, R.anim.fadeinforms);

					slideTop.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							findViewById(R.id.entrance_form_layout).setVisibility(View.VISIBLE);
							findViewById(R.id.entrance_form_layout).startAnimation(fadeIn1);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});				

					findViewById(R.id.entrance_logo).startAnimation(slideTop);
				}catch(Exception e){}
			}
		};
		hnd.post(r);
	}
	public void showProgress(){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					slideCancelSkipButton("Cancel");

					final Animation fadeOut = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fadeoutforms);
					final Animation slideDown = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.slidedown);		
					final Animation rotate = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.rotateinfinite);

					fadeOut.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							findViewById(R.id.entrance_form_layout).setVisibility(View.GONE);
							findViewById(R.id.entrance_logo).startAnimation(slideDown);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});
					slideDown.setAnimationListener(new AnimationListener(){
						public void onAnimationEnd(Animation animation) {
							findViewById(R.id.entrance_logo).startAnimation(rotate);
						}
						public void onAnimationRepeat(Animation animation) {}
						public void onAnimationStart(Animation animation) {}			
					});

					findViewById(R.id.entrance_form_layout).startAnimation(fadeOut);
				}catch(Exception e){}
			}
		};
		hnd.post(r);
	}
	public void goMain(){
		_active = false;
		finish();
		startActivity(Main.class);	
	}
	@Override
	public void modAVE() {}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {
		fontPastel(R.id.entrance_eid);
	}
	@Override
	public void showInstructions() {}
	@Override
	public void preAction() {}
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
class Entrance_Login extends ThreadWorker{

	private String _user = "";
	private String _pass = "";

	public Entrance_Login(String user, String pass){
		_user= user;
		_pass = pass;
	}
	@Override
	public void preExecute() throws Exception {
		((Entrance) AVE.CURRENT).showProgress();
	}
	@Override
	public void background() throws Exception {
		Thread.sleep(2000);
		if(AVE.CURRENT.isOnline())
			EIDManager.login(_user, _pass);
		else
			AutheticationReader.forceType(Event.LOGIN, StatusCode.CONNECTIVITY_ERROR);
	}
	@Override
	public void postExecute() throws Exception {
		new AutheticationListener(EIDConstants.Event.LOGIN){
			@Override
			public void onSuccess() {
				((Entrance) AVE.CURRENT).goMain();
				int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
				StringBuilder message = new StringBuilder();
				if (hour >=0 && hour < 4)
					message.append("Little late there ");
				else if(hour >= 4 && hour < 11)
					message.append("Good Morning");
				else if(hour >= 11 && hour < 15)
					message.append("Good Afternoon");
				else if(hour >= 15 && hour < 24)
					message.append("Good Evening");

				message.append(" " + EIDManager.fullName);
				AVE.CURRENT.toast(message.toString(), 1);	
			}
			@Override
			public void onFailure(StatusCode error) throws Exception {
				AVE.CURRENT.toast("Try again. " + error.toString(), 0);
				((Entrance) AVE.CURRENT).showLoginFromProgress();					
			}	
		};	
	}
	@Override
	public void onProgressUpdate() throws Exception {}
	@Override
	public void onError(Method m) {}

}







/*
	if (!facebook.isSessionValid()) {           facebook.authorize(this, new String[] {"user_groups","publish_stream", "friends_groups"}, new DialogListener(){

		public void onComplete(Bundle values) {
			//		postMessageOnWall("App Test --- ");
			getFeeds();
			Log.d("facebook", "here", "WHITE");
		}

		public void onFacebookError(FacebookError e) {
			// TODO Auto-generated method stub

		}

		public void onError(DialogError e) {
			// TODO Auto-generated method stub

		}

		public void onCancel() {
			// TODO Auto-generated method stub

		}

	});       }
	//	getFeeds();
	Log.d("facebook", "here", "WHITE");
}
/*	public void postMessageOnWall(String msg) { 
	Bundle parameters = new Bundle(); 
	parameters.putString("message", msg); 
	try { 
		String response = facebook.request("192948457308/feed", parameters,"POST"); 
		Log.d("Error", response); 
	} catch (IOException e) { 
		Log.d("Error", e.toString()); 
	} 
}
/*	public void getFeeds(){
	JSONObject response;
	try {
		response = Util.parseJson(facebook.request("192948457308/feed"));
		JSONArray jDataArray = response.getJSONArray("data");
		for(int i=0;i<jDataArray.length();i++){
			JSONObject jDataObject = jDataArray.getJSONObject(i);
			if(jDataObject.has("message")){          			
				String message=jDataObject.getString("message");
				Log.d("STATUS", message);
			}
			if(jDataObject.has("comments")){
				if(jDataObject.getJSONObject("comments").getInt("count")>0){
					JSONArray jCommentArray = jDataObject.getJSONObject("comments").getJSONArray("data");
					for(int x = 0; x<jCommentArray.length();x++){
						JSONObject jCommentObject = jCommentArray.getJSONObject(x);
						if(jCommentObject.has("message")){          			
							String message=jCommentObject.getString("message");
							Log.d("COMMENT", message);
						}
					}
				}
			}
		}
	} catch (MalformedURLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (JSONException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (FacebookError e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}*/