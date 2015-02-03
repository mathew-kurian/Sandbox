/**
 * @(#)GameBoardUI.java
 *
 *
 * @Mathew Kurian
 * @version 1.00 2010/2/11
 */
 
import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
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
import javax.swing.JTabbedPane;
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
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;
import java.util.Scanner;

public class GameBoardUI  extends JFrame implements MouseListener {
    
    //Primary Components
    JTextArea textArea;
    JFrame frameBoard = new JFrame("Monopoly");
    TransparentBackgroundStandStill combinedPanel;
    JFrame PopUpDeedFrame;
    
    public BoxPoperties boxProp = new BoxPoperties();
    public PairOfDice dice = new PairOfDice();
    public PopUpUI popup; 
    
    public JPanel dicePanel;
    public ModJLabel center;       
    public JLabel RollButton;
    
    public MKEngine engine;    
    public BankUI bank = new BankUI();
    
    Scanner kb = null;
	
	public int NUMPLAYERCOUNT = 0;
    public int PLAYERNUM = 0;
    	    
    public JPanel westAreaPanel = new JPanel(new GridLayout(4, 1));
   // ImagePanel westAreaPanel = new ImagePanel(new ImageIcon("images\\background3.jpg").getImage()); 
    public JPanel PlayerPanel1asuba;
    public JPanel PlayerPanel1asubb;
    
    public ArrayList <ModJLabel> NorthEdgeArrayList = new ArrayList <ModJLabel>();
    public ArrayList <ModJLabel> EastEdgeArrayList = new ArrayList <ModJLabel>();
    public ArrayList <ModJLabel> WestEdgeArrayList = new ArrayList <ModJLabel>();
    public ArrayList <ModJLabel> SouthEdgeArrayList = new ArrayList <ModJLabel>();
    public ArrayList <ModJLabel> FullBoardArrayList = new ArrayList <ModJLabel>(); 	
    
    public Timer timer;
    public Timer COMTimer;
    public Timer CHANCETimer;
    public Timer motionTimer;
    
    public Integer temp1;
    
    public ArrayList<Player> playerList = new ArrayList<Player>();
       
    public ImageIcon propClear = new ImageIcon("images\\stats\\property_clear.png");
           
    JPanel CombinedPlayersPanel = new JPanel(); 
    ImagePanel PlayerPanel1 = new ImagePanel("images\\stats\\Stat.png");   
    ImagePanel PlayerPanel2 = new ImagePanel("images\\stats\\Stat.png");   
    ImagePanel PlayerPanel3 = new ImagePanel("images\\stats\\Stat.png");   
    ImagePanel PlayerPanel4 = new ImagePanel("images\\stats\\Stat.png");   
    ImagePanel PlayerPanel5 = new ImagePanel("images\\stats\\Stat.png");   
    
    ImageIcon chanceNormal = new ImageIcon("images\\card\\chance.png");
    ImageIcon chanceYellow = new ImageIcon("images\\card\\chance_yellow.png");
    
    ImageIcon CommChestNormal = new ImageIcon("images\\card\\comm_chest.png");
    ImageIcon CommChestYellow = new ImageIcon("images\\card\\comm_chest_yellow.png");
    
    public JLabel Chance = new JLabel(chanceNormal);
    public JLabel CommChest = new JLabel(CommChestNormal);
    
    public JLabel PlayerIconLabel1 = new JLabel ();
    public JLabel PlayerGlassNameLabel1 = new JLabel ();
    public JLabel PlayerGlassMoneyLabel1 = new JLabel ();
    public PropJLabel PlayerGlassPropertyBoxesLabel1 = new PropJLabel (propClear);
        
    public JLabel PlayerIconLabel2 = new JLabel ();
    public JLabel PlayerGlassNameLabel2 = new JLabel ();
    public JLabel PlayerGlassMoneyLabel2 = new JLabel ();
    public PropJLabel PlayerGlassPropertyBoxesLabel2 = new PropJLabel (propClear);
    
    public JLabel PlayerIconLabel3 = new JLabel ();
    public JLabel PlayerGlassNameLabel3 = new JLabel ();
    public JLabel PlayerGlassMoneyLabel3 = new JLabel ();
    public PropJLabel PlayerGlassPropertyBoxesLabel3 = new PropJLabel (propClear);
    
    public JLabel PlayerIconLabel4 = new JLabel ();
    public JLabel PlayerGlassNameLabel4 = new JLabel ();
    public JLabel PlayerGlassMoneyLabel4 = new JLabel ();
    public PropJLabel PlayerGlassPropertyBoxesLabel4 = new PropJLabel (propClear);
    
    public JLabel PlayerIconLabel5 = new JLabel ();
    public JLabel PlayerGlassNameLabel5 = new JLabel ();
    public JLabel PlayerGlassMoneyLabel5 = new JLabel ();
    public PropJLabel PlayerGlassPropertyBoxesLabel5 = new PropJLabel(propClear);
        
    
    	JLabel copyPlayerIconLabel1;
	  	JLabel copyPlayerIconLabel2;
	  	JLabel copyPlayerIconLabel3;
	  	JLabel copyPlayerIconLabel4;
	  	JLabel copyPlayerIconLabel5;
	  	
	  	JLabel copyPlayerGlassNameLabel1;
	  	JLabel copyPlayerGlassNameLabel2;
	  	JLabel copyPlayerGlassNameLabel3;
	  	JLabel copyPlayerGlassNameLabel4;
	  	JLabel copyPlayerGlassNameLabel5;
	  	
    
    public JLabel [] copyPlayerIconList = new JLabel[5];
    public JLabel [] copyPlayerNameList = new JLabel[5];
    
    public ArrayList<ImagePanel> PlayerPanelList = new ArrayList<ImagePanel>();							   							 
    							   
    public JLabel [] PlayerMoneyList = { PlayerGlassMoneyLabel1, PlayerGlassMoneyLabel2, PlayerGlassMoneyLabel3,
    							   PlayerGlassMoneyLabel4, PlayerGlassMoneyLabel5	};
    
    public JLabel [] PlayerNameList = { PlayerGlassNameLabel1, PlayerGlassNameLabel2, PlayerGlassNameLabel3,
    							   PlayerGlassNameLabel4, PlayerGlassNameLabel5	};
    							   
    public PropJLabel [] PlayerPropList = { PlayerGlassPropertyBoxesLabel1, PlayerGlassPropertyBoxesLabel2, PlayerGlassPropertyBoxesLabel3,
    							   PlayerGlassPropertyBoxesLabel4, PlayerGlassPropertyBoxesLabel5	};	
    
    public JLabel StarOnCurrentPlayer = new JLabel (new ImageIcon("images\\stats\\star.png"));
    							   	
    int originalLocation = 0;
	int newLocation = 0;
    
    public int tempLocation;
    
    BoardPieces properties = new BoardPieces();
    
    public AePlayWave click;
    public AePlayWave cardFlicker;
    
    //Panel Creations
    public	JPanel gameBoard = new JPanel(new BorderLayout(1,2));// one row, 2 columns
	public	JPanel northEdge = new JPanel(new GridBagLayout()); // one row, 9 columns
	public	JPanel southEdge = new JPanel(new GridBagLayout());// one row, 9 columns
	public	JPanel eastEdge = new JPanel(new GridLayout(9, 1)); // six rows, 1 column
	public	JPanel westEdge = new JPanel(new GridLayout(9, 1));// six rows, 1 column
	
	public JTabbedPane gameBoardHolder = new JTabbedPane(JTabbedPane.TOP);
    
    public ImagePanel cardPanel = new ImagePanel("images\\boards\\center3.png");   ///NOTE NOTE NOTE///////////////TWO OF THE SAME BACKGROUNDS***************
    
    CardListener cardsL = new CardListener();
    
    public Player motionTemp;
               	   	   	
    public GameBoardUI()
    {   
    	cardPanel.setLayout(null);    		
    	
    	Chance.setBounds(19,12,208,218);
    	CommChest.setBounds(478,474,208,218);
    	
    	Chance.setName("Chance");
    	CommChest.setName("CommChest");
       	
    	cardsL.disableAll();
    		
    	cardPanel.add(Chance);
    	cardPanel.add(CommChest);
    	
    	Chance.addMouseListener(cardsL);
    	CommChest.addMouseListener(cardsL);
    	
    	StarOnCurrentPlayer.setBounds(180, 45, 48, 48);
    		
    	/***********************************************************************/
  		PlayerPanel1.setLayout(null);
  		PlayerGlassNameLabel1.setBounds(87, 22, 145, 25);
  		PlayerIconLabel1.setBounds(21,19,60,60);
  		PlayerGlassMoneyLabel1.setBounds(87,43,145,25);
  		PlayerGlassPropertyBoxesLabel1.setBounds(78,65,120,40);
  		PlayerPanel1.add(StarOnCurrentPlayer);
       	PlayerPanel1.add(PlayerGlassNameLabel1);    	
    	PlayerPanel1.add(PlayerIconLabel1);	
    	PlayerPanel1.add(PlayerGlassMoneyLabel1);    		
    	PlayerPanel1.add(PlayerGlassPropertyBoxesLabel1);
    	/*************************************************************/
    	PlayerPanel2.setLayout(null);    	
    	PlayerGlassNameLabel2.setBounds(87, 22, 145, 25);
  		PlayerIconLabel2.setBounds(21,19,60,60);
  		PlayerGlassMoneyLabel2.setBounds(87,43,145,25);
  		PlayerGlassPropertyBoxesLabel2.setBounds(78,65,120,40);
       	PlayerPanel2.add(PlayerGlassNameLabel2); 		
    	PlayerPanel2.add(PlayerIconLabel2);  
    	PlayerPanel2.add(PlayerGlassMoneyLabel2);
    	PlayerPanel2.add(PlayerGlassPropertyBoxesLabel2);
    	/***********************************************************************/
    	PlayerPanel3.setLayout(null);
    	PlayerGlassNameLabel3.setBounds(87, 22, 145, 25);
  		PlayerIconLabel3.setBounds(21,19,60,60);
  		PlayerGlassMoneyLabel3.setBounds(87,43,145,25);
  		PlayerGlassPropertyBoxesLabel3.setBounds(78,65,120,40);
    	PlayerPanel3.add(PlayerIconLabel3);
    	PlayerPanel3.add(PlayerGlassNameLabel3);
    	PlayerPanel3.add(PlayerGlassMoneyLabel3);
    	PlayerPanel3.add(PlayerGlassPropertyBoxesLabel3);
   		/***********************************************************************/ 	
    	PlayerPanel4.setLayout(null);
    	PlayerGlassNameLabel4.setBounds(87, 22, 145, 25);
  		PlayerIconLabel4.setBounds(21,19,60,60);
  		PlayerGlassMoneyLabel4.setBounds(87,43,145,25);
  		PlayerGlassPropertyBoxesLabel4.setBounds(78,65,120,40);   		
    	PlayerPanel4.add(PlayerIconLabel4);    	
    	PlayerPanel4.add(PlayerGlassNameLabel4);
    	PlayerPanel4.add(PlayerGlassMoneyLabel4);    	
    	PlayerPanel4.add(PlayerGlassPropertyBoxesLabel4);
    	/***********************************************************************/
    	PlayerPanel5.setLayout(null);
    	PlayerGlassNameLabel5.setBounds(87, 22, 145, 25);
  		PlayerIconLabel5.setBounds(21,19,60,60);
  		PlayerGlassMoneyLabel5.setBounds(87,43,145,25);
  		PlayerGlassPropertyBoxesLabel5.setBounds(78,65,120,40);
    	PlayerPanel5.add(PlayerIconLabel5);    
    	PlayerPanel5.add(PlayerGlassNameLabel5);
    	PlayerPanel5.add(PlayerGlassMoneyLabel5);
    	PlayerPanel5.add(PlayerGlassPropertyBoxesLabel5);
        /***********************************************************************/
        	
    	engine = new MKEngine();
    		engine.setLabeltoUpdate(PlayerPropList, PlayerMoneyList);
    	   	engine.setGameBoardUI(this);
    	   	
		//Panel Customizations
		try{westAreaPanel.setBorder(new CentredBackgroundBorder(ImageIO.read(new File("images\\bank\\background.png"))));}catch (IOException e) {        }
		westAreaPanel.setLayout(new BoxLayout(westAreaPanel, BoxLayout.Y_AXIS));
		CombinedPlayersPanel.setLayout(new BoxLayout(CombinedPlayersPanel, BoxLayout.Y_AXIS));
		gameBoard.setBackground(new Color(38,65,95));
		northEdge.setBackground(new Color(38,65,95));
		southEdge.setBackground(new Color(38,65,95));
		westEdge.setBackground(new Color(38,65,95));
		eastEdge.setBackground(new Color(38,65,95));		
				
		//Create MenuBar
		JMenuBar topBar = new JMenuBar();
		
		//Create Menu
		JMenu fileMenu = new JMenu("File");
		
		//Create MenuItem
		JMenuItem quitItem = new JMenuItem("Quit");
		JMenuItem aboutItem1 = new JMenuItem("Developer: Mathew Kurian");
		JMenuItem aboutItem2 = new JMenuItem("Version ID: 987444335A");
		JMenuItem CenterSwitcher1 = new JRadioButtonMenuItem  ("Theme: World");
		JMenuItem CenterSwitcher2 = new JRadioButtonMenuItem  ("Theme: Plain");
		JMenuItem CenterSwitcher3 = new JRadioButtonMenuItem  ("Theme: UK");
		
		CenterSwitcher3.setSelected(true); //AutoChooses UK
		
		ButtonGroup themesGroup = new ButtonGroup();
		themesGroup.add(CenterSwitcher1);	
		themesGroup.add(CenterSwitcher2);
		themesGroup.add(CenterSwitcher3);
		
		//Create MenuItem ActionListener
		quitItem.addActionListener(new QuitListener());
		CenterSwitcher1.addActionListener(new ActionListener() {
                                         
               
            public void actionPerformed(ActionEvent e)
            {
            	center.setIcon(new ImageIcon("images\\boards\\center2.png"));
            	center.validate();
            	center.repaint();
            	gameBoard.repaint();
            }
            
		 }); 
		
		CenterSwitcher2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	center.setIcon(new ImageIcon("images\\boards\\center1.png"));
            	center.validate();
            	center.repaint();
            	gameBoard.repaint();
            }
            
		 });
		 
		 CenterSwitcher3.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e)
            {
            	center.setIcon(new ImageIcon("images\\boards\\center3.png"));
            	center.validate();
            	center.repaint();
            	gameBoard.repaint();
            }
            
		 });
		//MenuItem to Menu
		
	//	fileMenu.add(aboutItem1);
	//	fileMenu.add(aboutItem2);
	//	fileMenu.addSeparator();
		fileMenu.add(CenterSwitcher1);
		fileMenu.addSeparator();		
		fileMenu.add(CenterSwitcher2);
		fileMenu.addSeparator();		
		fileMenu.add(CenterSwitcher3);		
		fileMenu.addSeparator();
		fileMenu.add(quitItem);
		
		//Menu dded to MenuBar
		topBar.add(fileMenu);
	
		//Panel backgrounds
		gameBoard.setBackground (new Color(236,236,236));			
		northEdge.setBackground (new Color(236,236,236));	
		southEdge.setBackground (new Color(236,236,236));	
		eastEdge.setBackground (new Color(236,236,236));
		westEdge.setBackground (new Color(236,236,236));
  		
  		//ArrayLists
  		NorthEdgeArrayList = properties.getEdge("north");
  		EastEdgeArrayList = properties.getEdge("east");
  		WestEdgeArrayList = properties.getEdge("west");
  		SouthEdgeArrayList = properties.getEdge("south");
  		
    	addMouseListener(this);   	    	
        
        //Add MouseListeners and add to panels   
    	for (int x = SouthEdgeArrayList.size()-1; x>=0; x--)
    //	for (int x = 0; x<SouthEdgeArrayList.size(); x++)
    	{
    		SouthEdgeArrayList.get(x).addMouseListener(this);
    		FullBoardArrayList.add((ModJLabel)SouthEdgeArrayList.get(x));
    	}
    	
    	for (int x = 0; x<WestEdgeArrayList.size(); x++)
    	{
    		WestEdgeArrayList.get(x).addMouseListener(this);
    	}
    	    
    	for (int x = WestEdgeArrayList.size()-1; x>=0; x--)
    //  for (int x = 0; x<WestEdgeArrayList.size(); x++)
    	{
    		FullBoardArrayList.add((ModJLabel)WestEdgeArrayList.get(x));
    	}   	
    	
    	for (int x = 0; x<NorthEdgeArrayList.size(); x++)
    	{
    		NorthEdgeArrayList.get(x).addMouseListener(this);
    		FullBoardArrayList.add((ModJLabel)NorthEdgeArrayList.get(x));
    	}
    	
    	for (int x = 0; x<EastEdgeArrayList.size(); x++)
    	{
    		EastEdgeArrayList.get(x).addMouseListener(this);
  //  		eastEdge.add(EastEdgeArrayList.get(x));    	
    	}
    	for (int x = 0; x< EastEdgeArrayList.size(); x++)
    	{
    		FullBoardArrayList.add((ModJLabel)EastEdgeArrayList.get(x));
    	} 		
		
      	FullBoardArrayList.remove(11);
     	FullBoardArrayList.remove(20);
    	FullBoardArrayList.remove(20);
    	FullBoardArrayList.remove(31);
    	
    	for( int y = 0; y<FullBoardArrayList.size(); y++)    {     	System.out.println (FullBoardArrayList.get(y).getName());    	}
    	
   		for( int y = 10; y>=0; y--)     {    	southEdge.add(FullBoardArrayList.get(y));    	}    	
    	for( int y = 20; y>=11; y--)    {    	westEdge.add(FullBoardArrayList.get(y));    	}
    	for( int y = 20; y<31; y++)     {    	northEdge.add(FullBoardArrayList.get(y));    	}
    	for( int y = 31; y<40; y++)     {  		eastEdge.add(FullBoardArrayList.get(y));    	}	
        	
		gameBoard.add(cardPanel);           //////////////////////////////////CARD PANEL ADDED!!!!!!!!!!!!!!!!!!!!!!!
		
	   	//Buttons	          	
        RollButton = new JLabel(new ImageIcon(("images\\button\\ROLL.png")));    	
    	RollButton.addMouseListener(new MouseListener() {
                                                        
        public void mouseClicked(MouseEvent e) {
           	   	
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\ROLL.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\ROLL_click.png")));
  			((JLabel)e.getSource()).repaint();
  				
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\ROLL.png")));
  			((JLabel)e.getSource()).repaint();
  			  			
  					int delay = 0;   
					int period = 50;  
						
               		timer = new Timer();
					timer.scheduleAtFixedRate(new TimerTask() {
						
						public int x = 0;
						
       					public void run() 
       					{   
       						if(x == 15)
       						{
       							try{move((playerList.get((PLAYERNUM)%NUMPLAYERCOUNT)), dice.getRollTotal());}
           	   					catch(ArithmeticException arth){    JOptionPane.showMessageDialog(null,"Arithmetic Error (Source: GameBoardUI.java [rollButton.addActionListener(new ActionListener()])\nChoose Player and Corresponding Icons", "Warning", JOptionPane.WARNING_MESSAGE); 	}
           	   					textArea.setText(textArea.getText() + "\n" + dice.getRollTotal() + " spaces");           	   					
           	   					           	   					
           	   					System.out.println();
           	   					
           	        			timer.cancel();
           	        			
           	        			PLAYERNUM++;//Next Player
       						}
       						else
       						{       						  						
            					westAreaPanel.remove(dicePanel);
               					dicePanel = (JPanel) dice.RollWithValue();
               					westAreaPanel.add(dicePanel);
               					westAreaPanel.validate();
               					westAreaPanel.repaint();
               					x++;
       						}
        				}
    				}, delay, period);    
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\ROLL_over.png")));
  			((JLabel)e.getSource()).repaint();
       	}
        }); 
        	
        	
        JLabel bankButton = new JLabel(new ImageIcon("images\\button\\STATS.png"));
    	
    	bankButton.addMouseListener(new MouseListener() {                                         
               
        public void mouseClicked(MouseEvent e) {
  			   
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\STATS.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\STATS_click.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\STATS.png")));
  			((JLabel)e.getSource()).repaint();
  			
  			gameBoardHolder.setSelectedIndex(1);
  			  			
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\STATS_over.png")));
  			((JLabel)e.getSource()).repaint();
       	}
        }); 	
        	
		//Pieces attached
		gameBoard.add(northEdge, BorderLayout.NORTH);
		gameBoard.add(southEdge, BorderLayout.SOUTH);
		gameBoard.add(eastEdge, BorderLayout.EAST);
		gameBoard.add(westEdge, BorderLayout.WEST);
		
		//TextArea
		textArea = new JTextArea(10, 10);
		textArea.setEditable(false);
		textArea.setLineWrap(true);
		textArea.setOpaque(false);
		textArea.setFont(new Font("MV Boli", Font.BOLD, 14));
		
		//ScrollPane and add background
		JScrollPane textScroll = new JScrollPane(textArea);
		textScroll.getViewport().setOpaque(false);
	//	try{textScroll.setViewportBorder(new InsetBackground(ImageIO.read(new File("images\\paper\\paper_edited.png"))));}catch (IOException e) {        }
					
		//Die Panel
		dicePanel = (JPanel)dice.getDefault();
		
		textScroll.setOpaque(false);
    	dicePanel.setOpaque(false);
    	    	
    	
    	//Title
    	JLabel titleLabel = new JLabel (new ImageIcon("images\\title\\title.png"));
    	
    	//AlignmentX
    	titleLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
    	RollButton.setAlignmentX(Component.CENTER_ALIGNMENT);
    	bankButton.setAlignmentX(Component.CENTER_ALIGNMENT);
    	    	
		//Full Panel Assembly
		westAreaPanel.add(titleLabel);
		westAreaPanel.add(CombinedPlayersPanel);
		westAreaPanel.add(textScroll);
		westAreaPanel.add(RollButton);
		westAreaPanel.add(bankButton);	
		westAreaPanel.add(dicePanel);
		combinedPanel = new TransparentBackgroundStandStill(frameBoard);
		combinedPanel.setLayout(new BorderLayout(6, 6));
	//	combinedPanel.add(topBar, BorderLayout.NORTH);
		gameBoardHolder.addTab("Game Screen", gameBoard);
		gameBoardHolder.addTab("Statistics", bank.getGUI());
		combinedPanel.add(gameBoardHolder, BorderLayout.CENTER);
	  	combinedPanel.add(westAreaPanel, BorderLayout.EAST);
	  	readPlayerNamesUIFile();
	  		  	
	  	westAreaPanel.setOpaque(false);
	  	combinedPanel.setOpaque(false);
	  	westEdge.setOpaque(false);
	  	eastEdge.setOpaque(false);
	  	northEdge.setOpaque(false);
	  	southEdge.setOpaque(false);
	    gameBoard.setOpaque(false);	  	
	  	gameBoardHolder.setOpaque(false);
	  	
	  	westAreaPanel.setBorder(null);
	  	combinedPanel.setBorder(null);
	  	westEdge.setBorder(null);
	  	eastEdge.setBorder(null);
	  	northEdge.setBorder(null);
	  	southEdge.setBorder(null);
	    gameBoard.setBorder(null);	
	  	gameBoardHolder.setBorder(null);
	  	
	  	for (int x = 0;x< playerList.size();x++) 	{  		this.startLocation(playerList.get(x));
	  														playerList.get(x).setNum(x);
	  														SetUpPlayerPanel();  														
	  										  	  	}
	  	
	  	copyPlayerIconLabel1 = new JLabel(PlayerIconLabel1.getIcon() );
	  	copyPlayerIconLabel2 = new JLabel(PlayerIconLabel2.getIcon() );
	  	copyPlayerIconLabel3 = new JLabel(PlayerIconLabel3.getIcon() );
	  	copyPlayerIconLabel4 = new JLabel(PlayerIconLabel4.getIcon() );
	  	copyPlayerIconLabel5 = new JLabel(PlayerIconLabel5.getIcon() );
	  	
	  	copyPlayerGlassNameLabel1 = new JLabel(PlayerGlassNameLabel1.getText() );
	  	copyPlayerGlassNameLabel2 = new JLabel(PlayerGlassNameLabel2.getText() );
	  	copyPlayerGlassNameLabel3 = new JLabel(PlayerGlassNameLabel3.getText() );
	  	copyPlayerGlassNameLabel4 = new JLabel(PlayerGlassNameLabel4.getText() );
	  	copyPlayerGlassNameLabel5 = new JLabel(PlayerGlassNameLabel5.getText() );
	  	
	  	copyPlayerGlassNameLabel1.setFont(new Font("Liberation Sans", Font.BOLD, 15));
    	copyPlayerGlassNameLabel1.setForeground(new Color(147, 207, 218));
    	
    	copyPlayerGlassNameLabel2.setFont(new Font("Liberation Sans", Font.BOLD, 15));
    	copyPlayerGlassNameLabel2.setForeground(new Color(147, 207, 218));
    	
    	copyPlayerGlassNameLabel3.setFont(new Font("Liberation Sans", Font.BOLD, 15));
    	copyPlayerGlassNameLabel3.setForeground(new Color(147, 207, 218));
    	
    	copyPlayerGlassNameLabel4.setFont(new Font("Liberation Sans", Font.BOLD, 15));
    	copyPlayerGlassNameLabel4.setForeground(new Color(147, 207, 218));
    			
    	copyPlayerGlassNameLabel5.setFont(new Font("Liberation Sans", Font.BOLD, 15));
    	copyPlayerGlassNameLabel5.setForeground(new Color(147, 207, 218));
    			
	  	copyPlayerIconList[0] = copyPlayerIconLabel1;
	  	copyPlayerIconList[1] = copyPlayerIconLabel2;
	  	copyPlayerIconList[2] = copyPlayerIconLabel3;
	  	copyPlayerIconList[3] = copyPlayerIconLabel4;
	  	copyPlayerIconList[4] = copyPlayerIconLabel5;
	  		  	 
    	copyPlayerNameList[0] = copyPlayerGlassNameLabel1;
    	copyPlayerNameList[1] = copyPlayerGlassNameLabel2;
    	copyPlayerNameList[2] = copyPlayerGlassNameLabel3;
    	copyPlayerNameList[3] = copyPlayerGlassNameLabel4;
    	copyPlayerNameList[4] = copyPlayerGlassNameLabel5;
    	
    							   
	  	bank.updatePlayers(NUMPLAYERCOUNT, copyPlayerIconList, copyPlayerNameList);
	  	
    }
    	public void createAndShowGUI()
    	{
    	
    	frameBoard.setContentPane(combinedPanel); // p from above, panel containing game board and text area
    	frameBoard.setResizable(false);
    	frameBoard.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
    	frameBoard.setUndecorated(true);
    	frameBoard.pack();
		frameBoard.setLocationRelativeTo(null);
		frameBoard.setVisible(true);
    	}
   		public void mouseClicked(MouseEvent e) {
  			String name = ((ModJLabel)e.getSource()).getName();
			textArea.setText(name);  			
        }
        public void mouseExited(MouseEvent e) {
        	String name = ((JLabel)e.getSource()).getName();
			textArea.setText(name);
        }
        public void mousePressed(MouseEvent e) {
            String name =((JLabel)e.getSource()).getName(); 		
  			  			
  			PopUpDeedFrame = new JFrame(name);
  			
  			TransparentBackground PopUpPanelMain = new TransparentBackground(PopUpDeedFrame);    	
    		
    		PopUpPanelMain.setLayout(new BorderLayout());
    		  			
  			JLabel DeedLabel = ((JLabel) boxProp.getLabel(name));
  			
  			JLabel CloseLabel = new JLabel(new ImageIcon(("images\\button\\CLOSE.png")));
    		CloseLabel.addMouseListener(new MouseListener() {
                
        	public void mouseClicked(MouseEvent e) {
  				PopUpDeedFrame.setVisible(false);
  				frameBoard.setEnabled(true);
  	      	}        
        	public void mouseExited(MouseEvent e) {
           		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CLOSE.png")));
  				((JLabel)e.getSource()).repaint();
        	}
        	public void mousePressed(MouseEvent e) {        
  				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CLOSE_click.png")));
  				((JLabel)e.getSource()).repaint();
        	}
        	public void mouseReleased(MouseEvent e) {
           		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CLOSE.png")));
  				((JLabel)e.getSource()).repaint();
        	}
        	public void mouseEntered(MouseEvent e) {
       			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CLOSE_over.png")));
  				((JLabel)e.getSource()).repaint();  			
       		}
        	}); 
  							
			PopUpPanelMain.add(DeedLabel, BorderLayout.PAGE_START);
			PopUpPanelMain.add(CloseLabel, BorderLayout.CENTER);
			PopUpDeedFrame.add(PopUpPanelMain);
			
			PopUpDeedFrame.setUndecorated(true);
			PopUpDeedFrame.pack();
			PopUpDeedFrame.setAlwaysOnTop(true);						
			PopUpDeedFrame.setLocationRelativeTo(null);
			PopUpDeedFrame.setVisible(true);
			frameBoard.setEnabled(false);			
  		
        }
        public void mouseReleased(MouseEvent e) {
        	String name =((JLabel)e.getSource()).getName();
			textArea.setText(name);
        }
        public void mouseEntered(MouseEvent e) {
       		String name =((ModJLabel)e.getSource()).getName();
       		textArea.setText(name);
//       		(JLabel) boxProp.getLabel(name);
       }
     public void move(Player p, int numSpaces)
		{
			
			originalLocation = p.getCellIndex();			
			newLocation = (originalLocation + numSpaces)%40;	
						
			temp1 = new Integer(originalLocation);
			
			tempLocation = playerList.indexOf(p);	
			
			int MotionDelay = 0;
			int MotionPeriod = 500;
						
			motionTimer = new Timer();  //FORWARD MOTION ONLY
					motionTimer.scheduleAtFixedRate(new TimerTask() {
												
       					public void run() 
       					{
       						       								
							if(originalLocation<newLocation)
							{		
								
									((ModJLabel)FullBoardArrayList.get(temp1)).removeGamePiece(playerList.get(tempLocation));
									((ModJLabel)FullBoardArrayList.get(temp1)).repaint();
																		
									temp1++;
									
									((ModJLabel)FullBoardArrayList.get(temp1)).addGamePiece(playerList.get(tempLocation));
									((ModJLabel)FullBoardArrayList.get(temp1)).repaint();
																		
														
       						}
       						if(originalLocation>newLocation)
       						{		
										((ModJLabel)FullBoardArrayList.get(temp1)).removeGamePiece(playerList.get(tempLocation));
										((ModJLabel)FullBoardArrayList.get(temp1)).repaint();
																		
										temp1++;
										
											if(temp1==40)
											{
												temp1=0;
												engine.plainAdd(playerList.get(tempLocation), 2000);
												bank.addHistory(playerList.get(tempLocation).getNum(), "Passed GO. Added 2000 to account.");
											}
									
										((ModJLabel)FullBoardArrayList.get(temp1)).addGamePiece(playerList.get(tempLocation));
										((ModJLabel)FullBoardArrayList.get(temp1)).repaint();
																
       						}
       						if(temp1==newLocation)
       						{
       							((ModJLabel)FullBoardArrayList.get(temp1)).removeGamePiece(playerList.get(tempLocation));
								((ModJLabel)FullBoardArrayList.get(temp1)).repaint();
									
       							((ModJLabel)FullBoardArrayList.get(newLocation)).addGamePiece(playerList.get(tempLocation));		
								((ModJLabel)FullBoardArrayList.get(newLocation)).repaint();
								motionTimer.cancel();
       						}
       						click = new AePlayWave("file:audio\\pieceMotion.wav");
       						click.runOnce();
       					}
					}, MotionDelay, MotionPeriod); 
			
			try{Thread.sleep((numSpaces+2)*MotionPeriod);}catch(InterruptedException ietc){			}
			
			p.setCellIndex(newLocation);
			
			bank.addHistory(p.getNum(), "Advanced from " +((ModJLabel)FullBoardArrayList.get(originalLocation)).getName() + " at " + originalLocation
										+ " to " + ((ModJLabel)FullBoardArrayList.get(newLocation)).getName() + " at " + newLocation + ", Die roll of " + numSpaces + ".");
						
			
			if((newLocation==2)||(newLocation  ==17)||(newLocation==33))
			{
				flickerCommChest((playerList.get((PLAYERNUM)%NUMPLAYERCOUNT)));
			}
			else if((newLocation==7)||(newLocation==22)||(newLocation==36))
			{
				flickerChance((playerList.get((PLAYERNUM)%NUMPLAYERCOUNT)));
			}
			else
			{
				popup.provokeCorrectCompiler(p, (((ModJLabel)FullBoardArrayList.get(newLocation)).getName()), newLocation, frameBoard,  (PLAYERNUM)%NUMPLAYERCOUNT );			
			}		
		}
		public void movePlain(Player p, int numSpaces)
		{
			originalLocation = p.getCellIndex();
			
			newLocation = (originalLocation + numSpaces)%40;		

			((ModJLabel)FullBoardArrayList.get(originalLocation)).removeGamePiece(p);
			((ModJLabel)FullBoardArrayList.get(originalLocation)).repaint();
			
       		((ModJLabel)FullBoardArrayList.get(newLocation)).addGamePiece(p);		
			((ModJLabel)FullBoardArrayList.get(newLocation)).repaint();
			
			p.setCellIndex(newLocation);
			
			click = new AePlayWave("file:audio\\pieceMotion.wav");
       						click.runOnce();
       						
			bank.addHistory(p.getNum(), "Advanced from " +((ModJLabel)FullBoardArrayList.get(originalLocation)).getName() + " at " + originalLocation
										+ " to " + ((ModJLabel)FullBoardArrayList.get(newLocation)).getName() + " at " + newLocation + ", Die roll of " + numSpaces + ".");					
		}
	  public void startLocation(Player p)
		{	
			originalLocation = p.getCellIndex();
			
       		((ModJLabel)FullBoardArrayList.get(originalLocation)).addGamePiece(p);		
			((ModJLabel)FullBoardArrayList.get(originalLocation)).repaint();		
			
		}
		public void readPlayerNamesUIFile()
	    {
	    	int commaTemp;
	    	int stringLength;
	    	String playerName;
	    	String playerIcon;
	    	String fullLine;
    	try{
    			kb = new Scanner (new File("PlayerNamesUI.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: GameBoardUI.java [readPlayerNamesUIFile()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}	
    	while (kb.hasNext())
            {
                fullLine = kb.nextLine();
                stringLength = fullLine.length();
                commaTemp = fullLine.indexOf(",");
				playerName = fullLine.substring(0,commaTemp);			
				playerIcon = fullLine.substring(commaTemp+1,stringLength);
                playerList.add(new Player(playerName, playerIcon));                        
            }
                    
        	kb.close();
        
        	NUMPLAYERCOUNT = playerList.size();
        	popup = new PopUpUI(playerList, boxProp, engine, bank, this);
          	cardsL.setPopUpAndImages(popup, chanceNormal, chanceYellow, CommChestNormal, CommChestYellow);
             		
        	/**********************/
        	PlayerPanel1.setOpaque(false);
        	PlayerPanel2.setOpaque(false);
        	PlayerPanel3.setOpaque(false);
        	PlayerPanel4.setOpaque(false);
        	PlayerPanel5.setOpaque(false);
        	CombinedPlayersPanel.setOpaque(false);
        	/**********************/
        	        	
        	switch (NUMPLAYERCOUNT) {
           	
            case 1:  PlayerIconLabel1.setIcon(playerList.get(0).getGamePiece().getImageIcon());
            	CombinedPlayersPanel.add(PlayerPanel1); 
            	        break;
            case 2:  PlayerIconLabel1.setIcon(playerList.get(0).getGamePiece().getImageIcon());
            		 PlayerIconLabel2.setIcon(playerList.get(1).getGamePiece().getImageIcon());
            		 CombinedPlayersPanel.add(PlayerPanel1);
            		 CombinedPlayersPanel.add(PlayerPanel2);
            		 PlayerPanelList.add(PlayerPanel1);
            		 PlayerPanelList.add(PlayerPanel2);
            		 	break;
            case 3:  PlayerIconLabel1.setIcon(playerList.get(0).getGamePiece().getImageIcon());
            		 PlayerIconLabel2.setIcon(playerList.get(1).getGamePiece().getImageIcon());
            		 PlayerIconLabel3.setIcon(playerList.get(2).getGamePiece().getImageIcon());
            		 CombinedPlayersPanel.add(PlayerPanel1);
            		 CombinedPlayersPanel.add(PlayerPanel2);
            		 CombinedPlayersPanel.add(PlayerPanel3);
            		 PlayerPanelList.add(PlayerPanel3);
            		 PlayerPanelList.add(PlayerPanel4);
            		 PlayerPanelList.add(PlayerPanel5);
            		 	break;
            case 4:  PlayerIconLabel1.setIcon(playerList.get(0).getGamePiece().getImageIcon());
            		 PlayerIconLabel2.setIcon(playerList.get(1).getGamePiece().getImageIcon());
            		 PlayerIconLabel3.setIcon(playerList.get(2).getGamePiece().getImageIcon());
            		 PlayerIconLabel4.setIcon(playerList.get(3).getGamePiece().getImageIcon());
            		 CombinedPlayersPanel.add(PlayerPanel1);
            		 CombinedPlayersPanel.add(PlayerPanel2);
            		 CombinedPlayersPanel.add(PlayerPanel3);
            		 CombinedPlayersPanel.add(PlayerPanel4);
            		 PlayerPanelList.add(PlayerPanel2);
            		 PlayerPanelList.add(PlayerPanel3);
            		 PlayerPanelList.add(PlayerPanel4);
            		 PlayerPanelList.add(PlayerPanel5); 
            		 	break;
            case 5:  PlayerIconLabel1.setIcon(playerList.get(0).getGamePiece().getImageIcon());
            		 PlayerIconLabel2.setIcon(playerList.get(1).getGamePiece().getImageIcon());
            		 PlayerIconLabel3.setIcon(playerList.get(2).getGamePiece().getImageIcon());
            		 PlayerIconLabel4.setIcon(playerList.get(3).getGamePiece().getImageIcon());
            		 PlayerIconLabel5.setIcon(playerList.get(4).getGamePiece().getImageIcon());
            		 CombinedPlayersPanel.add(PlayerPanel1);
            		 CombinedPlayersPanel.add(PlayerPanel2);
            		 CombinedPlayersPanel.add(PlayerPanel3);
            		 CombinedPlayersPanel.add(PlayerPanel4);
            		 CombinedPlayersPanel.add(PlayerPanel5);
            		 PlayerPanelList.add(PlayerPanel1);
            		 PlayerPanelList.add(PlayerPanel2);
            		 PlayerPanelList.add(PlayerPanel3);
            		 PlayerPanelList.add(PlayerPanel4);
            		 PlayerPanelList.add(PlayerPanel5);
            		 	break;
        	}
        	
        	CombinedPlayersPanel.validate();
        	CombinedPlayersPanel.repaint();
        	
        	engine.setPlayerList(playerList);        	
        		
    	}
    	
    	public void SetUpPlayerPanel()
    	{
    		//ADD PROPERTY LIST INFO AS WELL
    		//EXTEND JLABEL AGAIN FOR PROPERTIES
    		
    		JLabel tempName; //TEMP POINTERS
    		JLabel tempMoney; //TEMP POINTERS
    		    			
    		for (int x = 0;x< playerList.size();x++) 	
    		{  	
    			      
            	PlayerNameList[x].setText(playerList.get(x).getName());
    			PlayerNameList[x].setHorizontalTextPosition(JLabel.CENTER);
    			PlayerNameList[x].setFont(new Font("Liberation Sans", Font.BOLD, 15));
    			PlayerNameList[x].setForeground(Color.WHITE);
    			PlayerNameList[x].validate();
    			PlayerNameList[x].repaint();
    		 
           		try{PlayerMoneyList[x].setText(Integer.toString(playerList.get(x).getAccount()));     		}
    			catch(ArithmeticException arth2){    JOptionPane.showMessageDialog(null,"Arithmetic Error (Source: GameBoardUI.java [setMoney()])\nChoose Player and Corresponding Icons", "Warning", JOptionPane.WARNING_MESSAGE); 	}
    			PlayerMoneyList[x].setHorizontalTextPosition(JLabel.CENTER);
    			PlayerMoneyList[x].setFont(new Font("KabaleMedium", Font.PLAIN, 14));
    			PlayerMoneyList[x].setForeground(new Color(119, 182, 101));
    			PlayerMoneyList[x].validate();
    			PlayerMoneyList[x].repaint();
    			    			
        	}
    	}    	
    	public void flickerCommChest(Player p)
    	{    		    		
  			int COMDelay= 0;   
			int COMPeriod = 300;  
			int two = 2;
			
			cardsL.setEnabled(two);
			cardsL.setCurrentPlayer(p);	
			
			cardFlicker = new AePlayWave("file:audio\\cardFlicker.wav");
			cardFlicker.runOnce();
							
               		COMTimer = new Timer();
					COMTimer.scheduleAtFixedRate(new TimerTask() {
						
						boolean COMstateChange = true; //true means blue
						int COMcount = 0;
       					
       					public void run() 
       					{         					
       						if(COMcount<8)
       						{       						
       							if(COMstateChange)
       							{
       								CommChest.setIcon(CommChestYellow);
       								CommChest.repaint();
       								COMstateChange = false;       							
       								COMcount++;     							
       							
       							}
       							else
       							{
       								CommChest.setIcon(CommChestNormal);
       								CommChest.repaint();
       								COMstateChange = true;
       								COMcount++;
       							}
       						
       						}		
       						else
       						{ 
       							COMTimer.cancel();	
       						}
        				}
        				
    		}, COMDelay, COMPeriod);    
    	}   
    		public void flickerChance(Player p)
    	{    		    		
  			int CHANCEDelay = 0;   
			int CHANCEPeriod = 300;  
				
			int one = 1;
				
			cardsL.setEnabled(one);
			cardsL.setCurrentPlayer(p);	
			
			cardFlicker = new AePlayWave("file:audio\\cardFlicker.wav");
			cardFlicker.runOnce();
				
               		CHANCETimer = new Timer();
					CHANCETimer.scheduleAtFixedRate(new TimerTask() {
						
						boolean CHANCEstateChange = true; //true means blue
						int CHANCEcount = 0;
       					
       					public void run() 
       					{  
       						if(CHANCEcount<8)
       						{       						
       							if(CHANCEstateChange)
       							{
       								Chance.setIcon(chanceYellow);
       								Chance.repaint();
       								CHANCEstateChange = false;       							
       								CHANCEcount++;
       							
       								//	System.out.println(stateChange + "" + count);
       							}
       							else
       							{
       								Chance.setIcon(chanceNormal);
       								Chance.repaint();
       								CHANCEstateChange = true;
       								CHANCEcount++;
       							}
       						
       						}		
       						else
       						{     
       							CHANCETimer.cancel();	
       						}
        				}
        				
    		}, CHANCEDelay, CHANCEPeriod);    
    	}  
    	public void moveStarTo(int a)
    	{    		
    		for(int x =0; x<PlayerPanelList.size(); x++)
    		{
    			(PlayerPanelList.get(x)).remove(StarOnCurrentPlayer);
    			(PlayerPanelList.get(x)).repaint();
    		} 
    			   		
    		(PlayerPanelList.get(a)).add(StarOnCurrentPlayer);
    		(PlayerPanelList.get(a)).repaint();
    	} 
    	

    
}