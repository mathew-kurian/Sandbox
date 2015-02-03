/**
 * @(#)PairOfDice.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/13
 */

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
import javax.swing.SwingConstants;
import javax.swing.JOptionPane;
import javax.swing.border.Border;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;
import java.util.Scanner;

public class PairOfDice {
 	
 	public int die1;   // Number showing on the first die.
    public int die2;   // Number showing on the second die.
    
    public int die1Roll;   // Number showing on the first die.
    public int die2Roll;   // Number showing on the second die.
    
    public ArrayList<JLabel> SubObjects = new ArrayList<JLabel>();
	public ArrayList<JLabel> ExtrasObjects = new ArrayList<JLabel>();
	
	public ImageIcon d0 = new ImageIcon("images\\dice\\d0.png");
	public ImageIcon d1 = new ImageIcon("images\\dice\\d1.png");
    public ImageIcon d2 = new ImageIcon("images\\dice\\d2.png");
    public ImageIcon d3 = new ImageIcon("images\\dice\\d3.png");
    public ImageIcon d4 = new ImageIcon("images\\dice\\d4.png");
    public ImageIcon d5 = new ImageIcon("images\\dice\\d5.png");
    public ImageIcon d6 = new ImageIcon("images\\dice\\d6.png");
    
    public JLabel d0Label1;
    public JLabel d1Label1;
    public JLabel d2Label1;
    public JLabel d3Label1;
    public JLabel d4Label1;
 	public JLabel d5Label1;
 	public JLabel d6Label1;
 	
 	public JLabel d0Label2;
    public JLabel d1Label2;
    public JLabel d2Label2;
    public JLabel d3Label2;
    public JLabel d4Label2;
 	public JLabel d5Label2;
 	public JLabel d6Label2;
 	
 	public JPanel dPanel = new JPanel(new GridBagLayout());  	
 	
    public PairOfDice() {
    	
    	d0Label1 = new JLabel(d0);
    	d1Label1 = new JLabel(d1);
    	d2Label1 = new JLabel(d2);
    	d3Label1 = new JLabel(d3);
   		d4Label1 = new JLabel(d4);
 		d5Label1 = new JLabel(d5);
 		d6Label1 = new JLabel(d6);
 		
 		d0Label2 = new JLabel(d0);
    	d1Label2 = new JLabel(d1);
    	d2Label2 = new JLabel(d2);
    	d3Label2 = new JLabel(d3);
   		d4Label2 = new JLabel(d4);
 		d5Label2 = new JLabel(d5);
 		d6Label2 = new JLabel(d6);
 		
    }
    public Component RollWithValue() {
        
        JPanel releasedPanel = new JPanel(new GridBagLayout());
        
        try{releasedPanel.setBorder(new CentredBackgroundBorder(ImageIO.read(new File("images\\dice\\dieback.png"))));}catch (IOException e) {        }
        
        die1 = (int)(Math.random()*6) + 1;
        
        if(die1==1){ releasedPanel.add(d1Label1); }
        if(die1==2){ releasedPanel.add(d2Label1); }
        if(die1==3){ releasedPanel.add(d3Label1); }
        if(die1==4){ releasedPanel.add(d4Label1); }
        if(die1==5){ releasedPanel.add(d5Label1); }
        if(die1==6){ releasedPanel.add(d6Label1); }
        
        die2 = (int)(Math.random()*6) + 1;
        
        if(die2==1){ releasedPanel.add(d1Label2); }
        if(die2==2){ releasedPanel.add(d2Label2); }
        if(die2==3){ releasedPanel.add(d3Label2); }
        if(die2==4){ releasedPanel.add(d4Label2); }
        if(die2==5){ releasedPanel.add(d5Label2); }
        if(die2==6){ releasedPanel.add(d6Label2); }    
        
        releasedPanel.setOpaque(false);
        	
        return releasedPanel;   
    }   
    public Component getDefault(){
    	
    	try{dPanel.setBorder(new CentredBackgroundBorder(ImageIO.read(new File("images\\dice\\dieback.png"))));}catch (IOException e) {        }
    	
    	dPanel.add(d0Label1);
    	dPanel.add(d0Label2);
    	
    	dPanel.setOpaque(false);
    	
    	return dPanel;
    }
    public int getRollTotal()	{	return die1+die2;   }
}