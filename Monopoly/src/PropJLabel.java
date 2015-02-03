/**
 * @(#)ModJLabel.java
 *
 *
 * @author 
 * @version 1.00 2010/2/14
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
import java.awt.Graphics;

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

import java.util.*;
import java.lang.Object;

public class PropJLabel extends JLabel
{
	// A set of the game pieces currently on this cell
	
	private Player myPlayer = null;
    
	public PropJLabel()
	{
		super();
	}
	public PropJLabel (ImageIcon e)
	{
		super(e);
	}	
	public void setPlayer(Player a)
	{
		myPlayer = a;
	}
	protected void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		
		int offsetx = 3;
		int offsety = 7;
		
		if(myPlayer!=null)	
		{	for (ImageIcon a : myPlayer.getPropertiesBoughtColor()) 
			{
				a.paintIcon(this, g, offsetx, offsety);
				offsetx= offsetx + 15;
			}
		}
	}
	
}
