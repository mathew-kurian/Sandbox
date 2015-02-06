package mk.universityoftexas.austin;

import java.util.ArrayList;

import mk.universityoftexas.austin.EIDConstants.Event;
import mk.universityoftexas.austin.EIDConstants.StatusCode;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

public class EID_BevoBucks extends EIDComponent{

	LinearLayout container;	
	private String about = "Bevo Bucks is the easy-to-use, cashless form of payment accessible through the student ID Card. Bevo Bucks is a prepaid account that students use to purchase food, goods and services at participating locations, both on and off campus.";
	private String about2 = "A meal plan is included with your housing contract. The long session (fall and spring semesters)contract includes $1400 Dine In Dollars and $300 Bevo Bucks. Your Dine In Dollars and Bevo Bucks will be added to your student ID card. You can monitor your account balance and where you are spending your Dine In Dollars and Bevo Bucks from the Web. Use your Dine In Dollars at certain locations within the Division of Housing and Food Service. These locations are in Kinsolving, Jester, and San Jacinto residence halls and offer an almost unlimited variety of choices. Residents can also use Dine In Dollars at the Littlefield Patio Cafe after 2 pm."
			;
	public EID_BevoBucks() {
		super();

		LinearLayout.LayoutParams lp;

		container = new LinearLayout(AVE.CURRENT);
		container = new LinearLayout(AVE.CURRENT);
		container.setOrientation(LinearLayout.VERTICAL);
		container.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT));		

		LinearLayout holder0 = new LinearLayout(AVE.CURRENT);
		holder0.setOrientation(LinearLayout.VERTICAL);
		holder0.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT));
		holder0.setBackgroundResource(R.drawable.sticky1);

		TextView title0 = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		title0.setPadding(20, 0, 0, 0);
		title0.setBackgroundColor(Color.BLUE);
		title0.setTextColor(Color.WHITE);
		title0.setLayoutParams(lp);
		title0.setText("ABOUT THE BEVOBUCKS");

		TextView content = new TextView(AVE.CURRENT);
		content.setPadding(20, 0, 20, 10);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		content.setLayoutParams(lp);
		content.setText(about);
		content.setTextColor(Color.BLACK);

		holder0.addView(title0);
		holder0.addView(content);	

		LinearLayout holder1 = new LinearLayout(AVE.CURRENT);
		holder1.setOrientation(LinearLayout.VERTICAL);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.topMargin = 20;
		holder1.setLayoutParams(lp);
		holder1.setBackgroundResource(R.drawable.sticky1);

		TextView title1 = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		title1.setPadding(20, 0, 0, 0);
		title1.setBackgroundColor(Color.RED);
		title1.setTextColor(Color.WHITE);
		title1.setLayoutParams(lp);
		title1.setText("BEVO BUCKS BALANCE");

		TextView balance = new TextView(AVE.CURRENT);
		balance.setPadding(20, 0, 20, 10);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		balance.setLayoutParams(lp);
		balance.setTextColor(Color.BLACK);

		holder1.addView(title1);
		holder1.addView(balance);		

		LinearLayout holder2 = new LinearLayout(AVE.CURRENT);
		holder2.setOrientation(LinearLayout.VERTICAL);
		lp  = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.topMargin = 20;
		holder2.setLayoutParams(lp);
		holder2.setBackgroundResource(R.drawable.sticky1);		

		TextView title2 = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		title2.setBackgroundColor(Color.RED);
		title2.setTextColor(Color.WHITE);
		title2.setLayoutParams(lp);
		title2.setPadding(20, 0, 0, 0);
		title2.setText("WHAT I OWE (BEVO ONLY)");

		TextView whatiowe = new TextView(AVE.CURRENT);
		whatiowe.setPadding(10, 0, 0, 0);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		whatiowe.setLayoutParams(lp);
		whatiowe.setPadding(20, 0, 20, 10);
		whatiowe.setTextColor(Color.BLACK);		

		Spinner spinner = new Spinner(AVE.CURRENT);
		spinner.setPrompt("Select the page you want to visit and press Access");
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		lp.topMargin = 30;
		spinner.setLayoutParams(lp);
		spinner.setBackgroundResource(R.drawable.sticky1);
		ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
				AVE.CURRENT, R.array.EID_BevoBucks_List, android.R.layout.simple_spinner_item);
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		spinner.setAdapter(adapter);	   

		holder2.addView(title2);
		holder2.addView(whatiowe);	

		TextView go = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		lp.gravity = Gravity.RIGHT;
		lp.topMargin = 15;
		go.setBackgroundResource(R.drawable.tape1);
		go.setLayoutParams(lp);
		go.setGravity(Gravity.CENTER);
		go.setTextColor(Color.BLACK);
		go.setText("Access");
		go.setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				((EID) AVE.CURRENT).showWebView("http://www.google.com");				
			}
		});

		LinearLayout holder3 = new LinearLayout(AVE.CURRENT);
		holder3.setOrientation(LinearLayout.HORIZONTAL);
		lp  = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_HORIZONTAL;
		lp.topMargin = 20;
		holder3.setLayoutParams(lp);

		ImageView im = new ImageView(AVE.CURRENT);
		lp  = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		im.setLayoutParams(lp);
		im.setImageResource(R.drawable.attention);

		ImageView ib = new ImageView(AVE.CURRENT);		
		lp  = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		ib.setLayoutParams(lp);
		ib.setImageResource(R.drawable.go);
		ib.setClickable(true);
		ib.setOnClickListener(new OnClickListener(){
			public void onClick(View v) {
				((EID) AVE.CURRENT).showWebView("http://www.google.com");				
			}
		});

		TextView visit = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		lp.leftMargin = 20;
		lp.rightMargin = 20;
		lp.gravity = Gravity.CENTER_VERTICAL;
		visit.setBackgroundResource(R.drawable.sticky2);
		visit.setLayoutParams(lp);
		visit.setGravity(Gravity.CENTER);
		visit.setTextColor(Color.BLACK);
		visit.setPadding(10, 10, 10, 10);
		visit.setText("Visit Merchent Special");


		holder3.addView(im);		
		holder3.addView(visit);
		holder3.addView(ib);

		LinearLayout holder4 = new LinearLayout(AVE.CURRENT);
		holder4.setOrientation(LinearLayout.VERTICAL);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.topMargin = 20;
		holder4.setLayoutParams(lp);
		holder4.setBackgroundResource(R.drawable.sticky1);

		TextView title3 = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		title3.setPadding(20, 0, 0, 0);
		title3.setBackgroundColor(Color.BLUE);
		title3.setTextColor(Color.WHITE);
		title3.setLayoutParams(lp);
		title3.setText(" ABOUT THE DINE IN DOLLARS");

		TextView content2 = new TextView(AVE.CURRENT);
		content2.setPadding(20, 0, 20, 10);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		content2.setLayoutParams(lp);
		content2.setTextColor(Color.BLACK);
		content2.setText(about2);

		holder4.addView(title3);
		holder4.addView(content2);	

		LinearLayout holder5 = new LinearLayout(AVE.CURRENT);
		holder5.setOrientation(LinearLayout.VERTICAL);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.topMargin = 20;
		holder5.setLayoutParams(lp);
		holder5.setBackgroundResource(R.drawable.sticky1);

		TextView title4 = new TextView(AVE.CURRENT);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		title4.setPadding(20, 0, 0, 0);
		title4.setBackgroundColor(Color.RED);
		title4.setTextColor(Color.WHITE);
		title4.setLayoutParams(lp);
		title4.setText("DINE IN DOLLARS BALANCE");

		TextView dinein = new TextView(AVE.CURRENT);
		dinein.setPadding(20, 0, 20, 10);
		lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		dinein.setLayoutParams(lp);
		dinein.setTextColor(Color.BLACK);

		holder5.addView(title4);
		holder5.addView(dinein);	

		container.addView(holder0);
		container.addView(holder1);
		container.addView(holder2);		
		container.addView(spinner);	
		container.addView(go);
		container.addView(holder3);	
		container.addView(holder4);
		container.addView(holder5);

		new BevoBucks_Download(balance, whatiowe, dinein).execute();
	}
	public LinearLayout getContainer(){
		return container;
	}
	public void destroy(){
		container.removeAllViews();
	}
}
class BevoBucks_Download extends ThreadWorker{

	private String bevoBucksURL = "https://utdirect.utexas.edu/bevobucks/addBucks.WBX";	
	private String dineInURL = "https://utdirect.utexas.edu/hfis/diningDollars.WBX";	
	private TextView t1;
	private TextView t2;	
	private TextView t3;
	ArrayList<String> AM = null;
	ArrayList<String> DM = null;

	public BevoBucks_Download(TextView t1, TextView t2, TextView t3){
		this.t1 = t1;
		this.t2 = t2;		
		this.t3 = t3;
	}	
	@Override
	public void preExecute() throws Exception {
		AVE.CURRENT.setProgressVISIBILITY(View.VISIBLE);
	}
	@Override
	public void background() throws Exception {
		publishProgress();

		String bevo = "";
		if(EIDManager.isDownloaded(Event.BEVO)) bevo = EIDManager.getDownloaded(Event.BEVO);	
		else									bevo = EIDManager.getPage(bevoBucksURL, Event.BEVO);
		AM = EIDManager.getEncapsulatedData(bevo, new String [] {"span", "class", "orange"}, true);

		publishProgress();
		
		String dinin = "";
		if(EIDManager.isDownloaded(Event.DINE_IN)) 	dinin = EIDManager.getDownloaded(Event.DINE_IN);
		else										dinin = EIDManager.getPage(dineInURL, Event.DINE_IN);
		DM = EIDManager.getEncapsulatedData(dinin, new String [] {"tr", "class", "datarow"}, false);

		bevo = null;
		dinin = null;

		publishProgress();
	}
	@Override
	public void postExecute() throws Exception {
		StatusCode sc = EIDManager.getStatus(Event.BEVO);
		StatusCode dn = EIDManager.getStatus(Event.DINE_IN);

		try{
			t1.setText(AM.get(0));
		}catch(Exception e){				
			if(sc==StatusCode.SUCCESS)
				t1.setText("You don't have bevobucks? You should get some and save money with it!");
			else
				t1.setText(sc.toString());
		}

		try{
			t2.setText(AM.get(1));
		}catch(Exception e){
			if(sc==StatusCode.SUCCESS)
				t2.setText("You have no owe nothing.");
			else
				t1.setText(sc.toString());
		}

		try{
			String dinin = DM.get(0);
			if(dinin.contains("dine"))
				t3.setText(dinin);
			else
				throw new Exception();
		}catch(Exception e){
			if(dn==StatusCode.SUCCESS)
				t3.setText("You have no dine in dollars.");
			else
				t3.setText(dn.toString());
		}

		((EID) AVE.CURRENT).hideProgress(0);
		((EID) AVE.CURRENT).showScrollView(EID.ANIMATION_DELAY);
		AVE.CURRENT.setProgressVISIBILITY(View.INVISIBLE);

		t1 = null;
		t2 = null;
		t3 = null;
		AM = null;
		DM = null;
	}
	@Override
	public void onProgressUpdate() throws Exception {
		AVE.CURRENT.setProgressINCREMENT(1);}
	@Override
	public void onError(Method m) {
		AVE.CURRENT.toast("Something went wrong in [" + m + "] ...oops!", 0);
	}
}