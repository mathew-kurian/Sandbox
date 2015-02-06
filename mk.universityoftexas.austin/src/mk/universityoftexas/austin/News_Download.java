package mk.universityoftexas.austin;

import java.util.ArrayList;

import org.json.JSONObject;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class News_Download extends ThreadWorker {

	ArrayList<JSONObject> b = null;
	int action;
	String downloadId = new String(AVE.NEWSPAPER_RSS);
	
	public News_Download(int a){
		super();
		action = a;
	} 
	@Override
	public void postExecute() throws Exception {
		((LinearLayout) AVE.CURRENT.findViewById(R.id.newspaper_layout_horizontal)).removeAllViews();
		((LinearLayout) AVE.CURRENT.findViewById(R.id.newspaper_highlights_layout)).removeAllViews();		

		for(int x = 0; x<b.size(); x++){        		
			NewspaperHighlight nh = new NewspaperHighlight((Newspaper) AVE.CURRENT, b.get(x));
			((LinearLayout) AVE.CURRENT.findViewById(R.id.newspaper_layout_horizontal)).addView(nh.getFormattedArticle());
			((LinearLayout) AVE.CURRENT.findViewById(R.id.newspaper_highlights_layout)).addView(nh.getFormattedHighlight());
			publishProgress();
		}

		AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);
		b.removeAll(b);
		((TextView) AVE.CURRENT.findViewById(R.id.newspaper_update_text)).setText(XML_NEWS_BLOG.getLastUpdate(AVE.NEWSPAPER_RSS, ((Newspaper) AVE.CURRENT)));
		((ImageView) AVE.CURRENT.findViewById(R.id.newspaper_update_button)).setVisibility(View.VISIBLE);		
	}
	@Override
	public void onProgressUpdate() throws Exception {
		AVE.CURRENT.setProgressINCREMENT(1);		
	}
	@Override
	public void onError(Method m) {
		Log.d("News_Download", "Error dected", "red");		
	}
	@Override
	public void preExecute() throws Exception {
		AVE.CURRENT.setProgressRESET();
		((ImageView) AVE.CURRENT.findViewById(R.id.newspaper_update_button)).setVisibility(View.INVISIBLE);
	}
	@Override
	public void background() throws Exception {
		publishProgress();
		b = XML_NEWS_BLOG.getNewsRSS(downloadId, XML_NEWS_BLOG.CONTENT_FORMAT_HTML_ONLY, action);		
		publishProgress();
	} 

}