package mk.universityoftexas.austin;

import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

import mk.universityoftexas.austin.R;
import android.preference.PreferenceManager;
import android.text.Html;
import android.text.TextUtils.TruncateAt;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.view.ViewGroup.OnHierarchyChangeListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Button;
import android.app.Dialog;
import android.graphics.Color;

public class Newspaper extends Driver {
	String newsTitle = "";
	String newsText = "";
	public void modAVE(){
	}
	@Override
	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_NEWSPAPER, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	protected Dialog onCreateDialog(int id){
		Dialog dialog = null;
		switch(id){
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.NEWSPAPER, AVE.INSTRUCTION_PREF_NEWSPAPER, InstructionDialog.LANDSCAPE){
				@Override
				public void onDismiss(View v) {}    				
			}.getDialog();
			break;
		case AVE.NEWSPAPER_DIALOG_ID:
			dialog = new Dialog (this, R.style.PaperDiag);
			lv = factory.inflate(R.layout.newspaper_dialog,null);

			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
			dialog.setContentView(lv);
			
			((Button) dialog.findViewById(R.id.newspaper_dialog_button)).setOnClickListener(new OnClickListener(){
				public void onClick(View v) {
					AVE.CURRENT.dismissDialog(AVE.NEWSPAPER_DIALOG_ID);				
				}
			});
			
			AVE.applyNewsFont(this, dialog.findViewById(R.id.newspaper_dialog_text));
			AVE.applyNewsFont(this, dialog.findViewById(R.id.newspaper_dialog_title));
			break;
		}
		AVE.setDialogWindowConfigurations(dialog);
		return dialog;
	}
	@Override
	public int setLayout() {
		return R.layout.newspaper;
	}
	protected void onPrepareDialog(int id, Dialog dialog){
		switch(id){
		case AVE.NEWSPAPER_DIALOG_ID:     
			((TextView) dialog.findViewById(R.id.newspaper_dialog_text)).setText(Html.fromHtml(newsText));
			((TextView) dialog.findViewById(R.id.newspaper_dialog_title)).setText(Html.fromHtml(newsTitle));
			break;
		}
	}
	@Override
	public void action() {
		((LinearLayout) findViewById(R.id.newspaper_layout_horizontal)).setOnHierarchyChangeListener(new OnHierarchyChangeListener(){
			int counter = 0;

			public void onChildViewAdded(View parent, View child) {
				((NewspaperArticle) child).setScrollXPosition(counter*300);
				counter++;
			}
			public void onChildViewRemoved(View parent, View child) {
				counter = 0;
			}			
		});

		new News_Download(XML_NEWS_BLOG.ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE).execute();		

		((ImageView) findViewById(R.id.newspaper_update_button)).setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				new News_Download(XML_NEWS_BLOG.ACTION_DOWNLOAD_SAVE).execute();		

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
class NewspaperArticle extends LinearLayout{

	TextView title;
	ScrollView scroll;
	LinearLayout inner;
	TextView content;
	TextView description;
	TextView link;
	TextView publication;
	int scrollX = 0;
	Newspaper n;
	NewspaperHighlight nh;
	String contentS;
	String descriptionS;
	String titleS;
	
	public NewspaperArticle(Newspaper n, NewspaperHighlight nh, JSONObject a) {
		super(n.getApplicationContext());

		this.n = n;
		this.nh = nh;

		LinearLayout.LayoutParams lp;

		lp = new LinearLayout.LayoutParams(300, LinearLayout.LayoutParams.FILL_PARENT);
		setOrientation(LinearLayout.VERTICAL);
		setLayoutParams(lp);
		setPadding(5, 0, 5, 0);

		LinearLayout bar = new LinearLayout(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 2);
		bar.setBackgroundColor(Color.BLACK);
		bar.setLayoutParams(lp);

		title = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		title.setLayoutParams(lp);
		title.setTextColor(Color.BLACK);
		AVE.applyNewsFont(n.getApplicationContext(), title);

		scroll = new ScrollView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT);
		scroll.setLayoutParams(lp);
		scroll.setFadingEdgeLength(0);

		inner = new LinearLayout(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(ScrollView.LayoutParams.FILL_PARENT, ScrollView.LayoutParams.FILL_PARENT);
		inner.setOrientation(LinearLayout.VERTICAL);
		inner.setLayoutParams(lp);

		description = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT);
		description.setLayoutParams(lp);
		description.setTextColor(Color.BLACK);
		description.setTextSize(11);
		description.setPadding(0, 0, 0, 5);

		content = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT);
		content.setLayoutParams(lp);
		content.setTextColor(Color.BLACK);
		content.setTextSize(11);

		link = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		link.setLayoutParams(lp);
		link.setTextColor(Color.BLUE);
		link.setTextSize(11);
		link.setText("Click to read more...");
		link.setPadding(0, 5, 0, 20);
		link.setPadding(0, 5, 0, 25);
		AVE.applyNewsFont(n.getApplicationContext(), link);

		publication = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		publication.setLayoutParams(lp);
		publication.setTextColor(Color.BLACK);
		publication.setTextSize(11);
		publication.setPadding(0, 10, 0, 5);
		AVE.applyNewsFont(n.getApplicationContext(), publication);

		inner.addView(description);
		inner.addView(content);
		inner.addView(publication);
		inner.addView(link);
		scroll.addView(inner);
		addView(title);
		addView(bar);
		addView(scroll);

		try {
			setTitle(a.getString(XML_NEWS_BLOG.TITLE));
			setContent(a.getString(XML_NEWS_BLOG.CONTENT));
			setLink(a.getString(XML_NEWS_BLOG.LINK));
			setPublication(a.getString(XML_NEWS_BLOG.PUBLICATION_DATE));
			setDescription(a.getString(XML_NEWS_BLOG.DESCRIPTION));
		} catch (JSONException e) {}

	}
	public void setTitle(String s){
		titleS = s;
		title.setText(titleS);	
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			title.setText("Untitled - Article");			
		}
	}	
	public void setContent(String s){		
		contentS = Jsoup.clean(s, Whitelist.basic());	
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER)
			contentS = "No information provided by RSS. Click the link to read more about the article";
		content.setLongClickable(true);
		content.setOnLongClickListener(new OnLongClickListener(){
			public boolean onLongClick(View v) {
				n.newsText = new String(contentS);
				n.newsTitle = new String(titleS);
				n.showDialog(AVE.NEWSPAPER_DIALOG_ID);		
				return true;
			}

		});
		content.setText(Html.fromHtml(contentS));	
	}
	public void setDescription(String s){
		descriptionS = "<b><i>" + Jsoup.clean(s, Whitelist.basic()).replace("&#187;&#160;Continue Reading", "") + "</b></i>";	
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER)
			description.setVisibility(View.GONE);
		description.setLongClickable(true);
		description.setOnLongClickListener(new OnLongClickListener(){
			public boolean onLongClick(View v) {
				n.newsText = new String(descriptionS);
				n.newsTitle = new String(titleS);
				n.showDialog(AVE.NEWSPAPER_DIALOG_ID);		
				return true;
			}

		});
		description.setText(Html.fromHtml(descriptionS));
	}
	public void setPublication(String s){
		publication.setText(s);
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			publication.setVisibility(View.GONE);
		}	
	}
	public void setLink(String s){
		link.setTag(s);
		link.setClickable(true);
		link.setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				AVE.NEWSPAPER_WEB_URL = (String) v.getTag();				
				n.startActivity(NewspaperWeb.class);
			}

		});
	}
	public LinearLayout getFormattedArticle(){
		return this;		
	}
	public void setScrollXPosition(){
		scrollX = getLeft();
	}
	public void setScrollXPosition(int x){
		scrollX = x;
	}
	public int getScrollXPosition() {
		return scrollX;
	}
}
class NewspaperHighlight extends LinearLayout{
	LinearLayout container;
	HighlightedTextView title;
	TextView publication;
	ImageView arrow;
	TextView description;
	JSONObject j;
	NewspaperArticle na;
	Newspaper n;

	public NewspaperHighlight(Newspaper n, JSONObject a){
		super(n.getApplicationContext());		

		j = a;
		this.n = n;

		LinearLayout.LayoutParams lp;

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		setOrientation(LinearLayout.HORIZONTAL);
		setLayoutParams(lp);
		setPadding(0, 0, 10, 5);

		container = new LinearLayout(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(AVE.getDip(n.getApplicationContext(), 150), LinearLayout.LayoutParams.WRAP_CONTENT);
		container.setOrientation(LinearLayout.VERTICAL);
		container.setLayoutParams(lp);
		container.setPadding(0, 0, 2, 0);

		title = new HighlightedTextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		title.setLayoutParams(lp);
		title.setTextSize(11);
		title.setTextColor(Color.rgb(255, 97, 3));
		title.setMaxLines(5);
		title.setEllipsize(TruncateAt.END);
		title.setPadding(5,5,5,5);

		arrow = new ImageView(n.getApplicationContext());
		arrow.setBackgroundResource(R.drawable.newspaper_arrow);
		lp = new LinearLayout.LayoutParams(AVE.getDip(n.getApplicationContext(), 12), LinearLayout.LayoutParams.WRAP_CONTENT);  //Force width
		lp.gravity = Gravity.CENTER_VERTICAL;		
		arrow.setLayoutParams(lp);	

		publication = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		publication.setLayoutParams(lp);
		publication.setTextSize(8);
		publication.setBackgroundColor(Color.BLACK);
		publication.setTextColor(Color.WHITE);

		description = new TextView(n.getApplicationContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		description.setLayoutParams(lp);
		description.setTextSize(8);
		description.setTextColor(Color.BLACK);
		description.setPadding(5, 0, 5, 0);
		description.setMaxLines(3);
		description.setEllipsize(TruncateAt.END);

		container.addView(publication);
		container.addView(title);		
		container.addView(description);	

		addView(container);
		addView(arrow);	

		try {
			setTitle(a.getString(XML_NEWS_BLOG.TITLE));
			setPublication(a.getString(XML_NEWS_BLOG.PUBLICATION_DATE));
			setDescription(a.getString(XML_NEWS_BLOG.DESCRIPTION));
		} catch (JSONException e) {}
	}
	public void setTitle(String s){	
		title.setText(s);
		title.setClickable(true);
		title.setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				Log.d("Newspaper", Integer.toString(na.getScrollXPosition()));
				n.findViewById(R.id.newspaper_scroll_horizontal).scrollTo(na.getScrollXPosition(), 0);
			}

		});
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER)	title.setVisibility(View.GONE);
	}	
	public void setPublication(String s){
		publication.setText("   "+s.replace("+0000", "").toUpperCase()+"   ");
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER)	publication.setText("   UNIVERSITY OF TEXAS: AUSTIN   ");
	}
	public void setDescription(String s){
		description.setText(Html.fromHtml(s));
		if(s == XML_NEWS_BLOG.ERROR_RECOGNIZER){
			description.setText("Click to read more...");
		}
	}
	public LinearLayout getFormattedHighlight(){
		return this;		
	}
	public LinearLayout getFormattedArticle() throws JSONException{
		na = new NewspaperArticle(n, this, j);
		return na;
	}	
}