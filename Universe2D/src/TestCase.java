import java.awt.Color;

import javax.swing.UIManager;

import de.javasoft.plaf.synthetica.SyntheticaWhiteVisionLookAndFeel;


public class TestCase extends Universe{
			
	public TestCase()
	{
		super(800, 500, "Universe (Build 1001.2) Demo", new State());
	}
	@Override
	public State onKey(State s, String k) {
		if(k.equals("a")&&!s.pause){s.spX-=5;}
		if(k.equals("d")&&!s.pause){s.spX+=5;}
		if(k.equals("w")&&!s.pause){s.spY-=5;}
		if(k.equals("s")&&!s.pause){s.spY+=5;}
		if(k.equals("p")){
			s.pause = s.pause ? false : true; 
			pausePlay();}
		if(k.equals("m")){sleep(5000);}
		
		return s;
	}
	@Override
	public State onMouse(State s) {		
		if(MOUSE_DRAGGED){
			s.spX = MOUSE_X-s.ship.getWidth(null)/2;
			s.spY = MOUSE_Y-s.ship.getHeight(null)/2;
		}		
		
		if(s.spX > 500) s.spX = 500;
		if(s.spX < -100) s.spX = -100;
		
		if(s.spY > 200) s.spY = 200;
		if(s.spY < -100) s.spY = -100;
		
		return s;
	}
	@Override
	public State onRelease(State s, String k) {
		return s;
	}
	@Override
	public State onTick(State s) {
		if(s.astX>=780)	s.direcX = true;
		if(s.astX<=0)	s.direcX = false;
		
		if(!s.direcX) 	s.astX+=5;
		if(s.direcX) 	s.astX-=5;
		
		if(s.astY>=430)	s.direcY = true;
		if(s.astY<=0)	s.direcY = false;
		
		if(!s.direcY) 	s.astY+=5;
		if(s.direcY) 	s.astY-=5;
		
		if(TIME%5==0)
		{
			if(s.scale>=100) s.scaleB = true;
			if(s.scale<=10) s.scaleB = false;
		
			if(!s.scaleB) 	s.scale+=1;
			if(s.scaleB) 	s.scale-=1;
		}
		
		s.deg++;
				
		return s;
	}
	@Override
	public State stop(State s) {
		return s;
	}
	@Override
	public State toDraw(State s) {
		placeImage (s.bg, -500, -375);
		placeImage ((resize(rotate(s.ast, s.deg), s.scale)), s.astX, s.astY);
		placeImage (s.ship, s.spX, s.spY);
		placeImage (drawString("Mouse X: " + MOUSE_X + " Y: " + MOUSE_Y, "Segoe UI", "BOLD", 12, Color.WHITE), 10, 405);
		placeImage (drawString("Posn X: " + s.astX + " Y: " + s.astY + " Scale: " + s.scale, "Segoe UI", "BOLD", 12, Color.WHITE), 10, 420);
		placeImage (drawString("Frame: " + TIME + " Seconds: " + TIME/30, "Segoe UI", "BOLD", 12, Color.WHITE), 10, 435);
		placeImage (drawString("Presenting: Universe (An Extension of Conquerer) Build 1001.2", "Segoe UI", "Plain", 10, Color.GREEN), 10, 450);
		placeImage (drawString("Demo features parts of the KeyEvent (a,s,w,d,p,m) and some of the Image Extras", "Segoe UI", "Plain", 10, Color.YELLOW), 10, 460);
		placeImage (drawString("© Mathew Kurian", "Segoe UI", "Plain", 10, Color.YELLOW), 10, 470);
		placeImage (drawString("State Based", "Segoe UI", "Bold", 25, Color.ORANGE), 640, 0);
		
		if(s.pause){	
			placeImage (drawString("PAUSED", "Segoe UI", "Italic", 40, Color.RED), 180);	
			placeImage (drawString("pausePlay() only blocks onTick() and stop() methods.", "Segoe UI", "Italic", 12, Color.WHITE), 230);
			placeImage (drawString("sleep(int MILLISECS) blocks all methods for the alloted milliseconds.", "Segoe UI", "Italic", 12, Color.WHITE), 245);
		}
		
		return s;
	}
	public static void main (String [] args)
	{
		try 				{	UIManager.setLookAndFeel(new SyntheticaWhiteVisionLookAndFeel());	} 
		catch (Exception e) { 	e.printStackTrace();												}
		
		String[] li = {"Licensee=Mathew Kurian", "LicenseRegistrationNumber=NCMK100913", "Product=Synthetica", "LicenseType=Non Commercial", "ExpireDate=--.--.----", "MaxVersion=2.999.999"};
		UIManager.put("Synthetica.license.info", li);
		UIManager.put("Synthetica.license.key", "B8B5C450-C6F1B2B1-83145A64-0F546BD2-9CA130F0");

		String[] li2 = {"Licensee=Mathew Kurian", "LicenseRegistrationNumber=NCMK100916", "Product=SyntheticaAddons", "LicenseType=Non Commercial", "ExpireDate=--.--.----", "MaxVersion=1.999.999"};
		UIManager.put("SyntheticaAddons.license.info", li2);
		UIManager.put("SyntheticaAddons.license.key", "D379B2C2-D9129837-F3C19CBE-FF5F0414-0F6E4407");
		UIManager.put("Synthetica.popupMenu.blur.enabled", Boolean.TRUE);
		UIManager.put("Synthetica.popupMenu.blur.size", 10);		
		
		new TestCase();
	}
}
