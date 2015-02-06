package com.dEVELdRONE.GForce_Arena;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.EditTextPreference;
import android.preference.Preference;
import android.preference.PreferenceManager;
import android.preference.Preference.OnPreferenceClickListener;
import android.preference.PreferenceActivity;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.widget.EditText;

//todo: transfer gforce stuff to this class and make gforce edit text

public class Preferences extends PreferenceActivity implements TextWatcher, OnPreferenceClickListener{
	
	public static int num_particles, tails, particles_max = 1000, tails_max = 10;
	public static float gforce, gforce_max = 20;
	private EditTextPreference intPref, tailPref, gforcePref;
	private EditText intText, tailText, gforceText;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		/*SharedPreferences getPrefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());

		num_particles = Integer.parseInt(getPrefs.getString("num_particles_text", "150"));
		tails = Integer.parseInt(getPrefs.getString("num_particles_text", "150"));*/
		
		addPreferencesFromResource(R.xml.prefs);
		
		intPref = (EditTextPreference)findPreference("num_particles_text");
		tailPref = 	(EditTextPreference)findPreference("tails_text");
		gforcePref = (EditTextPreference)findPreference("gforce_text");
		
		tailText = tailPref.getEditText();
		intText = intPref.getEditText();
		gforceText = gforcePref.getEditText();

		intText.setInputType(InputType.TYPE_CLASS_NUMBER);
		intText.setText(""+num_particles);
		intText.addTextChangedListener(this);
		//intText.setText(Integer.toString(num_particles));
		
		tailText.setInputType(InputType.TYPE_CLASS_NUMBER);
		tailText.setText(""+tails);
		TailsWatcher watcher = new TailsWatcher();
		tailText.addTextChangedListener(watcher);
		
		gforceText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
		gforceText.setText(""+gforce);
		GForceWatcher gwatcher = new GForceWatcher();
		gforceText.addTextChangedListener(gwatcher);
		
		intPref.setOnPreferenceClickListener(this);
		tailPref.setOnPreferenceClickListener(this);
		gforcePref.setOnPreferenceClickListener(this);
	}

	@Override
	public void afterTextChanged(Editable s) {
		// TODO Auto-generated method stub
		if(num_particles>particles_max){
			//display warning message
			num_particles = particles_max;
			intText.setText(particles_max+"");
		}else if(num_particles<1){
			num_particles = 1;
			//intText.setText("1");
		}
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count,
			int after) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// TODO Auto-generated method stub
		try{
			num_particles = Integer.parseInt(s.toString());
		}catch(Exception e){
			num_particles = 0;
		}
	}

	@Override
	public boolean onPreferenceClick(Preference preference) {
		if(preference.getKey().equals("num_particles_text"))
			((EditTextPreference)preference).getEditText().setText(num_particles+"");
		else if(preference.getKey().equals("tails_text"))
			((EditTextPreference)preference).getEditText().setText(tails+"");
		return false;
	}
	
	@Override
	public void onPause(){
		super.onPause();
		SharedPreferences getPrefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
		
		try{
			num_particles = Integer.parseInt(getPrefs.getString("num_particles_text", "150"));
		}catch(Exception e){
			num_particles = 250;
		}
		
		try{
			tails = Integer.parseInt(getPrefs.getString("tails_text", "3"));
		}catch(Exception e){
			tails = 3;
		}
		
		try{
			gforce = Float.parseFloat(getPrefs.getString("gforce_text", "5"));
		}catch(Exception e){
			gforce = 5;
		}
		
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		intText.setText(""+num_particles);
		tailText.setText(""+tails);
		gforceText.setText(""+gforce);
	}

	public class TailsWatcher implements TextWatcher{

		@Override
		public void afterTextChanged(Editable s) {
			// TODO Auto-generated method stub
			if(tails>tails_max){
				//display warning message
				tails = tails_max;
				tailText.setText(tails_max+"");
			}
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onTextChanged(CharSequence s, int start, int before,
				int count) {
			// TODO Auto-generated method stub
			try{
				tails = Integer.parseInt(s.toString());
			}catch(Exception e){
				tails = 0;
			}
		}
		
	}
	
	public class GForceWatcher implements TextWatcher{

		@Override
		public void afterTextChanged(Editable s) {
			// TODO Auto-generated method stub
			if(gforce>gforce_max){
				//display warning message
				gforce = gforce_max;
				gforceText.setText(gforce_max+"");
			}
			else if(gforce<1){
				gforce = 1;
				gforceText.setText(1+"");
			}
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onTextChanged(CharSequence s, int start, int before,
				int count) {
			// TODO Auto-generated method stub
			try{
				gforce = Float.parseFloat(s.toString());
			}catch(Exception e){
				gforce = 1;
			}
		}
		
	}
}
