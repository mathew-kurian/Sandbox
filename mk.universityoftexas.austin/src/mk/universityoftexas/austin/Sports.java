package mk.universityoftexas.austin;

import java.util.ArrayList;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.preference.PreferenceManager;
import android.text.TextUtils.TruncateAt;
import mk.universityoftexas.austin.R;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class Sports extends Driver{		
	String currentRosterURL ="";
	String currentNewsURL ="";

	public Dialog rosterDialog = null;
	public Dialog newsDialog = null;
	public Dialog progressDialog = null;

	public LinearLayout sportsLayout;

	public ArrayList<ViewGroup> _roster = new ArrayList<ViewGroup>();
	public ArrayList<ViewGroup> _news = new ArrayList<ViewGroup>();
	public ArrayList<ViewGroup> _schedule = new ArrayList<ViewGroup>();
	public ArrayList<ViewGroup> _scores = new ArrayList<ViewGroup>();

	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_SPORTS, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}    
	@Override
	protected Dialog onCreateDialog(int id) {
		Dialog dialog = null;
		LayoutInflater factory = LayoutInflater.from(this);
		switch(id) {		
		case AVE.SPORTS_ROSTER_DIALOG_ID:
			dialog = new Dialog (this, R.style.PaperDiag);
			rosterDialog = dialog;
			View lv1 = factory.inflate(R.layout.roster_dialog,null);			 
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_name));
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_number));
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_height));
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_class));
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_weight));
			fontNewspaper(lv1.findViewById(R.id.roster_dialog_position));
			dialog.setContentView(lv1);	
			break;	
		case AVE.SPORTS_NEWS_DIALOG_ID:
			dialog = new Dialog (this, R.style.PaperDiag);
			newsDialog = dialog;
			View lv2 = factory.inflate(R.layout.news_dialog,null);
			dialog.setContentView(lv2);		
			fontNewspaper(lv2.findViewById(R.id.news_dialog_text));
			break;
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.SPORTS, AVE.INSTRUCTION_PREF_SPORTS, InstructionDialog.PORTRAIT){
				@Override
				public void onDismiss(View v) {}    				
			}.getDialog();
			break;
		}
		AVE.setDialogWindowConfigurations(dialog);
		return dialog;
	}
	public void selectionAlphaDefaulter(){
		((ImageView) findViewById(R.id.sports_news_arrow)).setAlpha(0);
		((ImageView) findViewById(R.id.sports_schedule_arrow)).setAlpha(0);
		((ImageView) findViewById(R.id.sports_roster_arrow)).setAlpha(0);
		((ImageView) findViewById(R.id.sports_scores_arrow)).setAlpha(0);
	}
	public void onClick(View target){	    	
		switch(target.getId()){	
		case R.id.sports_scores:	updateFromCache(HTML_SPORT.CONTENT_SCORES, false); selectionAlphaDefaulter(); ((ImageView) findViewById(R.id.sports_scores_arrow)).setAlpha(255); 		break;
		case R.id.sports_roster:	updateFromCache(HTML_SPORT.CONTENT_ROSTER, false); selectionAlphaDefaulter(); ((ImageView) findViewById(R.id.sports_roster_arrow)).setAlpha(255); 		break;
		case R.id.sports_news:		updateFromCache(HTML_SPORT.CONTENT_NEWS, false); selectionAlphaDefaulter(); ((ImageView) findViewById(R.id.sports_news_arrow)).setAlpha(255); 			break;
		case R.id.sports_schedule:	updateFromCache(HTML_SPORT.CONTENT_SCHEDULE, false); selectionAlphaDefaulter(); ((ImageView) findViewById(R.id.sports_schedule_arrow)).setAlpha(255); 	break;
		case R.id.refresh:			new Sports_Download(HTML_SPORT.ACTION_DOWNLOAD_SAVE).execute(); break;
		}
		sportsLayout.scrollTo(0, 0);
	}
	public void modAVE(){
	}
	public void updateFromCache(int action, boolean reset){
		if(reset){
			selectionAlphaDefaulter();
			((ImageView) findViewById(R.id.sports_scores_arrow)).setAlpha(255);
		}
		switch(action){
		case HTML_SPORT.CONTENT_NEWS: 		updateLeavesFrom(_news); break;
		case HTML_SPORT.CONTENT_SCHEDULE: 	updateLeavesFrom(_schedule); break;
		case HTML_SPORT.CONTENT_ROSTER: 	updateLeavesFrom(_roster); break;
		case HTML_SPORT.CONTENT_SCORES: 	updateLeavesFrom(_scores); break;
		}
	}
	private void updateLeavesFrom(ArrayList<ViewGroup>input){
		sportsLayout.removeAllViews();
		for(int x = 0; x<input.size(); x++){
			try{((ViewGroup)input.get(x).getParent()).removeView(input.get(x));}
			catch(NullPointerException npe){}
			((Sports) AVE.CURRENT).sportsLayout.addView(input.get(x));
		}
	}
	protected void createNewsLeaves(ArrayList<String> input){		
		_news.removeAll(_news);
		for(int x = 0; x< input.size(); x++){
			String  _link = input.get(x); x++;
			String _title = input.get(x);

			NewsLeaf nl = new NewsLeaf(this, _title, _link);

			_news.add(nl); //backup widgets for future cache
		}
	}
	@Override
	protected void onPrepareDialog (int id, Dialog dialog){
		switch(id) {
		case AVE.SPORTS_ROSTER_DIALOG_ID:
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_name)).setText("Loading...");
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setText("");
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_height)).setText("");
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_class)).setText("");
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_weight)).setText("");
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_position)).setText("");
			((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setImageResource(R.drawable.roster_error);
			new SportsPlayer_Download(currentRosterURL).execute();
			break;
		case AVE.SPORTS_NEWS_DIALOG_ID:    		
			new SportsNews_Download(currentNewsURL).execute();
			break;	
		}
	}

	protected void createScoreLeaves(ArrayList<String> input) throws IndexOutOfBoundsException{		
		_scores.removeAll(_scores);
		for(int x = 0; x< input.size(); x++){
			String _event = input.get(x); 		x++;
			String _win_lose = input.get(x);	x++;
			String _score1 = input.get(x); 		x++;
			String _score2 = input.get(x); 		x++;
			String _date = input.get(x); 		x++;
			String _location = input.get(x);

			ScoreLeaf sl = new ScoreLeaf(this, _event, _score1, _score2, _win_lose,_location, _date);

			_scores.add(sl); //backup widgets for future cache
		}
	}
	protected void createScheduleLeaf(ArrayList<String> input) throws IndexOutOfBoundsException{		
		_schedule.removeAll(_schedule);
		for(int x = 0; x< input.size();x++){			
			String _event = input.get(x); x++;
			String _location = input.get(x); x++;
			String _date = input.get(x); x++;
			String _time = input.get(x); x++;  x++;
			String _tv = input.get(x); x++;  x++;
			String _radio = input.get(x);		

			ScheduleLeaf sl = new ScheduleLeaf(this, _event, _location, _date, _time, _tv,_radio);

			_schedule.add(sl); //backup widgets for future cache
		}	
	}
	protected void createRosterLeaves(ArrayList<String> input) throws IndexOutOfBoundsException{		
		_roster.removeAll(_roster);
		for(int x = 0; x< input.size();x++){

			String _number = input.get(x); x++;
			String _link = input.get(x); x++;
			String _name = input.get(x); x++;
			String _position = input.get(x);

			RosterLeaf rl = new RosterLeaf(this, _number, _name, _position, _link);

			_roster.add(rl); //backup widgets for future cache
		}	
	}
	@Override
	public int setLayout() {
		return R.layout.sports;
	}
	@Override
	public void preAction() {
		// TODO Auto-generated method stub

	}
	@Override
	public void action() {		
		sportsLayout = ((LinearLayout) findViewById(R.id.sports_scroll_view_layout));
		new Sports_Download(HTML_SPORT.ACTION_ATTEMPT_LOAD_FALLBACK_DOWNLOAD_SAVE).execute();
		selectionAlphaDefaulter();		
		((ImageView) findViewById(R.id.sports_scores_arrow)).setAlpha(255);
	}
	@Override
	public int setProgressMAX() {
		return 10;
	}
	@Override
	public void applyFont() {
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
class RosterLeaf extends HighlightedLinearLayout implements OnClickListener{

	String link;
	RelativeLayout.LayoutParams rp;
	LinearLayout.LayoutParams lp;

	public RosterLeaf(Context context, String number, String name, String position, String link) {
		super(context);	
		this.link = link;
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;

		setClickable(true);
		setOnClickListener(this);
		setBackgroundResource(R.drawable.sports_leaf_generic);
		setLayoutParams(lp);
		setPadding(30, 0, 0, 0);

		TextView num = new TextView(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		num.setLayoutParams(lp);
		num.setText(number.length()<2 ? "0"+ number : number);
		num.setTextColor(Color.BLACK);
		num.setTextSize(25);
		num.setPadding(0, 0, 10, 0);
		AVE.applyNewsFont(getContext(), num);

		RelativeLayout rl = new RelativeLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		rl.setLayoutParams(lp);
		rl.setBackgroundColor(Color.TRANSPARENT);

		LinearLayout ll = new LinearLayout(getContext());
		rp = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		rp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
		ll.setLayoutParams(rp);
		ll.setBackgroundColor(Color.TRANSPARENT);


		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.LEFT;
		TextView nam = new TextView(getContext());
		nam.setLayoutParams(lp);
		nam.setText(name.substring(0, name.indexOf(" ")));
		nam.setTextSize(12);
		nam.setTextColor(Color.DKGRAY);
		nam.setGravity(Gravity.LEFT);
		AVE.applyNewsFont(getContext(), nam);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.LEFT;
		TextView las = new TextView(getContext());
		las.setLayoutParams(lp);
		las.setText("["+name.substring(name.indexOf(" ") + 1).toUpperCase()+"]");
		las.setTextSize(14);
		las.setTextColor(Color.BLACK);
		las.setGravity(Gravity.LEFT);
		las.setPadding(0, 0, 15, 0);
		AVE.applyNewsFont(getContext(), las);

		rp = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		rp.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		TextView pos = new TextView(getContext());
		pos.setLayoutParams(rp);
		pos.setText(position);
		pos.setTextSize(12);
		pos.setTextColor(Color.BLACK);
		pos.setGravity(Gravity.RIGHT);
		AVE.applyNewsFont(getContext(), pos);

		ll.addView(las);
		ll.addView(nam);
		rl.addView(ll);
		rl.addView(pos);
		addView(num);
		addView(rl);

	}
	public void onClick(View arg0) {
		((Sports) AVE.CURRENT).currentRosterURL = link;
		((Sports) AVE.CURRENT).showDialog(AVE.SPORTS_ROSTER_DIALOG_ID);		

	}			
}
class NewsLeaf extends HighlightedLinearLayout implements OnClickListener{

	String link;
	LinearLayout.LayoutParams lp;

	public NewsLeaf(Context context, String title, String link) {
		super(context);	
		this.link = link;
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;

		setClickable(true);
		setOnClickListener(this);
		setBackgroundResource(R.drawable.sports_leaf_generic);
		setLayoutParams(lp);
		setPadding(30, 15, 0, 15);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView til = new TextView(getContext());
		til.setLayoutParams(lp);
		til.setText(title);
		til.setTextSize(18);
		til.setTextColor(Color.BLACK);
		til.setGravity(Gravity.LEFT);
		til.setFadingEdgeLength(0);
		til.setHorizontalFadingEdgeEnabled(true);
		til.setMarqueeRepeatLimit(1);
		til.setSelected(true);
		til.setEllipsize(TruncateAt.MARQUEE);
		til.setSingleLine(true);
		AVE.applyNewsFont(getContext(), til);

		addView(til);

	}
	public void onClick(View arg0) {
		((Sports) AVE.CURRENT).currentNewsURL = link;
		((Sports) AVE.CURRENT).showDialog(AVE.SPORTS_NEWS_DIALOG_ID);		

	}			
}
class ScheduleLeaf extends HighlightedLinearLayout{

	LinearLayout.LayoutParams lp;
	RelativeLayout.LayoutParams rp;

	public ScheduleLeaf(Context context, String event, String location, String date, String emit, String tv, String radio) {
		super(context);	
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;

		setLayoutParams(lp);
		setPadding(20, 15, 20, 0);
		setOrientation(LinearLayout.VERTICAL);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView ev = new TextView(getContext());
		ev.setLayoutParams(lp);
		ev.setText(event);
		ev.setTextSize(18);
		ev.setTextColor(Color.BLACK);
		ev.setGravity(Gravity.CENTER);
		ev.setFadingEdgeLength(0);
		ev.setHorizontalFadingEdgeEnabled(true);
		ev.setMarqueeRepeatLimit(1);
		ev.setSelected(true);
		ev.setEllipsize(TruncateAt.MARQUEE);
		ev.setSingleLine(true);
		AVE.applyNewsFont(getContext(), ev);

		RelativeLayout container = new RelativeLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		container.setLayoutParams(lp);
		container.setBackgroundColor(Color.TRANSPARENT);	

		LinearLayout left = new LinearLayout(getContext());
		rp = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		rp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
		left.setLayoutParams(rp);
		left.setBackgroundColor(Color.TRANSPARENT);	
		left.setOrientation(LinearLayout.VERTICAL);

		LinearLayout left_in = new LinearLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.RIGHT;
		left_in.setLayoutParams(lp);
		left_in.setBackgroundColor(Color.TRANSPARENT);	
		left_in.setOrientation(LinearLayout.HORIZONTAL);

		LinearLayout right_in = new LinearLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.RIGHT;
		right_in.setLayoutParams(lp);
		right_in.setBackgroundColor(Color.TRANSPARENT);	
		right_in.setOrientation(LinearLayout.HORIZONTAL);

		LinearLayout right = new LinearLayout(getContext());
		rp = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		rp.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		left.setLayoutParams(rp);
		right.setBackgroundColor(Color.TRANSPARENT);	
		right.setOrientation(LinearLayout.VERTICAL);		

		ImageView tv_icon = new ImageView(getContext());
		tv_icon.setImageResource(R.drawable.tv);

		ImageView radio_icon = new ImageView(getContext());
		radio_icon.setImageResource(R.drawable.radio);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView loc = new TextView(getContext());
		loc.setLayoutParams(lp);
		loc.setText(location);
		loc.setTextSize(12);
		loc.setTextColor(Color.BLACK);
		AVE.applyNewsFont(getContext(), loc);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView da = new TextView(getContext());
		da.setLayoutParams(lp);
		da.setText(date);
		da.setTextSize(12);
		da.setTextColor(Color.BLACK);
		AVE.applyNewsFont(getContext(), da);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView em = new TextView(getContext());
		em.setLayoutParams(lp);
		em.setText(emit);
		em.setTextSize(12);
		em.setTextColor(Color.BLACK);
		AVE.applyNewsFont(getContext(), em);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView t = new TextView(getContext());
		t.setLayoutParams(lp);
		t.setText(tv.contains("coverage") ? "-" : tv);
		t.setTextSize(10);
		t.setTextColor(Color.BLACK);
		t.setPadding(0, 0, 5, 0);
		AVE.applyNewsFont(getContext(), t);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		TextView ra = new TextView(getContext());
		ra.setLayoutParams(lp);
		ra.setEllipsize(TruncateAt.END);
		ra.setText((radio.contains("coverage") ? "-" : radio));
		ra.setTextSize(10);
		ra.setTextColor(Color.BLACK);
		ra.setPadding(0, 0, 5, 0);
		AVE.applyNewsFont(getContext(), ra);

		left_in.addView(t);
		left_in.addView(tv_icon);
		right_in.addView(ra);
		right_in.addView(radio_icon);
		left.addView(left_in);
		left.addView(right_in);
		right.addView(loc);
		right.addView(em);
		container.addView(right);
		container.addView(left);
		addView(ev);
		addView(container);
	}		
}
class ScoreLeaf extends LinearLayout{

	LinearLayout.LayoutParams lp;

	public ScoreLeaf(Context context, String event, String score1, String score2, String win_lose, String location, String date) {
		super(context);	
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER;

		setOrientation(LinearLayout.VERTICAL);
		setLeafColorWin_Lose(win_lose);
		setLayoutParams(lp);
		setPadding(30, 0, 0, 40);

		TextView ev = new TextView(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		ev.setLayoutParams(lp);
		ev.setGravity(Gravity.CENTER);
		ev.setText(event);
		ev.setTextColor(Color.BLACK);
		ev.setTextSize(20);
		ev.setPadding(0, 0, 10, 0);
		ev.setFadingEdgeLength(0);
		ev.setHorizontalFadingEdgeEnabled(true);
		ev.setMarqueeRepeatLimit(-1);
		ev.setSelected(true);
		ev.setEllipsize(TruncateAt.MARQUEE);
		ev.setSingleLine(true);
		AVE.applyNewsFont(getContext(), ev);

		LinearLayout ll = new LinearLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_HORIZONTAL;
		ll.setLayoutParams(lp);
		ll.setBackgroundColor(Color.TRANSPARENT);		

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.LEFT | Gravity.CENTER_HORIZONTAL;
		TextView s1 = new TextView(getContext());
		s1.setLayoutParams(lp);
		s1.setText(score1);
		s1.setTextSize(18);
		s1.setTextColor(Color.BLACK);
		s1.setGravity(Gravity.LEFT);
		AVE.applyNewsFont(getContext(), s1);

		LinearLayout ll1 = new LinearLayout(getContext());
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER;
		ll1.setLayoutParams(lp);
		ll1.setOrientation(LinearLayout.VERTICAL);
		ll1.setBackgroundColor(Color.TRANSPARENT);		

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER;
		TextView loc = new TextView(getContext());
		loc.setPadding(30, 0, 30, 0);
		loc.setLayoutParams(lp);
		loc.setText(location);
		loc.setTextSize(12);
		loc.setTextColor(Color.BLACK);
		loc.setGravity(Gravity.CENTER);
		AVE.applyNewsFont(getContext(), loc);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER;
		TextView status = new TextView(getContext()){
			Paint paint = new Paint();
			@Override
			protected void onDraw(Canvas canvas) {
				super.onDraw(canvas);
				Rect rect = new Rect(0,0,getWidth(), getHeight());
				paint.setStyle(Paint.Style.STROKE);
				paint.setColor(Color.BLACK);
				paint.setStrokeWidth(2);
				canvas.drawRect(rect, paint);       
			}
		};
		status.setPadding(30, 0, 30, 0);
		status.setLayoutParams(lp);
		status.setText(win_lose.contains("w") || win_lose.contains("l") ? win_lose.substring(0, 1).toUpperCase() : "TBA");
		status.setTextSize(12);
		status.setTextColor(Color.BLACK);
		status.setGravity(Gravity.CENTER);
		AVE.applyNewsFont(getContext(), status);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER;
		TextView dt = new TextView(getContext());
		dt.setPadding(30, 0, 30, 0);
		dt.setLayoutParams(lp);
		dt.setText(date);
		dt.setTextSize(12);
		dt.setTextColor(Color.BLACK);
		dt.setGravity(Gravity.CENTER);
		AVE.applyNewsFont(getContext(), dt);

		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.RIGHT| Gravity.CENTER_HORIZONTAL;
		TextView s2 = new TextView(getContext());
		s2.setLayoutParams(lp);
		s2.setText(score2);
		s2.setTextSize(18);
		s2.setTextColor(Color.BLACK);
		s2.setGravity(Gravity.LEFT);
		AVE.applyNewsFont(getContext(), s2);

		ll1.addView(loc);
		ll1.addView(dt);
		ll1.addView(status);
		ll.addView(s1);	
		ll.addView(ll1);
		ll.addView(s2);
		addView(ev);
		addView(ll);

	}
	protected void setLeafColorWin_Lose(String s){
		if(s.contains("w"))
			setBackgroundResource(R.drawable.sports_win);
		else if(s.contains("l"))
			setBackgroundResource(R.drawable.sports_lose);
		else
			setBackgroundResource(R.drawable.sports_tba);
	}
}
