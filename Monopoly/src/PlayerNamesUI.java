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
import java.awt.Font;
import java.awt.image.BufferedImage;
import java.awt.Graphics2D;

import javax.imageio.ImageIO;

import javax.swing.JFrame;
import javax.swing.JRootPane;
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
import javax.swing.DefaultListCellRenderer;
import javax.swing.text.MaskFormatter;

import java.io.PrintWriter;
import java.io.IOException;
import java.io.File;

import java.text.ParseException;

import java.util.*;

import java.lang.Object;

public class PlayerNamesUI {
	
	public JFrame PlayerFrame = new JFrame ("Options");	
	public TransparentBackground outerShell = new TransparentBackground(PlayerFrame);
	public ImagePanel innerShell = new ImagePanel("images\\playerui\\back.png");
	
	public ImagePanel innerChoice = new ImagePanel("images\\playerui\\chooseBack.png");
		
    public PrintWriter printMe = null;
    
    public ImageIcon pieceBorder = new ImageIcon("images\\borders\\gamepiece_border.png");
    
    public String Name1 = "Name Here        ";  
    
    public JFormattedTextField textArea1;
   	public JFormattedTextField textArea2;
    public JFormattedTextField textArea3;
    public JFormattedTextField textArea4;
    public JFormattedTextField textArea5;
    
    public String textArea1String;
    public String textArea2String;
    public String textArea3String;
    public String textArea4String;
    public String textArea5String;
    
    public DefaultListModel dlist = new DefaultListModel();
    
    public String player1Icon;
    public String player2Icon;
    public String player3Icon;
    public String player4Icon;
    public String player5Icon;
    
    public 	JButton PickImage1 = new JButton("Player 1 Pick Icon");
    public 	JButton PickImage2 = new JButton("Player 2 Pick Icon");
    public 	JButton PickImage3 = new JButton("Player 3 Pick Icon");
    public 	JButton PickImage4 = new JButton("Player 4 Pick Icon");
    public 	JButton PickImage5 = new JButton("Player 5 Pick Icon");
    
    public JLabel spacer1 = new JLabel(" ");
    	
    GamePiece IconList = new GamePiece();
    
    public ImageIcon [] IconArray = IconList.getFullChoices();
    
    public String [] playerNumChoices = {"2","3","4","5"};
    
    public HistoryUI hist;
    
    public ImageIcon findSize = new ImageIcon("images\\button\\CHECK.png");
    
    public JLabel newLabelofPlayer;
    	
    public JList IconChoices = new JList(dlist);    
    
    	public PlayerNamesUI(HistoryUI a)
    {
    	try{
    	textArea1 = new JFormattedTextField(new MaskFormatter("*****************"));
   		textArea2 = new JFormattedTextField(new MaskFormatter("*****************"));
    	textArea3 = new JFormattedTextField(new MaskFormatter("*****************"));
    	textArea4 = new JFormattedTextField(new MaskFormatter("*****************"));
    	textArea5 = new JFormattedTextField(new MaskFormatter("*****************"));
    	}
    	catch(ParseException wea)
    	{
    		System.out.println ("Error: Parse Exception caught");
    	}
    	
    	
    	hist = a;
    	
    	hist.addHistory("PlayerNamesUI Initialized Sucessfully");
    	hist.addHistory("\nREADME-----:\nChoose Number of Players\nEnter Names\nSet Icons\n*Player 1 is first and so on");
    	    	
    	innerShell.setLayout(null);    	    	
    
    	for (int i=0; i<IconArray.length; i++) 
    	{
    		dlist.add(i, IconArray[i]);
		}
				
    	IconChoices.setOpaque(false);    	
    	IconChoices.setVisibleRowCount(1);
    	IconChoices.setLayoutOrientation(JList.HORIZONTAL_WRAP);
    	
    	DefaultListCellRenderer renderer = (DefaultListCellRenderer)IconChoices.getCellRenderer();
		renderer.setOpaque(false);
       
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
		
		textArea1.setFont(new Font("Calibri", Font.BOLD, 14));
    	textArea2.setFont(new Font("Calibri", Font.BOLD, 14));
		textArea3.setFont(new Font("Calibri", Font.BOLD, 14));
		textArea4.setFont(new Font("Calibri", Font.BOLD, 14));
		textArea5.setFont(new Font("Calibri", Font.BOLD, 14));
		
		textArea1.setBounds(50, 180, 230 , 30);
		textArea2.setBounds(50, 230, 230 , 30);
		textArea3.setBounds(50, 280, 230 , 30);
		textArea4.setBounds(50, 330, 230 , 30);
		textArea5.setBounds(50, 380, 230 , 30);
				
		PickImage1.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {               
				JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));				
				
				startLabel.addMouseListener(new MouseListener() {
                
        			public void mouseClicked(MouseEvent e) {  			 
  		 			
        			}        
        			public void mouseExited(MouseEvent e) {
        
        			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					outerShell.refresh();
  					
       		 		}
       			 	public void mousePressed(MouseEvent e) {        
  					((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  					((JLabel)e.getSource()).repaint();
        			}
       		 		public void mouseReleased(MouseEvent e) {
        
       			 	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					player1Icon = getNameofIcon();                	
                	 
                	hideChoices();
                	outerShell.refresh();
                	
        			}
        			public void mouseEntered(MouseEvent e) {
       				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  					((JLabel)e.getSource()).repaint();
  			
       				}
       				
       				
       				
        			}
        			
        			
        			);               
            	
            	showChoices(startLabel);
            }
        });
        	
        	PickImage2.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {
                
				JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));
				startLabel.addMouseListener(new MouseListener() {
                
        			public void mouseClicked(MouseEvent e) {  			 
  		 		
        			}        
        			public void mouseExited(MouseEvent e) {
        
        			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
       		 		}
       			 	public void mousePressed(MouseEvent e) {        
  					((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  					((JLabel)e.getSource()).repaint();
        			}
       		 		public void mouseReleased(MouseEvent e) {
        
       			 	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					player2Icon = getNameofIcon();
                	 
                	hideChoices();
                	outerShell.refresh();
                	
        			}
        			public void mouseEntered(MouseEvent e) {
       				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  					((JLabel)e.getSource()).repaint();
  			
       				}
        			});
                
               showChoices(startLabel);
            }
        }); 
        	
        	PickImage3.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {
              
				JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));
				startLabel.addMouseListener(new MouseListener() {
                
        			public void mouseClicked(MouseEvent e) {  			 
  		 			
        			}        
        			public void mouseExited(MouseEvent e) {
        
        			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
       		 		}
       			 	public void mousePressed(MouseEvent e) {        
  					((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  					((JLabel)e.getSource()).repaint();
        			}
       		 		public void mouseReleased(MouseEvent e) {
        
       			 	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					player3Icon = getNameofIcon();
                	 
                	hideChoices();
                	outerShell.refresh();
        			}
        			public void mouseEntered(MouseEvent e) {
       				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  					((JLabel)e.getSource()).repaint();
  			
       				}
        			});
                
            showChoices(startLabel);
            }  
        	}); 
        
	       	PickImage4.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {
               
				JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));
				
				startLabel.addMouseListener(new MouseListener() {
                
        			public void mouseClicked(MouseEvent e) {  			 
  		 			
        			}        
        			public void mouseExited(MouseEvent e) {
        
        			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
       		 		}
       			 	public void mousePressed(MouseEvent e) {        
  					((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  					((JLabel)e.getSource()).repaint();
        			}
       		 		public void mouseReleased(MouseEvent e) {
        
       			 	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					player4Icon = getNameofIcon();
                	 
                	hideChoices();
                	outerShell.refresh();
                		
        			}
        			public void mouseEntered(MouseEvent e) {
       				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  					((JLabel)e.getSource()).repaint();
  			
       				}
        			});
                
        		showChoices(startLabel);
            }
        }); 
        	
           	PickImage5.addActionListener(new ActionListener() {
               
            public void actionPerformed(ActionEvent e)
            {
             
        		JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));
				startLabel.addMouseListener(new MouseListener() {
                
        			public void mouseClicked(MouseEvent e) {  			 
  		 			
        			}        
        			public void mouseExited(MouseEvent e) {
        
        			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
       		 		}
       			 	public void mousePressed(MouseEvent e) {        
  					((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  					((JLabel)e.getSource()).repaint();
        			}
       		 		public void mouseReleased(MouseEvent e) {
        
       			 	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  					((JLabel)e.getSource()).repaint();
  					
  					player5Icon = getNameofIcon();
                	 
                	hideChoices();
                	outerShell.refresh();
        			}
        			public void mouseEntered(MouseEvent e) {
       				((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  					((JLabel)e.getSource()).repaint();
  			
       				}
        			});
                
                showChoices(startLabel);
            }
        }); 
        
        PickImage1.setBounds(330, 180, 150 , 30);
		PickImage2.setBounds(330, 230, 150 , 30);
		PickImage3.setBounds(330, 280, 150 , 30);
		PickImage4.setBounds(330, 330, 150 , 30);
		PickImage5.setBounds(330, 380, 150 , 30);  
			
		PickImage1.setEnabled(true);
    	PickImage2.setEnabled(true);
		PickImage3.setEnabled(false);
    	PickImage4.setEnabled(false);
    	PickImage5.setEnabled(false);  				
        
        JLabel startLabel = new JLabel (new ImageIcon("images\\button\\CHECK.png"));
		startLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 
  		 		
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_click.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK.png")));
  			((JLabel)e.getSource()).repaint();
  			
  			printList();
  		 		
  		 		// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame = SwingUtilities.getRoot(c);
        		
  		 		// Hide the frame
        		frame.setVisible(false);
                
                //Make the GameBoardUI and Show                
      		    GameBoardUI theGameBoard = new GameBoardUI();    
      			theGameBoard.createAndShowGUI();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\CHECK_over.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });      
                
        JLabel quitLabel = new JLabel (new ImageIcon("images\\button\\QUIT2.png"));
		quitLabel.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			   		 				
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT2.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT_click2.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT2.png")));
  			((JLabel)e.getSource()).repaint();
  			
  			System.exit(0);
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\QUIT_over2.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        
        ImageIcon JustToFindSize = new ImageIcon("images\\button\\QUIT_over2.png");
		
		quitLabel.setBounds(475, 435, JustToFindSize.getIconWidth(), JustToFindSize.getIconHeight());
		startLabel.setBounds(275, 435, JustToFindSize.getIconWidth(), JustToFindSize.getIconHeight());
			
    	JComboBox playerNum = new JComboBox(playerNumChoices);
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
    				 				
    	    		PickImage1.setEnabled(true);
    				PickImage2.setEnabled(true);
    				PickImage3.setEnabled(false);
    				PickImage4.setEnabled(false);
    				PickImage5.setEnabled(false);		
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
    				
    				PickImage1.setEnabled(true);
    				PickImage2.setEnabled(true);
    				PickImage3.setEnabled(true);
    				PickImage4.setEnabled(false);
    				PickImage5.setEnabled(false);			    		
           		}
           		
        		if(playerNumberInt==4)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(true);
    				textArea4.setEnabled(true);
    				textArea5.setEnabled(false);
    		
    				textArea5.setValue(new String(Name1));	
    	
    				PickImage1.setEnabled(true);
    				PickImage2.setEnabled(true);
    				PickImage3.setEnabled(true);
    				PickImage4.setEnabled(true);
    				PickImage5.setEnabled(false);
        		}
        		if(playerNumberInt==5)
        		{
        			textArea1.setEnabled(true);
    				textArea2.setEnabled(true);
    				textArea3.setEnabled(true);
    				textArea4.setEnabled(true);
    				textArea5.setEnabled(true); 
    		
    		 		PickImage1.setEnabled(true);
    				PickImage2.setEnabled(true);
    				PickImage3.setEnabled(true);
    				PickImage4.setEnabled(true);
    				PickImage5.setEnabled(true);
    		
        		}
        		
            }
        });
        
        playerNum.setBounds(50,115, 426, 35);    
    	
    	JLabel playerImage = new JLabel(new ImageIcon("images\\playerui\\photo.png"));
    	
    	playerImage.setBounds(515,105, 320, 360);
    		
    	innerShell.add(playerNum);
    	innerShell.add(quitLabel);
    	innerShell.add(startLabel);
    	innerShell.add(textArea1);
    	innerShell.add(textArea2);
    	innerShell.add(textArea3);
    	innerShell.add(textArea4);
    	innerShell.add(textArea5);
    	innerShell.add(PickImage1);
    	innerShell.add(PickImage2);
    	innerShell.add(PickImage3);
    	innerShell.add(PickImage4);
    	innerShell.add(PickImage5);
    	innerShell.add(playerImage);
    	
    	innerShell.setOpaque(false);
    	
    	outerShell.add(innerShell);
    }
        public void createAndShowGUI()
    {
    	PlayerFrame.setSize(innerShell.getSize());
    	PlayerFrame.setContentPane(outerShell); // p from above, panel containing game board and text area
		PlayerFrame.setResizable(false);
		PlayerFrame.setUndecorated(true);
		PlayerFrame.setLocationRelativeTo(null);
		PlayerFrame.setVisible(true);
    }
    	public void printList()
    	{
    			try    							{    			printMe = new PrintWriter(new File("PlayerNamesUI.MKONE"));    																			}
    			catch(IOException e)    		{    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PlayerNamesUI.java)", "Warning", JOptionPane.WARNING_MESSAGE);    		}
    			
    			textArea1String=textArea1.getText();
    			textArea2String=textArea2.getText();
    			textArea3String=textArea3.getText();
    			textArea4String=textArea4.getText();
    			textArea5String=textArea5.getText();
    					
    				if(textArea1String.equals("Name Here        ")==false)  	{   printMe.println(textArea1String + "," + player1Icon);	}
    				if(textArea2String.equals("Name Here        ")==false)	{  	printMe.println(textArea2String + "," + player2Icon);	}
    				if(textArea3String.equals("Name Here        ")==false)	{   printMe.println(textArea3String + "," + player3Icon);	}
    				if(textArea4String.equals("Name Here        ")==false)	{   printMe.println(textArea4String + "," + player4Icon);	}
    				if(textArea5String.equals("Name Here        ")==false)	{  	printMe.println(textArea5String + "," + player5Icon); 	}
    				
    			printMe.close();
    	
    	}
    	public String getNameofIcon()
    	{
    		String selected = "Sun";
    		int index = 0;
    	
    		try {
    	 	if((IconChoices.getSelectedValue()).toString().equals("images\\pieces\\Remi.png"))   	 			
    	 		{    	 		selected = "remi";
    	 						index = IconChoices.getSelectedIndex();
            					dlist.remove(index);	  		 	}
    	 	else if((IconChoices.getSelectedValue()).toString().equals("images\\pieces\\basketball.png"))    	
    	 		{    	 		selected = "basketball";
    	 						index = IconChoices.getSelectedIndex();
            					dlist.remove(index);	 			}
    	 	else if((IconChoices.getSelectedValue()).toString().equals("images\\pieces\\iphone.png"))    	 	
    	 		{    	 		selected = "iphone";    	 	
    	 						index = IconChoices.getSelectedIndex();
            					dlist.remove(index);		            }
    	 	else if((IconChoices.getSelectedValue()).toString().equals("images\\pieces\\nba_logo.png"))    	 	
    	 		{    	 		selected = "logo";
    	 						index = IconChoices.getSelectedIndex();
            					dlist.remove(index);		 	    	 	}
    	 	else    	 																						
    	 		{    	 		index = IconChoices.getSelectedIndex();
            					dlist.remove(index);		 	 		
            	} 
    	 		}
    	 	
    		catch(NullPointerException e)   {	   	JOptionPane.showMessageDialog(null,"Null Pointer Exception\nPick an Image","Error",JOptionPane.ERROR_MESSAGE);    	}
    		
    		return selected;
    	
    	}    
    	public void showChoices(JLabel a)
    	{
    		newLabelofPlayer = a;
    		
    		newLabelofPlayer.setBounds(70, 140, findSize.getIconWidth(), findSize.getIconHeight());
    		
    		IconChoices.setBounds(24, 60, 310, 63);
    	
    		innerChoice.add(newLabelofPlayer);
    		innerChoice.add(IconChoices);
    		
    		innerChoice.setBounds(263, 195, innerChoice.getWidth(), innerChoice.getHeight());
    			
    		outerShell.add(innerChoice, new Integer(2));		
    		
    		outerShell.repaint();
    	}
    	public void hideChoices()
    	{
    		outerShell.remove(innerChoice);
    		outerShell.repaint();		
    	}
    
}


  
  
  