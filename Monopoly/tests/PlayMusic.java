import java.io.File;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.SourceDataLine;

public class PlayMusic {
	  
public static void sound() throws Exception {
			
	byte tempBuffer[] = new byte[10000];
	boolean stopPlayback = false;
	File soundFile = new File("d:\\tada.wav");
	AudioInputStream  audioInputStream = AudioSystem.getAudioInputStream(soundFile);
	AudioFormat audioFormat = audioInputStream.getFormat();
    System.out.println(audioFormat);
    DataLine.Info dataLineInfo = new DataLine.Info(SourceDataLine.class,audioFormat);
    SourceDataLine sourceDataLine =(SourceDataLine)AudioSystem.getLine( dataLineInfo);
    sourceDataLine.open(audioFormat);
    sourceDataLine.start();
    int cnt;

    while((cnt = audioInputStream.read(
         tempBuffer,0,tempBuffer.length)) != -1
                     && stopPlayback == false){
      if(cnt > 0){
        sourceDataLine.write(
                           tempBuffer, 0, cnt);
      }//end if
    }//end while loop

}

 public static void main (String[] args)throws Exception {

	try { 
		sound();
	} catch(Exception e){
		e.printStackTrace();
	};
  }
}