/**
 * @(#)PopUpUI.java
 *
 *
 * @author 
 * @version 1.00 2010/2/25
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
import java.awt.geom.RoundRectangle2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;
import java.awt.Graphics2D;

//import com.sun.awt.AWTUtilities;

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

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;
import java.util.Scanner;
import java.lang.Integer;

public class PopUpUI{
	
	public BoxPoperties PopUpProps;
	
	public ImageIcon BUY = new ImageIcon("images\\button\\BUY.png");
    public ImageIcon PASS = new ImageIcon("images\\button\\PASS.png");
    public ImageIcon CLOSE = new ImageIcon("images\\button\\CLOSE.png");
    
    public ImageIcon BUYover = new ImageIcon("images\\button\\BUY_over.png");
    public ImageIcon PASSover = new ImageIcon("images\\button\\PASS_over.png");
    public ImageIcon CLOSEover = new ImageIcon("images\\button\\CLOSE_over.png");
    
    public ImageIcon BUYclick = new ImageIcon("images\\button\\BUY_click.png");
    public ImageIcon PASSclick = new ImageIcon("images\\button\\PASS_click.png");
	public ImageIcon CLOSEclick = new ImageIcon("images\\button\\CLOSE_click.png");
    
    public JLabel BuyLabel = new JLabel(BUY);
   	public JLabel PassLabel = new JLabel(PASS);
   	public JLabel CloseLabel = new JLabel(CLOSE);
    public JLabel ExitLabel = new JLabel(CLOSE);
    public JLabel HideLabel = new JLabel(CLOSE);
    
	public JFrame PopFrameWithChoices = new JFrame ("Choices");
	public JFrame PopFrameWithoutChoices = new JFrame ("Choices");
	public JFrame PopFrameBought = new JFrame ("Choices");
	public JFrame PopFrameCard = new JFrame ("Choices");	
	public JFrame frameBoard;
	
   	public JLabel currentPopImageWithChoice = new JLabel(PASS);     
    public JLabel currentPopImageWithoutChoice = new JLabel(PASS);
    public JLabel currentPopImageBought = new JLabel(PASS);
    public JLabel currentPopImageCard = new JLabel(PASS);
    
    public JLabel PlayerGlassMoneyLabel = null;
    public JLabel UniversalBackgroundClear = new JLabel(new ImageIcon("images\\popup\\pop_back_clear.png"));
        	
	public TransparentBackground PopPanelMainWithChoices = new TransparentBackground(PopFrameWithChoices);
	public TransparentBackground PopPanelMainWithoutChoices = new TransparentBackground(PopFrameWithoutChoices);
	public TransparentBackground PopPanelMainBought = new TransparentBackground(PopFrameBought);
	public TransparentBackground PopPanelMainCard = new TransparentBackground(PopFrameCard);
	
	public Player currentPlayer;
		
    public PlayerTurnInfoUI playerCountFrame =null;
    	  
    public int currentPLAYERNUM = 0;
    public int currentPosition;
    
    public JLabel [] currentPlayerMoneyList = null;    
    
    public Timer timer;
    
    public String tempAmount;
    public String PieceName;
    
    public PropJLabel [] currentPlayerPropList = null;
    
    public ArrayList <Player> playerList = null;
    
    public ArrayList <JLabel> chanceList = null;
    public ArrayList <JLabel> commList = null;
    
    public int startAmount = 0;
    public int endAmount = 0;
    
    public int rand = 3145;
        
    public MKEngine currentEngine;
    
    public BankUI bank;
    
    public ChanceCards chanceCard = new ChanceCards();
    public CommChestCards commCard = new CommChestCards();
    
    public GameBoardUI gameUI;
    	
    public PopUpUI(ArrayList<Player> a, BoxPoperties b, MKEngine e, BankUI asd, GameBoardUI g) 
    {        	
    	   PopUpProps = b;
    	   PopUpProps.fillArraysDeeds();
    	   PopUpProps.fillArraysExtras();
    	   
    	   gameUI = g;
    	     	   
    	   playerCountFrame = new PlayerTurnInfoUI(a);
    	   playerList =a;
    	   currentEngine = e;
    	   bank = asd;
    
    	   setUP();
    	   
    	   chanceList = chanceCard.getCardList();
    	   commList = commCard.getCardList();
    	
    	   bank.setDeedImages(PopUpProps);
    	   	
    }
    public void setUP()
    {
    	/**********************************************************WITH CHOICES*/   
    	PopPanelMainWithChoices.setLayout(new BorderLayout()); 
    	    	
    	BuyLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  							
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(BUY);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(BUYclick);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
           	((JLabel)e.getSource()).setIcon(BUY);
  			((JLabel)e.getSource()).repaint();
 			
 			PopFrameWithChoices.hide();
  			bank.addHistory(currentPLAYERNUM, "Bought " + PieceName + " for " + currentEngine.getPrice(currentPosition) + " dollars.");
  			
  			bank.resizeImageAndAdd(currentPopImageWithChoice.getIcon(), currentPLAYERNUM, currentPopImageWithChoice.getName());
  						
  		  	currentEngine.findAndBehave(currentPlayer, currentPosition, currentPLAYERNUM);
  		//	playerCountFrame.actionPlayers();
  			
  		    gameUI.moveStarTo(((gameUI.PLAYERNUM))%(gameUI.NUMPLAYERCOUNT));
  			
  			frameBoard.setEnabled(true);  
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(BUYover);
  			((JLabel)e.getSource()).repaint();
       	}
        }); 
        	
    	PassLabel.addMouseListener(new MouseListener() {
               
        public void mouseClicked(MouseEvent e) {
  						
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(PASS);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(PASSclick);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(PASS);
  			((JLabel)e.getSource()).repaint();
  			
  			gameUI.moveStarTo(((gameUI.PLAYERNUM))%(gameUI.NUMPLAYERCOUNT));
  			PopFrameWithChoices.hide();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(PASSover);
  			((JLabel)e.getSource()).repaint();
       	}
        });
        
        PopPanelMainWithChoices.add(currentPopImageWithChoice, BorderLayout.PAGE_START);
    	PopPanelMainWithChoices.add(BuyLabel,BorderLayout.LINE_START);
    	PopPanelMainWithChoices.add(PassLabel, BorderLayout.LINE_END);
        	
    	PopFrameWithChoices.getContentPane().add(PopPanelMainWithChoices); 
    	PopFrameWithChoices.setAlwaysOnTop(true);
    	PopFrameWithChoices.setUndecorated(true);   
    	PopFrameWithChoices.pack();
		PopFrameWithChoices.setLocationRelativeTo(null);		
		/**********************************************************WITH CHOICES*/
		
		/**********************************************************WITHOUT CHOICES*/
		PopPanelMainWithoutChoices.setLayout(new BorderLayout());
     	     	    	    	
    	CloseLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {  						
			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(CLOSEclick);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
  			
  			PopFrameWithoutChoices.hide();
  		//	playerCountFrame.actionPlayers();
  			frameBoard.setEnabled(true);
			gameUI.moveStarTo(((gameUI.PLAYERNUM))%(gameUI.NUMPLAYERCOUNT));
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(CLOSEover);
  			((JLabel)e.getSource()).repaint();
       	}
        }); 
        	    	    	
    	PopPanelMainWithoutChoices.add(currentPopImageWithoutChoice, BorderLayout.PAGE_START);
    	PopPanelMainWithoutChoices.add(CloseLabel,BorderLayout.CENTER);   	
    	
    	PopFrameWithoutChoices.getContentPane().add(PopPanelMainWithoutChoices); 
    	PopFrameWithoutChoices.setAlwaysOnTop(true);
    	PopFrameWithoutChoices.setUndecorated(true);   
    	PopFrameWithoutChoices.pack();    	
		PopFrameWithoutChoices.setLocationRelativeTo(null);	
		/**********************************************************WITHOUT CHOICES*/
		
    	/**********************************************************BOUGHT**********/
    	PopPanelMainBought.setLayout(new BorderLayout());
     	     	    	    	
    	HideLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {  						
			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(CLOSEclick);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
  			
  			PopFrameBought.hide();
  			currentEngine.findAndBehave(currentPlayer, currentPosition, currentPLAYERNUM);
  			  			
  			frameBoard.setEnabled(true);
  			gameUI.moveStarTo(((gameUI.PLAYERNUM))%(gameUI.NUMPLAYERCOUNT));
			
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(CLOSEover);
  			((JLabel)e.getSource()).repaint();
       	}
        }); 
        	    	    	
    	PopPanelMainBought.add(currentPopImageBought, BorderLayout.PAGE_START);
    	PopPanelMainBought.add(HideLabel,BorderLayout.CENTER);   	
    	
    	PopFrameBought.getContentPane().add(PopPanelMainBought); 
    	PopFrameBought.setAlwaysOnTop(true);
    	PopFrameBought.setUndecorated(true);   
    	PopFrameBought.pack();    	
		PopFrameBought.setLocationRelativeTo(null);
		/**********************************************************BOUGHT**********/
		
		/**********************************************************CARDS**********/
    	PopPanelMainCard.setLayout(new BorderLayout());
     	     	    	    	
    	ExitLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {  						
			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(CLOSEclick);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(CLOSE);
  			((JLabel)e.getSource()).repaint();
  			
  			PopFrameCard.hide();  			  			
  		//	frameBoard.setEnabled(true);      ////////////ADD THIS LATER
  			gameUI.moveStarTo(((gameUI.PLAYERNUM))%(gameUI.NUMPLAYERCOUNT));
			
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(CLOSEover);
  			((JLabel)e.getSource()).repaint();
       	}
        }); 
        	    	    	
    	PopPanelMainCard.add(currentPopImageCard, BorderLayout.PAGE_START);
    	PopPanelMainCard.add(ExitLabel,BorderLayout.CENTER);   	
    	
    	PopFrameCard.getContentPane().add(PopPanelMainCard); 
    	PopFrameCard.setAlwaysOnTop(true);
    	PopFrameCard.setUndecorated(true);   
    	PopFrameCard.pack();    	
		PopFrameCard.setLocationRelativeTo(null);
		/**********************************************************CARDS**********/	
    }
    public void provokeCorrectCompiler(Player p, String s, int positionNum, JFrame fullBoard,int PLAYERNUMdividedByNUMCOUNT)
    {    	    	
    	currentPlayer = p;
    	currentPosition = positionNum;
    	currentPLAYERNUM = PLAYERNUMdividedByNUMCOUNT;    	
    	PieceName = s;
    	frameBoard= fullBoard;    	
    	frameBoard.setEnabled(true); 	
        	    	    	
    	if(currentPosition == 4)	 {    		panelCompilerWithoutChoice();    				}
    //	else if(currentPosition == 2){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 5){  		panelCompilerWithoutChoice();    				}
    //	else if(currentPosition == 7){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 10){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 12){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 15){    		panelCompilerWithoutChoice();    				}
    //	else if(currentPosition == 17){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 20){    		panelCompilerWithoutChoice();    				}
    //	else if(currentPosition == 22){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 25){  		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 28){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 30){    		panelCompilerWithoutChoice();    				}
    //	else if(currentPosition == 33){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 35){    		panelCompilerWithoutChoice();  				  	}
    //	else if(currentPosition == 36){    		panelCompilerWithoutChoice();    				}
    	else if(currentPosition == 38){    		currentEngine.plainSub(currentPlayer, 7500);
    											bank.addHistory(currentPlayer.getNum(), "Landed on Luxury Tax: $7500 subtracted");     				}    			
    	else if(currentPosition == 0) {
    											currentEngine.plainAdd(currentPlayer, 2000);
    											bank.addHistory(currentPlayer.getNum(), "Landed on Go: $2000 added");    	
    								  }
    	else						  {    		panelCompilerWithChoice();    					}  	
    }  
    public void panelCompilerWithChoice()
   {    	
    	try
    	{
    		currentEngine.getPropertiesBought().get(currentPosition).get(0);    			
    		panelCompilerBoughtChoice(); 
    	}
    	catch(IndexOutOfBoundsException ieb)
    	{     	
    		System.out.println("Choice A");
    		
    		currentPopImageWithChoice.setIcon(((JLabel) PopUpProps.getLabel(PieceName)).getIcon());
    		currentPopImageWithChoice.setName(PieceName);
    		currentPopImageWithChoice.repaint();
    	
    		PopFrameWithChoices.pack(); 
    		PopFrameWithChoices.setLocationRelativeTo(null);
  			PopFrameWithChoices.show();				  
    	}    				    
   }
    public void panelCompilerWithoutChoice()
    {
    	System.out.println("Choice C");
    	currentPopImageWithoutChoice.setIcon(((JLabel) PopUpProps.getLabel(PieceName)).getIcon());
    	currentPopImageWithoutChoice.repaint();
    	
    	PopFrameWithoutChoices.pack(); 
    	PopFrameWithoutChoices.setLocationRelativeTo(null);	
  		PopFrameWithoutChoices.show();
  	}
    public void panelCompilerBoughtChoice()
    {
    	System.out.println("Choice B");	
    	currentPopImageBought.setIcon(((JLabel) PopUpProps.getLabel(PieceName)).getIcon());
    	currentPopImageBought.setName(PieceName);
    	currentPopImageBought.repaint();
    	
    	bank.addHistory(currentPLAYERNUM, "Pays for " + PieceName + " of " + currentEngine.getPropertiesBought().get(currentPosition).get(0).getName());
    	bank.addHistory(currentEngine.getPropertiesBought().get(currentPosition).get(0).getNum(), currentPlayer.getName() + " gets rent from " + PieceName + " by " + currentPlayer.getName());
    	
    	PopFrameBought.pack(); 
    	PopFrameBought.setLocationRelativeTo(null);
  		PopFrameBought.show();			
    }
     public void showChanceCard(Player p)
    {
    	currentPlayer = p;
    	
    	System.out.println("Choice E");	
    	
    	rand = (int) (Math.random() * 14);
    	
    	currentPopImageCard.setIcon(chanceList.get(rand).getIcon());
    	currentPopImageCard.setName(chanceList.get(rand).getName());
    	currentPopImageCard.repaint();
    	
    	currentEngine.chanceCardsAction(currentPlayer, currentPopImageCard.getName());
    	    	
    	bank.addHistory(currentPLAYERNUM, "Picks up a " + PieceName + " card");
    	bank.addHistory(currentPLAYERNUM, "Chance Card reads: " + currentPopImageCard.getName());
    	
    	PopFrameCard.pack(); 
    	PopFrameCard.setLocationRelativeTo(null);
  		PopFrameCard.show();			
    }
    public void showCommCard(Player p)
    {
    	currentPlayer = p;
    	
    	System.out.println("Choice F");
    	
    	rand = (int) (Math.random() * 14);
    	    	
    	currentPopImageCard.setIcon(commList.get(rand).getIcon());
    	currentPopImageCard.setName(commList.get(rand).getName());
    	currentPopImageCard.repaint();
    	
    	currentEngine.commCardsAction(currentPlayer, currentPopImageCard.getName());
    	
    	bank.addHistory(currentPLAYERNUM, "Picks up a " + PieceName + " card");
    	bank.addHistory(currentPLAYERNUM, "Community Chest Card reads: " + currentPopImageCard.getName());
    	
    	PopFrameCard.pack(); 
    	PopFrameCard.setLocationRelativeTo(null);
  		PopFrameCard.show();			
    }
    
}