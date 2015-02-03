/**
 * @(#)Thumbnails.java
 *
 *
 * @author 
 * @version 1.00 2010/3/17
 */


import java.awt.Image;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.io.FileOutputStream;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

import java.io.*;
import java.awt.Toolkit;
import java.awt.Color;

class Thumbnail {
	/**
	* Reads an image in a file and creates a thumbnail in another file.
	* largestDimension is the largest dimension of the thumbnail, the other dimension is scaled accordingly.
	* Utilises weighted stepping method to gradually reduce the image size for better results,
	* i.e. larger steps to start with then smaller steps to finish with.
	* Note: always writes a JPEG because GIF is protected or something - so always make your outFilename end in 'jpg'.
	* PNG's with transparency are given white backgrounds
	*/
	public buffered 
	public Image createThumbnail(String inFilename, String outFilename, int largestDimension)
	{
		try
		{
			double scale;
			int sizeDifference, originalImageLargestDim;
			if(!inFilename.endsWith(".jpg") && !inFilename.endsWith(".jpeg") && !inFilename.endsWith(".gif") && !inFilename.endsWith(".png"))
			{
				System.out.println("Error: Unsupported image type, please only either JPG, GIF or PNG");
			}
			else
			{
				Image inImage = Toolkit.getDefaultToolkit().getImage(inFilename);
				if(inImage.getWidth(null) == -1 || inImage.getHeight(null) == -1)
				{
					System.out.println("Error loading file: \"" + inFilename + "\"");
				}
				else
				{
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
					if(scale < 1.0d) //only scale if desired size is smaller than original
					{
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
					}
					else
					{
					//just copy the original
					outImage = new BufferedImage(inImage.getWidth(null), inImage.getHeight(null), BufferedImage.TYPE_INT_RGB);
					g2d = outImage.createGraphics();
					g2d.setBackground(Color.WHITE);
					g2d.clearRect(0, 0, outImage.getWidth(), outImage.getHeight());
					tx = new AffineTransform();
					tx.setToIdentity(); //use identity matrix so image is copied exactly
					g2d.drawImage(inImage, tx, null);
					g2d.dispose();
					}
					
					return outImage;
				}
			}
		}
		catch(Exception ex)
		{
			String errorMsg = "";
			errorMsg += "<br>Exception: " + ex.toString();
			errorMsg += "<br>Cause = " + ex.getCause();
			errorMsg += "<br>Stack Trace = ";
			StackTraceElement stackTrace[] = ex.getStackTrace();
			for(int traceLine=0; traceLine<stackTrace.length; traceLine++)
			{
				errorMsg += "<br>" + stackTrace[traceLine];
			}
			System.out.println(errorMsg);
		}
		System.out.println("Successful Conversion"); //success
		
		return null;
	}
}