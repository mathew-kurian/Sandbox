/**
 * @(#)CardListener.java
 *
 *
 * @author 
 * @version 1.00 2010/3/18
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

public class CardListener implements MouseListener{
    
    	ImageIcon chanceNormal;
    	ImageIcon chanceYellow;
    	
    	ImageIcon commNormal;
    	ImageIcon commYellow;
    
    	PopUpUI popup;
    	
    	Player p;
    	
    	boolean enabled = false;
    	int numCount = 2000;
    	
    public CardListener() {    }
    	
    public void mousePressed(MouseEvent e) {  }
    public void mouseReleased(MouseEvent e) 
    {
    	if(enabled)
    	{
    	  	if((((JLabel)e.getSource()).getName()=="Chance")&&(numCount==1))
       		{       		
       				((JLabel)e.getSource()).setIcon(chanceNormal);
       				((JLabel)e.getSource()).repaint();
       				disableAll();
       				popup.showChanceCard(p);
       		    		
       }
       		if((((JLabel)e.getSource()).getName()=="CommChest")&&(numCount==2))
       		{
       				((JLabel)e.getSource()).setIcon(commNormal);
       				((JLabel)e.getSource()).repaint(); 
       				disableAll();
       				popup.showCommCard(p);    		
       		}
    	}
    }
    
    public void mouseEntered(MouseEvent e) 
    {   	
    	if(enabled)
    	{
       			if((((JLabel)e.getSource()).getName()=="Chance")&&(numCount==1))
       		{
       				((JLabel)e.getSource()).setIcon(chanceYellow);
       				((JLabel)e.getSource()).repaint();      		
       		}
     		  if((((JLabel)e.getSource()).getName()=="CommChest")&&(numCount==2))
       		{
       				((JLabel)e.getSource()).setIcon(commYellow);
       				((JLabel)e.getSource()).repaint();     		
      		 }
    	}
    }
    public void mouseExited(MouseEvent e) 
    {
    	if(enabled)
    	{
       		if((((JLabel)e.getSource()).getName()=="Chance")&&(numCount==1))
       		{
       				((JLabel)e.getSource()).setIcon(chanceNormal);
       				((JLabel)e.getSource()).repaint();       		
       		}
        	if((((JLabel)e.getSource()).getName()=="CommChest")&&(numCount==2))
       		{
       				((JLabel)e.getSource()).setIcon(commNormal);
       				((JLabel)e.getSource()).repaint();       		
       		}
    	}
    }
    public void mouseClicked(MouseEvent e){ }
     
    public void setPopUpAndImages(PopUpUI p, ImageIcon cn, ImageIcon cy, ImageIcon ccn, ImageIcon ccy)
    {    	
    	chanceNormal = cn;
     	chanceYellow = cy;
    	
     	commNormal = ccn;
     	commYellow = ccy;
    
     	popup = p;
    }
    public void setEnabled(int a)
    {
    	numCount = a;
    	enabled = true;
    }
    public void disableAll()
    {
    	numCount = 454545;
    	enabled = false;
    }
    public void setCurrentPlayer(Player pa)
    {
    	p = pa;
    } 
}	