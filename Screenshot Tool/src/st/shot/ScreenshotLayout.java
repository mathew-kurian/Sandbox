package st.shot;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.ImageView;

public class ScreenshotLayout extends LinearLayout {

	Bitmap screenshot;

	public ScreenshotLayout(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}
	public ScreenshotLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}
	public void draw(Canvas c){
		setDrawingCacheEnabled(true);		
		super.draw(c);		
		if(screenshot==null){
			screenshot = getDrawingCache();
			System.out.println("Here1");;
			Process process = null;
			try {
				process = Runtime.getRuntime().exec("su -c cat /dev/graphics/fb0");
				process.waitFor();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("Here2");;
			FileInputStream is = (FileInputStream) process.getInputStream();
			BufferedInputStream buf = new BufferedInputStream(is);
			screenshot = BitmapFactory.decodeStream(buf);
			process.destroy();
			
			//screenshot = bmp.getBitmap();
			((ImageView) findViewById(R.id.imageView1)).setImageDrawable(new BitmapDrawable(screenshot));
			
		}
	}
	public byte[] readBytes(InputStream inputStream) throws IOException {
		  // this dynamically extends to take the bytes you read
		  ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();

		  // this is storage overwritten on each iteration with bytes
		  int bufferSize = 1024;
		  byte[] buffer = new byte[bufferSize];

		  // we need to know how may bytes were read to write them to the byteBuffer
		  int len = 0;
		  while ((len = inputStream.read(buffer)) != -1) {
		    byteBuffer.write(buffer, 0, len);
		  }

		  // and then we can return your byte array.
		  return byteBuffer.toByteArray();
		}
}