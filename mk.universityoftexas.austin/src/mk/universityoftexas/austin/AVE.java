package mk.universityoftexas.austin;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Calendar;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.hardware.Sensor;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

public abstract class AVE {
	
	public static final String FACEBOOK_ID = "154416121337236";
		
	public static boolean lightDefaultCheck = false;
	public static int lightDefaultMode = 0;
	public static float lightDefaultBrightness = 0.5f;
	public static boolean lightOn = false;
	
	public static Sensor shakeSensor;
	public static long lastUpdate;
	public static float last_x;
	public static float last_y;
	public static float last_z;
	
	public static final int NEWS_COUNT = 4;
	
	public static Driver CURRENT;
	public static Main MAIN;
	
	public static DisplayMetrics METRICS = new DisplayMetrics();
	
	public static BitmapDrawable NEWS_DOWNLOADED_IMAGE_1 = null;
	public static BitmapDrawable NEWS_DOWNLOADED_IMAGE_2 = null;
	public static BitmapDrawable NEWS_DOWNLOADED_IMAGE_3 = null;
	public static BitmapDrawable NEWS_DOWNLOADED_IMAGE_4 = null;
	
	public static String NEWS_IMG_SOURCE_1 = "No Internet Connection";
	public static String NEWS_DETAILS_1 = "Please check if 3G/4G is enabled.";
	public static String NEWS_TITLE_1 = "Please check if 3G/4G is enabled.";
	
	public static String NEWS_IMG_SOURCE_2 = "No Internet Connection";
	public static String NEWS_DETAILS_2 = "Please check if 3G/4G is enabled.";
	public static String NEWS_TITLE_2 = "Please check if 3G/4G is enabled.";
	
	public static String NEWS_IMG_SOURCE_3 = "No Internet Connection";
	public static String NEWS_DETAILS_3 = "Please check if 3G/4G is enabled.";
	public static String NEWS_TITLE_3 = "Please check if 3G/4G is enabled.";
	
	public static String NEWS_IMG_SOURCE_4 = "No Internet Connection";
	public static String NEWS_DETAILS_4 = "Please check if 3G/4G is enabled.";
	public static String NEWS_TITLE_4 = "Please check if 3G/4G is enabled.";
	
	public static final int CREATE_SCORE_TEXT = 0x56;
	public static final int CREATE_DATE_TEXT = 0x57;
	public static final int CREATE_TEAM_TEXT = 0x58;
	public static final int CREATE_EVENT_TEXT = 0x59;
	public static final int CREATE_LOCATION_TEXT = 0x60;	
	public static final int CREATE_NAME_TEXT = 0x61;
	public static final int CREATE_POSITION_TEXT = 0x62;
	public static final int CREATE_NUMBER_TEXT = 0x63;
	public static final int CREATE_TITLE_TEXT = 0x64;
	
	public static final int SPORTS_MENU_PROGRESS_DIALOG_ID = 0x014564;			
	public static final int SPORTS_ROSTER_DIALOG_ID = 0x0112;
	public static final int SPORTS_NEWS_DIALOG_ID = 0x01212;
	
	public static final int INSTRUCTION_DIALOG_ID = 0x125481;				
	public static final int ALERTS_CALL_DIALOG_ID = 0x4561;
	public static final int NEWSPAPER_DIALOG_ID = 0x445871;
	
	public static String CAMPUS_LIFE_WEB_URL = null;
	public static String NEWSPAPER_WEB_URL = null;
	public static String BLOG_WEB_URL = null;
	
	public static int LightingLayoutX = 0;
	public static int LightingLayoutY = 0;
	
	public static final String j = "Jesus is Savior!";
	
	public static final String INSTRUCTION_PREF_MAIN = "mainInstruct";
	public static final String INSTRUCTION_PREF_SPORTS_MENU = "spmInstruct";
	public static final String INSTRUCTION_PREF_SPORTS = "spInstruct";
	public static final String INSTRUCTION_PREF_CAMPUS_LIFE_MENU = "clmInstruct";
	public static final String INSTRUCTION_PREF_CAMPUS_LIFE_WEB = "clbInstruct";
	public static final String INSTRUCTION_PREF_ALERTS_SAFETY_MENU = "asmInstruct";
	public static final String INSTRUCTION_PREF_VIDEO = "vidInstruct";
	public static final String INSTRUCTION_PREF_NEWSPAPER = "newsInstruct";
	public static final String INSTRUCTION_PREF_NEWSPAPER_WEB = "newswebInstruct";
	public static final String INSTRUCTION_PREF_BLOG = "blogInstruct";
	
	public static final String LOGIN_REMEMBER = "loginRemember";
	public static final String LOGIN_USER = "loginUser";
	public static final String LOGIN_PASSWORD = "loginPass";
	
	public static String NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.AtTexas;
	public static String BLOG_RSS = XML_NEWS_BLOG.RSS.FreeMindsProject;
	public static String SPORT = HTML_SPORT.SPORTS.Football;
	
	public static Typeface PASTEL_FONT = null;
	public static Typeface NEWS_FONT = null;
		
	public static BitmapDrawable h1 = null;
	public static BitmapDrawable h2 = null;
	public static BitmapDrawable h3 = null;
	public static BitmapDrawable h4 = null;
	public static BitmapDrawable h5 = null;
	public static BitmapDrawable h6 = null;

	public static Bitmap LIGHTING_PORTRAIT;
	public static Bitmap LIGHTING_LANDSCAPE;
	
	public static Display dis;
	
	public static void setHighlightBitmaps(Context c){
		if(h1 == null) h1 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight0);
		if(h2 == null) h2 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight1);
		if(h3 == null) h3 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight2);
		if(h4 == null) h4 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight3);
		if(h5 == null) h5 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight4);
		if(h6 == null) h6 = (BitmapDrawable) c.getResources().getDrawable(R.drawable.text_button_highlight5);
	}
	public static void createLighting(Context c){		
		if(LIGHTING_PORTRAIT==null && LIGHTING_LANDSCAPE==null){
			int height = c.getResources().getDisplayMetrics().heightPixels;
			int width = c.getResources().getDisplayMetrics().widthPixels;			
			LIGHTING_PORTRAIT = ((BitmapDrawable) c.getResources().getDrawable(R.drawable.lighting_portrait)).getBitmap();
			LIGHTING_PORTRAIT = Bitmap.createScaledBitmap(LIGHTING_PORTRAIT, width, height, false);
			Matrix matrix = new Matrix();
	        matrix.postRotate(90);
			LIGHTING_LANDSCAPE = Bitmap.createBitmap(LIGHTING_PORTRAIT, 0, 0, width, height, matrix, false);
			
			Log.d("Lighting", "Developed shader", "purple");
		}		
	}
	@SuppressWarnings({ "static-access"})
	public static int getOrientation(Context c){
		if(dis == null) dis = ((WindowManager) c.getSystemService(c.WINDOW_SERVICE)).getDefaultDisplay();
		return dis.getOrientation();
	}
	public static BitmapDrawable resize(BitmapDrawable bd, int newWidth, int newHeight){
    	Bitmap orig = bd.getBitmap();
    	
    	int width = orig.getWidth();
        int height = orig.getHeight();
        
        float scaleWidth = ((float) newWidth) / width;
        float scaleHeight = ((float) newHeight) / height;
        
        Matrix matrix = new Matrix();
        matrix.postScale(scaleWidth, scaleHeight);
        
    	return new BitmapDrawable(Bitmap.createBitmap(orig, 0, 0, 
    			width, height, matrix, true));    	
    }
	public static BitmapDrawable downloadImage(String toDownload){
        URL url = null;        
        InputStream in  = null;
        BufferedInputStream buf  = null;
        
     /*   BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        options.inDither = false;
        options.inScaled = false;
        options.inPreferredConfig = Bitmap.Config.RGB_565;
        options.inSampleSize = 8;
        */
        try {
            url = new URL(toDownload);
            in = url.openStream();
            buf = new BufferedInputStream(in);
            Bitmap bMap = BitmapFactory.decodeStream(buf);
            if (in != null)		in.close();           
            if (buf != null)	buf.close();
                        return new BitmapDrawable(bMap);

        } catch (Exception e) {
        	Log.d("Error downloading image", e.toString());
        }
  
        return null;
    }
	public static String fetchURLData(String URL){
		URL url = null;
		try {
			url = new URL(URL);
		} catch (MalformedURLException e) {
			Log.d("Error reading url (A)", URL);
		}
		
		BufferedReader in  = null;
		try {
			in = new BufferedReader(
			        new InputStreamReader(
			        		url.openStream()));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String inputLine = "";
		String x = "";
		
		try {
			while ((inputLine = in.readLine()) != null){
				  x = x + inputLine;
			}
		} catch (IOException e) {
			Log.d("Error reading url (B)", e.toString());
		} 		
		  
		try {
			in.close();
		} catch (IOException e) {
			Log.d("Error reading url (C)", e.toString());
		}
		
		return x;
	}
	public static BitmapDrawable imageBlender(BitmapDrawable orig, BitmapDrawable top, PorterDuff.Mode md) 
	{ 	Bitmap bmp1 = orig.getBitmap();	Bitmap bmp2 = top.getBitmap();
		Bitmap bmOverlay = Bitmap.createBitmap(bmp1.getWidth(), bmp1.getHeight(), bmp1.getConfig()); 
	    Canvas canvas = new Canvas(bmOverlay); 
	    Paint p = new Paint();
        p.setAntiAlias(true);
        p.setXfermode(new PorterDuffXfermode(md));
	    canvas.drawBitmap(bmp1, 0, 0, null);
	    canvas.drawBitmap(bmp2, bmp1.getWidth()/2 - bmp2.getWidth()/2, bmp1.getHeight()/2 - bmp2.getHeight()/2, p);
	    return new BitmapDrawable(bmOverlay); 
	} 
	public static void applyPastelFont(Context c, View v) {
		if(PASTEL_FONT==null)
			PASTEL_FONT = Typeface.createFromAsset(c.getAssets(),"fonts/pastel.ttf");
		
		if(v instanceof TextView)	((TextView) v).setTypeface(PASTEL_FONT);
		if(v instanceof Button)		((Button) v).setTypeface(PASTEL_FONT);
		if(v instanceof EditText)	((EditText) v).setTypeface(PASTEL_FONT);
		if(v instanceof CheckBox)	((CheckBox) v).setTypeface(PASTEL_FONT);
	}
	public static void applyNewsFont(Context c, View v) {
		if(NEWS_FONT==null)
			NEWS_FONT = Typeface.createFromAsset(c.getAssets(),"fonts/newspaper.ttf");
		
		if(v instanceof TextView)	((TextView) v).setTypeface(NEWS_FONT);
		if(v instanceof Button)		((Button) v).setTypeface(NEWS_FONT);
		if(v instanceof EditText)	((EditText) v).setTypeface(NEWS_FONT);
		if(v instanceof CheckBox)	((CheckBox) v).setTypeface(NEWS_FONT);
		
	}
	public static void setDialogWindowConfigurations(Dialog d){		
		    WindowManager.LayoutParams lp = d.getWindow().getAttributes();
		    lp.dimAmount=0.8f;
		    d.getWindow().setAttributes(lp);
		    d.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
	}
	@SuppressWarnings("static-access")
	public static String getDate(){
		return Integer.toString(Calendar.getInstance().DAY_OF_MONTH)+
				"/" + Integer.toString(Calendar.getInstance().MONTH) + 
				"/" + Integer.toString(Calendar.getInstance().YEAR);
	}
	public static int getDip(Context c, int x){
		return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 
                (float) x, c.getResources().getDisplayMetrics());
	}
    public static void dumpEvent(MotionEvent event) {
 	   String names[] = { "DOWN" , "UP" , "MOVE" , "CANCEL" , "OUTSIDE" ,
 	      "POINTER_DOWN" , "POINTER_UP" , "7?" , "8?" , "9?" };
 	   StringBuilder sb = new StringBuilder();
 	   int action = event.getAction();
 	   int actionCode = action & MotionEvent.ACTION_MASK;
 	   sb.append("event ACTION_" ).append(names[actionCode]);
 	   if (actionCode == MotionEvent.ACTION_POINTER_DOWN
 	         || actionCode == MotionEvent.ACTION_POINTER_UP) {
 	      sb.append("(pid " ).append(
 	      action >> MotionEvent.ACTION_POINTER_ID_SHIFT);
 	      sb.append(")" );
 	   }
 	   sb.append("[" );
 	   for (int i = 0; i < event.getPointerCount(); i++) {
 	      sb.append("#" ).append(i);
 	      sb.append("(pid " ).append(event.getPointerId(i));
 	      sb.append(")=" ).append((int) event.getX(i));
 	      sb.append("," ).append((int) event.getY(i));
 	      if (i + 1 < event.getPointerCount())
 	         sb.append(";" );
 	   }
 	   sb.append("]" );
 	   Log.d("AVE Dump", sb.toString(), "Yellow");
 	}
}
