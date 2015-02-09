import java.awt.Canvas;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GraphicsConfiguration;
import java.awt.image.VolatileImage;
import java.util.ArrayList;

@SuppressWarnings("serial")
public class ImageCanvas extends Canvas implements Runnable
{
	private VolatileImage volatileImg;
	ArrayList <ImageWSpec> imgs;
	public int counter = 0;
	
	public ImageCanvas()
	{		
		imgs = new ArrayList<ImageWSpec>();
    } 
	public void paint(Graphics g) {
	  // create the hardware accelerated image.
	  createBackBuffer();
	  Graphics2D g2 = (Graphics2D) g;
	  // Main rendering loop. Volatile images may lose their contents. 
	  // This loop will continually render to (and produce if neccessary) volatile images
	  // until the rendering was completed successfully.
	  do {
		  
	   // Validate the volatile image for the graphics configuration of this 
	   // component. If the volatile image doesn't apply for this graphics configuration 
	   // (in other words, the hardware acceleration doesn't apply for the new device)
	   // then we need to re-create it.
	   GraphicsConfiguration gc = this.getGraphicsConfiguration();
	   int valCode = volatileImg.validate(gc);
	   
	   // This means the device doesn't match up to this hardware accelerated image.
	   if(valCode==VolatileImage.IMAGE_INCOMPATIBLE){
	    createBackBuffer(); // recreate the hardware accelerated image.
	   }
	   
	   Graphics offscreenGraphics = volatileImg.getGraphics();   
	   doPaint(offscreenGraphics); // call core paint method.
	 //  g2.rotate(1);
	   // paint back buffer to main graphics
	   g2.drawImage(volatileImg, 0, 0, this);
	   // Test if content is lost   
	  } while(volatileImg.contentsLost());
	 }
	 
	 // new method encapsulating rendering logic.
	 private void doPaint(Graphics g) {
		 for(counter = 0; counter<imgs.size(); counter++)
		 {
			 g.drawImage(imgs.get(counter).img, imgs.get(counter).x,imgs.get(counter).y, this); // arbitrary rendering logic
		 }	 
	 }
	 // This method produces a new volatile image.
	 private void createBackBuffer() {
	   GraphicsConfiguration gc = getGraphicsConfiguration();
	   volatileImg = gc.createCompatibleVolatileImage(getWidth(), getHeight());
	 }
	 
	 public void update(Graphics g) {
	  paint(g);
	 }
	 
	 public void addImage(ImageWSpec image) {
		imgs.add(image);
	}
	@Override
	public void run() {
		repaint();
		
	}
}