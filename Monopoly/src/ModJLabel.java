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

public class ModJLabel extends JLabel
{
	// A set of the game pieces currently on this cell
	
	private Set<GamePiece>	myPlayers = new HashSet<GamePiece>();
	private Set<ImageIcon>   boxGlow	 = new HashSet<ImageIcon>();
	
	public ImageIcon GlowIcon0 = new ImageIcon("images\\borders\\propertyborder0.png");
    public ImageIcon GlowIcon90 = new ImageIcon("images\\borders\\propertyborder90.png");
    public ImageIcon GlowIcon360 = new ImageIcon("images\\borders\\propertyborder360.png");
    
	public ModJLabel()
	{
		super();
	}
	public ModJLabel (ImageIcon e)
	{
		super(e);
	}
	public void addGamePiece(Player p)
	{
		myPlayers.add(p.getGamePiece());
		addGlow();		
	}
	public void removeGamePiece(Player p)
	{
		myPlayers.remove(p.getGamePiece());
		removeGlow();
	}
	public void addGlow()
	{	
		if(this.getIcon().getIconWidth()==78)													{		boxGlow.add(GlowIcon0);			}
		if((this.getIcon().getIconWidth()==110)&&(this.getIcon().getIconHeight()==78))			{		boxGlow.add(GlowIcon90);		}
		if(this.getIcon().getIconWidth()==110&&this.getIcon().getIconHeight()==110)				{		boxGlow.add(GlowIcon360);		}		
	}
	public void removeGlow()
	{
		if(this.getIcon().getIconWidth()==78)													{		boxGlow.remove(GlowIcon0);		}
		if((this.getIcon().getIconWidth()==110)&&(this.getIcon().getIconHeight()==78))			{		boxGlow.remove(GlowIcon90);		}
		if(this.getIcon().getIconWidth()==110&&this.getIcon().getIconHeight()==110)				{		boxGlow.remove(GlowIcon360);	}	
		
	}
	protected void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		int offset = 0;			
			for (ImageIcon p : boxGlow)
			{
				p.paintIcon(this, g, 0, 0);
			}
			for (GamePiece p : myPlayers) 
			{
				p.getImageIcon().paintIcon(this, g, 10 + offset, 10 + offset);
				offset += 10;
			}
	}
	
}
