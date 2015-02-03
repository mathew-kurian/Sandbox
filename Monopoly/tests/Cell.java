/**
 * @(#)Cell.java
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

public class Cell extends JLabel
{
	// A set of the game pieces currently on this cell
	
	private Set<GamePiece> gamePieces = new HashSet<GamePiece>();
	
	public Cell (ImageIcon e)
	{
		super(e);
	}
	public void addGamePiece(GamePiece piece)
	{
		gamePieces.add(piece);
	}

	public void removeGamePiece(GamePiece piece)
	{
		gamePieces.remove(piece);
	}

	protected void paintComponent(Graphics g)
	{
		super.paintComponent(g);
			for (GamePiece p : gamePieces) 
			p.getIcon().paintIcon(this, g, 0, 0);
			// or some more appropriate x,y location
	}
}
