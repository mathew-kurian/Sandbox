package st.shot;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioManager;
import android.os.IBinder;
import android.widget.Toast;

public class ScreenshotService extends Service implements SensorEventListener {

	int initialVolume = 0;
	AudioManager am;
	ScreenshotService ss;
	Sensor s1;
	long lastUpdate;
	float last_x;
	float last_y;
	float last_z;
	/** Called when the activity is first created. */
	public void onCreate(){
		ss = this;
		Toast.makeText(this, "Service started", Toast.LENGTH_SHORT).show();
		am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		initialVolume = am.getStreamVolume(AudioManager.NUM_STREAMS);
		SensorManager sm = (SensorManager)getSystemService(SENSOR_SERVICE);
	}
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
	@Override
	public void onDestroy() {
		Toast.makeText(this, "My Service Stopped", Toast.LENGTH_SHORT).show();
	}
	public void onAccuracyChanged(Sensor s, int arg1) {
		Toast.makeText(ss, "My Service Stopped", Toast.LENGTH_SHORT).show();
	}	
	private static final int SHAKE_THRESHOLD = 200;
	public void onSensorChanged(int sensor, float[] values) {
		if (sensor == Sensor.TYPE_ACCELEROMETER) {
			long curTime = System.currentTimeMillis();
			// only allow one update every 100ms.
			if ((curTime - lastUpdate) > 100) {
				long diffTime = (curTime - lastUpdate);
				lastUpdate = curTime;

				float x = values[SensorManager.DATA_X];
				float y = values[SensorManager.DATA_Y];
				float z = values[SensorManager.DATA_Z];
				
				float speed = Math.abs(x+y+z-(last_x + last_y + last_z)) / diffTime * 10000;

				if (speed > SHAKE_THRESHOLD) {					
					Toast.makeText(this, "shake detected w/ speed: " + speed, Toast.LENGTH_SHORT).show();
					 Intent i = new Intent(this, ScreenshotManager.class);
					 i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					startActivity(i);
				}
				last_x = x;
				last_y = y;
				last_z = z;
			}
		}
	}
	public void onSensorChanged(SensorEvent event) {
		onSensorChanged(event.sensor.getType(), event.values);

	}
}