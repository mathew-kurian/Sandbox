package mk.universityoftexas.austin;

import java.util.ArrayList;

import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import mk.universityoftexas.austin.R;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

public class SportsPlayerHTML_Download extends AsyncTask<Void, Void, Boolean> {

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
	public SportsPlayerHTML_Download(String url){
		super();
		playerURL = url;
	}
	@Override
	protected void onPreExecute() {}
	@Override
	protected Boolean doInBackground(Void ... arg0) {    				
		try{
			playerData = SportsHTMLParser_Helper.normalizeSportPlayer(SportsHTMLParser_Helper.extractSportPlayer(playerURL));	    	
			playerName = playerData.get(0);
			playerNum =  "#"+playerData.get(1).substring(playerData.get(1).indexOf(':')+1);
			playerHeight =  playerData.get(4).substring(playerData.get(4).indexOf(':')+1)+"\"";
			playerWeight =  playerData.get(3).substring(playerData.get(3).indexOf(':')+1)+"lbs";
			playerClass =  playerData.get(2).substring(playerData.get(2).indexOf(':')+1);
			playerPosition =  playerData.get(5).substring(playerData.get(5).indexOf(':')+1);
			playerImageURL = playerData.get(6);
			Log.d("playerImage", playerImageURL);
			playerImage = AVE.downloadImage(playerImageURL);
			playerImage = (BitmapDrawable) (playerImage==null ? ((Sports)AVE.CURRENT).getResources().getDrawable(R.drawable.roster_error) : playerImage);
			playerImage.setAntiAlias(true);
		}catch(Exception e){}
		return true;
	}
	@Override
	protected void onPostExecute(Boolean result) {
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setImageDrawable(playerImage);
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setMinimumHeight(100);
		((ImageView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_image)).setMinimumWidth(200);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_name)).setText(playerName);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_number)).setText(playerNum);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_height)).setText(playerHeight);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_class)).setText(playerClass);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_weight)).setText(playerWeight);
		((TextView) ((Sports)AVE.CURRENT).rosterDialog.findViewById(R.id.roster_dialog_position)).setText(playerPosition);
	}       
}