/**
 * @(#)Player.java
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

public class Player {

	public String name;
	public int account;
	public ImageIcon icon;
	public int myCellIndex = 0;
	public int myNum = 0;
	public GamePiece trial;
	public ArrayList <Integer> PropertiesBought = new ArrayList<Integer>();
	private Set<ImageIcon>	PropertiesColorBought = new HashSet<ImageIcon>();
	
	public ImageIcon navy = new ImageIcon("images\\prop_color\\navy.png");
	public ImageIcon purple = new ImageIcon("images\\prop_color\\purple.png");
    public ImageIcon pink  = new ImageIcon("images\\prop_color\\pink.png");
    public ImageIcon orange  = new ImageIcon("images\\prop_color\\orange.png");
    public ImageIcon red  = new ImageIcon("images\\prop_color\\red.png");
    public ImageIcon yellow  = new ImageIcon("images\\prop_color\\yellow.png");
    public ImageIcon green   = new ImageIcon("images\\prop_color\\green.png");
    public ImageIcon blue   = new ImageIcon("images\\prop_color\\blue.png");
    
    public Player(String a, String iconName) 
    {
    	name=a;
    	trial = new GamePiece(iconName);
    	account = 30000;    
    }    
    public void setNum(int a)			{		myNum = a;									 }
    public int getNum()					{		return myNum;								 }
    public void setPiece(String a) 		{   	icon = new GamePiece(a).getImageIcon();  	 }
    public void addAccount(int a)  		{   	account = account + a;						 }
    public void subAccount(int a)  		{   	account = account - a;						 }
	public int getCellIndex() 	   		{ 		return myCellIndex;							 }
	public void setCellIndex(int index) { 		myCellIndex = index;						 }
	public GamePiece getGamePiece()  	{		return trial;					   			 }
	public int getAccount()  			{		return account;					   			 }
    public String getName()  			{		return name;					   			 }	
	public void addPropertiesBought(int a)					{		PropertiesBought.add(a);		 }
	public Set<ImageIcon> getPropertiesBoughtColor ()		{		return PropertiesColorBought;	 }	
	public void addPropertiesBoughtColor(String a)
	{		
		if(a.equalsIgnoreCase("navy"))		{		PropertiesColorBought.add(navy);			}
		if(a.equalsIgnoreCase("purple"))	{		PropertiesColorBought.add(purple);			}
		if(a.equalsIgnoreCase("pink"))		{		PropertiesColorBought.add(pink);			}
		if(a.equalsIgnoreCase("orange"))	{		PropertiesColorBought.add(orange);			}
		if(a.equalsIgnoreCase("red"))		{		PropertiesColorBought.add(red);				}
		if(a.equalsIgnoreCase("yellow"))	{		PropertiesColorBought.add(yellow);			}
		if(a.equalsIgnoreCase("green"))		{		PropertiesColorBought.add(green);			}
		if(a.equalsIgnoreCase("blue"))		{		PropertiesColorBought.add(blue);			}	 
	}
}