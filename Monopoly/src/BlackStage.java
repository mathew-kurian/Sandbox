/**
 * @(#)BackgroundUI.java
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

import javax.swing.JWindow;
import javax.swing.JFormattedTextField;
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

public class BlackStage {
	
	public JWindow backgroundFrame;
	
	public JPanel backgroundPanel; 
	
	public ImageIcon splashScreenImage = new ImageIcon("images\\backgrounds\\black.png");
	
	JLabel backgroundLabel = new JLabel(splashScreenImage);
	
    public BlackStage() {
    	
    	backgroundFrame = new JWindow(); 
    	
    	backgroundPanel = new JPanel();
    	
    	backgroundPanel.setLayout(new BorderLayout());
    	
    	backgroundPanel.add(backgroundLabel, BorderLayout.CENTER);
    	
    }
    public void createAndShowGUI()
    {
    	backgroundFrame.getContentPane().add(backgroundPanel);     
		backgroundFrame.pack();
		backgroundFrame.setLocationRelativeTo(null);
		backgroundFrame.setVisible(true);
    }   
    public void endGUI()
    {
    	backgroundFrame.setVisible(false);
    }
}