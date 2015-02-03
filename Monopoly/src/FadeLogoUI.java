/**
 * @(#)FadeLogoUI.java
 *
 *
 * @author 
 * @version 1.00 2010/3/3
 */
 
import java.awt.AlphaComposite;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Graphics;
import java.awt.Graphics2D;
import javax.swing.*;

public class FadeLogoUI extends JPanel
    {
        public float opacity;
        public Timer fadeTimerEnd;
        public Timer fadeTimerOpen;
 
        public void FadeEnd() 
        {
        	opacity = 0f;
        	
            fadeTimerEnd = new Timer(75,new ActionListener(){
            	
            	public void actionPerformed(ActionEvent e) 
        		{
            		opacity += .03;
            
           			if(opacity > 1) 
            
            		{
                		opacity = 1;
                		fadeTimerEnd.stop();
                		fadeTimerEnd = null;
           			}
            
            	repaint();
        		}});
        		
            fadeTimerEnd.setInitialDelay(0);
            fadeTimerEnd.start();
 
        }
        public void FadeOpen() 
        {       	
            fadeTimerOpen = new Timer(10,new ActionListener(){
            	
            	public void actionPerformed(ActionEvent e) 
        		{
            		opacity -= .03;
            
           			if(opacity < 0f) 
            
            		{            		
                		opacity = 0f;
                		System.out.print(opacity);
                		fadeTimerOpen.stop();
                		fadeTimerOpen = null;
           			}
            	
            	System.out.print(opacity+ ", ");
            	
            	repaint();
        		}});
        		
            fadeTimerOpen.setInitialDelay(0);
            fadeTimerOpen.start();
 
        }
        public void paintComponent(Graphics g) 
        {
            ((Graphics2D) g).setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, opacity));
            g.setColor(getBackground());
            g.fillRect(0,0,getWidth(),getHeight());
        }
        public void setOpacity(float opacityLevel) 
        {
        	opacity = opacityLevel;
        	repaint();
        }	
    }