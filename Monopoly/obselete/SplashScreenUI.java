/**
 * @(#)SplashScreenUI.java
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

public class SplashScreenUI {
	
	//JFrame
	JFrame splashBoard = new JFrame("Welcome");
	
	//JLabel
	JPanel splashPanel = new JPanel(new BorderLayout(3,1));// one row, 1 columns
	JPanel splashPanelBack = new JPanel(new BorderLayout(3,1));// one row, 1 columns
	
	//Public Images
	public ImageIcon splashScreenImage = new ImageIcon("images\\startup\\clear.png");
	
	//JLabels
	public JLabel splashScreenImageLabel = new JLabel(splashScreenImage);
	
	public PlayerNamesUI choose1;
	
	public HelpUI help;
	
	public BackgroundUI launcher = new BackgroundUI();    
	
	public AePlayWave musicChoice = new AePlayWave(); 
    
    public HistoryUI hist;
    
    public SplashScreenUI temp;
    
    public SplashScreenUI(HistoryUI a) {
    	
    	hist = a;
    	temp = this;
    	
    	//Panel Customization    	
    	try{splashPanelBack.setBorder(new CentredBackgroundBorder(ImageIO.read(new File("images\\startup\\startup.png"))));}catch (IOException e) {        }
    	splashPanel.setOpaque(false);
    	hist.addHistory("Panels Customized");
    		    	
    	//Make Background
    	launcher.createAndShowGUI(); 
    	hist.addHistory("Background Set");
    	
    	//Create MenuBar
		JMenuBar topBar = new JMenuBar();
		hist.addHistory("JMenuBar Set");
		
		//Create Menu
		JMenu fileMenu = new JMenu("File");
		JMenu optionMenu = new JMenu("Options");
		JMenu themeMenuSub = new JMenu("Themes");
		JMenu musicMenuSub = new JMenu("Music");
		hist.addHistory("Menus Formed");
				
    	//Create MenuItem
		JMenuItem newItem = new JMenuItem("New Game");
		JMenuItem quitItem = new JMenuItem("Quit");
		
		JMenuItem CenterSwitcher1 = new JRadioButtonMenuItem  ("Carbon");
		JMenuItem CenterSwitcher2 = new JRadioButtonMenuItem  ("Aura");
		JMenuItem CenterSwitcher3 = new JRadioButtonMenuItem  ("Flow");
		JMenuItem CenterSwitcher4 = new JRadioButtonMenuItem  ("Bubbles");
		JMenuItem CenterSwitcher5 = new JRadioButtonMenuItem  ("Borealis");
		JMenuItem CenterSwitcher6 = new JRadioButtonMenuItem  ("Fluid");
		JMenuItem CenterSwitcher7 = new JRadioButtonMenuItem  ("Nebula");
		JMenuItem CenterSwitcher8 = new JRadioButtonMenuItem  ("Mixture");
		JMenuItem CenterSwitcher9 = new JRadioButtonMenuItem  ("Fluid");
		JMenuItem CenterSwitcher10 = new JRadioButtonMenuItem  ("Cityscape");
		JMenuItem CenterSwitcher11 = new JRadioButtonMenuItem  ("Violet");
				
		JMenuItem MusicSwitcher1 = new JRadioButtonMenuItem  ("Colplay - In My Place");
		JMenuItem MusicSwitcher2 = new JRadioButtonMenuItem  ("Kevin Rudolf - Let It Rock");
		JMenuItem MusicSwitcher3 = new JRadioButtonMenuItem  ("Colplay - Trouble");	
		JMenuItem MusicSwitcher4 = new JRadioButtonMenuItem  ("Gears of War Remix - Remember the Name");	
		JMenuItem MusicSwitcher5 = new JRadioButtonMenuItem  ("Mute");	
			
		CenterSwitcher1.setSelected(true); //AutoChooses UK
		hist.addHistory("CenterSwitcher1 enabled");
		
		ButtonGroup themesGroup = new ButtonGroup();
		themesGroup.add(CenterSwitcher1);	
		themesGroup.add(CenterSwitcher2);
		themesGroup.add(CenterSwitcher3);	
		themesGroup.add(CenterSwitcher4);
		themesGroup.add(CenterSwitcher5);
		themesGroup.add(CenterSwitcher6);	
		themesGroup.add(CenterSwitcher7);
		themesGroup.add(CenterSwitcher8);
		themesGroup.add(CenterSwitcher9);	
		themesGroup.add(CenterSwitcher10);
		themesGroup.add(CenterSwitcher11);
				
		ButtonGroup musicGroup = new ButtonGroup();
		musicGroup.add(MusicSwitcher1);	
		musicGroup.add(MusicSwitcher2);
		musicGroup.add(MusicSwitcher3);
		musicGroup.add(MusicSwitcher4);
		musicGroup.add(MusicSwitcher5);
		
		//Create MenuItem ActionListener
		quitItem.addActionListener(new QuitListener());
		
		CenterSwitcher1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background1.jpg"))));            	
            	hist.addHistory("CenterSwitcher1 enabled");
            }
		 }); 
		
		CenterSwitcher2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background2.jpg"))));            	
            	hist.addHistory("CenterSwitcher2 enabled");
            }
		 });		 
		 CenterSwitcher3.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background3.jpg"))));
            	hist.addHistory("CenterSwitcher3 enabled");
            }
		 });		 
		  CenterSwitcher4.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background4.jpg"))));
            	hist.addHistory("CenterSwitcher4 enabled");
            }
		 });
		  CenterSwitcher5.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background5.jpg"))));
            	hist.addHistory("CenterSwitcher5 enabled");
            }
		 });
		 CenterSwitcher6.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background6.jpg"))));
            	hist.addHistory("CenterSwitcher6 enabled");
            }
		 });
		 CenterSwitcher7.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background7.jpg"))));
            	hist.addHistory("CenterSwitcher7 enabled");
            }
		 });
		 CenterSwitcher8.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background8.jpg"))));
            	hist.addHistory("CenterSwitcher8 enabled");	
            }
		 });
		 CenterSwitcher9.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background9.jpg"))));
            	hist.addHistory("CenterSwitcher9 enabled");	
            }
		 });
		 CenterSwitcher10.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background10.jpg"))));
            	hist.addHistory("CenterSwitcher10 enabled");	
            }
		 });
		 CenterSwitcher11.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	launcher.changeBackGround(getBackground((new ImageIcon("images\\backgrounds\\background11.jpg"))));
            	hist.addHistory("CenterSwitcher11 enabled");	
            }
		 });
		  MusicSwitcher1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	try{musicChoice.stopAuline();}catch(NullPointerException e1){            	}
            	musicChoice.setFile("file:audio\\in_my_place_coldplay.wav", false);
            	try{musicChoice.start();} catch(IllegalThreadStateException i1){            	}
            	hist.addHistory("MusicSwitcher1 enabled");
            }
		 });
		  MusicSwitcher2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	try{musicChoice.stopAuline();}catch(NullPointerException e2){            	}
            	musicChoice.setFile("file:audio\\let_it_rock.wav", false);
            	try{musicChoice.start();} catch(IllegalThreadStateException i1){            	}
            	hist.addHistory("MusicSwitcher2 enabled");
            }
		 });
		   MusicSwitcher3.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	try{musicChoice.stopAuline();}catch(NullPointerException e3){ System.out.println("here");           	}            	
            	musicChoice.setFile("file:audio\\trouble_coldplay.wav", false);
            	try{musicChoice.start();} catch(IllegalThreadStateException i1){  System.out.println("here1");           	}
            	hist.addHistory("MusicSwitcher3 enabled");
            }
		 });
		   MusicSwitcher4.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	try{musicChoice.stopAuline();}catch(NullPointerException e3){            	}            	
            	musicChoice.setFile("file:audio\\fort_minor_rtn.wav", false);
            	try{musicChoice.start();} catch(IllegalThreadStateException i1){            	}
            	hist.addHistory("MusicSwitcher4 enabled");
            }
		 });	
		 	MusicSwitcher5.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	try{musicChoice.stopAuline();}catch(NullPointerException e3){            	}
            	musicChoice.setStop();
            	hist.addHistory("MusicSwitcher5 enabled");
            }
		 });
		 
		
		newItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
                hist.addHistory("PlayerNamesUI instantiaed");
                //Make the PlayerNamesUI and Show
				choose1 = new PlayerNamesUI(hist);
       			choose1.createAndShowGUI();
      			
      			// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame1 = SwingUtilities.getRoot(c);				
				
        		// Hide the frame
        	//	frame1.setVisible(false);                                          ////Note: Fix this
      	    }
        });      
		
		//MenuItem to Menu
		fileMenu.add(newItem);
		fileMenu.add(quitItem);
		
		themeMenuSub.add(CenterSwitcher1);
		themeMenuSub.add(CenterSwitcher3);
		themeMenuSub.add(CenterSwitcher2);
		themeMenuSub.add(CenterSwitcher4);
		themeMenuSub.add(CenterSwitcher5);
		themeMenuSub.add(CenterSwitcher6);
		themeMenuSub.add(CenterSwitcher7);
		themeMenuSub.add(CenterSwitcher8);
		themeMenuSub.add(CenterSwitcher9);
		themeMenuSub.add(CenterSwitcher10);
		themeMenuSub.add(CenterSwitcher11);
				
		musicMenuSub.add(MusicSwitcher1);
		musicMenuSub.add(MusicSwitcher2);
		musicMenuSub.add(MusicSwitcher3);
		musicMenuSub.add(MusicSwitcher4);
		musicMenuSub.add(MusicSwitcher5);
		
		optionMenu.add(themeMenuSub);
		optionMenu.add(musicMenuSub);
				
		//Menu dded to MenuBar
		topBar.add(fileMenu);
		topBar.add(optionMenu);
		
		//Button Created
		JLabel startLabel = new JLabel (new ImageIcon("images\\button\\START.png"));
		startLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\START.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\START_click.png")));
  			((JLabel)e.getSource()).repaint();  			
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\START.png")));
  			((JLabel)e.getSource()).repaint();
  			
  				hist.addHistory("PlayerNamesUI instantiaed");
  			 	
  			 	//Make the PlayerNamesUI and Show
				choose1= new PlayerNamesUI(hist);
       			choose1.createAndShowGUI();
      			
      			// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame = SwingUtilities.getRoot(c);
							
        		// Hide the frame
        		frame.setVisible(false); 
        		
        		splashBoard = null;
				//JLabel
				splashPanel = null;
				splashPanelBack = null;	
				//Public Images
				splashScreenImage = null;	
				//JLabels
				splashScreenImageLabel = null;
        		frame = null;
        		
        		Runtime r = Runtime.getRuntime();
				r.gc();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\START_over.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        
        JLabel helpLabel = new JLabel (new ImageIcon("images\\button\\HELP.png"));
		helpLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			   		 				
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\HELP.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\HELP_click.png")));
  			((JLabel)e.getSource()).repaint();
  			
  				// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame = SwingUtilities.getRoot(c);
							
        		// Hide the frame
        		frame.setVisible(false);
        		
        		//Make the PlayerNamesUI and Show
				help= new HelpUI(temp);
       			help.createAndShowGUI();
        		
        		
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\HELP.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\HELP_over.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        
        JLabel quitLabel = new JLabel (new ImageIcon("images\\button\\QUIT.png"));
		quitLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			   					
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT_click.png")));
  			((JLabel)e.getSource()).repaint();
  			 
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT.png")));
  			((JLabel)e.getSource()).repaint();
  			
  			System.exit(0);	
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT_over.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
				
		//Button Added to Stand-Alone Panel
		JPanel buttonPanel = new JPanel (new FlowLayout());
		buttonPanel.setOpaque(false);
		buttonPanel.add(startLabel);
		buttonPanel.add(helpLabel);
		buttonPanel.add(quitLabel);
		buttonPanel.setOpaque(false);
		hist.addHistory("Button Added to Stand-Alone Panel");
				
		//Combined
		splashPanel.add(topBar,BorderLayout.NORTH);
		splashPanel.add(buttonPanel,BorderLayout.SOUTH);
		splashPanel.add(splashScreenImageLabel, BorderLayout.CENTER);
		splashPanelBack.add(splashPanel);
		hist.addHistory("Panels Combined");
    
    }
    public void createAndShowGUI()
    {
    	splashBoard.setContentPane(splashPanelBack); // p from above, panel containing game board and text area
		splashBoard.setResizable(false);
		splashBoard.pack();
		splashBoard.setLocationRelativeTo(null);
		splashBoard.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		splashBoard.setVisible(true);
    }
    public ImageIcon getBackground(ImageIcon e)
    {
    	return e;
    }
    
    
        

}

