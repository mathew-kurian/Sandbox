package mk.universityoftexas.austin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mk.universityoftexas.austin.EIDConstants.Event;
import mk.universityoftexas.austin.EIDConstants.StatusCode;

import org.apache.http.HttpResponse;
import android.content.SharedPreferences;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.htmlcleaner.HtmlCleaner;
import org.htmlcleaner.TagNode;

public class EIDManager {

	public static String fullName = "";	
	public static String userName = "";	
	public static String password = "";	
	public static CookieStore cookieStore = new BasicCookieStore();
	public  static AuthenticationManager authenticationManager = new AuthenticationManager();
	public static ScrapeManager scrapeManager = new ScrapeManager();
	public static String getPassword(){
		return AVE.CURRENT.SharedPreferences().getString(AVE.LOGIN_PASSWORD, "password");	
	}
	public static StatusCode getStatus(Event e){
		return authenticationManager.getAttribute(e);
	}
	public static boolean isDownloaded(Event e){
		return scrapeManager.isDownloaded(e);
	}
	public static String getDownloaded(Event e){
		return scrapeManager.getAttribute(e);
	}
	public static List<Cookie> getCookies(){
		return cookieStore.getCookies();
	}
	public static String getUsername(){
		return AVE.CURRENT.SharedPreferences().getString(AVE.LOGIN_USER, "uteid");		
	}
	public static void setUsername(String user){
		SharedPreferences.Editor editor = AVE.CURRENT.SharedPreferences().edit();
		editor.putString(AVE.LOGIN_USER, user);
		editor.commit();
	}
	public static void setPassword(String pass){	
		SharedPreferences.Editor editor = AVE.CURRENT.SharedPreferences().edit();
		editor.putString(AVE.LOGIN_PASSWORD, pass);
		editor.commit();
	}
	public static boolean getRemember(){	
		return AVE.CURRENT.SharedPreferences().getBoolean(AVE.LOGIN_REMEMBER, true);
	}
	public static void setRemember(boolean b){	
		SharedPreferences.Editor editor = AVE.CURRENT.SharedPreferences().edit();
		editor.putBoolean(AVE.LOGIN_REMEMBER, b);
		editor.commit();
	}
	public static void autoLogin(String userName, String password) {		
		login(getUsername(), getPassword());
	} 
	public static void login(final String _userName, final String _password) {		
		final DefaultHttpClient httpclient = new DefaultHttpClient();
		final HttpPost httppost = new HttpPost("https://utdirect.utexas.edu/security-443/logon_check.logonform");		
		httpclient.setCookieStore(cookieStore);

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("LOGON", _userName));
		nameValuePairs.add(new BasicNameValuePair("PASSWORDS", _password));		
		try {
			final UrlEncodedFormEntity p_entity = new UrlEncodedFormEntity(nameValuePairs, HTTP.UTF_8);
			httppost.setEntity(p_entity);

			final HttpResponse response = httpclient.execute(httppost);
			int status_code = response.getStatusLine().getStatusCode();

			new AutheticationReader(EIDConstants.Event.LOGIN, status_code){

				@Override
				public boolean checkForkSuccess() throws Exception {
					String output = EntityUtils.toString(response.getEntity());
					String marker1 = "\"\\n\\n";
					String marker2 = " has";
					Log.d("sdf", output);
					fullName = output.substring(output.indexOf(marker1)+marker1.length(), output.indexOf(marker2));					
					if(output.contains("success")){				
						return true;
					}
					return false;
				}
				@Override
				public void onSuccess() throws Exception{		
					Log.d("EIDManager", "Login successful to " + getUsername(), "#FF00FF");
					userName = _userName;
					password = _password;
				}
			};

		} catch (ClientProtocolException e) {
			AutheticationReader.forceType(EIDConstants.Event.LOGIN, EIDConstants.StatusCode.CLIENT_ERROR);
		} catch (IOException e) {
			AutheticationReader.forceType(EIDConstants.Event.LOGIN, EIDConstants.StatusCode.CONNECTIVITY_ERROR);
		}		
		httpclient.getConnectionManager().shutdown();   
	} 
	public static void printCookies(CookieStore c){
		Log.d("Cookie", "==================", "white");
		List<Cookie> cookies  = c.getCookies();
		if (cookies.isEmpty()) {
			Log.d("Cookie", "None", "#FF00FF");
		} else {
			for (int i = 0; i < cookies.size(); i++) {
				Log.d("Cookie", cookies.get(i).toString(), "#FF00FF");
			}
		}
		Log.d("Cookie", "==================", "#FF00FF");
	}

	static HtmlCleaner cleaner = new HtmlCleaner();
	static ArrayList<String> getEncapsulatedData(String data, String [] tree, boolean preClean){
		TagNode rootNode;
		if(preClean)
			rootNode = cleaner.clean(data.replace(System.getProperty("line.separator"), "").replace("\t", "").replace("  ", "").replace("  ", ""));		
		else
			rootNode = cleaner.clean(data);		
		ArrayList<String> output = new ArrayList<String>();
		TagNode divElements[] = rootNode.getElementsByName(tree[0], true);

		for (int i = 0; divElements != null && i < divElements.length; i++){
			String classType = divElements[i].getAttributeByName(tree[1]);
			if (classType != null && classType.equals(tree[2]))
				output.add(divElements[i].getText().toString());
		}
		return output;
	}
	public static String getPage(String url, final EIDConstants.Event e){
		final DefaultHttpClient httpclient = new DefaultHttpClient();
		final HttpGet httpGet = new HttpGet(url); 
		final StringBuilder returnable = new StringBuilder();
		
		httpclient.setCookieStore(cookieStore);

		try {
			final HttpResponse response = httpclient.execute(httpGet);
			int status_code = response.getStatusLine().getStatusCode();			
			
			new AutheticationReader(e, status_code){

				@Override
				public boolean checkForkSuccess() throws Exception {
					return true;
				}
				@Override
				public void onSuccess() throws Exception{					
					Log.d("EIDManager", "Scraping data.", "#FF00FF");
					returnable.append(EntityUtils.toString(response.getEntity()));
					scrapeManager.setAttribute(e, returnable.toString());
				}
			};
			
			return returnable.toString();
			
		} catch (ClientProtocolException ec) {
			AutheticationReader.forceType(e, EIDConstants.StatusCode.CONNECTIVITY_ERROR);
			returnable.setLength(0);
		} catch (IOException ec) {
			AutheticationReader.forceType(e, EIDConstants.StatusCode.CONNECTIVITY_ERROR);
			returnable.setLength(0);
		}
		
		httpclient.getConnectionManager().shutdown(); 
		
		if(!isLoginActive())
			AVE.CURRENT.startActivity(Entrance.class);
		
		return returnable.toString();
	}
	public static boolean isLoginActive(){
		String check = getPage("https://utdirect.utexas.edu/bevobucks/menu.WBX", Event.LOGIN);
		if(check.contains("Unauthorized use of UT Austin computer")){
			AVE.CURRENT.toast("Session timeout. Sorry login again.", 1);	
			return false;
		}
		return true;
	}
}
class EIDConstants{
	public enum StatusCode{
		USERNAME_PASSWORD_ERROR {
			public String toString(){
				return "EID/Password error";				
			}
		},
		CONNECTIVITY_ERROR{
			public String toString(){
				return "Connectivity error";				
			}
		},
		REDIRECTION_ERROR{
			public String toString(){
				return "Redirection error";				
			}
		},
		SERVER_ERROR{
			public String toString(){
				return "Server error";				
			}
		},
		CLIENT_ERROR{
			public String toString(){
				return "Client error";				
			}
		},
		SUCCESS{
			public String toString(){
				return "Succesful";				
			}
		}
	}
	public enum Event{
		LOGIN,
		BEVO,
		DINE_IN
	}
}
abstract class AutheticationReader{	
	public AutheticationReader(EIDConstants.Event m, int status_code){
		try{
			if (status_code >= 300 && status_code<400){
				EIDManager.authenticationManager.setAttribute(m, EIDConstants.StatusCode.REDIRECTION_ERROR);
			}else if (status_code >= 400 && status_code<500){
				EIDManager.authenticationManager.setAttribute(m, EIDConstants.StatusCode.SERVER_ERROR);
			}else if (status_code >= 500 && status_code<600){
				EIDManager.authenticationManager.setAttribute(m, EIDConstants.StatusCode.CLIENT_ERROR);
			}else{
				EIDManager.authenticationManager.setAttribute(m, EIDConstants.StatusCode.USERNAME_PASSWORD_ERROR);			
				if(checkForkSuccess()){
					EIDManager.authenticationManager.setAttribute(m, EIDConstants.StatusCode.SUCCESS);	
					onSuccess();
				}
			}
		}catch(Exception e){}
	}
	public abstract boolean checkForkSuccess() throws Exception;
	public abstract void onSuccess() throws Exception;
	public static void forceType(EIDConstants.Event event, EIDConstants.StatusCode status){
		EIDManager.authenticationManager.setAttribute(event, status);
	}
}
abstract class AutheticationListener{	
	public AutheticationListener(EIDConstants.Event m){		
		EIDConstants.StatusCode isAuthenticated = EIDManager.authenticationManager.getAttribute(m);		
		if(isAuthenticated == EIDConstants.StatusCode.SUCCESS){
			try {
				onSuccess();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(isAuthenticated == EIDConstants.StatusCode.USERNAME_PASSWORD_ERROR){
			try {
				onFailure(EIDConstants.StatusCode.USERNAME_PASSWORD_ERROR);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(isAuthenticated == EIDConstants.StatusCode.CONNECTIVITY_ERROR){
			try {
				onFailure(EIDConstants.StatusCode.CONNECTIVITY_ERROR);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(isAuthenticated == EIDConstants.StatusCode.REDIRECTION_ERROR){
			try {
				onFailure(EIDConstants.StatusCode.REDIRECTION_ERROR);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(isAuthenticated == EIDConstants.StatusCode.SERVER_ERROR){
			try {
				onFailure(EIDConstants.StatusCode.SERVER_ERROR);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(isAuthenticated == EIDConstants.StatusCode.CLIENT_ERROR){
			try {
				onFailure(EIDConstants.StatusCode.CLIENT_ERROR);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	public abstract void onSuccess() throws Exception;
	public abstract void onFailure(EIDConstants.StatusCode error) throws Exception;
}
class AuthenticationManager{	
	private HashMap<EIDConstants.Event, EIDConstants.StatusCode> authentication = new HashMap<EIDConstants.Event, EIDConstants.StatusCode>();	
	public AuthenticationManager(){}
	public void setAttribute(EIDConstants.Event event, EIDConstants.StatusCode status){
		authentication.remove(event);
		authentication.put(event, status);
	}	
	public void removeAttribute(EIDConstants.Event event){
		authentication.remove(event);
	}
	public EIDConstants.StatusCode getAttribute(EIDConstants.Event event){
		return authentication.get(event) != null ? authentication.get(event) : EIDConstants.StatusCode.CLIENT_ERROR;
	}
	public EIDConstants.StatusCode getAuthentication(EIDConstants.Event event){
		return authentication.get(event) != null ? authentication.get(event) : EIDConstants.StatusCode.CLIENT_ERROR;
	}
}
class ScrapeManager{	
	private HashMap<EIDConstants.Event, String> data = new HashMap<EIDConstants.Event, String>();	
	public ScrapeManager(){}
	public void setAttribute(EIDConstants.Event event, String scape){
		data.remove(event);
		data.put(event, scape);
	}	
	public boolean isDownloaded (EIDConstants.Event event){
		return data.containsKey(event);
	}
	public void removeAttribute(EIDConstants.Event event){
		data.remove(event);
	}
	public String getAttribute(EIDConstants.Event event){
		return data.get(event) != null ? data.get(event) : null;
	}
}