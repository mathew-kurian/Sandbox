/**
 * @(#)PropertiesListener.java
 *
 *
 * @author 
 * @version 1.00 2010/3/17
 */

import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Component;
import java.awt.Font;
import java.awt.image.BufferedImage;
import java.awt.Image;
import java.awt.Graphics;
import java.awt.geom.AffineTransform;
import java.awt.Graphics2D;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.GraphicsConfiguration;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.Color;

import java.io.File;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JFormattedTextField;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;
import javax.swing.SwingUtilities;
import javax.swing.border.*;
import javax.swing.SwingConstants;
import javax.swing.Icon;

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;

import java.text.SimpleDateFormat;

public class PropertiesListener implements MouseListener {
	
	public BoxPoperties PopUpProps;
	public JPanel propFullView;
	public JLabel viewEnlarged;
	public ImageIcon origEnlarged = new ImageIcon("images\\deeds\\choose_to_begin.jpg");
    
    public PropertiesListener(BoxPoperties b, JPanel a) {
    	PopUpProps = b;
    	propFullView = a;
    	    	
    	viewEnlarged = new JLabel(createThumbnail(origEnlarged.getImage(),250));  //get Image from ImageIcon
    	
    	viewEnlarged.setAlignmentX(Component.CENTER_ALIGNMENT);
    	viewEnlarged.setAlignmentY(Component.CENTER_ALIGNMENT);
    	    	
    	propFullView.add(viewEnlarged);    	  
    	
    }
    public void mouseClicked(MouseEvent e) {  							
    }        
    public void mouseExited(MouseEvent e) {
    }
    public void mousePressed(MouseEvent e) {
    	
    	System.out.println(((JLabel)e.getSource()).getName());
    	viewEnlarged.setIcon(createThumbnail(iconToImage(((JLabel) PopUpProps.getLabel((String)((JLabel)e.getSource()).getName())).getIcon()), 250)); //get Icon from JLabel and Convert to Image
    	    	    		   	
    	propFullView.validate();
    	propFullView.repaint();
    	    			    	
    }
    public void mouseReleased(MouseEvent e) { 
    }
    public void mouseEntered(MouseEvent e) {
    }
  /*  public ImageIcon resizeImageIcon (ImageIcon originalIcon) 
     {	
      	double scale = 0.70;
      	int w = (int) (originalIcon.getIconHeight() * scale);
      	int h = (int) (originalIcon.getIconHeight() * scale);
      	BufferedImage outImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);              
      	AffineTransform trans = new AffineTransform();
      	trans.scale(scale, scale);
      	Graphics2D g = outImage.createGraphics();
      	RenderingHints rhints = g.getRenderingHints();
      	boolean antialiasOn = rhints.containsValue(RenderingHints.VALUE_ANTIALIAS_ON);
      	System.out.println(antialiasOn);
      	g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);      	
      	g.drawImage(originalIcon.getImage(), trans, null);
      	g.dispose();
      	
      	return new ImageIcon(outImage);
     }*/
   /*  public ImageIcon resizeIcon (Icon i) 
     {
        ImageIcon originalIcon = new ImageIcon(iconToImage(i));
                  	
      	double scale = 0.70;
      	int w = (int) (originalIcon.getIconHeight() * scale);
      	int h = (int) (originalIcon.getIconHeight() * scale);
      	BufferedImage outImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);                
      	AffineTransform trans = new AffineTransform();
      	trans.scale(scale, scale);
      	Graphics2D g = outImage.createGraphics();
      	g.drawImage(originalIcon.getImage(), trans, null);
      	g.dispose();
      	
      	return new ImageIcon(outImage);
      
     }*/
     static Image iconToImage(Icon icon) { 
          if (icon instanceof ImageIcon) { 
              return ((ImageIcon)icon).getImage(); 
          } else { 
              int w = icon.getIconWidth(); 
              int h = icon.getIconHeight(); 
              GraphicsEnvironment ge = 
                GraphicsEnvironment.getLocalGraphicsEnvironment(); 
              GraphicsDevice gd = ge.getDefaultScreenDevice(); 
              GraphicsConfiguration gc = gd.getDefaultConfiguration(); 
              BufferedImage image = gc.createCompatibleImage(w, h); 
              Graphics2D g = image.createGraphics(); 
              icon.paintIcon(null, g, 0, 0); 
              g.dispose(); 
              return image; 
          } 
      }
      public ImageIcon createThumbnail(Image a, int largestDimension)
	{
			double scale = 85;
			int sizeDifference, originalImageLargestDim;

				Image inImage = a;
			
					//find biggest dimension	    
					if(inImage.getWidth(null) > inImage.getHeight(null))
					{
						scale = (double)largestDimension/(double)inImage.getWidth(null);
						sizeDifference = inImage.getWidth(null) - largestDimension;
						originalImageLargestDim = inImage.getWidth(null);
					}
					else
					{
						scale = (double)largestDimension/(double)inImage.getHeight(null);
						sizeDifference = inImage.getHeight(null) - largestDimension;
						originalImageLargestDim = inImage.getHeight(null);
					}
					//create an image buffer to draw to
					BufferedImage outImage = new BufferedImage(100, 100, BufferedImage.TYPE_INT_RGB); //arbitrary init so code compiles
					Graphics2D g2d;
					AffineTransform tx;
					
						int numSteps = sizeDifference / 100;
						int stepSize = sizeDifference / numSteps;
						int stepWeight = stepSize/2;
						int heavierStepSize = stepSize + stepWeight;
						int lighterStepSize = stepSize - stepWeight;
						int currentStepSize, centerStep;
						double scaledW = inImage.getWidth(null);
						double scaledH = inImage.getHeight(null);
						if(numSteps % 2 == 1) //if there's an odd number of steps
							centerStep = (int)Math.ceil((double)numSteps / 2d); //find the center step
						else
							centerStep = -1; //set it to -1 so it's ignored later
						Integer intermediateSize = originalImageLargestDim, previousIntermediateSize = originalImageLargestDim;
						Integer calculatedDim;
						for(Integer i=0; i<numSteps; i++)
						{
							if(i+1 != centerStep) //if this isn't the center step
							{
								if(i == numSteps-1) //if this is the last step
								{
									//fix the stepsize to account for decimal place errors previously
									currentStepSize = previousIntermediateSize - largestDimension;
								}
								else
								{
									if(numSteps - i > numSteps/2) //if we're in the first half of the reductions
										currentStepSize = heavierStepSize;
									else
										currentStepSize = lighterStepSize;
								}
							}
							else //center step, use natural step size
							{                        
								currentStepSize = stepSize;
							}
							intermediateSize = previousIntermediateSize - currentStepSize;
							scale = (double)intermediateSize/(double)previousIntermediateSize;
							scaledW = (int)scaledW*scale;
							scaledH = (int)scaledH*scale;
							outImage = new BufferedImage((int)scaledW, (int)scaledH, BufferedImage.TYPE_INT_RGB);
							g2d = outImage.createGraphics();
							g2d.setBackground(Color.WHITE);
							g2d.clearRect(0, 0, outImage.getWidth(), outImage.getHeight());
							g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
							tx = new AffineTransform();
							tx.scale(scale, scale);
							g2d.drawImage(inImage, tx, null);
							g2d.dispose();
							inImage = new ImageIcon(outImage).getImage();
							previousIntermediateSize = intermediateSize;
						}
						
						JFrame af = new JFrame("");
						JPanel bf = new JPanel();
						bf.add(new JLabel(new ImageIcon(inImage)));
													
					return new ImageIcon(inImage);
				
	}
	
}