package mk.universityoftexas.austin;

import android.app.Dialog;
import android.preference.PreferenceManager;
import android.view.View;

public class SportsMenu extends Driver{		

	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_SPORTS_MENU, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	public void onClick(View target){	
		switch(target.getId()){
		case R.id.football:				AVE.SPORT = HTML_SPORT.SPORTS.Football; 			break;  
		case R.id.baseball:				AVE.SPORT = HTML_SPORT.SPORTS.Baseball; 			break;  
		case R.id.wbball:				AVE.SPORT = HTML_SPORT.SPORTS.WomensBasketball; 			break;  
		case R.id.mbball:				AVE.SPORT = HTML_SPORT.SPORTS.MensBasketabll; 			break; 
		case R.id.wvolleyball:			AVE.SPORT = HTML_SPORT.SPORTS.WomensVolleyball; 			break; 
		case R.id.rowing:				AVE.SPORT = HTML_SPORT.SPORTS.Rowing; 			break; 
		case R.id.soccer:				AVE.SPORT = HTML_SPORT.SPORTS.Soccer; 			break;
		case R.id.msd:					AVE.SPORT = HTML_SPORT.SPORTS.MensSwimmingDiving; 			break;
		case R.id.wsd:					AVE.SPORT = HTML_SPORT.SPORTS.WomensSwimmingDiving; 			break;
		case R.id.mtf:					AVE.SPORT = HTML_SPORT.SPORTS.MensTrackField; 			break;
		case R.id.wtf:					AVE.SPORT = HTML_SPORT.SPORTS.WomensTrackField; 			break; 
		case R.id.softball:				AVE.SPORT = HTML_SPORT.SPORTS.Softball; 			break;
		case R.id.mgolf:				AVE.SPORT = HTML_SPORT.SPORTS.MensGolf; 			break; 
		case R.id.wgolf:				AVE.SPORT = HTML_SPORT.SPORTS.WomensGolf; 			break;  
		case R.id.mtennis:				AVE.SPORT = HTML_SPORT.SPORTS.MensTennis; 			break;   	
		case R.id.wtennis:				AVE.SPORT = HTML_SPORT.SPORTS.WomensTennis; 			break;  	
		}
		startActivity(Sports.class);
	}	
	@Override
	protected Dialog onCreateDialog(int id) {
		Dialog dialog = null;
		switch(id) {		
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.SPORTS_MENU, AVE.INSTRUCTION_PREF_SPORTS_MENU, InstructionDialog.PORTRAIT){
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
		return R.layout.sports_menu;
	}
	@Override
	public void preAction() {}
	@Override
	public void action() {
	}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {
		fontNewspaper(R.id.football);
		fontNewspaper(R.id.baseball);
		fontNewspaper(R.id.wvolleyball);
		fontNewspaper(R.id.mbball);
		fontNewspaper(R.id.mtennis);
		fontNewspaper(R.id.wtennis);
		fontNewspaper(R.id.rowing);
		fontNewspaper(R.id.wbball);
		
		fontPastel(R.id.soccer);
		fontPastel(R.id.msd);
		fontPastel(R.id.wsd);
		fontPastel(R.id.mtf);
		fontPastel(R.id.wtf);
		fontPastel(R.id.softball);
		fontPastel(R.id.mgolf);
		fontPastel(R.id.wgolf);
	}
	@Override
	public void modAVE() {
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
