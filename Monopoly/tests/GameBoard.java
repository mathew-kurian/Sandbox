/**
 * @(#)GameBoard.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/18
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

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;

public class GameBoard {
	
	public ArrayList<Player> playerList = new ArrayList<Player>();
	Scanner kb = null;
	public GameBoardUI theGameBoard = null;
    public ArrayList <ModJLabel> SouthEdgeArrayList = new ArrayList<ModJLabel>();
    
    public GameBoard() 
    {

    }    
    public void getAction(Player p)
    {
    	if(p.getCellIndex()==0)
    	{
    		p.addAccount(2000);
    	}
    	if(p.getCellIndex()==1)
    	{
    		
    	}
    	if(p.getCellIndex()==2)
    	{
    		
    	}
    
    	
    }
    	
    }
    
