package mk.universityoftexas.austin;

import android.os.AsyncTask;
import android.text.Html;
import mk.universityoftexas.austin.R;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

public class SportsNewsHTML_Download extends AsyncTask<Void, Void, Boolean> {
	
	String markerStart = "<!-- PARSER CONTENT MARKER START -->";
	String markerEnd = "<!-- PARSER CONTENT MARKER END -->";
	String originalHTML = "No Internet Connection";
	String outputHTML = "No Internet Connection";
	public SportsNewsHTML_Download(String url){
		super();
		originalHTML = url;
	}
    @Override
    protected void onPreExecute() {
    	((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setProgress(1);
    }
    @Override
    protected Boolean doInBackground(Void ... arg0) {    				
    	outputHTML = AVE.fetchURLData(originalHTML);		
    	outputHTML.substring(outputHTML.indexOf(markerStart)+markerStart.length(), outputHTML.indexOf(markerEnd));	
		return true;
    }
    @Override
    protected void onPostExecute(Boolean result) {
    	((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setProgress(2);    	
    	((TextView) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_text)).setText(Html.fromHtml(outputHTML));
    	((ProgressBar) ((Sports)AVE.CURRENT).newsDialog.findViewById(R.id.news_dialog_progressbar)).setVisibility(View.GONE);
    }       
}