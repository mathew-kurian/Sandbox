package mk.universityoftexas.austin;

import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import mk.universityoftexas.austin.R;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class MainNews_Download extends ThreadWorker {

	private int START = 0;
	private int END = 0;	
	private String x = "";
	
	@Override
	public void background() throws Exception {		
		publishProgress();
		x = AVE.fetchURLData("http://www.utexas.edu");
		x = x.substring(x.indexOf("<div class=\"view-content slideshow-div\">"));

		for(int y = 0; y < AVE.NEWS_COUNT; y++){
			START = x.indexOf("<img src=\"");
			x = x.substring(START);
			START = x.indexOf("\"")+1;
			x = x.substring(START);
			END = x.indexOf("\"");

			String TEMP = new String("http://www.utexas.edu" + x.substring(0, END));

			switch(y){
			case 0: AVE.NEWS_IMG_SOURCE_1 = TEMP;
			AVE.NEWS_DOWNLOADED_IMAGE_1 = AVE.downloadImage(TEMP);
			AVE.NEWS_DOWNLOADED_IMAGE_1 = AVE.imageBlender(AVE.NEWS_DOWNLOADED_IMAGE_1,
					(BitmapDrawable)((Main) AVE.MAIN).getResources().getDrawable(R.drawable.img_overlay_1),
					PorterDuff.Mode.MULTIPLY);
			AVE.NEWS_DOWNLOADED_IMAGE_1.setAntiAlias(true);
			break;
			case 1: AVE.NEWS_IMG_SOURCE_2 = TEMP;
			AVE.NEWS_DOWNLOADED_IMAGE_2 = AVE.downloadImage(TEMP);
			AVE.NEWS_DOWNLOADED_IMAGE_2 = AVE.imageBlender(AVE.NEWS_DOWNLOADED_IMAGE_2,
					(BitmapDrawable)((Main) AVE.MAIN).getResources().getDrawable(R.drawable.img_overlay_1),
					PorterDuff.Mode.MULTIPLY);
			AVE.NEWS_DOWNLOADED_IMAGE_2.setAntiAlias(true);
			break; 
			case 2:	AVE.NEWS_IMG_SOURCE_3 = TEMP;
			AVE.NEWS_DOWNLOADED_IMAGE_3 = AVE.downloadImage(TEMP);
			AVE.NEWS_DOWNLOADED_IMAGE_3 = AVE.imageBlender(AVE.NEWS_DOWNLOADED_IMAGE_3,
					(BitmapDrawable)((Main) AVE.MAIN).getResources().getDrawable(R.drawable.img_overlay_1),
					PorterDuff.Mode.MULTIPLY);
			AVE.NEWS_DOWNLOADED_IMAGE_3.setAntiAlias(true);
			break; 
			case 3:	AVE.NEWS_IMG_SOURCE_4 = TEMP;
			AVE.NEWS_DOWNLOADED_IMAGE_4 = AVE.downloadImage(TEMP);
			AVE.NEWS_DOWNLOADED_IMAGE_4 = AVE.imageBlender(AVE.NEWS_DOWNLOADED_IMAGE_4,
					(BitmapDrawable)((Main) AVE.MAIN).getResources().getDrawable(R.drawable.img_overlay_1),
					PorterDuff.Mode.MULTIPLY);
			AVE.NEWS_DOWNLOADED_IMAGE_4.setAntiAlias(true);
			break; 
			}

			x = x.substring(START);
			START = x.indexOf("alt=\"");
			x = x.substring(START);
			START = x.indexOf("\"")+1;
			x = x.substring(START);
			END = x.indexOf("\"");		  

			switch(y){
			case 0: AVE.NEWS_TITLE_1 = x.substring(0, END);
			break;
			case 1: AVE.NEWS_TITLE_2 = x.substring(0, END);
			break; 
			case 2:	AVE.NEWS_TITLE_3 = x.substring(0, END);
			break; 
			case 3:	AVE.NEWS_TITLE_4 = x.substring(0, END);
			break; 
			}

			x = x.substring(END);		  		  
			START = x.indexOf("<div class=\"views-field-body\">");
			x = x.substring(START);		  
			START = x.indexOf("<div class=\"field-content\">");
			x = x.substring(START);
			START = x.indexOf("\">")+2;
			x = x.substring(START);
			END = x.indexOf("</");

			switch(y){
			case 0: AVE.NEWS_DETAILS_1 = x.substring(0, END);	
			break;
			case 1: AVE.NEWS_DETAILS_2 = x.substring(0, END);	
			break; 
			case 2:	AVE.NEWS_DETAILS_3 = x.substring(0, END);	
			break; 
			case 3:	AVE.NEWS_DETAILS_4 = x.substring(0, END);	
			break; 
			}
		}

	}
	@Override
	public void postExecute() throws Exception {
		((Main) AVE.MAIN).setProgressVISIBILITY(View.INVISIBLE);
		((Main) AVE.MAIN).setNews((TextView) ((Main) AVE.MAIN).findViewById(R.id.home_news_1), AVE.NEWS_DOWNLOADED_IMAGE_1, AVE.NEWS_DETAILS_1);
	}
	@Override
	public void onProgressUpdate() throws Exception {
		((Main) AVE.MAIN).setProgressINCREMENT(1);		
	}
	@Override
	public void onError(Method m) {
		Log.d("NewsHTMLParser", "Error dected", "red");
	}
	@Override
	public void preExecute() throws Exception {
		((ImageView) ((Main) AVE.MAIN).findViewById(R.id.home_news_image)).setMinimumWidth(AVE.METRICS.widthPixels);
		((ImageView) ((Main) AVE.MAIN).findViewById(R.id.home_news_image)).setMinimumHeight((int)(AVE.METRICS.heightPixels/2.5));		
		
	}       
}