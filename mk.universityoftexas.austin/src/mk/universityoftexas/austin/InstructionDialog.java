package mk.universityoftexas.austin;

import android.app.Activity;
import android.app.Dialog;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import mk.universityoftexas.austin.R;
import android.text.Html;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;

public abstract class InstructionDialog implements OnClickListener{

	private Dialog dialog = null;
	
	private String id;
		
	private Activity a;
	
	private LayoutInflater factory;
	
	private View lv;
	
	public static final int PORTRAIT = 0x450;
	public static final int LANDSCAPE = 0x213;
	
	public InstructionDialog(Activity act, String instructions, String ID, int format){
		id = ID;
		a = act;
		factory = LayoutInflater.from(act);
		
		dialog = new Dialog (act, R.style.PaperDiag);        
        lv = factory.inflate(R.layout.instruction_dialog,null);
        
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(lv);
	    
	    String title = instructions.substring(0, instructions.indexOf("|"));
	    instructions = instructions.substring(instructions.indexOf("|")+1);
	    
	    AVE.applyPastelFont(a, ((TextView) lv.findViewById(R.id.instruction_dialog_title)));
	    AVE.applyPastelFont(a, ((TextView) lv.findViewById(R.id.instruction_dialog_text)));
	    AVE.applyPastelFont(a, ((CheckBox) lv.findViewById(R.id.instruction_dialog_checkbox)));
	    
	    if(format == LANDSCAPE){
	    	LayoutParams rl_p = new LayoutParams(
			        LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
	    	rl_p.leftMargin = 100;
	    	rl_p.rightMargin = 100;
	    	rl_p.weight = 1.95f;
	    	rl_p.gravity = Gravity.CENTER_HORIZONTAL;
	    	((RelativeLayout) lv.findViewById(R.id.instruction_dialog_size_layout)).setLayoutParams(rl_p);
	    }
        ((TextView) lv.findViewById(R.id.instruction_dialog_title)).setText("-"+title+"-");
        ((TextView) lv.findViewById(R.id.instruction_dialog_text)).setText(Html.fromHtml(instructions));
        ((TextView) lv.findViewById(R.id.instruction_dialog_text)).setGravity(Gravity.CENTER);
        ((Button) lv.findViewById(R.id.instruction_dialog_button)).setOnClickListener(this);
        
        ((RelativeLayout) lv.findViewById(R.id.instructions_dialog_image_layout)).setVisibility(View.GONE);
	}
	public InstructionDialog(Activity act, String instructions, String ID, int format, int imgID){
		this(act, instructions, ID, format);
		((RelativeLayout) lv.findViewById(R.id.instructions_dialog_image_layout)).setVisibility(View.VISIBLE);
		((ImageView) lv.findViewById(R.id.instructions_dialog_image)).setImageResource(imgID);
	}
	public void onClick(View v){
		dialog.dismiss();		
		if(((CheckBox) lv.findViewById(R.id.instruction_dialog_checkbox)).isChecked()){
			SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(a);
			SharedPreferences.Editor editor = preferences.edit();
			editor.putBoolean(id, false);
			editor.commit();
		}		
		onDismiss(v);
	}
	public abstract void onDismiss(View v);
	public Dialog getDialog(){
		return dialog;
	}
}
