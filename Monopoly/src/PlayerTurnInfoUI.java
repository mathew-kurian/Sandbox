/**
 * @(#)PlayerTurnInfoUI.java
 *
 *
 * @author 
 * @version 1.00 2010/2/27
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

import javax.swing.JFrame;
import javax.swing.JFormattedTextField;
import javax.swing.JScrollPane;
import javax.swing.JMenuBar;
import javax.swing.JTextArea;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;
import javax.swing.SwingUtilities;
import javax.swing.SwingConstants;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.ButtonGroup;
import javax.swing.JList;
import javax.swing.ListSelectionModel;
import javax.swing.event.*;
import javax.swing.DefaultListModel;

import java.io.PrintWriter;
import java.io.IOException;
import java.io.File;

import java.util.*;

import java.lang.Object;

public class PlayerTurnInfoUI {
	
	public JFrame tempNameFrame ;
    public TransparentBackground tempNamePanel;
    public JLabel tempNameLabel= null;
    
    int PLAYERNUM = 1;
    int NUMPLAYERCOUNT = 0;
    
    ArrayList<Player> playerList = null;
    
    boolean recreationFrames = true; //Continue
    
    public PlayerTurnInfoUI(ArrayList<Player> a) //Frome POPUI << GAMEBOARDUI [TRANSFERRED]
    {    	    	
    	String filler = null;
    	NUMPLAYERCOUNT = a.size();
    	playerList = a;
    }
    public void actionPlayers() ////DEPRECATED METHOD
    {     	
    	tempNameFrame = new JFrame("tempNameFrame");
    	tempNamePanel = new TransparentBackground(tempNameFrame);
    	
    	String tempName = playerList.get((PLAYERNUM)%NUMPLAYERCOUNT).getName();
    		
    	/****************************************** MAKE YOUR MOVE*/    			
    	
    	tempNamePanel.removeAll();
    	tempNamePanel.setLayout(new FlowLayout());
    				
  		tempNameLabel = new JLabel(tempName+": Make Your Move");
  		tempNameLabel.setFont(new Font("Arial Rounded MT Bold", Font.PLAIN, 36));
  					
  		tempNamePanel.add(tempNameLabel);  					
  		
  		tempNameFrame.setContentPane(tempNamePanel);
    	tempNameFrame.setUndecorated(true);
    	
    	tempNameFrame.setAlwaysOnTop(true);
    	tempNameFrame.pack();
		tempNameFrame.setLocationRelativeTo(null);
		
		tempNameFrame.setVisible(true);
		
		Timer timer = new Timer();
		timer.schedule( new HideFrame( tempNameFrame ), 2000 );		
				
		PLAYERNUM++;
		
		try{Thread.sleep(2001);} catch(InterruptedException a){		};
		
		tempNameFrame = null;
		tempNamePanel = null;
		tempName = null;
		
		Runtime r = Runtime.getRuntime();
		r.gc();	
			
    	}
    
}
    
   
