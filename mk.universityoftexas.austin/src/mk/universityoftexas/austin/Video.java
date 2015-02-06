package mk.universityoftexas.austin;

import java.util.ArrayList;

import mk.universityoftexas.austin.R;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.MediaController;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.VideoView;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.Handler;
import android.preference.PreferenceManager;

public class Video extends Driver {

	boolean hidden = false;
	boolean lock;

	Handler hnd = new Handler();
	Runnable rn;
	VideoView video;
	Uri ur;

	int lockCounter = 0;
	int pg = 1;

	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_VIDEO, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	protected Dialog onCreateDialog(int id){
		Dialog dialog = null;
		switch(id){
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.VIDEO, AVE.INSTRUCTION_PREF_VIDEO, InstructionDialog.LANDSCAPE, R.drawable.instruction_video){
				@Override
				public void onDismiss(View v) {}    				
			}.getDialog();
			break;
		}
		AVE.setDialogWindowConfigurations(dialog);
		return dialog;
	}
	@Override
	public int setLayout() {
		return R.layout.video;
	}
	@Override
	public void action() {
		video = (VideoView) findViewById(R.id.video_view);
		video.setOnTouchListener(new OnTouchListener(){

			public boolean onTouch(View v, MotionEvent event) {
				if(event.getX()<v.getWidth()/2){
					if(event.getAction() == MotionEvent.ACTION_DOWN){
						if(hidden){
							gallerySlideIn();
							gallerySlideOut(5000);
						}
						else
							gallerySlideOut(0);
					}
					return true;
				}else if(!hidden && event.getAction() == MotionEvent.ACTION_DOWN){
					gallerySlideOut(0);
					System.out.println("SHOWING MEDIACONTROLLER1");
					return true;
				}else if(hidden  && event.getAction() == MotionEvent.ACTION_DOWN){
					System.out.println("SHOWING MEDIACONTROLLER");
					return false;
				}
				else
					return true;

			}

		});        

		MediaController ctlr = new MediaController(this);
		ctlr.setBackgroundColor(Color.TRANSPARENT);
		ctlr.setMediaPlayer(video);

		video.setOnCompletionListener(new OnCompletionListener(){

			public void onCompletion(MediaPlayer arg0) {
				video.setVideoURI(ur);
				video.seekTo(1000);
			}

		});

		video.setOnPreparedListener(new OnPreparedListener(){

			public void onPrepared(MediaPlayer arg0) {
				video.start();
				((Video) AVE.CURRENT).showProgress_lock(false, null);

			}

		});
		video.setMediaController(ctlr);
		video.requestFocus();
		video.forceLayout();
		gallerySlideOut(2000);

		new Youtube_Download(pg).execute(); pg++;

		//    ur = Uri.parse("rtsp://v2.cache5.c.youtube.com/CiILENy73wIaGQmFUrQ_SK2uPRMYDSANFEgGUgZ2aWRlb3MM/0/0/0/video.3gp");
		//	video.setVideoURI(ur);		
	}
	@Override
	public int setProgressMAX() {		
		return 0;
	}
	@Override
	public void applyFont() {
		/*	AVE.applyPastelFont(this, ((TextView) findViewById(R.id.video_content_title)));
    	AVE.applyPastelFont(this, ((TextView) findViewById(R.id.video_favorites_title)));
    	AVE.applyPastelFont(this, ((TextView) findViewById(R.id.video_title)));*/
		AVE.applyPastelFont(this, ((TextView) findViewById(R.id.video_progress_text)));

	}
	public void modAVE(){
	}
	public void gallerySlideIn(){
		try{hnd.removeCallbacks(rn);} catch(NullPointerException npe){}
		if(hidden&&!lock){

			Animation SlideInLeft = AnimationUtils.loadAnimation(Video.this, R.anim.slideinleft);
			((LinearLayout) findViewById(R.id.video_gallery_slider)).setVisibility(View.VISIBLE);
			((LinearLayout) findViewById(R.id.video_gallery_slider)).startAnimation(SlideInLeft);
			Animation fadeIn = AnimationUtils.loadAnimation(Video.this, R.anim.fadeinimage);
			((RelativeLayout) findViewById(R.id.video_info)).setVisibility(View.VISIBLE);
			((RelativeLayout) findViewById(R.id.video_info)).startAnimation(fadeIn);
			((VideoScroll) findViewById(R.id.video_scroll)).setIsScrollable(true);
			hidden = false;
		}
	}
	public void gallerySlideOut(long time){
		try{hnd.removeCallbacks(rn);} catch(NullPointerException npe){}
		if(!hidden&&!lock){
			rn = new Runnable(){
				public void run() {
					try{
						((VideoScroll) findViewById(R.id.video_scroll)).setIsScrollable(false);
						Animation SlideOutLeft = AnimationUtils.loadAnimation(Video.this, R.anim.slideoutleft);
						((LinearLayout) findViewById(R.id.video_gallery_slider)).startAnimation(SlideOutLeft);
						((LinearLayout) findViewById(R.id.video_gallery_slider)).setVisibility(View.GONE);
						Animation fadeOut = AnimationUtils.loadAnimation(Video.this, R.anim.fadeoutimage);
						((RelativeLayout) findViewById(R.id.video_info)).startAnimation(fadeOut);
						((RelativeLayout) findViewById(R.id.video_info)).setVisibility(View.GONE);
						hidden = true;
					}catch(Exception e){
						AVE.CURRENT.toast("Error", 0);
						finish();
					}
				}
			};
			hnd.postDelayed(rn, time);
		}

	}
	public void addVideoLeaves(final ArrayList<String> input) throws NullPointerException{
		new QuickThreadWorker(){
			public void preExecute(){
				super.preExecute();
				AVE.CURRENT.setProgressVISIBILITY(View.VISIBLE);
			}
			public void run() {
				LinearLayout l = ((LinearLayout) (AVE.CURRENT.findViewById(R.id.video_gallery_layout)));
				for(int x = 0; x<input.size();x++){
					VideoLeaf v = new VideoLeaf(AVE.CURRENT);

					v.FAVORITED = input.get(x); x++;

					System.out.println(input.get(x));
					BitmapDrawable bmp = AVE.imageBlender( AVE.downloadImage(input.get(x)), (BitmapDrawable)getResources().getDrawable(R.drawable.video_play_overlay), PorterDuff.Mode.SCREEN);
					bmp = AVE.imageBlender( bmp, (BitmapDrawable)getResources().getDrawable(R.drawable.img_overlay_2), PorterDuff.Mode.MULTIPLY);

					v.setBackgroundDrawable(bmp);
					v.setPadding(2, 2, 2, 2);

					LinearLayout.LayoutParams rl_p = new LinearLayout.LayoutParams(
							LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);

					v.setLayoutParams(rl_p);

					l.addView(v);	x++;

					v.CONTENT = !input.get(x).equals("") ? input.get(x) : v.CONTENT; x++;
					v.TITLE = input.get(x); x++;

					v.VIDEO_URL = input.get(x); x++;

					if(x == 0)
						setVideo_Data(v.VIDEO_URL, v.CONTENT, v.FAVORITED, v.TITLE);
				}
				l.invalidate();			
			}    
			public void postExecute(){
				super.postExecute();
				AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);
			}
		}.execute();
	}
	public void setVideo_Data(String url, String content, String favorites, String title){
		((Video) AVE.CURRENT).showProgress_lock(true, "Loading video..");
		ur = Uri.parse(url);
		video.setVideoURI(ur);
		video.start();
		video.setOnErrorListener(new OnErrorListener(){

			public boolean onError(MediaPlayer mp, int what, int extra) {
				((Video) AVE.CURRENT).toast("Network error detected. Please try again later.", 5);
				((Video) AVE.CURRENT).finish();					
				return true;
			}

		});

		Log.d("Youtube", url);

		((TextView)this.findViewById(R.id.video_title)).setText(title);
		((TextView)this.findViewById(R.id.video_content)).setText(content);
		((TextView)this.findViewById(R.id.video_favorites)).setText(favorites); 	
	}
	public void showProgress_lock(boolean show, String msg){
		if(show) {
			((TextView) ((Video) AVE.CURRENT).findViewById(R.id.video_progress_text)).setText(msg);
			((Video) AVE.CURRENT).findViewById(R.id.video_progress_layout).setVisibility(View.VISIBLE);    		
			lock = true;
			lockCounter++;
		}
		else{
			lockCounter--;
			if(lockCounter <= 0){
				((Video) AVE.CURRENT).findViewById(R.id.video_progress_layout).setVisibility(View.GONE);
				lock = false;
				lockCounter = 0;
			}

		}
		System.out.println("lock: " + lockCounter);

	}
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
class VideoLeaf extends ImageView implements OnTouchListener, OnClickListener{

	public String CONTENT = "The youtube description field is empty.";
	public String VIDEO_URL = "";
	public String FAVORITED = "";
	public String TITLE = "";	

	public VideoLeaf(Context context) {
		super(context);
		setClickable(true);
		setOnClickListener(this);
		//	setOnTouchListener(this);
		// TODO Auto-generated constructor stub
	}
	public VideoLeaf(Context context, AttributeSet attrs) {
		super(context, attrs);
		setClickable(true);
		setOnClickListener(this);
		//	setOnTouchListener(this);
		// TODO Auto-generated constructor stub
	}
	public VideoLeaf(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		setClickable(true);
		setOnClickListener(this);
		//	setOnTouchListener(this);
		// TODO Auto-generated constructor stub
	}
	public boolean onTouch(View v, MotionEvent event) {
		if(event.getAction()== MotionEvent.ACTION_DOWN){
			((VideoLeaf) v).setAlpha(180);
		}if(event.getAction()== MotionEvent.ACTION_UP){
			//		((VideoLeaf) v).setAlpha(255);
		}

		invalidate();

		return false;
	}
	public void onClick(View v) {
		while(!((Video) AVE.CURRENT).hidden&&!((Video) AVE.CURRENT).lock){
			((VideoLeaf) v).setAlpha(15);
			((Video) AVE.CURRENT).setVideo_Data(VIDEO_URL, CONTENT, FAVORITED, TITLE);		
		}		
	}

}