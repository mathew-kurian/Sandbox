package mk.universityoftexas.austin;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class XML_NEWS_BLOG {
	public static final int CONTENT_FORMAT_TEXT_ONLY = 0x451;
	public static final int CONTENT_FORMAT_IMAGES_AND_HTML = 0x452;
	public static final int CONTENT_FORMAT_HTML_ONLY = 0x453;

	public static final String TITLE = "title";
	public static final String LINK = "link";
	public static final String DESCRIPTION = "description";
	public static final String CONTENT = "content";
	public static final String PUBLICATION_DATE = "publication date";

	public static final String ERROR_RECOGNIZER = "NAN";

	public static final int ACTION_DOWNLOAD_SAVE = 0x512;
	public static final int ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE = 0x513;
	public static final int ACTION_ATTEMPT_DOWNLOAD_FALLBACK_LOAD = 0x514;
	public static final int ACTION_LOAD_ONLY = 0x515;

	/*
	 * Null return means error in load;
	 */
	public static ArrayList<JSONObject> getNewsRSS(String RSS, int content_format, int action) throws IOException, ParserConfigurationException, SAXException, URISyntaxException{

		Log.d("RSS", "Developed for " + getCacheFileName(RSS));


		//========================================================================//
		ArrayList<JSONObject> empty_return = new ArrayList<JSONObject>();		
		JSONObject empty = new JSONObject();

		try {
			empty.put(TITLE, "Oopsie! No information found on RSS");
			empty.put(CONTENT, "Sorry");
			empty.put(LINK, "http://www.utexas.edu");
			empty.put(PUBLICATION_DATE, "Try again later");
			empty.put(DESCRIPTION, "Error seems to exist");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		

		empty_return.add(empty);
		//========================================================================//

		switch(action){
		case ACTION_DOWNLOAD_SAVE:
			Log.d("RSS", "Download and save");
			setLastUpdate(RSS, AVE.CURRENT);
			return getRSSFromInputStream(getURLInputStream(AVE.CURRENT, RSS), content_format, empty_return);		
		case ACTION_LOAD_ONLY:
			Log.d("RSS", "Loading from file");
			return getRSSFromInputStream(getCacheInputStream(AVE.CURRENT, RSS), content_format, empty_return);
		}

		InputStream _cache = getCacheInputStream(AVE.CURRENT, RSS);
		InputStream _download = null;

		if(action == ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE){
			Log.d("RSS", "Loading from file with backup");
			if(_cache!=null){
				Log.d("RSS", "Loading from file");
				return getRSSFromInputStream(_cache, content_format, empty_return);
			}
			else{
				Log.d("RSS", "Fallback to downloading and saving");
				_download = getURLInputStream(AVE.CURRENT, RSS);
				if(_download==null)	return empty_return;
				return getRSSFromInputStream(_download, content_format, empty_return);
			}
		}
		else{
			Log.d("RSS", "Downloading and saving with backup");
			_download = getURLInputStream(AVE.CURRENT, RSS);
			if(_download!=null){
				Log.d("RSS", "Downloading and saving");
				setLastUpdate(RSS, AVE.CURRENT);
				return getRSSFromInputStream(_download, content_format, empty_return);
			}
			else
				Log.d("RSS", "Fallback to load from file");
			if(_cache==null)	return empty_return;
			return getRSSFromInputStream(_cache, content_format, empty_return);	
		}
	}
	public static void setLastUpdate(String RSS, Context c){
		SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(c);
		SharedPreferences.Editor editor = preferences.edit();
		editor.putString(getCacheFileName(RSS),  AVE.getDate());
		editor.commit();
	}
	public static String getLastUpdate(String RSS, Context c){
		return PreferenceManager.getDefaultSharedPreferences(c).getString(getCacheFileName(RSS), AVE.getDate());
	}
	private static InputStream getCacheInputStream(Context c, String RSS){
		InputStream in = null;
		try {
			in = c.openFileInput(getCacheFileName(RSS));
		} catch (FileNotFoundException e) {
			Log.d("RSS", "File not found");
		}
		return in;
	}
	/*
	 * Downloads and sends a inputstream to save;
	 */
	private static InputStream getURLInputStream(Context c, String RSS) throws IOException{
		URL metafeedUrl = new URL(RSS);
		URLConnection connection;     
		connection= metafeedUrl.openConnection();

		HttpURLConnection  httpConnection = (HttpURLConnection)connection;        
		int resposnseCode= httpConnection.getResponseCode();

		InputStream in = null;
		InputStream save = null;
		if(resposnseCode == HttpURLConnection.HTTP_OK){
			in = httpConnection.getInputStream();
			save = getSaveInputStream(RSS);
		}

		if(save!=null)	saveInputStreamToFile(c, save, RSS);			

		return in;
	}
	/*
	 * Duplicating inputstream from web for save
	 */
	private static InputStream getSaveInputStream(String RSS) throws IOException{
		URL metafeedUrl = new URL(RSS);
		URLConnection connection;     
		connection= metafeedUrl.openConnection();				
		HttpURLConnection  httpConnection = (HttpURLConnection)connection;   

		return httpConnection.getInputStream();
	}
	private static ArrayList<JSONObject> getRSSFromInputStream(InputStream a, int content_format, ArrayList<JSONObject> empty_return) throws SAXException, IOException, ParserConfigurationException{
		ArrayList<JSONObject> data = new ArrayList<JSONObject>();
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();

		if(a == null)
			return empty_return;
				
		Document dom = db.parse(a);
		dom.getXmlVersion();
		Element docEle = dom.getDocumentElement();

		Log.d("RSS", "Parsing feed");

		NodeList nl = docEle.getElementsByTagName("item");
		if (nl != null && nl.getLength() > 0) {
			for (int i = 0 ; i < nl.getLength(); i++) {
				Element entry = (Element)nl.item(i);

				//============================================================//TITLE
				Element title = (Element)entry.getElementsByTagName("title").item(0);
				String titleStr = ERROR_RECOGNIZER;
				try{
					titleStr = title.getFirstChild().getNodeValue();
				}catch(NullPointerException npe){}

				Log.d("RSS", "Title: " +  titleStr);
				//============================================================//

				//============================================================//LINK
				Element link = (Element)entry.getElementsByTagName("link").item(0);
				String linkStr = ERROR_RECOGNIZER;
				try{
					linkStr = link.getFirstChild().getNodeValue();
				}catch(NullPointerException npe){}

				Log.d("RSS", "Link: " + linkStr);
				//============================================================//

				//============================================================//DESCRIPTION
				Element desc = (Element)entry.getElementsByTagName("description").item(0);					
				String descStr = ERROR_RECOGNIZER;
				try{
					descStr= desc.getFirstChild().getNodeValue();
				}catch(NullPointerException npe){}

				Log.d("RSS", "Description: " + descStr);
				//============================================================//

				//============================================================//PUBLICATION DATE
				Element pubdate = (Element)entry.getElementsByTagName("pubDate").item(0);					
				String pubdateStr = ERROR_RECOGNIZER;
				try{
					pubdateStr = pubdate.getFirstChild().getNodeValue();
				}catch(NullPointerException npe){}

				Log.d("RSS", "Publication Date: " + pubdateStr);
				//============================================================//

				//============================================================//CONTENT
				Element content = (Element)entry.getElementsByTagName("content:encoded").item(0);					
				String contentStr = ERROR_RECOGNIZER;
				try{						
					if(content_format ==  CONTENT_FORMAT_TEXT_ONLY)
						contentStr = Jsoup.clean(content.getFirstChild().getNodeValue(), Whitelist.none());
					else if(content_format ==  CONTENT_FORMAT_IMAGES_AND_HTML)
						contentStr  = Jsoup.clean(content.getFirstChild().getNodeValue(), Whitelist.basicWithImages());
					else if(content_format ==  CONTENT_FORMAT_HTML_ONLY)
						contentStr  = Jsoup.clean(content.getFirstChild().getNodeValue(), Whitelist.basic());
					else
						contentStr = Jsoup.clean(content.getFirstChild().getNodeValue(), Whitelist.none());
				}catch(NullPointerException npe){}

				Log.d("RSS", "Content: " + contentStr);
				//============================================================//

				JSONObject temp = new JSONObject();
				try {
					temp.put(TITLE, titleStr);
					temp.put(CONTENT, contentStr);
					temp.put(LINK, linkStr);
					temp.put(PUBLICATION_DATE, pubdateStr);
					temp.put(DESCRIPTION, descStr);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				if(temp.length()>2) data.add(temp);
			}
		}

		if(data.size()>1) 	return data;
		else				return empty_return;
	}
	private static String getCacheFileName(String RSS){		
		String fileName = "";
		try{
			fileName = RSS.substring(RSS.lastIndexOf("/")+1);
		}catch(StringIndexOutOfBoundsException ste){}
		if(!RSS.contains(".rss")){
			fileName = RSS.substring(RSS.indexOf(".edu/")+5);
			fileName = fileName.substring(0, fileName.lastIndexOf("/"));
			fileName = fileName.substring(0, fileName.lastIndexOf("/"))+".rss";
		}

		Log.d("RSS", "Cache File Name: "+ fileName);

		return fileName;		
	}
	protected static void saveInputStreamToFile(Context c, InputStream in, String RSS) throws IOException{
		String _name = getCacheFileName(RSS);
		FileOutputStream fos = c.openFileOutput(_name, Context.MODE_PRIVATE);		

		int read = 0;
		byte[] bytes = new byte[1024];
		while ((read = in.read(bytes)) != -1) {
			fos.write(bytes, 0, read);
		}

		in.close();  //DO NOT CLOSE
		fos.flush();
		fos.close();

		Log.d("RSS", "File: "+ _name +" created successfully");
	}
	public static final class RSS {
		public static final String UtNews ="http://www.utexas.edu/news/feed/";
		public static final String UsEducation = "http://www.utexas.edu/news/channels/useducationnews.rss";
		public static final String AtTexas = "http://www.utexas.edu/news/channels/texas.rss";
		public static final String Architecture = "http://www.utexas.edu/news/channels/architecture.rss";
		public static final String RedMcCombsSchoolofBusiness = "http://www.utexas.edu/news/channels/business.rss";
		public static final String CollegeofCommunication = "http://www.utexas.edu/news/channels/communication.rss";
		public static final String CollegeofEducation = "http://www.utexas.edu/news/channels/education.rss";
		public static final String CollegeofEngineering = "http://www.utexas.edu/news/channels/engineering.rss";
		public static final String FineArts = "http://www.utexas.edu/news/channels/finearts.rss";
		public static final String GraduateStudies = "http://www.utexas.edu/news/channels/graduatestudies.rss";
		public static final String GSLIS = "http://www.utexas.edu/news/channels/gslis.rss";
		public static final String JacksonSchoolofGeoSciences = "http://www.utexas.edu/news/channels/jsg.rss";
		public static final String LBJSchoolofPublicAffairs = "http://www.utexas.edu/news/channels/lawschool.rss";
		public static final String LiberalArts = "http://www.utexas.edu/news/channels/lbjschool.rss";
		public static final String NaturalScience = "http://www.utexas.edu/news/channels/naturalscience.rss";
		public static final String SchoolofNursing = "http://www.utexas.edu/news/channels/nursing.rss";
		public static final String CollegeofPharmacy = "http://www.utexas.edu/news/channels/pharmacy.rss";
		public static final String SchoolofSocialWork = "http://www.utexas.edu/news/channels/socialwork.rss";
		public static final String DailyTexnHeadlines = "http://www.utexas.edu/news/channels/dailytexan.rss";
		public static final String OfficeofPublicAffairs = "http://www.utexas.edu/news/channels/opa.rss";
		public static final String EyesofTexas = "http://www.utexas.edu/news/channels/eot.rss";
		public static final String OnCampus = "http://www.utexas.edu/news/channels/oncampus.rss";
		public static final String OnCampusToday = "http://www.utexas.edu/news/channels/on_campus_today.rss";
		public static final String HousingandFood = "http://www.utexas.edu/news/channels/housingfood.rss";
		public static final String ITNews = "http://www.utexas.edu/news/channels/itnews.rss";
		public static final String BusinessandEnterpriseNews = "http://www.utexas.edu/news/channels/enterprisenews.rss";
		public static final String GeneralLibraries = "http://www.utexas.edu/news/channels/generallibrarynews.rss";
		public static final String TxTell = "http://www.utexas.edu/news/channels/txtell.rss";
		public static final String StudyAbroad = "http://www.utexas.edu/news/channels/studyabroad.rss";
		public static final String IntenationalOffice = "http://www.utexas.edu/news/channels/io.rss";
		public static final String OfficeofAdmissions = "http://www.utexas.edu/news/channels/admissions.rss";
		public static final String BeaLonghorn = "http://www.utexas.edu/news/channels/bealonghorn.rss";
		public static final String Purchasing = "http://www.utexas.edu/news/channels/purchasing.rss";
		public static final String StudentCentralSpotlights = "http://www.utexas.edu/news/channels/studentcentralspots.rss";
		public static final String WebCentralSpotlights = "http://www.utexas.edu/news/channels/webcentralspots.rss";
		public static final String UTSystem = "http://www.utexas.edu/news/channels/utssystem.rss";
		public static final String UTSAToday = "http://www.utexas.edu/news/channels/usta.rss";
		public static final String UTSAFYI = "http://www.utexas.edu/news/channels/utsafyi.rss";
		public static final String AustinChronicle = "http://www.utexas.edu/news/channels/austinchronicle.rss";
		public static final String DallasFortWorthNews = "http://www.utexas.edu/news/channels/dallasfortworth.rss";
		public static final String HoustonNews = "http://www.utexas.edu/news/channels/houston.rss";
		public static final String ElPasoNews = "http://www.utexas.edu/news/channels/elpaso.rss";
		public static final String MotleyFool = "http://www.utexas.edu/news/channels/motleyfool.rss";
		public static final String InternetNewsTopHeadlines = "http://www.utexas.edu/news/channels/internettopheadlines.rss";
		public static final String InternetProductNews = "http://www.utexas.edu/news/channels/internetproductnews.rss";
		public static final String WebDeveloperNews = "http://www.utexas.edu/news/channels/webdevelopernews.rss";
		public static final String CyberAtlas = "http://www.utexas.edu/news/channels/cyberaltlas.rss";
		public static final String InternetAdvertisingReport = "http://www.utexas.edu/news/channels/internetadvertisingreport.rss";
		public static final String InternetEcommerceNews = "http://www.utexas.edu/news/channels/internetconnercenews.rss";
		public static final String ISPNews = "http://www.utexas.edu/news/channels/ispnews.rss";
		public static final String StreamingMediaNews = "http://www.utexas.edu/news/channels/streamindmedianews.rss";
		public static final String JavaScriptTipoftheDay = "http://www.utexas.edu/news/channels/jstipoftheday.rss";
		public static final String WebReference = "http://www.utexas.edu/news/channels/webreference.rss";
		public static final String XMLamdMetadataNews = "http://www.utexas.edu/news/channels/xmlmetadata.rss";
		public static final String QuoteoftheDay = "http://www.utexas.edu/news/channels/qotd.rss";
		public static final String MotivationalQuoteoftheDay = "http://www.utexas.edu/news/channels/mqotd.rss";
		public static final String CNNTopStories = "http://www.utexas.edu/news/channels/cnn.rss";
		public static final String CNNWorld = "http://www.utexas.edu/news/channels/cnn_world.rss";
		public static final String CNNUS = "http://www.utexas.edu/news/channels/cnn_us.rss";
		public static final String CNNPolitics = "http://www.utexas.edu/news/channels/cnn_allpolitics.rss";
		public static final String CNNLaw = "http://www.utexas.edu/news/channels/cnn_law.rss";
		public static final String CNNTechnology = "http://www.utexas.edu/news/channels/cnn_tech.rss";
		public static final String CNNHealth = "http://www.utexas.edu/news/channels/cnn_health.rss";
		public static final String CNNEntertainment = "http://www.utexas.edu/news/channels/cnn_showbiz.rss";
		public static final String CNNTravel = "http://www.utexas.edu/news/channels/cnn_travel.rss";
		public static final String CNNEducation = "http://www.utexas.edu/news/channels/cnn_education.rss";
		public static final String CNNOffbeat = "http://www.utexas.edu/news/channels/cnn_offbeat.rss";
		public static final String CNNMostPopular = "http://www.utexas.edu/news/channels/cnn_mostpopular.rss";
		public static final String ITunesTop10 = "http://www.utexas.edu/news/channels/itunes.rss";
		public static final String ESPN = "http://www.utexas.edu/news/channels/espn.rss";
		public static final String Salon = "http://www.utexas.edu/news/channels/salon.rss";
		public static final String Slashdot = "http://www.utexas.edu/news/channels/slashdot.rss";
		public static final String SlashdotIT = "http://www.utexas.edu/news/channels/slashdotit.rss";
		public static final String WiredNews = "http://www.utexas.edu/news/channels/wirednews.rss";
		public static final String IntradocUsers = "http://www.utexas.edu/news/channels/intradoc.rss";
		public static final String AfricaNews = "http://www.utexas.edu/news/channels/africanews.rss";
		public static final String EuropeNews = "http://www.utexas.edu/news/channels/europenews.rss";
		public static final String LatinAmericaNews = "http://www.utexas.edu/news/channels/latinamericanews.rss";
		public static final String IndiaNews = "http://www.utexas.edu/news/channels/indianews.rss";
		public static final String ChinaNews = "http://www.utexas.edu/news/channels/chinanews.rss";
		public static final String MideastNew = "http://www.utexas.edu/news/channels/mideastnews.rss";
		public static final String Sports247 = "http://texas.247sports.com/Article/Index.rss";

		public static final String UTESSocialStudies ="http://blogs.utexas.edu/utes_socialstudies/feed/";
		public static final String GradStudentDev ="http://blogs.utexas.edu/gradstudentdev/feed/";
		public static final String TarltonLibraryNews ="http://blogs.utexas.edu/Tarlton-library-news/feed/";
		public static final String CreativePorblemSolving ="http://blogs.utexas.edu/creativeproblemsolving/feed/";
		public static final String FreeMindsProject ="http://blogs.utexas.edu/freeminds/feed/";
		public static final String ThelLAHHerald ="http://blogs.utexas.edu/lahonors/feed/";
		public static final String Polyphony ="http://blogs.utexas.edu/polyphony/feed/";
		public static final String PublicAffairsReporting ="http://blogs.utexas.edu/public-affairs-reporting/feed/";
		public static final String GeoNews ="http://blogs.utexas.edu/geonews/feed/";
		public static final String ElementsofComputing ="http://blogs.utexas.edu/elements/feed/";
		public static final String LegalwritingDotnetBlog ="http://blogs.utexas.edu/legalwriting/feed/";
		public static final String StraussIntistuteDidYouKnow ="http://blogs.utexas.edu/straussinstitute/feed/";
		public static final String UTAikidoClub ="http://blogs.utexas.edu/aikido/feed/";
		public static final String CeneterforTramsportationResearchNews ="http://blogs.utexas.edu/ctr/feed/";
		public static final String HoggBlog ="http://blogs.utexas.edu/hogg/feed/";
		public static final String TexasTaiChi ="http://blogs.utexas.edu/taichi/feed/";
		public static final String URBAdvising ="http://blogs.utexas.edu/urbadvising/feed/";
		public static final String GenderEquity ="http://blogs.utexas.edu/provost/feed/";
		public static final String TowerTalk ="http://blogs.utexas.edu/towertalk/feed/";
		public static final String WtotheMWPMBACMB ="http://blogs.utexas.edu/wpcm/feed/";
		public static final String questionsoveranswer ="http://blogs.utexas.edu/adamc/feed/";
		public static final String UTCommAbroad ="http://blogs.utexas.edu/intl/feed/";
		public static final String KeriStephensBlog ="http://blogs.utexas.edu/ks8004/feed/";
		public static final String HCMPHealthCareersMentorshipProgram ="http://blogs.utexas.edu/uthcmp/feed/";
		public static final String JohnMcCalpinsblog ="http://blogs.utexas.edu/jdm4372/feed/";
		public static final String HEASPA ="http://blogs.utexas.edu/heaspa/feed/";
		public static final String UTLARP ="http://blogs.utexas.edu/utlarp/feed/";
		public static final String AdministrativeSystemsMasterPlan = "http://blogs.utexas.edu/adminsysmasterplan/feed/";
		public static final String DesireePallais ="http://blogs.utexas.edu/dmp/feed/";
		public static final String CMRG ="http://blogs.utexas.edu/materials/feed/";
		public static final String ProjectMALES ="http://blogs.utexas.edu/projectmales/feed/";
		public static final String UTESWellness ="http://blogs.utexas.edu/utes_wellness/feed/";
		public static final String ECOAdvising ="http://blogs.utexas.edu/ecoadvising/feed/";
		public static final String UTESEducatorReasources ="http://blogs.utexas.edu/utes_educatorresources/feed/";
		public static final String ThimblesandCare ="http://blogs.utexas.edu/curtispe/feed/";
		public static final String NMC ="http://blogs.utexas.edu/nmc/feed/";
		public static final String RCWPS ="http://blogs.utexas.edu/rapoportcenterwps/feed/";
		public static final String SC11 ="http://blogs.utexas.edu/sc11/feed/";
		public static final String DMatUTA ="http://blogs.utexas.edu/datamanagement/feed/";
	}
}
