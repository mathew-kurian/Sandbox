package mk.universityoftexas.austin.widget;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.CookieStore;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.htmlcleaner.HtmlCleaner;
import org.htmlcleaner.TagNode;

import android.app.PendingIntent;
import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.view.View;
import android.widget.RemoteViews;

public class UTWidgetService extends Service{



	public static CookieStore cookieStore = new BasicCookieStore();	
	public static final String LOGIN_USER = "loginUser";
	public static final String LOGIN_PASSWORD = "loginPass";
	public static final String PREF_FILENAME = "ut123";
	public RemoteViews remoteViews;
	public int widgetId = 0;
	public AppWidgetManager appWidgetManager;

	@Override
	public void onStart(Intent intent, int startId) {
		appWidgetManager = AppWidgetManager.getInstance(this
				.getApplicationContext());

		int[] allWidgetIds = intent
				.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS);		

		for(int x = 0; x<allWidgetIds.length;x++) {
			widgetId = allWidgetIds[x];

			remoteViews = new RemoteViews(this
					.getApplicationContext().getPackageName(),
					R.layout.main);

			try {
				action();
			} catch (Exception e) {	}

			Intent clickIntent = new Intent(this.getApplicationContext(),
					UTWidget.class);

			clickIntent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
			clickIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS,
					allWidgetIds);

			PendingIntent pendingIntent = PendingIntent.getBroadcast(
					getApplicationContext(), 0, clickIntent,
					PendingIntent.FLAG_UPDATE_CURRENT);

			remoteViews.setOnClickPendingIntent(R.id.update, pendingIntent);
			appWidgetManager.updateAppWidget(widgetId, remoteViews);
		}
		stopSelf();

		super.onStart(intent, startId);
	}
	public static String getPassword(Context c){
		try {
			return SharedPreferences(c).getString(LOGIN_PASSWORD, "password");
		} catch (Exception e) {
			return "password";
		}	
	}
	public static String getUsername(Context c){
		try {
			return SharedPreferences(c).getString(LOGIN_USER, "uteid");
		} catch (Exception e) {
			return "uteid";
		}		
	}
	static SharedPreferences SharedPreferences(Context c) throws Exception{
		return c.createPackageContext("mk.universityoftexas.austin", Context.MODE_WORLD_WRITEABLE).getSharedPreferences(PREF_FILENAME,
				Context.MODE_WORLD_READABLE);		
	}
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
	public void preActionUI(){

	}
	public void action() throws Exception{
		remoteViews.setViewVisibility(R.id.update, View.GONE);
		remoteViews.setViewVisibility(R.id.progress, View.VISIBLE);
		remoteViews.setViewVisibility(R.id.login_required, View.INVISIBLE);
		remoteViews.setViewVisibility(R.id.nointernet, View.INVISIBLE);
		remoteViews.setViewVisibility(R.id.data, View.INVISIBLE);		
		remoteViews.setViewVisibility(R.id.logo, View.GONE);

		appWidgetManager.updateAppWidget(widgetId, remoteViews);

		Handler h = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				String username = getUsername(getApplicationContext());
				boolean success = false;
				String currentPage = "";
				if (msg.what != 0) {
					System.out.println("not connected");
					remoteViews.setImageViewResource(R.id.logo, R.drawable.attention);
					remoteViews.setViewVisibility(R.id.nointernet, View.VISIBLE);
				} else { // code if connected
					System.out.println("connected");
					if(!username.equals("uteid")){
						if(cookieStore.getCookies().size()>0) //Use cookies to check  : output --> failed login, failed internet
							success = !(currentPage = getPage("https://utdirect.utexas.edu/hfis/diningDollars.WBX")).contains("concurrence");
						if(!success)						//relogin
							success = login(username, getPassword(getApplicationContext()));
						if(success && currentPage.equals(""))
							currentPage = getPage("https://utdirect.utexas.edu/hfis/diningDollars.WBX");
						if(success){						
							updateFields(remoteViews, currentPage);
							remoteViews.setImageViewResource(R.id.logo, R.drawable.logo);
							remoteViews.setViewVisibility(R.id.data, View.VISIBLE);
						}
					}else{
						remoteViews.setImageViewResource(R.id.logo, R.drawable.error);
						remoteViews.setViewVisibility(R.id.login_required, View.VISIBLE);
					}
				}

				remoteViews.setViewVisibility(R.id.progress, View.INVISIBLE);
				remoteViews.setViewVisibility(R.id.logo, View.VISIBLE);
				remoteViews.setViewVisibility(R.id.update, View.VISIBLE);
				
				appWidgetManager.updateAppWidget(widgetId, remoteViews);
			}
		};

		isNetworkAvailable(h, 2000);
		
	}
	public void updateFields(RemoteViews remoteViews, String fullPage){
		ArrayList<String> AM = getEncapsulatedData(fullPage, new String [] {"tr", "class", "datarow"}, false);


		remoteViews.setTextViewText(R.id.bevo, "None");
		remoteViews.setTextViewText(R.id.dinein, "None");

		for(int x = 0; x<AM.size(); x++){
			String str = AM.get(x);
			try{
				if(str.toLowerCase().contains("bevo"))
					remoteViews.setTextViewText(R.id.bevo, str.toLowerCase().replace(" ", "").replace("bevobucks", "").replace("active", ""));
			}catch(Exception e){}
			try{
				if(str.toLowerCase().contains("dinin"))
					remoteViews.setTextViewText(R.id.dinein, str);
			}catch(Exception e){}
		}


	}
	HtmlCleaner cleaner = new HtmlCleaner();
	ArrayList<String> getEncapsulatedData(String data, String [] tree, boolean preClean){
		TagNode rootNode;
		if(preClean)
			rootNode = cleaner.clean(data.replace(System.getProperty("line.separator"), "").replace("\t", "").replace("  ", "").replace("  ", "").replace("&nbsp;", ""));		
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
	public boolean login(final String _userName, final String _password) {		
		final DefaultHttpClient httpclient = new DefaultHttpClient();
		final HttpPost httppost = new HttpPost("https://utdirect.utexas.edu/security-443/logon_check.logonform");		
		httpclient.setCookieStore(cookieStore);

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("LOGON", _userName));
		nameValuePairs.add(new BasicNameValuePair("PASSWORDS", _password));		
		try {
			UrlEncodedFormEntity p_entity = new UrlEncodedFormEntity(nameValuePairs, HTTP.UTF_8);
			httppost.setEntity(p_entity);

			HttpResponse response = httpclient.execute(httppost);

			String output = EntityUtils.toString(response.getEntity());
			if(output.contains("success"))	return true;
		}
		catch(Exception e){	}		
		return false;
	}
	public static void isNetworkAvailable(final Handler handler, final int timeout) {

		// ask fo message '0' (not connected) or '1' (connected) on 'handler'
		// the answer must be send before before within the 'timeout' (in milliseconds)

		new Thread() {
			private boolean responded = false;
			@Override
			public void run() {
				// set 'responded' to TRUE if is able to connect with google mobile (responds fast)
				new Thread() {
					@Override
					public void run() {
						HttpGet requestForTest = new HttpGet("http://m.google.com");
						try {
							new DefaultHttpClient().execute(requestForTest); // can last...
							responded = true;
						} catch (Exception e) {}
					}
				}.start();

				try {
					int waited = 0;
					while(!responded && (waited < timeout)) {
						sleep(100);
						if(!responded ) { 
							waited += 100;
						}
					}
				} 
				catch(InterruptedException e) {} // do nothing 
				finally { 
					if (responded) { handler.sendEmptyMessage(0); } 
					else { handler.sendEmptyMessage(1); }
				}
			}
		}.start();
	}
	public String getPage(String url){
		final DefaultHttpClient httpclient = new DefaultHttpClient();
		final HttpGet httpGet = new HttpGet(url); 
		final StringBuilder returnable = new StringBuilder();
		httpclient.setCookieStore(cookieStore);		
		try{
			final HttpResponse response = httpclient.execute(httpGet);
			returnable.append(EntityUtils.toString(response.getEntity()));
		}catch(Exception e){}
		httpclient.getConnectionManager().shutdown(); 	
		return returnable.toString().length() > 200 ? returnable.toString() : "";
	}

}