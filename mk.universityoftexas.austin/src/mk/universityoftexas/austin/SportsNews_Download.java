package mk.universityoftexas.austin;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

import android.text.Html;
import mk.universityoftexas.austin.R;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

public class SportsNews_Download extends ThreadWorker {
	
	String markerStart = "<!-- PARSER CONTENT MARKER START -->";
	String markerEnd = "<!-- PARSER CONTENT MARKER END -->";
	String originalHTML = "No Internet Connection";
	String outputHTML = "No Internet Connection";
	public SportsNews_Download(String url){
		super();
		originalHTML = url;
		Log.d("SportsNewsHTML_Download",originalHTML, "white");
	}
	@Override
	public void preExecute() throws Exception {
		((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setVisibility(View.VISIBLE);
    	((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setProgress(1);
    	((TextView) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_text)).setText("Receiving Data...");
		
	}
	@Override
	public void background() throws Exception {
		outputHTML = AVE.fetchURLData(originalHTML);
    	outputHTML.substring(outputHTML.indexOf(markerStart)+markerStart.length(), outputHTML.indexOf(markerEnd));	
		
	}
	@Override
	public void postExecute() throws Exception {		
		((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setProgress(2); 
    	((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setVisibility(View.GONE);
    	((TextView) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_text)).setText(Html.fromHtml(Jsoup.clean(outputHTML, Whitelist.basic())));		
	}
	@Override
	public void onProgressUpdate() throws Exception {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void onError(Method m) {
		Log.d("SportsNewsHTML_Download", "Error", "red");
		
	}       
}