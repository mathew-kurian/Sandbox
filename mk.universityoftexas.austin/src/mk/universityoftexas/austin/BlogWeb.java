package mk.universityoftexas.austin;

import mk.universityoftexas.austin.R;
import android.view.View;
import android.webkit.WebSettings.ZoomDensity;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class BlogWeb extends Driver{
	WebView webView;
	public void showInstructions(){}
    public void onClick(View target){	
		switch(target.getId()){    
		case R.id.blog_web_refresh:			webView.reload(); 				break;  	
	}
}
	@Override
	public int setLayout() {
		return R.layout.blog_web;
	}
	@Override
	public void action() {
		webView = (WebView) findViewById(R.id.blog_web_webview);
        webView.getSettings().setSupportZoom(true);      
        webView.setInitialScale(1);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDefaultZoom(ZoomDensity.FAR);
        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.setWebChromeClient(new WebChromeClient(){
			 public void onProgressChanged(WebView view, int progress) {	            	 
				 AVE.CURRENT.setProgressINT(progress);
			 }
		 });
        webView.setWebViewClient(new WebViewClient() {			     	
        	public boolean shouldOverrideUrlLoading(WebView view, String url){
				 view.loadUrl(url);
				 return false;
			 }	            
		 });	   
        webView.loadUrl(AVE.BLOG_WEB_URL);	   
	}
	@Override
	public void modAVE() {	
	}
	@Override
	public int setProgressMAX() {
		// TODO Auto-generated method stub
		return 100;
	}
	@Override
	public void applyFont() {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void preAction() {
		// TODO Auto-generated method stub
		
	}
	@Override
	public int[] toAnimate() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public int[] animationTypes() {
		// TODO Auto-generated method stub
		return null;
	}
}