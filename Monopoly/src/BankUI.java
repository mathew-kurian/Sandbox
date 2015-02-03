/**
 * @(#)BankUI.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/16
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

public class BankUI implements MouseListener{
	
	public ImageIcon box = new ImageIcon("images\\bank\\box.png");
   	public ImageIcon background = new ImageIcon("images\\bank\\background.png");
	public ImageIcon playerMenu = new ImageIcon("images\\stats\\menu_stats.png");
	public ImageIcon playerMenuOver = new ImageIcon("images\\stats\\menu_stats - over.png");
	public ImageIcon playerMenuClick = new ImageIcon("images\\stats\\menu_stats - click.png");
	
	public JPanel fullPanel = new JPanel(new GridLayout(2,2));
	public JFrame BankFrame = new JFrame ("Bank");
	public ImagePanel BankPanel = new ImagePanel("images\\stats\\bank_menu.png");
	//public ImagePanel ChoosePanel = new ImagePanel("images\\stats\\hist_back.png");
	public ImagePanel ChoosePanel = new ImagePanel("images\\stats\\player_menu.png");
	public ImagePanel HistoryPanel = new ImagePanel("images\\stats\\history_menu.png");
	public ImagePanel PropertyPanel = new ImagePanel("images\\stats\\properties_menu.png");
	public JPanel PropPanel = new JPanel();
	public JPanel BankPanelLeft = new JPanel();    
    public JLabel totalMoney= new JLabel("             1502.00", box, JLabel.CENTER);;
    public JPanel ChoicesPanel = new JPanel();
    public JScrollPane chooseScroll = new JScrollPane(ChoicesPanel);
       	
 /*  	public JLabel playerMenuLabel1 = new JLabel(playerMenu);
   	public JLabel playerMenuLabel2 = new JLabel(playerMenu);
   	public JLabel playerMenuLabel3 = new JLabel(playerMenu);
   	public JLabel playerMenuLabel4 = new JLabel(playerMenu);
   	public JLabel playerMenuLabel5 = new JLabel(playerMenu);*/
    
    public ImagePanel playerInfo1 = new ImagePanel(playerMenuClick); 
    public ImagePanel playerInfo2 = new ImagePanel(playerMenu);
    public ImagePanel playerInfo3 = new ImagePanel(playerMenu);
    public ImagePanel playerInfo4 = new ImagePanel(playerMenu); 
    public ImagePanel playerInfo5 = new ImagePanel(playerMenu); 
    		
	public Date Today;
	public SimpleDateFormat TimeFormat;	
	public String TimeStamp;
	
	public String selected = "1";	
		
	public JTextArea HistoryText1 = new JTextArea(55,51);
	public JScrollPane HistoryScroll1 = new JScrollPane(HistoryText1);
	
	public JTextArea HistoryText2 = new JTextArea(55,51);
	public JScrollPane HistoryScroll2 = new JScrollPane(HistoryText2);
	
	public JTextArea HistoryText3 = new JTextArea(55,51);
	public JScrollPane HistoryScroll3 = new JScrollPane(HistoryText3);
	
	public JTextArea HistoryText4 = new JTextArea(55,51);
	public JScrollPane HistoryScroll4 = new JScrollPane(HistoryText4);
	
	public JTextArea HistoryText5 = new JTextArea(55,51);
	public JScrollPane HistoryScroll5 = new JScrollPane(HistoryText5);
	
	public JScrollPane currentHistoryPane;
	
	public JSplitPane splitPane;
	
	public JPanel propChoicesPane1 = new JPanel();
	public JPanel propChoicesPane2 = new JPanel();
	public JPanel propChoicesPane3 = new JPanel();
	public JPanel propChoicesPane4 = new JPanel();
	public JPanel propChoicesPane5 = new JPanel();
	
	public JPanel propFullView = new JPanel();
		
	Dimension dim = new Dimension();
	
	public BoxPoperties PopUpProps ;
		
	public PropertiesListener PropListener;
	
    public BankUI()
     
    {  
    	playerInfo1.setName("1");
    	playerInfo2.setName("2");
    	playerInfo3.setName("3");
    	playerInfo4.setName("4");
    	playerInfo5.setName("5");
    	
    	playerInfo1.setOpaque(true);
    	playerInfo2.setOpaque(true);
    	playerInfo3.setOpaque(true);
    	playerInfo4.setOpaque(true);
    	playerInfo5.setOpaque(true);
    	
    	dim.setSize(playerMenu.getIconWidth()+20, playerMenu.getIconHeight()*2.5);
    	
    	//Customize main Panel
    	fullPanel.setBackground(new Color(176,176,176));    	
    	fullPanel.setOpaque(false);
    	fullPanel.setBorder(null);
    	
    	fullPanel = new JPanel(){
          public void paintComponent( Graphics g )
          {
               super.paintComponent(g);
               g.drawImage(background.getImage(), 0, 0, this );
          }
		};
		
		fullPanel.setLayout(new GridLayout(2,2));		
		fullPanel.setBorder(null);
				
		//Banking	    	
    	BankPanel.setLayout(new GridLayout(1,2));
    	BankPanel.setOpaque(false);
    	
    	BankPanelLeft.setLayout(new GridLayout(2,1));
    	BankPanelLeft.setOpaque(false);    		
    	
    	totalMoney.setHorizontalTextPosition(SwingConstants.CENTER);
    	totalMoney.setFont(new Font("Arial Rounded MT Bold", Font.PLAIN, 36));
    	totalMoney.setOpaque(false);
    	
    	BankPanelLeft.add(totalMoney);
    	
    	BankPanel.add(BankPanelLeft);
    	
    	fullPanel.add(BankPanel);
    	
    	/********************************************/
    	
    	//Choices
    	dim.setSize(351, 347);
    	
    	chooseScroll.setPreferredSize(dim); 
    	
    	ChoicesPanel.setLayout(new BoxLayout(ChoicesPanel, BoxLayout.Y_AXIS)); 	
    	ChoicesPanel.setSize(dim);
    
    	ChoicesPanel.setOpaque(false); 
    	chooseScroll.setOpaque(false); 
    	
    	ChoosePanel.setOpaque(false); 
    	ChoosePanel.setLayout(null);
    		
    	ChoosePanel.add(chooseScroll);
    	chooseScroll.setBounds(55,51,353, 347);
    		
    	playerInfo1.addMouseListener(this);
    	playerInfo2.addMouseListener(this);
    	playerInfo3.addMouseListener(this);
    	playerInfo4.addMouseListener(this);
    	playerInfo5.addMouseListener(this);
    	
    	playerInfo1.setLayout(new GridLayout(1,2));
    	playerInfo2.setLayout(new GridLayout(1,2));
    	playerInfo3.setLayout(new GridLayout(1,2));
    	playerInfo4.setLayout(new GridLayout(1,2));
    	playerInfo5.setLayout(new GridLayout(1,2));
    	
    	playerInfo1.setOpaque(false);
    	chooseScroll.setOpaque(false);
    	chooseScroll.getViewport().setOpaque(false);
    	    	
    	fullPanel.add(ChoosePanel);
    	
    	/**********************************/
    	
    	//History
    	HistoryPanel.setOpaque(false);
    	
    	HistoryScroll1.setBounds(55,51,351, 347);
    	HistoryScroll2.setBounds(55,51,351, 347);
    	HistoryScroll3.setBounds(55,51,351, 347);
    	HistoryScroll4.setBounds(55,51,351, 347);
    	HistoryScroll5.setBounds(55,51,351, 347);
    	
    	HistoryScroll1.setOpaque(false);
    	HistoryScroll2.setOpaque(false);
    	HistoryScroll3.setOpaque(false);
    	HistoryScroll4.setOpaque(false);
    	HistoryScroll5.setOpaque(false);
      	
      	HistoryScroll1.getViewport().setOpaque(false);
      	HistoryScroll2.getViewport().setOpaque(false);
      	HistoryScroll3.getViewport().setOpaque(false);
      	HistoryScroll4.getViewport().setOpaque(false);
      	HistoryScroll5.getViewport().setOpaque(false);
      	
    	HistoryText1.setText("Time :: Event");
    	HistoryText2.setText("Time :: Event");
    	HistoryText3.setText("Time :: Event");
    	HistoryText4.setText("Time :: Event");
    	HistoryText5.setText("Time :: Event");
    	
    	HistoryText1.setEditable(false);
		HistoryText1.setLineWrap(true);
		HistoryText1.setWrapStyleWord(true);
		HistoryText1.setOpaque(false);
		HistoryText1.setForeground(Color.BLACK);
    	HistoryText1.setFont(new Font("Arial", Font.BOLD, 15));
    	
		HistoryText2.setEditable(false);
		HistoryText2.setLineWrap(true);
		HistoryText2.setWrapStyleWord(true);
		HistoryText2.setOpaque(false);
		HistoryText2.setForeground(Color.BLACK);
    	HistoryText2.setFont(new Font("Arial", Font.BOLD, 15));
    	
		HistoryText3.setEditable(false);
		HistoryText3.setLineWrap(true);
		HistoryText3.setWrapStyleWord(true);
		HistoryText3.setOpaque(false);
		HistoryText3.setForeground(Color.BLACK);
    	HistoryText3.setFont(new Font("Arial", Font.BOLD, 15));
    	
		HistoryText4.setEditable(false);
		HistoryText4.setLineWrap(true);
		HistoryText4.setWrapStyleWord(true);
		HistoryText4.setOpaque(false);
		HistoryText4.setForeground(Color.BLACK);
    	HistoryText4.setFont(new Font("Arial", Font.BOLD, 15));
    	
		HistoryText5.setEditable(false);
		HistoryText5.setLineWrap(true);
		HistoryText5.setWrapStyleWord(true);
		HistoryText5.setOpaque(false);
    	HistoryText5.setForeground(Color.BLACK);
    	HistoryText5.setFont(new Font("Arial", Font.BOLD, 15));
    	
    	HistoryPanel.add(HistoryScroll1);
    	    	
    	fullPanel.add(HistoryPanel);  
    	
    	/***************************************Cards*/
    	propChoicesPane1.setOpaque(false);
    	propChoicesPane2.setOpaque(false);
    	propChoicesPane3.setOpaque(false);
    	propChoicesPane4.setOpaque(false);
    	propChoicesPane5.setOpaque(false);
    	
    	propFullView.setOpaque(false);
    	propFullView.setLayout(new FlowLayout());
    	
    	JScrollPane ScrollPanelChoices = new JScrollPane(propChoicesPane1);
    	ScrollPanelChoices.getViewport().setOpaque(false); 
    	ScrollPanelChoices.setOpaque(false);
    		  	
    	splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, ScrollPanelChoices, propFullView);
    	splitPane.setOneTouchExpandable(true);
		splitPane.setDividerLocation(70);
		splitPane.setBounds(55,51,351, 347);
		splitPane.setOpaque(false);
			
		PropertyPanel.setLayout(null);
		PropertyPanel.add(splitPane);
		PropertyPanel.setOpaque(false);
				
		fullPanel.add(PropertyPanel);
				  		
    }
        public Component getGUI()
    	{
    		return fullPanel;
    	}
    	
    	public void updatePlayers(int x, JLabel [] a,  JLabel [] b)
    	{    		
    		switch(x)
    		{
    		 	case 2: playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
   				
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					
    					ChoicesPanel.add(playerInfo1);
    					ChoicesPanel.add(playerInfo2);
    					
    					dim.setSize(playerMenu.getIconWidth()+20, ((playerMenu.getIconHeight()*2)));
    					
    					chooseScroll.setPreferredSize(dim);
    					ChoicesPanel.setSize(dim);
    					
    					break;
    	    			
    			case 3: playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
   				
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					
    					ChoicesPanel.add(playerInfo1);
    					ChoicesPanel.add(playerInfo2);
    					ChoicesPanel.add(playerInfo3);
    			
    					break;
    	    			
    			case 4: playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
   				
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    			
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    			
    					ChoicesPanel.add(playerInfo1);
    					ChoicesPanel.add(playerInfo2);
    					ChoicesPanel.add(playerInfo3);
    					ChoicesPanel.add(playerInfo4);
    					
    					break;
    			
    			case 5: playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					playerInfo1.add(a[0]);
    					
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
    					playerInfo1.add(b[0]);
   				
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					playerInfo2.add(a[1]);
    					
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					playerInfo2.add(b[1]);
    					
    									
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					playerInfo3.add(a[2]);
    					
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    					playerInfo3.add(b[2]);
    			
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					playerInfo4.add(a[3]);
    					
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    					playerInfo4.add(b[3]);
    					
    					playerInfo5.add(a[4]);
    					playerInfo5.add(a[4]);
    					playerInfo5.add(a[4]);
    					playerInfo5.add(a[4]);
    					
    					playerInfo5.add(b[4]);
    					playerInfo5.add(b[4]);
    					playerInfo5.add(b[4]);
    					playerInfo5.add(b[4]);    						
    					
    					ChoicesPanel.add(playerInfo1);
    					ChoicesPanel.add(playerInfo2);
    					ChoicesPanel.add(playerInfo3);
    					ChoicesPanel.add(playerInfo4);
    					ChoicesPanel.add(playerInfo5);
    					
    					break;
    	    			
    					

    		}
    		
    					playerInfo1.validate();
    					playerInfo1.repaint();
    				
    		 			playerInfo2.validate();
    					playerInfo2.repaint();
    				
    		 			playerInfo3.validate();
    					playerInfo3.repaint();
    				
    		 			playerInfo4.validate();
    					playerInfo4.repaint();
    				
    		 			playerInfo5.validate();
    					playerInfo5.repaint();
    					
    					ChoicesPanel.validate();
    					ChoicesPanel.repaint();
    				
    	
    	}
    	public void addHistory(int x, String a)
    	{
    		TimeFormat = new SimpleDateFormat("hh.mm.ss");
			Today = new Date();
			TimeStamp = TimeFormat.format(Today);
		
    		switch (x) {
           	
            case 0: HistoryText1.append("\n\n"+ TimeStamp + ": " + a);
            		HistoryText1.setCaretPosition(HistoryText1.getDocument().getLength());
            	        break;
            case 1: HistoryText2.append("\n\n"+ TimeStamp + ": " + a); 
            		HistoryText2.setCaretPosition(HistoryText2.getDocument().getLength());
            		 	break;
            case 2: HistoryText3.append("\n\n"+ TimeStamp + ": " + a); 
            		HistoryText3.setCaretPosition(HistoryText3.getDocument().getLength());
            		 	break;
            case 3: HistoryText4.append("\n\n"+ TimeStamp + ": " + a); 
            		HistoryText4.setCaretPosition(HistoryText4.getDocument().getLength());
            		 	break;
            case 4: HistoryText5.append("\n\n"+ TimeStamp + ": " + a); 
            		HistoryText5.setCaretPosition(HistoryText5.getDocument().getLength());
            		 	break;
    		}
    	    	
    	}
    
    		public void mouseClicked(MouseEvent e) 
    		{
  					
  	    	}
        	public void mouseExited(MouseEvent e) 
        	{   
        		if ((((ImagePanel)e.getSource()).getName())!=(selected))
  				{        		
  					((ImagePanel)e.getSource()).changeImage(playerMenu);
  					((ImagePanel)e.getSource()).repaint();
  				}
        	}
        	public void mousePressed(MouseEvent e) 
        	{        
  				if(selected.equals("1"));
  				{
  					playerInfo1.changeImage(playerMenu);
  			//		playerInfo1.repaint();
  				}
  				if(selected.equals("2"));
  				{
  					playerInfo2.changeImage(playerMenu);
  			//		playerInfo2.repaint();
  				}
  				if(selected.equals("3"));
  				{
  					playerInfo3.changeImage(playerMenu);
  			//		playerInfo3.repaint();
  				}
  				if(selected.equals("4"));
  				{
  					playerInfo4.changeImage(playerMenu);
  			//		playerInfo4.repaint();
  				}
  				if(selected.equals("5"));
  				{
  					playerInfo5.changeImage(playerMenu);
  			//		playerInfo5.repaint();
  				}
  				
  				selected = ((ImagePanel)e.getSource()).getName();
  								  				
  				((ImagePanel)e.getSource()).changeImage(playerMenuClick);
  				
  				if(((ImagePanel)e.getSource()).getName().equals("1"))
  				{
  					HistoryPanel.removeAll();
  					HistoryPanel.add(HistoryScroll1);
  					
  					HistoryPanel.validate();
  					HistoryPanel.repaint();
  					
  					PropertyPanel.removeAll();
  					
  					JScrollPane ScrollPanelChoices1 = new JScrollPane(propChoicesPane1);
    	    		ScrollPanelChoices1.getViewport().setOpaque(false);
    	    		ScrollPanelChoices1.setOpaque(false);    	    		   		
    	    		
    				splitPane.setTopComponent(ScrollPanelChoices1);
    				splitPane.setOneTouchExpandable(true);
					splitPane.setDividerLocation(70);
					splitPane.setBounds(55,51,351, 347);
					splitPane.setOpaque(false);
  					
  					PropertyPanel.add(splitPane);
  					
  					PropertyPanel.validate();
  					PropertyPanel.repaint();  					
  					
  				}
  				if(((ImagePanel)e.getSource()).getName().equals("2"))
  				{
  					 
  					HistoryPanel.removeAll();
  					HistoryPanel.add(HistoryScroll2);
  					
  					HistoryPanel.validate();
  					HistoryPanel.repaint();
  					
  					JScrollPane ScrollPanelChoices2 = new JScrollPane(propChoicesPane2);
  					ScrollPanelChoices2.getViewport().setOpaque(false);
  					ScrollPanelChoices2.setOpaque(false);
  					  					
    				splitPane.setTopComponent(ScrollPanelChoices2);
    				splitPane.setOneTouchExpandable(true);
					splitPane.setDividerLocation(70);
					splitPane.setBounds(55,51,351, 347);
					splitPane.setOpaque(false);
  					
  					PropertyPanel.add(splitPane);
  					
  					PropertyPanel.validate();
  					PropertyPanel.repaint();  	
  				}
  				if(((ImagePanel)e.getSource()).getName().equals("3"))
  				{
  					HistoryPanel.removeAll();
  					HistoryPanel.add(HistoryScroll3);
  					
  					
  					HistoryPanel.validate();
  					HistoryPanel.repaint();
  					
  					JScrollPane ScrollPanelChoices3 = new JScrollPane(propChoicesPane3);
  					ScrollPanelChoices3.getViewport().setOpaque(false);
  					ScrollPanelChoices3.setOpaque(false);
    	    	 
    				splitPane.setTopComponent(ScrollPanelChoices3);
    				splitPane.setOneTouchExpandable(true);
					splitPane.setDividerLocation(70);
					splitPane.setBounds(55,51,351, 347);
					splitPane.setOpaque(false);
  					
  					PropertyPanel.add(splitPane);
  					
  					PropertyPanel.validate();
  					PropertyPanel.repaint();  	
  				}
  				if(((ImagePanel)e.getSource()).getName().equals("4"))
  				{
  					HistoryPanel.removeAll();
  					HistoryPanel.add(HistoryScroll4);
  					
  					HistoryPanel.validate();
  					HistoryPanel.repaint();
  					
  					JScrollPane ScrollPanelChoices4 = new JScrollPane(propChoicesPane4);
  					ScrollPanelChoices4.getViewport().setOpaque(false);
  					ScrollPanelChoices4.setOpaque(false);
    	    	
    				splitPane.setTopComponent(ScrollPanelChoices4);
    				splitPane.setOneTouchExpandable(true);
					splitPane.setDividerLocation(70);
					splitPane.setBounds(55,51,351, 347);
					splitPane.setOpaque(false);
  					
  					PropertyPanel.add(splitPane);
  					
  					PropertyPanel.validate();
  					PropertyPanel.repaint();  	
  				}
  				if(((ImagePanel)e.getSource()).getName().equals("5"))
  				{
  					HistoryPanel.removeAll();
  					HistoryPanel.add(HistoryScroll5);
  					
  					HistoryPanel.validate();
  					HistoryPanel.repaint();
  					
  					JScrollPane ScrollPanelChoices5 = new JScrollPane(propChoicesPane5);
  					ScrollPanelChoices5.getViewport().setOpaque(false);
  					ScrollPanelChoices5.setOpaque(false);
    	    	
    				splitPane.setTopComponent(ScrollPanelChoices5);
    				splitPane.setOneTouchExpandable(true);
					splitPane.setDividerLocation(70);
					splitPane.setBounds(55,51,351, 347);
					splitPane.setOpaque(false);
  					
  					PropertyPanel.add(splitPane);
  					
  					PropertyPanel.validate();
  					PropertyPanel.repaint();  	
  				}
  				
  				((ImagePanel)e.getSource()).repaint();
        	}
        	public void mouseReleased(MouseEvent e) 
        	{          		
  				
        	}
        	public void mouseEntered(MouseEvent e) 
        	{
       			if (((ImagePanel)e.getSource()).getName()!=selected)
  				{
       				((ImagePanel)e.getSource()).changeImage(playerMenuOver);
  					((ImagePanel)e.getSource()).repaint();  
  				}			
       		}
       	
     	public void resizeImageAndAdd (Icon ic, int a, String name) 
     	{     	
 			double scale = 85;
 			int largestDimension = 55;
 			
			int sizeDifference, originalImageLargestDim;
			
				Image inImage = iconToImage(ic);
			
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
					      	
      	JLabel thumbnail = new JLabel(new ImageIcon(inImage));
      	thumbnail.setName(name);
      	thumbnail.addMouseListener(PropListener);
      	       	
      	switch(a)
     {      	
      		case 0: propChoicesPane1.add(thumbnail);
      				propChoicesPane1.validate();
       				propChoicesPane1.repaint();    		
            	        break;
            case 1: propChoicesPane2.add(thumbnail);
      				propChoicesPane2.validate();
       				propChoicesPane2.repaint();            		
            		 	break;
            case 2: propChoicesPane3.add(thumbnail);
      				propChoicesPane3.validate();
       				propChoicesPane3.repaint();
            		 	break;
            case 3: propChoicesPane4.add(thumbnail);
      				propChoicesPane4.validate();
       				propChoicesPane4.repaint();
            		 	break;
            case 4: propChoicesPane5.add(thumbnail);
      				propChoicesPane5.validate();
       				propChoicesPane5.repaint();
            		 	break;
     	} 
     		             	
       	splitPane.validate();
       	splitPane.repaint();
       	       	
  	}
  	
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
  	public void setDeedImages(BoxPoperties p)
  	{
  		 PopUpProps = p;
  		 PropListener = new PropertiesListener(p, propFullView);
  	}
  	
}