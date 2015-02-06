package mk.universityoftexas.austin;

import java.util.ArrayList;

import android.os.AsyncTask;
import android.widget.RelativeLayout;
import android.widget.Toast;

public class SportsHTML_Prefetch extends AsyncTask<Void, Void, Boolean>{
	int SPORT = 0;
	boolean prefetchScores = true;
	boolean prefetchNews = true;
	boolean prefetchSchedule = false;
	boolean prefetchRoster = true;
	boolean singleUpdate = false;
	String errors = "";
	public SportsHTML_Prefetch(int toPrefetch){
		super();
		SPORT = (SPORT==0) ? toPrefetch : SPORT;
	}
	public SportsHTML_Prefetch(int toPrefetch, boolean prefetch_forced){
		this(toPrefetch);
		singleUpdate = prefetch_forced;
	}
	@Override
	protected void onPreExecute() {
//		if(singleUpdate)	((ProgressBar) AVE.SPORTS_SINGLE_UPDATE.findViewById(R.id.progress_bar)).setProgress(1);
	}
	@Override
	protected Boolean doInBackground(Void... params) {
		if(prefetchScores)	developPrefetch(SPORT, AVE.HTML_SCORE);
		if(prefetchRoster)	developPrefetch(SPORT, AVE.HTML_ROSTER);
		if(prefetchNews)	developPrefetch(SPORT, AVE.HTML_NEWS);
		return true;
	}
	@Override
	protected void onPostExecute(Boolean result){
		((Sports)AVE.CURRENT).updateScrollViewFromPrefetch();
		try{
			if(errors!= "") Toast.makeText(AVE.CURRENT, errors, Toast.LENGTH_SHORT).show();		
			((Sports) AVE.CURRENT).setProgressINCREMENT(1);
		}
		catch(NullPointerException npe){}
/*		if(singleUpdate){
			((ProgressBar) AVE.SPORTS_SINGLE_UPDATE.findViewById(R.id.progress_bar)).setProgress(2);
			AVE.SPORTS_SINGLE_UPDATE.dismiss();
		}*/
	}
	protected void developPrefetch(int sport, int action){
		ArrayList<ArrayList<String>> allData = new ArrayList<ArrayList<String>>();
		ArrayList<ArrayList<RelativeLayout>> allCache = new ArrayList<ArrayList<RelativeLayout>>();
		switch(sport){
		case AVE.HTML_FOOTBALL:	
			allData.add(AVE.FOOTBALL_SCORES_DATA);
			allData.add(AVE.FOOTBALL_ROSTER_DATA);
			allData.add(AVE.FOOTBALL_NEWS_DATA);
			allData.add(AVE.FOOTBALL_SCHEDULE_DATA);
			allCache.add(AVE.FOOTBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.FOOTBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.FOOTBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.FOOTBALL_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_BASEBALL:	
			allData.add(AVE.BASEBALL_SCORES_DATA);
			allData.add(AVE.BASEBALL_ROSTER_DATA);
			allData.add(AVE.BASEBALL_NEWS_DATA);
			allData.add(AVE.BASEBALL_SCHEDULE_DATA);
			allCache.add(AVE.BASEBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.BASEBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.BASEBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.BASEBALL_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_MENS_BASKETBALL:	
			allData.add(AVE.MENS_BASKETBALL_SCORES_DATA);
			allData.add(AVE.MENS_BASKETBALL_ROSTER_DATA);
			allData.add(AVE.MENS_BASKETBALL_NEWS_DATA);
			allData.add(AVE.MENS_BASKETBALL_SCHEDULE_DATA);
			allCache.add(AVE.MENS_BASKETBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.MENS_BASKETBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.MENS_BASKETBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.MENS_BASKETBALL_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_BASKETBALL:	
			allData.add(AVE.WOMENS_BASKETBALL_SCORES_DATA);
			allData.add(AVE.WOMENS_BASKETBALL_ROSTER_DATA);
			allData.add(AVE.WOMENS_BASKETBALL_NEWS_DATA);
			allData.add(AVE.WOMENS_BASKETBALL_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_BASKETBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_BASKETBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_BASKETBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_BASKETBALL_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_VBALL:	
			allData.add(AVE.WOMENS_VBALL_SCORES_DATA);
			allData.add(AVE.WOMENS_VBALL_ROSTER_DATA);
			allData.add(AVE.WOMENS_VBALL_NEWS_DATA);
			allData.add(AVE.WOMENS_VBALL_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_VBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_VBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_VBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_VBALL_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_MENS_GOLF:	
			allData.add(AVE.MENS_GOLF_SCORES_DATA);
			allData.add(AVE.MENS_GOLF_ROSTER_DATA);
			allData.add(AVE.MENS_GOLF_NEWS_DATA);
			allData.add(AVE.MENS_GOLF_SCHEDULE_DATA);
			allCache.add(AVE.MENS_GOLF_SCORES_WIDGETS_cache);
			allCache.add(AVE.MENS_GOLF_ROSTER_WIDGETS_cache);
			allCache.add(AVE.MENS_GOLF_NEWS_WIDGETS_cache);
			allCache.add(AVE.MENS_GOLF_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_GOLF:	
			allData.add(AVE.WOMENS_GOLF_SCORES_DATA);
			allData.add(AVE.WOMENS_GOLF_ROSTER_DATA);
			allData.add(AVE.WOMENS_GOLF_NEWS_DATA);
			allData.add(AVE.WOMENS_GOLF_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_GOLF_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_GOLF_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_GOLF_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_GOLF_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_ROWING:	
			allData.add(AVE.ROWING_SCORES_DATA);
			allData.add(AVE.ROWING_ROSTER_DATA);
			allData.add(AVE.ROWING_NEWS_DATA);
			allData.add(AVE.ROWING_SCHEDULE_DATA);
			allCache.add(AVE.ROWING_SCORES_WIDGETS_cache);
			allCache.add(AVE.ROWING_ROSTER_WIDGETS_cache);
			allCache.add(AVE.ROWING_NEWS_WIDGETS_cache);
			allCache.add(AVE.ROWING_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_SOCCER:	
			allData.add(AVE.SOCCER_SCORES_DATA);
			allData.add(AVE.SOCCER_ROSTER_DATA);
			allData.add(AVE.SOCCER_NEWS_DATA);
			allData.add(AVE.SOCCER_SCHEDULE_DATA);
			allCache.add(AVE.SOCCER_SCORES_WIDGETS_cache);
			allCache.add(AVE.SOCCER_ROSTER_WIDGETS_cache);
			allCache.add(AVE.SOCCER_NEWS_WIDGETS_cache);
			allCache.add(AVE.SOCCER_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_MENS_SD:	
			allData.add(AVE.MENS_SD_SCORES_DATA);
			allData.add(AVE.MENS_SD_ROSTER_DATA);
			allData.add(AVE.MENS_SD_NEWS_DATA);
			allData.add(AVE.MENS_SD_SCHEDULE_DATA);
			allCache.add(AVE.MENS_SD_SCORES_WIDGETS_cache);
			allCache.add(AVE.MENS_SD_ROSTER_WIDGETS_cache);
			allCache.add(AVE.MENS_SD_NEWS_WIDGETS_cache);
			allCache.add(AVE.MENS_SD_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_SD:	
			allData.add(AVE.WOMENS_SD_SCORES_DATA);
			allData.add(AVE.WOMENS_SD_ROSTER_DATA);
			allData.add(AVE.WOMENS_SD_NEWS_DATA);
			allData.add(AVE.WOMENS_SD_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_SD_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_SD_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_SD_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_SD_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_MENS_TENNIS:	
			allData.add(AVE.MENS_TENNIS_SCORES_DATA);
			allData.add(AVE.MENS_TENNIS_ROSTER_DATA);
			allData.add(AVE.MENS_TENNIS_NEWS_DATA);
			allData.add(AVE.MENS_TENNIS_SCHEDULE_DATA);
			allCache.add(AVE.MENS_TENNIS_SCORES_WIDGETS_cache);
			allCache.add(AVE.MENS_TENNIS_ROSTER_WIDGETS_cache);
			allCache.add(AVE.MENS_TENNIS_NEWS_WIDGETS_cache);
			allCache.add(AVE.MENS_TENNIS_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_TENNIS:	
			allData.add(AVE.WOMENS_TENNIS_SCORES_DATA);
			allData.add(AVE.WOMENS_TENNIS_ROSTER_DATA);
			allData.add(AVE.WOMENS_TENNIS_NEWS_DATA);
			allData.add(AVE.WOMENS_TENNIS_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_TENNIS_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TENNIS_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TENNIS_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TENNIS_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_MENS_TF:	
			allData.add(AVE.MENS_TF_SCORES_DATA);
			allData.add(AVE.MENS_TF_ROSTER_DATA);
			allData.add(AVE.MENS_TF_NEWS_DATA);
			allData.add(AVE.MENS_TF_SCHEDULE_DATA);
			allCache.add(AVE.MENS_TF_SCORES_WIDGETS_cache);
			allCache.add(AVE.MENS_TF_ROSTER_WIDGETS_cache);
			allCache.add(AVE.MENS_TF_NEWS_WIDGETS_cache);
			allCache.add(AVE.MENS_TF_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_WOMENS_TF:	
			allData.add(AVE.WOMENS_TF_SCORES_DATA);
			allData.add(AVE.WOMENS_TF_ROSTER_DATA);
			allData.add(AVE.WOMENS_TF_NEWS_DATA);
			allData.add(AVE.WOMENS_TF_SCHEDULE_DATA);
			allCache.add(AVE.WOMENS_TF_SCORES_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TF_ROSTER_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TF_NEWS_WIDGETS_cache);
			allCache.add(AVE.WOMENS_TF_SCHEDULE_WIDGETS_cache);
			break;
		case AVE.HTML_SOFTBALL:	
			allData.add(AVE.SOFTBALL_SCORES_DATA);
			allData.add(AVE.SOFTBALL_ROSTER_DATA);
			allData.add(AVE.SOFTBALL_NEWS_DATA);
			allData.add(AVE.SOFTBALL_SCHEDULE_DATA);
			allCache.add(AVE.SOFTBALL_SCORES_WIDGETS_cache);
			allCache.add(AVE.SOFTBALL_ROSTER_WIDGETS_cache);
			allCache.add(AVE.SOFTBALL_NEWS_WIDGETS_cache);
			allCache.add(AVE.SOFTBALL_SCHEDULE_WIDGETS_cache);
			break;
		}
		prefetchData(allData, allCache, action);
	}
	protected void prefetchData(ArrayList<ArrayList<String>> allData,  ArrayList<ArrayList<RelativeLayout>> allCache, int prefetchAction){
		switch(prefetchAction){
		case AVE.HTML_SCORE: 	if(singleUpdate) allCache.get(0).clear();
		try{((Sports) AVE.CURRENT).createScoreLeaves_Prefetch(allData.get(0), allCache.get(0), SPORT);}
		catch(IndexOutOfBoundsException iob){  setErrorCode("prefetch_score_"+ SPORT);}
		break;
		case AVE.HTML_ROSTER: if(singleUpdate) allCache.get(1).clear();
		try{((Sports)AVE.CURRENT).createRosterLeaves_Prefetch( allData.get(1), allCache.get(1));}
		catch(IndexOutOfBoundsException iob){  setErrorCode("prefetch_roster_"+SPORT);}
		break;
		case AVE.HTML_NEWS: 	if(singleUpdate) allCache.get(2).clear();
		try{((Sports)AVE.CURRENT).createNewsLeaves_Prefetch(allData.get(2), allCache.get(2));}
		catch(IndexOutOfBoundsException iob){  setErrorCode("prefetch_news_"+SPORT);}
		break;
		}
	}
	protected void setErrorCode(final String e){
		errors = errors+ " "+ e;
	}
}
