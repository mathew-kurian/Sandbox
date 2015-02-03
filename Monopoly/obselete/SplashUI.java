/**
 * @(#)SplashUI.java
 *
 *
 * @author 
 * @version 1.00 2010/3/18
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

public class SplashScreenUI {

		JFrame splashBoard = new JFrame("Welcome");
    	
    	public TransparentBackground clearPane = new TransparentBackground(splashBoard);
    	
    	public ImageIcon newGameNormal = new ImageIcon("images\\menu\\newgame_normal.png");
    	public ImageIcon newGameOver = new ImageIcon("images\\menu\\newgame_over.png");
    	public ImageIcon newGameClick = new ImageIcon("images\\menu\\newgame_click.png");
    	
    	public ImageIcon loadNormal = new ImageIcon("images\\menu\\load_save_normal.png");
    	public ImageIcon loadOver = new ImageIcon("images\\menu\\load_save_over.png");
    	public ImageIcon loadClick = new ImageIcon("images\\menu\\load_save_click.png");
    	
    	public ImageIcon helpNormal = new ImageIcon("images\\menu\\help_about_normal.png");
    	public ImageIcon helpOver = new ImageIcon("images\\menu\\help_about_over.png");
    	public ImageIcon helpClick = new ImageIcon("images\\menu\\help_about_click.png");
    
    	public ImageIcon quitNormal = new ImageIcon("images\\menu\\quit_normal.png");
    	public ImageIcon quitOver = new ImageIcon("images\\menu\\quit_over.png");
    	public ImageIcon quitClick = new ImageIcon("images\\menu\\quit_click.png");
    	
    	public JLabel newGame = new JLabel(newGameNormal);
    	public JLabel loadGame = new JLabel(loadNormal);
    	public JLabel helpGame = new JLabel(helpNormal);
    	public JLabel quitGame = new JLabel(quitNormal);
    	
    	Dimension dim = new Dimension();
    	
    	public HistoryUI hist;
    
    	public PlayerNamesUI PNameUI;
    	
    	public SplashScreenUI temp;
    
    	public HelpUI help;
    	
    public SplashScreenUI(HistoryUI a) {
    	
    	hist = a;
    	temp = this;
    	
    	dim.setSize(1210, 775);
    	
    	clearPane.setPreferredSize(dim);
    		
    	newGame.setBounds(383, 75, 781, 137);
    	loadGame.setBounds(273, 227, 781, 137);
    	helpGame.setBounds(157, 388, 781, 137);
    	quitGame.setBounds(137, 546, 781, 137);    	  	
    	
    	/************************************************************************************************/
    	newGame.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(newGameNormal);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(newGameClick);
  			((JLabel)e.getSource()).repaint();  			
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(newGameNormal);
  			((JLabel)e.getSource()).repaint();
  			
  				hist.addHistory("PlayerNamesUI instantiaed");
  			 	
  			 	//Make the PlayerNamesUI and Show
				PNameUI= new PlayerNamesUI(hist);
       			PNameUI.createAndShowGUI();
      			
      			// Get the Component
      			Component c = (Component)e.getSource();
      			
      			// Get the frame
        		Component frame = SwingUtilities.getRoot(c);
							
        		// Hide the frame
        		frame.setVisible(false);
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(newGameOver);
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        /*********************************************************************************/
        quitGame.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(quitNormal);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(quitClick);
  			((JLabel)e.getSource()).repaint();  			
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(quitNormal);
  			((JLabel)e.getSource()).repaint();
  			System.exit(0);
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(quitOver);
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        /********************************************************/
    	loadGame.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(loadNormal);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(loadClick);
  			((JLabel)e.getSource()).repaint();  			
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(loadNormal);
  			((JLabel)e.getSource()).repaint();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(loadOver);
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        /********************************************************/
    	helpGame.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			 			
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(helpNormal);
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(helpClick);
  			((JLabel)e.getSource()).repaint();  			
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(helpNormal);
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
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(helpOver);
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
        /********************************************************/  
        		
    	clearPane.add(newGame);
    	clearPane.add(loadGame);
    	clearPane.add(helpGame);
    	clearPane.add(quitGame);	
    	
    }
    
    
}