package mk.universityoftexas.austin;

import android.os.AsyncTask;

public abstract class ThreadWorker extends AsyncTask<Void, Void, Boolean> {

	ThreadWorker.Method CURRENT_METHOD;
	
	enum Method{
		PREEXCEUTE,
		BACKGROUND,
		POSTEXECUTE,
		PROGRESSUPDATE,		
	}
	@Override
	protected void onPreExecute() {  
		try{
			CURRENT_METHOD = Method.PREEXCEUTE;
			preExecute();
		}catch(Exception e){
			onError(Method.PREEXCEUTE);
		}
	}
	@Override
	protected Boolean doInBackground(Void... params) {
		try{
			CURRENT_METHOD = Method.BACKGROUND;
			background();
		}catch(Exception e){
			onError(Method.BACKGROUND);
		}
		return true;
	}
	@Override
	protected void onProgressUpdate(Void... v){
		try {
			CURRENT_METHOD = Method.PROGRESSUPDATE;
			onProgressUpdate();
		} catch (Exception e) {
			onError(Method.PROGRESSUPDATE);
		}		
	}
	protected void onPostExecute(Boolean result) { 
		try{
			CURRENT_METHOD = Method.POSTEXECUTE;
			postExecute();
		}catch(Exception e){
			onError(Method.POSTEXECUTE);
		}
	} 
	public ThreadWorker.Method getCurrentThread(){
		return CURRENT_METHOD;
	}
	public abstract void preExecute() throws Exception;
	public abstract void background() throws Exception;
	public abstract void postExecute() throws Exception;
	public abstract void onProgressUpdate() throws Exception;
	public abstract void onError(Method m);
}
abstract class QuickDrivenThreadWorker extends ThreadWorker{
	Driver d;	
	public QuickDrivenThreadWorker(Driver d){
		this.d = d;
	}
	public abstract void run(); 
	@Override
	public void preExecute() {}
	@Override
	public void background() {
		run();		
	}
	@Override
	public void postExecute() {
		d = null;
	}
	public Driver getThreadDriver(){
		return d;
	}
	@Override
	public void onProgressUpdate() {}
	@Override
	public void onError(Method m) {}

}
abstract class QuickDrivenUIThreadWorker extends ThreadWorker{
	Driver d;	
	public QuickDrivenUIThreadWorker(Driver d){
		this.d = d;
	}
	public abstract void run(); 
	public abstract void atEnd();
	@Override
	public void preExecute() {}
	@Override
	public void background() {
		run();		
	}
	@Override
	public void postExecute() {
		atEnd();
		d = null;
	}
	public Driver getThreadDriver(){
		return d;
	}
	@Override
	public void onProgressUpdate() {}
	@Override
	public void onError(Method m) {}

}
abstract class QuickThreadWorker extends ThreadWorker{
	public abstract void run(); 
	@Override
	public void preExecute() {}
	@Override
	public void background() {
		run();		
	}
	@Override
	public void postExecute() {}
	@Override
	public void onProgressUpdate() {}
	@Override
	public void onError(Method m) {}

}