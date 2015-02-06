package mk.universityoftexas.austin;

import java.util.ArrayList;

import android.view.View;

public class Sports_Download extends ThreadWorker{

	int action;
	ArrayList<String> _news;
	ArrayList<String> _roster;
	ArrayList<String> _schedule;
	ArrayList<String> _scores;
	String currentDownloadID = new String(AVE.SPORT);
	
	public Sports_Download(int x){
		super();
		this.action = x;
	}	
	@Override
	public void preExecute() throws Exception {
		AVE.CURRENT.findViewById(R.id.refresh).setVisibility(View.INVISIBLE);
		AVE.CURRENT.setProgressRESET();		
	}
	@Override
	public void background() throws Exception {
		publishProgress();
		_news = HTML_SPORT.getData(currentDownloadID, HTML_SPORT.CONTENT_NEWS, action);
		publishProgress();
		_roster = HTML_SPORT.getData(currentDownloadID, HTML_SPORT.CONTENT_ROSTER, action);
		publishProgress();
		_schedule = HTML_SPORT.getData(currentDownloadID, HTML_SPORT.CONTENT_SCHEDULE, action);
		publishProgress();
		_scores = HTML_SPORT.getData(currentDownloadID, HTML_SPORT.CONTENT_SCORES, action);	
		publishProgress();
				
		try {((Sports) AVE.CURRENT).createNewsLeaves(_news); }
		catch(Exception e){
			((Sports) AVE.CURRENT).toast("News creation error", 0);
		}
		publishProgress();
		try {((Sports) AVE.CURRENT).createScoreLeaves(_scores); }
		catch(Exception e){
			((Sports) AVE.CURRENT).toast("Scores creation error", 0);
		}
		publishProgress();
		try {((Sports) AVE.CURRENT).createRosterLeaves(_roster); }
		catch(Exception e){
			((Sports) AVE.CURRENT).toast("Roster creation error", 0);
		}
		publishProgress();
		try {((Sports) AVE.CURRENT).createScheduleLeaf(_schedule); }
		catch(Exception e){
			((Sports) AVE.CURRENT).toast("Schedule creation error", 0);
		}
		publishProgress();
	}
	@Override
	public void postExecute() throws Exception {
		AVE.CURRENT.findViewById(R.id.refresh).setVisibility(View.VISIBLE);
		AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);
		if(AVE.SPORT.equals(currentDownloadID)) ((Sports) AVE.CURRENT).updateFromCache(HTML_SPORT.CONTENT_SCORES, true);
	}

	@Override
	public void onProgressUpdate() throws Exception {
		AVE.CURRENT.setProgressINCREMENT(1);
	}

	@Override
	public void onError(Method m) {
		AVE.CURRENT.toast("Error", 0);
	}
	
}

