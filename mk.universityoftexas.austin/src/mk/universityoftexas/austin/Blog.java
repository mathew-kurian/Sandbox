package mk.universityoftexas.austin;

import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

import mk.universityoftexas.austin.R;
import android.preference.PreferenceManager;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.app.Dialog;
import android.graphics.Color;

public class Blog extends Driver {
    /** Called when the activity is first created. */
    public void modAVE(){}
    @Override
    public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_BLOG, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
    protected Dialog onCreateDialog(int id){
    	Dialog dialog = null;
    	switch(id){
    		case AVE.INSTRUCTION_DIALOG_ID:
    			dialog = new InstructionDialog(this, Instructions.BLOG, AVE.INSTRUCTION_PREF_BLOG, InstructionDialog.PORTRAIT){
					@Override
					public void onDismiss(View v) {}    				
    			}.getDialog();
    			break;
    	}
    	AVE.setDialogWindowConfigurations(dialog);
    	return dialog;
    }
	@Override
	public int setLayout() {
		return R.layout.blog;
	}
	@Override
	public void action() {
		new Blog_Download(XML_NEWS_BLOG.ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE).execute();		
		
		((TextView) findViewById(R.id.blog_update)).setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				new Blog_Download(XML_NEWS_BLOG.ACTION_DOWNLOAD_SAVE).execute();		
				
			}
			
		});
	}
	@Override
	public int setProgressMAX() {
		return 4;
	}
	@Override
	public void applyFont() {
		
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
class BlogArticle extends LinearLayout{
		
	TextView title;
	TextView description;
	TextView content;
	TextView link;
	TextView publication;
	int scrollX = 0;
	Blog b;
	
	public BlogArticle(Blog b, JSONObject a) {
		super(b);
				
		this.b = b;
		
		LinearLayout.LayoutParams lp;
				
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		setOrientation(LinearLayout.VERTICAL);
		setLayoutParams(lp);
		setPadding(0, 0, 0, 10);
		
		title = new TextView(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		title.setLayoutParams(lp);
		title.setGravity(Gravity.RIGHT);
		title.setTextColor(Color.RED);
		
		description = new TextView(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT);
		description.setLayoutParams(lp);
		description.setTextColor(Color.BLACK);
		description.setGravity(Gravity.RIGHT);
		description.setTextSize(11);
			
		content = new TextView(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT);
		content.setLayoutParams(lp);
		content.setTextColor(Color.BLACK);
		content.setTextSize(10);
		
		link = new TextView(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		link.setLayoutParams(lp);
		link.setTextColor(Color.RED);
		link.setTextSize(8);
		link.setText("Online Version");
		link.setPadding(0, 0, 0, 5);
		link.setGravity(Gravity.RIGHT);
		
		publication = new TextView(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		publication.setLayoutParams(lp);
		publication.setTextColor(Color.BLACK);
		publication.setTextSize(8);
		publication.setPadding(0, 3, 0, 5);
		publication.setGravity(Gravity.RIGHT);	
		
		LinearLayout bar = new LinearLayout(b);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 2);
		bar.setBackgroundColor(Color.RED);
		bar.setLayoutParams(lp);

		addView(title);
		addView(publication);
		addView(content);
		addView(link);
		addView(bar);
				
		try {
			setTitle(a.getString(XML_NEWS_BLOG.TITLE));
			setContent(a.getString(XML_NEWS_BLOG.CONTENT));
			setLink(a.getString(XML_NEWS_BLOG.LINK));
			setPublication(a.getString(XML_NEWS_BLOG.PUBLICATION_DATE));
			setDescription(a.getString(XML_NEWS_BLOG.DESCRIPTION));
		} catch (JSONException e) {}
		
	}
	public void setTitle(String s){
		title.setText(s);	
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			title.setText("Untitled - Article");			
		}
	}	
	public void setContent(String s){
		content.setText(Html.fromHtml(Jsoup.clean(s, Whitelist.basic())));	
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER)
			content.setText("No information provided by RSS. Click the link to read more about the article");	
	}
	public void setDescription(String s){
		description.setText(Html.fromHtml("<p>" + Jsoup.clean(s, Whitelist.simpleText()).replace("[...]", "...") + "</p>"));
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			description.setVisibility(View.GONE);
		}
	}
	public void setPublication(String s){
		publication.setText(s.replace("+0000", ""));
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			publication.setVisibility(View.GONE);
		}	
	}
	public void setLink(String s){
		link.setTag(s);
		link.setClickable(true);
		link.setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				AVE.BLOG_WEB_URL = (String) v.getTag();				
				b.startActivity(BlogWeb.class);
			}
			
		});
	}
	public LinearLayout getFormattedArticle(){
		return this;		
	}
}