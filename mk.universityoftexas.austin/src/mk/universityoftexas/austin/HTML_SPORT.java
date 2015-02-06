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


public abstract class HTML_SPORT {
	
	public static final int CONTENT_ROSTER = 1;
	public static final int CONTENT_SCHEDULE = 2;
	public static final int CONTENT_SCORES = 3;
	public static final int CONTENT_NEWS = 4;
	

	public static final int ACTION_DOWNLOAD_SAVE = 0x512;
	public static final int ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE = 0x513;
	public static final int ACTION_ATTEMPT_DOWNLOAD_FALLBACK_LOAD = 0x514;
	public static final int ACTION_LOAD_ONLY = 0x515;
	
	public static final class SPORTS {
		public static final String Football ="Football";
		public static final String WomensBasketball ="Women's Basketball";
		public static final String WomensTennis ="Women's Tennis";
		public static final String Baseball ="Baseball";

		public static final String Rowing ="Rowing";
		public static final String WomensVolleyball ="Women's Volleyball";
		public static final String MensTennis ="Men's Tennis";
		public static final String MensBasketabll ="Men's Basketball";
		
		public static final String MensSwimmingDiving ="Men's Swimming and Diving";
		public static final String WomensSwimmingDiving ="Women's Swimming and Diving";
		public static final String MensTrackField ="Men's Track and Field";
		public static final String WomensTrackField ="Women's Track and Field";

		public static final String Softball ="Softball";
		public static final String MensGolf ="Men's Golf";
		public static final String WomensGolf ="Women's Golf";
		public static final String Soccer ="Soccer";
	}
	private static String getCacheFileName(String sport, int content){
		return sport.replaceAll("'", "").replace(" ", "") + Integer.toString(content)+".txt";
	}
	public static ArrayList<String> getData(String sport, int content, int action){
		ArrayList<String> toSave;
		switch(action){
		case ACTION_DOWNLOAD_SAVE:
			Log.d("HTML_SPORT", "Download and save");
			toSave =  getArrayListFor(sport, content);
			saveData(toSave, sport, content);
		case ACTION_LOAD_ONLY:
			Log.d("HTML_SPORT", "Loading from file");
			return loadData(sport, content);
		}
		
		ArrayList<String> _cache = loadData(sport, content);
		ArrayList<String> _download = null;
		
		if(action == ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE){
			Log.d("HTML_SPORT", "Loading from file with backup");
			if(_cache!=null){
				Log.d("RSS", "Loading from file");
				return loadData(sport, content);
			}
			else{
				Log.d("HTML_SPORT", "Fallback to downloading and saving");
				_download =  getArrayListFor(sport, content);
				if(_download==null)	return null;
				saveData(_download, sport, content);
				return _download;
			}
		}
		else{
			Log.d("HTML_SPORT", "Downloading and saving with backup");
			_download =  getArrayListFor(sport, content);
			if(_download!=null){
				Log.d("RSS", "Downloading and saving");
				saveData(_download, sport, content);
				return _download;
			}
			else
				Log.d("HTML_SPORT", "Fallback to load from file");
			if(_cache==null)	return null;
			return loadData(sport, content);	
		}
	}
	private static ArrayList<String> getArrayListFor(String sport, int content){
		switch(content){
			case CONTENT_ROSTER: 	return normalizeSportRoster(extractSportRoster(sport));
			case CONTENT_SCHEDULE: 	return normalizeSportSchedule(extractSportSchedule(sport));
			case CONTENT_SCORES: 	return normalizeSportScores(extractSportScores(sport));
			case CONTENT_NEWS:	 	return normalizeSportNews(extractSportNews(sport));
		}
		return null;
	}
	private static ArrayList<String> loadData(String sport, int content){		
		FileInputStream fis = null;
		InputStreamReader isr = null;
		String s = null;
		try {
			fis = AVE.CURRENT.openFileInput(getCacheFileName(sport, content));
			isr = new InputStreamReader(fis);
			char[] inputBuffer = new char[fis.available()];
			isr.read(inputBuffer);
			s = new String(inputBuffer);
			isr.close();
			fis.close();
		} catch (FileNotFoundException e) {
			return null;
		} catch (IOException e) {
			return null;
		}		

		ArrayList <String> b = new ArrayList <String>();
		Collections.addAll(b, s.split("\\|"));
		
		return b;
	}
	private static void saveData(ArrayList<String> a, String sport, int content){
		FileOutputStream fos = null;
		try {
			fos = AVE.CURRENT.openFileOutput(getCacheFileName(sport, content), Context.MODE_PRIVATE);
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
	private static String extractSportURL(String sport){		
		if(sport.equals(SPORTS.Football))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-footbl";
		if(sport .equals( SPORTS.WomensBasketball))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-baskbl";
		if(sport .equals( SPORTS.WomensTennis))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-tennis";
		if(sport .equals( SPORTS.Baseball))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-basebl";
		if(sport .equals( SPORTS.Rowing))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-rowing";
		if(sport .equals( SPORTS.WomensVolleyball))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-baskbl";
		if(sport .equals( SPORTS.MensTennis))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-tennis";
		if(sport .equals( SPORTS.MensBasketabll))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-baskbl";
		if(sport .equals( SPORTS.MensSwimmingDiving))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-swim";
		if(sport .equals( SPORTS.WomensSwimmingDiving))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-swim";
		if(sport .equals( SPORTS.MensTrackField))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-track";
		if(sport .equals( SPORTS.WomensTrackField))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-track";
		if(sport .equals( SPORTS.Softball))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-softbl";
		if(sport .equals( SPORTS.MensGolf))
			return "http://m.utexas.edu/athletics/teams.php?sport=m-golf";
		if(sport .equals( SPORTS.WomensGolf))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-golf";
		if(sport .equals( SPORTS.Soccer))
			return "http://m.utexas.edu/athletics/teams.php?sport=w-soccer";

		return "http://m.utexas.edu/athletics/teams.php?sport=m-footbl";

	}
	private static ArrayList<String> normalizeSportScores(String s) {
		ArrayList <String> a = toList(s);

		int c = 0;
		int e = 0;

		if(a.size()>3){

			while(e<a.size()) {
				e++; c++;
				int check = -25;
				//	System.out.println(e);
				try{
					check = Integer.parseInt(a.get(e));
				}catch(Exception sfs){}
				if(c==1&&check>=0){
					a.add(e, "-");
					c=0;
					e+=5;
				}		

				else if(c==1&&a.get(e).contains("/")){
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
					e+=5;
				}
				else{
					c = 0;
					e+=5;
				}
			}
		}
		else{
			a.removeAll(a);
			a.add("Error in input file.");
			a.add(e, "Try again later.");
			a.add(e, "-");
			a.add(e, "-");
			a.add("-");
			a.add("-");
		}
		return a;	
	}
	private static String extractSportSchedule(String sport){	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "schedule"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpSchedule(c);
	}
	private static String extractSportScores(String sport){	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "scores"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpSports(c);	
	}
	private static String cleanUpSchedule(String unClean){
		String a;
		if(unClean.contains("Season is over"))
			a = removeXLinesFromStart(unClean, 3);
		else
			a = removeXLinesFromStart(unClean, 7);		

		a = removeConclusion(a);
		return a;		
	}
	private static String cleanUpSports(String unClean){
		String a  = removeXLinesFromStart(unClean, 8);
		a = removeConclusion(a);
		return a;		
	}
	private static String extractSportNews(String sport){	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "news"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpNews(c);	
	}
	public static ArrayList<String> normalizeSportSchedule(String s){
		ArrayList <String> a = toList(s);
		if(a.size()<8){
			a.removeAll(a);
			a.add("Season is over.");
			a.add("I think :P");
			a.add("-");
			a.add("-");
			a.add("-");
			a.add("-");	
			a.add("-");	
			a.add("-");	
		}
		return a;
	}
	private static String cleanUpNews(String unClean){
		String a  = removeXLinesFromStart(unClean, 3);
		a = reseatURLS(a);
		a = removeConclusion(a);
		return a;		
	}
	private static String extractSportRoster(String sport){	
		StringExtractor a = new StringExtractor(extractSportURL(sport).replaceAll("teams", "roster"));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}				
		return cleanUpRoster(c);	
	}
	private static String cleanUpRoster(String unClean){
		String a  = removeXLinesFromStart(unClean, 3);
		a = reseatURLS(a);
		a = removeConclusion(a);
		return a.replace("Name" + System.getProperty("line.separator"), "").replace("Event" + System.getProperty("line.separator"), "");		
	}
	private static String removeConclusion(String s){
		s = s.substring(0, s.lastIndexOf(System.getProperty("line.separator")));
		s = s.substring(0, s.indexOf("Sports brought to you by"));
		return s;
	}
	static String removeXLinesFromStart(String s, int x){
		for(int y = 0; y<x; y++)
			s = s.substring(s.indexOf(System.getProperty("line.separator"))+System.getProperty("line.separator").length());

		return s;
	}
	private static String reseatURLS(String s){
		s = s.replaceAll("<", "");
		s = s.replaceAll(">", System.getProperty("line.separator"));
		return s;		
	}
	static ArrayList<String> toList(String s){
		ArrayList <String> a = new ArrayList <String>();
		Collections.addAll(a, s.split(System.getProperty("line.separator")));
		return a;
	}
	private static ArrayList<String> normalizeSportRoster(String s){
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
	static String extractSportPlayer(String url){	
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
	private static String cleanUpPlayer(String unClean){
		String a  = removeXLinesFromStart(unClean, 2);
		a = removeConclusion(a);
		return a;		
	}
	static ArrayList <String>  normalizeSportPlayer(String s){	
		ArrayList <String> a = toList(s);
		if(a.size()<7){
			for(int x = 0; x<8-a.size();x++)
				a.add(a.size()-1, "--");
		}
		return a;	
	}
	private static ArrayList <String>  normalizeSportNews(String s){	
		ArrayList <String> a = toList(s);
		return a;	
	}
	private static String extractSportPlayerImage(String url){
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

