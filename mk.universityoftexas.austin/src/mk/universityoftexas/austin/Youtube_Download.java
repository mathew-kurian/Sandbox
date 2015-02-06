package mk.universityoftexas.austin;

import java.util.ArrayList;

public class Youtube_Download extends ThreadWorker {

	int page = 0;
	ArrayList<String> a;	

	public Youtube_Download(int pg){
		super();
		page = pg;
	}
	@Override
	public void preExecute() throws Exception {
		((Video) AVE.CURRENT).showProgress_lock(true, "Downloading thumbs...");
	}
	@Override
	public void background() throws Exception {
		a = XML_YOUTUBE.extractYoutubeData(page);
	}
	@Override
	public void postExecute() throws Exception {
		((Video) AVE.CURRENT).addVideoLeaves(a);
		((Video) AVE.CURRENT).showProgress_lock(false, null);
	}
	@Override
	public void onProgressUpdate() throws Exception {}
	@Override
	public void onError(Method m) {
		Log.d("AsyncTask: Video" , "Error Detected");
	} 

}