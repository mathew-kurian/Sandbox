package mk.universityoftexas.austin;

import android.app.Dialog;
import android.preference.PreferenceManager;
import mk.universityoftexas.austin.R;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebSettings.ZoomDensity;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class CampusLifeWeb extends Driver{
	OverlayWebView webView;
	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_CAMPUS_LIFE_WEB, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
    protected Dialog onCreateDialog(int id){
    	Dialog dialog = null;
    	switch(id){
    		case AVE.INSTRUCTION_DIALOG_ID:
    			dialog = new InstructionDialog(this, Instructions.CAMPUS_LIFE_WEB, AVE.INSTRUCTION_PREF_CAMPUS_LIFE_WEB, InstructionDialog.PORTRAIT){
					@Override
					public void onDismiss(View v) {}    				
    			}.getDialog();
    			break;
    	}
    	 AVE.setDialogWindowConfigurations(dialog);
    	return dialog;
    }
	public void onClick(View target){	
		switch(target.getId()){    
    		case R.id.campus_life_web_back:				webView.goBack(); 				break;  
    		case R.id.campus_life_web_refresh:			webView.reload(); 				break;  
    		case R.id.campus_life_web_forward:			webView.goForward();			break;      		
    	}
    }
	@Override
	public int setLayout() {
		return R.layout.campus_life_web;
	}
	@Override
	public void action() {
		webView = (OverlayWebView) findViewById(R.id.campus_life_web_webview);
		webView.getSettings().setSupportZoom(true);     
		webView.setInitialScale(110);
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
		webView.loadUrl(AVE.CAMPUS_LIFE_WEB_URL);	        
		
	}
	@Override
	public void modAVE() {		
		
	}
	@Override
	public int setProgressMAX() {
		return 100;
	}
	@Override
	public void applyFont() {		
	}
	@Override
	public void preAction() {		
	}
	public void finish(){
		super.finish();
		webView.recycle();
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