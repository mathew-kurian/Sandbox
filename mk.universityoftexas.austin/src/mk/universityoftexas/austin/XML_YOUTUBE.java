package mk.universityoftexas.austin;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import org.htmlparser.parserapplications.StringExtractor;
import org.htmlparser.util.ParserException;
import org.json.JSONException;
import org.json.JSONObject;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XML_YOUTUBE{	

	public static String YOUTUBE_TITLE = "Title";
	public static String YOUTUBE_THUMB = "PhotoUrl";
	public static String YOUTUBE_CONTENT = "content";
	public static String YOUTUBE_VIDEO_URL = "VideoUrl";
	public static String YOUTUBE_VIEWS = "views";
	
	public static ArrayList<String> extractYoutubeData(int page){
		StringExtractor a = new StringExtractor("http://mobile.utexas.edu/youtube/?page="+Integer.toString(page));
		String c = null;
		try {
			c = a.extractStrings(true);
		} catch (ParserException e) {
			e.printStackTrace();
		}	
		return normalizeYoutubeData(HTML_SPORT.removeXLinesFromStart(c, 2));		
	}
	/*
	 * views/thumburl/content/title/videourl
	 */
	public static ArrayList<String> normalizeYoutubeData(String s){
		ArrayList <String> a = HTML_SPORT.toList(s);
		
		for(int x = 0; x<5;x++)
			a.remove(10);
		for(int x = 0; x<a.size(); x++){
			String b = a.get(x).replace("<", "");
			Log.d("XML Youtube", b);
			String url = b.substring(0, b.indexOf('>'));
			String title = b.substring(b.indexOf('>')+1);
			
			JSONObject info = null;
			try {
				info = getYoutubeData(url);
			} catch (IOException e) {} 
			catch (ParserConfigurationException e) {} 
			catch (SAXException e) {}
			
			try {
				a.set(x, info.getString(YOUTUBE_VIDEO_URL));
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
			a.add(x, title);
			
			try {
				a.add(x, info.getString(YOUTUBE_CONTENT));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			try {
				a.add(x, info.getString(YOUTUBE_THUMB));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				a.add(x, info.getString(YOUTUBE_VIEWS));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			x+=5;
		}
		return a;		
	}
	@SuppressWarnings("unused")
	public static JSONObject getYoutubeData(String s) throws IOException, ParserConfigurationException, SAXException{
		JSONObject temp = null;
		URL metafeedUrl = new URL((s.replace("http://www.youtube.com/watch?v=", "http://gdata.youtube.com/feeds/mobile/videos/")).replace("&feature=youtube_gdata_player", ""));
		URLConnection connection;     
		connection= metafeedUrl.openConnection();

		HttpURLConnection  httpConnection = (HttpURLConnection)connection;        
		int resposnseCode= httpConnection.getResponseCode();

		if(resposnseCode == HttpURLConnection.HTTP_OK){
			
			InputStream in = httpConnection.getInputStream(); 

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			Document dom = db.parse(in);      
			Element docEle = dom.getDocumentElement();

			NodeList nl = docEle.getElementsByTagName("entry");
			if (nl != null && nl.getLength() > 0) {
				for (int i = 0 ; i < nl.getLength(); i++) {
					Element entry = (Element)nl.item(i);
					
					Element title = (Element)entry.getElementsByTagName("title").item(0);
					String titleStr = title.getFirstChild().getNodeValue();

					Element content = (Element)entry.getElementsByTagName("content").item(0);
					String contentStr = content.getAttribute("src");

					Element rsp = (Element)entry.getElementsByTagName("media:content").item(1);					
					String anotherurl=rsp.getAttribute("url");

					Element photoUrl = (Element)entry.getElementsByTagName("media:thumbnail").item(0);
					String photoStr = photoUrl.getAttribute("url");
					
					Element viewCount = (Element)entry.getElementsByTagName("yt:statistics").item(0);
					String viewCountStr = viewCount.getAttribute("favoriteCount");
					
					Log.d("XML Youtube",viewCountStr);
					
					temp = new JSONObject();
					try {
						temp.put(YOUTUBE_TITLE, titleStr);
						temp.put(YOUTUBE_CONTENT, contentStr);
						temp.put(YOUTUBE_THUMB, photoStr);
						temp.put(YOUTUBE_VIDEO_URL, anotherurl);
						temp.put(YOUTUBE_VIEWS, viewCountStr);
					} catch (JSONException e) {
						// TODO Auto-generated catch block
	               e.printStackTrace();
	             }

					return temp;
				}
			}
		}
		return null;
	}
}

