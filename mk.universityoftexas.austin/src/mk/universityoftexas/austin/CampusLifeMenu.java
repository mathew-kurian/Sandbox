package mk.universityoftexas.austin;

import android.app.Dialog;
import android.preference.PreferenceManager;
import mk.universityoftexas.austin.R;
import android.view.View;

public class CampusLifeMenu extends Driver{		

	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_CAMPUS_LIFE_MENU, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	protected Dialog onCreateDialog(int id){
		Dialog dialog = null;
		switch(id){
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.CAMPUS_LIFE_MENU, AVE.INSTRUCTION_PREF_CAMPUS_LIFE_MENU, InstructionDialog.PORTRAIT){
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
		case R.id.campus_life_dean:			setAddress("http://deanofstudents.utexas.edu/doscentral/mobile/"); 	break;
		case R.id.campus_life_health:		setAddress("http://www.healthyhorns.utexas.edu/mobile/");			break;
		case R.id.campus_life_housing:		setAddress("http://www.utexas.edu/student/housing/mobile/");		break;
		case R.id.campus_life_landmarks:	setAddress("http://landmarks.utexas.edu/mobile/artists/"); 			break;
		case R.id.campus_life_mental:		setAddress("http://www.cmhc.utexas.edu/mobile/"); 					break;
		case R.id.campus_life_bevo:			setAddress("http://www.utexas.edu/student/bevobucks/mobile/"); 		break;
		case R.id.campus_life_wildflower:	setAddress("http://www.wildflower.org/mobile/"); 					break;			
		}
		startActivity(CampusLifeWeb.class);
	}
	public void setAddress(String url){		
		AVE.CAMPUS_LIFE_WEB_URL = url;
	}
	@Override
	public int setLayout() {
		return R.layout.campus_life_menu;
	}
	@Override
	public void applyFont() {
		fontPastel(R.id.campus_life_dean);
		fontPastel(R.id.campus_life_health);
		fontPastel(R.id.campus_life_housing);
		fontPastel(R.id.campus_life_landmarks);
		fontPastel(R.id.campus_life_mental);
		fontPastel(R.id.campus_life_bevo);
		fontPastel(R.id.campus_life_wildflower);		
	}
	@Override
	public void modAVE() {}
	@Override
	public void action() {		
		defaultAnimationEngine(500);
	}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void preAction() {}
	@Override
	public int[] toAnimate() {
		return new int [] { R.id.campus_life_dean, R.id.campus_life_health,R.id.campus_life_housing, R.id.campus_life_landmarks,
				R.id.campus_life_mental,R.id.campus_life_bevo,R.id.campus_life_wildflower };
	}
	@Override
	public int[] animationTypes() {
		return new int [] { R.anim.fastfadein };
	}
}