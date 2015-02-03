/**
 * @(#)GamePiece.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/14
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

import java.io.File;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JFormattedTextField;
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

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;

public class GamePiece {

	public BufferedImage graphic = new BufferedImage(48, 48, BufferedImage.TYPE_INT_ARGB);
	
	public ImageIcon BBall= new ImageIcon("images\\pieces\\basketball.png");
   	public ImageIcon IPhone= new ImageIcon("images\\pieces\\iphone.png");
  	public ImageIcon Logo= new ImageIcon("images\\pieces\\nba_logo.png");
  	public ImageIcon Remi= new ImageIcon("images\\pieces\\Remi.png");
   	public ImageIcon Sun= new ImageIcon("images\\pieces\\Sun.png");
   	 	
	String IconName;
        
    public GamePiece() 
    {
    	
    }
    public GamePiece(String a) 
    {    	
    	IconName=a;
    	
    	if (a.equalsIgnoreCase("basketball"))    	{    	try{	graphic = ImageIO.read(new File("images\\pieces\\basketball.png"));    	}catch (IOException e) {        }}
    	else if (a.equalsIgnoreCase("iphone"))    	{    	try{	graphic = ImageIO.read(new File("images\\pieces\\iphone.png"));    		}catch (IOException e) {        }}
    	else if (a.equalsIgnoreCase("logo"))    	{    	try{	graphic = ImageIO.read(new File("images\\pieces\\nba_logo.png"));    	}catch (IOException e) {        }}
    	else if (a.equalsIgnoreCase("remi"))	   	{    	try{	graphic = ImageIO.read(new File("images\\pieces\\Remi.png"));    		}catch (IOException e) {        }}
    	else    									{    	try{	graphic = ImageIO.read(new File("images\\pieces\\Sun.png"));    		}catch (IOException e) {        }}
    }
    public Graphics getGraphic()    						
   	{	
   		Graphics returhGraphic = graphic.getGraphics();    		
   		return returhGraphic;
   	}
   	public ImageIcon getImageIcon()
   	{
   		ImageIcon returnIcon;
   		
   		if (IconName.equalsIgnoreCase("basketball"))    	{  returnIcon = BBall; 	}
    	else if (IconName.equalsIgnoreCase("iphone"))    	{  returnIcon = IPhone; }
    	else if (IconName.equalsIgnoreCase("logo"))    		{  returnIcon = Logo;  	}
    	else if (IconName.equalsIgnoreCase("remi"))	   		{  returnIcon = Remi;  	}
    	else   												{  returnIcon = Sun;  	}
    	
    	return returnIcon;
   	}
    public ImageIcon[] getFullChoices()
    {
    	ImageIcon [] IconChoices= new ImageIcon[]{BBall, IPhone, Logo, Remi, Sun 	};
    	return IconChoices;
    }
    
}
