package mk.universityoftexas.austin;

import java.util.ArrayList;

import android.graphics.drawable.BitmapDrawable;
import mk.universityoftexas.austin.R;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class SportsPlayer_Download extends ThreadWorker {

	String playerURL = "No Internet Connection";
	String playerImageURL = "No Internet Connection";
	ArrayList<String> playerData;
	BitmapDrawable playerImage;
	String playerName = "";
	String playerNum = "";
	String playerHeight = "";
	String playerClass = "";
	String playerWeight = "";
	String playerPosition = "";
	public SportsPlayer_Download(String url){
		super();
		playerURL = new String(url);
	}
	@Override
	public void background() throws Exception {
		playerData = HTML_SPORT.normalizeSportPlayer(HTML_SPORT.extractSportPlayer(playerURL));	    	
		playerName = playerData.get(0);
		playerNum  = playerData.get(1).substring(playerData.get(1).indexOf(':')+1);
		for(int x = 2; x<6; x++){
			String current = playerData.get(x);
			if(current.contains("Height"))
				playerHeight = current.substring(playerData.get(x).indexOf(':')+1);
			else if(current.contains("Class"))
				playerClass = current.substring(playerData.get(x).indexOf(':')+1);
			else if(current.contains("Weight"))
				playerWeight = current.substring(playerData.get(x).indexOf(':')+1);			
			else if(current.contains("Position"))
				playerPosition = current.substring(playerData.get(x).indexOf(':')+1);		
		}
		playerImageURL = playerData.get(6);
		Log.d("playerImage", playerImageURL);
		playerImage = AVE.downloadImage(playerImageURL);
		playerImage = (BitmapDrawable) (playerImage==null ? ((Sports)AVE.CURRENT).getResources().getDrawable(R.drawable.roster_error) : playerImage);
		playerImage.setAntiAlias(true);

	}
	@Override
	public void postExecute() throws Exception {
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setImageDrawable(playerImage);
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setMinimumHeight(100);
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setMinimumWidth(200);

		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_name)).setText(playerName);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_position)).setText(playerPosition);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_weight)).setText(playerWeight+ " lbs.") ;
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_class)).setText(playerClass);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_height)).setText(playerHeight + "\"");
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setText(playerNum);
		
		if(playerName.length()<1)	
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setVisibility(View.GONE);
		if(playerHeight.length()<1)
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_height)).setVisibility(View.GONE);
		if(playerClass.length()<1)
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_class)).setVisibility(View.GONE);
		if(playerWeight.length()<1)
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_weight)).setVisibility(View.GONE);
		if(playerPosition.length()<1)
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_position)).setVisibility(View.GONE);
		if(playerNum.length()<1)
			((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setVisibility(View.GONE);
	}
	@Override
	public void onProgressUpdate() throws Exception {
		// TODO Auto-generated method stub

	}
	@Override
	public void onError(Method m) {
		AVE.CURRENT.toast("Error", 0);

	}
	@Override
	public void preExecute() throws Exception {
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_name)).setVisibility(View.VISIBLE);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setVisibility(View.VISIBLE);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_height)).setVisibility(View.VISIBLE);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_class)).setVisibility(View.VISIBLE);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_weight)).setVisibility(View.VISIBLE);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_position)).setVisibility(View.VISIBLE);
	}       
}