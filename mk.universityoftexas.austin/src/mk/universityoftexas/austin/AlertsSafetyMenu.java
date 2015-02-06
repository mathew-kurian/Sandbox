package mk.universityoftexas.austin;

import android.app.Dialog;
import android.content.Intent;
import android.net.Uri;
import android.preference.PreferenceManager;
import mk.universityoftexas.austin.R;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;

public class AlertsSafetyMenu extends Driver{
	Intent callIntent = new Intent(Intent.ACTION_CALL);
	String numberToCall;

	@Override
	public int setLayout() {
		return R.layout.alerts_safety_menu;
	}
	@Override
	public void action() {
		resizeLayout(R.id.rl, Driver.RESIZE_MARGIN_RIGHT);	
		defaultAnimationEngine(500);
	}
	@Override
	public void modAVE() {
		AVE.CURRENT = this;		
	}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {
		fontPastel(R.id.alerts_safety_autoassist);
		fontPastel(R.id.alerts_safety_behavior);
		fontPastel(R.id.alerts_safety_counsel);
		fontPastel(R.id.alerts_safety_environ);
		fontPastel(R.id.alerts_safety_lostfound);
		fontPastel(R.id.alerts_safety_nurse);
		fontPastel(R.id.alerts_safety_utpolice);		
	}
	public void onClick(View target){	    	
		switch(target.getId()){
		case R.id.alerts_safety_autoassist:		numberToCall = "5124714441"; 	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_behavior:		numberToCall = "5122325050";	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_counsel:		numberToCall = "5124712255";	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_environ:		numberToCall = "5124713511"; 	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_lostfound:		numberToCall = "5122329619"; 	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_nurse:			numberToCall = "5124756877"; 	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		case R.id.alerts_safety_utpolice:		numberToCall = "5124714441"; 	showDialog(AVE.ALERTS_CALL_DIALOG_ID); break;
		}
	}
	public void callNumber(String num){		
		callIntent.setData(Uri.parse("tel:"+num));
		callIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		startActivity(callIntent);
	}
	protected Dialog onCreateDialog(int id){
		Dialog dialog = null;
		switch(id){
		case AVE.ALERTS_CALL_DIALOG_ID:
			dialog = new Dialog (this, R.style.PaperDiag); 		
			LayoutInflater factory = LayoutInflater.from(this);
			View lv = factory.inflate(R.layout.alerts_safety_call_diag,null);
			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
			dialog.setContentView(lv);
			AVE.applyPastelFont(AlertsSafetyMenu.this, ((TextView) lv.findViewById(R.id.alerts_safety_call_text)));
			((Button) lv.findViewById(R.id.alerts_safety_call)).setOnClickListener(new OnClickListener(){
				public void onClick(View v) {
					((AlertsSafetyMenu) AVE.CURRENT).callNumber(numberToCall);
				}

			});
			break;
		case AVE.INSTRUCTION_DIALOG_ID:
			dialog = new InstructionDialog(this, Instructions.ALERTS_SAFETY_MENU, AVE.INSTRUCTION_PREF_ALERTS_SAFETY_MENU, InstructionDialog.PORTRAIT){
				@Override
				public void onDismiss(View v) {}    				
			}.getDialog();
			break;
		}
		AVE.setDialogWindowConfigurations(dialog);
		return dialog;
	}
	public void showInstructions(){
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean(AVE.INSTRUCTION_PREF_ALERTS_SAFETY_MENU, true)) showDialog(AVE.INSTRUCTION_DIALOG_ID);
	}
	@Override
	public void preAction() {}
	@Override
	public int[] toAnimate() {
		return new int [] {
				R.id.alerts_safety_autoassist, R.id.alerts_safety_behavior, R.id.alerts_safety_counsel,
				R.id.alerts_safety_environ, R.id.alerts_safety_lostfound, R.id.alerts_safety_nurse, R.id.alerts_safety_utpolice
		};
	}
	@Override
	public int[] animationTypes() {
		return new int [] { R.anim.fastfadein };
	}

}