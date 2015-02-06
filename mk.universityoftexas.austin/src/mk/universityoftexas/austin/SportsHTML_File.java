package mk.universityoftexas.austin;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;

import org.htmlparser.Parser;
import org.htmlparser.Tag;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.parserapplications.StringExtractor;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;
import org.htmlparser.util.SimpleNodeIterator;

import android.content.Context;
import android.os.AsyncTask;
import android.widget.Toast;

public class SportsHTML_File extends AsyncTask<Void, Void, Boolean>{
	int SPORT = 0;

	String file_temp = "";

	private boolean downloadScores = false;
	private boolean downloadNews = false;
	private boolean downloadSchedule = false;
	private boolean downloadRoster = false;

	private boolean loadScores = false;
	private boolean loadNews = false;
	private boolean loadSchedule = false;
	private boolean loadRoster = false;

	boolean singleUpdate = false;	

	String errors = "";

	public SportsHTML_File(int toDownload){
		super();
		SPORT = (SPORT==0) ? toDownload : SPORT;
	}
	public void setDownloadScores(){
		downloadScores = true;
		loadScores = false;
	}
	public void setSingleUpdate(){
		singleUpdate = true;
	}
	public void setDownloadRoster(){
		downloadRoster = true;
		loadRoster = false;
	}
	public void setDownloadNews(){
		downloadNews = true;
		loadNews = false;
	}
	public void setDownloadSchedule(){
		downloadRoster = true;
		loadRoster = false;
	}
	public void setLoadScores(){
		loadScores = true;
		downloadScores = false;
	}
	public void setLoadRoster(){
		loadRoster = true;
		downloadRoster = false;
	}
	public void setLoadNews(){
		loadNews = true;
		downloadNews = false;
	}
	public void setLoadSchedule(){
		loadSchedule = true;
		downloadSchedule = false;
	}
	public void setAllDownloads(boolean a){
		downloadScores = a;
		downloadNews = a;
		downloadSchedule = a;
		downloadRoster = a;
	}
	public void setAllLoads(boolean a){
		loadScores = a;
		loadNews = a;
		loadSchedule = a;
		loadRoster = a;
	}
	@Override
	protected void onPreExecute() {}
	@Override
	protected Boolean doInBackground(Void... params) {
		if(downloadScores)	createData(SPORT, AVE.HTML_SCORE, true);
		if(downloadRoster)	createData(SPORT, AVE.HTML_ROSTER, true);
		if(downloadNews)	createData(SPORT, AVE.HTML_NEWS, true);
		if(loadScores)	createData(SPORT, AVE.HTML_SCORE, false);
		if(loadRoster)	createData(SPORT, AVE.HTML_ROSTER, false);
		if(loadNews)	createData(SPORT, AVE.HTML_NEWS, false);
		return true;
	}
	protected void createData(int sportNum, int action, boolean download_load){
		switch(sportNum){	
		case AVE.HTML_FOOTBALL: 				if(download_load)	downloadData("Football", sportNum, action);						else loadData("Football", sportNum, action); break;
		case AVE.HTML_BASEBALL:				if(download_load)	downloadData("Baseball", sportNum, action);						else loadData("Baseball", sportNum, action); break;
		case AVE.HTML_MENS_BASKETBALL: 		if(download_load)	downloadData("Men's Basketball", sportNum, action);				else loadData("Men's Basketball", sportNum, action); break;
		case AVE.HTML_WOMENS_BASKETBALL: 		if(download_load)	downloadData("Women's Basketball", sportNum, action);			else loadData("Women's Basketball", sportNum, action); break;
		case AVE.HTML_WOMENS_VBALL: 			if(download_load)	downloadData("Women's Volleyball", sportNum, action);			else loadData("Women's Volleyball", sportNum, action); break;
		case AVE.HTML_MENS_GOLF: 				if(download_load)	downloadData("Men's Golf", sportNum, action);					else loadData("Men's Golf", sportNum, action); break;
		case AVE.HTML_WOMENS_GOLF: 			if(download_load)	downloadData("Women's Golf", sportNum, action);					else loadData("Women's Golf", sportNum, action); break;
		case AVE.HTML_ROWING: 				if(download_load)	downloadData("Rowing", sportNum, action);						else loadData("Rowing", sportNum, action); break;
		case AVE.HTML_SOCCER: 				if(download_load)	downloadData("Soccer", sportNum, action);						else loadData("Soccer", sportNum, action); break;
		case AVE.HTML_MENS_SD: 				if(download_load)	downloadData("Men's Swimming and Diving", sportNum, action);	else loadData("Men's Swimming and Diving", sportNum, action); break;
		case AVE.HTML_WOMENS_SD: 				if(download_load)	downloadData("Women's Swimming and Diving", sportNum, action);	else loadData("Women's Swimming and Diving", sportNum, action); break;
		case AVE.HTML_MENS_TENNIS: 			if(download_load)	downloadData("Men's Tennis", sportNum, action);					else loadData("Men's Tennis", sportNum, action); break;
		case AVE.HTML_WOMENS_TENNIS: 			if(download_load)	downloadData("Women's Tennis", sportNum, action);				else loadData("Women's Tennis", sportNum, action); break;
		case AVE.HTML_MENS_TF: 				if(download_load)	downloadData("Men's Track and Field", sportNum, action);		else loadData("Men's Track and Field", sportNum, action); break;
		case AVE.HTML_WOMENS_TF:				if(download_load)	downloadData("Women's Track and Field", sportNum, action);		else loadData("Women's Track and Field", sportNum, action); break;
		case AVE.HTML_SOFTBALL: 				if(download_load)	downloadData("Softball", sportNum, action);						else loadData("Softball", sportNum, action); break;
		}	
	}
	protected void downloadData(String sport, int sportNum, int action){
		ArrayList<String>a = null;
		switch(action){
		case AVE.HTML_SCORE: 	try{a =SportsHTMLParser_Helper.normalizeSportScores(SportsHTMLParser_Helper.extractSportScores(sport));}
		catch(ArrayIndexOutOfBoundsException aib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		catch(StringIndexOutOfBoundsException sib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		updateDataList(sportNum, action, a);
		saveData(a, sport, "Scores");
		break;
		case AVE.HTML_ROSTER: 	try{a = SportsHTMLParser_Helper.normalizeSportRoster(SportsHTMLParser_Helper.extractSportRoster(sport));}
		catch(ArrayIndexOutOfBoundsException aib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		catch(StringIndexOutOfBoundsException sib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		updateDataList(sportNum, action, a);
		saveData(a, sport, "Roster");
		break;
		case AVE.HTML_NEWS: 	try{a = SportsHTMLParser_Helper.toList(SportsHTMLParser_Helper.extractSportNews(sport));}
		catch(ArrayIndexOutOfBoundsException aib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		catch(StringIndexOutOfBoundsException sib){
			setErrorCode("prefetch_score_"+ SPORT);
			a = new ArrayList<String>();}
		updateDataList(sportNum, action, a);
		saveData(a, sport, "News");
		break;
		}
	}

	protected void setErrorCode(final String e){
		errors = errors+ " "+ e;
	}
	protected void updateDataList(int sportNum, int action, ArrayList<String> newList){
		switch(sportNum){
		case AVE.HTML_FOOTBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.FOOTBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.FOOTBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.FOOTBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.FOOTBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_BASEBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.BASEBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.BASEBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.BASEBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.BASEBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_MENS_BASKETBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.MENS_BASKETBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.MENS_BASKETBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.MENS_BASKETBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.MENS_BASKETBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_BASKETBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_BASKETBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_BASKETBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_BASKETBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.WOMENS_BASKETBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_VBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_VBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_VBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_VBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.WOMENS_VBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_MENS_GOLF:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.MENS_GOLF_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.MENS_GOLF_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.MENS_GOLF_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.MENS_GOLF_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_GOLF:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_GOLF_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_GOLF_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_GOLF_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.WOMENS_GOLF_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_ROWING:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.ROWING_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.ROWING_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.ROWING_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.ROWING_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_SOCCER:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.SOCCER_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.SOCCER_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.SOCCER_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.SOCCER_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_MENS_SD:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.MENS_SD_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.MENS_SD_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.MENS_SD_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.MENS_SD_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_SD:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_SD_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_SD_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_SD_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.WOMENS_SD_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_MENS_TENNIS:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.MENS_TENNIS_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.MENS_TENNIS_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.MENS_TENNIS_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.MENS_TENNIS_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_TENNIS:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_TENNIS_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_TENNIS_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_TENNIS_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.WOMENS_TENNIS_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_MENS_TF:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.MENS_TF_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.MENS_TF_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.MENS_TF_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.MENS_TF_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_WOMENS_TF:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.WOMENS_TF_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.WOMENS_TF_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.WOMENS_TF_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.FOOTBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		case AVE.HTML_SOFTBALL:{
			switch(action){
			case AVE.HTML_SCORE:		AVE.SOFTBALL_SCORES_DATA = newList; break;
			case AVE.HTML_ROSTER: 	AVE.SOFTBALL_ROSTER_DATA = newList; break;
			case AVE.HTML_NEWS:		AVE.SOFTBALL_NEWS_DATA = newList; break;
			case AVE.HTML_SCHEDULE: 	AVE.SOFTBALL_SCHEDULE_DATA = newList; break;
			} break;
		}
		}
	}
	protected void loadData(String sport, int sportNum, int action){
		String a = null;
		switch(action){
		case AVE.HTML_SCORE: 		a = "Scores";	break;
		case AVE.HTML_ROSTER: 	a = "Roster";	break;
		case AVE.HTML_NEWS: 		a = "News";		break;
		case AVE.HTML_SCHEDULE: 	a = "Schedule";	break;
		}

		file_temp = sport.replaceAll("\'", "") + "_" +a + ".txt";	
		FileInputStream fis = null;
		InputStreamReader isr = null;
		String s = null;
		try {
			fis = AVE.CURRENT.openFileInput(file_temp);
			isr = new InputStreamReader(fis);
			char[] inputBuffer = new char[fis.available()];
			isr.read(inputBuffer);
			s = new String(inputBuffer);
			isr.close();
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}		

		ArrayList <String> b = new ArrayList <String>();
		Collections.addAll(b, s.split("\\|"));

		updateDataList(sportNum, action, b);

		Log.d("Hello1", Integer.toString(b.size()));
	}
	@Override
	protected void onPostExecute(Boolean result){
		((SportsMenu) AVE.CURRENT).setProgressINCREMENT(1);
		if(errors!= "") Toast.makeText(AVE.CURRENT, errors, Toast.LENGTH_SHORT).show();		
		if(singleUpdate)	new SportsHTML_Prefetch(SPORT, true).execute();
	}
	protected void saveData(ArrayList<String> a, String sport, String action){
		file_temp = sport.replaceAll("\'","") + "_" +action + ".txt";
		FileOutputStream fos = null;
		try {
			fos = AVE.CURRENT.openFileOutput(file_temp, Context.MODE_PRIVATE);
			for(int x = 0; x<a.size();x++){				
				fos.write(a.get(x).getBytes());	
				if(!((x+1)==a.size())) fos.write("|".getBytes());
			}			
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
abstract class SportsHTMLParser_Helper {
	String MENU = "http://m.utexas.edu/athletics/";	
	public static String extractSportURL(String sport) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		StringExtractor a = new StringExtractor("http://m.utexas.edu/athletics/");
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}
		c = c.substring(0, c.indexOf(sport));
		int start = c.lastIndexOf('<')+1;
		int end = c.lastIndexOf('>');

		return c.substring(start, end);
	}
	public static ArrayList<String> normalizeSportScores(String s) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException {
		ArrayList <String> a = toList(s);

		int c = 0;
		int e = 0;

		if(a.size()>3){

			while(e<a.size()) {
				e++; c++;
				if(c==1&&a.get(e).contains("/")){
					System.out.println("E: " + a.get(e));
					a.add(e, "-");
					a.add(e, "-");
					a.add(e, "N/A");
					c = 0;
					e+=5;
				}
				else if((c==1&&(a.get(e).contains("lost")||a.get(e).contains("won")))&&a.get(e+1).contains("/")){
					a.add(e+1, "-");
					a.add(e+1, "-");
					c = 0;
					e+=4;
					System.out.println("HERE");
				}
				else{
					c = 0;
					e+=5;
				}

			}
		}
		return a;	
	}
	public static String extractSportScores(String sport) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "scores"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpSports(c);	
	}
	public static String cleanUpSports(String unClean) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		String a  = removeXLinesFromStart(unClean, 8);
		a = removeConclusion(a);
		return a;		
	}
	public static String extractSportNews(String sport) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "news"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpNews(c);	
	}
	public static String cleanUpNews(String unClean) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		String a  = removeXLinesFromStart(unClean, 3);
		a = reseatURLS(a);
		a = removeConclusion(a);
		return a;		
	}
	public static String extractSportRoster(String sport) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "roster"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpRoster(c);	
	}
	public static String cleanUpRoster(String unClean) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		String a  = removeXLinesFromStart(unClean, 3);
		a = reseatURLS(a);
		a = removeConclusion(a);
		return a.replace("Name" + System.getProperty("line.separator"), "").replace("Event" + System.getProperty("line.separator"), "");		
	}
	public static String removeConclusion(String s){
		s = s.substring(0, s.lastIndexOf(System.getProperty("line.separator")));
		s = s.substring(0, s.indexOf("Sports brought to you by"));
		return s;
	}
	public static String removeXLinesFromStart(String s, int x) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		for(int y = 0; y<x; y++)
			s = s.substring(s.indexOf(System.getProperty("line.separator"))+System.getProperty("line.separator").length());

		return s;
	}
	public static String reseatURLS(String s) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		s = s.replaceAll("<", "");
		s = s.replaceAll(">", System.getProperty("line.separator"));
		return s;		
	}
	public static ArrayList<String> toList(String s) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		ArrayList <String> a = new ArrayList <String>();
		Collections.addAll(a, s.split(System.getProperty("line.separator")));
		return a;
	}
	public static ArrayList<String> normalizeSportRoster(String s) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		ArrayList <String> a = toList(s);
		for(int x = 0;x < a.size(); x++){
			if(a.get(x).length()>6){
				a.add(x, "--");
			}
			try{
				if(a.get(x+=3).length()>30)			
					a.add(x, "--");
			}catch(IndexOutOfBoundsException i){
				a.add(a.size(), "--");
			}
		}
		return a;
	}
	public static String extractSportPlayer(String url) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{	
		StringExtractor a = new StringExtractor(url);
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		c = cleanUpPlayer(c);
		c = c+ extractSportPlayerImage(url) + System.getProperty("line.separator");
		return c;	
	}
	public static String cleanUpPlayer(String unClean) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{
		String a  = removeXLinesFromStart(unClean, 2);
		a = removeConclusion(a);
		return a;		
	}
	public static ArrayList <String>  normalizeSportPlayer(String s) throws ArrayIndexOutOfBoundsException, StringIndexOutOfBoundsException{	
		ArrayList <String> a = toList(s);
		if(a.size()<7){
			for(int x = 0; x<7-a.size();x++)
				a.add(a.size()-1, "--");
		}
		return a;	
	}
	public static String extractSportPlayerImage(String url){
		Parser parser;
		NodeList list = null;
		try {
			parser = new Parser(url);
			list = parser.parse(new TagNameFilter("IMG"));
		} catch (ParserException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		for ( SimpleNodeIterator iterator = list.elements(); iterator.hasMoreNodes(); ) {
			Tag tag = (Tag) iterator.nextNode();
			return tag.getAttribute("src");
		}
		return "";
	}
}

