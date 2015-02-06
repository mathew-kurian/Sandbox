package tiffany.wordeditor;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

import android.text.Html;
import android.util.Log;
import android.os.AsyncTask;

public class Blog_Download extends AsyncTask<Void, Void, Boolean> {
	String s = "not available";
	Home h;
	public Blog_Download(Home h){
		this.h = h;
	}
	@Override
    protected void onPreExecute() {
		
	}
	@Override
	protected Boolean doInBackground(Void... params) {
		s = fetchURLData("http://www.utexas.edu/");
		
		return true;			
	}	
	protected void onPostExecute(Boolean result) { 
        ((WordEditor) h.findViewById(R.id.editText1)).setText(Html.fromHtml(s));
    } 
	public static String fetchURLData(String URL){
		URL url = null;
		try {
			url = new URL(URL);
		} catch (MalformedURLException e) {
			Log.d("Error reading url (A)", URL);
		}
		
		BufferedReader in  = null;
		try {
			in = new BufferedReader(
			        new InputStreamReader(
			        		url.openStream()));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String inputLine = "";
		String x = "";
		
		try {
			while ((inputLine = in.readLine()) != null){
				  x = x + inputLine;
			}
		} catch (IOException e) {
			Log.d("Error reading url (B)", e.toString());
		} 		
		  
		try {
			in.close();
		} catch (IOException e) {
			Log.d("Error reading url (C)", e.toString());
		}
		
		return x;
	}
}