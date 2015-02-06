package mk.universityoftexas.austin;

import java.util.List;

import org.apache.http.cookie.Cookie;

import android.os.Handler;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings.ZoomDensity;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.LinearLayout;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import mk.universityoftexas.austin.R;

public class EID extends Driver {	 
	private ScrollView scroll;
	private LinearLayout web_layout;
	private LinearLayout web_tools;
	private RelativeLayout progress;
	private WebView webView;
	public static int ANIMATION_DELAY = 300;
	private boolean webShown = false;
	public void modAVE(){
		AVE.CURRENT = this;
	}
	public void showInstructions(){}
	@Override
	public int setProgressMAX() {
		return 3;
	}
	@Override
	public int setLayout() {
		return R.layout.eid;
	}
	@Override
	public void applyFont() {}
	@Override
	public void action() {
		scroll = ((ScrollView) findViewById(R.id.eid_scrollview));
		web_layout = ((LinearLayout) findViewById(R.id.eid_web_layout));
		web_tools = ((LinearLayout) findViewById(R.id.eid_webtools));
		progress = ((RelativeLayout)findViewById(R.id.eid_progress_layout));
		createWebView();
		
		((TextView) findViewById(R.id.eid_name)).setText(EIDManager.fullName);
		((TextView) findViewById(R.id.eid_uteid)).setText(EIDManager.userName);
		
		EID_BevoBucks lp = new EID_BevoBucks();
		((LinearLayout) AVE.CURRENT.findViewById(R.id.eid_holder)).addView(lp.getContainer());
	}
	public void createWebView(){
		CookieSyncManager.createInstance(this).startSync();
		CookieManager cookieManager = CookieManager.getInstance();
		cookieManager.removeAllCookie();
		List<Cookie> ck = EIDManager.getCookies();
		for(int x = 0; x<ck.size(); x++){	
			Log.d("Cookie", ck.get(x).toString());
			String cookieString = ck.get(x).getName() + "=" + ck.get(x).getValue() + "; domain=" + ck.get(x).getDomain();
			cookieManager.setCookie(ck.get(x).getDomain(), cookieString);
		}
		PinnedLinearLayout pll = new PinnedLinearLayout(this);
		pll.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT));
		webView = new WebView(this);
		webView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT));
		webView.getSettings().setSupportZoom(true);     
		webView.setInitialScale(50);
		webView.getSettings().setBuiltInZoomControls(true);
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setDefaultZoom(ZoomDensity.FAR);
		webView.getSettings().setLoadWithOverviewMode(true);
		webView.getSettings().setTextSize(WebSettings.TextSize.LARGER);
		webView.setWebViewClient(new WebViewClient() {
			public boolean shouldOverrideUrlLoading(WebView view, String url){
				view.loadUrl(url);
				return false;
			}	            
		});	   
		webView.setWebChromeClient(new WebChromeClient(){
			public void onProgressChanged(WebView view, int progress) {	            	 
				AVE.CURRENT.setProgressINT(progress);
			}
		});
		pll.addView(webView);
		web_layout.addView(pll);
	}
	public void showProgress(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{			
					progress.setVisibility(View.VISIBLE);
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadein);
					progress.startAnimation(anim);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);
	}
	public void showWebView(String url){
		webShown = true;
		webView.clearHistory();
		webView.loadUrl(url);
		hideScrollView(0);
		showWeb(ANIMATION_DELAY);	
	}
	public void hideWebView(){
		webShown = false;
		hideWeb(0);
		showScrollView(ANIMATION_DELAY);
	}
	private void showWeb(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					web_layout.setVisibility(View.VISIBLE);
					web_tools.setVisibility(View.VISIBLE);
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadein);
					web_tools.startAnimation(anim);
					web_layout.startAnimation(anim);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);
	}
	private void hideWeb(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadeout);
					web_layout.startAnimation(anim);
					web_tools.startAnimation(anim);
					web_tools.setVisibility(View.GONE);
					web_layout.setVisibility(View.GONE);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);		
	}
	public void showScrollView(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					scroll.setVisibility(View.VISIBLE);
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadein);
					scroll.startAnimation(anim);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);
	}
	public void hideScrollView(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadeout);
					scroll.startAnimation(anim);
					scroll.setVisibility(View.GONE);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);
	}	
	public void hideProgress(int post){
		Handler hnd = new Handler();
		Runnable r = new Runnable(){
			public void run(){
				try{					
					Animation anim = AnimationUtils.loadAnimation(AVE.CURRENT, R.anim.fastfadeout);
					progress.startAnimation(anim);
					AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);
				}catch(Exception e){}		
			}
		};
		hnd.postDelayed(r, post);
	}
	@Override
	public void preAction() {}
	@Override
	public int[] animationTypes() {
		return null;
	}
	@Override
	public int[] toAnimate() {
		return null;
	}
	public void onBackPressed(){
		if(webShown)	hideWebView();
		else			super.onBackPressed();
	}
}
abstract class EIDComponent{
	public static int ANIMATION_DELAY = EID.ANIMATION_DELAY;
	public EIDComponent(){
		((EID) AVE.CURRENT).showProgress(0);
		((EID) AVE.CURRENT).hideScrollView(ANIMATION_DELAY);		
	}
	public abstract LinearLayout getContainer();
	public abstract void destroy();
}