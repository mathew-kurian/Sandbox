package mk.universityoftexas.austin;

import java.util.ArrayList;

import org.json.JSONObject;

import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

public class Blog_Download extends ThreadWorker {

	ArrayList<JSONObject> c = null;
	int action;
	String downloadID = new String(AVE.BLOG_RSS);
	
	public Blog_Download(int a){
		super();
		action = a;
	} 	
	@Override
	public void preExecute() throws Exception{
		AVE.CURRENT.setProgressRESET();
		((TextView) AVE.CURRENT.findViewById(R.id.blog_update)).setVisibility(View.INVISIBLE);
	}
	@Override
	public void background() throws Exception{	
		publishProgress();
		c = XML_NEWS_BLOG.getNewsRSS(downloadID, XML_NEWS_BLOG.CONTENT_FORMAT_HTML_ONLY, action);
		publishProgress();
	}
	@Override
	public void postExecute() throws Exception{
		AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);
		((LinearLayout) AVE.CURRENT.findViewById(R.id.blog_scroll_layout)).removeAllViews();
		for(int x = 0; x<c.size(); x++){        		
			BlogArticle ba = new BlogArticle((Blog) AVE.CURRENT, c.get(x));
			((LinearLayout) AVE.CURRENT.findViewById(R.id.blog_scroll_layout)).addView(ba.getFormattedArticle());
		}
		
		((TextView) AVE.CURRENT.findViewById(R.id.blog_update)).setVisibility(View.VISIBLE);
		c.removeAll(c);
		c = null;
	}
	@Override
	public void onProgressUpdate() throws Exception{
		AVE.CURRENT.setProgressINCREMENT(1);
	}
	@Override
	public void onError(Method m){
		Log.d("Blog_Download", "Error dected", "red");
	} 

}