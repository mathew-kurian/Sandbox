/**
 * @(#)PlayerNamesUI.java
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
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Component;

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

import java.io.PrintWriter;
import java.io.IOException;
import java.io.File;

import java.util.*;

import java.lang.Object;

public class PlayerNamesUI extends SplashScreenUI implements ActionListener {
	
	public JFrame PlayerFrame = new JFrame ("Options");
	public JPanel NamePanel;	
    public JPanel OKPanel;
    
    public PrintWriter printMe = null;
    
    public ImageIcon border = new ImageIcon("images\\borders\\player_border.png");
    
    public String Name1 = "Player Name";
    
    public String [] playerNumChoices = {"2","3","4","5"};
    
    public ArrayList <JRadioButton> samegroup1ArrayList = new ArrayList <JRadioButton>();
    public ArrayList <JRadioButton> samegroup2ArrayList = new ArrayList <JRadioButton>();
    public ArrayList <JRadioButton> samegroup3ArrayList = new ArrayList <JRadioButton>();
    public ArrayList <JRadioButton> samegroup4ArrayList = new ArrayList <JRadioButton>();
    public ArrayList <JRadioButton> samegroup5ArrayList = new ArrayList <JRadioButton>();
    
    public JFormattedTextField textArea1 = new JFormattedTextField();
   	public JFormattedTextField textArea2 = new JFormattedTextField();
    public JFormattedTextField textArea3 = new JFormattedTextField();
    public JFormattedTextField textArea4 = new JFormattedTextField();
    public JFormattedTextField textArea5 = new JFormattedTextField();
    
    public String textArea1String;
    public String textArea2String;
    public String textArea3String;
    public String textArea4String;
    public String textArea5String;
    
        ButtonGroup group1Button = new ButtonGroup();
        ButtonGroup group2Button = new ButtonGroup();
        ButtonGroup group3Button = new ButtonGroup();
        ButtonGroup group4Button = new ButtonGroup();
        ButtonGroup group5Button = new ButtonGroup();
        
     /*   ButtonGroup samegroup1Button = new ButtonGroup();
        ButtonGroup samegroup2Button = new ButtonGroup();
        ButtonGroup samegroup3Button = new ButtonGroup();
        ButtonGroup samegroup4Button = new ButtonGroup();
        ButtonGroup samegroup5Button = new ButtonGroup();*/
        
        JPanel RadioPanel1 = new JPanel(new GridLayout(1,5));
    	JPanel RadioPanel2 = new JPanel(new GridLayout(1,5));
    	JPanel RadioPanel3 = new JPanel(new GridLayout(1,5));
    	JPanel RadioPanel4 = new JPanel(new GridLayout(1,5));
    	JPanel RadioPanel5 = new JPanel(new GridLayout(1,5));
    
        public JRadioButton logoButton1 = new JRadioButton("NBA Logo");
        public JRadioButton iButton1 = new JRadioButton("IPhone");
        public JRadioButton remiButton1 = new JRadioButton("Ratatouille");
        public  JRadioButton sunButton1 = new JRadioButton("Sun");        
        public JRadioButton ballButton1 = new JRadioButton("BasketBall");
        
        public JRadioButton logoButton2 = new JRadioButton("NBA Logo");
        public JRadioButton iButton2 = new JRadioButton("IPhone");
        public JRadioButton remiButton2 = new JRadioButton("Ratatouille");
        public JRadioButton sunButton2 = new JRadioButton("Sun");        
        public JRadioButton ballButton2 = new JRadioButton("BasketBall");
        
        public JRadioButton logoButton3 = new JRadioButton("NBA Logo");
        public JRadioButton iButton3 = new JRadioButton("IPhone");
        public JRadioButton remiButton3 = new JRadioButton("Ratatouille");
        public JRadioButton sunButton3 = new JRadioButton("Sun");        
        public JRadioButton ballButton3 = new JRadioButton("BasketBall");
    	
    	public JRadioButton logoButton4 = new JRadioButton("NBA Logo");
        public JRadioButton iButton4 = new JRadioButton("IPhone");
        public JRadioButton remiButton4 = new JRadioButton("Ratatouille");
        public JRadioButton sunButton4 = new JRadioButton("Sun");        
        public JRadioButton ballButton4 = new JRadioButton("BasketBall");
        
        public JRadioButton logoButton5 = new JRadioButton("NBA Logo");
        public JRadioButton iButton5 = new JRadioButton("IPhone");
        public JRadioButton remiButton5 = new JRadioButton("Ratatouille");
        public JRadioButton sunButton5 = new JRadioButton("Sun");        
        public JRadioButton ballButton5 = new JRadioButton("BasketBall");
    
    	public PlayerNamesUI()
    {
    	
    	NamePanel = new JPanel();
    	OKPanel = new JPanel();

    	NamePanel.setLayout(new BoxLayout(NamePanel, BoxLayout.Y_AXIS));
    	OKPanel.setLayout(new GridLayout(1,10));
    	RadioPanel1.setLayout(new GridLayout(1,5));
    	RadioPanel2.setLayout(new GridLayout(1,5));
    	RadioPanel3.setLayout(new GridLayout(1,5));
    	RadioPanel4.setLayout(new GridLayout(1,5));
    	RadioPanel5.setLayout(new GridLayout(1,5));
    	
    	JLabel borderLabel = new JLabel(border);	
    	JLabel spacer1 = new JLabel(" ");	
    	JLabel text = new JLabel("Choose Number of Players:");	
    	JLabel spacer2 = new JLabel(" ");
    	JLabel spacer3 = new JLabel(" ");
    	JLabel spacer4 = new JLabel(" ");    	
    	   	
    	borderLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
    	text.setAlignmentX(Component.LEFT_ALIGNMENT);
    	    	
    	textArea1.setValue(new String(Name1));
    	textArea2.setValue(new String(Name1));
    	textArea3.setValue(new String(Name1));
    	textArea4.setValue(new String(Name1));
    	textArea5.setValue(new String(Name1));	
    	
    	textArea1.setEnabled(true);
    	textArea2.setEnabled(true);
		textArea3.setEnabled(false);
		textArea4.setEnabled(false);
		textArea5.setEnabled(false);
		
	    				
    	JButton OK = new JButton("  ", new ImageIcon("images\\button\\checkmark.png"));
    	OK.setHorizontalTextPosition(SwingConstants.CENTER);
		OK.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {
                printList();
                
                //Make the GameBoardUI and Show                
      		    GameBoardUI theGameBoard = new GameBoardUI();    
      			theGameBoard.createAndShowGUI();
      				
      			// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame = SwingUtilities.getRoot(c);

        		// Hide the frame
        		frame.setVisible(false);
      			
            }
        }); 
        
        JButton quitButton = new JButton("  ", new ImageIcon("images\\button\\xmark.png"));
		quitButton.setHorizontalTextPosition(SwingConstants.CENTER);
		quitButton.addActionListener(new QuitListener());     

    	JComboBox playerNum = new JComboBox(playerNumChoices);
    	playerNum.setSize(5,5);
    	playerNum.setSelectedIndex(0);
    	
    	//Enable/Disable TextAreas
    	playerNum.addActionListener(new ActionListener(){
    		
    		public void actionPerformed(ActionEvent e)
            {
                JComboBox cb = (JComboBox)e.getSource();
        		int playerNumberInt =  Integer.parseInt((String)cb.getSelectedItem());
        		
        		if(playerNumberInt==2)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(false);
    				textArea4.setEnabled(false);
    				textArea5.setEnabled(false);
    				
    			  	textArea3.setValue(new String(Name1));	
    				textArea4.setValue(new String(Name1));	
    				textArea5.setValue(new String(Name1));
    				
    		 logoButton1.setEnabled(true);
    	     iButton1.setEnabled(true);
    	     remiButton1.setEnabled(true);
    	     sunButton1.setEnabled(true);
    	     ballButton1.setEnabled(true);
    		
    	     logoButton2.setEnabled(true);
    	     iButton2.setEnabled(true);
    	     remiButton2.setEnabled(true);
    	     sunButton2.setEnabled(true);
    	     ballButton2.setEnabled(true);
    		 
    		 logoButton3.setEnabled(false);
    	     iButton3.setEnabled(false);
    	     remiButton3.setEnabled(false);
    	     sunButton3.setEnabled(false);
    	     ballButton3.setEnabled(false);
    		
    	     logoButton4.setEnabled(false);
    	     iButton4.setEnabled(false);
    	     remiButton4.setEnabled(false);
    	     sunButton4.setEnabled(false);
    	     ballButton4.setEnabled(false);
    	
    	     logoButton5.setEnabled(false);
    	     iButton5.setEnabled(false);
    	     remiButton5.setEnabled(false);
    	     sunButton5.setEnabled(false);
    	     ballButton5.setEnabled(false);	    				
        		}
        		
        		if(playerNumberInt==3)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(true);
    				textArea4.setEnabled(false);
    				textArea5.setEnabled(false);
    			
    				textArea4.setValue(new String(Name1));	
    				textArea5.setValue(new String(Name1));
    						
    		 logoButton1.setEnabled(true);
    	     iButton1.setEnabled(true);
    	     remiButton1.setEnabled(true);
    	     sunButton1.setEnabled(true);
    	     ballButton1.setEnabled(true);
    		
    	     logoButton2.setEnabled(true);
    	     iButton2.setEnabled(true);
    	     remiButton2.setEnabled(true);
    	     sunButton2.setEnabled(true);
    	     ballButton2.setEnabled(true);
    		 
    		 logoButton3.setEnabled(true);
    	     iButton3.setEnabled(true);
    	     remiButton3.setEnabled(true);
    	     sunButton3.setEnabled(true);
    	     ballButton3.setEnabled(true);
    	     
    	     logoButton4.setEnabled(false);
    	     iButton4.setEnabled(false);
    	     remiButton4.setEnabled(false);
    	     sunButton4.setEnabled(false);
    	     ballButton4.setEnabled(false);
    	
    	     logoButton5.setEnabled(false);
    	     iButton5.setEnabled(false);
    	     remiButton5.setEnabled(false);
    	     sunButton5.setEnabled(false);
    	     ballButton5.setEnabled(false);
           		}
           		
        		if(playerNumberInt==4)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(true);
    				textArea4.setEnabled(true);
    				textArea5.setEnabled(false);
    		
    				textArea5.setValue(new String(Name1));	
    		    		
    	     logoButton1.setEnabled(true);
    	     iButton1.setEnabled(true);
    	     remiButton1.setEnabled(true);
    	     sunButton1.setEnabled(true);
    	     ballButton1.setEnabled(true);
    		
    	     logoButton2.setEnabled(true);
    	     iButton2.setEnabled(true);
    	     remiButton2.setEnabled(true);
    	     sunButton2.setEnabled(true);
    	     ballButton2.setEnabled(true);
    		 
    		 logoButton3.setEnabled(true);
    	     iButton3.setEnabled(true);
    	     remiButton3.setEnabled(true);
    	     sunButton3.setEnabled(true);
    	     ballButton3.setEnabled(true);
    	     
    	     logoButton4.setEnabled(true);
    	     iButton4.setEnabled(true);
    	     remiButton4.setEnabled(true);
    	     sunButton4.setEnabled(true);
    	     ballButton4.setEnabled(true);
    	
    	     logoButton5.setEnabled(false);
    	     iButton5.setEnabled(false);
    	     remiButton5.setEnabled(false);
    	     sunButton5.setEnabled(false);
    	     ballButton5.setEnabled(false);
    	     
        		}
        		if(playerNumberInt==5)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(true);
    				textArea4.setEnabled(true);
    				textArea5.setEnabled(true); 
    		
    		 logoButton1.setEnabled(true);
    	     iButton1.setEnabled(true);
    	     remiButton1.setEnabled(true);
    	     sunButton1.setEnabled(true);
    	     ballButton1.setEnabled(true);
    		
    	     logoButton2.setEnabled(true);
    	     iButton2.setEnabled(true);
    	     remiButton2.setEnabled(true);
    	     sunButton2.setEnabled(true);
    	     ballButton2.setEnabled(true);
    		 
    		 logoButton3.setEnabled(true);
    	     iButton3.setEnabled(true);
    	     remiButton3.setEnabled(true);
    	     sunButton3.setEnabled(true);
    	     ballButton3.setEnabled(true);
    	     
    	     logoButton4.setEnabled(true);
    	     iButton4.setEnabled(true);
    	     remiButton4.setEnabled(true);
    	     sunButton4.setEnabled(true);
    	     ballButton4.setEnabled(true);
    	
    	     logoButton5.setEnabled(true);
    	     iButton5.setEnabled(true);
    	     remiButton5.setEnabled(true);
    	     sunButton5.setEnabled(true);
    	     ballButton5.setEnabled(true); 	
    		
        		}
        		
            }
        });
             logoButton1.addActionListener(this);
    	     iButton1.addActionListener(this);
    	     remiButton1.addActionListener(this);
    	     sunButton1.addActionListener(this);
    	     ballButton1.addActionListener(this);
    		
    	     logoButton2.addActionListener(this);
    	     iButton2.addActionListener(this);
    	     remiButton2.addActionListener(this);
    	     sunButton2.addActionListener(this);
    	     ballButton2.addActionListener(this);
    		 
    		 logoButton3.addActionListener(this);
    	     iButton3.addActionListener(this);
    	     remiButton3.addActionListener(this);
    	     sunButton3.addActionListener(this);
    	     ballButton3.addActionListener(this);
    	     
    	     logoButton4.addActionListener(this);
    	     iButton4.addActionListener(this);
    	     remiButton4.addActionListener(this);
    	     sunButton4.addActionListener(this);
    	     ballButton4.addActionListener(this);
    	
    	     logoButton5.addActionListener(this);
    	     iButton5.addActionListener(this);
    	     remiButton5.addActionListener(this);
    	     sunButton5.addActionListener(this);
    	     ballButton5.addActionListener(this);
       	        
    	samegroup1ArrayList.add(logoButton1);
    	samegroup1ArrayList.add(logoButton2);
    	samegroup1ArrayList.add(logoButton3);
    	samegroup1ArrayList.add(logoButton4);
    	samegroup1ArrayList.add(logoButton5);
    	
    	samegroup2ArrayList.add(iButton1);
    	samegroup2ArrayList.add(iButton2);
    	samegroup2ArrayList.add(iButton3);
    	samegroup2ArrayList.add(iButton4);
    	samegroup2ArrayList.add(iButton5);
    	
    	samegroup3ArrayList.add(remiButton1);
    	samegroup3ArrayList.add(remiButton2);
    	samegroup3ArrayList.add(remiButton3);
    	samegroup3ArrayList.add(remiButton4);
    	samegroup3ArrayList.add(remiButton5);
    	
		samegroup4ArrayList.add(sunButton1);
    	samegroup4ArrayList.add(sunButton2);
    	samegroup4ArrayList.add(sunButton3);
    	samegroup4ArrayList.add(sunButton4);
    	samegroup4ArrayList.add(sunButton5);
    	
    	samegroup5ArrayList.add(ballButton1);
    	samegroup5ArrayList.add(ballButton2);
    	samegroup5ArrayList.add(ballButton3);
    	samegroup5ArrayList.add(ballButton4);
    	samegroup5ArrayList.add(ballButton5);
    	
    	group1Button.add(logoButton1);
    	group1Button.add(iButton1);
    	group1Button.add(remiButton1);
    	group1Button.add(sunButton1);
    	group1Button.add(ballButton1);
    	
    	group2Button.add(logoButton2);
    	group2Button.add(iButton2);
    	group2Button.add(remiButton2);
    	group2Button.add(sunButton2);
    	group2Button.add(ballButton2);
    	
    	group3Button.add(logoButton3);
    	group3Button.add(iButton3);
    	group3Button.add(remiButton3);
    	group3Button.add(sunButton3);
    	group3Button.add(ballButton3);
    	
		group4Button.add(logoButton4);
    	group4Button.add(iButton4);
    	group4Button.add(remiButton4);
    	group4Button.add(sunButton4);
    	group4Button.add(ballButton4);
    	
    	group5Button.add(logoButton5);
    	group5Button.add(iButton5);
    	group5Button.add(remiButton5);
    	group5Button.add(sunButton5);
    	group5Button.add(ballButton5);
    	
    	RadioPanel1.add(logoButton1);
    	RadioPanel1.add(iButton1);
    	RadioPanel1.add(remiButton1);
    	RadioPanel1.add(sunButton1);
    	RadioPanel1.add(ballButton1);
    	
    	RadioPanel2.add(logoButton2);
    	RadioPanel2.add(iButton2);
    	RadioPanel2.add(remiButton2);
    	RadioPanel2.add(sunButton2);
    	RadioPanel2.add(ballButton2);
    	
    	RadioPanel3.add(logoButton3);
    	RadioPanel3.add(iButton3);
    	RadioPanel3.add(remiButton3);
    	RadioPanel3.add(sunButton3);
    	RadioPanel3.add(ballButton3);
    	
		RadioPanel4.add(logoButton4);
    	RadioPanel4.add(iButton4);
    	RadioPanel4.add(remiButton4);
    	RadioPanel4.add(sunButton4);
    	RadioPanel4.add(ballButton4);
    	
    	RadioPanel5.add(logoButton5);
    	RadioPanel5.add(iButton5);
    	RadioPanel5.add(remiButton5);
    	RadioPanel5.add(sunButton5);
    	RadioPanel5.add(ballButton5);
    	
    	JPanel set1 = new JPanel(new GridLayout(2,1));
    	JPanel set2 = new JPanel(new GridLayout(2,1));
    	JPanel set3 = new JPanel(new GridLayout(2,1));
    	JPanel set4 = new JPanel(new GridLayout(2,1));
    	JPanel set5 = new JPanel(new GridLayout(2,1));
    	
    	set1.add(textArea1);
    	set1.add(spacer1);
    	set1.add(RadioPanel1);
    	set1.add(spacer1);
    	
    	set2.add(textArea2);
    	set2.add(spacer1);
    	set2.add(RadioPanel2);
    	set2.add(spacer1);
    	
    	set3.add(textArea3);
    	set3.add(spacer1);
    	set3.add(RadioPanel3);
    	set3.add(spacer1);
    	
    	set4.add(textArea4);
    	set4.add(spacer1);
    	set4.add(RadioPanel4);
    	set4.add(spacer1);
    	
    	set5.add(textArea5);
    	set5.add(spacer1);
    	set5.add(RadioPanel5);
    	set5.add(spacer1);
    	
    	
    	//Combined
    	OKPanel.add(OK);
    	OKPanel.add(quitButton);
    	NamePanel.add(borderLabel);
    	NamePanel.add(spacer1);
    	NamePanel.add(spacer1);
       	NamePanel.add(playerNum);
    	NamePanel.add(set1);
    	NamePanel.add(set2);
    	NamePanel.add(set3);
    	NamePanel.add(set4);
    	NamePanel.add(set5);
    	NamePanel.add(spacer1);
    	NamePanel.add(OKPanel);

    	    	
    }
        public void createAndShowGUI()
    {
    	PlayerFrame.setContentPane(NamePanel); // p from above, panel containing game board and text area
		PlayerFrame.pack();
		PlayerFrame.setLocationRelativeTo(null);
		PlayerFrame.setVisible(true);
    }
    	
    	public void printList()
    	{
    			try
    		{
    			printMe = new PrintWriter(new File("PlayerNamesUI.MKONE"));
    		}
    			catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PlayerNamesUI.java)", "Warning", JOptionPane.WARNING_MESSAGE);
    		}
    			
    			textArea1String=textArea1.getText();
    			textArea2String=textArea2.getText();
    			textArea3String=textArea3.getText();
    			textArea4String=textArea4.getText();
    			textArea5String=textArea5.getText();
    					
    				if(textArea1String.equals("Player Name")==false)
    			{    				
    				printMe.println(textArea1String);
    			}
    				if(textArea2String.equals("Player Name")==false)
    			{    				
    				printMe.println(textArea2String);
    			}
    				if(textArea3String.equals("Player Name")==false)
    			{    			
    				printMe.println(textArea3String);
    			}
    				if(textArea4String.equals("Player Name")==false)
    			{    			
    				printMe.println(textArea4String);
    			}
    				if(textArea5String.equals("Player Name")==false)
    			{    				
    				printMe.println(textArea5String);
    			}
    			
    	printMe.close();
    	}
    	
    	public void setAllEnabled()
    	{
    		 logoButton4.setEnabled(false);
    	     iButton4.setEnabled(false);
    	     remiButton4.setEnabled(false);
    	     sunButton4.setEnabled(false);
    	     ballButton4.setEnabled(false);
    	
    	     logoButton5.setEnabled(false);
    	     iButton5.setEnabled(false);
    	     remiButton5.setEnabled(false);
    	     sunButton5.setEnabled(false);
    	     ballButton5.setEnabled(false);
    	}
    	public void actionPerformed( ActionEvent e) 
    	{
    		if ((((JRadioButton) e.getSource())==logoButton1))
    		{
    				if ((((JRadioButton) e.getSource()).isShowing()))
    			{
    				logoButton1.setVisible(true);
    				logoButton2.setVisible(false);
    				logoButton3.setVisible(false);
    				logoButton4.setVisible(false);
    				logoButton5.setVisible(false);
    			}
    		if ((((JRadioButton) e.getSource())==logoButton2))
    			
    			if ((((JRadioButton) e.getSource()).isShowing()))
    			{
    				logoButton1.setVisible(false);
    				logoButton2.setVisible(true);
    				logoButton3.setVisible(false);
    				logoButton4.setVisible(false);
    				logoButton5.setVisible(false);
    			}
    		if ((((JRadioButton) e.getSource())==logoButton3))
    			
    			if ((((JRadioButton) e.getSource()).isShowing()))
    			{
    				logoButton1.setVisible(false);
    				logoButton2.setVisible(false);
    				logoButton3.setVisible(true);
    				logoButton4.setVisible(false);
    				logoButton5.setVisible(false);
    			}
    		if ((((JRadioButton) e.getSource())==logoButton4))
    			
    			if ((((JRadioButton) e.getSource()).isShowing()))
    			{
    				logoButton1.setVisible(false);
    				logoButton2.setVisible(false);
    				logoButton3.setVisible(false);
    				logoButton4.setVisible(true);
    				logoButton5.setVisible(false);
    			}
    		if ((((JRadioButton) e.getSource())==logoButton5))
    			
    			if ((((JRadioButton) e.getSource()).isShowing()))
    			{
    				logoButton1.setVisible(false);
    				logoButton2.setVisible(false);
    				logoButton3.setVisible(false);
    				logoButton4.setVisible(false);
    				logoButton5.setVisible(true);
    			}
    		if ((((JRadioButton) e.getSource())==iButton1))
    		{	
    				logoButton1.setVisible(true);
    				logoButton2.setVisible(true);
    				logoButton3.setVisible(true);
    				logoButton4.setVisible(true);
    				logoButton5.setVisible(true);
    			
    		}
    	}
   
  }
}
  
  
  