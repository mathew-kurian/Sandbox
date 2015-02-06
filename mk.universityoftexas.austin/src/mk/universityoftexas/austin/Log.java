package mk.universityoftexas.austin;
import java.text.DecimalFormat;

import android.app.ActivityManager;
import android.os.Debug;
public abstract class Log {
	
	private static ActivityManager.MemoryInfo a = new ActivityManager.MemoryInfo();
	public static StringBuilder LOG = new StringBuilder();
	
	private static int MAX_RECENT_MESSAGES = 75;	
	private static int c = 0;		
	private static String marker = "<!-- STOP -->";
	
	public static void d(String tag, String message){		
		d(tag, message, "red");
		android.util.Log.d(tag, message);
	}
	public static void d(String tag, String message, String color){		
		c++;
		LOG.append(marker);
		LOG.append("<br><font color=\""+ color.toLowerCase() + "\">"+tag + "</font> : " + message);
		if(c > MAX_RECENT_MESSAGES)
			maintainLength();
	}
	public static void appendMemoryUsage(){
		Double allocated = new Double(Debug.getNativeHeapAllocatedSize())/new Double((1048576));
		Double available = new Double(Debug.getNativeHeapSize())/1048576.0;
		Double free = new Double(Debug.getNativeHeapFreeSize())/1048576.0;
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(2);
		d("Memory Info", Long.toString(a.availMem) + " MB", "White");
		d("Memory Info", "consumption High/Low: " + Boolean.toString(a.lowMemory), "White");	
        d("Memory Info", "debug.heap native: allocated " + df.format(allocated) + "MB of " + df.format(available) + "MB (" + df.format(free) + "MB free)", "White");
        d("Memory Info", "debug.memory: allocated: " + df.format(new Double(Runtime.getRuntime().totalMemory()/1048576)) + "MB of " + df.format(new Double(Runtime.getRuntime().maxMemory()/1048576))+ "MB (" + df.format(new Double(Runtime.getRuntime().freeMemory()/1048576)) +"MB free)", "White");
    }
	private static void maintainLength(){
		LOG.delete(0, LOG.indexOf(marker)+marker.length());
	}
	
}