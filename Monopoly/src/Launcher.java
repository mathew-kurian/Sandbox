/**
 * @(#)Launcher.java
 *
 *
 * @Mathew Kurian
 * @version 1.00 2010/2/11
 */
 
import java.awt.AlphaComposite;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Graphics;
import java.awt.Graphics2D;

import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Component;
import java.awt.Font;  
import java.awt.geom.RoundRectangle2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;

import java.io.IOException;
import java.io.File;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.SourceDataLine;

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
import javax.swing.SwingConstants;
import javax.swing.JOptionPane;
import javax.swing.border.Border;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.UIManager;

import javax.imageio.ImageIO;

//import com.sun.awt.AWTUtilities;

import java.util.*;
import java.lang.Object;
import java.util.Scanner;

public class Launcher {
	
	public static HistoryUI hist = new HistoryUI();
	
    public static void main(String[] args) 
    
    {       
	try {UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());} catch(Exception e) {}
    	
    	JFrame logoFade = new JFrame("");
    		logoFade.setBackground(Color.BLACK); //Frame Background Color
    		logoFade.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    		hist.addHistory("Frame Background Color Set");
    		
		JPanel background = new JPanel();		
			background.setLayout(new FlowLayout());
			background.setOpaque(false);		
			hist.addHistory("Background Color Set");
			
		FadeLogoUI fadeL = new FadeLogoUI();
			fadeL.setBackground(Color.BLACK); //Fade to Color
			hist.addHistory("Fader Formed");
			
		logoFade.setGlassPane(fadeL);		
		
		background.add(new JLabel(new ImageIcon("images\\backgrounds\\title.png")));	

       	logoFade.setContentPane(background);
       	logoFade.setUndecorated(true);
       	logoFade.pack(); 
	
       		
       	logoFade.setLocationRelativeTo(logoFade.getRootPane()); //Center
       	
       	BlackStage black = new BlackStage(); //Black Background
 		black.createAndShowGUI();  //Black stage will always be in the back
 	
       	logoFade.setVisible(true);
       	       		
       	try{Thread.sleep(4000);}
       	catch(InterruptedException e) {e.printStackTrace();} 		
 		
		fadeL.setVisible(true); //Begin the Fade
       	fadeL.FadeEnd();		//Commence Fade
	
		try{Thread.sleep(1000);}
       	catch(InterruptedException e) {e.printStackTrace();}       
        
        logoFade.setVisible(false);   //Hide the Fade Frame      
   
   		SplashScreenUI starter = new SplashScreenUI(hist); 
    	
    	/***********************************************TEMPORARY*/
    	
	PropertyReader reader = new PropertyReader();  
    		reader.populateAll(); 	
    	
    	ArrayList<String>name;
   		ArrayList<String>group;
  		ArrayList<Integer>position;
   		ArrayList<Integer>price;
   		ArrayList<Integer>rent;  		
   	    
    	    name= reader.getNameArrayList();
   			group= reader.getGroupArrayList();
  			position= reader.getPositonArrayList();
   			price= reader.getPriceArrayList();
   			rent= reader.getRentArrayList();
   		
   		for(int x = 0; x<40; x++)
   		{
   			hist.addHistory("Name: " + name.get(x) + " Color: " + group.get(x) + " Location: " + position.get(x) + " Cost: " + price.get(x) + " Rent: " + rent.get(x)+"\n");
   		}
   		
   		hist.addHistory("Successfull Loading");
		/***********************************************TEMPORARY*/
    }    
   
}        
    	


